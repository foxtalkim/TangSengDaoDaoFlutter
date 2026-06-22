// 应用层 sqflite 单例.
//
// 跟 wukongimfluttersdk SDK 的 `wk_<uid>.db` 独立 — 这份是应用层 data
// (好友请求 / 敏感词缓存 / etc), iOS 对应 WKKitDB. SDK 的 IM 核心数据
// (message / conversation / channel / member / reaction / reminder) 都
// 在 SDK db, 不要往这里加.
//
// 路径: `<sandbox>/databases/foxtalk_<server+uid>.db`. 按 server + uid
// 隔离, 避免切到其他 TS DaoDao 服务器且 uid 相同时串台.
//
// 单例: 进程内 first call open() → openDatabase + 缓存; 之后复用. logout
// 调 close() 释放连接 (db 文件保留, 下次同 uid 登录直接命中本地缓存).
// 切到不同 uid → 自动 close 旧 + open 新 file.

import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'schema.dart';

class FoxTalkDatabase {
  FoxTalkDatabase._();
  static final FoxTalkDatabase instance = FoxTalkDatabase._();

  Database? _db;
  String? _currentScope;

  /// 打开当前账号 scope 的 db. 多次调用 idempotent. scope 变化 → close 旧 + open 新.
  Future<Database> open(String accountScope) async {
    if (accountScope.isEmpty) {
      throw StateError('FoxTalkDatabase.open requires non-empty account scope');
    }
    if (_db != null && _currentScope == accountScope) {
      return _db!;
    }
    if (_db != null) {
      await _db!.close();
      _db = null;
      _currentScope = null;
    }
    final dbDir = await getDatabasesPath();
    final path = p.join(dbDir, 'foxtalk_$accountScope.db');
    _db = await openDatabase(
      path,
      version: schemaVersion,
      onCreate: (db, _) async {
        for (final sql in schemaCreate) {
          await db.execute(sql);
        }
      },
      // onUpgrade: 后续 schema 改动时加 migration script.
    );
    _currentScope = accountScope;
    return _db!;
  }

  /// 当前账号 scope (null = 没 open 过).
  String? get currentUid => _currentScope;

  /// logout / disconnect 调. 关连接 (db 文件保留, 下次同 uid 命中本地数据).
  Future<void> close() async {
    final db = _db;
    if (db == null) return;
    _db = null;
    _currentScope = null;
    await db.close();
  }
}

String serverAccountScope(String serverScope, String uid) {
  final normalizedUid = _safeScopePart(uid);
  final normalizedServer = _safeScopePart(serverScope);
  if (normalizedServer.isEmpty) return normalizedUid;
  return '${normalizedServer}__$normalizedUid';
}

String _safeScopePart(String value) {
  return value.trim().replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_');
}
