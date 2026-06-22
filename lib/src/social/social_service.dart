import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../db/database.dart';
import '../ui/identity_display.dart';

abstract interface class ChatSocialGateway {
  Future<ChatSocialSnapshot> loadSnapshot();

  /// Look up a user by keyword (FoxTalk ID / 手机号).
  ///
  /// Backend `/user/search` returns `{exist: 0|1, data: {uid,name,vercode}}`
  /// — a single-object shape rather than a list. The implementation
  /// normalises it into a `ChatUserSearchResult` so the UI layer can
  /// distinguish "no such user" from "found one" without poking at
  /// raw JSON.
  Future<ChatUserSearchResult> searchUser(String keyword);

  Future<ChatGlobalSearchResult> searchGlobal({
    required String keyword,
    int onlyMessage = 0,
    String channelId = '',
    int channelType = 0,
    String fromUid = '',
    String topic = '',
    int page = 1,
    int limit = 20,
    int startTime = 0,
    int endTime = 0,
    List<int> contentTypes = const [1, 8],
  });

  Future<void> grantWebLogin(String authCode);

  Future<ChatScanResult> resolveScanResult(String content);

  Future<ChatGroup?> loadPublicGroupInfo(String groupNo);

  /// 读某 bot 的命令列表 (robot_menu). 命令公开 (任何登录用户可读, 跟 TG bot
  /// 命令一致). 聊天页命令菜单 + bot 详情回显都用. `GET /v1/bots/<username>/commands`.
  Future<List<BotCommand>> botCommands(String username);

  /// 当前用户创建的 bot runtime 状态. 基础聊天页只需要知道对方 bot 是否可用,
  /// 所以放在 gateway, 避免聊天基础模块硬依赖 bot 管理页面实现.
  Future<Map<String, BotRuntimeStatus>> botRuntimeStatuses();

  Future<void> scanJoinGroup({
    required String groupNo,
    required String authCode,
  });

  Future<void> quitPcLogin();

  Future<void> applyFriend({
    required String uid,
    String remark = '',
    String vercode = '',
  });

  Future<void> acceptFriendRequest(String token);

  Future<void> refuseFriendRequest(String uid);

  Future<void> deleteFriendRequest(String uid);

  Future<void> updateFriendRemark({
    required String uid,
    required String remark,
  });

  Future<void> deleteFriend(String uid);

  Future<List<ChatContact>> loadBlacklist();

  Future<void> addUserBlacklist(String uid);

  Future<void> removeUserBlacklist(String uid);

  Future<ChatGroup?> createGroup(
    List<String> memberUids, {
    String name = '',
    List<String> memberNames = const [],
  });

  Future<List<ChatContact>> loadGroupMembers(String groupNo);

  Future<List<ChatContact>> loadDeletedGroupMembers(String groupNo);

  /// 拉群黑名单成员. server `GET /groups/<no>/members` 的 SQL 硬写死了
  /// `status=1` (Normal), 拿不到 status=2 (Blacklist) 的人. 用 membersync
  /// 接口拿所有 status 的 members 然后客户端过滤 status==2.
  /// 对齐 iOS WKGroupBlacklistVM (m:22) `getBlacklistMembersWithChannel:`.
  Future<List<ChatContact>> loadGroupBlacklist(String groupNo);

  Future<void> addGroupMembers({
    required String groupNo,
    required List<String> memberUids,
  });

  Future<void> inviteGroupMembers({
    required String groupNo,
    required List<String> memberUids,
    String remark = '',
  });

  Future<void> removeGroupMembers({
    required String groupNo,
    required List<String> memberUids,
  });

  Future<void> addGroupManagers({
    required String groupNo,
    required List<String> memberUids,
  });

  Future<void> removeGroupManagers({
    required String groupNo,
    required List<String> memberUids,
  });

  Future<void> transferGroupOwner({
    required String groupNo,
    required String uid,
  });

  Future<void> setGroupForbidden({
    required String groupNo,
    required bool enabled,
  });

  Future<List<ChatGroupForbiddenTime>> loadGroupForbiddenTimes();

  Future<void> forbidGroupMember({
    required String groupNo,
    required String memberUid,
    required int key,
  });

  Future<void> unforbidGroupMember({
    required String groupNo,
    required String memberUid,
  });

  Future<void> disbandGroup(String groupNo);

  Future<String> loadGroupInviteConfirmUrl({
    required String groupNo,
    required String inviteNo,
  });

  Future<void> exitGroup(String groupNo);

  Future<void> updateGroupSetting({
    required String groupNo,
    required Map<String, dynamic> setting,
  });

  Future<void> updateGroupInfo({
    required String groupNo,
    required String key,
    required String value,
  });

  Future<void> updateGroupMemberRemark({
    required String groupNo,
    required String memberUid,
    required String remark,
  });

  Future<void> addGroupBlacklist({
    required String groupNo,
    required List<String> memberUids,
  });

  Future<void> removeGroupBlacklist({
    required String groupNo,
    required List<String> memberUids,
  });

  Future<List<ChatLabel>> loadLabels();

  Future<void> createLabel({
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  });

  Future<void> updateLabel({
    required String id,
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  });

  Future<void> deleteLabel(String id);

  Future<List<ChatFavorite>> loadFavorites();

  Future<List<ChatAppModule>> loadAppModules();

  Future<List<ChatBackground>> loadChatBackgrounds();

  Future<ChatAppVersion?> loadAppVersion({
    required String os,
    required String currentVersion,
  });

  Future<void> addFavorite({
    required String uniqueKey,
    required String authorUid,
    required String authorName,
    required int type,
    required String content,
  });

  Future<void> deleteFavorite(String id);

  Future<void> updateFavorite({
    required String id,
    required Map<String, dynamic> payload,
  });

  Future<ChatOnlineStatus> loadOnlineStatus();

  Future<List<ChatUserOnlineState>> loadOnlineForUids(List<String> uids);

  Future<List<ChatGroupMember>> syncGroupMembers({
    required String groupNo,
    int version = 0,
  });

  Future<ChatContact?> getUserInfo(String uid);

  Future<List<ChatContact>> searchFriends(String keyword);

  Future<int> getRedDot(String category);

  Future<void> clearRedDot(String category);

  Future<List<ChatContact>> loadCustomerServices();

  Future<List<Map<String, dynamic>>> loadAppVersionList();

  Future<List<Map<String, dynamic>>> loadCountries();

  Future<String> requestPcLoginUuid();

  Future<Map<String, dynamic>> getPcLoginStatus(String loginUuid);

  Future<List<ChatChatFolder>> loadChatFolders();

  Future<ChatChatFolder?> loadChatFolderDetail(String id);

  Future<void> createChatFolder({
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  });

  Future<void> updateChatFolder({
    required String id,
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  });

  Future<void> deleteChatFolder(String id);

  Future<ChatLabel?> loadLabelDetail(String id);

  Future<void> registerDeviceToken({
    required String token,
    required String deviceType,
    required String bundleId,
  });

  /// iOS PKPushRegistry .voIP token — 跟 alert APNS token 是两条独立 token,
  /// 单独上报 (server 端 Redis hash 加 voip_device_token 字段). RTC invite
  /// 触发时, server 给 alert + voip 各发一条 push: alert 走通知栏兜底,
  /// voip 走 PKPushRegistry didReceiveIncomingPushWith 唤起 CallKit 全屏.
  Future<void> registerVoipDeviceToken(String voipToken);

  Future<void> unregisterDeviceToken();

  Future<void> updateBadge(int badge);

  Future<List<ChatDevice>> loadDevices();

  Future<void> deleteDevice(String deviceId);

  Future<void> updateCurrentUserSetting({
    required String key,
    required int value,
  });

  Future<void> updateCurrentUserInfo({
    required String key,
    required String value,
  });

  Future<void> updateUserSetting({
    required String uid,
    required Map<String, dynamic> setting,
  });

  Future<void> uploadCurrentUserAvatar({
    required String uid,
    required String filePath,
  });

  Future<void> uploadGroupAvatar({
    required String groupNo,
    required String filePath,
  });

  Future<ChatGroup?> loadGroupInfo(String groupNo);

  Future<void> sendDestroyAccountCode();

  Future<void> destroyAccount(String code);

  Future<ChatQrCode> loadUserQrCode();

  Future<ChatQrCode> loadGroupQrCode(String groupNo);

  Future<ChatInviteCode> loadInviteCode();

  Future<void> toggleInviteCodeStatus();

  Future<void> sendPasswordResetCode({
    required String phone,
    String zone = '0086',
  });

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
    String zone = '0086',
  });

  Future<void> uploadPhoneContacts(List<ChatPhoneContact> contacts);

  Future<List<ChatPhoneContact>> loadPhoneContacts();

  Future<List<ChatReportCategory>> loadReportCategories();

  Future<void> submitReport({
    required String channelId,
    required int channelType,
    required String categoryNo,
    required String remark,
    List<String> imgs = const [],
  });

  Future<List<ChatMoment>> loadMoments({
    int pageIndex = 1,
    int pageSize = 20,
    String uid = '',
  });

  Future<void> publishMoment({
    required String text,
    String privacyType = 'public',
    List<String> imgs = const [],
    List<String> privacyUids = const [],
    List<String> remindUids = const [],
    String videoPath = '',
    String videoCoverPath = '',
    String address = '',
    String longitude = '',
    String latitude = '',
  });

  Future<ChatMoment> loadMomentDetail(String momentNo);

  /// 上传朋友圈封面图. 对齐 iOS WKMomentVM.m:310-326:
  ///   1. GET /file/upload?type=momentcover → 返 {url: upload URL}
  ///   2. POST 二进制到 upload URL
  /// 成功后服务端缓存新封面, 下次 `GET /moment/cover?uid=<self>` 返新图.
  Future<void> uploadMomentCover(String localPath);

  /// 上传朋友圈图片. 返回服务端 relative path (`/moment/.../xxx.jpg`),
  /// 调用方需把它放进 publishMoment(imgs: [...]) 提交.
  /// 对齐 iOS WKMomentFileUploadTask (`m:147` + `m:135`).
  ///   1. `GET /file/upload?type=moment&path=<hint>` → {url: ...}
  ///   2. POST 二进制
  ///   3. response.path = 服务端实际存储路径 (relative)
  Future<String> uploadMomentImage(String localPath, {String? uid});

  Future<List<ChatStickerPack>> loadStickerStore({
    int pageIndex = 1,
    int pageSize = 20,
  });

  Future<ChatStickerPackDetail> loadStickerDetail(String category);

  Future<List<ChatStickerPack>> loadStickerCategories();

  Future<List<ChatSticker>> loadCustomStickers();

  Future<List<ChatSticker>> searchStickers({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  });

  Future<void> addStickerCategory(String category);

  Future<void> removeStickerCategory(String category);

  Future<void> addCustomSticker(ChatSticker sticker);

  /// 上传单张本地图作为自定义贴纸. 对齐 iOS WKStickerCollectionVC m:299-370:
  /// 1. GET /file/upload?type=sticker → {url}
  /// 2. POST 二进制到 url → server path
  /// 3. POST sticker/user {path, width, height, ...} (addCustomSticker)
  /// 返回服务端 sticker path (相对 URL).
  Future<String> uploadCustomStickerImage(
    String localPath, {
    int width = 0,
    int height = 0,
  });

  Future<void> deleteCustomStickers(List<String> paths);

  Future<void> moveCustomStickersToFront(List<String> paths);

  Future<void> reorderStickerCategories(List<String> categories);

  Future<void> likeMoment(String momentNo);

  Future<void> unlikeMoment(String momentNo);

  Future<ChatMomentComment> commentMoment({
    required String momentNo,
    required String content,
    String replyCommentId = '',
    String replyUid = '',
    String replyName = '',
  });

  Future<void> deleteMomentComment({
    required String momentNo,
    required String commentId,
  });

  Future<void> deleteMoment(String momentNo);

  Future<ChatMomentSetting> loadMomentSetting(String uid);

  Future<void> setMomentHideMy({required String uid, required bool enabled});

  Future<void> setMomentHideHis({required String uid, required bool enabled});

  Future<void> setChatPassword({
    required String uid,
    required String loginPassword,
    required String chatPassword,
  });

  Future<void> setLockScreenPassword({
    required String uid,
    required String password,
  });

  Future<void> updateLockAfterMinute(int minute);

  Future<void> closeLockScreenPassword();
}

class ChatSocialSnapshot {
  const ChatSocialSnapshot({
    this.contacts = const [],
    this.groups = const [],
    this.friendRequests = const [],
  });

  final List<ChatContact> contacts;
  final List<ChatGroup> groups;
  final List<ChatFriendRequest> friendRequests;
}

/// 一条 bot 命令 (Telegram bot command 同语义). type 固定 none — 点了发
/// "/cmd" 文本给 bot。cmd 含前导 /, remark 是给用户看的描述。
class BotCommand {
  const BotCommand({required this.cmd, this.remark = ''});

  final String cmd;
  final String remark;

  factory BotCommand.fromJson(Map<String, dynamic> json) {
    return BotCommand(
      cmd: (json['cmd'] ?? '').toString(),
      remark: (json['remark'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'cmd': cmd, 'remark': remark};
}

enum BotRuntimeState { offline, connecting, ready, busy, queued, error }

class BotRuntimeStatus {
  const BotRuntimeStatus({
    required this.robotId,
    this.status = BotRuntimeState.offline,
    this.bridgeId = '',
    this.cliType = '',
    this.cwd = '',
    this.queueLen = 0,
    this.activeChannelId = '',
    this.activeChannelType = 0,
    this.lastError = '',
    this.lastSeenAt = 0,
  });

  final String robotId;
  final BotRuntimeState status;
  final String bridgeId;
  final String cliType;
  final String cwd;
  final int queueLen;
  final String activeChannelId;
  final int activeChannelType;
  final String lastError;
  final int lastSeenAt;

  bool get available =>
      status == BotRuntimeState.ready ||
      status == BotRuntimeState.busy ||
      status == BotRuntimeState.queued;

  factory BotRuntimeStatus.offline(String robotId) {
    return BotRuntimeStatus(robotId: robotId);
  }

  factory BotRuntimeStatus.fromJson(Map<String, dynamic> json) {
    final robotId = _botStr(json['robot_id'] ?? json['robotId']);
    return BotRuntimeStatus(
      robotId: robotId,
      status: _botRuntimeState(_botStr(json['status'])),
      bridgeId: _botStr(json['bridge_id'] ?? json['bridgeId']),
      cliType: _botStr(json['cli_type'] ?? json['cliType']),
      cwd: _botStr(json['cwd']),
      queueLen: _botInt(json['queue_len'] ?? json['queueLen']),
      activeChannelId: _botStr(
        json['active_channel_id'] ?? json['activeChannelId'],
      ),
      activeChannelType: _botInt(
        json['active_channel_type'] ?? json['activeChannelType'],
      ),
      lastError: _botStr(json['last_error'] ?? json['lastError']),
      lastSeenAt: _botInt(json['last_seen_at'] ?? json['lastSeenAt']),
    );
  }
}

Map<String, BotRuntimeStatus> parseBotRuntimeStatuses(Object? data) {
  if (data is! List) return const {};
  final result = <String, BotRuntimeStatus>{};
  for (final entry in data.whereType<Map>()) {
    final status = BotRuntimeStatus.fromJson(Map<String, dynamic>.from(entry));
    if (status.robotId.isNotEmpty) {
      result[status.robotId] = status;
    }
  }
  return result;
}

String _botStr(Object? value) => value?.toString() ?? '';

int _botInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

BotRuntimeState _botRuntimeState(String value) {
  switch (value) {
    case 'connecting':
      return BotRuntimeState.connecting;
    case 'ready':
      return BotRuntimeState.ready;
    case 'busy':
      return BotRuntimeState.busy;
    case 'queued':
      return BotRuntimeState.queued;
    case 'error':
      return BotRuntimeState.error;
    default:
      return BotRuntimeState.offline;
  }
}

class ChatContact {
  const ChatContact({
    required this.uid,
    required this.name,
    this.username = '',
    this.remark = '',
    this.subtitle = '',
    this.sourceDescription = '',
    this.avatar = '',
    this.online = false,
    this.role = 0,
    this.status = 1,
    this.vercode = '',
    this.version = 0,
    this.isDeleted = false,
    this.isRobot = false,
    this.category = '',
  });

  final String uid;
  final String name;

  /// 服务端 user.username. 跟 name 的区别: name 是显示名 (可改, 多语言), username
  /// 是机器标识 (唯一, 不可改, 用于 @mention 跳转 / API 查找). BotFather 创建 bot
  /// 时回包用 `@<username>`, 客户端 chat_mention_logic 走 candidate label 匹配,
  /// candidates 含 username 才能找到 bot 跳转 (否则点击 @bot_xxx 显示"未找到").
  final String username;

  final String remark;
  final String subtitle;
  final String sourceDescription;
  final String avatar;
  final bool online;

  /// Group membership role: 0 = member, 1 = owner, 2 = manager.
  /// Outside group contexts the value is 0 and ignored.
  final int role;

  /// Friend relation status from server user detail: 1 = normal, 2 = blacklisted.
  final int status;

  /// Per-stranger verification code returned by the server's
  /// `/user/search` response (or surfaced by qr-card scans). Required
  /// by `friend/apply` so the backend can verify the apply originated
  /// from a legitimate name-card view. Empty for already-friend
  /// contacts (we don't need it) and for synthesized rows where the
  /// server response didn't include one.
  final String vercode;

  /// `friend/sync` row version. Monotonically increasing per row,
  /// used as `version=` query param on the next sync so the server
  /// returns only delta. Mirrors iOS WKContactsSync caching the
  /// last `version` from `contacts.lastObject`.
  final int version;

  /// Tombstone flag from `friend/sync` (`is_deleted=1` means the
  /// row was removed on another device). Never persisted to cache;
  /// we drop the row instead.
  final bool isDeleted;

  /// 服务端 user.robot=1 标记. true 表示这是个 bot (机器人, AI 或系统).
  /// 渲染层结合 category 决定 badge:
  ///   isRobot && category == 'system'  → "系统" badge (FileHelper/BotFather/SystemUID)
  ///   isRobot && category != 'system'  → "AI" badge   (用户通过 BotFather 创建的)
  ///   !isRobot                          → 无 badge     (真人)
  final bool isRobot;

  /// 服务端 user.category. 'system' = 系统账号; '' (空) = 普通用户或 AI bot.
  /// 跟 isRobot 配合判断 badge 类型.
  final String category;

  String get displayName => remark.isEmpty ? name : remark;

  ChatContact copyWith({
    String? name,
    String? username,
    String? remark,
    String? subtitle,
    String? sourceDescription,
    String? avatar,
    bool? online,
    int? role,
    int? status,
    String? vercode,
    int? version,
    bool? isDeleted,
    bool? isRobot,
    String? category,
  }) {
    return ChatContact(
      uid: uid,
      name: name ?? this.name,
      username: username ?? this.username,
      remark: remark ?? this.remark,
      subtitle: subtitle ?? this.subtitle,
      sourceDescription: sourceDescription ?? this.sourceDescription,
      avatar: avatar ?? this.avatar,
      online: online ?? this.online,
      role: role ?? this.role,
      status: status ?? this.status,
      vercode: vercode ?? this.vercode,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      isRobot: isRobot ?? this.isRobot,
      category: category ?? this.category,
    );
  }

  /// Cache-only payload shape; mirrors the keys `_contactFromJson`
  /// reads so a cache round-trip is byte-stable with what the server
  /// returns. We persist this and replay through the same parser on
  /// load to avoid drift if the parser gains fields.
  Map<String, dynamic> toCacheJson() => <String, dynamic>{
    'uid': uid,
    'name': name,
    'username': username,
    'remark': remark,
    'short_no': subtitle,
    'source_desc': sourceDescription,
    'avatar': avatar,
    'online': online ? 1 : 0,
    'role': role,
    'status': status,
    'vercode': vercode,
    'version': version,
    'robot': isRobot ? 1 : 0,
    'category': category,
  };
}

/// Mirrors the iOS WKUserSearchResp shape returned by `/user/search`:
/// `{exist: 0|1, data: {uid,name,vercode}}`. The Flutter side needs
/// both pieces — `exist=false` is the cue to show "用户不存在",
/// `exist=true` carries the data into the name-card page so the apply
/// flow has a `vercode` to send.
class ChatUserSearchResult {
  const ChatUserSearchResult({required this.exist, this.contact});

  /// True when the keyword resolved to a known user. Maps directly to
  /// the server's `exist` flag (0/1).
  final bool exist;

  /// User data when `exist == true`. Null when not found.
  final ChatContact? contact;
}

class ChatGroup {
  const ChatGroup({
    required this.groupNo,
    required this.name,
    required this.memberCount,
    this.notice = '',
    this.muted = false,
    this.saved = true,
    this.inviteConfirm = false,
    this.forbidden = false,
    this.forbiddenAddFriend = false,
    this.allowViewHistoryMsg = true,
    this.allowMemberPinnedMessage = false,
  });

  final String groupNo;
  final String name;
  final int memberCount;
  final String notice;
  final bool muted;
  final bool saved;
  final bool inviteConfirm;
  final bool forbidden;
  final bool forbiddenAddFriend;
  final bool allowViewHistoryMsg;
  final bool allowMemberPinnedMessage;
}

class ChatGroupForbiddenTime {
  const ChatGroupForbiddenTime({required this.text, required this.key});

  final String text;
  final int key;
}

class ChatGlobalSearchResult {
  const ChatGlobalSearchResult({
    this.friends = const [],
    this.groups = const [],
    this.messages = const [],
  });

  final List<ChatGlobalChannel> friends;
  final List<ChatGlobalChannel> groups;
  final List<ChatGlobalMessage> messages;
}

class ChatGlobalChannel {
  const ChatGlobalChannel({
    required this.channelId,
    required this.channelType,
    required this.channelName,
    this.channelRemark = '',
  });

  final String channelId;
  final int channelType;
  final String channelName;
  final String channelRemark;
}

class ChatGlobalMessage {
  const ChatGlobalMessage({
    required this.messageId,
    required this.clientMsgNo,
    required this.fromUid,
    required this.timestamp,
    required this.text,
    required this.channel,
    required this.fromChannel,
    this.contentType = 0,
    this.messageSeq = 0,
    this.payload = const {},
  });

  final String messageId;
  final String clientMsgNo;
  final String fromUid;
  final int timestamp;

  /// 命中消息文本 — 服务端可能内嵌 <mark>...</mark> 高亮关键字, 调用方
  /// (_SearchMessageTile) 自己解析渲染, 这里不剥离.
  final String text;
  final ChatGlobalChannel channel;
  final ChatGlobalChannel fromChannel;
  final int contentType;

  /// 消息在该 channel 内的 sequence (server 端唯一递增). 跳转到搜索结果
  /// 需要它配合 SDK getOrderSeq 计算 orderSeq.
  final int messageSeq;
  final Map<String, dynamic> payload;
}

class ChatFriendRequest {
  const ChatFriendRequest({
    required this.uid,
    required this.token,
    required this.name,
    required this.message,
    this.accepted = false,
    this.refused = false,
  });

  final String uid;
  final String token;
  final String name;
  final String message;
  // 服务端 friend_apply_record.status:
  //   0 = 未处理   1 = 已通过   2 = 已拒绝
  final bool accepted;
  final bool refused;
}

class ChatLabel {
  const ChatLabel({
    required this.id,
    required this.name,
    this.memberUids = const [],
    this.groupNos = const [],
    this.count = 0,
  });

  final String id;
  final String name;
  final List<String> memberUids;
  final List<String> groupNos;
  final int count;
}

class ChatFavorite {
  const ChatFavorite({
    required this.id,
    required this.authorName,
    required this.content,
    this.authorUid = '',
    this.type = 0,
    this.createdAt = '',
  });

  final String id;
  final String authorUid;
  final String authorName;
  final int type;
  final String content;
  final String createdAt;
}

class ChatStickerPack {
  const ChatStickerPack({
    required this.category,
    required this.title,
    this.desc = '',
    this.cover = '',
    this.coverLimit = '',
    this.added = false,
  });

  final String category;
  final String title;
  final String desc;
  final String cover;
  final String coverLimit;
  final bool added;
}

class ChatStickerPackDetail {
  const ChatStickerPackDetail({
    required this.category,
    required this.title,
    this.desc = '',
    this.cover = '',
    this.coverLimit = '',
    this.added = false,
    this.stickers = const [],
  });

  final String category;
  final String title;
  final String desc;
  final String cover;
  final String coverLimit;
  final bool added;
  final List<ChatSticker> stickers;
}

class ChatSticker {
  const ChatSticker({
    required this.path,
    this.title = '',
    this.placeholder = '',
    this.category = '',
    this.format = '',
    this.width = 0,
    this.height = 0,
    this.searchableWord = '',
  });

  final String path;
  final String title;
  final String placeholder;
  final String category;
  final String format;
  final int width;
  final int height;
  // 服务端 sticker.searchable_word — emoji 贴纸用它存对应的 unicode emoji
  // (😽🙀…), 给"单 emoji → 大表情"映射用 (#6, 对齐 Android getEmojiSticker)。
  final String searchableWord;
}

class ChatAppModule {
  const ChatAppModule({
    required this.sid,
    required this.name,
    this.description = '',
    this.enabled = true,
    this.checked = false,
    this.locked = false,
  });

  final String sid;
  final String name;
  final String description;
  final bool enabled;
  final bool checked;
  final bool locked;
}

class ChatAppVersion {
  const ChatAppVersion({
    required this.os,
    required this.appVersion,
    this.force = false,
    this.updateDescription = '',
    this.downloadUrl = '',
    this.createdAt = '',
  });

  final String os;
  final String appVersion;
  final bool force;
  final String updateDescription;
  final String downloadUrl;
  final String createdAt;

  bool get hasDownload => appVersion.isNotEmpty && downloadUrl.isNotEmpty;
}

class ChatBackground {
  const ChatBackground({
    this.cover = '',
    this.url = '',
    this.isSvg = false,
    this.lightColors = const [],
    this.darkColors = const [],
  });

  final String cover;
  final String url;
  final bool isSvg;
  final List<String> lightColors;
  final List<String> darkColors;
}

class ChatDevice {
  const ChatDevice({
    required this.id,
    required this.name,
    this.platform = '',
    this.lastLogin = '',
    this.current = false,
  });

  final String id;
  final String name;
  final String platform;
  final String lastLogin;
  final bool current;
}

class ChatQrCode {
  const ChatQrCode({required this.data, this.day = 0, this.expire = ''});

  final String data;
  final int day;
  final String expire;
}

class ChatScanResult {
  const ChatScanResult({
    required this.forward,
    required this.type,
    this.data = const {},
    this.raw = '',
  });

  const ChatScanResult.raw(String value)
    : forward = '',
      type = '',
      data = const {},
      raw = value;

  final String forward;
  final String type;
  final Map<String, Object?> data;
  final String raw;

  String get authCode {
    final value = data['auth_code'] ?? data['authCode'];
    return value?.toString().trim() ?? '';
  }

  String get url {
    final value = data['url'];
    return value?.toString().trim() ?? '';
  }

  String get uid {
    final value = data['uid'];
    return value?.toString().trim() ?? '';
  }

  String get groupNo {
    final value = data['group_no'] ?? data['groupNo'];
    return value?.toString().trim() ?? '';
  }

  String get joinGroupNo {
    final uri = Uri.tryParse(url);
    if (!_isJoinGroupUrl(uri)) {
      return '';
    }
    return uri?.queryParameters['group_no']?.trim() ?? '';
  }

  String get joinGroupAuthCode {
    final uri = Uri.tryParse(url);
    if (!_isJoinGroupUrl(uri)) {
      return '';
    }
    return uri?.queryParameters['auth_code']?.trim() ?? '';
  }

  bool get isJoinGroupConfirm =>
      forward == 'h5' &&
      type == 'webview' &&
      joinGroupNo.isNotEmpty &&
      joinGroupAuthCode.isNotEmpty;

  static bool _isJoinGroupUrl(Uri? uri) {
    if (uri == null) return false;
    return uri.path.toLowerCase().contains('join_group.html');
  }
}

class ChatInviteCode {
  const ChatInviteCode({required this.code, this.enabled = true});

  final String code;
  final bool enabled;
}

class ChatPhoneContact {
  const ChatPhoneContact({
    required this.name,
    required this.phone,
    this.zone = '',
    this.uid = '',
    this.vercode = '',
    this.isFriend = false,
  });

  final String name;
  final String phone;
  final String zone;
  final String uid;
  final String vercode;
  final bool isFriend;
}

class ChatReportCategory {
  const ChatReportCategory({required this.no, required this.name});

  final String no;
  final String name;
}

class ChatMoment {
  const ChatMoment({
    required this.momentNo,
    required this.publisherUid,
    required this.publisherName,
    required this.text,
    this.createdAt = '',
    this.privacyType = 'public',
    this.privacyUids = const [],
    this.videoPath = '',
    this.videoCoverPath = '',
    this.imgs = const [],
    this.address = '',
    this.longitude = '',
    this.latitude = '',
    this.remindUids = const [],
    this.likes = const [],
    this.comments = const [],
  });

  final String momentNo;
  final String publisherUid;
  final String publisherName;
  final String text;
  final String createdAt;
  final String privacyType;
  final List<String> privacyUids;
  final String videoPath;
  final String videoCoverPath;
  final List<String> imgs;
  final String address;
  final String longitude;
  final String latitude;
  final List<String> remindUids;
  final List<ChatMomentLike> likes;
  final List<ChatMomentComment> comments;
}

class ChatMomentLike {
  const ChatMomentLike({required this.uid, required this.name});

  final String uid;
  final String name;
}

class ChatMomentComment {
  const ChatMomentComment({
    required this.id,
    required this.uid,
    required this.name,
    required this.content,
    this.replyUid = '',
    this.replyName = '',
    this.commentAt = '',
  });

  final String id;
  final String uid;
  final String name;
  final String content;
  final String replyUid;
  final String replyName;
  final String commentAt;
}

class ChatMomentSetting {
  const ChatMomentSetting({this.hideMy = false, this.hideHis = false});

  final bool hideMy;
  final bool hideHis;
}

class ChatUserOnlineState {
  const ChatUserOnlineState({
    this.uid = '',
    this.online = false,
    this.lastOffline = 0,
    this.deviceFlag = 0,
  });

  final String uid;
  final bool online;
  final int lastOffline;
  final int deviceFlag;

  factory ChatUserOnlineState.fromJson(Map<String, dynamic> json) {
    return ChatUserOnlineState(
      uid: (json['uid'] ?? '').toString(),
      online: (json['online'] ?? 0).toString() == '1',
      lastOffline: int.tryParse('${json['last_offline'] ?? 0}') ?? 0,
      deviceFlag: int.tryParse('${json['device_flag'] ?? 0}') ?? 0,
    );
  }
}

class ChatOnlineStatus {
  const ChatOnlineStatus({
    this.friends = const [],
    this.pcOnline = false,
    this.webOnline = false,
  });

  final List<ChatUserOnlineState> friends;
  final bool pcOnline;
  final bool webOnline;

  factory ChatOnlineStatus.fromJson(Map<String, dynamic> json) {
    final friendsRaw = json['friends'];
    final friends = <ChatUserOnlineState>[];
    if (friendsRaw is List) {
      for (final item in friendsRaw) {
        if (item is Map) {
          friends.add(
            ChatUserOnlineState.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    final pcRaw = json['pc'];
    final webRaw = json['web_online'];
    return ChatOnlineStatus(
      friends: friends,
      pcOnline: pcRaw is Map,
      webOnline: webRaw != null && '$webRaw' == '1',
    );
  }
}

class ChatChatFolder {
  const ChatChatFolder({
    this.id = '',
    this.name = '',
    this.memberUids = const [],
    this.groupNos = const [],
    this.memberCount = 0,
  });

  final String id;
  final String name;
  final List<String> memberUids;
  final List<String> groupNos;
  final int memberCount;

  factory ChatChatFolder.fromJson(Map<String, dynamic> json) {
    final uids = <String>[];
    final groupNos = <String>[];
    final uidsRaw = json['member_uids'] ?? json['uids'];
    if (uidsRaw is List) {
      for (final entry in uidsRaw) {
        uids.add(entry?.toString() ?? '');
      }
    }
    final groupRaw = json['group_nos'] ?? json['groups'];
    if (groupRaw is List) {
      for (final entry in groupRaw) {
        groupNos.add(entry?.toString() ?? '');
      }
    }
    return ChatChatFolder(
      id: (json['id'] ?? json['folder_no'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      memberUids: uids,
      groupNos: groupNos,
      memberCount: int.tryParse('${json['member_count'] ?? 0}') ?? 0,
    );
  }
}

class ChatGroupMember {
  const ChatGroupMember({
    this.uid = '',
    this.name = '',
    this.remark = '',
    this.avatar = '',
    this.role = 0,
    this.version = 0,
    this.isDeleted = false,
  });

  final String uid;
  final String name;
  final String remark;
  final String avatar;
  final int role;
  final int version;
  final bool isDeleted;

  factory ChatGroupMember.fromJson(Map<String, dynamic> json) {
    return ChatGroupMember(
      uid: (json['uid'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      remark: (json['remark'] ?? '').toString(),
      avatar: (json['avatar'] ?? '').toString(),
      role: int.tryParse('${json['role'] ?? 0}') ?? 0,
      version: int.tryParse('${json['version'] ?? 0}') ?? 0,
      isDeleted: (json['is_deleted'] ?? 0).toString() == '1',
    );
  }
}

/// md5(password + uid) — the on-wire digest the server stores for
/// chat / lock-screen passwords. Exposed as a top-level helper so the
/// LockScreenGuard can verify user input against `UserSession.current
/// .lockScreenPwd` without round-tripping to the server (mirrors iOS
/// WKApp.showLockScreenProtectIfNeed which compares the local digest
/// directly).
String lockScreenDigest({required String uid, required String password}) {
  return md5.convert(utf8.encode('$password$uid')).toString();
}

class ChatSocialService implements ChatSocialGateway {
  ChatSocialService({
    required this.client,
    this.loginUid = '',
    this.serverScope = '',
  });

  final ApiClient client;

  /// Logged-in user uid — used to namespace the per-user cache key
  /// (mirrors iOS WKContactsSync.m:16 `{uid}_friend_version`). When
  /// empty (anonymous / pre-login probes) we fall back to a full
  /// sync without persistence.
  final String loginUid;
  final String serverScope;

  /// `friend/sync` page size, mirrors iOS WKContactsSync.m:18.
  static const int _kFriendSyncLimit = 200;

  String? get _contactsCacheKey => loginUid.isEmpty
      ? null
      : '${serverAccountScope(serverScope, loginUid)}_contacts_cache_v1';

  @override
  Future<ChatSocialSnapshot> loadSnapshot() async {
    final contactsFuture = _syncContactsIncremental();
    final otherResults = await Future.wait<Object?>([
      _safeGet('group/my'),
      // 服务端 `modules/user/api_friend.go::apply` 用
      //   Offset((page-1)*pageSize).Limit(pageSize)
      // 拼 SQL；不传参数时 pageSize=0 → LIMIT 0 → 永远返回 []。
      // 必须显式传 page_index>=1 & page_size>0。
      _safeGet('friend/apply?page_index=1&page_size=100'),
    ]);

    return ChatSocialSnapshot(
      contacts: await contactsFuture,
      groups: _readList(otherResults[0]).map(_groupFromJson).toList(),
      friendRequests: _readFriendRequests(otherResults[1]),
    );
  }

  /// Incremental friend/sync — mirrors iOS WKContactsSync.sync:
  ///   1. read cached contacts (from prefs) + their max version
  ///   2. GET friend/sync?version={maxVersion}&limit=200&api_version=1
  ///   3. merge delta into cache (is_deleted → drop, else upsert by uid)
  ///   4. if delta.length >= limit → loop again (server has more)
  ///   5. persist merged list to prefs, return full list
  /// First launch (no cache): max=0 → server returns full list.
  Future<List<ChatContact>> _syncContactsIncremental() async {
    final cacheKey = _contactsCacheKey;
    final byUid = <String, ChatContact>{};
    if (cacheKey != null) {
      for (final c in await _loadCachedContacts(cacheKey)) {
        byUid[c.uid] = c;
      }
    }
    int maxVersion = byUid.values.fold<int>(
      0,
      (m, c) => c.version > m ? c.version : m,
    );
    var more = true;
    while (more) {
      final prevMax = maxVersion;
      final raw = await _safeGet(
        'friend/sync?version=$maxVersion'
        '&limit=$_kFriendSyncLimit&api_version=1',
      );
      final delta = _readList(raw).map(_contactFromJson).toList();
      if (delta.isEmpty) break;
      for (final c in delta) {
        if (c.uid.isEmpty) continue;
        if (c.isDeleted || c.status == 2) {
          byUid.remove(c.uid);
        } else {
          byUid[c.uid] = c;
        }
        if (c.version > maxVersion) maxVersion = c.version;
      }
      // Keep paging only if (a) we hit the page limit AND (b) server
      // actually advanced the cursor. Without the prevMax guard, a
      // misbehaving server returning the same rows at version=X
      // would loop forever.
      more = delta.length >= _kFriendSyncLimit && maxVersion > prevMax;
    }
    final merged = byUid.values.where((c) => !c.isDeleted).toList();
    if (cacheKey != null) {
      await _saveCachedContacts(cacheKey, merged);
    }
    return merged;
  }

  Future<List<ChatContact>> _loadCachedContacts(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.map(_contactFromJson).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _saveCachedContacts(
    String key,
    List<ChatContact> contacts,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode([for (final c in contacts) c.toCacheJson()]);
      await prefs.setString(key, payload);
    } catch (_) {
      // Cache write failure is non-fatal — next launch just re-pulls
      // delta from version=0 (full sync).
    }
  }

  Future<void> _patchCachedContact(
    String uid,
    ChatContact Function(ChatContact contact) patch,
  ) async {
    final key = _contactsCacheKey;
    if (key == null || uid.trim().isEmpty) return;
    final contacts = await _loadCachedContacts(key);
    var changed = false;
    final next = <ChatContact>[];
    for (final contact in contacts) {
      if (contact.uid == uid) {
        next.add(patch(contact));
        changed = true;
      } else {
        next.add(contact);
      }
    }
    if (changed) {
      await _saveCachedContacts(key, next);
    }
  }

  Future<void> _removeCachedContact(String uid) async {
    final key = _contactsCacheKey;
    if (key == null || uid.trim().isEmpty) return;
    final contacts = await _loadCachedContacts(key);
    final next = contacts.where((contact) => contact.uid != uid).toList();
    if (next.length != contacts.length) {
      await _saveCachedContacts(key, next);
    }
  }

  @override
  Future<ChatUserSearchResult> searchUser(String keyword) async {
    final query = Uri(queryParameters: {'keyword': keyword.trim()});
    final data = await client.getAny('user/search?${query.query}');
    final map = _readMap(data);
    // Server contract (modules/user/api.go::search):
    //   not found  → {exist: 0}
    //   found      → {exist: 1, data: {uid, name, vercode}}
    final existRaw = map['exist'];
    final exist = existRaw is int
        ? existRaw == 1
        : (existRaw is String && existRaw == '1');
    if (!exist) {
      return const ChatUserSearchResult(exist: false);
    }
    final inner = map['data'];
    if (inner is! Map) {
      // Server said exist=1 but data is malformed — surface as not-
      // found rather than crashing the search flow.
      return const ChatUserSearchResult(exist: false);
    }
    return ChatUserSearchResult(exist: true, contact: _contactFromJson(inner));
  }

  @override
  Future<ChatGlobalSearchResult> searchGlobal({
    required String keyword,
    int onlyMessage = 0,
    String channelId = '',
    int channelType = 0,
    String fromUid = '',
    String topic = '',
    int page = 1,
    int limit = 20,
    int startTime = 0,
    int endTime = 0,
    List<int> contentTypes = const [1, 8],
  }) async {
    final data = await client.postJson('search/global', {
      'channel_id': channelId,
      'channel_type': channelType,
      'only_message': onlyMessage,
      'keyword': keyword.trim(),
      'from_uid': fromUid,
      'topic': topic,
      'limit': limit,
      'page': page,
      'start_time': startTime,
      'end_time': endTime,
      'content_type': contentTypes,
    });
    return _globalSearchResultFromJson(data);
  }

  @override
  Future<void> grantWebLogin(String authCode) async {
    final query = Uri(
      queryParameters: {'auth_code': authCode.trim(), 'encrypt': ''},
    );
    await client.getAny('user/grant_login?${query.query}');
  }

  @override
  Future<ChatScanResult> resolveScanResult(String content) async {
    final normalizedContent = content.trim();
    if (normalizedContent.isEmpty) {
      return const ChatScanResult.raw('');
    }
    final data = await client.getAny(normalizedContent);
    return _scanResultFromJson(data, raw: normalizedContent);
  }

  @override
  Future<ChatGroup?> loadPublicGroupInfo(String groupNo) async {
    final no = groupNo.trim();
    if (no.isEmpty) {
      return null;
    }
    final data = await client.getAny('groups/$no/detail');
    final group = _groupFromJson(data);
    return group.groupNo.isEmpty ? null : group;
  }

  @override
  Future<List<BotCommand>> botCommands(String username) async {
    final name = username.trim();
    if (name.isEmpty) return const [];
    final data = await client.getAny('bots/$name/commands');
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => BotCommand.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Map<String, BotRuntimeStatus>> botRuntimeStatuses() async {
    Object? data;
    try {
      data = await client.getAny('bot-runtime/bots');
    } catch (_) {
      return const {};
    }
    return parseBotRuntimeStatuses(data);
  }

  @override
  Future<void> scanJoinGroup({
    required String groupNo,
    required String authCode,
  }) async {
    final no = groupNo.trim();
    final code = authCode.trim();
    if (no.isEmpty || code.isEmpty) {
      throw const ApiException('二维码信息不完整');
    }
    final query = Uri(queryParameters: {'auth_code': code});
    await client.getAny('groups/$no/scanjoin?${query.query}');
  }

  @override
  Future<void> quitPcLogin() async {
    await client.postJson('user/pc/quit', const {});
  }

  @override
  Future<void> applyFriend({
    required String uid,
    String remark = '',
    String vercode = '',
  }) async {
    await client.postJson('friend/apply', {
      'to_uid': uid,
      'remark': remark,
      'vercode': vercode,
    });
  }

  @override
  Future<void> acceptFriendRequest(String token) async {
    if (token.trim().isEmpty) {
      return;
    }
    await client.postJson('friend/sure', {'token': token});
  }

  @override
  Future<void> refuseFriendRequest(String uid) async {
    if (uid.trim().isEmpty) {
      return;
    }
    await client.putJson('friend/refuse/$uid', const {});
  }

  @override
  Future<void> deleteFriendRequest(String uid) async {
    if (uid.trim().isEmpty) {
      return;
    }
    await client.deleteJson('friend/apply/$uid');
  }

  @override
  Future<void> updateFriendRemark({
    required String uid,
    required String remark,
  }) async {
    final normalizedUid = uid.trim();
    await client.putJson('friend/remark', {
      'uid': normalizedUid,
      'remark': remark,
    });
    await _patchCachedContact(
      normalizedUid,
      (contact) => contact.copyWith(remark: remark),
    );
  }

  @override
  Future<void> deleteFriend(String uid) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      return;
    }
    await client.deleteJson('friends/$normalizedUid');
    await _removeCachedContact(normalizedUid);
  }

  @override
  Future<List<ChatContact>> loadBlacklist() async {
    final data = await client.getAny('user/blacklists');
    return _readList(data).map(_contactFromJson).toList();
  }

  @override
  Future<void> addUserBlacklist(String uid) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      return;
    }
    await client.postJson('user/blacklist/$normalizedUid', const {});
    await _removeCachedContact(normalizedUid);
  }

  @override
  Future<void> removeUserBlacklist(String uid) async {
    if (uid.trim().isEmpty) {
      return;
    }
    await client.deleteJson('user/blacklist/$uid');
  }

  @override
  Future<ChatGroup?> createGroup(
    List<String> memberUids, {
    String name = '',
    List<String> memberNames = const [],
  }) async {
    final data = await client.postJson('group/create', {
      'name': name,
      'members': memberUids,
      'member_names': memberNames,
    });
    final group = _groupFromJson(data);
    return group.groupNo.isEmpty ? null : group;
  }

  @override
  Future<List<ChatContact>> loadGroupMembers(String groupNo) async {
    final query = Uri(queryParameters: {'limit': '10000'});
    final data = await client.getAny('groups/$groupNo/members?${query.query}');
    return _readList(data).map(_contactFromJson).toList();
  }

  @override
  Future<List<ChatContact>> loadDeletedGroupMembers(String groupNo) async {
    final query = Uri(queryParameters: {'version': '0', 'limit': '10000'});
    final data = await client.getAny(
      'groups/$groupNo/membersync?${query.query}',
    );
    return _readList(data)
        .where((item) => _int(_readMap(item)['is_deleted']) == 1)
        .map(_contactFromJson)
        .toList();
  }

  @override
  Future<List<ChatContact>> loadGroupBlacklist(String groupNo) async {
    // server GroupMemberStatusBlacklist = 2; is_deleted=0 排除已退群成员.
    final query = Uri(queryParameters: {'version': '0', 'limit': '10000'});
    final data = await client.getAny(
      'groups/$groupNo/membersync?${query.query}',
    );
    return _readList(data)
        .where((item) {
          final map = _readMap(item);
          return _int(map['status']) == 2 && _int(map['is_deleted']) == 0;
        })
        .map(_contactFromJson)
        .toList();
  }

  @override
  Future<void> addGroupMembers({
    required String groupNo,
    required List<String> memberUids,
  }) async {
    await client.postJson('groups/$groupNo/members', {'members': memberUids});
  }

  @override
  Future<void> inviteGroupMembers({
    required String groupNo,
    required List<String> memberUids,
    String remark = '',
  }) async {
    await client.postJson('groups/$groupNo/member/invite', {
      'uids': memberUids,
      'remark': remark,
    });
  }

  @override
  Future<void> removeGroupMembers({
    required String groupNo,
    required List<String> memberUids,
  }) async {
    await client.deleteJson(
      'groups/$groupNo/members',
      body: {'members': memberUids},
    );
  }

  @override
  Future<void> addGroupManagers({
    required String groupNo,
    required List<String> memberUids,
  }) async {
    await client.postAny('groups/$groupNo/managers', memberUids);
  }

  @override
  Future<void> removeGroupManagers({
    required String groupNo,
    required List<String> memberUids,
  }) async {
    await client.deleteAny('groups/$groupNo/managers', body: memberUids);
  }

  @override
  Future<void> transferGroupOwner({
    required String groupNo,
    required String uid,
  }) async {
    await client.postJson('groups/$groupNo/transfer/$uid', const {});
  }

  @override
  Future<void> setGroupForbidden({
    required String groupNo,
    required bool enabled,
  }) async {
    await client.postJson(
      'groups/$groupNo/forbidden/${enabled ? 1 : 0}',
      const {},
    );
  }

  @override
  Future<List<ChatGroupForbiddenTime>> loadGroupForbiddenTimes() async {
    final data = await client.getAny('group/forbidden_times');
    return _readList(data).map(_groupForbiddenTimeFromJson).toList();
  }

  @override
  Future<void> forbidGroupMember({
    required String groupNo,
    required String memberUid,
    required int key,
  }) async {
    await client.postJson('groups/$groupNo/forbidden_with_member', {
      'member_uid': memberUid,
      'action': 1,
      'key': key,
    });
  }

  @override
  Future<void> unforbidGroupMember({
    required String groupNo,
    required String memberUid,
  }) async {
    await client.postJson('groups/$groupNo/forbidden_with_member', {
      'member_uid': memberUid,
      'action': 0,
      'key': 0,
    });
  }

  @override
  Future<void> disbandGroup(String groupNo) async {
    await client.deleteJson('groups/$groupNo/disband');
  }

  @override
  Future<String> loadGroupInviteConfirmUrl({
    required String groupNo,
    required String inviteNo,
  }) async {
    final query = Uri(queryParameters: {'invite_no': inviteNo});
    final data = await client.getAny(
      'groups/$groupNo/member/h5confirm?${query.query}',
    );
    return _string(_readMap(data)['url']);
  }

  @override
  Future<void> exitGroup(String groupNo) async {
    await client.postJson('groups/$groupNo/exit', const {});
  }

  @override
  Future<void> updateGroupSetting({
    required String groupNo,
    required Map<String, dynamic> setting,
  }) async {
    await client.putJson('groups/$groupNo/setting', setting);
  }

  @override
  Future<void> updateGroupInfo({
    required String groupNo,
    required String key,
    required String value,
  }) async {
    await client.putJson('groups/$groupNo', {key: value});
  }

  @override
  Future<void> updateGroupMemberRemark({
    required String groupNo,
    required String memberUid,
    required String remark,
  }) async {
    await client.putJson('groups/$groupNo/members/$memberUid', {
      'remark': remark,
    });
  }

  @override
  Future<void> addGroupBlacklist({
    required String groupNo,
    required List<String> memberUids,
  }) async {
    await client.postJson('groups/$groupNo/blacklist/add', {
      'uids': memberUids,
    });
  }

  @override
  Future<void> removeGroupBlacklist({
    required String groupNo,
    required List<String> memberUids,
  }) async {
    await client.postJson('groups/$groupNo/blacklist/remove', {
      'uids': memberUids,
    });
  }

  @override
  Future<List<ChatLabel>> loadLabels() async {
    final data = await client.getAny('labels');
    return _readList(data).map(_labelFromJson).toList();
  }

  @override
  Future<void> createLabel({
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  }) async {
    // 字段名跟齐 iOS LLLabelAddVM.finishLabel + server modules/label/api.go:262
    // 之前用 `members` / `groups` server 静默忽略, 创建空标签.
    await client.postJson('labels', {
      'name': name,
      'member_uids': memberUids,
      'group_ids': groupNos,
    });
  }

  @override
  Future<void> updateLabel({
    required String id,
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  }) async {
    await client.putJson('labels/$id', {
      'name': name,
      'member_uids': memberUids,
      'group_ids': groupNos,
    });
  }

  @override
  Future<void> deleteLabel(String id) async {
    await client.deleteJson('labels/$id');
  }

  @override
  Future<List<ChatFavorite>> loadFavorites() async {
    final data = await client.getAny(
      'favorite/my?page_index=1&page_size=10000',
    );
    return _readList(data).map(_favoriteFromJson).toList();
  }

  @override
  Future<List<ChatAppModule>> loadAppModules() async {
    final data = await client.getAny('common/appmodule');
    return _readList(data).map(_appModuleFromJson).toList();
  }

  @override
  Future<List<ChatBackground>> loadChatBackgrounds() async {
    final data = await client.getAny('common/chatbg');
    return _readList(data).map(_chatBackgroundFromJson).toList();
  }

  @override
  Future<ChatAppVersion?> loadAppVersion({
    required String os,
    required String currentVersion,
  }) async {
    final normalizedOs = os.trim();
    final normalizedVersion = currentVersion.trim();
    if (normalizedOs.isEmpty || normalizedVersion.isEmpty) {
      return null;
    }
    final data = await client.getAny(
      'common/appversion/$normalizedOs/$normalizedVersion',
    );
    final version = _appVersionFromJson(data);
    return version.appVersion.isEmpty ? null : version;
  }

  @override
  Future<void> addFavorite({
    required String uniqueKey,
    required String authorUid,
    required String authorName,
    required int type,
    required String content,
  }) async {
    await client.postJson('favorites', {
      'type': type,
      'unique_key': uniqueKey,
      'author_name': authorName,
      'author_uid': authorUid,
      'payload': {'content': content},
    });
  }

  @override
  Future<void> deleteFavorite(String id) async {
    await client.deleteJson('favorites/$id');
  }

  @override
  Future<void> updateFavorite({
    required String id,
    required Map<String, dynamic> payload,
  }) async {
    await client.postJson('favorites/update/$id', payload);
  }

  @override
  Future<ChatOnlineStatus> loadOnlineStatus() async {
    final data = await client.getAny('user/online');
    return ChatOnlineStatus.fromJson(_readMap(data));
  }

  @override
  Future<List<ChatUserOnlineState>> loadOnlineForUids(List<String> uids) async {
    if (uids.isEmpty) {
      return const [];
    }
    final data = await client.postAny('user/online', uids);
    return _readList(
      data,
    ).map((value) => ChatUserOnlineState.fromJson(_readMap(value))).toList();
  }

  @override
  Future<List<ChatGroupMember>> syncGroupMembers({
    required String groupNo,
    int version = 0,
  }) async {
    final data = await client.getAny(
      'groups/$groupNo/membersync?version=$version',
    );
    return _readList(
      data,
    ).map((value) => ChatGroupMember.fromJson(_readMap(value))).toList();
  }

  @override
  Future<ChatContact?> getUserInfo(String uid) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      return null;
    }
    final data = await client.getAny('users/$normalizedUid');
    return _contactFromJson(data);
  }

  @override
  Future<List<ChatContact>> searchFriends(String keyword) async {
    final query = Uri(queryParameters: {'keyword': keyword.trim()});
    final data = await client.getAny('friend/search?${query.query}');
    return _readList(data).map(_contactFromJson).toList();
  }

  @override
  Future<int> getRedDot(String category) async {
    final normalized = category.trim();
    if (normalized.isEmpty) {
      return 0;
    }
    final data = await client.getAny('user/reddot/$normalized');
    final source = _readMap(data);
    return int.tryParse('${source['count'] ?? source['unread'] ?? 0}') ?? 0;
  }

  @override
  Future<void> clearRedDot(String category) async {
    final normalized = category.trim();
    if (normalized.isEmpty) {
      return;
    }
    await client.deleteJson('user/reddot/$normalized');
  }

  @override
  Future<List<ChatContact>> loadCustomerServices() async {
    final data = await client.getAny('user/customerservices');
    return _readList(data).map(_contactFromJson).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> loadAppVersionList() async {
    final data = await client.getAny('common/appversion/list');
    return _readList(data).map(_readMap).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> loadCountries() async {
    final data = await client.getAny('common/countries');
    return _readList(data).map(_readMap).toList();
  }

  @override
  Future<String> requestPcLoginUuid() async {
    final data = await client.getAny('user/loginuuid');
    final source = _readMap(data);
    return (source['login_uuid'] ?? source['uuid'] ?? '').toString();
  }

  @override
  Future<Map<String, dynamic>> getPcLoginStatus(String loginUuid) async {
    final query = Uri(queryParameters: {'login_uuid': loginUuid});
    final data = await client.getAny('user/loginstatus?${query.query}');
    return _readMap(data);
  }

  @override
  Future<List<ChatChatFolder>> loadChatFolders() async {
    final data = await client.getAny('chatfolders');
    return _readList(
      data,
    ).map((value) => ChatChatFolder.fromJson(_readMap(value))).toList();
  }

  @override
  Future<ChatChatFolder?> loadChatFolderDetail(String id) async {
    final normalized = id.trim();
    if (normalized.isEmpty) {
      return null;
    }
    final data = await client.getAny('chatfolders/$normalized');
    final source = _readMap(data);
    if (source.isEmpty) {
      return null;
    }
    return ChatChatFolder.fromJson(source);
  }

  @override
  Future<void> createChatFolder({
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  }) async {
    await client.postJson('chatfolders', {
      'name': name,
      'uids': memberUids,
      'group_nos': groupNos,
    });
  }

  @override
  Future<void> updateChatFolder({
    required String id,
    required String name,
    required List<String> memberUids,
    required List<String> groupNos,
  }) async {
    await client.putJson('chatfolders/$id', {
      'name': name,
      'uids': memberUids,
      'group_nos': groupNos,
    });
  }

  @override
  Future<void> deleteChatFolder(String id) async {
    final normalized = id.trim();
    if (normalized.isEmpty) {
      return;
    }
    await client.deleteJson('chatfolders/$normalized');
  }

  @override
  Future<ChatLabel?> loadLabelDetail(String id) async {
    final normalized = id.trim();
    if (normalized.isEmpty) {
      return null;
    }
    final data = await client.getAny('labels/$normalized');
    final source = _readMap(data);
    if (source.isEmpty) {
      return null;
    }
    return _labelFromJson(source);
  }

  @override
  Future<void> registerDeviceToken({
    required String token,
    required String deviceType,
    required String bundleId,
  }) async {
    if (token.trim().isEmpty) {
      return;
    }
    await client.postJson('user/device_token', {
      'device_token': token,
      'device_type': deviceType,
      'bundle_id': bundleId,
    });
  }

  @override
  Future<void> registerVoipDeviceToken(String voipToken) async {
    if (voipToken.trim().isEmpty) {
      return;
    }
    // 同 endpoint 增量更新 — server 端 Hmset 只 set 非空字段, 不动其他
    // 字段, 所以 voip_device_token 单独上报不会覆盖已注册的 alert
    // device_token / device_type / bundle_id.
    await client.postJson('user/device_token', {
      'voip_device_token': voipToken,
    });
  }

  @override
  Future<void> unregisterDeviceToken() async {
    await client.deleteJson('user/device_token');
  }

  @override
  Future<void> updateBadge(int badge) async {
    await client.postJson('user/device_badge', {'badge': badge});
  }

  @override
  Future<List<ChatDevice>> loadDevices() async {
    final data = await client.getAny('user/devices');
    return _readList(data).map(_deviceFromJson).toList();
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    if (deviceId.trim().isEmpty) {
      return;
    }
    await client.deleteJson('user/devices/$deviceId');
  }

  @override
  Future<void> updateCurrentUserSetting({
    required String key,
    required int value,
  }) async {
    final normalizedKey = key.trim();
    if (normalizedKey.isEmpty) {
      return;
    }
    await client.putJson('user/my/setting', {normalizedKey: value});
  }

  @override
  Future<void> updateCurrentUserInfo({
    required String key,
    required String value,
  }) async {
    final normalizedKey = key.trim();
    if (normalizedKey.isEmpty) {
      return;
    }
    await client.putJson('user/current', {normalizedKey: value});
  }

  @override
  Future<void> updateUserSetting({
    required String uid,
    required Map<String, dynamic> setting,
  }) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty || setting.isEmpty) {
      return;
    }
    await client.putJson('users/$normalizedUid/setting', setting);
  }

  @override
  Future<void> uploadCurrentUserAvatar({
    required String uid,
    required String filePath,
  }) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty || filePath.trim().isEmpty) {
      return;
    }
    await client.uploadFile('users/$normalizedUid/avatar', filePath);
  }

  @override
  Future<void> uploadGroupAvatar({
    required String groupNo,
    required String filePath,
  }) async {
    final no = groupNo.trim();
    if (no.isEmpty || filePath.trim().isEmpty) {
      return;
    }
    await client.uploadFile('groups/$no/avatar', filePath);
  }

  @override
  Future<ChatGroup?> loadGroupInfo(String groupNo) async {
    final no = groupNo.trim();
    if (no.isEmpty) {
      return null;
    }
    try {
      final raw = await client.getAny('groups/$no');
      final json = _readMap(raw);
      if (json.isEmpty) {
        return null;
      }
      return ChatGroup(
        groupNo: (json['group_no'] ?? no).toString(),
        name: (json['name'] ?? '').toString(),
        memberCount: int.tryParse('${json['member_count'] ?? 0}') ?? 0,
        notice: (json['notice'] ?? '').toString(),
        muted: '${json['mute'] ?? 0}' == '1',
        saved: '${json['save'] ?? 1}' == '1',
        inviteConfirm: '${json['invite'] ?? 0}' == '1',
        forbidden: '${json['forbidden'] ?? 0}' == '1',
        forbiddenAddFriend: '${json['forbidden_add_friend'] ?? 0}' == '1',
        allowViewHistoryMsg: '${json['allow_view_history_msg'] ?? 1}' == '1',
        allowMemberPinnedMessage:
            '${json['allow_member_pinned_message'] ?? 0}' == '1',
      );
    } on ApiException {
      return null;
    }
  }

  @override
  Future<void> sendDestroyAccountCode() async {
    await client.postJson('user/sms/destroy', const {});
  }

  @override
  Future<void> destroyAccount(String code) async {
    final normalizedCode = code.trim();
    if (normalizedCode.isEmpty) {
      return;
    }
    await client.deleteJson('user/destroy/$normalizedCode');
  }

  @override
  Future<ChatQrCode> loadUserQrCode() async {
    final data = await client.getAny('user/qrcode');
    return _qrCodeFromJson(data);
  }

  @override
  Future<ChatQrCode> loadGroupQrCode(String groupNo) async {
    final normalizedGroupNo = groupNo.trim();
    if (normalizedGroupNo.isEmpty) {
      return const ChatQrCode(data: '');
    }
    final data = await client.getAny('groups/$normalizedGroupNo/qrcode');
    return _qrCodeFromJson(data);
  }

  @override
  Future<ChatInviteCode> loadInviteCode() async {
    final data = await client.getAny('invite');
    return _inviteCodeFromJson(data);
  }

  @override
  Future<void> toggleInviteCodeStatus() async {
    await client.putJson('invite/status', const {});
  }

  @override
  Future<void> sendPasswordResetCode({
    required String phone,
    String zone = '0086',
  }) async {
    await client.postJson('user/sms/forgetpwd', {
      'zone': zone,
      'phone': phone.trim(),
    });
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
    String zone = '0086',
  }) async {
    await client.postJson('user/pwdforget', {
      'zone': zone,
      'phone': phone.trim(),
      'code': code.trim(),
      'pwd': password,
    });
  }

  @override
  Future<void> uploadPhoneContacts(List<ChatPhoneContact> contacts) async {
    if (contacts.isEmpty) {
      return;
    }
    await client.postAny('user/maillist', [
      for (final contact in contacts)
        {'name': contact.name, 'zone': contact.zone, 'phone': contact.phone},
    ]);
  }

  @override
  Future<List<ChatPhoneContact>> loadPhoneContacts() async {
    final data = await client.getAny('user/maillist');
    return _readList(data).map(_phoneContactFromJson).toList();
  }

  @override
  Future<List<ChatReportCategory>> loadReportCategories() async {
    final data = await client.getAny('report/categories');
    return [
      for (final value in _readList(data)) ..._reportCategoriesFromJson(value),
    ];
  }

  @override
  Future<void> submitReport({
    required String channelId,
    required int channelType,
    required String categoryNo,
    required String remark,
    List<String> imgs = const [],
  }) async {
    await client.postJson('reports', {
      'channel_id': channelId,
      'channel_type': channelType,
      'category_no': categoryNo,
      'imgs': imgs,
      'remark': remark,
    });
  }

  @override
  Future<void> setChatPassword({
    required String uid,
    required String loginPassword,
    required String chatPassword,
  }) async {
    final digest = _digestPassword(uid: uid, password: chatPassword);
    await client.postJson('user/chatpwd', {
      'login_pwd': loginPassword,
      'chat_pwd': digest,
    });
    // 持久化 digest 给 _openChat 拦截校验用 — session.chatPwd 是 cold snapshot
    // (登录时拉一次), 用户设密码后没有刷新机制. 走 prefs 全局可读, 跟 iOS
    // WKApp.loginInfo.chat_pwd 同语义.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('chatPwdDigest:$uid', digest);
    } catch (_) {}
  }

  @override
  Future<void> setLockScreenPassword({
    required String uid,
    required String password,
  }) async {
    await client.postJson('user/lockscreenpwd', {
      'lock_screen_pwd': _digestPassword(uid: uid, password: password),
    });
  }

  @override
  Future<void> updateLockAfterMinute(int minute) async {
    await client.putJson('user/lock_after_minute', {
      'lock_after_minute': minute,
    });
  }

  @override
  Future<void> closeLockScreenPassword() async {
    await client.deleteJson('user/lockscreenpwd');
  }

  @override
  Future<List<ChatMoment>> loadMoments({
    int pageIndex = 1,
    int pageSize = 20,
    String uid = '',
  }) async {
    final query = Uri(
      queryParameters: {
        'page_index': '$pageIndex',
        'page_size': '$pageSize',
        if (uid.trim().isNotEmpty) 'uid': uid.trim(),
      },
    );
    final data = await client.getAny('moments?${query.query}');
    return _readList(data).map(_momentFromJson).toList();
  }

  @override
  Future<void> publishMoment({
    required String text,
    String privacyType = 'public',
    List<String> imgs = const [],
    List<String> privacyUids = const [],
    List<String> remindUids = const [],
    String videoPath = '',
    String videoCoverPath = '',
    String address = '',
    String longitude = '',
    String latitude = '',
  }) async {
    await client.postJson('moments', {
      'video_path': videoPath,
      'video_cover_path': videoCoverPath,
      'text': text.trim(),
      'imgs': imgs,
      'privacy_type': privacyType.trim().isEmpty ? 'public' : privacyType,
      'privacy_uids': privacyUids,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'remind_uids': remindUids,
    });
  }

  @override
  Future<ChatMoment> loadMomentDetail(String momentNo) async {
    final normalizedMomentNo = momentNo.trim();
    if (normalizedMomentNo.isEmpty) {
      return const ChatMoment(
        momentNo: '',
        publisherUid: '',
        publisherName: '',
        text: '',
      );
    }
    final data = await client.getAny('moments/$normalizedMomentNo');
    return _momentFromJson(data);
  }

  @override
  Future<void> uploadMomentCover(String localPath) async {
    if (localPath.isEmpty) return;
    // 对齐 iOS WKMomentVM.m:310-326 2-step upload:
    // 1) GET file/upload?type=momentcover → 取 upload URL
    // 2) POST 二进制到该 URL
    final uploadInfo = await client.getJson('file/upload?type=momentcover');
    final uploadUrl = _string(_readMap(uploadInfo)['url']);
    if (uploadUrl.isEmpty) {
      throw const ApiException('封面上传地址为空');
    }
    await client.uploadFile(uploadUrl, localPath);
  }

  @override
  Future<String> uploadMomentImage(String localPath, {String? uid}) async {
    if (localPath.isEmpty) return '';
    // hint path: /<uid>/<ts>.<ext> (跟 chat upload 同模式, 服务端可能用 / 可能不用,
    // 用了的话决定存储位置. 没传 server 也会自动生成).
    final fileName = localPath.split('/').last;
    final ext = fileName.contains('.') ? fileName.split('.').last : 'jpg';
    final ts = DateTime.now().millisecondsSinceEpoch;
    final hintPath = '/${uid ?? "anon"}/$ts.$ext';
    final query = Uri(queryParameters: {'type': 'moment', 'path': hintPath});
    final uploadInfo = await client.getJson('file/upload?${query.query}');
    final uploadUrl = _string(_readMap(uploadInfo)['url']);
    if (uploadUrl.isEmpty) {
      throw const ApiException('上传地址为空');
    }
    final uploadResult = await client.uploadFile(uploadUrl, localPath);
    final result = _readMap(uploadResult);
    final remote = _string(result['path']);
    return remote.isNotEmpty ? remote : hintPath;
  }

  @override
  Future<List<ChatStickerPack>> loadStickerStore({
    int pageIndex = 1,
    int pageSize = 20,
  }) async {
    final query = Uri(
      queryParameters: {'page_index': '$pageIndex', 'page_size': '$pageSize'},
    );
    final data = await client.getAny('sticker/store?${query.query}');
    return _readList(data).map(_stickerPackFromJson).toList();
  }

  @override
  Future<ChatStickerPackDetail> loadStickerDetail(String category) async {
    final normalizedCategory = category.trim();
    if (normalizedCategory.isEmpty) {
      return const ChatStickerPackDetail(category: '', title: '');
    }
    final query = Uri(queryParameters: {'category': normalizedCategory});
    final data = await client.getAny('sticker/user/sticker?${query.query}');
    return _stickerDetailFromJson(data);
  }

  @override
  Future<List<ChatStickerPack>> loadStickerCategories() async {
    final data = await client.getAny('sticker/user/category');
    return _dedupeStickerPacksByCategory(
      _readList(data).map(_stickerPackFromJson),
    );
  }

  @override
  Future<List<ChatSticker>> loadCustomStickers() async {
    final data = await client.getAny('sticker/user');
    return _readList(data).map(_stickerFromJson).toList();
  }

  @override
  Future<List<ChatSticker>> searchStickers({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    final normalizedKeyword = keyword.trim();
    if (normalizedKeyword.isEmpty) {
      return const [];
    }
    final query = Uri(
      queryParameters: {
        'keyword': normalizedKeyword,
        'page': '$page',
        'page_size': '$pageSize',
      },
    );
    final data = await client.getAny('sticker?${query.query}');
    return _readList(data).map(_stickerFromJson).toList();
  }

  @override
  Future<void> addStickerCategory(String category) async {
    final normalizedCategory = category.trim();
    if (normalizedCategory.isEmpty) {
      return;
    }
    await client.postJson('sticker/user/$normalizedCategory', const {});
  }

  @override
  Future<void> removeStickerCategory(String category) async {
    final normalizedCategory = category.trim();
    if (normalizedCategory.isEmpty) {
      return;
    }
    final query = Uri(queryParameters: {'category': normalizedCategory});
    await client.deleteJson('sticker/remove?${query.query}');
  }

  @override
  Future<void> addCustomSticker(ChatSticker sticker) async {
    final normalizedPath = sticker.path.trim();
    if (normalizedPath.isEmpty) {
      return;
    }
    await client.postJson('sticker/user', {
      'path': normalizedPath,
      'width': sticker.width,
      'height': sticker.height,
      'format': sticker.format,
      'category': sticker.category,
      'placeholder': sticker.placeholder,
    });
  }

  @override
  Future<String> uploadCustomStickerImage(
    String localPath, {
    int width = 0,
    int height = 0,
  }) async {
    if (localPath.isEmpty) return '';
    final fileName = localPath.split('/').last;
    final ext = fileName.contains('.') ? fileName.split('.').last : 'png';
    final ts = DateTime.now().millisecondsSinceEpoch;
    final hintPath = '/$ts.$ext';
    final query = Uri(queryParameters: {'type': 'sticker', 'path': hintPath});
    final uploadInfo = await client.getJson('file/upload?${query.query}');
    final uploadUrl = _string(_readMap(uploadInfo)['url']);
    if (uploadUrl.isEmpty) {
      throw const ApiException('上传地址为空');
    }
    final uploadResult = await client.uploadFile(uploadUrl, localPath);
    final result = _readMap(uploadResult);
    final remote = _string(result['path']);
    final path = remote.isNotEmpty ? remote : hintPath;
    await addCustomSticker(
      ChatSticker(path: path, width: width, height: height, format: ext),
    );
    return path;
  }

  @override
  Future<void> deleteCustomStickers(List<String> paths) async {
    final normalizedPaths = paths
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toList(growable: false);
    if (normalizedPaths.isEmpty) {
      return;
    }
    await client.deleteJson('sticker/user', body: {'paths': normalizedPaths});
  }

  @override
  Future<void> moveCustomStickersToFront(List<String> paths) async {
    final normalizedPaths = paths
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toList(growable: false);
    if (normalizedPaths.isEmpty) {
      return;
    }
    await client.putJson('sticker/user/front', {'paths': normalizedPaths});
  }

  @override
  Future<void> reorderStickerCategories(List<String> categories) async {
    final normalizedCategories = categories
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList(growable: false);
    if (normalizedCategories.isEmpty) {
      return;
    }
    await client.putJson('sticker/user/category/reorder', {
      'categorys': normalizedCategories,
    });
  }

  @override
  Future<void> likeMoment(String momentNo) async {
    final normalizedMomentNo = momentNo.trim();
    if (normalizedMomentNo.isEmpty) {
      return;
    }
    await client.putJson('moments/$normalizedMomentNo/like', const {});
  }

  @override
  Future<void> unlikeMoment(String momentNo) async {
    final normalizedMomentNo = momentNo.trim();
    if (normalizedMomentNo.isEmpty) {
      return;
    }
    await client.putJson('moments/$normalizedMomentNo/unlike', const {});
  }

  @override
  Future<ChatMomentComment> commentMoment({
    required String momentNo,
    required String content,
    String replyCommentId = '',
    String replyUid = '',
    String replyName = '',
  }) async {
    final normalizedMomentNo = momentNo.trim();
    final normalizedContent = content.trim();
    if (normalizedMomentNo.isEmpty || normalizedContent.isEmpty) {
      return const ChatMomentComment(id: '', uid: '', name: '', content: '');
    }
    final data = await client.postJson('moments/$normalizedMomentNo/comments', {
      'reply_comment_id': replyCommentId.trim(),
      'reply_uid': replyUid.trim(),
      'reply_name': replyName.trim(),
      'content': normalizedContent,
    });
    final json = _readMap(data);
    return ChatMomentComment(
      id: _string(json['id'] ?? json['sid']),
      uid: _string(json['uid']),
      name: _string(json['name']),
      content: _string(json['content']).isEmpty
          ? normalizedContent
          : _string(json['content']),
      replyUid: _string(json['reply_uid'] ?? json['replyUid']).isEmpty
          ? replyUid.trim()
          : _string(json['reply_uid'] ?? json['replyUid']),
      replyName: _string(json['reply_name'] ?? json['replyName']).isEmpty
          ? replyName.trim()
          : _string(json['reply_name'] ?? json['replyName']),
      commentAt: _string(json['comment_at'] ?? json['commentAt']),
    );
  }

  @override
  Future<void> deleteMomentComment({
    required String momentNo,
    required String commentId,
  }) async {
    final normalizedMomentNo = momentNo.trim();
    final normalizedCommentId = commentId.trim();
    if (normalizedMomentNo.isEmpty || normalizedCommentId.isEmpty) {
      return;
    }
    await client.deleteJson(
      'moments/$normalizedMomentNo/comments/$normalizedCommentId',
    );
  }

  @override
  Future<void> deleteMoment(String momentNo) async {
    final normalizedMomentNo = momentNo.trim();
    if (normalizedMomentNo.isEmpty) {
      return;
    }
    await client.deleteJson('moments/$normalizedMomentNo');
  }

  @override
  Future<ChatMomentSetting> loadMomentSetting(String uid) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      return const ChatMomentSetting();
    }
    final data = await client.getAny('moment/setting/$normalizedUid');
    return _momentSettingFromJson(data);
  }

  @override
  Future<void> setMomentHideMy({
    required String uid,
    required bool enabled,
  }) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      return;
    }
    await client.putJson(
      'moment/setting/hidemy/$normalizedUid/${enabled ? 1 : 0}',
      const {},
    );
  }

  @override
  Future<void> setMomentHideHis({
    required String uid,
    required bool enabled,
  }) async {
    final normalizedUid = uid.trim();
    if (normalizedUid.isEmpty) {
      return;
    }
    await client.putJson(
      'moment/setting/hidehis/$normalizedUid/${enabled ? 1 : 0}',
      const {},
    );
  }

  Future<Object?> _safeGet(String path) async {
    try {
      return await client.getAny(path);
    } catch (_) {
      return const [];
    }
  }

  static ChatContact _contactFromJson(Object? value) {
    final json = _readMap(value);
    final uid = _string(json['uid'] ?? json['id']);
    final name = _string(json['name'] ?? json['nickname'] ?? json['username']);
    final username = _string(json['username']);
    final remark = _string(json['remark']);
    final subtitle = _string(
      json['short_no'] ?? json['phone'] ?? json['signature'],
    );
    return ChatContact(
      uid: uid,
      name: moyuDisplayName(name: name, rawIdentity: uid, placeholder: ''),
      username: username,
      remark: remark,
      subtitle: subtitle,
      sourceDescription: _string(json['source_desc'] ?? json['sourceDesc']),
      avatar: _string(json['avatar'] ?? json['logo']),
      online: _int(json['online']) == 1,
      role: _int(json['role']),
      status: _int(json['status'], fallback: 1),
      vercode: _string(json['vercode']),
      version: _int(json['version']),
      isDeleted: _int(json['is_deleted']) == 1,
      isRobot: _int(json['robot']) == 1,
      category: _string(json['category']),
    );
  }

  static ChatGroup _groupFromJson(Object? value) {
    final json = _readMap(value);
    final groupNo = _string(json['group_no'] ?? json['groupNo']);
    final name = _string(json['name']);
    return ChatGroup(
      groupNo: groupNo,
      name: name.isEmpty ? groupNo : name,
      memberCount: _int(json['member_count'] ?? json['memberCount']),
      notice: _string(json['notice'] ?? json['remark']),
      muted: _int(json['mute']) == 1,
      saved: json.containsKey('save') ? _int(json['save']) == 1 : true,
      inviteConfirm: _int(json['invite']) == 1,
      forbidden: _int(json['forbidden']) == 1,
      forbiddenAddFriend: _int(json['forbidden_add_friend']) == 1,
      allowViewHistoryMsg: json.containsKey('allow_view_history_msg')
          ? _int(json['allow_view_history_msg']) == 1
          : true,
      allowMemberPinnedMessage: _int(json['allow_member_pinned_message']) == 1,
    );
  }

  static ChatGroupForbiddenTime _groupForbiddenTimeFromJson(Object? value) {
    final json = _readMap(value);
    return ChatGroupForbiddenTime(
      text: _string(json['text']),
      key: _int(json['key']),
    );
  }

  static ChatGlobalSearchResult _globalSearchResultFromJson(Object? value) {
    final json = _readMap(value);
    return ChatGlobalSearchResult(
      friends: _readList(json['friends']).map(_globalChannelFromJson).toList(),
      groups: _readList(json['groups']).map(_globalChannelFromJson).toList(),
      messages: _readList(
        json['messages'],
      ).map(_globalMessageFromJson).toList(),
    );
  }

  static ChatGlobalChannel _globalChannelFromJson(Object? value) {
    final json = _readMap(value);
    return ChatGlobalChannel(
      channelId: _string(json['channel_id'] ?? json['channelId']),
      channelType: _int(json['channel_type'] ?? json['channelType']),
      channelName: _stripSearchMarkup(
        _string(json['channel_name'] ?? json['channelName']),
      ),
      channelRemark: _stripSearchMarkup(
        _string(json['channel_remark'] ?? json['channelRemark']),
      ),
    );
  }

  static ChatGlobalMessage _globalMessageFromJson(Object? value) {
    final json = _readMap(value);
    final payload = _readMap(json['payload']);
    return ChatGlobalMessage(
      messageId: _string(json['message_idstr'] ?? json['message_id']),
      clientMsgNo: _string(json['client_msg_no'] ?? json['clientMsgNo']),
      fromUid: _string(json['from_uid'] ?? json['fromUid']),
      timestamp: _int(json['timestamp']),
      text: _globalMessageText(payload),
      channel: _globalChannelFromJson(json['channel']),
      fromChannel: _globalChannelFromJson(json['from_channel']),
      contentType: _int(
        json['content_type'] ?? json['contentType'] ?? payload['type'],
      ),
      messageSeq: _int(json['message_seq'] ?? json['messageSeq']),
      payload: payload,
    );
  }

  /// 拿消息文本 — 保留 <mark>...</mark> 让 cell 自己解析高亮 (对齐 iOS
  /// WKSearchMessageCell.highlightText 正则替换主题色).
  static String _globalMessageText(Map<String, dynamic> payload) {
    for (final key in ['content', 'name', 'file_name', 'title']) {
      final value = _string(payload[key]);
      if (value.isNotEmpty) {
        return value;
      }
    }
    return '';
  }

  static List<ChatFriendRequest> _readFriendRequests(Object? source) {
    final directList = _readList(source);
    if (directList.isNotEmpty) {
      return directList.map(_friendRequestFromJson).toList();
    }
    final candidates = [
      _readMap(source)['friend_requests'],
      _readMap(source)['requests'],
      _readMap(source)['apply'],
    ];
    for (final candidate in candidates) {
      final list = _readList(candidate);
      if (list.isNotEmpty) {
        return list.map(_friendRequestFromJson).toList();
      }
    }
    return const [];
  }

  static ChatFriendRequest _friendRequestFromJson(Object? value) {
    final json = _readMap(value);
    // 服务端 /v1/friend/apply 的响应字段命名:
    //   uid     = 收件人（当前登录用户，e.g. dasha）
    //   to_uid  = 申请人（e.g. kk）  ← 这才是我们要的
    //   to_name = 申请人的昵称        ← 这才是我们要的
    // 命名反直觉，但 server.go 写的就是这样（看
    // modules/user/api_friend.go::friendApplyResp）。
    // 之前读 `uid` / `name` 把收件人 UID 当成申请人显示
    // → 列表上是 dasha 自己的 32 位 UID + 没头像。
    final applicantUid = _string(
      json['to_uid'] ?? json['apply_uid'] ?? json['from_uid'],
    );
    final applicantName = _string(
      json['to_name'] ?? json['apply_name'] ?? json['name'] ?? json['nickname'],
    );
    final status = _int(json['status']);
    return ChatFriendRequest(
      uid: applicantUid,
      token: _string(json['token']),
      name: applicantName.isEmpty ? applicantUid : applicantName,
      message: _string(json['remark'] ?? json['message']),
      accepted: status == 1 || _int(json['accepted']) == 1,
      refused: status == 2,
    );
  }

  static ChatLabel _labelFromJson(Object? value) {
    final json = _readMap(value);
    // server `modules/label/api.go` 返回结构:
    //   members: [{uid, name}, ...]
    //   groups:  [{group_no, group_name}, ...]
    // 之前直接 `_string(item)` 把 dict toString 转成 "{uid: xxx, name: yyy}"
    // 字符串, 让 memberUids 里全是错字符串 — 反查 contacts 找不到,
    // editor 重复添加同一人 Set 不去重 (key 是错字符串不是 uid), server
    // count 持续增加. 对齐 iOS LLLabelResp.fromMap (LLLabelListVM.m:79).
    final memberUids = _readList(json['members'])
        .map(_readMap)
        .map((m) => _string(m['uid']))
        .where((u) => u.isNotEmpty)
        .toList();
    final groupNos = _readList(json['groups'])
        .map(_readMap)
        .map((m) => _string(m['group_no']))
        .where((g) => g.isNotEmpty)
        .toList();
    return ChatLabel(
      id: _string(json['id'] ?? json['_id'] ?? json['label_id']),
      name: _string(json['name']),
      memberUids: memberUids,
      groupNos: groupNos,
      count: _int(json['count'], fallback: memberUids.length + groupNos.length),
    );
  }

  static ChatFavorite _favoriteFromJson(Object? value) {
    final json = _readMap(value);
    final payload = _readMap(json['payload']);
    return ChatFavorite(
      id: _string(json['unique_key'] ?? json['id'] ?? json['no']),
      authorUid: _string(json['author_uid']),
      authorName: moyuDisplayName(
        name: _string(json['author_name']),
        rawIdentity: _string(json['author_uid']),
        placeholder: '',
      ),
      type: _int(json['type']),
      content: _string(payload['content'] ?? json['content']),
      createdAt: _string(json['created_at'] ?? json['createdAt']),
    );
  }

  static ChatStickerPack _stickerPackFromJson(Object? value) {
    final json = _readMap(value);
    final category = _string(json['category']);
    final title = _string(json['title'] ?? json['name'] ?? category);
    return ChatStickerPack(
      category: category,
      title: title.isEmpty ? category : title,
      desc: _string(json['desc'] ?? json['description']),
      cover: _string(json['cover']),
      coverLimit: _string(json['cover_lim'] ?? json['coverLimit']),
      added: _int(json['status']) == 1 || _truthy(json['added']),
    );
  }

  static List<ChatStickerPack> _dedupeStickerPacksByCategory(
    Iterable<ChatStickerPack> packs,
  ) {
    final byCategory = <String, ChatStickerPack>{};
    for (final pack in packs) {
      final category = pack.category.trim();
      if (category.isEmpty) {
        continue;
      }
      final existing = byCategory[category];
      byCategory[category] = existing == null
          ? pack
          : _mergeStickerPack(existing, pack);
    }
    return byCategory.values.toList(growable: false);
  }

  static ChatStickerPack _mergeStickerPack(
    ChatStickerPack current,
    ChatStickerPack incoming,
  ) {
    final winner = _stickerPackScore(incoming) > _stickerPackScore(current)
        ? incoming
        : current;
    return ChatStickerPack(
      category: winner.category,
      title: winner.title,
      desc: winner.desc,
      cover: winner.cover,
      coverLimit: winner.coverLimit,
      added: current.added || incoming.added,
    );
  }

  static int _stickerPackScore(ChatStickerPack pack) {
    var score = 0;
    if (pack.coverLimit.isNotEmpty) score += 16;
    if (_isHttpUrl(pack.coverLimit)) score += 8;
    if (pack.cover.isNotEmpty) score += 4;
    if (_isHttpUrl(pack.cover)) score += 2;
    if (pack.title.isNotEmpty && pack.title != pack.category) score += 1;
    return score;
  }

  static bool _isHttpUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  static ChatStickerPackDetail _stickerDetailFromJson(Object? value) {
    final json = _readMap(value);
    final category = _string(json['category']);
    final title = _string(json['title'] ?? json['name'] ?? category);
    return ChatStickerPackDetail(
      category: category,
      title: title.isEmpty ? category : title,
      desc: _string(json['desc'] ?? json['description']),
      cover: _string(json['cover']),
      coverLimit: _string(json['cover_lim'] ?? json['coverLimit']),
      added: _truthy(json['added']) || _int(json['status']) == 1,
      stickers: _readList(
        json['list'] ?? json['stickers'],
      ).map(_stickerFromJson).toList(),
    );
  }

  static ChatSticker _stickerFromJson(Object? value) {
    final json = _readMap(value);
    return ChatSticker(
      path: _string(json['path'] ?? json['url']),
      title: _string(json['title'] ?? json['name']),
      placeholder: _string(json['placeholder']),
      category: _string(json['category']),
      format: _string(json['format']),
      width: _int(json['width']),
      height: _int(json['height']),
      searchableWord: _string(
        json['searchable_word'] ?? json['searchableWord'],
      ),
    );
  }

  static ChatDevice _deviceFromJson(Object? value) {
    final json = _readMap(value);
    final id = _string(json['device_id'] ?? json['id'] ?? json['device_no']);
    final name = _string(
      json['device_name'] ?? json['deviceName'] ?? json['name'] ?? id,
    );
    return ChatDevice(
      id: id,
      name: name.isEmpty ? id : name,
      platform: _string(
        json['device_type'] ?? json['deviceType'] ?? json['os'],
      ),
      lastLogin: _string(
        json['last_login'] ?? json['lastLogin'] ?? json['updated_at'],
      ),
      current: _int(json['current'] ?? json['is_current']) == 1,
    );
  }

  static ChatQrCode _qrCodeFromJson(Object? value) {
    final json = _readMap(value);
    return ChatQrCode(
      data: _string(json['data'] ?? json['qrcode'] ?? json['qr_code']),
      day: _int(json['day']),
      expire: _string(json['expire'] ?? json['expired_at']),
    );
  }

  static ChatScanResult _scanResultFromJson(Object? value, {String raw = ''}) {
    final json = _readMap(value);
    return ChatScanResult(
      forward: _string(json['forward']),
      type: _string(json['type']),
      data: Map<String, Object?>.from(_readMap(json['data'])),
      raw: raw,
    );
  }

  static ChatInviteCode _inviteCodeFromJson(Object? value) {
    final json = _readMap(value);
    return ChatInviteCode(
      code: _string(json['invite_code'] ?? json['inviteCode']),
      enabled: _truthy(json['status'], fallback: true),
    );
  }

  static ChatAppModule _appModuleFromJson(Object? value) {
    final json = _readMap(value);
    final status = _int(json['status'], fallback: 1);
    return ChatAppModule(
      sid: _string(json['sid']),
      name: _string(json['name']),
      description: _string(json['desc'] ?? json['description']),
      enabled: status != 0,
      checked:
          status == 2 || _int(json['checked']) == 1 || json['checked'] == true,
      locked: status == 2,
    );
  }

  static ChatAppVersion _appVersionFromJson(Object? value) {
    final json = _readMap(value);
    return ChatAppVersion(
      os: _string(json['os']),
      appVersion: _string(json['app_version'] ?? json['appVersion']),
      force: _int(json['is_force'] ?? json['isForce']) == 1,
      updateDescription: _string(
        json['update_desc'] ?? json['updateDesc'] ?? json['notes'],
      ),
      downloadUrl: _string(json['download_url'] ?? json['downloadUrl']),
      createdAt: _string(json['created_at'] ?? json['createdAt']),
    );
  }

  static ChatBackground _chatBackgroundFromJson(Object? value) {
    final json = _readMap(value);
    return ChatBackground(
      cover: _string(json['cover']),
      url: _string(json['url']),
      isSvg: _int(json['is_svg'] ?? json['isSvg']) == 1,
      lightColors: _readList(
        json['light_colors'] ?? json['lightColors'],
      ).map(_string).toList(),
      darkColors: _readList(
        json['dark_colors'] ?? json['darkColors'],
      ).map(_string).toList(),
    );
  }

  static ChatPhoneContact _phoneContactFromJson(Object? value) {
    final json = _readMap(value);
    return ChatPhoneContact(
      name: _string(json['name']),
      phone: _string(json['phone']),
      zone: _string(json['zone']),
      uid: _string(json['uid']),
      vercode: _string(json['vercode']),
      isFriend: _int(json['is_friend'] ?? json['isFriend']) == 1,
    );
  }

  static Iterable<ChatReportCategory> _reportCategoriesFromJson(Object? value) {
    final json = _readMap(value);
    final category = ChatReportCategory(
      no: _string(json['category_no'] ?? json['categoryNo']),
      name: _string(json['category_name'] ?? json['categoryName']),
    );
    return [
      if (category.no.isNotEmpty && category.name.isNotEmpty) category,
      for (final child in _readList(json['children']))
        ..._reportCategoriesFromJson(child),
    ];
  }

  static ChatMoment _momentFromJson(Object? value) {
    final json = _readMap(value);
    final publisherUid = _string(json['publisher'] ?? json['publisher_uid']);
    final publisherName = _string(
      json['publisher_name'] ?? json['publisherName'] ?? publisherUid,
    );
    return ChatMoment(
      momentNo: _string(json['moment_no'] ?? json['momentNo']),
      publisherUid: publisherUid,
      publisherName: publisherName.isEmpty ? publisherUid : publisherName,
      text: _string(json['text']),
      createdAt: _string(json['created_at'] ?? json['createdAt']),
      privacyType: _string(json['privacy_type'] ?? json['privacyType']),
      privacyUids: _readList(
        json['privacy_uids'] ?? json['privacyUids'],
      ).map(_string).toList(),
      videoPath: _string(json['video_path'] ?? json['videoPath']),
      videoCoverPath: _string(
        json['video_cover_path'] ?? json['videoCoverPath'],
      ),
      imgs: _readList(json['imgs']).map(_string).toList(),
      address: _string(json['address']),
      longitude: _string(json['longitude']),
      latitude: _string(json['latitude']),
      remindUids: _readList(
        json['remind_uids'] ?? json['remindUids'],
      ).map(_string).toList(),
      likes: _readList(json['likes']).map(_momentLikeFromJson).toList(),
      comments: _readList(
        json['comments'],
      ).map(_momentCommentFromJson).toList(),
    );
  }

  static ChatMomentLike _momentLikeFromJson(Object? value) {
    final json = _readMap(value);
    return ChatMomentLike(
      uid: _string(json['uid']),
      name: _string(json['name']),
    );
  }

  static ChatMomentComment _momentCommentFromJson(Object? value) {
    final json = _readMap(value);
    return ChatMomentComment(
      id: _string(json['id'] ?? json['sid']),
      uid: _string(json['uid']),
      name: _string(json['name']),
      content: _string(json['content']),
      replyUid: _string(json['reply_uid'] ?? json['replyUid']),
      replyName: _string(json['reply_name'] ?? json['replyName']),
      commentAt: _string(json['comment_at'] ?? json['commentAt']),
    );
  }

  static ChatMomentSetting _momentSettingFromJson(Object? value) {
    final json = _readMap(value);
    return ChatMomentSetting(
      hideMy: _int(json['is_hide_my'] ?? json['hide_my']) == 1,
      hideHis: _int(json['is_hide_his'] ?? json['hide_his']) == 1,
    );
  }

  static List<dynamic> _readList(Object? value) {
    if (value is List) {
      return value;
    }
    final map = _readMap(value);
    for (final key in ['data', 'list', 'items']) {
      final item = map[key];
      if (item is List) {
        return item;
      }
    }
    return const [];
  }

  static Map<String, dynamic> _readMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const {};
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static String _stripSearchMarkup(String value) {
    return value.replaceAll('<mark>', '').replaceAll('</mark>', '');
  }

  static String _digestPassword({
    required String uid,
    required String password,
  }) => lockScreenDigest(uid: uid, password: password);

  static int _int(Object? value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _truthy(Object? value, {bool fallback = false}) {
    if (value == null) {
      return fallback;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final text = value.toString().trim().toLowerCase();
    if (text.isEmpty) {
      return fallback;
    }
    return text == '1' || text == 'true' || text == 'yes';
  }
}
