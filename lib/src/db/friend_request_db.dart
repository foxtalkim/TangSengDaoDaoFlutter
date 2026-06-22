// 好友请求本地持久化. 对齐 iOS WKFriendRequestDB.m (lim_friend_req 表) +
// Android `ApplyDB.java`. Schema 跟 iOS 1:1 抄, 字段定义见 [schema.dart].
//
// 同步策略 (跟 iOS WKContactsManager CMD handlers 对齐):
// - cold-start: home_shell `_loadSocialSnapshot` → `queryAll()` → 立即 emit
//   到 UI, 再 await server API (`socialGateway.loadSnapshot`) 校准 →
//   `upsertAll()` 写回 → setState 新数据. 用户感受 = cold-start 秒显上次
//   的好友请求列表 + badge.
// - CMD `friendRequest`: 单条 upsert (后续接 wukong_im_service CMD listener 时加)
// - accept/refuse: upsert 同一行 with new status (后续接)
// - logout: app database close() 释放连接, SDK uid 隔离 db 文件自动隔离
//   (跟 channel 表同款保护机制).
//
// **readed 列**: schema 有 readed INTEGER, 但当前实现一律写 0; runtime read
// state 仍走 home_shell `_readFriendRequestUids` SharedPreferences set
// (旧逻辑保持不变). 等后续 atomic 把 prefs read state 合并到这张表再启用.

import 'package:sqflite/sqflite.dart';

import 'database.dart';

class FriendRequestRow {
  const FriendRequestRow({
    required this.uid,
    required this.name,
    this.avatar = '',
    this.remark = '',
    this.token = '',
    this.status = 0,
    this.readed = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  final String uid;
  final String name;
  final String avatar;
  final String remark;
  final String token;

  /// 0=未处理 1=已通过 2=已拒绝
  final int status;

  /// 0=未读 1=已读
  final int readed;
  final String createdAt;
  final String updatedAt;

  Map<String, Object?> toMap() => {
    'uid': uid,
    'name': name,
    'avatar': avatar,
    'remark': remark,
    'token': token,
    'status': status,
    'readed': readed,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  factory FriendRequestRow.fromMap(Map<String, Object?> m) => FriendRequestRow(
    uid: (m['uid'] as String?) ?? '',
    name: (m['name'] as String?) ?? '',
    avatar: (m['avatar'] as String?) ?? '',
    remark: (m['remark'] as String?) ?? '',
    token: (m['token'] as String?) ?? '',
    status: (m['status'] as int?) ?? 0,
    readed: (m['readed'] as int?) ?? 0,
    createdAt: (m['created_at'] as String?) ?? '',
    updatedAt: (m['updated_at'] as String?) ?? '',
  );
}

class FriendRequestDb {
  FriendRequestDb._();
  static final FriendRequestDb instance = FriendRequestDb._();

  /// `select * from lim_friend_req order by created_at desc` — 对齐 iOS
  /// `WK_GETALL_FRIENDREQUEST_SQL`. created_at 为空字符串的行排到最后
  /// (lexicographic sort), 跟 server 返回顺序 fallback.
  Future<List<FriendRequestRow>> queryAll(
    String loginUid, {
    String serverScope = '',
  }) async {
    if (loginUid.isEmpty) return const [];
    final db = await FoxTalkDatabase.instance.open(
      serverAccountScope(serverScope, loginUid),
    );
    final rows = await db.rawQuery(
      'SELECT * FROM lim_friend_req ORDER BY created_at DESC',
    );
    return [for (final r in rows) FriendRequestRow.fromMap(r)];
  }

  /// 批量 upsert (insert or replace by uid). 对齐 iOS `addFriendRequest:`
  /// 行为 (先 delete same uid 再 insert). **不删除** server response 没列
  /// 出来的行 — 用 [replaceAll] 实现 server snapshot 全量覆盖.
  Future<void> upsertAll(
    String loginUid,
    List<FriendRequestRow> rows, {
    String serverScope = '',
  }) async {
    if (loginUid.isEmpty || rows.isEmpty) return;
    final db = await FoxTalkDatabase.instance.open(
      serverAccountScope(serverScope, loginUid),
    );
    final batch = db.batch();
    for (final row in rows) {
      if (row.uid.isEmpty) continue;
      batch.insert(
        'lim_friend_req',
        row.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 全量替换: transaction 先 delete 整表 再 batch insert. server 是单一真相
  /// 源时用这个 (`_loadSocialSnapshot` 拿到 server 的 friendRequests list 全
  /// 覆盖). 跟 [upsertAll] 区别: upsert 不删除 server 没列出来的行, 会留下
  ///
  /// 空 list 也会执行 (清空整表) — 对齐 server 返回空 = 没有 pending 请求
  /// 的语义.
  Future<void> replaceAll(
    String loginUid,
    List<FriendRequestRow> rows, {
    String serverScope = '',
  }) async {
    if (loginUid.isEmpty) return;
    final db = await FoxTalkDatabase.instance.open(
      serverAccountScope(serverScope, loginUid),
    );
    await db.transaction((txn) async {
      await txn.delete('lim_friend_req');
      if (rows.isEmpty) return;
      final batch = txn.batch();
      for (final row in rows) {
        if (row.uid.isEmpty) continue;
        batch.insert(
          'lim_friend_req',
          row.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// 单行 upsert. CMD `friendRequest` 增量到来时用 (atomic 4 暂未接,
  /// 后续 wukong_im_service CMD listener 加).
  Future<void> upsert(
    String loginUid,
    FriendRequestRow row, {
    String serverScope = '',
  }) async {
    if (loginUid.isEmpty || row.uid.isEmpty) return;
    final db = await FoxTalkDatabase.instance.open(
      serverAccountScope(serverScope, loginUid),
    );
    await db.insert(
      'lim_friend_req',
      row.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 删除单行. iOS deleteFriendRequest: 同款.
  Future<void> delete(
    String loginUid,
    String uid, {
    String serverScope = '',
  }) async {
    if (loginUid.isEmpty || uid.isEmpty) return;
    final db = await FoxTalkDatabase.instance.open(
      serverAccountScope(serverScope, loginUid),
    );
    await db.delete('lim_friend_req', where: 'uid = ?', whereArgs: [uid]);
  }

  /// 清空整表. logout 调; SDK channel 表是 uid 隔离 db file 自然隔离,
  /// 这边 app db 也是按 uid 文件名隔离 (`foxtalk_<uid>.db`), 严格不需要手清,
  /// 但留这 API 给 future 用 (例: 切账号时手动 reset).
  Future<void> clear(String loginUid, {String serverScope = ''}) async {
    if (loginUid.isEmpty) return;
    final db = await FoxTalkDatabase.instance.open(
      serverAccountScope(serverScope, loginUid),
    );
    await db.delete('lim_friend_req');
  }
}
