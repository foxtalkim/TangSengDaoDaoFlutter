// 应用层 sqflite 所有 CREATE TABLE 语句.
//
// 命名约定 (persistence-spec §2): 表名 / 字段名 snake_case, 跟 iOS WKxxxDB
// 完全一致, 后续诊断 grep 能对得上. 新建表前先 grep iOS schema 抄字段.
//
// `openDatabase` onCreate 顺序 execute. 加新表 → append. 改字段 → 加 version
// 号 + migration (lib/src/db/migration.dart, 暂未建).

/// 所有 CREATE TABLE 语句, 启动时 onCreate 一次性 execute.
const List<String> schemaCreate = [
  // 好友请求 — iOS WKFriendRequestDB.m 同名 schema.
  // 字段对照 iOS:
  //   uid TEXT PK             — 申请人 uid
  //   name TEXT               — 申请人昵称
  //   avatar TEXT             — 申请人头像 (可为空, 空走 users/<uid>/avatar)
  //   remark TEXT             — 申请附言 (Flutter ChatFriendRequest.message)
  //   token TEXT              — 申请 token (后续 accept/refuse 用)
  //   status INTEGER          — 0=未处理 1=已通过 2=已拒绝
  //   readed INTEGER          — 0=未读 1=已读 (badge 计数)
  //   created_at TEXT         — 申请时间
  //   updated_at TEXT         — 状态变更时间
  '''
  CREATE TABLE lim_friend_req (
    uid TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    avatar TEXT NOT NULL DEFAULT '',
    remark TEXT NOT NULL DEFAULT '',
    token TEXT NOT NULL DEFAULT '',
    status INTEGER NOT NULL DEFAULT 0,
    readed INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT '',
    updated_at TEXT NOT NULL DEFAULT ''
  )
  ''',
];

/// 当前 db schema 版本. schema.dart 改动需要同步 +1 并加 migration.
const int schemaVersion = 1;
