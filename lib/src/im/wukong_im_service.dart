import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/db/const.dart';
import 'package:wukongimfluttersdk/db/conversation.dart';
import 'package:wukongimfluttersdk/db/reaction.dart';
import 'package:wukongimfluttersdk/db/reminder.dart';
import 'package:wukongimfluttersdk/db/wk_db_helper.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_image_content.dart';
import 'package:wukongimfluttersdk/model/wk_media_message_content.dart';
import 'package:wukongimfluttersdk/model/wk_message_content.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/model/wk_card_content.dart';
import 'package:wukongimfluttersdk/model/wk_video_content.dart';
import 'package:wukongimfluttersdk/model/wk_voice_content.dart';
import 'package:wukongimfluttersdk/proto/proto.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../auth/user_session.dart';
import '../db/database.dart';
import '../media/chat_media_service.dart';
import '../modules/feature_registry.dart';
import '../modules/module_ids.dart';
import '../network/api_client.dart';
import '../server/server_profile.dart';
import '../social/social_service.dart';
import '../ui/identity_display.dart';
import 'message_content_registration.dart';
import 'typing_label_logic.dart';

/// 内置系统账号 uid — 跟 server `configs/tsdd.yaml` 默认值 + iOS 原版
/// `WKAppConfig.m:94-95` (`self.systemUID = @"u_10000"; self.fileHelperUID
/// = @"fileHelper";`) 对齐. 原版放在 `WKAppConfig` 集中类里, chatim 没建
/// 等价 config 类, 集中到 im_service 顶部. server 部署改 systemUID 时要
/// 同步改这两个常量.
const String kSystemUID = 'u_10000';
const String kFileHelperUID = 'fileHelper';

/// BotFather 早期 bot 创建入口的系统账号 UID, **已废弃** — 创建 bot 改走
/// 「我的 Bots」入口 (发现页 → POST /v1/bots)。此常量现仅用于通讯录隐藏可能
/// 残留的 BotFather 数据 (见 home_shell `_contacts` 过滤)。
/// 必须跟 server `modules/base/sysaccount.BotFatherUID` 一致。
const String kBotFatherUID = '____botfather____';

const int _wkGifContentType = ModuleMessageContentTypeIds.gifSticker;
const int _wkLocationContentType = ModuleMessageContentTypeIds.location;
// _wkCardContentType (= 7) is implicitly handled by the SDK's
// WkMessageContentType.card constant; we don't redeclare it here.
const int _wkMergeForwardContentType = 11;
const int _wkLottieStickerContentType =
    ModuleMessageContentTypeIds.lottieSticker;
const int _wkEmojiStickerContentType = ModuleMessageContentTypeIds.emojiSticker;
// Live Photo = 静态图 + paired motion MOV 配对发送 (iOS Live Photo,
// 协议形态参考 Telegram Bot API LivePhoto). 接收端展示静态图 + LIVE 角标,
// 点击全屏播放 MOV (含声音). iOS 原版没做, 这是项目内自造协议 - 单独一个
// content type 避免污染现有 video=5 / image=2 语义.
//
// **避开 14** (= WK_RICHTEXT, WuKongIM 上游协议占用 — WKConstant.h:313 +
// 本文件 _genericContentLabels[14]='[富文本]'). 用 15: iOS WKConstant.h 0
// 占用, server _genericContentLabels 也没注册.
const int _wkLivePhotoContentType = 15;
const int _wkScreenshotContentType = 20;
const int _wkGroupApproveContentType = 1009;

const String wukongStreamNoKey = 'wukong_stream_no';
const String wukongStreamSeqKey = 'wukong_stream_seq';
const String wukongStreamFlagKey = 'wukong_stream_flag';
const String wukongStreamPayloadKey = 'wukong_stream_payload';

typedef WukongAvatarInvalidationTarget = ({
  String avatarPath,
  String channelId,
  int channelType,
});

abstract interface class ChatImGateway {
  /// 当前 app session 的全局单例 — _HomeShellState initState 时 set,
  /// dispose 清. 跟 UserSession.current / MomentMsgService.current 同模式,
  /// 给那些没法走 widget tree 透传 imGateway 的入口用 (例如 group_pages
  /// 内 GroupManagePage 跨 GroupListPage / chat_settings 多层 thread
  /// 麻烦). 1 个 app session 只有 1 个 IM gateway, 单例语义本来就成立.
  static ChatImGateway? current;

  Stream<List<WukongConversationSnapshot>> get conversationSnapshots;

  Stream<WukongMessageSnapshot> get messageSnapshots;

  Stream<WukongAguiEventSnapshot> get aguiEventSnapshots;

  /// Emits the current set of channels where the remote peer is typing.
  /// Each entry's key is `${channelType}_${channelId}` and value is the
  /// label to render (e.g. "对方正在输入..." or "{name} 正在输入...").
  /// Entries auto-expire after 5 seconds without a fresh `typing` CMD.
  Stream<Map<String, String>> get typingSnapshots;

  /// Emits a single event when the IM connection is dropped because
  /// the same account logged in on another device. Mirrors iOS native
  /// `WKConnectionManagerDelegate.onKick:` — the app is expected to
  /// clear local session, show "账号已在其他设备上登录" and bounce to
  /// the login screen.
  Stream<void> get kickedSignals;

  /// IM 长连接状态变化 broadcast. 对齐 iOS WKConversationListVC.refreshTitle
  /// 用于聊天列表顶部标题 (连接中 / 收取中 / 已断开 / 不可用) + 网络错误
  /// banner. 订阅方应初始用 `currentConnectionStatus` seed UI, 然后随
  /// stream event 实时更新.
  Stream<ChatConnectionStatus> get connectionStatusSignals;

  /// 同步快照 — 给 widget initState 用, 不依赖 stream 第一次 emit.
  ChatConnectionStatus get currentConnectionStatus;

  /// Fires whenever the server pushes a friend-relationship change
  /// (`friendRequest` / `friendAccept` / `friendDeleted` CMDs over the
  /// IM long-connection). Subscribers re-pull `loadSnapshot()` from
  /// the social gateway so the contacts / friend-requests list stays
  /// live without the user pulling-to-refresh.
  Stream<void> get friendChangeSignals;

  /// Fires when the IM long-connection delivers an `rtc.p2p.*` CMD
  /// (invoke / accept / refuse / cancel / hangup). The UI layer
  /// subscribes at app-shell scope so an `invoke` from any peer pushes
  /// the incoming-call page on top of the entire stack, mirroring
  /// iOS `WKRTCManager.onCmd:WKCMDRTCP2PInvoke`.
  Stream<IncomingCallEvent> get incomingCallSignals;

  /// Fires when the server pushes `syncPinnedMessage` CMD for some
  /// channel —— A 端置顶 / 取消置顶后服务端 broadcast 给所有该 channel
  /// 订阅者，B 端要据此 re-fetch /message/pinned/sync 拉增量更新本地
  /// pin banner / pin 列表。
  ///
  /// 对齐 iOS WKPinnedModule.cmdManager:onCMD: ——iOS 收到 CMD 直接调
  /// `WKPinnedService.requestSyncPinnedMessages(channel)`。Flutter 没有
  /// 全局 pinnedMessageManager，pin 数据由各 _ChatScreenState 自己持有，
  /// 所以走 stream 让 chat screen 订阅匹配当前 channel 后 re-fetch。
  Stream<WukongPinnedSyncSignal> get pinnedSyncSignals;

  /// Fires after reconnect hydration determines that the active group
  /// conversation should refresh its member roster. IM 层只发 channel
  /// signal；真正的 membersync 仍由 chat 页面通过 social gateway 执行，
  /// 避免 IM gateway 反向依赖 social service。
  Stream<WukongGroupMemberSyncSignal> get groupMemberSyncSignals;

  /// Fires after reconnect hydration so an already-open favorites page
  /// can re-pull `favorite/my`. 收藏列表三端都不持久化；IM 层只发
  /// signal，页面继续通过 social gateway 拉服务端真相源。
  Stream<void> get favoriteSyncSignals;

  /// 朋友圈通知 CMD push (`cmd == "momentMsg"`)。各 action (like /
  /// comment / delete_comment / publish) 走同一个 stream, 订阅方 (一般是
  /// MomentMsgService) 自己根据 action 入库 + 累计未读. 对齐 iOS
  /// WKMomentMsgManager.recvMomentCMDMsg 委派模型.
  Stream<WukongMomentMsgSignal> get momentMsgSignals;

  /// 频道消息被清空通知 (远端 / 本端 / 跨设备). 触发源:
  /// 1. SDK `addOnClearChannelMsgListener` (其它设备清空, sync 过来)
  /// 2. 远端 `messageEerase` CMD (非 from 模式 = 整个 channel 清)
  /// 3. 本地 `clearConversationMessages` 调 SDK clearWithChannel
  ///
  /// 订阅方 (HomeShell / ChatScreen) 收到后清自己内存的 _messages /
  /// _messageThreads, 否则 SDK 已删但内存列表还在 → 切走再回会重新渲染
  /// (清空"假删除" bug). 对齐 iOS WKChatManagerDelegate clearMessages
  Stream<WukongChannelClearedSignal> get channelClearedSignals;

  /// 单条消息被删通知 (远端撤回 / 本端删除 / 跨设备 sync). 触发源:
  /// SDK `addOnDeleteMsgListener` — clientMsgNo 维度. 订阅方按
  /// clientMsgNo 从内存列表 removeWhere.
  Stream<String> get messageDeletedSignals;

  /// Synchronous snapshot of the current typing map. Mirrors
  /// `typingSnapshots` but readable on demand so a freshly-opened
  /// chat screen can seed its header subtitle without having to wait
  /// for the next broadcast event (which only fires on a state
  /// change). Returns `const {}` when nobody is typing.
  Map<String, String> get currentTypingSnapshot;

  /// Query online/last-seen status for the given uids.
  /// Returns map keyed by uid; missing entries indicate unknown status.
  Future<Map<String, ChatUserPresence>> queryUserPresence(List<String> uids);

  /// Re-fetch a channel's metadata (name / avatar cache key / mute /
  /// pin / etc) from the server and rebroadcast updated conversation
  /// snapshots. Mirrors the iOS native call site that runs after any
  /// group-info edit (rename / avatar upload / notice change) so the
  /// conversation list cell + chat header refresh without waiting for
  /// the IM long-connection's group-update push.
  Future<void> refreshChannel({
    required String channelId,
    required int channelType,
  });

  Future<List<WukongConversationSnapshot>> loadConversations();

  /// Sync getter: 上一次 `loadConversations()` 的结果, 用于 cold-start
  /// first frame 直接 seed UI 列表, 跳过 "空列表 → 200ms 后填充" 的过渡感.
  /// `main.dart _activateSession` 在 connect 后 await 一次 loadConversations
  /// 预热 cache, HomeShell.initState sync 读这个 getter 立即填 _conversations.
  /// 后续 loadConversations 调用也会刷新这个 cache.
  /// 没预加载 / 调过失败 → null.
  List<WukongConversationSnapshot>? get cachedConversations;

  /// SDK 本地 channel 表的 `follow=1 AND status=normal AND channel_type=personal`
  /// 行 = 本地缓存的好友列表. 对齐 iOS WKContactsVC.requestData
  /// (`WKChannelInfoDB queryChannelInfosWithStatusAndFollow:`):
  /// 应用层 cold-start 直接读这条数据立即 emit, 之后后台调
  /// `ChatSocialGateway.loadSnapshot` API 校准. 缺字段 (subtitle / role /
  /// vercode / version / sourceDescription) 走 `WKChannel.localExtra` JSON.
  /// 数据来源:
  /// - 首次启动: 表为空, 返回 []
  /// - 之后: 由 [writeFriendsToCache] 写入 (API fetch 完成时调用)
  /// SDK db 文件按 uid 隔离 (`wk_<uid>.db`), 切账号不串台.
  Future<List<ChatContact>> loadCachedFriends();

  /// API fetch 完成后调用, 把好友列表写回 SDK `channel` 表 (`follow=1`).
  /// 对齐 iOS CMD `friendAccept` / channel info auto-sync 后的写回行为.
  /// 内部走 `WKIM.shared.channelManager.addOrUpdateChannels`, 同 channelID
  /// 已存在则 update, 不存在则 insert.
  Future<void> writeFriendsToCache(List<ChatContact> contacts);

  Future<List<WukongMessageSnapshot>> loadMessages({
    required String channelId,
    required int channelType,
    int limit = 30,
    int beforeSeq = 0,
  });

  Future<void> sendText({
    required String channelId,
    required int channelType,
    required String text,
    List<String> mentionUids,
    bool mentionAll,
    // Reply / quote target. When `replyMessageId` is non-empty the
    // outgoing WKTextContent carries a WKReply payload so the
    // peer/server records the quote linkage and the bubble renders
    // the original message as a quote header. Mirrors iOS
    // `WKConversationContext.replyMessage` field.
    String replyMessageId,
    int replyMessageSeq,
    String replyFromUid,
    String replyFromName,
    String replyText,
  });

  Future<void> sendMedia({
    required String channelId,
    required int channelType,
    required ChatMediaAttachment attachment,
  });

  Future<void> persistFailedMedia({
    required String channelId,
    required int channelType,
    required ChatMediaAttachment attachment,
  });

  Future<void> sendSticker({
    required String channelId,
    required int channelType,
    required ChatSticker sticker,
  });

  Future<void> sendLocation({
    required String channelId,
    required int channelType,
    required ChatLocation location,
  });

  /// Forward a contact card (`WKCardContent`, contentType 7). Used by the
  /// long-press 转发 path and by 多选 → 逐条转发 when a selected message
  /// is a card bubble. Receiver renders via `_CardBubble`.
  ///
  /// `vercode` carries the `WKCardContent.vercode` from the original
  /// card so receivers can use auto-add-friend without the verification
  /// round-trip. Pass empty when forwarding a card we don't have a code
  /// for (or for a fresh card with no auto-add behavior).
  Future<void> sendCard({
    required String channelId,
    required int channelType,
    required String cardUid,
    required String cardName,
    String vercode,
  });

  /// Send a merge-forward bubble (`WKMergeForwardContent`, contentType 11)
  /// to the target channel. The full per-entry payload travels inline; the
  /// receiver renders a single bubble + tap-to-detail page. Used by 多选
  /// → 合并转发 in the chat action sheet.
  Future<void> sendMergeForward({
    required String channelId,
    required int channelType,
    required WKMergeForwardContent content,
  });

  /// Broadcast a "I just took a screenshot" notice to a channel — peers
  /// see a centered "{name}在聊天中截屏了" system row. Server contentType
  /// 20 (WK_SCREENSHOT). Best-effort; failure is silent.
  Future<void> sendScreenshotNotice({
    required String channelId,
    required int channelType,
    // Display name to broadcast in the WKScreenshotContent payload's
    // `from_name`. Receivers render "{name}在聊天中截屏了"; when this
    // is empty and the receiver's local channel cache doesn't have the
    // sender's channel info yet, they fall back to the raw uid hash —
    // hence the "其他机出现但是id会错误" bug. Pass the caller's
    // current login display name to avoid that.
    String senderName,
  });

  Future<void> clearUnread({
    required UserSession session,
    required String channelId,
    required int channelType,
  });

  Future<void> deleteConversation({
    required String channelId,
    required int channelType,
  });

  Future<void> updateChannelSetting({
    required String channelId,
    required int channelType,
    required Map<String, dynamic> setting,
  });

  Future<void> clearConversationMessages({
    required String channelId,
    required int channelType,
    int messageSeq = 0,
  });

  Future<void> clearAllMessages();

  Future<void> deleteMessages(List<WukongMessageReference> messages);

  Future<void> mutualDeleteMessages(List<WukongMessageReference> messages);

  Future<void> revokeMessage(WukongMessageReference message);

  Future<void> editMessage({
    required WukongMessageReference message,
    required String content,
  });

  Future<void> markMessagesRead({
    required String channelId,
    required int channelType,
    required List<String> messageIds,
  });

  Future<void> markVoiceMessageRead(WukongMessageReference message);

  /// Tell the gateway which channel the user is currently looking at. Used
  /// as a fallback target for server-pushed `syncMessageExtra` cmds that
  /// arrive without a `param` payload (1:1 receipt acks frequently do).
  void setActiveChannel({required String channelId, required int channelType});

  /// Clear the active-channel marker (chat screen disposed / backgrounded).
  void clearActiveChannel();

  /// Pull the channel's incremental message_extra rows from the server and
  /// merge them into the SDK's local DB so the standard refresh listeners
  /// fire. Idempotent and best-effort. Use on chat-open as a safety net in
  /// case the server's `syncMessageExtra` cmd fired before the listener
  /// was wired up.
  Future<void> syncAndStoreMessageExtras({
    required String channelId,
    required int channelType,
  });

  Future<void> sendTyping({
    required String channelId,
    required int channelType,
  });

  Future<void> purgeChannelMessages({
    required String channelId,
    required int channelType,
  });

  Future<void> setChannelMessageAutoDelete({
    required String channelId,
    required int channelType,
    required int retentionSeconds,
  });

  Future<List<Map<String, dynamic>>> getMessageReceipts({
    required String messageId,
    required bool readed,
    int pageIndex = 1,
    int pageSize = 100,
  });

  Future<List<Map<String, dynamic>>> syncMessageExtras({
    required String channelId,
    required int channelType,
    int extraVersion = 0,
    String source = '',
    int limit = 100,
  });

  Future<ChatSensitiveWords> syncSensitiveWords({int version = 0});

  /// In-memory cache of the most recent sensitive-words sync. Mirrors
  /// native iOS `WKSecurityTipManager.shared` which caches the list
  /// after the first server fetch. Empty until `warmSensitiveWords()`
  /// has run at least once, then incrementally refreshed by passing
  /// the previous version to subsequent syncs. UI code reads this to
  /// render the inline 可能涉及敏感信息 warning row under received
  /// text bubbles.
  ChatSensitiveWords get cachedSensitiveWords;

  /// Lazy-load + refresh the sensitive-words cache. Calls
  /// `syncSensitiveWords` with the cached version so the server only
  /// returns a fresh payload when the list has actually changed.
  /// Safe to call repeatedly; concurrent calls coalesce to one HTTP
  /// request. No-op if the gateway is offline / unconfigured.
  Future<ChatSensitiveWords> warmSensitiveWords();

  Future<List<Map<String, dynamic>>> syncProhibitWords({int version = 0});

  Future<List<Map<String, dynamic>>> syncReminders({
    int version = 0,
    int limit = 100,
    List<String> channelIds = const [],
  });

  Future<void> markRemindersDone(List<int> ids);

  Future<void> sendReaction({
    required String messageId,
    required String channelId,
    required int channelType,
    required String emoji,
  });

  Future<List<Map<String, dynamic>>> syncReactions({
    required String channelId,
    required int channelType,
    int seq = 0,
    int limit = 100,
  });

  /// 拉某条消息的 per-user reaction list (本地 ReactionDB), 给"N 人回应"
  /// 列表页用. 对齐 iOS WKReactionsListVC.reactions (= message.reactions
  /// per-user list). 返每行 {uid, name, emoji}, 已 filter isDeleted=1 删除行.
  Future<List<Map<String, Object>>> queryReactionUsers(String messageId);

  /// 拉某条消息的已读/未读用户列表, 给"N 人已读" 列表页用. 对齐 iOS
  /// WKReceiptClient (WuKongAdvanced/.../WKReceiptClient.m):
  ///   `GET /messages/<messageId>/receipt?readed=1/0&channel_id=&channel_type=`
  /// 返每行 {uid, name}. readed=true 拿已读 list, readed=false 拿未读.
  Future<List<Map<String, String>>> queryMessageReceipt({
    required String messageId,
    required String channelId,
    required int channelType,
    required bool readed,
  });

  /// Fetch the channel's reaction delta from server and persist into the
  /// SDK's local reaction DB so each WKMsg's `reactionList` repopulates
  /// on subsequent `getOrSyncHistoryMessages` reads. Mirrors iOS
  /// WKReactionManager.sync(channel) which is called from
  /// `WKMessageListView.viewDidLoad`. Without this, every chat re-open
  /// shows an empty reaction strip because the local DB was never
  /// hydrated even though the user clicked an emoji earlier.
  Future<void> syncAndStoreReactions({
    required String channelId,
    required int channelType,
  });

  Future<void> ackConversationSync({
    required int cmdVersion,
    required String deviceUuid,
  });

  Future<List<Map<String, dynamic>>> syncConversationExtras({int version = 0});

  Future<void> updateConversationExtra({
    required String channelId,
    required int channelType,
    int browseTo = 0,
    int keepMessageSeq = 0,
    int keepOffsetY = 0,
    String draft = '',
  });

  Future<void> pinMessage(WukongMessageReference message);

  Future<List<WukongPinnedMessageSnapshot>> syncPinnedMessages({
    required String channelId,
    required int channelType,
    int version = 0,
  });

  Future<void> clearPinnedMessages({
    required String channelId,
    required int channelType,
  });

  Future<ChatMessageBackupResult> backupMessages();

  Future<ChatMessageRecoveryResult> recoverMessages();
}

class WukongImService implements ChatImGateway {
  WukongImService({required this.client, FeatureRegistry? featureRegistry})
    : _featureRegistry = featureRegistry;

  static const int _connectionTraceLimit = 200;
  static const _connectionListenerKey = 'wukong_im_service.kicked';
  static const _flutterGatewayKey = 'flutter_gateway';
  static const _cmdListenerKeys = <String>[
    'moyu_extra_sync',
    'moyu_channel_update',
    'moyu_group_avatar',
    'moyu_user_avatar',
    'moyu_member_update',
    'moyu_conv_update',
    'moyu_friend',
    'moyu_online_status',
    'moyu_msg_extras',
    'moyu_msg_erase',
    'moyu_sync_misc',
    'moyu_pinned_sync',
    'moyu_misc',
    'moyu_moment_msg',
    'moyu_all_cmd_tap',
    'moyu_rtc_p2p_invoke',
    'moyu_rtc_p2p_accept',
    'moyu_rtc_p2p_refuse',
    'moyu_rtc_p2p_cancel',
    'moyu_rtc_p2p_hangup',
    'moyu_rtc_p2p_switch_video',
    'moyu_rtc_p2p_switch_video_reply',
    'moyu_rtc_p2p_switch_voice',
    'moyu_rtc_room_invoke',
    'moyu_rtc_room_hangup',
    'moyu_rtc_room_refuse',
    'moyu_typing',
  ];

  final ApiClient client;
  final FeatureRegistry? _featureRegistry;
  bool _disposed = false;
  ImConnectGeneration _connectGeneration = const ImConnectGeneration(0);
  final List<ImConnectionTraceEntry> _connectionTrace =
      <ImConnectionTraceEntry>[];

  /// Cold-start fast-path 用. main 启动时 await loadConversations 预热 +
  /// HomeShell.initState sync 读. 接口 sync getter 实现.
  List<WukongConversationSnapshot>? _cachedConversations;
  @override
  List<WukongConversationSnapshot>? get cachedConversations =>
      _cachedConversations;

  final _conversationController =
      StreamController<List<WukongConversationSnapshot>>.broadcast();
  final _messageController =
      StreamController<WukongMessageSnapshot>.broadcast();
  final _aguiEventController =
      StreamController<WukongAguiEventSnapshot>.broadcast();
  final _typingController = StreamController<Map<String, String>>.broadcast();
  final _kickedController = StreamController<void>.broadcast();
  final _friendChangeController = StreamController<void>.broadcast();
  final _incomingCallController =
      StreamController<IncomingCallEvent>.broadcast();
  final _pinnedSyncController =
      StreamController<WukongPinnedSyncSignal>.broadcast();
  final _groupMemberSyncController =
      StreamController<WukongGroupMemberSyncSignal>.broadcast();
  final _favoriteSyncController = StreamController<void>.broadcast();
  final _momentMsgController =
      StreamController<WukongMomentMsgSignal>.broadcast();
  final _channelClearedController =
      StreamController<WukongChannelClearedSignal>.broadcast();
  final _messageDeletedController = StreamController<String>.broadcast();
  final _connectionStatusController =
      StreamController<ChatConnectionStatus>.broadcast();
  ChatConnectionStatus _currentConnectionStatus =
      ChatConnectionStatus.disconnected;

  List<ImConnectionTraceEntry> get connectionTraceSnapshot =>
      List<ImConnectionTraceEntry>.unmodifiable(_connectionTrace);

  ImConnectGeneration get currentConnectGeneration => _connectGeneration;

  Map<String, Object?> buildDiagnosticsSnapshot({DateTime? generatedAt}) {
    final connectionManager = WKIM.shared.connectionManager;
    return {
      'schemaVersion': 1,
      'generatedAt': (generatedAt ?? DateTime.now()).toIso8601String(),
      'uid': _sanitizeDiagnosticText(WKIM.shared.options.uid ?? ''),
      'disposed': _disposed,
      'currentConnectionStatus': _currentConnectionStatus.name,
      'connectGeneration': _connectGeneration.value,
      'sdk': {
        'isDisconnection': connectionManager.isDisconnection,
        'isReconnection': connectionManager.isReconnection,
        'isNetworkUnavailable': connectionManager.isNetworkUnavailable,
      },
      'activeChannel': {
        'channelId': _sanitizeDiagnosticText(_activeChannelId),
        'channelType': _activeChannelType,
      },
      'caches': {
        'cachedConversations': _cachedConversations?.length ?? 0,
        'processedPendingRooms': _processedPendingRoomIds.length,
        'typingChannels': _typingState.length,
        'voiceStatusEntries': _voiceStatusFromExtra.length,
      },
      'trace': {
        'limit': _connectionTraceLimit,
        'count': _connectionTrace.length,
        'events': _connectionTrace.map(_diagnosticTraceJson).toList(),
        'eventCounts': _diagnosticTraceEventCounts(),
      },
    };
  }

  String exportDiagnosticsJson({bool pretty = true, DateTime? generatedAt}) {
    final snapshot = buildDiagnosticsSnapshot(generatedAt: generatedAt);
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(snapshot);
    }
    return jsonEncode(snapshot);
  }

  Future<File> writeDiagnosticsSnapshot({bool pretty = true}) {
    return _writeBackupFile(
      exportDiagnosticsJson(pretty: pretty),
      suffix: 'im_diagnostics',
    );
  }

  /// Multi-typer state keyed by channelKey → `Map<typerKey, entry>`.
  /// `typerKey` is `from_uid` when the CMD provides one, otherwise
  /// `from_name` (or a sentinel for unnamed 1:1 events). Lets the
  /// aggregation render `X 和 Y 正在输入...` / `几位成员正在输入...`
  /// instead of overwriting on every fresh typing CMD.
  final Map<String, Map<String, _TypingEntry>> _typingState =
      <String, Map<String, _TypingEntry>>{};
  Timer? _typingSweep;
  String _activeChannelId = '';
  int _activeChannelType = 0;
  static const Duration _typingTtl = Duration(seconds: 5);

  @override
  Stream<List<WukongConversationSnapshot>> get conversationSnapshots =>
      _conversationController.stream;

  @override
  Stream<WukongMessageSnapshot> get messageSnapshots =>
      _messageController.stream;

  @override
  Stream<WukongAguiEventSnapshot> get aguiEventSnapshots =>
      _aguiEventController.stream;

  @override
  Stream<Map<String, String>> get typingSnapshots => _typingController.stream;

  @override
  Stream<void> get kickedSignals => _kickedController.stream;

  @override
  Stream<ChatConnectionStatus> get connectionStatusSignals =>
      _connectionStatusController.stream;

  @override
  Stream<WukongChannelClearedSignal> get channelClearedSignals =>
      _channelClearedController.stream;

  @override
  Stream<String> get messageDeletedSignals => _messageDeletedController.stream;

  @override
  ChatConnectionStatus get currentConnectionStatus => _currentConnectionStatus;

  @visibleForTesting
  void debugRecordConnectionTrace({
    required String event,
    String uid = '',
    ImConnectGeneration? generation,
    String status = '',
    String reason = '',
    String addr = '',
  }) {
    _recordConnectionTrace(
      event: event,
      uid: uid,
      generation: generation,
      status: status,
      reason: reason,
      addr: addr,
    );
  }

  ImConnectGeneration _nextConnectGeneration() {
    _connectGeneration = _connectGeneration.next();
    return _connectGeneration;
  }

  void _recordConnectionTrace({
    required String event,
    String uid = '',
    ImConnectGeneration? generation,
    String status = '',
    String reason = '',
    String addr = '',
  }) {
    final entry = ImConnectionTraceEntry(
      uid: uid.isNotEmpty ? uid : (WKIM.shared.options.uid ?? ''),
      connectGeneration: generation ?? _connectGeneration,
      event: event,
      status: status,
      reason: reason,
      addr: addr,
      timestamp: DateTime.now(),
    );
    _connectionTrace.add(entry);
    final overflow = _connectionTrace.length - _connectionTraceLimit;
    if (overflow > 0) {
      _connectionTrace.removeRange(0, overflow);
    }
  }

  Map<String, Object?> _diagnosticTraceJson(ImConnectionTraceEntry entry) {
    return {
      'uid': _sanitizeDiagnosticText(entry.uid),
      'connectGeneration': entry.connectGeneration.value,
      'event': _sanitizeDiagnosticText(entry.event),
      'status': _sanitizeDiagnosticText(entry.status),
      'reason': _sanitizeDiagnosticText(entry.reason),
      'addr': _sanitizeDiagnosticText(entry.addr),
      'timestamp': entry.timestamp.toIso8601String(),
    };
  }

  Map<String, int> _diagnosticTraceEventCounts() {
    final counts = <String, int>{};
    for (final entry in _connectionTrace) {
      final event = _sanitizeDiagnosticText(entry.event);
      counts[event] = (counts[event] ?? 0) + 1;
    }
    return counts;
  }

  static String _sanitizeDiagnosticText(String value) {
    var out = value;
    out = out.replaceAllMapped(
      RegExp(r'\bbearer\s+[A-Za-z0-9._~+/=-]+', caseSensitive: false),
      (_) => 'Bearer <redacted>',
    );
    out = out.replaceAllMapped(
      RegExp(
        '\\b(authorization|token|im[_-]?token|password|secret)(["\\\']?\\s*[:=]\\s*["\\\']?)[^,\\s"\\\'\\}]+',
        caseSensitive: false,
      ),
      (match) => '${match.group(1)}${match.group(2)}<redacted>',
    );
    return out;
  }

  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _typingSweep?.cancel();
    _typingSweep = null;
    _typingState.clear();
    _processedPendingRoomIds.clear();
    _voiceStatusFromExtra.clear();
    _voiceStatusHydration = null;
    WKIM.shared.connectionManager.removeOnConnectionStatus(
      _connectionListenerKey,
    );
    for (final key in _cmdListenerKeys) {
      WKIM.shared.cmdManager.removeCmdListener(key);
    }
    WKIM.shared.channelManager.removeOnRefreshListener(_flutterGatewayKey);
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener(
      _flutterGatewayKey,
    );
    WKIM.shared.messageManager.removeNewMsgListener(_flutterGatewayKey);
    WKIM.shared.messageManager.removeOnRefreshMsgListener(_flutterGatewayKey);
    WKIM.shared.eventManager.removeEventListener(_flutterGatewayKey);
    if (!_conversationController.isClosed) {
      unawaited(_conversationController.close());
    }
    if (!_messageController.isClosed) {
      unawaited(_messageController.close());
    }
    if (!_aguiEventController.isClosed) {
      unawaited(_aguiEventController.close());
    }
    if (!_typingController.isClosed) {
      unawaited(_typingController.close());
    }
    if (!_kickedController.isClosed) {
      unawaited(_kickedController.close());
    }
    if (!_friendChangeController.isClosed) {
      unawaited(_friendChangeController.close());
    }
    if (!_incomingCallController.isClosed) {
      unawaited(_incomingCallController.close());
    }
    if (!_pinnedSyncController.isClosed) {
      unawaited(_pinnedSyncController.close());
    }
    if (!_groupMemberSyncController.isClosed) {
      unawaited(_groupMemberSyncController.close());
    }
    if (!_favoriteSyncController.isClosed) {
      unawaited(_favoriteSyncController.close());
    }
    if (!_momentMsgController.isClosed) {
      unawaited(_momentMsgController.close());
    }
    if (!_channelClearedController.isClosed) {
      unawaited(_channelClearedController.close());
    }
    if (!_messageDeletedController.isClosed) {
      unawaited(_messageDeletedController.close());
    }
    if (!_connectionStatusController.isClosed) {
      unawaited(_connectionStatusController.close());
    }
    // SDK 单槽 listener — dispose 时显式清掉, 防止下一个 service 实例
    // remove API 可用, SDK 自身仅支持覆盖). 这里调置空封装方法.
    WKIM.shared.messageManager.removeClearChannelMsgListener(
      _flutterGatewayKey,
    );
    WKIM.shared.messageManager.removeDeleteMsgListener(_flutterGatewayKey);
  }

  @override
  Stream<void> get friendChangeSignals => _friendChangeController.stream;

  @override
  Stream<IncomingCallEvent> get incomingCallSignals =>
      _incomingCallController.stream;

  @override
  Stream<WukongPinnedSyncSignal> get pinnedSyncSignals =>
      _pinnedSyncController.stream;

  @override
  Stream<WukongGroupMemberSyncSignal> get groupMemberSyncSignals =>
      _groupMemberSyncController.stream;

  @override
  Stream<void> get favoriteSyncSignals => _favoriteSyncController.stream;

  @override
  Stream<WukongMomentMsgSignal> get momentMsgSignals =>
      _momentMsgController.stream;

  @override
  Map<String, String> get currentTypingSnapshot => _currentTypingMap();

  Future<void> connect(UserSession session) async {
    final generation = _nextConnectGeneration();
    _recordConnectionTrace(
      event: 'connect_start',
      uid: session.uid,
      generation: generation,
    );
    client.token = session.token;
    final options = Options.newDefault(
      session.uid,
      session.imToken,
      databaseScope: serverAccountScope(
        serverStorageScope(client.config),
        session.uid,
      ),
    );
    options.getAddr = (complete) async {
      try {
        final route = await client.getJson('users/${session.uid}/im');
        final addr = extractConnectAddress(route);
        _recordConnectionTrace(
          event: 'route_addr',
          uid: session.uid,
          generation: generation,
          addr: addr,
        );
        complete(addr);
      } catch (error) {
        _recordConnectionTrace(
          event: 'route_addr_fail',
          uid: session.uid,
          generation: generation,
          reason: error.toString(),
        );
        rethrow;
      }
    };

    await WKIM.shared.setup(options);

    // 立即 sync 加载本地敏感词缓存 (跟 iOS WKProhibitwordsService.load
    // 同模式 — viewDidLoad 之前先从本地 JSON 文件读). 让后续 chat 收到
    // 第一条消息时已经能做敏感词匹配, 不必等 server fetch.
    // server fetch 在 home_shell.initState 调 warmSensitiveWords 触发,
    // 返回 delta 后会 await prefs 写回 _saveSensitiveWordsToPrefs.
    await _loadSensitiveWordsFromPrefs();
    WKIM.shared.messageManager.registerMsgContent(
      _wkLivePhotoContentType,
      (dynamic data) => WKLivePhotoContent().decodeJson(data),
    );
    _registerExtendedMessageContents(featureRegistry: _featureRegistry);
    _registerSyncListeners(session);
    _registerTypingListener();
    _registerExtraSyncListener();
    _registerChannelUpdateListeners();
    _registerClearDeleteListeners();
    _registerAguiEventListener();
    _registerAllCmdTap();
    _registerModuleCmdListeners();
    // Reset in-memory voice-status cache before hydrating the
    // per-uid prefs slot. Without this an account switch could
    // leak the previous user's listened ids into the new session.
    _voiceStatusFromExtra.clear();
    _voiceStatusHydration = null;
    // Hydrate the voice-status side-channel from prefs so previously
    // listened voice messages stay listened across app restart even
    // before the next extra-sync round-trip lands. Per-uid scoping
    // (see `_voiceStatusPrefsKey`) prevents cross-account bleed.
    unawaited(_hydrateVoiceStatusFromPrefs());
    // Surface kicked-by-other-device events. The SDK sets
    // `WKConnectStatus.kicked` (=2) when the server pushes a
    // disconnect packet, mirroring native iOS `onKick:`. We pipe
    // that into a one-shot stream the app layer subscribes to so it
    // can drop the persisted session and bounce back to the login
    // screen with a "账号已在其他设备上登录" alert.
    WKIM.shared.connectionManager.addOnConnectionStatus(
      _connectionListenerKey,
      (status, reasonCode, info) {
        // Mirror to plain print so release iOS builds (where
        // debugPrint becomes a no-op for the console) still surface
        // the IM connection lifecycle when attached via `flutter
        // logs` / `flutter run --release`. Status codes (实际 Flutter
        // SDK packages/wukongimfluttersdk_patched/lib/type/const.dart):
        //   0 = fail / 1 = success / 2 = kicked / 3 = syncMsg
        //   4 = connecting / 5 = noNetwork / 6 = syncCompleted
        // ignore: avoid_print
        print('[im] connectionStatus=$status reasonCode=$reasonCode');
        if (status == WKConnectStatus.kicked && !_kickedController.isClosed) {
          _recordConnectionTrace(
            event: 'kicked',
            uid: session.uid,
            generation: generation,
            status: 'sdk:$status',
            reason: reasonCode?.toString() ?? '',
          );
          _kickedController.add(null);
        }
        // 同步 broadcast 给 UI 层 — 对齐 iOS WKConversationListVC.refreshTitle
        // 监听 connectionManager status 变化 + 显示对应标题/banner.
        final mapped = _mapConnectionStatus(status);
        _recordConnectionTrace(
          event: status == WKConnectStatus.success
              ? 'connect_success'
              : status == WKConnectStatus.fail
              ? 'connect_fail'
              : 'status_changed',
          uid: session.uid,
          generation: generation,
          status: 'sdk:$status${mapped == null ? '' : '/${mapped.name}'}',
          reason: reasonCode?.toString() ?? '',
        );
        if (mapped != null && _currentConnectionStatus != mapped) {
          _currentConnectionStatus = mapped;
          if (!_connectionStatusController.isClosed) {
            _connectionStatusController.add(mapped);
          }
        }
        if (status == WKConnectStatus.success) {
          unawaited(
            _runReconnectHydration(
              session,
              generation,
              trigger: 'connect_success',
            ),
          );
        }
      },
    );
    // ignore: avoid_print
    print('[im] connectionManager.connect() called for uid=${session.uid}');
    WKIM.shared.connectionManager.connect();
    unawaited(_emitConversations());
  }

  Future<void> recoverConnection(
    UserSession session, {
    String reason = 'recover',
    bool forceReconnect = false,
  }) async {
    _recordConnectionTrace(
      event: 'recovery_check',
      uid: session.uid,
      status: _currentConnectionStatus.name,
      reason: reason,
    );
    if (forceReconnect ||
        _currentConnectionStatus != ChatConnectionStatus.connected) {
      _recordConnectionTrace(
        event: 'recovery_reconnect',
        uid: session.uid,
        status: _currentConnectionStatus.name,
        reason: reason,
      );
      await connect(session);
      return;
    }
    await _runReconnectHydration(session, _connectGeneration, trigger: reason);
  }

  @visibleForTesting
  Future<void> debugRunReconnectHydration(
    UserSession session, {
    ImConnectGeneration? generation,
    String trigger = 'debug',
  }) {
    return _runReconnectHydration(
      session,
      generation ?? _connectGeneration,
      trigger: trigger,
    );
  }

  bool _isHydrationCurrent(String uid, ImConnectGeneration generation) {
    if (_disposed) return false;
    if (generation.value != _connectGeneration.value) return false;
    return (WKIM.shared.options.uid ?? '') == uid;
  }

  Future<void> _runReconnectHydration(
    UserSession session,
    ImConnectGeneration generation, {
    required String trigger,
  }) async {
    final uid = session.uid;
    if (!_isHydrationCurrent(uid, generation)) {
      _recordConnectionTrace(
        event: 'hydration_skip',
        uid: uid,
        generation: generation,
        reason: '$trigger:stale',
      );
      return;
    }
    _recordConnectionTrace(
      event: 'hydration_pipeline_start',
      uid: uid,
      generation: generation,
      reason: trigger,
    );

    void abortPipeline(String reason) {
      _recordConnectionTrace(
        event: 'hydration_pipeline_aborted',
        uid: uid,
        generation: generation,
        reason: reason,
      );
    }

    Future<bool> step(String domain, Future<void> Function() body) async {
      if (!_isHydrationCurrent(uid, generation)) {
        _recordConnectionTrace(
          event: 'hydration_skip',
          uid: uid,
          generation: generation,
          reason: '$domain:stale',
        );
        return false;
      }
      _recordConnectionTrace(
        event: 'hydration_start',
        uid: uid,
        generation: generation,
        reason: domain,
      );
      try {
        await body();
        if (!_isHydrationCurrent(uid, generation)) {
          _recordConnectionTrace(
            event: 'hydration_skip',
            uid: uid,
            generation: generation,
            reason: '$domain:stale',
          );
          return false;
        }
        _recordConnectionTrace(
          event: 'hydration_end',
          uid: uid,
          generation: generation,
          reason: domain,
        );
        return true;
      } catch (error) {
        _recordConnectionTrace(
          event: 'hydration_fail',
          uid: uid,
          generation: generation,
          reason: '$domain:$error',
        );
        return _isHydrationCurrent(uid, generation);
      }
    }

    final activeChannelId = _activeChannelId;
    final activeChannelType = _activeChannelType;
    final moduleHydrationHooks = _enabledHydrationHookIds();

    if (!await step('voice_status', _hydrateVoiceStatusFromPrefs)) {
      abortPipeline('voice_status');
      return;
    }
    if (!await step('conversations', _emitConversations)) {
      abortPipeline('conversations');
      return;
    }
    if (!await step('friend_snapshot_signal', () async {
      _emitFriendChangeSignal();
    })) {
      abortPipeline('friend_snapshot_signal');
      return;
    }
    if (moduleHydrationHooks.contains(ModuleHydrationHookIds.favoriteSync)) {
      if (!await step('favorites_signal', () async {
        _emitFavoriteSyncSignal();
      })) {
        abortPipeline('favorites_signal');
        return;
      }
    }

    if (activeChannelId.isNotEmpty && activeChannelType != 0) {
      if (!await step(
        'active_channel_info',
        () => _fetchAndCacheChannel(activeChannelId, activeChannelType),
      )) {
        abortPipeline('active_channel_info');
        return;
      }
      if (activeChannelType == WKChannelType.group) {
        if (!await step('active_group_members_signal', () async {
          _emitGroupMemberSyncSignal(activeChannelId, activeChannelType);
        })) {
          abortPipeline('active_group_members_signal');
          return;
        }
      }
      if (!await step(
        'active_message_extras',
        () => _syncMessageExtras(activeChannelId, activeChannelType),
      )) {
        abortPipeline('active_message_extras');
        return;
      }
      if (!await step(
        'active_reactions',
        () => syncAndStoreReactions(
          channelId: activeChannelId,
          channelType: activeChannelType,
        ),
      )) {
        abortPipeline('active_reactions');
        return;
      }
      if (moduleHydrationHooks.contains(
        ModuleHydrationHookIds.activePinnedSync,
      )) {
        if (!await step('active_pinned_signal', () async {
          if (!_pinnedSyncController.isClosed) {
            _pinnedSyncController.add(
              WukongPinnedSyncSignal(
                channelId: activeChannelId,
                channelType: activeChannelType,
              ),
            );
          }
        })) {
          abortPipeline('active_pinned_signal');
          return;
        }
      }
    }

    if (moduleHydrationHooks.contains(
      ModuleHydrationHookIds.rtcPendingInvites,
    )) {
      if (!await step(
        'rtc_pending_invites',
        () => _syncPendingRtcInvites(generation, trace: false),
      )) {
        abortPipeline('rtc_pending_invites');
        return;
      }
    }

    _recordConnectionTrace(
      event: 'hydration_pipeline_end',
      uid: uid,
      generation: generation,
      reason: trigger,
    );
  }

  Set<String> _enabledHydrationHookIds() {
    return (_featureRegistry?.enabledFeatures(
              kind: FeatureKind.hydrationHook,
            ) ??
            const Iterable<FeatureRegistration>.empty())
        .map((feature) => feature.id)
        .toSet();
  }

  /// Subscribe to the server-pushed `syncMessageExtra` cmd. The native
  /// server sends this over the IM long-connection whenever a message
  /// extra (read receipt, revoke, edit, voice-readed, mutual-delete)
  /// changes — there is no direct push of the new extra data, only a
  /// nudge to pull the channel's incremental changes from
  /// `POST /message/extra/sync`. Without this, the sender's bubble never
  /// flips from ✓ to ✓✓ because the SDK never learns the receipt landed.
  void _registerExtraSyncListener() {
    WKIM.shared.cmdManager.addOnCmdListener('moyu_extra_sync', (cmd) {
      if (cmd.cmd != 'syncMessageExtra') return;
      var channelId = '';
      var channelType = 0;
      final param = cmd.param;
      if (param is Map) {
        channelId = (param['channel_id'] ?? '').toString();
        channelType = _readInt(param['channel_type']);
      }
      // 1:1 receipt cmds frequently arrive with `param: null` — the
      // channel is implied by whichever chat the user is currently in.
      // Fall back to the active channel so we still know which slice
      // of the message_extra table to fetch.
      if (channelId.isEmpty || channelType == 0) {
        if (_activeChannelId.isEmpty || _activeChannelType == 0) return;
        channelId = _activeChannelId;
        channelType = _activeChannelType;
      }
      unawaited(_syncMessageExtras(channelId, channelType));
    });
  }

  /// Hook every server-pushed channel-info / member-info / avatar
  /// CMD into a local refresh so the UI stays in sync without the
  /// user pulling-to-refresh. The Go server emits these via the
  /// IM long-connection whenever someone (the user, an admin, or
  /// another device) edits group metadata — see
  /// `TangSengDaoDaoServerLib/common/constant.go` for the full list.
  /// Native iOS WuKongBase wires every CMD to a corresponding model
  /// invalidation; Flutter previously only listened for
  /// `syncMessageExtra` + `typing`, so renames / avatar uploads
  /// looked stale until the user manually refreshed.
  /// SDK clear/delete 事件桥接 — 把 `addOnClearChannelMsgListener` 和
  /// `addOnDeleteMsgListener` 转成 broadcast stream, 给 HomeShell /
  /// ChatScreen 订阅 (清自己内存的 _messages / _messageThreads).
  ///
  /// 触发源:
  /// - 本端 `clearConversationMessages` → SDK clearWithChannel → 这里回调
  /// - 其它设备清空, SDK sync 同步过来 → 这里回调
  /// - 远端 `messageEerase` CMD (非 from 模式) → 也调 clearWithChannel
  ///   → 这里回调
  ///
  /// SDK 本地 DB 已删但 UI 内存列表残留, 切走再回会复活. iOS 原版通过
  /// WKChatManagerDelegate clearMessages 委派给 UI 层清, 现在补齐.
  void _registerClearDeleteListeners() {
    WKIM.shared.messageManager.addOnClearChannelMsgListener(
      _flutterGatewayKey,
      (channelId, channelType) {
        if (_disposed || _channelClearedController.isClosed) return;
        _channelClearedController.add(
          WukongChannelClearedSignal(
            channelId: channelId,
            channelType: channelType,
          ),
        );
        // 顺手 emit conversation snapshot 让会话列表 lastMessage preview
        // 重算 (cleared channel 的 lastMessage 应变 "暂无聊天记录").
        unawaited(_emitConversations());
      },
    );
    WKIM.shared.messageManager.addOnDeleteMsgListener(_flutterGatewayKey, (
      clientMsgNo,
    ) {
      if (_disposed || _messageDeletedController.isClosed) return;
      if (clientMsgNo.isEmpty) return;
      _messageDeletedController.add(clientMsgNo);
    });
  }

  void _registerAguiEventListener() {
    WKIM.shared.eventManager.addEventListener(_flutterGatewayKey, (event) {
      if (_disposed || _aguiEventController.isClosed) return;
      final data = event.dataJson;
      if (data == null) return;
      final clientMsgNo = _string(data['client_msg_no']);
      if (clientMsgNo.isEmpty) return;
      final rawChannelId = _string(data['channel_id']);
      final channelType = _readInt(data['channel_type']);
      final fromUid = _string(data['from_uid']);
      final channelId = _normalizeInboundHintChannelId(
        channelId: rawChannelId,
        channelType: channelType,
        fromUid: fromUid,
        selfUid: WKIM.shared.options.uid ?? '',
      );
      if (channelId.isEmpty || channelType == 0) return;
      final payload = data['payload'];
      var delta = '';
      var snapshotText = '';
      if (payload is Map) {
        final kind = _string(payload['kind']);
        if (kind == 'text') {
          delta = _string(payload['delta']);
        }
        final snapshot = payload['snapshot'];
        if (snapshot is Map && _string(snapshot['kind']) == 'text') {
          snapshotText = _string(snapshot['text']);
        }
      }
      debugPrint(
        '[agui] recv type=${event.type} rawChannel=$rawChannelId channel=$channelId from=$fromUid clientMsgNo=$clientMsgNo delta=${delta.length} snapshot=${snapshotText.length}',
      );
      _aguiEventController.add(
        WukongAguiEventSnapshot(
          channelId: channelId,
          channelType: channelType,
          fromUid: fromUid,
          fromAvatarUrl: fromUid.isEmpty
              ? ''
              : client.config.showUrl('users/$fromUid/avatar'),
          clientMsgNo: clientMsgNo,
          eventType: event.type,
          delta: delta,
          snapshotText: snapshotText,
          timestamp: event.timestamp > 0
              ? (event.timestamp ~/ 1000)
              : DateTime.now().millisecondsSinceEpoch ~/ 1000,
        ),
      );
    });
  }

  void _registerChannelUpdateListeners() {
    String channelIdOf(dynamic param, {String fallback = ''}) {
      if (param is Map) {
        final raw = param['channel_id'] ?? param['group_no'] ?? param['uid'];
        if (raw != null) return raw.toString();
      }
      return fallback;
    }

    int channelTypeOf(dynamic param, {int fallback = 0}) {
      final channelType = _commandChannelType(param);
      return channelType == 0 ? fallback : channelType;
    }

    void invalidateAvatarAndRefresh(String command, dynamic param) {
      final targets = WukongImService.avatarInvalidationTargetsForCommand(
        command,
        param,
      );
      for (final target in targets) {
        unawaited(
          CachedNetworkImage.evictFromCache(
            client.config.showUrl(target.avatarPath),
          ),
        );
        unawaited(
          refreshChannel(
            channelId: target.channelId,
            channelType: target.channelType,
          ),
        );
      }
    }

    // group rename / notice / mute toggle / forbidden flag etc.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_channel_update', (cmd) {
      if (cmd.cmd != 'channelUpdate') return;
      invalidateAvatarAndRefresh(cmd.cmd, cmd.param);
    });

    // Avatar upload commands use fixed URLs (`users/<uid>/avatar`,
    // `groups/<no>/avatar`). Evict first, then refresh channel info so both
    // conversation cells and direct AvatarResolver users rebuild with fresh
    // bytes.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_group_avatar', (cmd) {
      if (cmd.cmd != 'groupAvatarUpdate') return;
      invalidateAvatarAndRefresh(cmd.cmd, cmd.param);
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_user_avatar', (cmd) {
      if (cmd.cmd != 'userAvatarUpdate') return;
      invalidateAvatarAndRefresh(cmd.cmd, cmd.param);
    });

    // group member add/kick/role-change. We treat it as a channel
    // refresh so the member-count + saved-to-contacts state catch up.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_member_update', (cmd) {
      if (cmd.cmd != 'memberUpdate') return;
      final groupNo = channelIdOf(cmd.param);
      if (groupNo.isEmpty) return;
      unawaited(
        refreshChannel(channelId: groupNo, channelType: WKChannelType.group),
      );
    });

    // unread-clear / conversation-delete — re-emit so the list cell
    // updates the badge / disappears.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_conv_update', (cmd) {
      if (cmd.cmd != 'unreadClear' &&
          cmd.cmd != 'conversationDelete' &&
          cmd.cmd != 'conversationDeleted') {
        return;
      }
      unawaited(_emitConversations());
    });

    // ---------- 好友关系（来自 WKContactsManager.handleCMD）----------
    // Server pushes these whenever someone applies / accepts / deletes
    // a friend relation. The `friendChangeSignals` stream is consumed
    // by `_HomeShellState` to re-run `loadSnapshot()` so the contacts
    // list + friend-request page stay in sync; the conversation list
    // also re-emits because `friendDeleted` removes the 1:1 channel.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_friend', (cmd) {
      if (cmd.cmd != 'friendRequest' &&
          cmd.cmd != 'friendAccept' &&
          cmd.cmd != 'friendDeleted') {
        return;
      }
      // Log every friend-relation CMD so we can verify the long-conn
      // is actually pushing them to the recipient.  When the scanner
      // adds dasha, dasha's app should emit:
      //   [friend] CMD cmd=friendRequest param={apply_uid, apply_name, ...}
      debugPrint('[friend] CMD cmd=${cmd.cmd} param=${cmd.param}');
      _emitFriendChangeSignal();
      // Mirror iOS WKContactsManager.handleFriendDeleted: drop the
      // 1:1 conversation + its message history when the peer removes
      // us. SDK exposes `deleteMsg(channelId, channelType)` on the
      // conversation manager (despite the name, it removes the whole
      // conversation row); plus `clearWithChannel` on the message
      // manager to drop the cached messages.
      if (cmd.cmd == 'friendDeleted') {
        final uid = channelIdOf(cmd.param);
        if (uid.isNotEmpty) {
          unawaited(
            WKIM.shared.conversationManager.deleteMsg(
              uid,
              WKChannelType.personal,
            ),
          );
          unawaited(
            WKIM.shared.messageManager.clearWithChannel(
              uid,
              WKChannelType.personal,
            ),
          );
        }
      }
      unawaited(_emitConversations());
    });

    // ---------- 在线状态 ----------
    // The server multicasts `onlineStatus` whenever a peer comes
    // online / goes offline. We just re-emit the conversation list so
    // the cell's online dot picks up the new flag (the SDK already
    // wrote it into its channel cache when the cmd landed).
    WKIM.shared.cmdManager.addOnCmdListener('moyu_online_status', (cmd) {
      if (cmd.cmd != 'onlineStatus') return;
      unawaited(_emitConversations());
    });

    // ---------- 消息撤回 / extra / reaction / voice-readed ----------
    // These all funnel through the `/message/extra/sync` endpoint —
    // the server CMDs are just nudges to pull the channel's latest
    // extras (revoke flag, reaction tally, voice-listened mark).
    //
    // Reactions need a SECOND pull through `reaction/sync` because the
    // server doesn't bundle them into the `message/extra/sync`
    // response — without that we never write the reaction row into
    // the local ReactionDB, so the next chat-open re-renders an empty
    // reaction strip even though the user clicked an emoji moments
    // ago. Mirrors iOS WKReactionManager.sync(channel) which native
    // calls in addition to extras.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_msg_extras', (cmd) {
      if (cmd.cmd != 'messageRevoke' &&
          cmd.cmd != 'syncMessageReaction' &&
          cmd.cmd != 'voiceReaded') {
        return;
      }
      final channelId = channelIdOf(cmd.param);
      final channelType = channelTypeOf(cmd.param);
      // ignore: avoid_print
      print(
        '[reaction] CMD received: ${cmd.cmd} '
        'ch=$channelId/$channelType param=${cmd.param}',
      );
      if (channelId.isEmpty || channelType == 0) return;
      unawaited(_syncMessageExtras(channelId, channelType));
      if (cmd.cmd == 'syncMessageReaction') {
        unawaited(
          syncAndStoreReactions(channelId: channelId, channelType: channelType),
        );
      }
    });

    // ---------- 消息擦除（双向删除 / 清频道）----------
    // iOS WKSystemMessageHandler.handleMessageEerase: `erase_type=from`
    // deletes only messages sent by `from_uid`; otherwise clear the
    // whole channel. SDK exposes `clearWithChannel` for the latter
    // path — for the per-sender variant we re-fetch extras + emit so
    // the chat page picks up SDK-deleted rows on next render.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_msg_erase', (cmd) {
      if (cmd.cmd != 'messageEerase') return;
      final param = cmd.param;
      if (param is! Map) return;
      final channelId = (param['channel_id'] ?? '').toString();
      final channelType = _readInt(param['channel_type']);
      final eraseType = (param['erase_type'] ?? 'from').toString();
      if (channelId.isEmpty || channelType == 0) return;
      if (eraseType != 'from') {
        unawaited(
          WKIM.shared.messageManager.clearWithChannel(channelId, channelType),
        );
      }
      unawaited(_syncMessageExtras(channelId, channelType));
      unawaited(_emitConversations());
    });

    // ---------- 同步类（@提醒 / 会话 extra）----------
    // These trigger background fetches the existing service helpers
    // already perform on chat-open or app-resume. Re-firing them on
    // CMD makes the bell badge / draft 更新 without waiting for the
    // next UI navigation.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_sync_misc', (cmd) {
      if (cmd.cmd != 'syncReminders' && cmd.cmd != 'syncConversationExtra') {
        return;
      }
      unawaited(_emitConversations());
    });

    // ---------- PC 端登出 ----------
    WKIM.shared.cmdManager.addOnCmdListener('moyu_misc', (cmd) {
      if (cmd.cmd != 'pcQuit') return;
      unawaited(_emitConversations());
    });
  }

  void _registerModuleCmdListeners() {
    final installers = <String, void Function()>{
      ModuleCmdHandlerIds.pinnedSync: _registerPinnedSyncListener,
      ModuleCmdHandlerIds.momentNotification: _registerMomentMsgListener,
      ModuleCmdHandlerIds.rtcIncomingCall: _registerRtcCallListeners,
    };
    final features =
        _featureRegistry?.enabledFeatures(kind: FeatureKind.cmdHandler) ??
        const Iterable<FeatureRegistration>.empty();
    for (final feature in features) {
      installers[feature.id]?.call();
    }
  }

  // ---------- Pin / Unpin 同步（独立 listener，对齐 iOS） ----------
  // iOS WKPinnedModule.cmdManager:onCMD: 收到 `syncPinnedMessage` CMD
  // 后调 `WKPinnedService.requestSyncPinnedMessages(channel)`，拉
  // /message/pinned/sync 增量。Flutter 没有全局 pinnedMessageManager，
  // pin 数据由 _ChatScreenState 自己持有，所以走 stream emit channel
  // info 让 chat screen 订阅 re-fetch。
  //
  // **修复 bug**：之前 `syncPinnedMessage` 跟 syncReminders/Extra 并
  // 在一个 `moyu_sync_misc` listener，只 emit conversations，没拉
  // pinned list → A 端 pin 后 B 端 banner 永远不出。用户报"pin 做完
  // 但不能用"就是这里。
  void _registerPinnedSyncListener() {
    WKIM.shared.cmdManager.addOnCmdListener('moyu_pinned_sync', (cmd) {
      if (cmd.cmd != 'syncPinnedMessage') return;
      final param = cmd.param;
      if (param == null) return;
      final channelId = param['channel_id']?.toString() ?? '';
      final channelTypeRaw = param['channel_type'];
      final channelType = channelTypeRaw is int
          ? channelTypeRaw
          : int.tryParse(channelTypeRaw?.toString() ?? '') ?? 0;
      if (channelId.isEmpty) return;
      debugPrint(
        '[pinned] CMD syncPinnedMessage channel=$channelId/$channelType',
      );
      if (!_pinnedSyncController.isClosed) {
        _pinnedSyncController.add(
          WukongPinnedSyncSignal(
            channelId: channelId,
            channelType: channelType,
          ),
        );
      }
    });
  }

  // ---------- 朋友圈通知 momentMsg ----------
  // 对齐 iOS WKMomentMsgManager.cmdManager:onCMD: (`m:101-150`)
  // param 字段: action / action_at / moment_no / uid / name /
  //            comment_id / comment / content (原动态摘要)
  // action ∈ { like, comment, delete_comment, publish }
  // 订阅方 (MomentMsgService) 负责入本地库 + 累计未读 + 广播 banner.
  void _registerMomentMsgListener() {
    WKIM.shared.cmdManager.addOnCmdListener('moyu_moment_msg', (cmd) {
      if (cmd.cmd != 'momentMsg') return;
      final param = cmd.param;
      if (param == null) return;
      final action = param['action']?.toString() ?? '';
      if (action.isEmpty) return;
      final actionAt = param['action_at'] is int
          ? param['action_at'] as int
          : int.tryParse(param['action_at']?.toString() ?? '') ??
                (DateTime.now().millisecondsSinceEpoch ~/ 1000);
      final content = param['content'] is Map
          ? Map<String, dynamic>.from(param['content'] as Map)
          : <String, dynamic>{};
      final signal = WukongMomentMsgSignal(
        action: action,
        actionAt: actionAt,
        momentNo: param['moment_no']?.toString() ?? '',
        uid: param['uid']?.toString() ?? '',
        name: param['name']?.toString() ?? '',
        commentId: param['comment_id']?.toString() ?? '',
        comment: param['comment']?.toString() ?? '',
        content: content,
      );
      debugPrint(
        '[moment-msg] CMD momentMsg action=$action moment=${signal.momentNo} from=${signal.uid}',
      );
      if (!_momentMsgController.isClosed) {
        _momentMsgController.add(signal);
      }
    });
  }

  void _emitFriendChangeSignal() {
    if (!_friendChangeController.isClosed) {
      _friendChangeController.add(null);
    }
  }

  void _emitGroupMemberSyncSignal(String channelId, int channelType) {
    if (!_groupMemberSyncController.isClosed) {
      _groupMemberSyncController.add(
        WukongGroupMemberSyncSignal(
          channelId: channelId,
          channelType: channelType,
        ),
      );
    }
  }

  void _emitFavoriteSyncSignal() {
    if (!_favoriteSyncController.isClosed) {
      _favoriteSyncController.add(null);
    }
  }

  @override
  void setActiveChannel({required String channelId, required int channelType}) {
    _activeChannelId = channelId;
    _activeChannelType = channelType;
  }

  @override
  void clearActiveChannel() {
    _activeChannelId = '';
    _activeChannelType = 0;
  }

  @override
  Future<void> syncAndStoreMessageExtras({
    required String channelId,
    required int channelType,
  }) async {
    await _syncMessageExtras(channelId, channelType);
  }

  /// Pull incremental `message_extra` rows from the server for one channel,
  /// write them into the SDK DB, and let the SDK's refresh listener fan out
  /// to the chat UI. Mirrors what native iOS WKChatViewController does on
  /// receiving the same cmd.
  /// Side-channel cache of per-message `voice_status` flags pulled
  /// from `message/extra/sync` responses. SDK 1.7.9's `WKMsgExtra`
  /// has no `voiceStatus` field, so the value gets dropped during
  /// `saveRemoteExtraMsg` and `_mapMessage` only sees
  /// `WKMsg.voiceStatus` (which the SDK doesn't refresh from
  /// extra-only syncs). Keep our own map so listened-on-another-
  /// device state still flips the bubble's red dot off without a
  /// full message resync. Keyed by messageId.
  ///
  /// Hydrated lazily on first sync from `SharedPreferences` so the
  /// state survives app restarts (extra-sync only returns versions
  /// after the saved max — the SDK won't replay listened state if
  /// we lose this map).
  final Map<String, int> _voiceStatusFromExtra = <String, int>{};
  Future<void>? _voiceStatusHydration;

  /// Per-uid prefs key. Voice listen state is recipient-scoped — if
  /// user A listens to a message and user B later logs in on the
  /// same device, B's "unread" view of the same messageId must not
  /// inherit A's read state. Falls back to a sentinel key when uid
  /// isn't available (pre-connect / signed-out state).
  String get _voiceStatusPrefsKey {
    final uid = WKIM.shared.options.uid ?? '';
    if (uid.isEmpty) return 'wukong.voice_status_extra.v1.anonymous';
    return 'wukong.voice_status_extra.v1.$uid';
  }

  /// Async-safe hydration: callers `await` the same future so a
  /// concurrent extra-sync triggered right after `connect()` doesn't
  /// race past the prefs read. Only on success / failure does the
  /// future resolve — meaning all `_mapMessage` callers gated on
  /// `_voiceStatusHydration` see the loaded ids.
  Future<void> _hydrateVoiceStatusFromPrefs() {
    return _voiceStatusHydration ??= () async {
      // Snapshot the uid + prefs key at the start of hydration. If
      // the user switches accounts while we're awaiting prefs, the
      // newly-connected user's `connect()` will reset
      // `_voiceStatusHydration` to null AND change `WKIM.shared.
      // options.uid`. If the uid we captured no longer matches when
      // the prefs read returns, drop the loaded state — those ids
      // belonged to the previous account and must NOT bleed into
      // the new session's `_voiceStatusFromExtra`.
      final startUid = WKIM.shared.options.uid ?? '';
      final keyAtStart = _voiceStatusPrefsKey;
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString(keyAtStart);
        if (raw == null || raw.isEmpty) return;
        final currentUid = WKIM.shared.options.uid ?? '';
        if (currentUid != startUid) return; // account switched mid-await
        final decoded = jsonDecode(raw);
        if (decoded is! Map) return;
        decoded.forEach((k, v) {
          final id = k.toString();
          final value = v is int ? v : int.tryParse('$v') ?? 0;
          if (id.isNotEmpty && value > 0) _voiceStatusFromExtra[id] = value;
        });
      } catch (_) {
        // Best-effort. Worst case the dot reappears for one app run
        // until the next manual play / chat reopen lands.
      }
    }();
  }

  Future<void> _persistVoiceStatusToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_voiceStatusFromExtra.isEmpty) {
        await prefs.remove(_voiceStatusPrefsKey);
        return;
      }
      // Cap entries so the prefs blob doesn't grow without bound for
      // long-lived installs. Keep most-recent 1000 (insertion order).
      final keys = _voiceStatusFromExtra.keys.toList();
      final trimmed = keys.length > 1000
          ? Map<String, int>.fromEntries(
              keys
                  .skip(keys.length - 1000)
                  .map((k) => MapEntry(k, _voiceStatusFromExtra[k]!)),
            )
          : Map<String, int>.from(_voiceStatusFromExtra);
      await prefs.setString(_voiceStatusPrefsKey, jsonEncode(trimmed));
    } catch (e) {
      debugPrint('[im][voice-status] persist failed: $e');
    }
  }

  Future<void> _syncMessageExtras(String channelId, int channelType) async {
    await _hydrateVoiceStatusFromPrefs();
    try {
      final maxVersion = await WKIM.shared.messageManager
          .getMaxExtraVersionWithChannel(channelId, channelType);
      final raw = await client.postAny('message/extra/sync', {
        'channel_id': channelId,
        'channel_type': channelType,
        'extra_version': maxVersion,
        'source': await client.deviceId(),
        'limit': 100,
      });
      // Server returns a bare JSON array of extras. Some other tangsengdaodao
      // endpoints wrap in `{data: [...]}`, handle both.
      final list = _readExtraList(raw);
      if (list.isEmpty) return;
      final extras = <WKMsgExtra>[];
      for (final item in list) {
        if (item is! Map) continue;
        final messageId =
            (item['message_id_str'] ?? item['message_id']?.toString() ?? '')
                .toString();
        if (messageId.isEmpty) continue;
        // Capture voice_status separately — SDK's WKMsgExtra drops it.
        final voiceStatus = _readInt(item['voice_status']);
        if (voiceStatus > 0) {
          _voiceStatusFromExtra[messageId] = voiceStatus;
        }
        final extra = WKMsgExtra()
          ..messageID = messageId
          ..channelID = channelId
          ..channelType = channelType
          ..readed = _readInt(item['readed'])
          ..readedCount = _readInt(item['readed_count'])
          ..replyCount = _readInt(item['reply_count'])
          ..unreadCount = _readInt(item['unread_count'])
          ..revoke = _readInt(item['revoke'])
          ..revoker = (item['revoker'] ?? '').toString()
          ..isMutualDeleted = _readInt(item['is_mutual_deleted'])
          ..isPinned = _readInt(item['is_pinned'])
          ..editedAt = _readInt(item['edited_at'])
          // **必读 content_edit** — 否则编辑后 sync 把本地标记冲掉. server
          // 可能返回 JSON string, 也可能返回已解析的 Map. 不能对 Map 调
          // toString(), 否则 DB 会写成 `{content: xxx, type: 1}` 并被 UI
          // 当普通文本显示.
          ..contentEdit = _contentEditPayloadString(item['content_edit'])
          ..extraVersion = _readInt(item['extra_version']);
        extras.add(extra);
      }
      if (extras.isEmpty) return;
      await WKIM.shared.messageManager.saveRemoteExtraMsg(extras);
      // Persist the captured voice_status side-channel so it
      // survives app restart. Without this, the SDK's saved
      // max-extra-version would prevent the listened state from
      // being re-fetched, leaving heard voices visually unread
      // until a manual replay.
      unawaited(_persistVoiceStatusToPrefs());
    } catch (_) {
      // Best-effort: receipt sync is idempotent; the next cmd will retry.
    }
  }

  static List<dynamic> _readExtraList(Object? raw) {
    if (raw is List) return raw;
    if (raw is Map) {
      final data = raw['data'];
      if (data is List) return data;
    }
    return const [];
  }

  /// Catch-all CMD tap. Logs every CMD the SDK delivers — used to
  /// diagnose "iOS doesn't seem to receive rtc.p2p.invoke" by proving
  /// whether ANY CMD lands on iOS during the call. If we see e.g.
  /// `typing` / `channelUpdate` flowing but not `rtc.p2p.*`, the
  /// problem is server-side routing. If we see nothing, the IM long
  /// connection isn't up.
  void _registerAllCmdTap() {
    WKIM.shared.cmdManager.addOnCmdListener('moyu_all_cmd_tap', (cmd) {
      // ignore: avoid_print
      print('[im] CMD tap: cmd=${cmd.cmd} hasParam=${cmd.param != null}');
    });
  }

  /// Hook the 5 P2P-call CMDs sent over the IM long-connection
  /// (`rtc.p2p.invoke` / `accept` / `refuse` / `cancel` / `hangup`).
  /// Each event is normalised into an [IncomingCallEvent] and fanned
  /// out via [incomingCallSignals]. The UI shell at HomeShell level
  /// owns the subscription so the IncomingCallPage can push on top of
  /// *any* current route (chat screen, settings, contacts list).
  ///
  /// Mirrors iOS `WKRTCManager`'s `onCmd:` dispatcher — the same five
  /// CMD names + param-shape contract documented in
  /// `WuKongBase/Classes/WKConstant.h` (WKCMDRTCP2P*).
  void _registerRtcCallListeners() {
    void emit(IncomingCallEvent event) {
      if (_incomingCallController.isClosed) return;
      _incomingCallController.add(event);
    }

    int readCallType(dynamic raw) {
      if (raw is int) return raw;
      if (raw is String) return int.tryParse(raw) ?? 0;
      return 0;
    }

    String readString(Map param, List<String> keys) {
      for (final key in keys) {
        final value = param[key];
        if (value != null && '$value'.trim().isNotEmpty) {
          return '$value'.trim();
        }
      }
      return '';
    }

    int readSeconds(Map param) {
      final raw = param['second'] ?? param['seconds'];
      if (raw is int) return raw;
      if (raw is String) return int.tryParse(raw) ?? 0;
      if (raw is num) return raw.toInt();
      return 0;
    }

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_invoke', (cmd) {
      if (cmd.cmd != 'rtc.p2p.invoke') return;
      final param = cmd.param;
      // ignore: avoid_print
      print('[call] CMD rtc.p2p.invoke received, param=$param');
      debugPrint('[call] CMD rtc.p2p.invoke received, param=$param');
      if (param is! Map) return;
      // iOS short-circuits when from_uid == self.uid (multi-device echo);
      // do the same so the same account on another device doesn't
      // accidentally pop an incoming page on itself.
      final fromUid = readString(param, ['from_uid', 'uid']);
      if (fromUid.isEmpty) return;
      final selfUid = WKIM.shared.options.uid ?? '';
      if (fromUid == selfUid) {
        debugPrint('[call] invoke ignored — own uid echo ($selfUid)');
        return;
      }
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.invoke,
          fromUid: fromUid,
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          fromName: readString(param, ['from_name', 'fromName']),
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
          ]),
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_accept', (cmd) {
      if (cmd.cmd != 'rtc.p2p.accept') return;
      final param = cmd.param;
      debugPrint('[call] CMD rtc.p2p.accept received, param=$param');
      if (param is! Map) return;
      final fromUid = readString(param, ['from_uid', 'uid']);
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.accept,
          fromUid: fromUid,
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
          ]),
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_refuse', (cmd) {
      if (cmd.cmd != 'rtc.p2p.refuse') return;
      final param = cmd.param;
      debugPrint('[call] CMD rtc.p2p.refuse received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.refuse,
          fromUid: readString(param, ['uid', 'from_uid']),
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
          ]),
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_cancel', (cmd) {
      if (cmd.cmd != 'rtc.p2p.cancel') return;
      final param = cmd.param;
      debugPrint('[call] CMD rtc.p2p.cancel received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.cancel,
          fromUid: readString(param, ['uid', 'from_uid']),
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
          ]),
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_hangup', (cmd) {
      if (cmd.cmd != 'rtc.p2p.hangup') return;
      final param = cmd.param;
      debugPrint('[call] CMD rtc.p2p.hangup received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.hangup,
          fromUid: readString(param, ['uid', 'from_uid']),
          callType: readCallType(param['call_type']),
          seconds: readSeconds(param),
          roomId: readString(param, ['room_id', 'roomId']),
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
          ]),
        ),
      );
    });

    // 通话中 audio ⇄ video 切换 CMD. iOS WKRTCManager.onCmd 同模式
    // (rtc.p2p.switchToVideo / switchToVideoReply / switchToVoice).
    // 这 3 个 CMD 走 NoPersist, 通话已断后 client _CallPageState
    // _terminated 守卫也会 ignore.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_switch_video', (cmd) {
      if (cmd.cmd != 'rtc.p2p.switchToVideo') return;
      final param = cmd.param;
      debugPrint('[call] CMD rtc.p2p.switchToVideo received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.switchToVideo,
          fromUid: readString(param, ['from_uid', 'uid']),
          callType: 0,
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_switch_video_reply', (
      cmd,
    ) {
      if (cmd.cmd != 'rtc.p2p.switchToVideoReply') return;
      final param = cmd.param;
      debugPrint(
        '[call] CMD rtc.p2p.switchToVideoReply received, param=$param',
      );
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.switchToVideoReply,
          fromUid: readString(param, ['from_uid', 'uid']),
          callType: 0,
          agreed: param['agree'] == true,
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_p2p_switch_voice', (cmd) {
      if (cmd.cmd != 'rtc.p2p.switchToVoice') return;
      final param = cmd.param;
      debugPrint('[call] CMD rtc.p2p.switchToVoice received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.switchToVoice,
          fromUid: readString(param, ['from_uid', 'uid']),
          callType: 0,
        ),
      );
    });

    // Group call CMDs — server-side `modules/rtc/const.go`:
    //   room.invoke / room.hangup / room.refuse / room.leave.
    // The room.invoke CMD lands on every invited uid (server fans
    // out via Subscribers list in roomCreate). Before this listener
    // existed, group invitees never saw an incoming-call modal —
    // the user-facing "群通话发起后成员收不到" bug. Payload shape
    // (from `roomCreate` handler):
    //   { room_id, inviter, participants, channel_id?, channel_type? }
    // No `call_type` field — server doesn't track audio-vs-video for
    // group rooms (caller chose, callee opens with audio default and
    // can toggle video later, matching iOS).
    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_room_invoke', (cmd) {
      if (cmd.cmd != 'room.invoke') return;
      final param = cmd.param;
      debugPrint('[call] CMD room.invoke received, param=$param');
      if (param is! Map) return;
      final inviter = readString(param, ['inviter', 'from_uid', 'uid']);
      if (inviter.isEmpty) return;
      final selfUid = WKIM.shared.options.uid ?? '';
      if (inviter == selfUid) {
        debugPrint('[call] room.invoke ignored — own uid echo ($selfUid)');
        return;
      }
      final participantsRaw = param['participants'];
      final groupParticipants = <String>[];
      if (participantsRaw is List) {
        for (final entry in participantsRaw) {
          final uid = entry?.toString() ?? '';
          if (uid.isNotEmpty && uid != selfUid) {
            groupParticipants.add(uid);
          }
        }
      }
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.invoke,
          fromUid: inviter,
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          isGroupCall: true,
          groupChannelId: readString(param, ['channel_id', 'channelId']),
          groupChannelType: readCallType(param['channel_type']),
          fromName: readString(param, ['inviter_name', 'from_name']),
          groupParticipants: groupParticipants,
          // group call_instance_id = room_id (server 端默认这样,
          // group roomId 本身就是 UUID per call). fallback 读 field
          // 防 server schema 变化.
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
            'room_id',
            'roomId',
          ]),
        ),
      );
    });

    // room.hangup: server fans out when any participant taps hangup
    // (= "I'm leaving"). For the callee modal that's still pre-
    // accept this means the inviter cancelled — close the ringer.
    // Once we're in the _CallPage, LiveKit
    // ParticipantDisconnectedEvent flips the participant tile, so
    // hangup CMD doesn't need to teardown the whole _CallPage in
    // that path.
    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_room_hangup', (cmd) {
      if (cmd.cmd != 'room.hangup') return;
      final param = cmd.param;
      debugPrint('[call] CMD room.hangup received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.hangup,
          // server 现在用 `participant` 字段; 保留旧 fallback 兼容
          // 老 client/server combo
          fromUid: readString(param, [
            'participant',
            'uid',
            'from_uid',
            'inviter',
          ]),
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          seconds: readSeconds(param),
          isGroupCall: true,
          groupChannelId: readString(param, ['channel_id', 'channelId']),
          groupChannelType: readCallType(param['channel_type']),
          // owner 挂断 = 整个房间终结. callee 收到这个标志主动
          // disconnect LiveKit + 退出 _CallPage. 不带的话保持
          // "某成员离开" 行为 (LiveKit ParticipantDisconnect 自动
          // 移除 tile, 不退页).
          roomEnded: param['room_ended'] == true,
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
            'room_id',
            'roomId',
          ]),
        ),
      );
    });

    WKIM.shared.cmdManager.addOnCmdListener('moyu_rtc_room_refuse', (cmd) {
      if (cmd.cmd != 'room.refuse') return;
      final param = cmd.param;
      debugPrint('[call] CMD room.refuse received, param=$param');
      if (param is! Map) return;
      emit(
        IncomingCallEvent(
          kind: IncomingCallKind.refuse,
          fromUid: readString(param, ['participant', 'uid', 'from_uid']),
          callType: readCallType(param['call_type']),
          roomId: readString(param, ['room_id', 'roomId']),
          isGroupCall: true,
          groupChannelId: readString(param, ['channel_id', 'channelId']),
          groupChannelType: readCallType(param['channel_type']),
          callInstanceId: readString(param, [
            'call_instance_id',
            'callInstanceId',
            'room_id',
            'roomId',
          ]),
        ),
      );
    });
  }

  /// Pulls every still-active group-call invite addressed to the
  /// logged-in user from `GET /v1/rtc/rooms/pending` and replays them
  /// as `IncomingCallEvent`s on `_incomingCallController`. This covers
  /// the "user opened the app after a group call started" gap — the
  /// `room.invoke` CMD is fire-and-forget on the server side (no
  /// persistence / re-send), so the only way the callee learns about
  /// the pending invite on reconnect is a deliberate pull.
  ///
  /// Hooked off the success branch of the connection status listener,
  /// so it fires once on every successful (re)connect — covers both
  /// cold start and "phone was offline, came back".
  /// Per-process dedup of pending invites we've already replayed.
  /// Every reconnect triggers `_syncPendingRtcInvites`; without this
  /// set the same room id would re-emit on every network blip,
  /// stacking fake incoming-call pages for invites the user already
  /// dismissed once. Cleared on logout via [disconnect].
  final Set<String> _processedPendingRoomIds = <String>{};

  Future<void> _syncPendingRtcInvites(
    ImConnectGeneration? generation, {
    bool trace = true,
  }) async {
    try {
      final raw = await client.getAny('rtc/rooms/pending');
      final list = _coerceList(raw);
      if (list.isEmpty) {
        if (trace) {
          _recordConnectionTrace(
            event: 'hydration_end',
            generation: generation,
            reason: 'rtc_pending_invites:empty',
          );
        }
        return;
      }
      final selfUid = WKIM.shared.options.uid ?? '';
      for (final entry in list) {
        final inviter = (entry['inviter'] ?? '').toString();
        if (inviter.isEmpty || inviter == selfUid) continue;
        if (_incomingCallController.isClosed) return;
        final roomId = (entry['room_id'] ?? '').toString();
        // Skip rooms we've already surfaced this session. Without
        // this every reconnect re-fires the same invite as a fresh
        // "fake来电" — user-facing bug "假来电偶尔出现".
        if (roomId.isNotEmpty && _processedPendingRoomIds.contains(roomId)) {
          continue;
        }
        if (roomId.isNotEmpty) _processedPendingRoomIds.add(roomId);
        final participantsRaw = entry['participants'];
        final groupParticipants = <String>[];
        if (participantsRaw is List) {
          for (final p in participantsRaw) {
            final uid = p?.toString() ?? '';
            if (uid.isNotEmpty && uid != selfUid) {
              groupParticipants.add(uid);
            }
          }
        }
        _incomingCallController.add(
          IncomingCallEvent(
            kind: IncomingCallKind.invoke,
            fromUid: inviter,
            // Use the server-supplied call_type (0=audio/1=video)
            // — previously hardcoded 0 so a group video invite that
            // landed via the pending sync would re-pop as audio.
            callType: _readInt(entry['call_type']),
            roomId: roomId,
            isGroupCall: true,
            groupChannelId: (entry['channel_id'] ?? '').toString(),
            groupChannelType: _readInt(entry['channel_type']),
            groupParticipants: groupParticipants,
          ),
        );
        // Only re-pop the topmost pending invite. Multiple races
        // on the IncomingCallPage gate (`_incomingCallVisible`)
        // make stacking invitations confusing, and the user can
        // only realistically answer one anyway.
        break;
      }
      if (trace) {
        _recordConnectionTrace(
          event: 'hydration_end',
          uid: selfUid,
          generation: generation,
          reason: 'rtc_pending_invites:${list.length}',
        );
      }
    } catch (error) {
      if (trace) {
        _recordConnectionTrace(
          event: 'hydration_fail',
          generation: generation,
          reason: 'rtc_pending_invites:$error',
        );
      }
      debugPrint('[call] _syncPendingRtcInvites failed: $error');
    }
  }

  void _registerTypingListener() {
    WKIM.shared.cmdManager.addOnCmdListener('moyu_typing', (cmd) {
      if (cmd.cmd != 'typing') return;
      final param = cmd.param;
      if (param is! Map) return;
      final rawChannelId = (param['channel_id'] ?? '').toString();
      final channelType = _readInt(param['channel_type']);
      final fromUid = (param['from_uid'] ?? param['uid'] ?? '').toString();
      final channelId = _normalizeInboundHintChannelId(
        channelId: rawChannelId,
        channelType: channelType,
        fromUid: fromUid,
        selfUid: WKIM.shared.options.uid ?? '',
      );
      if (channelId.isEmpty || channelType == 0) return;
      final fromName = (param['from_name'] ?? param['name'] ?? '').toString();
      final channelKey = '${channelType}_$channelId';
      final typerKey = fromUid.isNotEmpty
          ? fromUid
          : (fromName.isNotEmpty ? 'name:$fromName' : 'anon');
      final displayName = buildTypingDisplayName(
        channelType: channelType,
        fromName: fromName,
        fromUid: fromUid,
      );
      if (_typingController.isClosed) return;
      final perChannel = _typingState.putIfAbsent(channelKey, () => {});
      perChannel[typerKey] = _TypingEntry(displayName, DateTime.now());
      _typingController.add(_currentTypingMap());
      _typingSweep ??= Timer.periodic(const Duration(seconds: 1), (_) {
        final now = DateTime.now();
        var changed = false;
        _typingState.removeWhere((channelKey, perChannel) {
          perChannel.removeWhere((typerKey, entry) {
            final stale = now.difference(entry.startedAt) >= _typingTtl;
            if (stale) changed = true;
            return stale;
          });
          return perChannel.isEmpty;
        });
        if (changed && !_typingController.isClosed) {
          _typingController.add(_currentTypingMap());
        }
        if (_typingState.isEmpty) {
          _typingSweep?.cancel();
          _typingSweep = null;
        }
      });
    });
  }

  /// Aggregate the multi-typer state into render-ready labels. Per
  /// channel:
  ///   * 1 typer → `<name> 正在输入...` (or `对方正在输入...` for
  ///     1:1 chats with no name).
  ///   * 2 typers → `<X> 和 <Y> 正在输入...`.
  ///   * 3+ typers → `几位成员正在输入...`.
  /// Empty channels are filtered. Channel-type sentinel `2` = group;
  /// 1:1 with a single typer falls back to the `对方` form when the
  /// name is the placeholder.
  Map<String, String> _currentTypingMap() {
    final out = <String, String>{};
    for (final ch in _typingState.entries) {
      final typers = ch.value;
      if (typers.isEmpty) continue;
      final label = buildTypingLabel(
        channelType: _channelTypeFromTypingKey(ch.key),
        displayNames: typers.values.map((e) => e.displayName).toList(),
      );
      if (label.isNotEmpty) out[ch.key] = label;
    }
    return Map<String, String>.unmodifiable(out);
  }

  int _channelTypeFromTypingKey(String key) {
    final separator = key.indexOf('_');
    if (separator <= 0) return 0;
    return int.tryParse(key.substring(0, separator)) ?? 0;
  }

  @override
  Future<List<WukongConversationSnapshot>> loadConversations() async {
    final conversations = await WKIM.shared.conversationManager.getAll();
    final legacyAvatarCacheChannels = <WKChannel>[];
    // 父子会话聚合 — 对齐 iOS WKConversationListVM.addOrCreateParentConversation:
    //   sub-channel (parentChannelID 非空, 一般是 Community 内的 topic 子频道)
    //   会被聚合到父 channel 下, 列表只显示父 channel 一行, 父预览取最新
    //   子会话的内容. chatim 当前没启用 Community feature, 子会话路径不会
    //   触发, 但为防 server 数据已含 community channel 导致列表出现孤立
    //   子频道, 这里**直接 skip 子会话** (不渲染), 跟 iOS 默认行为对齐
    //   (Community 模式未开时父聚合也是 skip 等效).
    final snapshots = <WukongConversationSnapshot>[];
    for (final conversation in conversations) {
      if (conversation.parentChannelID.isNotEmpty) {
        // 子会话: 跳过 list 渲染. (如果未来要支持 Community,
        // 这里聚合到 parent snapshot.)
        continue;
      }
      if (await _isMistypedGroupConversation(conversation)) {
        continue;
      }
      snapshots.add(
        await _mapConversation(
          conversation,
          legacyAvatarCacheChannels: legacyAvatarCacheChannels,
        ),
      );
    }
    await _evictLegacyAvatarCachesOnce(
      legacyAvatarCacheChannels,
      scope: 'conversations',
    );
    snapshots.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      return b.timestamp.compareTo(a.timestamp);
    });
    // Cache the latest snapshot list synchronously so the next cold-start
    // (or any rebuild that needs an initial list) can seed UI without
    // awaiting another DB round-trip. See [cachedConversations] doc.
    _cachedConversations = snapshots;
    return snapshots;
  }

  Future<bool> _isMistypedGroupConversation(
    WKUIConversationMsg conversation,
  ) async {
    if (conversation.channelType != WKChannelType.personal) {
      return false;
    }
    final personalChannel = await conversation.getWkChannel();
    final personalTitle = _channelTitle(
      personalChannel,
      rawIdentity: conversation.channelID,
    );
    if (personalTitle.isNotEmpty) {
      return false;
    }
    final groupChannel = await WKIM.shared.channelManager.getChannel(
      conversation.channelID,
      WKChannelType.group,
    );
    final groupTitle = _channelTitle(
      groupChannel,
      rawIdentity: conversation.channelID,
    );
    return groupTitle.isNotEmpty;
  }

  @override
  Future<List<ChatContact>> loadCachedFriends() async {
    // 对齐 iOS WKContactsVC.requestData (WKChannelInfoDB
    // queryChannelInfosWithStatusAndFollow:status:WKChannelStatusNormal
    // follow:WKChannelInfoFollowFriend). follow=1 → 好友, status=1 → normal.
    final channels = await WKIM.shared.channelManager.getWithFollowAndStatus(
      WKChannelType.personal,
      1,
      1,
    );
    final contacts = <ChatContact>[];
    for (final ch in channels) {
      contacts.add(_contactFromChannel(ch));
    }
    await _evictLegacyAvatarCachesOnce(channels, scope: 'friends');
    return contacts;
  }

  @override
  Future<void> writeFriendsToCache(List<ChatContact> contacts) async {
    if (contacts.isEmpty) return;
    final channels = <WKChannel>[];
    for (final c in contacts) {
      if (c.uid.isEmpty) continue;
      channels.add(_channelFromContact(c));
    }
    if (channels.isEmpty) return;
    WKIM.shared.channelManager.addOrUpdateChannels(channels);
  }

  /// `WKChannel` 行 → `ChatContact`. 缺的应用层字段从 `localExtra` JSON 取
  /// (上次 [writeFriendsToCache] 写入). 第一次读 cache (没写过) 时 extra
  /// 为空, 字段降级为默认值, UI 显示能用但缺 subtitle/role 等; 后台 fetch
  /// 完后 [writeFriendsToCache] 写一遍再读就齐了 (跟 iOS 同模式).
  ChatContact _contactFromChannel(WKChannel ch) {
    final extra = ch.localExtra ?? const <String, dynamic>{};
    return ChatContact(
      uid: ch.channelID,
      name: ch.channelName,
      remark: ch.channelRemark,
      avatar: ch.avatar,
      online: ch.online == 1,
      role: (extra['role'] as int?) ?? 0,
      vercode: (extra['vercode'] as String?) ?? '',
      version: ch.version != 0 ? ch.version : ((extra['version'] as int?) ?? 0),
      subtitle: (extra['subtitle'] as String?) ?? '',
      sourceDescription: (extra['sourceDescription'] as String?) ?? '',
      // SDK 原生字段直接用 — channel 表本来就有 username/robot/category 列,
      // friend/sync 写入时 SDK 自动按字段名分发, 不用我们走 localExtra detour.
      username: ch.username,
      isRobot: ch.robot == 1,
      category: ch.category,
    );
  }

  /// `ChatContact` → `WKChannel`. 核心字段直接对应 (uid/name/remark/avatar),
  /// 应用层独有字段塞 `localExtra` (跟 iOS WKChannelInfo.extra NSDictionary
  /// 同模式). `follow=1 status=1` 标记好友. `localExtra` 不上传 server,
  /// SDK 持久化到 channel 表的 local_extra 列.
  WKChannel _channelFromContact(ChatContact c) {
    final channel = WKChannel(c.uid, WKChannelType.personal)
      ..channelName = c.name
      ..channelRemark = c.remark
      ..avatar = c.avatar
      ..follow = 1
      ..status = 1
      ..online = c.online ? 1 : 0
      ..isDeleted = c.isDeleted ? 1 : 0
      // SDK 原生字段写入 — channel 表有原生 username/robot/category 列, 直接对齐.
      ..username = c.username
      ..robot = c.isRobot ? 1 : 0
      ..category = c.category
      ..version = c.version
      ..localExtra = {
        // 留 localExtra 只放应用层独有字段 (subtitle / role / vercode 等 SDK 没原生
        // 列的). bot 识别字段已经走原生列, 不在这里重复.
        'role': c.role,
        'vercode': c.vercode,
        'subtitle': c.subtitle,
        'sourceDescription': c.sourceDescription,
      };
    return channel;
  }

  @override
  Future<List<WukongMessageSnapshot>> loadMessages({
    required String channelId,
    required int channelType,
    int limit = 30,
    int beforeSeq = 0,
  }) async {
    final completer = Completer<List<WKMsg>>();
    // 对齐 iOS WKChatManager.m:1186-1189 + WKConst.h:82-85 —
    //   WKPullModeDown = 0 (older 方向, 查 anchor 之前的)
    //   WKPullModeUp   = 1 (newer 方向, 查 anchor 之后的)
    // iOS 首屏从 conversation 拿 maxMessageSeq 当 anchor, 用 WKPullModeUp 拉
    // newer; 翻页用 WKPullModeDown 拉 older. Flutter SDK message.dart:202-216
    // + message_manager.dart:379 ("0:向下拉取 1:向上拉取") 跟 iOS enum 一致.
    //
    // 之前这里 `beforeSeq > 0 ? 1 : 0` 把方向写反了 → 清空聊天记录后重进
    // 触发 sync, server 沿"旧方向"找, channel_offset race 时可能返回应被
    // 过滤的旧消息, insertMsgList 按 client_msg_no 比对失败时 INSERT 新 row
    // → "最后一条残留" + "我发的多一条" 复现 (时有时无). 改回 newer 方向后
    // sync 沿 (maxDeletedSeq+1, ∞) 找, 拉不到 <= maxDeletedSeq 的旧 row.
    final useOrderSeq = beforeSeq > 0 ? beforeSeq * 1000 : 0;
    final pullMode = beforeSeq > 0 ? 0 : 1;
    WKIM.shared.messageManager.getOrSyncHistoryMessages(
      channelId,
      channelType,
      useOrderSeq,
      false,
      pullMode,
      limit,
      0,
      (messages) {
        if (!completer.isCompleted) {
          completer.complete(messages);
        }
      },
      () {},
    );

    final messages = await completer.future.timeout(
      const Duration(seconds: 8),
      onTimeout: () => <WKMsg>[],
    );
    // Await hydration before mapping so previously-listened voice
    // messages render their red dot off on first chat-open after
    // an app restart. Without this, `_mapMessage` could run with
    // an empty `_voiceStatusFromExtra` and the SDK's cached
    // max-extra-version would prevent the next sync from
    // republishing the listened state.
    await _hydrateVoiceStatusFromPrefs();
    final snapshots = messages.map(_mapMessage).toList();
    snapshots.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return snapshots;
  }

  @override
  Future<void> sendText({
    required String channelId,
    required int channelType,
    required String text,
    List<String> mentionUids = const [],
    bool mentionAll = false,
    String replyMessageId = '',
    int replyMessageSeq = 0,
    String replyFromUid = '',
    String replyFromName = '',
    String replyText = '',
  }) async {
    final content = text.trim();
    if (content.isEmpty) {
      return;
    }

    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    final body = WKTextContent(content);
    if (mentionAll || mentionUids.isNotEmpty) {
      body.mentionInfo = WKMentionInfo()
        ..mentionAll = mentionAll
        ..uids = mentionUids.isEmpty ? null : List.of(mentionUids);
    }
    if (replyMessageId.isNotEmpty) {
      // Build a WKReply payload mirroring iOS `WKConversationContext`
      // reply marshalling. payload carries the original message's text
      // content so the receiver's bubble can render the quote header
      // even before re-fetching the source message.
      body.reply = WKReply()
        ..messageId = replyMessageId
        ..rootMid = replyMessageId
        ..messageSeq = replyMessageSeq
        ..fromUID = replyFromUid
        ..fromName = replyFromName
        ..payload = (WKTextContent(replyText)..contentType = 1);
    }
    // ignore: avoid_print
    print(
      '[send] sendText → channel=${channelType}_$channelId len=${content.length} '
      'reply=${replyMessageId.isEmpty ? "no" : "yes"}',
    );
    final stopwatch = Stopwatch()..start();
    try {
      await WKIM.shared.messageManager.sendWithOption(
        body,
        WKChannel(channelId, channelType),
        options,
      );
    } catch (error) {
      // ignore: avoid_print
      print(
        '[send] sendWithOption threw after ${stopwatch.elapsedMilliseconds}ms: $error',
      );
      rethrow;
    }
    // ignore: avoid_print
    print(
      '[send] sendWithOption returned in ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  WKMessageContent _mediaContentFor(ChatMediaAttachment attachment) {
    return switch (attachment.kind) {
      ChatMediaKind.image =>
        WKImageContent(attachment.width, attachment.height)
          ..localPath = attachment.localPath
          ..url = attachment.remoteUrl,
      ChatMediaKind.file =>
        WKFileContent(name: attachment.fileName, size: attachment.fileSize)
          ..localPath = attachment.localPath
          ..url = attachment.remoteUrl,
      ChatMediaKind.voice =>
        WKVoiceContent(attachment.durationSeconds)
          ..localPath = attachment.localPath
          ..url = attachment.remoteUrl,
      ChatMediaKind.video =>
        WKVideoContent()
          ..localPath = attachment.localPath
          ..url = attachment.remoteUrl
          ..cover = attachment.coverUrl
          ..width = attachment.width
          ..height = attachment.height
          ..second = attachment.durationSeconds
          ..size = attachment.fileSize,
      ChatMediaKind.livePhoto =>
        WKLivePhotoContent()
          ..localPath = attachment.localPath
          ..url = attachment.remoteUrl
          ..videoLocalPath = attachment.livePhotoVideoLocalPath
          ..videoUrl = attachment.livePhotoVideoUrl
          ..videoSize = attachment.livePhotoVideoSize
          ..width = attachment.width
          ..height = attachment.height
          ..second = attachment.durationSeconds
          ..size = attachment.fileSize,
      ChatMediaKind.sticker =>
        // Stickers go through their own send path (sendSticker); never
        // reach the generic media sender. Treat as a no-op fall-back.
        WKImageContent(attachment.width, attachment.height)
          ..localPath = attachment.localPath
          ..url = attachment.remoteUrl,
    };
  }

  @override
  Future<void> sendMedia({
    required String channelId,
    required int channelType,
    required ChatMediaAttachment attachment,
  }) async {
    final content = _mediaContentFor(attachment);
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    await WKIM.shared.messageManager.sendWithOption(
      content,
      WKChannel(channelId, channelType),
      options,
    );
  }

  @override
  Future<void> persistFailedMedia({
    required String channelId,
    required int channelType,
    required ChatMediaAttachment attachment,
  }) async {
    final content = _mediaContentFor(attachment);
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    debugPrint(
      '[media-send] persistFailedMedia channel=${channelType}_$channelId '
      'kind=${attachment.kind}',
    );
    final saved = await WKIM.shared.messageManager.saveFailedMediaMessage(
      content,
      WKChannel(channelId, channelType),
      options,
    );
    debugPrint(
      '[media-send] persistFailedMedia saved '
      'clientMsgNo=${saved?.clientMsgNO} status=${saved?.status} (refresh→发送失败)',
    );
  }

  @override
  Future<void> sendSticker({
    required String channelId,
    required int channelType,
    required ChatSticker sticker,
  }) async {
    final path = sticker.path.trim();
    if (path.isEmpty) {
      return;
    }
    final content = _stickerContent(sticker);
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    await WKIM.shared.messageManager.sendWithOption(
      content,
      WKChannel(channelId, channelType),
      options,
    );
  }

  @override
  Future<void> sendLocation({
    required String channelId,
    required int channelType,
    required ChatLocation location,
  }) async {
    if (location.title.trim().isEmpty && location.address.trim().isEmpty) {
      return;
    }
    final content = WKLocationContent.fromLocation(location);
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    await WKIM.shared.messageManager.sendWithOption(
      content,
      WKChannel(channelId, channelType),
      options,
    );
  }

  @override
  Future<void> sendCard({
    required String channelId,
    required int channelType,
    required String cardUid,
    required String cardName,
    String vercode = '',
  }) async {
    if (cardUid.trim().isEmpty) return;
    final content = WKCardContent(cardUid.trim(), cardName.trim());
    if (vercode.trim().isNotEmpty) {
      content.vercode = vercode.trim();
    }
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    await WKIM.shared.messageManager.sendWithOption(
      content,
      WKChannel(channelId, channelType),
      options,
    );
  }

  @override
  Future<void> sendMergeForward({
    required String channelId,
    required int channelType,
    required WKMergeForwardContent content,
  }) async {
    if (content.msgs.isEmpty) return;
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    await WKIM.shared.messageManager.sendWithOption(
      content,
      WKChannel(channelId, channelType),
      options,
    );
  }

  @override
  Future<void> sendScreenshotNotice({
    required String channelId,
    required int channelType,
    String senderName = '',
  }) async {
    final selfUid = WKIM.shared.options.uid ?? '';
    // Resolve sender name in priority order: caller-supplied
    // (login display name) > local self-channel cache > empty. Empty
    // would cause receivers to fall back to the raw uid hash via
    // `_resolveScreenshotName`'s `message.fromUID` last-ditch path.
    String selfName = senderName.trim();
    if (selfName.isEmpty) {
      final selfChannel = await WKIM.shared.channelManager.getChannel(
        selfUid,
        WKChannelType.personal,
      );
      selfName = moyuDisplayName(
        remark: selfChannel?.channelRemark ?? '',
        name: selfChannel?.channelName ?? '',
        rawIdentity: selfUid,
        placeholder: '',
      );
    }
    final body = WKScreenshotContent(fromUid: selfUid, fromName: selfName);
    final setting = Setting()..receipt = 1;
    final options = WKSendOptions()..setting = setting;
    try {
      await WKIM.shared.messageManager.sendWithOption(
        body,
        WKChannel(channelId, channelType),
        options,
      );
    } catch (_) {
      // Best-effort: if the broadcast fails, the local UI still shows
      // the toast and we don't block the user.
    }
  }

  WKMessageContent _stickerContent(ChatSticker sticker) {
    final format = sticker.format.toLowerCase();
    if (format == 'gif' || sticker.path.toLowerCase().endsWith('.gif')) {
      return WKGifContent(
        url: sticker.path,
        width: sticker.width,
        height: sticker.height,
      );
    }
    final content = sticker.category == 'emoji'
        ? WKEmojiStickerContent()
        : WKLottieStickerContent();
    content
      ..url = sticker.path
      ..category = sticker.category
      ..placeholder = sticker.placeholder
      ..format = sticker.format.isEmpty ? 'lim' : sticker.format
      ..content = sticker.title;
    return content;
  }

  @override
  Future<void> clearUnread({
    required UserSession session,
    required String channelId,
    required int channelType,
  }) async {
    await WKIM.shared.conversationManager.updateRedDot(
      channelId,
      channelType,
      0,
    );
    await client.putJson('coversation/clearUnread', {
      'login_uid': session.uid,
      'channel_id': channelId,
      'channel_type': channelType,
      'unread': 0,
    });
  }

  @override
  Future<void> deleteConversation({
    required String channelId,
    required int channelType,
  }) async {
    await client.deleteJson('conversations/$channelId/$channelType');
    try {
      await WKIM.shared.conversationManager.deleteMsg(channelId, channelType);
    } catch (e) {
      // SDK cache 删失败 → server 已删但本地 SDK conversation 表还在,
      // 下次 loadConversations 会回流 "已删" cell. 必须 log 否则用户报
      // "删了又出来" 无 log 可查.
      debugPrint('[im][deleteConversation] SDK deleteMsg failed: $e');
    }
    // 跟 pin / mute / clearMessages 等 mutation 同模式 — 触发
    // _emitConversations 让 UI 拉新 list, 否则 home_shell._conversations
    // 不会刷新, 会话列表右滑删除"假删除" (server 删了 SDK 删了 UI cell
    // 还在). 之前 deleteConversation 漏调.
    unawaited(_emitConversations());
  }

  @override
  Future<void> updateChannelSetting({
    required String channelId,
    required int channelType,
    required Map<String, dynamic> setting,
  }) async {
    final path = channelType == WKChannelType.group
        ? 'groups/$channelId/setting'
        : 'users/$channelId/setting';
    await client.putJson(path, setting);
    try {
      final channel = await WKIM.shared.channelManager.getChannel(
        channelId,
        channelType,
      );
      if (channel == null) {
        return;
      }
      if (setting.containsKey('top')) {
        channel.top = _readInt(setting['top']);
      }
      if (setting.containsKey('mute')) {
        channel.mute = _readInt(setting['mute']);
      }
      if (setting.containsKey('receipt')) {
        channel.receipt = _readInt(setting['receipt']);
      }
      if (setting.containsKey('chat_pwd_on')) {
        channel.remoteExtraMap = {
          ...?channel.remoteExtraMap,
          'chat_pwd_on': _readInt(setting['chat_pwd_on']),
        };
      }
      if (setting.containsKey('flame')) {
        channel.remoteExtraMap = {
          ...?channel.remoteExtraMap,
          'flame': _readInt(setting['flame']),
        };
      }
      if (setting.containsKey('flame_second')) {
        channel.remoteExtraMap = {
          ...?channel.remoteExtraMap,
          'flame_second': _readInt(setting['flame_second']),
        };
      }
      if (setting.containsKey('screenshot')) {
        // Keep the per-channel screenshot-notify flag in sync with
        // server state so the chat screen's broadcast gate sees the
        // updated value on the next snapshot emission.
        channel.remoteExtraMap = {
          ...?channel.remoteExtraMap,
          'screenshot': _readInt(setting['screenshot']),
        };
      }
      WKIM.shared.channelManager.addOrUpdateChannel(channel);
    } catch (e) {
      debugPrint('[im][updateChannelSetting] SDK addOrUpdateChannel: $e');
    }
    // SDK channel-refresh listener may run asynchronously and miss the
    // immediate UI tick after toggling top/mute/etc. Push a fresh snapshot
    // ourselves so the conversation list reorders right away.
    unawaited(_emitConversations());
  }

  @override
  Future<void> clearConversationMessages({
    required String channelId,
    required int channelType,
    int messageSeq = 0,
  }) async {
    // 对齐 iOS WKMessageManagerDelegateImp.clearMessages —
    //   uint32_t messageSeq = [[WKMessageDB shared] getMaxMessageSeq:channel];
    //   POST message/offset { message_seq: maxSeq }
    // 关键: 传当前 channel 的 max seq 让 server 把 offset 卡到 max, 下次
    // 拉历史 / 离线 / 系统消息 server 才会真的不返回 < offset 的旧消息.
    // 之前 caller 传 messageSeq=0 等于没设 offset → 清空后进会话 SDK
    // 重新 pullLast 从 server 仍能拿到历史 + 系统消息, 表现成"假删除".
    int seq = messageSeq;
    if (seq <= 0) {
      try {
        // SDK 本地 max — 反映此设备已拉过的最大 seq.
        seq = await WKIM.shared.messageManager.getMaxMessageSeq(
          channelId,
          channelType,
        );
      } catch (e) {
        debugPrint('[im][clearMessages] getMaxMessageSeq failed: $e');
      }
      try {
        // Server 端 max — conversation snapshot 同步过来的 lastMsgSeq, 反映
        // server 真实持有的最大 seq. 当 SDK 本地从未拉过完整历史时
        // (e.g. 用户没进过这个会话就直接清空), local max << server max,
        // POST offset 只能卡到 local max → 下次 sync server 仍能返
        // local..server 之间的旧消息. 取两者 max 让 server channel offset
        // 卡到真实最大.
        final convMsg = await ConversationDB.shared.queryMsgByMsgChannelId(
          channelId,
          channelType,
        );
        if (convMsg != null && convMsg.lastMsgSeq > seq) {
          seq = convMsg.lastMsgSeq;
        }
      } catch (e) {
        debugPrint('[im][clearMessages] queryMsgByMsgChannelId failed: $e');
      }
    }
    await client.postJson('message/offset', {
      'channel_id': channelId,
      'channel_type': channelType,
      'message_seq': seq,
    });
    try {
      await WKIM.shared.messageManager.clearWithChannel(channelId, channelType);
    } catch (e) {
      // SDK clearWithChannel 失败 → SDK 本地 message 表没真删, 下次
      // SDK loadMessages 会把消息倒回来 = 用户报的"清空后又出现". 关键路径,
      // 必须 log.
      debugPrint('[im][clearMessages] SDK clearWithChannel failed: $e');
    }
    // 跟 deleteConversation 同款 — 调 SDK clearWithChannel 后 conversation
    // lastMessage 已 invalidate, 触发 _emitConversations 让 UI cell preview
    // 立即刷新.
    unawaited(_emitConversations());
  }

  @override
  Future<void> clearAllMessages() async {
    final conversations = await loadConversations();
    for (final conversation in conversations) {
      try {
        await WKIM.shared.messageManager.clearWithChannel(
          conversation.channelId,
          conversation.channelType,
        );
      } catch (e) {
        debugPrint(
          '[im][clearAll] clearWithChannel ${conversation.channelId} failed: $e',
        );
      }
    }
    try {
      await WKIM.shared.conversationManager.clearAll();
    } catch (e) {
      debugPrint('[im][clearAll] conversationManager.clearAll failed: $e');
    }
    if (!_conversationController.isClosed) {
      _conversationController.add(const []);
    }
  }

  @override
  Future<void> deleteMessages(List<WukongMessageReference> messages) async {
    if (messages.isEmpty) {
      return;
    }
    await client.deleteJson(
      'message',
      body: messages
          .map(
            (message) => {
              'message_id': message.messageId,
              'channel_id': message.channelId,
              'channel_type': message.channelType,
              'message_seq': message.messageSeq,
            },
          )
          .toList(),
    );
  }

  @override
  Future<void> revokeMessage(WukongMessageReference message) async {
    final path = Uri(
      path: 'message/revoke',
      queryParameters: {
        'channel_id': message.channelId,
        'channel_type': '${message.channelType}',
        'message_id': message.messageId,
        'client_msg_no': message.clientMsgNo,
      },
    ).toString();
    await client.postJson(path, const {});
  }

  @override
  Future<void> pinMessage(WukongMessageReference message) async {
    await client.postJson('message/pinned', {
      'message_id': message.messageId,
      'message_seq': message.messageSeq,
      'channel_id': message.channelId,
      'channel_type': message.channelType,
    });
  }

  @override
  Future<List<WukongPinnedMessageSnapshot>> syncPinnedMessages({
    required String channelId,
    required int channelType,
    int version = 0,
  }) async {
    final response = await client.postJson('message/pinned/sync', {
      'version': version,
      'channel_id': channelId,
      'channel_type': channelType,
    });
    final source = _source(response);
    // 服务端响应分两个数组：
    //   - pinned_messages[]: pin 元数据 (message_id / message_seq / version /
    //     is_deleted) **不含 payload**
    //   - messages[]: 跟 pinned 关联的实际消息内容 (含 payload)
    // 对齐 iOS WKPinnedService：iOS 把 messages[] 写进 SDK
    // chatManager 缓存，banner 通过 message_id 查 content。Flutter 没
    // SDK 全局消息缓存，所以在这里直接 join：以 pinned_messages 为主，
    // 用 messages[] 通过 message_id 补 payload → 注入到 snapshot.text。
    final pinnedRaw = _readList(source['pinned_messages']);
    final messagesRaw = _readList(source['messages']);
    // 索引 messages[] payload。两个 key 都建索引：
    //   - message_id (canonical) —— 主键
    //   - message_seq (channel-内序号) —— fallback，因为有时服务端从
    //     发件人 vs 收件人视角下 message_id 不一致（personal channel
    //     fakeChannelID 翻转），但 seq 在 channel 内对齐。
    // 索引完整 message map (不只 payload) 让 join 时能补 from_uid / timestamp
    // 给置顶列表页渲染头像 / 名字 / 时间.
    final msgByMsgId = <String, Map<String, dynamic>>{};
    final msgBySeq = <int, Map<String, dynamic>>{};
    for (final raw in messagesRaw) {
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        final id = _string(map['message_id']);
        if (id.isNotEmpty) msgByMsgId[id] = map;
        final seq = _readInt(map['message_seq']);
        if (seq > 0) msgBySeq[seq] = map;
      }
    }
    final result = <WukongPinnedMessageSnapshot>[];
    for (final raw in pinnedRaw) {
      if (raw is! Map) continue;
      final pinnedMap = Map<String, dynamic>.from(raw);
      // 服务端 isDeleted=1 的 pin 不要进 banner / 列表
      if (_readInt(pinnedMap['is_deleted']) != 0) continue;
      final msgId = _string(pinnedMap['message_id']);
      final seq = _readInt(pinnedMap['message_seq']);
      Map<String, dynamic>? joinedMsg;
      if (msgId.isNotEmpty && msgByMsgId.containsKey(msgId)) {
        joinedMsg = msgByMsgId[msgId];
      } else if (seq > 0 && msgBySeq.containsKey(seq)) {
        joinedMsg = msgBySeq[seq];
      }
      if (joinedMsg != null) {
        pinnedMap['payload'] = joinedMsg['payload'];
        pinnedMap['from_uid'] = joinedMsg['from_uid'];
        pinnedMap['timestamp'] = joinedMsg['timestamp'];
      }
      result.add(WukongPinnedMessageSnapshot.fromJson(pinnedMap));
    }
    return result;
  }

  @override
  Future<void> clearPinnedMessages({
    required String channelId,
    required int channelType,
  }) async {
    await client.postJson('message/pinned/clear', {
      'channel_id': channelId,
      'channel_type': channelType,
    });
  }

  @override
  Future<void> mutualDeleteMessages(
    List<WukongMessageReference> messages,
  ) async {
    if (messages.isEmpty) {
      return;
    }
    await client.deleteJson(
      'message/mutual',
      body: messages
          .map(
            (message) => {
              'message_id': message.messageId,
              'channel_id': message.channelId,
              'channel_type': message.channelType,
              'message_seq': message.messageSeq,
            },
          )
          .toList(),
    );
  }

  @override
  Future<void> editMessage({
    required WukongMessageReference message,
    required String content,
  }) async {
    // server 端 content_edit 字段期望 **JSON 格式 message payload**
    // (不是纯文本): server 入库后再 reload 时 util.ReadJsonByByte 解析,
    // 不是 JSON 会 fail / 回退原文.
    // iOS 走 WKMessageExtra.contentEditData (encoded payload bytes), 等价于
    // {"type": 1, "content": "新文本"}. Flutter 这里手 encode 一份, 之前
    // 直接传纯 content 字符串 → server 解析失败 → 编辑"一闪而过"显示已编辑.
    final payload = jsonEncode({
      'type': 1, // WkMessageContentType.text
      'content': content,
    });
    await client.postJson('message/edit', {
      'message_id': message.messageId,
      'message_seq': message.messageSeq,
      'channel_id': message.channelId,
      'channel_type': message.channelType,
      'content_edit': payload,
    });
  }

  @override
  Future<void> markMessagesRead({
    required String channelId,
    required int channelType,
    required List<String> messageIds,
  }) async {
    if (messageIds.isEmpty) {
      return;
    }
    await client.postJson('message/readed', {
      'message_ids': messageIds,
      'channel_id': channelId,
      'channel_type': channelType,
    });
  }

  @override
  Future<void> markVoiceMessageRead(WukongMessageReference message) async {
    await client.putJson('message/voicereaded', {
      'message_id': message.messageId,
      'channel_id': message.channelId,
      'channel_type': message.channelType,
      'message_seq': message.messageSeq,
    });
  }

  @override
  Future<void> sendTyping({
    required String channelId,
    required int channelType,
  }) async {
    await client.postJson('message/typing', {
      'channel_id': channelId,
      'channel_type': channelType,
    });
  }

  @override
  Future<Map<String, ChatUserPresence>> queryUserPresence(
    List<String> uids,
  ) async {
    if (uids.isEmpty) return const <String, ChatUserPresence>{};
    final response = await client.postAny('users/online', uids);
    if (response is! List) return const <String, ChatUserPresence>{};
    final result = <String, ChatUserPresence>{};
    for (final entry in response) {
      if (entry is! Map) continue;
      final uid = (entry['uid'] ?? '').toString();
      if (uid.isEmpty) continue;
      result[uid] = ChatUserPresence(
        uid: uid,
        online: _readInt(entry['online']) == 1,
        deviceFlag: _readInt(entry['device_flag']),
        lastOnline: _readInt(entry['last_online']),
        lastOffline: _readInt(entry['last_offline']),
      );
    }
    return result;
  }

  @override
  Future<void> purgeChannelMessages({
    required String channelId,
    required int channelType,
  }) async {
    await client.postJson(
      'channels/$channelId/$channelType/message/clear',
      const {},
    );
    try {
      await WKIM.shared.messageManager.clearWithChannel(channelId, channelType);
    } catch (e) {
      debugPrint('[im][clearChannelMessages] SDK clearWithChannel: $e');
    }
  }

  @override
  Future<void> setChannelMessageAutoDelete({
    required String channelId,
    required int channelType,
    required int retentionSeconds,
  }) async {
    await client.postJson(
      'channels/$channelId/$channelType/message/autodelete',
      {'auto_delete_at': retentionSeconds},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getMessageReceipts({
    required String messageId,
    required bool readed,
    int pageIndex = 1,
    int pageSize = 100,
  }) async {
    final query = Uri(
      queryParameters: {
        'readed': readed ? '1' : '0',
        'page_index': '$pageIndex',
        'page_size': '$pageSize',
      },
    ).query;
    final response = await client.getAny('messages/$messageId/receipt?$query');
    return _coerceList(response);
  }

  @override
  Future<List<Map<String, dynamic>>> syncMessageExtras({
    required String channelId,
    required int channelType,
    int extraVersion = 0,
    String source = '',
    int limit = 100,
  }) async {
    final response = await client.postAny('message/extra/sync', {
      'channel_id': channelId,
      'channel_type': channelType,
      'extra_version': extraVersion,
      'source': source,
      'limit': limit,
    });
    return _coerceList(response);
  }

  @override
  Future<ChatSensitiveWords> syncSensitiveWords({int version = 0}) async {
    final response = await client.getJson(
      'message/sync/sensitivewords?version=$version',
    );
    return ChatSensitiveWords.fromJson(_source(response));
  }

  ChatSensitiveWords _cachedSensitiveWords = const ChatSensitiveWords();
  Future<ChatSensitiveWords>? _sensitiveWordsInflight;

  /// SharedPreferences key prefix. 按 loginUid 隔离, 跟 SDK channel db 文件
  /// uid 隔离同款思路. logout 不删 prefs (跨账号自动隔离).
  static const String _sensitiveWordsPrefsPrefix = 'chatim.sensitive_words.';

  String _sensitiveWordsPrefsKey() {
    final uid = WKIM.shared.options.uid ?? '';
    return '$_sensitiveWordsPrefsPrefix$uid';
  }

  /// 从 SharedPreferences 同步加载敏感词. 对齐 iOS WKProhibitwordsService.load
  /// (读 JSON 文件). 调用时机: `connect()` 完成后, server warmSensitiveWords
  /// 之前. 即使 server 不可达, chat 仍能基于本地 cache 做敏感词警告.
  Future<void> _loadSensitiveWordsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_sensitiveWordsPrefsKey());
      if (raw == null || raw.isEmpty) return;
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final list = ((j['list'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toList();
      final tips = (j['tips'] as String?) ?? '';
      final version = j['version'] is int
          ? j['version'] as int
          : (int.tryParse(j['version']?.toString() ?? '') ?? 0);
      _cachedSensitiveWords = ChatSensitiveWords(
        tips: tips,
        list: List.unmodifiable(list),
        version: version,
      );
      debugPrint(
        '[sensitive] prefs hit: n=${list.length} v=$version tips="$tips"',
      );
    } catch (e) {
      debugPrint('[sensitive] prefs load fail: $e');
    }
  }

  /// 写 SharedPreferences. 对齐 iOS WKProhibitwordsService.save (写 JSON 文件).
  /// 调用时机: `_runSensitiveWordsRefresh` 拿到 server 新 delta 后.
  Future<void> _saveSensitiveWordsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode({
        'tips': _cachedSensitiveWords.tips,
        'list': _cachedSensitiveWords.list,
        'version': _cachedSensitiveWords.version,
      });
      await prefs.setString(_sensitiveWordsPrefsKey(), json);
    } catch (e) {
      debugPrint('[sensitive] prefs save fail: $e');
    }
  }

  @override
  ChatSensitiveWords get cachedSensitiveWords => _cachedSensitiveWords;

  @override
  Future<ChatSensitiveWords> warmSensitiveWords() {
    final inflight = _sensitiveWordsInflight;
    if (inflight != null) return inflight;
    final task = _runSensitiveWordsRefresh();
    _sensitiveWordsInflight = task;
    return task.whenComplete(() {
      if (identical(_sensitiveWordsInflight, task)) {
        _sensitiveWordsInflight = null;
      }
    });
  }

  Future<ChatSensitiveWords> _runSensitiveWordsRefresh() async {
    try {
      final fresh = await syncSensitiveWords(
        version: _cachedSensitiveWords.version,
      );
      // Server returns an empty list with the same version when there
      // are no changes. Keep the existing cache in that case so the UI
      // still has the prior word list to match against.
      bool changed = false;
      if (fresh.list.isNotEmpty ||
          fresh.version > _cachedSensitiveWords.version) {
        _cachedSensitiveWords = fresh;
        changed = true;
      } else if (fresh.tips.isNotEmpty &&
          fresh.tips != _cachedSensitiveWords.tips) {
        _cachedSensitiveWords = ChatSensitiveWords(
          tips: fresh.tips,
          list: _cachedSensitiveWords.list,
          version: _cachedSensitiveWords.version,
        );
        changed = true;
      }
      // 写回 SharedPreferences 让下次冷启动 cold-start 秒显. 跟 iOS
      // WKProhibitwordsService.save 同模式. async 不 await: server fetch
      // 已经完成, UI 已能用 latest cache, prefs 写慢一拍无碍.
      if (changed) {
        unawaited(_saveSensitiveWordsToPrefs());
      }
      return _cachedSensitiveWords;
    } catch (_) {
      // Network / auth errors are non-fatal — UI just falls back to no
      // matches. Returning the existing cache so callers can still
      // render against whatever we last had.
      return _cachedSensitiveWords;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> syncProhibitWords({
    int version = 0,
  }) async {
    final response = await client.getAny(
      'message/prohibit_words/sync?version=$version',
    );
    return _coerceList(response);
  }

  @override
  Future<List<Map<String, dynamic>>> syncReminders({
    int version = 0,
    int limit = 100,
    List<String> channelIds = const [],
  }) async {
    final response = await client.postAny('message/reminder/sync', {
      'version': version,
      'limit': limit,
      'channel_ids': channelIds,
    });
    return _coerceList(response);
  }

  @override
  Future<void> markRemindersDone(List<int> ids) async {
    if (ids.isEmpty) {
      return;
    }
    await client.postAny('message/reminder/done', ids);
  }

  @override
  Future<void> sendReaction({
    required String messageId,
    required String channelId,
    required int channelType,
    required String emoji,
  }) async {
    // ignore: avoid_print
    print(
      '[reaction] sendReaction → POST /reactions msg=$messageId '
      'ch=$channelId/$channelType emoji=$emoji',
    );
    try {
      final result = await client.postJson('reactions', {
        'message_id': messageId,
        'channel_id': channelId,
        'channel_type': channelType,
        'emoji': emoji,
      });
      // ignore: avoid_print
      print('[reaction] sendReaction ← OK $result');
    } catch (error) {
      // ignore: avoid_print
      print('[reaction] sendReaction FAILED: $error');
      rethrow;
    }
    // Immediately pull the just-sent reaction back through
    // `reaction/sync` so it lands in the SDK's local ReactionDB.
    // Without this, the in-app bubble shows the emoji optimistically
    // but the next chat-open re-queries WKMsg.reactionList from DB
    // and renders an empty strip.
    unawaited(
      syncAndStoreReactions(channelId: channelId, channelType: channelType),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> syncReactions({
    required String channelId,
    required int channelType,
    int seq = 0,
    int limit = 100,
  }) async {
    final response = await client.postAny('reaction/sync', {
      'channel_id': channelId,
      'channel_type': channelType,
      'seq': seq,
      'limit': limit,
    });
    return _coerceList(response);
  }

  @override
  Future<List<Map<String, Object>>> queryReactionUsers(String messageId) async {
    if (messageId.isEmpty) return const [];
    try {
      final rows = await ReactionDB.shared.queryWithMessageId(messageId);
      return [
        for (final r in rows)
          if (r.isDeleted != 1)
            <String, Object>{'uid': r.uid, 'name': r.name, 'emoji': r.emoji},
      ];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<Map<String, String>>> queryMessageReceipt({
    required String messageId,
    required String channelId,
    required int channelType,
    required bool readed,
  }) async {
    if (messageId.isEmpty) return const [];
    try {
      final query = Uri(
        queryParameters: {
          'readed': readed ? '1' : '0',
          'channel_id': channelId,
          'channel_type': '$channelType',
          'page_size': '1000',
        },
      );
      final data = await client.getAny(
        'messages/$messageId/receipt?${query.query}',
      );
      return [
        for (final raw in _coerceList(data))
          <String, String>{
            'uid': (raw['uid'] ?? '').toString(),
            'name': (raw['name'] ?? '').toString(),
          },
      ];
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> syncAndStoreReactions({
    required String channelId,
    required int channelType,
  }) async {
    // Mirrors iOS WKReactionManager.sync(channel): query the SDK's
    // current max reaction-seq for the channel, ask the server for
    // everything newer, then write into the SDK's reaction DB so the
    // next message-list read joins reactions back onto WKMsg rows.
    try {
      final maxSeq = await WKIM.shared.messageManager
          .getMaxReactionSeqWithChannel(channelId, channelType);
      // ignore: avoid_print
      print('[reaction] sync entry ch=$channelId/$channelType maxSeq=$maxSeq');
      final rows = await syncReactions(
        channelId: channelId,
        channelType: channelType,
        seq: maxSeq,
      );
      // ignore: avoid_print
      print(
        '[reaction] sync server returned ${rows.length} rows: '
        '${rows.isEmpty ? "(empty)" : rows.first}',
      );
      if (rows.isEmpty) return;
      final reactions = <WKSyncMsgReaction>[];
      for (final raw in rows) {
        final messageId =
            (raw['message_id_str'] ?? raw['message_id']?.toString() ?? '')
                .toString();
        if (messageId.isEmpty) continue;
        final entry = WKSyncMsgReaction()
          ..messageID = messageId
          ..channelID = (raw['channel_id'] ?? channelId).toString()
          ..channelType = _readInt(raw['channel_type']) == 0
              ? channelType
              : _readInt(raw['channel_type'])
          ..uid = (raw['uid'] ?? '').toString()
          ..name = (raw['name'] ?? '').toString()
          ..seq = _readInt(raw['seq'])
          ..emoji = (raw['emoji'] ?? '').toString()
          ..isDeleted = _readInt(raw['is_deleted'])
          ..createdAt = (raw['created_at'] ?? '').toString();
        reactions.add(entry);
      }
      if (reactions.isEmpty) {
        // ignore: avoid_print
        print(
          '[reaction] sync DROPPED all rows during parse '
          '(message_id empty? raw=${rows.first})',
        );
        return;
      }
      await WKIM.shared.messageManager.saveMessageReactions(reactions);
      // ignore: avoid_print
      print(
        '[reaction] sync saved ${reactions.length} entries to ReactionDB '
        '(first: msg=${reactions.first.messageID} '
        'emoji=${reactions.first.emoji} '
        'uid=${reactions.first.uid})',
      );
    } catch (error, stack) {
      // ignore: avoid_print
      print(
        '[reaction] sync FAILED for $channelId/$channelType: $error\n$stack',
      );
    }
  }

  @override
  Future<void> ackConversationSync({
    required int cmdVersion,
    required String deviceUuid,
  }) async {
    await client.postJson('conversation/syncack', {
      'cmd_version': cmdVersion,
      'device_uuid': deviceUuid,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> syncConversationExtras({
    int version = 0,
  }) async {
    final response = await client.postAny('conversation/extra/sync', {
      'version': version,
    });
    return _coerceList(response);
  }

  @override
  Future<void> updateConversationExtra({
    required String channelId,
    required int channelType,
    int browseTo = 0,
    int keepMessageSeq = 0,
    int keepOffsetY = 0,
    String draft = '',
  }) async {
    await client.postJson('conversations/$channelId/$channelType/extra', {
      'browse_to': browseTo,
      'keep_message_seq': keepMessageSeq,
      'keep_offset_y': keepOffsetY,
      'draft': draft,
    });
    // server PUT 后立刻 emit — 让本机 conversation list re-build snapshot.
    // _mapConversation 会从 SharedPreferences 读 draft (SDK 端 conversation_extra
    // 表写入只能靠 server CMD push, 本机写入只能走 prefs fallback).
    unawaited(_emitConversations());
  }

  static List<Map<String, dynamic>> _coerceList(Object? raw) {
    final list = <Map<String, dynamic>>[];
    if (raw is List) {
      for (final entry in raw) {
        if (entry is Map) {
          list.add(Map<String, dynamic>.from(entry));
        }
      }
    } else if (raw is Map) {
      final inner = raw['data'] ?? raw['list'] ?? raw['items'];
      if (inner is List) {
        for (final entry in inner) {
          if (entry is Map) {
            list.add(Map<String, dynamic>.from(entry));
          }
        }
      }
    }
    return list;
  }

  @override
  Future<ChatMessageBackupResult> backupMessages() async {
    final messages = await _loadBackupMessages();
    final payload = jsonEncode(messages.map(_messageBackupJson).toList());
    final file = await _writeBackupFile(payload, suffix: 'backup');
    await client.uploadFile('message/backup', file.path);
    return ChatMessageBackupResult(
      messageCount: messages.length,
      byteCount: utf8.encode(payload).length,
      filePath: file.path,
    );
  }

  @override
  Future<ChatMessageRecoveryResult> recoverMessages() async {
    final bytes = await client.downloadBytes('message/recovery');
    final file = await _writeBackupBytes(bytes, suffix: 'recovery');
    return ChatMessageRecoveryResult(
      messageCount: _countRecoveredMessages(bytes),
      byteCount: bytes.length,
      filePath: file.path,
    );
  }

  static void disconnect() {
    WKIM.shared.connectionManager.disconnect(true);
  }

  static String extractTcpAddress(Map<String, dynamic> route) {
    return extractConnectAddress(route);
  }

  static String extractConnectAddress(Map<String, dynamic> route) {
    final source = _source(route);
    for (final key in [
      'wss_addr',
      'wssAddr',
      'ws_addr',
      'wsAddr',
      'tcp_addr',
      'tcpAddr',
      'addr',
      'address',
    ]) {
      final value = source[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  static void registerExtendedMessageContentsForTests({
    FeatureRegistry? featureRegistry,
  }) {
    _registerExtendedMessageContents(featureRegistry: featureRegistry);
  }

  static void _registerExtendedMessageContents({
    FeatureRegistry? featureRegistry,
  }) {
    WKIM.shared.messageManager.registerMsgContent(
      _wkGroupApproveContentType,
      (dynamic data) => WKGroupApproveContent().decodeJson(data),
    );
    // Screenshot notification (contentType 20): payload carries
    // `from_uid` + `from_name`. The chat will render these as a centered
    // system row "{name}在聊天中截屏了".
    WKIM.shared.messageManager.registerMsgContent(
      _wkScreenshotContentType,
      (dynamic data) => WKScreenshotContent().decodeJson(data),
    );
    // Merge-forward (t=11) gets a dedicated content class so the bubble can
    // surface title + per-msg preview rows + tap-to-detail. Pre-empts the
    // generic '[合并消息]' label registration below.
    WKIM.shared.messageManager.registerMsgContent(
      _wkMergeForwardContentType,
      (dynamic data) => WKMergeForwardContent().decodeJson(data),
    );
    final moduleContentRegistrations = _enabledMessageContentRegistrations(
      featureRegistry,
    ).toList();
    final moduleContentTypes = {
      for (final registration in moduleContentRegistrations)
        registration.contentType,
    };
    for (final registration in moduleContentRegistrations) {
      WKIM.shared.messageManager.registerMsgContent(
        registration.contentType,
        registration.decoder,
      );
    }
    // Register every native ContentType the server can produce so the SDK
    // never falls back to WKUnknownContent ('[未知消息]'). Each registration
    // produces a friendly placeholder displayText that matches native iOS
    // GetDisplayText output (TangSengDaoDaoServerLib/common/msg.go).
    for (final entry in _genericContentLabels.entries) {
      final type = entry.key;
      if (moduleContentTypes.contains(type)) {
        continue;
      }
      final label = entry.value;
      WKIM.shared.messageManager.registerMsgContent(
        type,
        (dynamic data) => WKGenericLabelContent(type, label).decodeJson(data),
      );
    }
  }

  static Iterable<MessageContentRegistration>
  _enabledMessageContentRegistrations(FeatureRegistry? featureRegistry) {
    if (featureRegistry == null) return const [];
    return featureRegistry
        .enabledFeatures(kind: FeatureKind.messageContentHandler)
        .map((feature) => feature.value)
        .whereType<MessageContentRegistration>();
  }

  /// Native ContentType → friendly preview text. Mirrors
  /// `common.GetDisplayText` and the system-message subtitles surfaced by
  /// WKConversationListCell when the content type has no rich UI. 跟 iOS
  /// `WuKongBase/Classes/WKConstant.h` 的 WK_* enum 对齐 (line 300-345).
  static const Map<int, String> _genericContentLabels = {
    // ---- rich content without dedicated cell yet ----
    // 7 (card) is handled by the SDK's built-in WKCardContent — DO NOT
    // register it here as a generic label, that would overwrite the SDK
    // decoder and `_mapMessage` could not see `content is WKCardContent`.
    // 11 (merge-forward) is registered as WKMergeForwardContent in
    // _registerExtendedMessageContents — keep this map without 11.
    // 14 (WK_RICHTEXT) 由 WKRichTextContent 专门接管, 不走 generic label.
    3: '[表情]',
    16: '[组织邀请]',
    97: '[消息格式错误]',
    98: '[安全消息]',
    // ---- group / friend system events (1000-1099, WKConstant.h:320-339) ----
    1000: '好友申请', // WK_FRIEND_REQUEST (注: iOS 注释说"已废弃走 cmd", 保留以防遗留消息)
    1001: '创建了群聊', // server 历史下发, iOS constant 没列, 保留兼容
    1002: '加入了群聊', // WK_GROUP_MEMBERADD
    1003: '被移出了群聊', // WK_GROUP_MEMBERREMOVE
    1004: '通过了好友请求', // WK_FRIEND_ACCEPTED
    1005:
        '更新了群信息', // WK_GROUP_UPDATE (改名/改公告/改头像等子类型由 SDK displayText 走 placeholder)
    1006: '撤回了一条消息', // WK_MESSAGE_REVOKE
    1007: '通过扫码加入了群聊', // WK_GROUP_MEMBERSCANJOIN
    1008: '转让了群主', // WK_GROUP_TRANSFERGROUPER
    1009: '邀请入群', // WK_GROUP_MEMBERINVITE
    1010: '拒绝入群邀请', // WK_GROUP_MEMBERREFUND
    1011: '领取了红包', // WK_REDPACKET_OPEN
    1012: '交易通知', // WK_TRADE_SYSTEM_NOTIFY (转账/红包退回等)
    1013: '群内禁止互加好友', // WK_GROUP_FORBIDDEN_ADD_FRIEND
    1020: '已被移出群聊',
    1021: '退出了群聊',
    1022: '群已升级', // WK_GROUP_UPGRADE
    // ---- hotline (1200-1299) ----
    1200: '已分配客服',
    1201: '会话已解决',
    1202: '会话已重新打开',
    // ---- generic tip ----
    2000: '提示', // WK_TIP
    // ---- 音视频通话 (WKConstant.h:344-345) ----
    9989: '通话已结束', // WK_VIDEOCALL_RESULT
    9990: '已切换到视频通话', // WK_VIDEOCALL_SWITCH_TO_VIDEO
  };

  static WKSyncConversation parseSyncConversation(
    Map<String, dynamic> response,
  ) {
    final source = _source(response);
    final sync = WKSyncConversation()
      ..uid = _string(source['uid'])
      ..cmdVersion = _readInt(source['cmd_version'])
      ..conversations = [];

    for (final item in _readList(source['conversations'])) {
      if (item is! Map) {
        continue;
      }
      final json = Map<String, dynamic>.from(item);
      final conversation = WKSyncConvMsg()
        ..channelID = _string(json['channel_id'])
        ..channelType = _readInt(json['channel_type'])
        ..unread = _readInt(json['unread'])
        ..timestamp = _readInt(json['timestamp'])
        ..lastMsgSeq = _readInt(json['last_msg_seq'])
        ..lastClientMsgNO = _string(json['last_client_msg_no'])
        ..version = _readInt(json['version'])
        ..recents = [];

      for (final message in _readList(json['recents'])) {
        if (message is Map) {
          conversation.recents!.add(parseSyncMessage(message));
        }
      }
      sync.conversations!.add(conversation);
    }

    return sync;
  }

  static WKSyncChannelMsg parseSyncChannelMessages(
    Map<String, dynamic> response,
  ) {
    final source = _source(response);
    final sync = WKSyncChannelMsg()
      ..startMessageSeq = _readInt(source['start_message_seq'])
      ..endMessageSeq = _readInt(source['end_message_seq'])
      ..more = _readInt(source['more'])
      ..messages = [];

    for (final message in _readList(source['messages'])) {
      if (message is Map) {
        sync.messages!.add(parseSyncMessage(message));
      }
    }
    return sync;
  }

  static List<WKChannel> parseChannelsFromSyncResponse(
    Map<String, dynamic> response,
  ) {
    final source = _source(response);
    final channels = <WKChannel>[];

    for (final item in _readList(source['users'])) {
      if (item is Map) {
        final user = Map<String, dynamic>.from(item);
        final channel = _channelFromJson(
          user,
          fallbackChannelId: _string(user['uid']),
          fallbackChannelType: WKChannelType.personal,
        );
        if (channel.channelID.isNotEmpty) {
          channels.add(channel);
        }
      }
    }

    for (final item in _readList(source['groups'])) {
      if (item is Map) {
        final group = Map<String, dynamic>.from(item);
        final channel = _channelFromJson(
          group,
          fallbackChannelId: _string(group['group_no']),
          fallbackChannelType: WKChannelType.group,
        );
        if (channel.channelID.isNotEmpty) {
          channels.add(channel);
        }
      }
    }

    return channels;
  }

  static WKChannel parseChannelInfo(
    Map<String, dynamic> response, {
    required String fallbackChannelId,
    required int fallbackChannelType,
  }) {
    final source = _source(response);
    final channelMap = _readMap(source['channel']);
    return _channelFromJson(
      source,
      fallbackChannelId: _string(
        channelMap['channel_id'],
        fallback: fallbackChannelId,
      ),
      fallbackChannelType: _readInt(
        channelMap['channel_type'],
        fallback: fallbackChannelType,
      ),
    );
  }

  static WKSyncMsg parseSyncMessage(Map<dynamic, dynamic> input) {
    final json = Map<String, dynamic>.from(input);
    final message = WKSyncMsg()
      ..messageID = _string(json['message_id'])
      ..messageSeq = _readInt(json['message_seq'])
      ..clientMsgNO = _string(json['client_msg_no'])
      ..fromUID = _string(json['from_uid'])
      ..channelID = _string(json['channel_id'])
      ..channelType = _readInt(json['channel_type'])
      ..timestamp = _readInt(json['timestamp'])
      ..voiceStatus = _readInt(json['voice_status'])
      ..isDeleted = _readInt(json['is_deleted'])
      ..revoke = _readInt(json['revoke'])
      ..extraVersion = _readInt(json['extra_version'])
      ..unreadCount = _readInt(json['unread_count'])
      ..readedCount = _readInt(json['readed_count'])
      ..readed = _readInt(json['readed'])
      ..receipt = _readInt(json['receipt'])
      ..setting = _readInt(json['setting'])
      ..payload = _readPayload(json['payload']);

    final extra = json['message_extra'];
    if (extra is Map) {
      final extraVoiceStatus = _readInt(extra['voice_status']);
      message.messageExtra = WKSyncExtraMsg()
        ..messageID = _readInt(extra['message_id'])
        ..messageIdStr = _string(extra['message_id_str'])
        ..revoke = _readInt(extra['revoke'])
        ..voiceStatus = extraVoiceStatus
        ..isMutualDeleted = _readInt(extra['is_mutual_deleted'])
        ..extraVersion = _readInt(extra['extra_version'])
        ..unreadCount = _readInt(extra['unread_count'])
        ..readedCount = _readInt(extra['readed_count'])
        ..replyCount = _readInt(extra['reply_count'])
        ..readed = _readInt(extra['readed'])
        ..contentEdit = _contentEditPayloadForSdk(extra['content_edit'])
        ..editedAt = _readInt(extra['edited_at']);
      // Promote `message_extra.voice_status` onto the top-level
      // `WKSyncMsg` so SDK 1.7.9's `getWKMsg()` (which only carries
      // the top-level value forward) doesn't lose the listened state
      // when a refresh / sync re-renders the message. Without this
      // patch, the SDK's own `wkSyncExtraMsg2WKMsgExtra` drops the
      // extra-side voice_status and previously-listened messages
      // come back as `voiceStatus = 0` — the local-heard set masks
      // it during a single chat session, but a chat reopen reverted
      // the dot. Promotion: take the higher of the two (0/1) so a
      // server-synced 1 can never be downgraded by a stale top-level
      // 0 baked into the same payload.
      if (extraVoiceStatus > message.voiceStatus) {
        message.voiceStatus = extraVoiceStatus;
      }
    }
    return message;
  }

  void _registerSyncListeners(UserSession session) {
    WKIM.shared.conversationManager.addOnSyncConversationListener((
      lastMsgSeqs,
      msgCount,
      version,
      complete,
    ) async {
      if (_disposed) {
        complete(WKSyncConversation()..conversations = []);
        return;
      }
      try {
        final data = await client.postJson('conversation/sync', {
          'login_uid': session.uid,
          'version': version,
          'last_msg_seqs': lastMsgSeqs,
          'msg_count': msgCount,
          'device_uuid': await client.deviceId(),
        });
        if (_disposed) {
          complete(WKSyncConversation()..conversations = []);
          return;
        }
        _cacheChannelsFromSync(data);
        complete(parseSyncConversation(data));
      } catch (_) {
        complete(WKSyncConversation()..conversations = []);
      }
    });

    WKIM.shared.messageManager.addOnSyncChannelMsgListener((
      channelId,
      channelType,
      startMessageSeq,
      endMessageSeq,
      limit,
      pullMode,
      complete,
    ) async {
      if (_disposed) {
        complete(WKSyncChannelMsg()..messages = []);
        return;
      }
      try {
        final data = await client.postJson('message/channel/sync', {
          'login_uid': session.uid,
          'channel_id': channelId,
          'channel_type': channelType,
          'start_message_seq': startMessageSeq,
          'end_message_seq': endMessageSeq,
          'limit': limit,
          'pull_mode': pullMode,
        });
        if (_disposed) {
          complete(WKSyncChannelMsg()..messages = []);
          return;
        }
        complete(parseSyncChannelMessages(data));
      } catch (_) {
        complete(WKSyncChannelMsg()..messages = []);
      }
    });

    WKIM.shared.channelManager.addOnGetChannelListener((
      channelId,
      channelType,
      complete,
    ) async {
      if (_disposed) {
        return;
      }
      final channel = await _fetchAndCacheChannel(channelId, channelType);
      if (_disposed) {
        return;
      }
      if (channel != null) {
        complete(channel);
      }
    });

    WKIM.shared.channelManager.addOnRefreshListener(
      _flutterGatewayKey,
      (_) => unawaited(_emitConversations()),
    );
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      _flutterGatewayKey,
      (_) => unawaited(_emitConversations()),
    );
    WKIM.shared.messageManager.addOnNewMsgListener(_flutterGatewayKey, (
      messages,
    ) {
      if (_disposed) {
        return;
      }
      _emitMessages(messages);
      unawaited(_emitConversations());
    });
    WKIM.shared.messageManager.addOnMsgInsertedListener((message) {
      if (_disposed) {
        return;
      }
      _emitMessages([message]);
      unawaited(_emitConversations());
    });
    // Refresh fires when an existing message's metadata changes — most
    // importantly when the server delivers a `readed` ack from the peer for
    // one of OUR sent messages, which is how the sender's bubble flips from
    // ✓ to ✓✓ in native iOS.
    //
    // Critical: `saveRemoteExtraMsg` (extras sync path inside the SDK)
    // queries WKMsg via `MessageDB.queryWithMessageIds`, which JOINs only
    // the messageExtra table — NOT the reaction table. The msg delivered
    // to this listener therefore has `reactionList == null` even when
    // ReactionDB has rows for that message_id. Without re-querying, the
    // emitted snapshot has empty reactions and the chat screen's
    // `_handleGatewayMessage` overwrites the previously-rendered bubble
    // (which had reactions) with the reaction-less version — the visual
    // bug "进入对话表情有时有有时没有". Re-query reactions from DB here
    // so the emitted snapshot always reflects DB truth.
    WKIM.shared.messageManager.addOnRefreshMsgListener(_flutterGatewayKey, (
      message,
    ) {
      if (_disposed) {
        return;
      }
      if (message.messageContent is WKMediaMessageContent) {
        debugPrint(
          '[media-send] refresh clientMsgNo=${message.clientMsgNO} '
          'status=${message.status} → ${_sendStatus(message.status)}',
        );
      }
      unawaited(_hydrateReactionsAndEmit(message));
      unawaited(_emitConversations());
    });
    WKIM.shared.messageManager.addOnUploadAttachmentListener((message, done) {
      if (_disposed) {
        done(false, message);
        return;
      }
      final content = message.messageContent;
      if (content is WKMediaMessageContent && content.url.isNotEmpty) {
        debugPrint(
          '[media-send] SDK upload ok url-present clientMsgNo=${message.clientMsgNO}',
        );
        done(true, message);
        return;
      }
      debugPrint(
        '[media-send] SDK upload fail url-empty clientMsgNo=${message.clientMsgNO}',
      );
      done(false, message);
    });
  }

  void _cacheChannelsFromSync(Map<String, dynamic> data) {
    final channels = parseChannelsFromSyncResponse(data);
    if (channels.isNotEmpty) {
      WKIM.shared.channelManager.addOrUpdateChannels(channels);
    }
  }

  @override
  Future<void> refreshChannel({
    required String channelId,
    required int channelType,
  }) async {
    final fresh = await _fetchAndCacheChannel(channelId, channelType);
    if (fresh != null) {
      // Bump the SDK's per-channel cache key so any cached avatar
      // URLs invalidate (the conversation list / chat header rebuild
      // their `imageUrl` from `config.showUrl(...)?v=cacheKey`).
      WKIM.shared.channelManager.updateAvatarCacheKey(
        channelId,
        channelType,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }
    // Re-emit so subscribers (conversation list + chat screen) pick
    // up the new title / avatar even when the SDK didn't fire its
    // own refresh listener.
    await _emitConversations();
  }

  Future<WKChannel?> _fetchAndCacheChannel(
    String channelId,
    int channelType,
  ) async {
    try {
      final data = await client.getJson('channels/$channelId/$channelType');
      final channel = parseChannelInfo(
        data,
        fallbackChannelId: channelId,
        fallbackChannelType: channelType,
      );
      if (channel.channelID.isEmpty) {
        return null;
      }
      WKIM.shared.channelManager.addOrUpdateChannel(channel);
      return channel;
    } catch (_) {
      return null;
    }
  }

  Future<void> _evictLegacyAvatarCachesOnce(
    Iterable<WKChannel?> channels, {
    required String scope,
  }) async {
    final paths = legacyAvatarCachePathsForChannels(channels);
    if (paths.isEmpty) return;
    final loginUid = (WKIM.shared.options.uid ?? '').trim();
    final account = loginUid.isEmpty ? 'anonymous' : loginUid;
    final key =
        'im.avatar.legacyFixedCacheEvicted.v1.'
        '${serverStorageScope(client.config)}.$account.$scope';
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(key) == true) return;
      await Future.wait(
        paths.map(
          (path) => CachedNetworkImage.evictFromCache(
            client.config.showUrl(path),
          ).catchError((_) => false),
        ),
      );
      await prefs.setBool(key, true);
    } catch (e) {
      debugPrint('[avatar] legacy cache eviction skipped: $e');
    }
  }

  Future<void> _emitConversations() async {
    if (_disposed || _conversationController.isClosed) {
      return;
    }
    final conversations = await loadConversations();
    if (!_disposed && !_conversationController.isClosed) {
      _conversationController.add(conversations);
    }
  }

  /// 数据源层"可展示消息"唯一入口 — 用于 emit / hydrate / preview / cache
  /// write 统一语义, 不让 SDK 已删 / 互删 message 漏到 UI 层.
  ///
  /// 对齐 SDK 历史查询 SQL (~/.pub-cache/.../lib/db/message.dart:197):
  ///   `where is_deleted=0 and is_mutual_deleted=0`
  ///
  /// 之前只 filter isDeleted, 漏了 isMutualDeleted (对方"为双方删除消息"
  /// 时 server extra sync 推下来 is_mutual_deleted=1, SDK 先 refresh emit
  /// 再软删 DB, 中间窗口 chatim 收到的 message isDeleted=0 / isMutualDeleted=1
  /// → UI 累积). 对齐 iOS `WKChatManager.m:1792-1806` extra sync 互删处理
  /// + Android `ChatActivity.java:780-787` refresh listener 互删 remove 模式.
  static bool shouldSurfaceMessage(WKMsg message) {
    return message.isDeleted != 1 &&
        (message.wkMsgExtra?.isMutualDeleted ?? 0) != 1;
  }

  /// 当前本地持久化仍由 SDK 管理；先与展示入口保持同一语义，避免阶段 1-2
  /// 新增 hydration / cache write 时又绕出第二套 filter。
  static bool shouldPersistMessage(WKMsg message) =>
      shouldSurfaceMessage(message);

  bool _shouldSurfaceMessage(WKMsg message) => shouldSurfaceMessage(message);

  void _emitMessages(List<WKMsg> messages) {
    if (_disposed || _messageController.isClosed) {
      return;
    }
    for (final message in messages) {
      if (_disposed || _messageController.isClosed) {
        return;
      }
      // 清空聊天记录后, SDK 仍可能因为 sync / extras refresh / hydrate
      // 等路径 fire `addOnNewMsgListener` / `addOnMsgInsertedListener` /
      // `addOnRefreshMsgListener`, 把本地标了 is_deleted=1 的旧消息再 emit
      // 一遍 (msgId 跟清空前一致). ChatScreen `_handleGatewayMessage` 不
      // 查 SDK is_deleted 状态, 直接 add 到 _messages → 每进会话累 +1 条.
      // 数据源层 filter: is_deleted / is_mutual_deleted → 不 emit. 见
      if (!_shouldSurfaceMessage(message)) {
        continue;
      }
      _messageController.add(_mapMessage(message));
    }
  }

  /// Re-hydrate `message.reactionList` from `ReactionDB` before emitting.
  /// Used by the refresh-msg listener path because the SDK's
  /// `saveRemoteExtraMsg` re-queries WKMsg without joining the reaction
  /// table, leaving `reactionList == null`. Emitting that snapshot would
  /// visually clear a previously-rendered reaction strip in the chat
  /// page even though the rows are still present in `ReactionDB`.
  Future<void> _hydrateReactionsAndEmit(WKMsg message) async {
    if (_disposed || _messageController.isClosed) return;
    // 跟 _emitMessages 同款 filter — refresh listener 也会 fire 已删 / 互删消息.
    if (!_shouldSurfaceMessage(message)) {
      return;
    }
    if (message.messageID.isNotEmpty) {
      try {
        final reactions = await ReactionDB.shared.queryWithMessageId(
          message.messageID,
        );
        // Overwrite even when empty — the DB is the source of truth.
        // If a user toggled their reaction off (isDeleted=1), the DB
        // query already filters those out, and emitting an empty list
        // correctly removes the chip from the UI.
        message.reactionList = reactions;
      } catch (_) {
        // Best-effort: fall through to whatever reactionList the SDK
        // delivered (likely null), which is no worse than the current
        // behaviour.
      }
    }
    if (_disposed || _messageController.isClosed) return;
    _messageController.add(_mapMessage(message));
  }

  /// Conversation-list previews come from `messageContent.displayText()`,
  /// which on the Flutter SDK preserves `{0}` / `{1}` placeholders.
  /// Native iOS WKSystemContent runs this substitution inside the SDK
  /// itself (see `getDisplayContent` in the iOS SDK), but the Dart SDK
  /// doesn't — the app has to do it. Mirror the iOS rule:
  ///   * Each `{i}` ← `extra[i].name` (or "你" if extra[i].uid is the
  ///     login user — the iOS SDK self-references like this).
  ///   * If extra has no entry at index `i`, leave `{i}` alone rather
  ///     than dropping a generic "某人" placeholder onto the user.
  String _substituteSystemPlaceholders(String text, WKMsg? message) {
    if (text.isEmpty || !text.contains('{')) {
      return text;
    }

    // Pull the raw payload. `WKGenericLabelContent` exposes `raw`
    // (preferred — that's where `extra` lives for 1003/1005/1020/1021
    // group system events). For other content types fall back to
    // `contentObj` if the SDK exposes it.
    Map<String, dynamic>? payload;
    final content = message?.messageContent;
    if (content is WKGenericLabelContent) {
      payload = content.raw;
    } else {
      try {
        final raw = (content as dynamic)?.contentObj;
        if (raw is Map<String, dynamic>) {
          payload = raw;
        } else if (raw is Map) {
          payload = Map<String, dynamic>.from(raw);
        }
      } catch (_) {
        payload = null;
      }
    }
    if (payload == null) {
      return text;
    }

    final extra = payload['extra'];
    List? entries;
    if (extra is List) {
      entries = extra;
    } else if (extra is Map && extra['users'] is List) {
      entries = extra['users'] as List;
    } else if (payload['users'] is List) {
      // Some 1003/1021 events surface users at the top level.
      entries = payload['users'] as List;
    }
    if (entries == null) {
      return text;
    }

    final loginUid = WKIM.shared.options.uid ?? '';
    var resolved = text;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      String name = '';
      String uid = '';
      if (entry is Map) {
        uid = (entry['uid'] ?? entry['user_id'] ?? '').toString();
        name =
            (entry['name'] ?? entry['nickname'] ?? entry['display_name'] ?? '')
                .toString();
      } else if (entry != null) {
        name = entry.toString();
      }
      if (uid.isNotEmpty && uid == loginUid) {
        name = '你';
      }
      if (name.isEmpty) continue;
      resolved = resolved.replaceAll('{$i}', name);
    }
    return resolved;
  }

  Future<WukongConversationSnapshot> _mapConversation(
    WKUIConversationMsg conversation, {
    List<WKChannel>? legacyAvatarCacheChannels,
  }) async {
    var channel = await conversation.getWkChannel();
    if (needsChannelInfoRefresh(channel, rawIdentity: conversation.channelID)) {
      channel = await _fetchAndCacheChannel(
        conversation.channelID,
        conversation.channelType,
      );
    }
    if (channel != null) {
      legacyAvatarCacheChannels?.add(channel);
    }
    var message = await conversation.getWkMsg();
    // 清空聊天记录后 preview filter — SDK clearWithChannel 把 message 表所有
    // row 标 is_deleted=1, 但 conversation.last_client_msg_no 不变. SDK 的
    // queryWithClientMsgNo (lib/db/message.dart:83) 不 filter is_deleted,
    // 这里 conversation.getWkMsg() 还能拿到已删 message → preview 会显示已
    // 清空的内容. iOS WKConversationListCell.m:322-334 也无此 filter (同款
    // latent bug, 触发刷新路径不同没人报). 直接在 chatim 层 filter, 不动
    // SDK SQL (SDK queryWithClientMsgNo 还被 deleteWithClientMsgNo 内部用,
    // 加 filter 会 break 该路径的 fixup conversation lastMessage 流程).
    //
    // 把整条 message 视为 null — 让 preview / senderName / status icon 全部
    // 走 message==null 路径归零. 之前只把 rawPreview='' 但 senderName 还在,
    // 列表 cell 显示 "A：" (空 body + 群发送者前缀 "$name: "). 见
    // MoyuConvPreviewBuilder.build moyu_widgets.dart:1389-1394.
    //
    // 用 shouldSurfaceMessage 跟 stream emit 路径统一语义 — 也 filter
    // 互删 (isMutualDeleted=1), 不让对方双向删除的消息漏成列表 cell preview.
    if (message != null && !_shouldSurfaceMessage(message)) {
      message = null;
    }
    final title = _channelTitle(channel, rawIdentity: conversation.channelID);
    final avatarPath = _avatarFor(
      channel?.avatar ?? '',
      conversation.channelID,
      conversation.channelType,
      cacheKey: channel?.avatarCacheKey ?? '',
    );
    String rawPreview;
    if (message != null && (message.wkMsgExtra?.revoke ?? 0) == 1) {
      final loginUid = WKIM.shared.options.uid ?? '';
      final revoker = message.wkMsgExtra?.revoker ?? '';
      final isMine = revoker.isEmpty
          ? (message.fromUID == loginUid)
          : (revoker == loginUid);
      if (isMine) {
        rawPreview = '你撤回了一条消息';
      } else {
        // 群消息显示 revoker 名字, 单聊"对方撤回了一条消息"
        String name = '';
        if (revoker.isNotEmpty) {
          final ch = await WKIM.shared.channelManager.getChannel(
            revoker,
            WKChannelType.personal,
          );
          name = moyuDisplayName(
            remark: ch?.channelRemark ?? '',
            name: ch?.channelName ?? '',
            rawIdentity: revoker,
            placeholder: '',
          );
        }
        rawPreview = name.isNotEmpty ? '$name 撤回了一条消息' : '对方撤回了一条消息';
      }
    } else {
      rawPreview = _substituteSystemPlaceholders(
        message == null ? '' : _messageDisplayText(message),
        message,
      );
    }
    // draft 优先级: SDK remoteMsgExtra (server 同步过) > 本地 SharedPreferences
    // (本机 _ChatScreen.dispose 时存的). SDK conversation_extra 表只能通过
    // server CMD `syncConversationExtra` 触发写入 (SDK 没公开写 API),
    // 本机写的 draft 必须从 prefs 拿. 跨设备同步靠 server PUT path.
    var draft = conversation.getRemoteMsgExtra()?.draft ?? '';
    if (draft.isEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final loginUid = WKIM.shared.options.uid ?? '';
        final localKey =
            'chat.draft.$loginUid.${conversation.channelType}.${conversation.channelID}';
        draft = prefs.getString(localKey) ?? '';
      } catch (e) {
        debugPrint('[im][draft] prefs read failed: $e');
      }
    }
    final reminderText = await _composeReminderText(
      channelId: conversation.channelID,
      channelType: conversation.channelType,
    );
    final senderInfo = await _resolveSender(
      message: message,
      channelType: conversation.channelType,
    );
    final lastFailed =
        senderInfo.isMine &&
        message != null &&
        message.status == WKSendMsgResult.sendFail;
    // 对齐 iOS WKConversationListCell.updateStatus 4 种 status icon:
    //   sending (TimeWait): WAITSEND / UPLOADING
    //   sent (Checkmark): SUCCESS && readedCount == 0
    //   read (DoubleCheckmark): SUCCESS && readedCount > 0
    //   failed (SendError): FAIL  ← lastFailed 已 cover
    final lastSending =
        senderInfo.isMine &&
        message != null &&
        (message.status == WKSendMsgResult.sendLoading);
    final lastRead =
        senderInfo.isMine &&
        message != null &&
        message.status == WKSendMsgResult.sendSuccess &&
        (message.wkMsgExtra?.readedCount ?? 0) > 0;
    return WukongConversationSnapshot(
      channelId: conversation.channelID,
      channelType: conversation.channelType,
      title: title,
      avatarLabel: title.isEmpty ? conversation.channelID : title,
      avatarPath: avatarPath.isEmpty ? '' : client.config.showUrl(avatarPath),
      preview: rawPreview,
      draft: draft,
      lastSenderName: senderInfo.name,
      lastSenderUid: senderInfo.uid,
      lastIsMine: senderInfo.isMine,
      lastMsgFailed: lastFailed,
      lastMsgSending: lastSending,
      lastMsgRead: lastRead,
      lastMsgSeq: conversation.lastMsgSeq,
      lastClientMsgNo: conversation.clientMsgNo,
      reminderText: reminderText,
      timestamp: conversation.lastMsgTimestamp,
      timeLabel: _formatTime(conversation.lastMsgTimestamp),
      unread: conversation.unreadCount,
      online: channel?.online == 1,
      muted: channel?.mute == 1,
      pinned: channel?.top == 1,
      receiptEnabled: channel?.receipt == 1,
      chatPasswordEnabled: channelChatPasswordEnabled(channel),
      flameEnabled: channelFlameEnabled(channel),
      flameSecond: channelFlameSecond(channel),
      // 官方账号 category — 对齐 iOS WKConversationListCell.refreshOfficialTag.
      // 'service' = 服务号 (蓝圆), 'visitor' = 访客号 (灰椭圆), 'system' = 内置
      // 系统账号 (fileHelper / u_10000, chatim 独有逻辑, 原版不显示). 空字符
      // 串 = 无 tag. server 端 fileHelper / 系统账号没 user 表行返不出 category,
      // 客户端按 channelId 兜底.
      channelCategory: (channel?.category ?? '').isNotEmpty
          ? channel!.category
          : (conversation.channelID == kFileHelperUID ||
                    conversation.channelID == kSystemUID
                ? 'system'
                : ''),
      isRobot: channel?.robot == 1,
      // 自动删除 N 天 — iOS msg_auto_delete extra (1d/2w/3m/1y 显示).
      msgAutoDeleteSeconds: WukongImService._readInt(
        channel?.remoteExtraMap?['msg_auto_delete'],
      ),
      notifyScreenshot: channelNotifyScreenshot(
        channel,
        conversation.channelType,
      ),
      forbidden: channel?.forbidden == 1,
      // memberRemoved is intentionally always false here. The Flutter
      // WuKong SDK's `WKChannel.status` enum is [0=Unknown, 1=Normal,
      // 2=Blacklist] — `0` is *uninitialized*, not "removed", and
      // freshly-loaded channels routinely come back from DB with
      // status=0 before the channel-info fetch lands. The previous
      // `channel.status == 0` check therefore false-positived every
      // open chat as 「你已离开该聊天」 and locked the composer for
      // all conversations.
      //
      // iOS uses `WKChannel.beDeleted` (a separate boolean) for the
      // membership-removed signal, and that field doesn't exist on
      // the Flutter SDK side. We instead rely entirely on
      // `_localMemberRemoved`, which `_applySystemSideEffects` sets
      // when a 1003 / 1020 / 1021 kick/leave system message names the
      // current user — matching iOS WKSystemMessageHandler behavior.
      memberRemoved: false,
    );
  }

  Future<String> _composeReminderText({
    required String channelId,
    required int channelType,
  }) async {
    try {
      final reminders = await ReminderDB.shared.queryWithChannel(
        channelId,
        channelType,
        0,
      );
      if (reminders.isEmpty) return '';
      final buffer = StringBuffer();
      for (final reminder in reminders) {
        // 按 WKReminder.type 显式给中文文案 — 对齐 iOS
        // WKConversationListCell.getLastContent 渲染逻辑.
        //   type=1 → "[有人@我]"  (WKMentionType.wkReminderTypeMentionMe)
        //   type=2 → "[申请加群]" (WKMentionType.wkApplyJoinGroupApprove)
        // server 本身 reminder.text 可能空 / 可能是 raw label, 不能依赖.
        // 之前直接 concat reminder.text → server 给空时前缀也为空, 被@
        // 的群在会话列表看不到橙色提示.
        final label = switch (reminder.type) {
          1 => '[有人@我]',
          2 => '[申请加群]',
          _ => reminder.text,
        };
        if (label.isEmpty) continue;
        buffer.write(label);
      }
      return buffer.toString();
    } catch (_) {
      return '';
    }
  }

  Future<_SenderInfo> _resolveSender({
    required WKMsg? message,
    required int channelType,
  }) async {
    if (message == null) return const _SenderInfo();
    final fromUid = message.fromUID;
    if (fromUid.isEmpty) return const _SenderInfo();
    final isMine = fromUid == WKIM.shared.options.uid;
    if (isMine || channelType != WKChannelType.group) {
      return _SenderInfo(uid: fromUid, isMine: isMine);
    }
    var name = _resolveSenderName(message);
    try {
      final channel = await WKIM.shared.channelManager.getChannel(
        fromUid,
        WKChannelType.personal,
      );
      name = name.isNotEmpty
          ? name
          : moyuSenderDisplayName(
              channelRemark: channel?.channelRemark ?? '',
              channelName: channel?.channelName ?? '',
              rawIdentity: fromUid,
            );
    } catch (_) {}
    return _SenderInfo(uid: fromUid, name: name);
  }

  WukongMessageSnapshot _mapMessage(WKMsg message) {
    final content = message.messageContent;
    final fromUid = message.fromUID;
    final isMine = fromUid == WKIM.shared.options.uid;
    final fromAvatarUrl = (!isMine && fromUid.isNotEmpty)
        ? client.config.showUrl('users/$fromUid/avatar')
        : '';
    final extra = message.wkMsgExtra;
    return WukongMessageSnapshot(
      messageId: message.messageID,
      messageSeq: message.messageSeq,
      clientMsgNo: message.clientMsgNO,
      channelId: message.channelID,
      channelType: message.channelType,
      text: _messageDisplayText(message),
      isMine: isMine,
      timestamp: message.timestamp,
      status: _sendStatus(message.status),
      kind: _messageKind(message.contentType),
      fileName: content is WKFileContent ? content.name : '',
      fileSize: content is WKFileContent ? content.size : 0,
      localPath: content is WKMediaMessageContent ? content.localPath : '',
      // The wukong protocol stores the upload path the sender wrote (often
      // a relative slug like `/2/uid/123.m4a` for messages sent before
      // the client started writing absolute URLs). Resolve through
      // AppConfig.showUrl here so receivers always get an absolute URL
      // — UI image/voice paths assume `startsWith('http')` to render.
      remoteUrl: _resolveAbsoluteUrl(
        content is WKMediaMessageContent ? content.url : '',
      ),
      // Voice messages carry their length in WKVoiceContent.timeTrad —
      // surface it so the receiver's bubble shows the correct duration
      // (and the playback countdown works). Video messages carry their
      // length in WKVideoContent.second (note: same field name pattern).
      durationSeconds: content is WKVoiceContent
          ? content.timeTrad
          : content is WKVideoContent
          ? content.second
          : 0,
      coverUrl: _resolveAbsoluteUrl(
        content is WKVideoContent ? content.cover : '',
      ),
      // 统一 media 尺寸 — image / video / livePhoto 都有原图 width/height.
      // bubble 渲染靠 aspect ratio 计算. 之前漏 image 分支, image 永远 0×0
      // → _ImageBubbleContent 没法算 aspect 走 fixed 192×144, portrait 图
      // 被裁切显示.
      mediaWidth: content is WKVideoContent
          ? content.width
          : content is WKLivePhotoContent
          ? content.width
          : content is WKImageContent
          ? content.width
          : 0,
      mediaHeight: content is WKVideoContent
          ? content.height
          : content is WKLivePhotoContent
          ? content.height
          : content is WKImageContent
          ? content.height
          : 0,
      livePhotoVideoUrl: _resolveAbsoluteUrl(
        content is WKLivePhotoContent ? content.videoUrl : '',
      ),
      livePhotoVideoLocalPath: content is WKLivePhotoContent
          ? content.videoLocalPath
          : '',
      revoked: (extra?.revoke ?? 0) == 1,
      revoker: extra?.revoker ?? '',
      // Voice unread state. Three-tier resolution:
      //   1. `message.voiceStatus` — set by `parseSyncMessage`
      //      where we promoted `message_extra.voice_status` onto
      //      the top-level value.
      //   2. `_voiceStatusFromExtra[messageId]` — captured during
      //      the dedicated `message/extra/sync` path which SDK
      //      `WKMsgExtra` storage drops the field for.
      // The OR (max) ensures a server-side flip to `1` from any
      // sync source can never be downgraded to `0` by a stale
      // refresh. Always 0 for non-voice messages.
      voiceStatus: math.max(
        message.voiceStatus,
        _voiceStatusFromExtra[message.messageID] ?? 0,
      ),
      // Location metadata for contentType=6 messages. Sourced
      // from the SDK's decoded WKLocationContent. Zero / empty
      // for everything else so the UI can gate on
      // `locationLat != 0 || locationLng != 0` cheaply.
      locationLat: content is WKLocationContent ? content.latitude : 0,
      locationLng: content is WKLocationContent ? content.longitude : 0,
      locationTitle: content is WKLocationContent ? content.title : '',
      locationAddress: content is WKLocationContent ? content.address : '',
      // WKLocationContent 继承自 WKMediaMessageContent — `url` 字段 = 服务端
      // 上传后的 mini-map 截图绝对 URL (decodeJson 时从 `img` 字段填充).
      // 跟 iOS 原版 WKLocationCell.refresh:`sd_setImageWithURL:content.img`
      // 同模式.
      locationImageUrl: content is WKLocationContent ? content.url : '',
      replyToMessageId: content?.reply?.messageId ?? '',
      replyToSender: content?.reply?.fromName ?? '',
      replyToText: _substituteSystemPlaceholders(
        content?.reply?.payload?.displayText() ?? '',
        message,
      ),
      replyToRevoked: (content?.reply?.revoke ?? 0) == 1,
      mentionUids: content?.mentionInfo?.uids ?? const [],
      mentionAll: content?.mentionInfo?.mentionAll ?? false,
      // 提取 contentEdit JSON 里的 `content` 字段 (server 存 JSON payload,
      // 不是纯文本). 之前直接用 raw JSON 当 editedText 显示, 用户看到的
      // 是 `{"type":1,"content":"新文本"}` 整段乱码; iOS WKMessageExtra
      // 自带 contentEditMsgModel 解了, 这里手动解 JSON 提 content.
      editedText: _extractEditedText(extra?.contentEdit ?? ''),
      editedAt: extra?.editedAt ?? 0,
      reactions: _aggregateReactions(message),
      cardUid: content is WKCardContent ? content.uid : '',
      cardName: content is WKCardContent ? content.name : '',
      screenshotFromName: message.contentType == _wkScreenshotContentType
          ? _resolveScreenshotName(message)
          : '',
      fromUid: fromUid,
      // Resolve sender display name from SDK metadata so group revoke
      // rows / system messages / quote previews show "<actual name>"
      // instead of falling back to "对方". Priority:
      //   1. group member groupNickname (WKMsg.getMemberOfFrom — set
      //      by SDK queries that JOIN channel_member)
      //   2. channel display name (WKMsg.getFrom() — set by JOIN on
      //      channel where from_uid == channel_id for 1:1)
      //   3. empty (UI falls back to "对方")
      // Mirrors iOS `WKMessageCell.getFromName` lookup chain.
      fromName: _resolveSenderName(message),
      fromAvatarUrl: fromAvatarUrl,
      readed: (extra?.readed ?? 0) == 1,
      readedCount: extra?.readedCount ?? 0,
      unreadCount: extra?.unreadCount ?? 0,
      replyCount: extra?.replyCount ?? 0,
      contentType: message.contentType,
      callType: content is WKCallSystemContent ? content.callType : 0,
      // Preserve the card source token so tapping a received card can
      // send friend/apply with the same proof as native clients.
      cardVercode: content is WKCardContent ? _safeCardVercode(content) : '',
      mergeForwardTitle: content is WKMergeForwardContent
          ? content.resolveTitle()
          : '',
      mergeForwardEntries: content is WKMergeForwardContent
          ? content.msgs
          : const [],
      mergeForwardSourceChannelType: content is WKMergeForwardContent
          ? content.sourceChannelType
          : 0,
      mergeForwardUsers: content is WKMergeForwardContent
          ? content.users
          : const [],
      data: _messageData(message, content),
    );
  }

  static Map<String, Object?> _messageData(
    WKMsg message,
    WKMessageContent? content,
  ) {
    // Surface the raw payload for both group-approve invites AND
    // generic-label system events (1003/1020/1021 kick/leave events
    // carry `users[]` here; 1005 group-info-update carries `extra`).
    // UI side-effect handlers like the chat-screen composer-lock
    // dispatcher need this to identify whether the current user is
    // among the affected uids.
    final base = content is WKGroupApproveContent
        ? Map<String, Object?>.from(content.data)
        : content is WKGenericLabelContent
        ? Map<String, Object?>.from(content.raw)
        // GroupCallInvite (9988) carries `room_id` in the SDK's
        // call-system content. Surface it via the snapshot's data
        // map so the chat-screen bubble can wire onTap to
        // acceptGroupCall(roomId) without re-decoding the payload.
        : (content is WKCallSystemContent && content.roomId.isNotEmpty)
        ? <String, Object?>{'room_id': content.roomId}
        : const <String, Object?>{};
    final streamData = _messageStreamData(message);
    if (streamData.isEmpty) {
      return base;
    }
    return <String, Object?>{...base, ...streamData};
  }

  static Map<String, Object?> _messageStreamData(WKMsg message) {
    if (message.streamNo.isEmpty &&
        message.streamSeq == 0 &&
        message.streamFlag == 0) {
      return const {};
    }
    final data = <String, Object?>{
      wukongStreamNoKey: message.streamNo,
      wukongStreamSeqKey: message.streamSeq,
      wukongStreamFlagKey: message.streamFlag,
    };
    final payload = _readPayload(message.content);
    if (payload is Map) {
      data[wukongStreamPayloadKey] = Map<String, dynamic>.from(payload);
    }
    return data;
  }

  String _resolveAbsoluteUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return client.config.showUrl(trimmed);
  }

  /// Resolve a WKMsg's display sender name (group metadata → channel
  /// metadata). Empty when nothing is known; the UI falls back
  /// to "对方" / "你" depending on context.
  static String _resolveSenderName(WKMsg message) {
    final member = message.getMemberOfFrom();
    final channel = message.getFrom();
    return moyuSenderDisplayName(
      friendRemark: member?.remark ?? '',
      memberRemark: member?.memberRemark ?? '',
      memberName: member?.memberName ?? '',
      channelRemark: channel?.channelRemark ?? '',
      channelName: channel?.channelName ?? '',
      rawIdentity: message.fromUID,
    );
  }

  /// server 端 message_extra.content_edit 存 JSON 格式 message payload
  /// (`{"type": 1, "content": "新文本"}`), 不是纯文本. 这里 jsonDecode
  /// 提 content 字段. 旧消息 / decode 失败 → 兜底返 raw 字符串.
  static String _extractEditedText(String raw) {
    if (raw.isEmpty) return '';
    final trimmed = raw.trim();
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final content = decoded['content'];
        if (content is String && content.isNotEmpty) return content;
      } else if (decoded is Map) {
        final content = decoded['content'];
        if (content is String && content.isNotEmpty) return content;
      } else if (decoded is String && decoded != trimmed) {
        final nested = _extractEditedText(decoded);
        if (nested.isNotEmpty) return nested;
      }
    } catch (_) {
      // 不是合法 JSON → 当作旧版纯文本兜底返回.
    }
    final mapText = _extractDartMapContentEdit(trimmed);
    if (mapText.isNotEmpty) return mapText;
    return raw;
  }

  static String _extractDartMapContentEdit(String raw) {
    if (!raw.startsWith('{') || !raw.endsWith('}')) return '';
    final body = raw.substring(1, raw.length - 1).trim();
    const prefix = 'content:';
    if (!body.startsWith(prefix)) return '';
    var content = body.substring(prefix.length).trim();
    final typeSuffix = RegExp(r',\s*type:\s*\d+\s*$').firstMatch(content);
    if (typeSuffix != null) {
      content = content.substring(0, typeSuffix.start).trim();
    }
    return content;
  }

  static String _messageDisplayText(WKMsg message) {
    final editedText = _extractEditedText(
      message.wkMsgExtra?.contentEdit ?? '',
    );
    if (editedText.isNotEmpty) return editedText;
    return message.messageContent?.displayText() ?? '';
  }

  /// Resolve the display name embedded in a screenshot system message.
  /// Prefer `from_name` from the payload; fall back to "你" / channel
  /// name. Matches native iOS WKScreenshotContent.tip's lookup chain.
  static String _resolveScreenshotName(WKMsg message) {
    final content = message.messageContent;
    final selfUid = WKIM.shared.options.uid ?? '';
    if (message.fromUID == selfUid) return '你';
    if (content is WKScreenshotContent) {
      if (content.screenshotFromUid == selfUid) return '你';
      final payloadName = content.screenshotFromName.trim();
      if (payloadName.isNotEmpty && !moyuLooksLikeRawIdentity(payloadName)) {
        return payloadName;
      }
    }
    final from = message.getFrom();
    return moyuDisplayName(
      remark: from?.channelRemark ?? '',
      name: from?.channelName ?? '',
      rawIdentity: message.fromUID,
      placeholder: '对方',
    );
  }

  /// Roll the SDK's per-user reaction rows into per-emoji counts in stable
  /// insertion order. Empty when the message has no reactions yet.
  static List<Map<String, Object>> _aggregateReactions(WKMsg message) {
    final list = message.reactionList;
    if (list == null || list.isEmpty) return const [];
    final order = <String>[];
    final counts = <String, int>{};
    final mineFlag = <String, bool>{};
    final selfUid = WKIM.shared.options.uid ?? '';
    for (final reaction in list) {
      if (reaction.isDeleted == 1) continue;
      final emoji = reaction.emoji;
      if (emoji.isEmpty) continue;
      if (!counts.containsKey(emoji)) {
        order.add(emoji);
        counts[emoji] = 0;
        mineFlag[emoji] = false;
      }
      counts[emoji] = counts[emoji]! + 1;
      if (reaction.uid == selfUid) {
        mineFlag[emoji] = true;
      }
    }
    return [
      for (final emoji in order)
        <String, Object>{
          'emoji': emoji,
          'count': counts[emoji] ?? 0,
          'mine': mineFlag[emoji] ?? false,
        },
    ];
  }

  static WukongMessageKind _messageKind(int contentType) {
    return switch (contentType) {
      WkMessageContentType.image => WukongMessageKind.image,
      WkMessageContentType.file => WukongMessageKind.file,
      WkMessageContentType.voice => WukongMessageKind.voice,
      WkMessageContentType.video => WukongMessageKind.video,
      WkMessageContentType.card => WukongMessageKind.card,
      _wkLocationContentType => WukongMessageKind.location,
      _wkLivePhotoContentType => WukongMessageKind.livePhoto,
      _wkMergeForwardContentType => WukongMessageKind.mergeForward,
      _wkGifContentType ||
      _wkLottieStickerContentType ||
      _wkEmojiStickerContentType => WukongMessageKind.sticker,
      WkMessageContentType.text => WukongMessageKind.text,
      _ => WukongMessageKind.unknown,
    };
  }

  static WKChannel _channelFromJson(
    Map<String, dynamic> source, {
    required String fallbackChannelId,
    required int fallbackChannelType,
  }) {
    final channel = WKChannel(fallbackChannelId, fallbackChannelType)
      ..channelName = _string(source['name'])
      ..channelRemark = _string(source['remark'])
      ..avatar = _avatarFor(
        _string(source['logo']),
        fallbackChannelId,
        fallbackChannelType,
      )
      ..showNick = _readInt(source['show_nick'])
      ..top = _readFirstInt(source, const ['stick', 'top'])
      ..save = _readInt(source['save'])
      ..mute = _readInt(source['mute'])
      ..forbidden = _readInt(source['forbidden'])
      ..invite = _readInt(source['invite'])
      ..status = _readInt(source['status'], fallback: 1)
      ..follow = _readInt(source['follow'])
      ..isDeleted = _readInt(source['is_deleted'])
      ..createdAt = _string(source['created_at'])
      ..updatedAt = _string(source['updated_at'])
      ..version = _readInt(source['version'])
      ..online = _readInt(source['online'])
      ..lastOffline = _readInt(source['last_offline'])
      ..deviceFlag = _readInt(source['device_flag'])
      ..receipt = _readInt(source['receipt'])
      ..robot = _readInt(source['robot'])
      ..category = _string(source['category'])
      ..username = _string(source['username'])
      ..avatarCacheKey = _string(source['avatar_cache_key'])
      ..remoteExtraMap = _remoteExtra(source);

    final parentChannel = _readMap(source['parent_channel']);
    if (parentChannel.isNotEmpty) {
      channel
        ..parentChannelID = _string(parentChannel['channel_id'])
        ..parentChannelType = _readInt(parentChannel['channel_type']);
    }
    return channel;
  }

  static String _avatarFor(
    String logo,
    String channelId,
    int channelType, {
    String cacheKey = '',
  }) {
    final base = logo.isNotEmpty
        ? logo
        : switch (channelType) {
            WKChannelType.personal => 'users/$channelId/avatar',
            WKChannelType.group => 'groups/$channelId/avatar',
            _ => '',
          };
    if (base.isEmpty || cacheKey.isEmpty) {
      return base;
    }
    // Append the SDK's per-channel cache key so cached avatar URLs
    // invalidate after the user uploads a new photo (CachedNetworkImage
    // keys by full URL — same URL = stale image).
    return base.contains('?') ? '$base&v=$cacheKey' : '$base?v=$cacheKey';
  }

  static Map<String, dynamic> _remoteExtra(Map<String, dynamic> source) {
    final extra = _readMap(source['extra']);
    final remote = <String, dynamic>{...extra, ...source};
    final remark = _string(source['remark']);
    final name = _string(source['name']);
    remote['remark'] = remark;
    remote['displayName'] = remark.isNotEmpty ? remark : name;
    if (source.containsKey('short_no') || extra.containsKey('short_no')) {
      remote['shortNo'] = _string(source['short_no'] ?? extra['short_no']);
    }
    return remote;
  }

  static String _channelTitle(WKChannel? channel, {String rawIdentity = ''}) =>
      moyuDisplayName(
        remark: channel?.channelRemark ?? '',
        name: channel?.channelName ?? '',
        rawIdentity: rawIdentity,
        placeholder: '',
      );

  static bool needsChannelInfoRefresh(
    WKChannel? channel, {
    String rawIdentity = '',
  }) {
    if (channel == null) {
      return true;
    }
    if (moyuDisplayName(
      remark: channel.channelRemark,
      name: channel.channelName,
      rawIdentity: rawIdentity,
      placeholder: '',
    ).isEmpty) {
      return true;
    }
    return channel.channelRemark.trim().isEmpty &&
        channel.channelName.trim().isEmpty;
  }

  static bool channelChatPasswordEnabled(WKChannel? channel) {
    final value = channel?.remoteExtraMap?['chat_pwd_on'];
    if (value is bool) {
      return value;
    }
    return _readInt(value) == 1;
  }

  static bool channelFlameEnabled(WKChannel? channel) {
    final value = channel?.remoteExtraMap?['flame'];
    if (value is bool) {
      return value;
    }
    return _readInt(value) == 1;
  }

  static int channelFlameSecond(WKChannel? channel) {
    return _readInt(channel?.remoteExtraMap?['flame_second']);
  }

  static List<WukongAvatarInvalidationTarget>
  avatarInvalidationTargetsForCommand(String command, Object? param) {
    WukongAvatarInvalidationTarget? targetFor(
      String channelId,
      int channelType,
    ) {
      final id = channelId.trim();
      if (id.isEmpty) return null;
      return switch (channelType) {
        WKChannelType.personal => (
          avatarPath: 'users/$id/avatar',
          channelId: id,
          channelType: WKChannelType.personal,
        ),
        WKChannelType.group => (
          avatarPath: 'groups/$id/avatar',
          channelId: id,
          channelType: WKChannelType.group,
        ),
        _ => null,
      };
    }

    WukongAvatarInvalidationTarget? target;
    switch (command.trim()) {
      case 'userAvatarUpdate':
        target = targetFor(
          _commandString(param, const [
            'uid',
            'channel_id',
            'channelId',
            'channelID',
          ]),
          WKChannelType.personal,
        );
      case 'groupAvatarUpdate':
        target = targetFor(
          _commandString(param, const [
            'group_no',
            'groupNo',
            'channel_id',
            'channelId',
            'channelID',
          ]),
          WKChannelType.group,
        );
      case 'channelUpdate':
        target = targetFor(
          _commandString(param, const [
            'channel_id',
            'channelId',
            'channelID',
            'uid',
            'group_no',
            'groupNo',
          ]),
          _commandChannelType(param),
        );
    }
    return target == null ? const [] : [target];
  }

  static Set<String> legacyAvatarCachePathsForChannels(
    Iterable<WKChannel?> channels,
  ) {
    final paths = <String>{};
    for (final channel in channels) {
      if (channel == null) continue;
      final path = _stripQuery(
        _avatarFor(channel.avatar, channel.channelID, channel.channelType),
      );
      if (path.isNotEmpty) paths.add(path);
    }
    return paths;
  }

  /// Reads the per-channel screenshot-notification flag, applying native
  /// defaults when the server hasn't surfaced an explicit value:
  /// - 1:1 (personal) channels default to **off** — screenshot broadcast
  ///   is intrusive between two friends; native iOS keeps it opt-in.
  /// - Group channels default to **on** — group admins typically want
  ///   the deterrent enabled by default.
  ///
  /// Mirrors `screenshot-broadcast-flow.md §5.2 / §6 P1` so flutter
  /// matches native iOS gating before broadcasting a t=20 message.
  static bool channelNotifyScreenshot(WKChannel? channel, int channelType) {
    final raw = channel?.remoteExtraMap?['screenshot'];
    if (raw is bool) return raw;
    if (raw == null) {
      return channelType == WKChannelType.group;
    }
    return _readInt(raw) == 1;
  }

  /// Map the SDK's WKSendMsgResult code to a display label.
  ///
  /// The SDK reports business rejections (黑名单 / 不是好友 / 不在白
  /// 名单) with non-zero codes 3/4/13. These all mean "send terminated,
  /// not in flight" — fall-through to '发送中' would freeze the bubble
  /// in a spinner forever because the SDK won't push another refresh
  /// for the same message. Map every non-loading, non-success code to
  /// '发送失败' so the UI shows a long-press → 重发 affordance.
  ///
  /// SDK status codes (see lib/type/const.dart WKSendMsgResult):
  ///   0 sendLoading
  ///   1 sendSuccess
  ///   2 sendFail
  ///   3 noRelation    (不是好友/不在群内)
  ///   4 blackList     (被对方拉黑)
  ///   13 notOnWhiteList (未通过白名单审核)
  static String _sendStatus(int status) {
    return switch (status) {
      WKSendMsgResult.sendLoading => '发送中',
      WKSendMsgResult.sendSuccess => '已发送',
      _ => '发送失败',
    };
  }

  /// SDK WKConnectStatus code → ChatConnectionStatus. kicked 单走 stream
  /// 不映射 (返回 null 跳过). 对齐 packages/wukongimfluttersdk_patched
  /// /lib/type/const.dart 实际 code (跟 iOS SDK 完全不同, 之前抄 iOS 错了):
  ///   0 = fail / 1 = success / 2 = kicked / 3 = syncMsg
  ///   4 = connecting / 5 = noNetwork / 6 = syncCompleted
  static ChatConnectionStatus? _mapConnectionStatus(int status) {
    return switch (status) {
      // fail
      0 => ChatConnectionStatus.disconnected,
      // success (登录/连接成功)
      1 => ChatConnectionStatus.connected,
      // kicked — 单独 kickedSignals 处理
      2 => null,
      // syncMsg (同步消息中 = 收取中)
      3 => ChatConnectionStatus.syncing,
      // connecting
      4 => ChatConnectionStatus.connecting,
      // noNetwork
      5 => ChatConnectionStatus.noNetwork,
      // syncCompleted (同步完成 = 视作已连接)
      6 => ChatConnectionStatus.connected,
      _ => null,
    };
  }

  static const _weekdayLabels = <String>[
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  static String _formatTime(int timestamp) {
    if (timestamp <= 0) {
      return '';
    }
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(date.year, date.month, date.day);
    final dayDiff = today.difference(messageDay).inDays;

    if (dayDiff == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    if (dayDiff == 1) {
      return '昨天';
    }
    if (dayDiff > 1 && dayDiff < 7) {
      return _weekdayLabels[date.weekday - 1];
    }
    if (date.year == now.year) {
      return '${date.month}/${date.day}';
    }
    return '${date.year}/${date.month}/${date.day}';
  }

  static Map<String, dynamic> _source(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return response;
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

  static String _commandString(Object? param, List<String> keys) {
    final source = _readMap(param);
    for (final key in keys) {
      final value = source[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    final channel = _readMap(source['channel']);
    for (final key in keys) {
      final value = channel[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  static String _stripQuery(String value) {
    final raw = value.trim();
    final query = raw.indexOf('?');
    return query < 0 ? raw : raw.substring(0, query);
  }

  static int _commandChannelType(Object? param) {
    final source = _readMap(param);
    final raw =
        source['channel_type'] ??
        source['channelType'] ??
        source['channel_type_int'] ??
        _readMap(source['channel'])['channel_type'] ??
        _readMap(source['channel'])['channelType'];
    return _readInt(raw);
  }

  static List<dynamic> _readList(Object? value) {
    if (value is List) {
      return value;
    }
    return const [];
  }

  static dynamic _readPayload(Object? value) {
    if (value is String) {
      try {
        return jsonDecode(value);
      } catch (_) {
        return {'type': WkMessageContentType.text, 'content': value};
      }
    }
    return value;
  }

  static String _contentEditPayloadString(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }

  static Object? _contentEditPayloadForSdk(Object? value) {
    final raw = _contentEditPayloadString(value).trim();
    if (raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is String && decoded.trim().isNotEmpty) {
        return _contentEditPayloadForSdk(decoded);
      }
      return decoded;
    } catch (_) {
      return {'type': WkMessageContentType.text, 'content': raw};
    }
  }

  @visibleForTesting
  static String debugContentEditPayloadString(Object? value) =>
      _contentEditPayloadString(value);

  @visibleForTesting
  static String debugExtractEditedText(String raw) => _extractEditedText(raw);

  @visibleForTesting
  static String debugNormalizeInboundHintChannelId({
    required String channelId,
    required int channelType,
    required String fromUid,
    required String selfUid,
  }) {
    return _normalizeInboundHintChannelId(
      channelId: channelId,
      channelType: channelType,
      fromUid: fromUid,
      selfUid: selfUid,
    );
  }

  static String _normalizeInboundHintChannelId({
    required String channelId,
    required int channelType,
    required String fromUid,
    required String selfUid,
  }) {
    final normalizedChannelId = channelId.trim();
    final normalizedFromUid = fromUid.trim();
    final normalizedSelfUid = selfUid.trim();
    if (channelType == WKChannelType.personal &&
        normalizedChannelId == normalizedSelfUid &&
        normalizedFromUid.isNotEmpty &&
        normalizedFromUid != normalizedSelfUid) {
      return normalizedFromUid;
    }
    return normalizedChannelId;
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int _readFirstInt(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      if (source.containsKey(key)) {
        return _readInt(source[key]);
      }
    }
    return 0;
  }

  static String _safeCardVercode(WKCardContent content) {
    final value = content.vercode?.trim() ?? '';
    if (value.isEmpty) return '';
    if (value == content.uid.trim()) return '';
    return value;
  }

  static String _string(Object? value, {String fallback = ''}) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? fallback : text;
  }

  Future<List<WKMsg>> _loadBackupMessages() async {
    final db = WKDBHelper.shared.getDB();
    if (db == null) {
      return const [];
    }
    final rows = await db.query(
      WKDBConst.tableMessage,
      where: 'is_deleted=0',
      orderBy: 'order_seq ASC',
    );
    return rows.map(WKDBConst.serializeWKMsg).toList();
  }

  Map<String, Object> _messageBackupJson(WKMsg message) {
    return {
      'channel_id': message.channelID,
      'channel_type': message.channelType,
      'message_id': message.messageID,
      'message_seq': message.messageSeq,
      'client_msg_no': message.clientMsgNO,
      'from_uid': message.fromUID,
      'payload': message.content,
      'timestamp': message.timestamp,
    };
  }

  Future<File> _writeBackupFile(
    String payload, {
    required String suffix,
  }) async {
    final file = await _backupFile(suffix);
    return file.writeAsString(payload, flush: true);
  }

  Future<File> _writeBackupBytes(
    List<int> bytes, {
    required String suffix,
  }) async {
    final file = await _backupFile(suffix);
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<File> _backupFile(String suffix) async {
    final directory = await getTemporaryDirectory();
    final optionUid = WKIM.shared.options.uid ?? '';
    final uid = optionUid.isEmpty ? 'anonymous' : optionUid;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return File('${directory.path}/${uid}_${suffix}_$timestamp.json');
  }

  int _countRecoveredMessages(List<int> bytes) {
    try {
      final data = jsonDecode(utf8.decode(bytes));
      return data is List ? data.length : 0;
    } catch (_) {
      return 0;
    }
  }
}

class ChatMessageBackupResult {
  const ChatMessageBackupResult({
    required this.messageCount,
    required this.byteCount,
    this.filePath = '',
  });

  final int messageCount;
  final int byteCount;
  final String filePath;
}

class ChatMessageRecoveryResult {
  const ChatMessageRecoveryResult({
    required this.messageCount,
    required this.byteCount,
    this.filePath = '',
  });

  final int messageCount;
  final int byteCount;
  final String filePath;
}

class ChatSensitiveWords {
  const ChatSensitiveWords({
    this.tips = '',
    this.list = const [],
    this.version = 0,
  });

  final String tips;
  final List<String> list;
  final int version;

  factory ChatSensitiveWords.fromJson(Map<String, dynamic> json) {
    final raw = json['list'];
    final words = <String>[];
    if (raw is List) {
      for (final entry in raw) {
        if (entry == null) continue;
        words.add(entry.toString());
      }
    }
    return ChatSensitiveWords(
      tips: (json['tips'] ?? '').toString(),
      list: words,
      version: WukongImService._readInt(json['version']),
    );
  }
}

class WukongConversationSnapshot {
  const WukongConversationSnapshot({
    required this.channelId,
    required this.channelType,
    required this.title,
    required this.avatarLabel,
    required this.preview,
    required this.timestamp,
    required this.timeLabel,
    required this.unread,
    required this.online,
    this.avatarPath = '',
    this.draft = '',
    this.lastSenderName = '',
    this.lastSenderUid = '',
    this.lastIsMine = false,
    this.lastMsgFailed = false,
    this.lastMsgSending = false,
    this.lastMsgRead = false,
    this.lastMsgSeq = 0,
    this.lastClientMsgNo = '',
    this.reminderText = '',
    this.muted = false,
    this.pinned = false,
    this.receiptEnabled = false,
    this.chatPasswordEnabled = false,
    this.flameEnabled = false,
    this.flameSecond = 0,
    this.notifyScreenshot = false,
    this.forbidden = false,
    this.memberRemoved = false,
    this.channelCategory = '',
    this.isRobot = false,
    this.msgAutoDeleteSeconds = 0,
  });

  final String channelId;
  final int channelType;
  final String title;
  final String avatarLabel;
  final String avatarPath;

  /// Cached draft text (empty if no draft). When present the preview
  /// shows a `[草稿]` orange prefix and replaces the message content.
  final String draft;

  /// Display name of the last message sender (group chats prefix preview
  /// with `name: content`). Empty for personal chats or own messages.
  final String lastSenderName;
  final String lastSenderUid;
  final bool lastIsMine;

  /// True when the last message was sent by us and failed to deliver.
  /// Surfaces a red `!` marker in the conversation list row.
  final bool lastMsgFailed;

  /// True 当 last message 是自己发的, 状态 = sending / uploading. iOS 显示
  /// TimeWait 小钟图标. 对齐 WKMessage.status == WAITSEND || UPLOADING.
  final bool lastMsgSending;

  /// True 当 last message 是自己发的且 readedCount > 0. iOS 显示双勾.
  /// false 但 lastIsMine && !sending && !failed → 单勾 (sent).
  final bool lastMsgRead;

  final int lastMsgSeq;
  final String lastClientMsgNo;

  /// Reminder/mention prefix already concatenated, e.g. `[有人@我]`.
  /// Rendered in orange ahead of the preview body.
  final String reminderText;
  final String preview;
  final int timestamp;
  final String timeLabel;
  final int unread;
  final bool online;
  final bool muted;
  final bool pinned;
  final bool receiptEnabled;
  final bool chatPasswordEnabled;
  final bool flameEnabled;
  final int flameSecond;

  /// Per-channel "broadcast a system row when I take a screenshot"
  /// toggle. Sourced from `channel.remoteExtraMap['screenshot']` with
  /// native defaults (1:1 off, group on — see
  /// `channelNotifyScreenshot`). Used by the chat screen to gate the
  /// `screen_capture_event` listener's t=20 broadcast.
  final bool notifyScreenshot;

  /// `forbidden=1` on the underlying channel — the room is muted (group is
  /// in 全员禁言 mode, or the 1:1 channel is read-only). Used to disable
  /// the chat input bar.
  final bool forbidden;

  /// True when the local user is no longer a member of the channel
  /// (kicked / left a group, removed contact for 1:1). Used to hide the
  /// input bar entirely.
  final bool memberRemoved;

  /// 官方账号 category — 'service' (服务号) / 'visitor' (访客号) / ''.
  /// 对齐 iOS WKChannel.category + WKConversationListCell.refreshOfficialTag.
  /// 列表 cell name 旁显示 tag chip 区分.
  final String channelCategory;

  /// 服务端 channel.robot=1. AI bot 的 category 为空, 需要单独透传给
  /// 会话列表 / 聊天头渲染 AI badge.
  final bool isRobot;

  /// 自动删除消息的 TTL (秒). >0 时列表 cell 显示倒计时小标 (1d/2w/3m).
  /// 对齐 iOS WKAutoDeleteView + channel.extra.msg_auto_delete.
  final int msgAutoDeleteSeconds;
}

class WukongMessageSnapshot {
  const WukongMessageSnapshot({
    this.messageId = '',
    this.messageSeq = 0,
    this.clientMsgNo = '',
    required this.channelId,
    required this.channelType,
    required this.text,
    required this.isMine,
    required this.timestamp,
    required this.status,
    this.kind = WukongMessageKind.text,
    this.fileName = '',
    this.localPath = '',
    this.remoteUrl = '',
    this.coverUrl = '',
    this.durationSeconds = 0,
    this.mediaWidth = 0,
    this.mediaHeight = 0,
    this.livePhotoVideoUrl = '',
    this.livePhotoVideoLocalPath = '',
    this.revoked = false,
    this.revoker = '',
    this.replyToMessageId = '',
    this.replyToSender = '',
    this.replyToText = '',
    this.replyToRevoked = false,
    this.mentionUids = const [],
    this.mentionAll = false,
    this.voiceStatus = 0,
    this.locationLat = 0,
    this.locationLng = 0,
    this.locationTitle = '',
    this.locationAddress = '',
    this.locationImageUrl = '',
    this.editedText = '',
    this.editedAt = 0,
    this.reactions = const [],
    this.cardUid = '',
    this.cardName = '',
    this.screenshotFromName = '',
    this.fromUid = '',
    this.fromName = '',
    this.fromAvatarUrl = '',
    this.readed = false,
    this.readedCount = 0,
    this.unreadCount = 0,
    this.replyCount = 0,
    this.contentType = 0,
    this.callType = 0,
    this.cardVercode = '',
    this.mergeForwardTitle = '',
    this.mergeForwardEntries = const [],
    this.mergeForwardSourceChannelType = 0,
    this.mergeForwardUsers = const [],
    this.fileSize = 0,
    this.data = const {},
  });

  final String messageId;
  final int messageSeq;
  final String clientMsgNo;
  final String channelId;
  final int channelType;
  final String text;
  final bool isMine;
  final int timestamp;
  final String status;
  final WukongMessageKind kind;
  final String fileName;
  final String localPath;
  final String remoteUrl;

  /// Length in seconds for voice / video messages.
  final int durationSeconds;

  /// Absolute cover/thumbnail URL for video messages (parsed from
  /// `WKVideoContent.cover` and resolved via `AppConfig.showUrl`).
  final String coverUrl;

  /// Pixel size of a video message — used to pick the bubble aspect ratio.
  final int mediaWidth;
  final int mediaHeight;

  /// Live Photo paired MOV URL (绝对). 仅 kind == livePhoto 时非空.
  /// 接收端长按 bubble 时播放这个 URL (含音轨), 跟 iOS Photos app
  /// Live Photo 长按一致.
  final String livePhotoVideoUrl;

  /// Live Photo paired MOV 本地路径 (发送方暂存). 发送途中 (上传未完成)
  /// 让 bubble 显示自己的本地预览.
  final String livePhotoVideoLocalPath;

  /// True when the message has been revoked (recalled). The bubble should be
  /// replaced by a centered system row `"<from> 撤回了一条消息"`.
  final bool revoked;

  /// uid of whoever performed the revoke (the sender themselves, or an
  /// admin in groups). Used to render "你撤回了..." vs `"<name> 撤回了..."`.
  final String revoker;

  /// Server messageId of the message this one is replying to (empty when
  /// not a reply). Used by the chat to scroll the original into view when
  /// the user taps the inline quote header.
  final String replyToMessageId;

  /// Sender name + content of the replied-to message (used by the inline
  /// quote header inside the reply bubble).
  final String replyToSender;
  final String replyToText;

  /// True when the original message that this reply quotes has since
  /// been revoked. The quote text is replaced by `原消息已撤回` in the
  /// inline header. Mirrors native iOS `WKReply.revoke == 1` check
  /// inside `WKTextMessageCell` reply rendering. Source: native
  /// `content.reply.revoke` flag pushed by the server alongside the
  /// revoke cmd, or set client-side when the user revokes a message
  /// that other bubbles already quote.
  final bool replyToRevoked;

  /// uids of users explicitly @-mentioned in this message. Sourced
  /// from `WKMentionInfo.uids` decoded by the SDK
  /// (`message_manager.dart`). Empty when nothing was mentioned. UI
  /// uses this for the `@-mention` scroll FAB and notification
  /// red-dot logic. Mirrors native iOS `WKTextContent.mention.uids`.
  final List<String> mentionUids;

  /// True iff this message targets `@全体成员`. Server uses
  /// `mention.all = 1` payload. UI treats it as
  /// "everyone in the channel" for unread-mention banners.
  final bool mentionAll;

  /// Per-recipient voice-listen state. 0 = unheard (recipient hasn't
  /// played the voice yet), 1 = listened. Server-pushed via
  /// `message_extra.voice_status`; falls back to the message-level
  /// value when extra hasn't synced. Drives the bubble's unread
  /// red dot and `markVoiceMessageRead` POST on first play.
  /// Always 0 for non-voice messages.
  final int voiceStatus;

  /// Location message (`contentType == 6` /
  /// `WKLocationContent`) coordinates + place metadata.
  /// `locationLat` and `locationLng` are 0 for non-location
  /// messages. `locationTitle` is the user-readable POI label
  /// (e.g. "麓湖公园"); `locationAddress` is the geocoded
  /// street address. UI uses these to render
  /// `_LocationBubbleContent` and to deep-link the system map
  /// app on tap. Mirrors native iOS `WKLocationContent`.
  final double locationLat;
  final double locationLng;
  final String locationTitle;
  final String locationAddress;

  /// 服务端 mini-map 截图 URL — 对齐 iOS WKLocationContent.img.
  /// picker 发送时上传截图拿到, 接收方 decode `img` JSON 字段填充.
  final String locationImageUrl;

  /// Edited content text — when non-empty, the bubble should render this
  /// instead of `text` and show a `(已编辑)` suffix. Mirrors native iOS
  /// `messageExtra.contentEdit`.
  final String editedText;
  final int editedAt;

  /// Aggregated emoji reactions in display order.
  /// Each entry: { 'emoji': String, 'count': int, 'mine': bool }.
  final List<Map<String, Object>> reactions;

  /// uid + display name on a contact-card message (WKCardContent).
  final String cardUid;
  final String cardName;

  /// Screenshot system message (contentType 20): the displayed name to
  /// embed in the "{name}在聊天中截屏了" notice. Empty for non-screenshot
  /// messages. Mirrors native iOS WKScreenshotContent.tip.
  final String screenshotFromName;
  final String fromUid;
  final String fromName;
  final String fromAvatarUrl;

  /// Whether the message has been read by *any* recipient (1:1 chat).
  final bool readed;

  /// How many participants have read this message (group chat).
  final int readedCount;

  /// How many participants have NOT yet read this message (group chat).
  final int unreadCount;

  /// 被回复次数 — server `message_extra.reply_count` 同步过来。
  /// 对方/群消息气泡末尾显示 `⬅️N` (>0 才显)。从
  /// `WKMsgExtra.replyCount` 取 (Phase 2 SDK patch 已 port),
  /// 服务端走 WuKongIM webhook → Redis Incr → 3s 落库 → CMDSyncMessageExtra
  /// → SDK 本地 message_extra 表。
  final int replyCount;

  /// Raw WuKongIM content type code — used by group approve / system message
  /// rendering paths that key off the type rather than the parsed content.
  final int contentType;

  /// RTC call type for `WKCallSystemContent` messages (9989-9999):
  /// 0 = audio (`WKCallTypeAudio`), 1 = video (`WKCallTypeVideo`).
  /// 0 for non-call messages. Used by `_CallBubble` to pick the icon
  /// (phone vs videocam) and by tap-to-recall to honor the original
  /// call-type instead of always defaulting to audio.
  final int callType;

  /// Pre-resolved bubble title for merge-forward messages (e.g. "张三的
  /// 聊天记录" / "群的聊天记录"). Empty for non-merge messages. Mirrors
  /// native iOS `WKMergeForwardContent.getTitle`.
  final String mergeForwardTitle;

  /// Per-entry list embedded in a merge-forward bubble. Each carries
  /// enough metadata to re-render the original message in the detail
  /// page. Empty for non-merge messages.
  final List<MergeForwardEntry> mergeForwardEntries;

  /// Original `channel_type` from the merge-forward payload — preserved
  /// so re-forwarding the bubble keeps the source title resolution
  /// (e.g. forwarding a 1:1 merge into a group still says `"<name>的聊天记录"`
  /// rather than degrading to "群的聊天记录").
  final int mergeForwardSourceChannelType;

  /// Original `users[]` list (each `{uid, name}`) from the merge-forward
  /// payload. Empty for non-merge messages. Used both for name lookup
  /// during render AND to preserve metadata on re-forward.
  final List<Map<String, dynamic>> mergeForwardUsers;

  /// Original card verification code (`WKCardContent.vercode`) so
  /// forwarding a card preserves the auto-add-friend behavior. Empty
  /// when not a card or when the original message had no vercode.
  final String cardVercode;

  /// File size in bytes for `WKFileContent` messages. 0 for non-file
  /// messages. Surfaced through to `ChatMediaAttachment.fileSize` so
  /// `_FileBubbleContent` can render the "4.6MB" / "3.4KB" subtitle
  /// without an HTTP HEAD probe.
  final int fileSize;

  /// Decoded content payload for messages whose data needs structured access
  /// (e.g. WKGroupApproveContent).
  final Map<String, Object?> data;
}

class WukongAguiEventSnapshot {
  const WukongAguiEventSnapshot({
    required this.channelId,
    required this.channelType,
    required this.fromUid,
    required this.clientMsgNo,
    required this.eventType,
    required this.timestamp,
    this.delta = '',
    this.snapshotText = '',
    this.fromName = '',
    this.fromAvatarUrl = '',
  });

  final String channelId;
  final int channelType;
  final String fromUid;
  final String fromName;
  final String fromAvatarUrl;
  final String clientMsgNo;
  final String eventType;
  final String delta;
  final String snapshotText;
  final int timestamp;
}

class WukongMessageReference {
  const WukongMessageReference({
    required this.messageId,
    required this.messageSeq,
    required this.clientMsgNo,
    required this.channelId,
    required this.channelType,
  });

  final String messageId;
  final int messageSeq;
  final String clientMsgNo;
  final String channelId;
  final int channelType;

  bool get hasRemoteIdentity => messageId.isNotEmpty && messageSeq > 0;
}

class ChatLocation {
  const ChatLocation({
    required this.title,
    required this.address,
    required this.longitude,
    required this.latitude,
    this.imageUrl = '',
    this.city = '',
  });

  final String title;
  final String address;
  final double longitude;
  final double latitude;
  final String imageUrl;
  final String city;

  String get displayText {
    final label = title.trim().isNotEmpty ? title.trim() : address.trim();
    return label.isEmpty ? '[位置]' : '[位置] $label';
  }
}

/// Emitted by `pinnedSyncSignals` when server pushes `syncPinnedMessage`
/// CMD. _ChatScreenState 订阅后匹配 channelId+channelType 跟当前会话一
/// 致就 re-fetch /message/pinned/sync 拉增量更新 banner / 列表。
class WukongPinnedSyncSignal {
  const WukongPinnedSyncSignal({
    required this.channelId,
    required this.channelType,
  });

  final String channelId;
  final int channelType;
}

/// Emitted by reconnect hydration when the active chat is a group. The
/// chat page matches the channel and reuses its existing social gateway
/// `loadGroupMembers` / `syncGroupMembers` path, keeping IM and social
/// service ownership separate.
class WukongGroupMemberSyncSignal {
  const WukongGroupMemberSyncSignal({
    required this.channelId,
    required this.channelType,
  });

  final String channelId;
  final int channelType;
}

/// 频道被清空消息事件 — 触发源见 `ChatImGateway.channelClearedSignals`.
class WukongChannelClearedSignal {
  const WukongChannelClearedSignal({
    required this.channelId,
    required this.channelType,
  });

  final String channelId;
  final int channelType;
}

/// 朋友圈 IM CMD `momentMsg` 推送的事件载荷。
/// 对齐 iOS WKMomentMsgManager.cmdManager:onCMD: (`WKMomentMsgManager.m:101`):
///   model.cmd == "momentMsg"
///   model.param = {
///     action: "like" | "comment" | "delete_comment" | "publish",
///     action_at: int (unix ts),
///     comment: string (评论内容),
///     content: { moment_content, imgs[], video_conver_path } 原动态摘要,
///     moment_no, comment_id, uid, name (操作者),
///   }
class WukongMomentMsgSignal {
  const WukongMomentMsgSignal({
    required this.action,
    required this.actionAt,
    required this.momentNo,
    required this.uid,
    required this.name,
    this.commentId = '',
    this.comment = '',
    this.content = const {},
  });

  /// 'like' / 'comment' / 'delete_comment' / 'publish'
  final String action;
  final int actionAt;
  final String momentNo;
  final String uid;
  final String name;
  final String commentId;
  final String comment;

  /// 原朋友圈摘要: { moment_content, imgs[], video_conver_path }
  final Map<String, dynamic> content;
}

class WukongPinnedMessageSnapshot {
  const WukongPinnedMessageSnapshot({
    required this.messageId,
    required this.messageSeq,
    required this.clientMsgNo,
    required this.channelId,
    required this.channelType,
    required this.version,
    required this.text,
    this.fromUid = '',
    this.timestamp = 0,
  });

  factory WukongPinnedMessageSnapshot.fromJson(Map<String, dynamic> json) {
    return WukongPinnedMessageSnapshot(
      messageId: WukongImService._string(json['message_id']),
      messageSeq: WukongImService._readInt(json['message_seq']),
      clientMsgNo: WukongImService._string(json['client_msg_no']),
      channelId: WukongImService._string(json['channel_id']),
      channelType: WukongImService._readInt(json['channel_type']),
      version: WukongImService._readInt(json['version']),
      text: _payloadText(json['payload']),
      // 由 syncPinnedMessages join messages[] 时注入 (不是 server 原生
      // pinned_messages[] 字段), 给置顶列表页渲染发送者头像 / 名字 / 时间.
      fromUid: WukongImService._string(json['from_uid']),
      timestamp: WukongImService._readInt(json['timestamp']),
    );
  }

  final String messageId;
  final int messageSeq;
  final String clientMsgNo;
  final String channelId;
  final int channelType;
  final int version;
  final String text;

  /// 发送者 uid — caller 用来 lookup contact / 显头像名字.
  final String fromUid;

  /// 服务端 unix seconds. 0 表示 join messages[] 时没拿到.
  final int timestamp;

  /// 对齐 iOS WKPinnedView.m:141 `[[pinnedMessage content] conversationDigest]`：
  /// 按 contentType 输出预览文案，避免非文本消息（贴图/图片/语音 …）
  /// 在 banner 上直接 toString 整个 payload Map 变成 JSON 字符串。
  static String _payloadText(Object? payload) {
    final value = WukongImService._readPayload(payload);
    if (value is Map) {
      final source = Map<String, dynamic>.from(value);
      final type = WukongImService._readInt(source['type']);
      switch (type) {
        case WkMessageContentType.text:
          final content = WukongImService._string(source['content']);
          if (content.isNotEmpty) return content;
          break;
        case WkMessageContentType.image:
          return '[图片]';
        case _wkGifContentType:
          return '[动图]';
        case WkMessageContentType.voice:
          return '[语音]';
        case WkMessageContentType.video:
          return '[小视频]';
        case WkMessageContentType.card:
          return '[名片]';
        case WkMessageContentType.file:
          return '[文件]';
        case _wkLocationContentType:
          return '[位置]';
        case _wkMergeForwardContentType:
          return '[聊天记录]';
        case _wkLottieStickerContentType:
        case _wkEmojiStickerContentType:
          return '[贴图]';
        case _wkLivePhotoContentType:
          return '[实况]';
      }
      // 未知类型兜底：优先 content / name，避免 JSON dump
      final content = WukongImService._string(source['content']);
      if (content.isNotEmpty) return content;
      final name = WukongImService._string(source['name']);
      if (name.isNotEmpty) return name;
      return '[消息]';
    }
    return WukongImService._string(value);
  }
}

/// IM 长连接状态. 对齐 iOS WKConnectStatus SDK enum:
///   1 = connecting / 2 = kicked / 3 = connected / 4 = noNetwork
///   5 = connectFail / 6 = syncing (拉离线消息) / 7 = syncCompleted
/// `kicked` 单独走 kickedSignals (异地踢出 → 弹框 + 跳登录), 这里不上报.
/// `syncCompleted` 视作 `connected` (同一状态).
enum ChatConnectionStatus {
  /// 已断开 (初始 / connectFail / 主动 disconnect)
  disconnected,

  /// 连接中
  connecting,

  /// 已连接 (正常 / sync 完毕)
  connected,

  /// 收取离线消息中
  syncing,

  /// 无网络
  noNetwork,
}

class ImConnectGeneration {
  const ImConnectGeneration(this.value);

  final int value;

  ImConnectGeneration next() => ImConnectGeneration(value + 1);

  @override
  String toString() => value.toString();
}

class ImConnectionTraceEntry {
  const ImConnectionTraceEntry({
    required this.uid,
    required this.connectGeneration,
    required this.event,
    required this.status,
    required this.reason,
    required this.addr,
    required this.timestamp,
  });

  final String uid;
  final ImConnectGeneration connectGeneration;
  final String event;
  final String status;
  final String reason;
  final String addr;
  final DateTime timestamp;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'connectGeneration': connectGeneration.value,
      'event': event,
      'status': status,
      'reason': reason,
      'addr': addr,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

enum WukongMessageKind {
  text,
  image,
  file,
  voice,
  video,
  card,
  location,
  sticker,
  mergeForward,
  livePhoto,
  unknown,
}

/// Live Photo (iOS) = 静态图 + 配对 MOV (含音轨) 一起发送.
/// 协议形态参考 Telegram Bot API InputMediaLivePhoto (photo + video 双字段).
/// 接收端: 静态图渲染 + LIVE 角标, 长按播放 MOV (跟 iOS Photos app 体验对齐).
/// `url` (基类字段) = 静态图 URL; `videoUrl` = paired MOV URL.
class WKLivePhotoContent extends WKMediaMessageContent {
  WKLivePhotoContent() {
    contentType = _wkLivePhotoContentType;
  }

  String videoUrl = '';
  String videoLocalPath = '';
  int videoSize = 0;
  int second = 0;
  int size = 0;
  int width = 0;
  int height = 0;

  @override
  Map<String, dynamic> encodeJson() {
    return {
      'url': url,
      'localPath': localPath,
      'videoUrl': videoUrl,
      'videoLocalPath': videoLocalPath,
      'videoSize': videoSize,
      'second': second,
      'size': size,
      'width': width,
      'height': height,
    };
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    url = readString(json, 'url');
    localPath = readString(json, 'localPath');
    videoUrl = readString(json, 'videoUrl');
    videoLocalPath = readString(json, 'videoLocalPath');
    videoSize = readInt(json, 'videoSize');
    second = readInt(json, 'second');
    size = readInt(json, 'size');
    width = readInt(json, 'width');
    height = readInt(json, 'height');
    return this;
  }

  @override
  String displayText() => '[Live Photo]';

  @override
  String searchableWord() => displayText();
}

class WKGifContent extends WKMediaMessageContent {
  WKGifContent({String url = '', this.width = 0, this.height = 0}) {
    contentType = _wkGifContentType;
    this.url = url;
  }

  int width;
  int height;

  @override
  Map<String, dynamic> encodeJson() {
    return {'url': url, 'width': width, 'height': height};
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    url = readString(json, 'url');
    width = readInt(json, 'width');
    height = readInt(json, 'height');
    return this;
  }

  @override
  String displayText() => '[表情]';

  @override
  String searchableWord() => displayText();
}

class WKLottieStickerContent extends WKMediaMessageContent {
  WKLottieStickerContent() {
    contentType = _wkLottieStickerContentType;
  }

  String category = '';
  String placeholder = '';
  String format = 'lim';

  @override
  Map<String, dynamic> encodeJson() {
    return {
      'url': url,
      'category': category,
      'placeholder': placeholder,
      'format': format,
      'content': content,
    };
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    url = readString(json, 'url');
    category = readString(json, 'category');
    placeholder = readString(json, 'placeholder');
    format = readString(json, 'format');
    content = readString(json, 'content');
    return this;
  }

  // 对齐 iOS WKLottieStickerContent.conversationDigest (返回 LLang("[贴图]")):
  // 固定文案, 不读 placeholder. server 的 sticker.placeholder 实际是 SVG 字符串
  // (sticker store item 的占位 SVG, 不是给会话 preview 用的 label), 之前直接
  // 当文本吐到会话列表 → preview 显示 "<svg ..." raw. 跟 .lim 当 PNG 是同根
  // (§4.9.4 跨端 bug 先看 server data 实际格式).
  @override
  String displayText() => '[贴图]';

  @override
  String searchableWord() => displayText();
}

class WKEmojiStickerContent extends WKLottieStickerContent {
  WKEmojiStickerContent() {
    contentType = _wkEmojiStickerContentType;
  }

  // displayText 继承父类 [贴图]. iOS WKEmojiStickerContent.m 没 override
  // conversationDigest, 也是继承父类 [贴图], 两端一致.
}

class WKLocationContent extends WKMediaMessageContent {
  WKLocationContent({
    this.longitude = 0,
    this.latitude = 0,
    this.title = '',
    this.address = '',
    String imageUrl = '',
  }) {
    contentType = _wkLocationContentType;
    url = imageUrl;
  }

  factory WKLocationContent.fromLocation(ChatLocation location) {
    return WKLocationContent(
      longitude: location.longitude,
      latitude: location.latitude,
      title: location.title,
      address: location.address,
      imageUrl: location.imageUrl,
    );
  }

  double longitude;
  double latitude;
  String title;
  String address;

  @override
  Map<String, dynamic> encodeJson() {
    final data = <String, dynamic>{
      'lng': longitude,
      'lat': latitude,
      'title': title,
      'address': address,
    };
    if (url.isNotEmpty) {
      data['img'] = url;
    }
    return data;
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    longitude = _readDouble(json['lng']);
    latitude = _readDouble(json['lat']);
    title = readString(json, 'title');
    address = readString(json, 'address');
    url = readString(json, 'img');
    return this;
  }

  @override
  String displayText() {
    final label = title.trim().isNotEmpty ? title.trim() : address.trim();
    return label.isEmpty ? '[位置]' : '[位置] $label';
  }

  @override
  String searchableWord() => '[位置]';

  static double _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class WKFileContent extends WKMediaMessageContent {
  WKFileContent({this.name = '', this.size = 0}) {
    contentType = WkMessageContentType.file;
  }

  String name;
  int size;

  @override
  Map<String, dynamic> encodeJson() {
    return {'name': name, 'size': size, 'url': url, 'localPath': localPath};
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    name = readString(json, 'name');
    size = readInt(json, 'size');
    url = readString(json, 'url');
    localPath = readString(json, 'localPath');
    return this;
  }

  @override
  String displayText() {
    return name.isEmpty ? '[文件]' : '[文件] $name';
  }

  @override
  String searchableWord() => displayText();
}

class WKGroupApproveContent extends WKMessageContent {
  WKGroupApproveContent() {
    contentType = _wkGroupApproveContentType;
  }

  Map<String, Object?> data = const {};

  String get inviteNo {
    final value = data['invite_no'] ?? data['inviteNo'] ?? data['id'];
    return value?.toString().trim() ?? '';
  }

  @override
  Map<String, dynamic> encodeJson() {
    return Map<String, dynamic>.from(data)..['content'] = content;
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    final source = WukongImService._readMap(json);
    data = Map<String, Object?>.from(source);
    content = readString(source, 'content');
    if (!data.containsKey('invite_no') && inviteNo.isNotEmpty) {
      data = {...data, 'invite_no': inviteNo};
    }
    return this;
  }

  @override
  String displayText() {
    if (content.trim().isNotEmpty) {
      return content;
    }
    return '进群邀请待确认';
  }

  @override
  String searchableWord() => displayText();
}

/// Screenshot system notice — contentType 20. Sender broadcasts the
/// payload `{from_uid, from_name}` to the channel; receivers render it
/// as a centered system row "{name}在聊天中截屏了". Mirrors native iOS
/// WKScreenshotContent.
class WKScreenshotContent extends WKMessageContent {
  WKScreenshotContent({String fromUid = '', String fromName = ''})
    : screenshotFromUid = fromUid,
      screenshotFromName = fromName {
    contentType = _wkScreenshotContentType;
  }

  String screenshotFromUid;
  String screenshotFromName;

  @override
  Map<String, dynamic> encodeJson() => {
    'from_uid': screenshotFromUid,
    'from_name': screenshotFromName,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    screenshotFromUid = readString(json, 'from_uid');
    screenshotFromName = readString(json, 'from_name');
    return this;
  }

  @override
  String displayText() => '[截屏通知]';

  @override
  String searchableWord() => '[截屏通知]';
}

class WKCallSystemContent extends WKMessageContent {
  WKCallSystemContent(int type) {
    contentType = type;
  }

  static const contentTypes = [
    9988,
    9989,
    9990,
    9991,
    9992,
    9993,
    9994,
    9995,
    9996,
    9997,
    9998,
    9999,
  ];

  int callType = 0;
  int resultType = 0;
  int seconds = 0;

  /// LiveKit room id for group-call invite (contentType == 9988).
  /// Empty for any other call system message. Used by the chat
  /// screen to wire the bubble's onTap to `acceptGroupCall(roomId)`.
  String roomId = '';

  @override
  Map<String, dynamic> encodeJson() {
    return {
      'content': content,
      'call_type': callType,
      'result_type': resultType,
      'second': seconds,
      if (roomId.isNotEmpty) 'room_id': roomId,
    };
  }

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    content = readString(json, 'content');
    callType = readInt(json, 'call_type');
    resultType = readInt(json, 'result_type');
    seconds = readInt(json, 'second');
    roomId = readString(json, 'room_id');
    return this;
  }

  @override
  String displayText() {
    if (content.trim().isNotEmpty) {
      return content;
    }
    return switch (contentType) {
      9988 => '邀请加入群通话',
      9992 => '通话取消',
      9995 => '未接听',
      9996 => '收到通话',
      9997 => '通话拒绝',
      9998 => '接受通话',
      9999 => seconds > 0 ? '通话时长：${_formatDuration(seconds)}' : '挂断通话',
      _ => '通话消息',
    };
  }

  @override
  String searchableWord() => displayText();

  static String _formatDuration(int value) {
    final minutes = (value ~/ 60).toString().padLeft(2, '0');
    final secs = (value % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}

/// Catch-all message content used for native ContentType values that don't
/// have a dedicated UI yet (cards / merge-forward / system events / hotline).
/// Compute a friendly digest line for a single merge-forward entry from
/// its raw payload. Mirrors native iOS `WKMergeForwardCell.refresh:` which
/// calls `[message.content conversationDigest]` per content class.
String _digestFromMergeEntryPayload(
  int contentType,
  Map<String, dynamic> payload,
) {
  switch (contentType) {
    case 1:
      final c = payload['content'];
      if (c is String && c.trim().isNotEmpty) return c.trim();
      return '[消息]';
    case 2:
    case 3:
      return '[图片]';
    case 4:
      return '[语音]';
    case 5:
      return '[小视频]';
    case 6:
      return '[位置]';
    case 7:
      return '[名片]';
    case 8:
      return '[文件]';
    case 11:
      return '[聊天记录]';
    case 12:
    case 13:
      return '[贴图]';
    default:
      return '[消息]';
  }
}

/// One entry inside a merge-forward bubble. Each preserves enough
/// metadata to re-render the original message in the detail page (sender,
/// timestamp, contentType, the original payload as a json blob).
/// Mirrors the per-element structure of native iOS WKMergeForwardContent
/// `msgs[]` (see `WKMergeForwardContent.m messageToDict:`).
class MergeForwardEntry {
  const MergeForwardEntry({
    required this.messageId,
    required this.timestamp,
    required this.fromUid,
    required this.fromName,
    required this.contentType,
    required this.payload,
    required this.digest,
  });

  final String messageId;
  final int timestamp;
  final String fromUid;
  final String fromName;

  /// Original content type (e.g. 1 text, 2 image, 4 voice). Used by the
  /// detail page to pick the right inline renderer.
  final int contentType;

  /// Decoded original payload — same shape as `WKMessage.content.encodeJson()`
  /// on the original sender's device. Embedded verbatim so the receiver
  /// can rehydrate the message into the proper widget without another
  /// server roundtrip.
  final Map<String, dynamic> payload;

  /// Pre-computed display digest (`[图片]` / `[语音]` / first text line)
  /// used by the bubble's 4-line preview list.
  final String digest;

  Map<String, dynamic> encodeJson() {
    // Native iOS/Android encoders place the original ContentType inside
    // `payload['type']` (see `WKMergeForwardContent.m messageToDict:`).
    // Mirror that contract so receivers on either platform can rehydrate
    // the original message. Keep `content_type` at top level too — older
    // Flutter receivers fall back to it via the decoder's compat branch.
    final outPayload = Map<String, dynamic>.from(payload);
    if (!outPayload.containsKey('type')) {
      outPayload['type'] = contentType;
    }
    return {
      'message_id': messageId,
      'timestamp': timestamp,
      'from_uid': fromUid,
      'from_name': fromName,
      'content_type': contentType,
      'payload': outPayload,
      'digest': digest,
    };
  }
}

/// Wire model for `t=11` merge-forward content. Produced when a user
/// multi-selects N messages and taps "合并转发" in the action sheet.
/// The receiver renders this as a single bubble with a title + up to 4
/// preview lines + "聊天记录" footer; tapping the bubble pushes a
/// detail page that lists every entry. Mirrors native iOS
/// `WKMergeForwardContent` (see merge-forward-message.md spec).
class WKMergeForwardContent extends WKMessageContent {
  WKMergeForwardContent() {
    contentType = _wkMergeForwardContentType;
  }

  /// Channel type the bubble was originally collected from (`1` person /
  /// `2` group). Drives the title text — group becomes "群的聊天记录"
  /// regardless of `users[]` length per native title builder.
  int sourceChannelType = 1;
  List<Map<String, dynamic>> users = const [];
  List<MergeForwardEntry> msgs = const [];

  @override
  Map<String, dynamic> encodeJson() => {
    'channel_type': sourceChannelType,
    if (users.isNotEmpty) 'users': users,
    if (msgs.isNotEmpty) 'msgs': msgs.map((m) => m.encodeJson()).toList(),
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    sourceChannelType = readInt(json, 'channel_type');
    final rawUsers = json['users'];
    if (rawUsers is List) {
      users = rawUsers
          .whereType<Map>()
          .map((m) => Map<String, dynamic>.from(m))
          .toList(growable: false);
    } else {
      users = const [];
    }
    final rawMsgs = json['msgs'];
    if (rawMsgs is List) {
      // Build uid → name lookup from `users[]` since native iOS/Android
      // encoders only put `from_uid` per entry and the names live in the
      // top-level `users[]` array.
      final uidToName = <String, String>{};
      for (final u in users) {
        final uid = (u['uid'] ?? '').toString();
        final rawName = (u['name'] ?? u['display_name'] ?? '').toString();
        final name = moyuDisplayName(
          name: rawName,
          rawIdentity: uid,
          placeholder: '',
        );
        if (uid.isNotEmpty && name.isNotEmpty) {
          uidToName[uid] = name;
        }
      }
      msgs = rawMsgs
          .whereType<Map>()
          .map((m) {
            final src = Map<String, dynamic>.from(m);
            final rawPayload = src['payload'];
            final payloadMap = rawPayload is Map
                ? Map<String, dynamic>.from(rawPayload)
                : const <String, dynamic>{};
            // Native iOS/Android encoders put the original ContentType inside
            // `payload['type']` (see `WKMergeForwardContent.m messageToDict:`).
            // Flutter-side encoders may also write a top-level `content_type`
            // for backwards compat — accept either, prefer the native shape.
            final innerType = payloadMap['type'];
            final contentType = innerType is int
                ? innerType
                : innerType is num
                ? innerType.toInt()
                : readInt(src, 'content_type');
            // Digest: prefer explicit `digest` if Flutter wrote it, else
            // compute from native payload so mixed-platform forwards still
            // render readable preview lines.
            var digest = readString(src, 'digest');
            if (digest.isEmpty) {
              digest = _digestFromMergeEntryPayload(contentType, payloadMap);
            }
            final fromUid = readString(src, 'from_uid');
            var fromName = moyuDisplayName(
              name: readString(src, 'from_name'),
              rawIdentity: fromUid,
              placeholder: '',
            );
            if (fromName.isEmpty && fromUid.isNotEmpty) {
              fromName = uidToName[fromUid] ?? '';
            }
            return MergeForwardEntry(
              messageId: readString(src, 'message_id'),
              timestamp: readInt(src, 'timestamp'),
              fromUid: fromUid,
              fromName: fromName,
              contentType: contentType,
              payload: payloadMap,
              digest: digest,
            );
          })
          .toList(growable: false);
    } else {
      msgs = const [];
    }
    return this;
  }

  String resolveTitle() {
    if (sourceChannelType != 1) return '群的聊天记录';
    if (users.isEmpty) return '聊天记录';
    final names = users
        .map((u) => (u['name'] ?? u['display_name'] ?? '').toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (names.isEmpty) return '聊天记录';
    if (names.length == 1) return '${names[0]}的聊天记录';
    return '${names[0]}和${names[1]}的聊天记录';
  }

  @override
  String displayText() => '[聊天记录]';

  @override
  String searchableWord() => '[聊天记录]';
}

/// Stores raw payload + a static label so conversations and chat rows can
/// surface a friendly placeholder instead of the SDK's '[未知消息]' fallback.
class WKGenericLabelContent extends WKMessageContent {
  WKGenericLabelContent(int type, this._label) {
    contentType = type;
  }

  final String _label;
  Map<String, dynamic> _raw = const {};

  /// Raw decoded payload exposed read-only so the snapshot mapper can
  /// surface fields like `users[]` (kick / leave events) and `extra`
  /// without parsing the inline JSON twice. Empty when the server
  /// pushed an empty payload.
  Map<String, dynamic> get raw => _raw;

  @override
  Map<String, dynamic> encodeJson() => Map<String, dynamic>.from(_raw);

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    _raw = Map<String, dynamic>.from(json);
    final inline = _raw['content'];
    if (inline is String && inline.trim().isNotEmpty) {
      content = inline;
    }
    return this;
  }

  @override
  String displayText() {
    final text = content.trim();
    if (text.isNotEmpty) {
      final noticeText = _noticeUpdateDisplayText(text);
      if (noticeText.isNotEmpty) return noticeText;
      return text;
    }
    return _label;
  }

  @override
  String searchableWord() => displayText();

  String _noticeUpdateDisplayText(String text) {
    if (contentType != 1005) return '';
    final attr = (_raw['attr'] ?? '').toString();
    final data = _raw['data'];
    final hasNoticeData =
        attr == 'notice' ||
        (data is Map && data.containsKey('notice')) ||
        _raw.containsKey('notice');
    if (text.contains('清空了群公告')) {
      return text;
    }
    if (!hasNoticeData && !text.contains('修改群公告为')) {
      return '';
    }
    final marker = text.indexOf('修改群公告为');
    if (marker >= 0) {
      return '${text.substring(0, marker)}修改了群公告';
    }
    return text;
  }
}

class _SenderInfo {
  const _SenderInfo({this.uid = '', this.name = '', this.isMine = false});

  final String uid;
  final String name;
  final bool isMine;
}

/// Polled user presence sourced from `POST users/online`.
/// `lastOffline` is the unix-second timestamp of the last disconnect.
class ChatUserPresence {
  const ChatUserPresence({
    required this.uid,
    required this.online,
    this.deviceFlag = 0,
    this.lastOnline = 0,
    this.lastOffline = 0,
  });

  final String uid;
  final bool online;
  final int deviceFlag;
  final int lastOnline;
  final int lastOffline;
}

/// One typing event for a single (channel, user). The channel-level
/// state stores a map of these so multi-typer aggregation can render
/// `X 和 Y 正在输入...` / `几位成员正在输入...` instead of just the
/// most-recent typer. `displayName` is the sender's name as pushed in
/// the typing CMD; falls back to `'对方'` for 1:1 chats with no name.
class _TypingEntry {
  const _TypingEntry(this.displayName, this.startedAt);

  final String displayName;
  final DateTime startedAt;
}

/// Categorises an RTC P2P CMD so the UI layer can decide whether to
/// push the IncomingCallPage (invoke), drop the ringing UI (cancel),
/// flip the caller's state to connected (accept), or close the call
/// (refuse / hangup). Mirrors the 5 cases iOS `WKRTCManager` handles
/// in its onCmd dispatcher.
enum IncomingCallKind {
  invoke,
  accept,
  refuse,
  cancel,
  hangup,
  // 通话中切换语音→视频请求 (需 callee 同意, 等 switchToVideoReply).
  switchToVideo,
  // 视频切换请求的回应. `agreed` 字段 (event.agreed) 决定双方是否切换.
  switchToVideoReply,
  // 通话中视频→语音降级. 单向, 对方收到立即关 camera publish.
  switchToVoice,
}

/// Translated from an RTC CMD's param map. `fromUid` is the
/// originator (caller for invoke, callee for accept/refuse, caller for
/// cancel, terminating party for hangup). `roomId` is the LiveKit
/// room shared between caller + callee — supplied by the server in
/// the invoke CMD so the callee can `connectRoom` without having to
/// re-derive it from uids.
class IncomingCallEvent {
  const IncomingCallEvent({
    required this.kind,
    required this.fromUid,
    required this.callType,
    this.roomId = '',
    this.seconds = 0,
    this.isGroupCall = false,
    this.groupChannelId = '',
    this.groupChannelType = 0,
    this.fromName = '',
    this.roomEnded = false,
    this.groupParticipants = const [],
    this.agreed = false,
    this.callInstanceId = '',
  });

  /// "一次通话"唯一 id (server invoke 时生成 uuid). P2P roomId 是 deterministic
  /// (sorted "A@B"), 同一对人永远同一 roomId, 不能当通话级 id; 必须用
  /// call_instance_id 算 CallKit UUID + 做 tombstone, 否则同一对人下一次
  /// `call_instance_id`, 终止 CMD (hangup/cancel/refuse) 也透传, 让 client
  /// CallKit.endCall(uuid) 算出跟 showIncoming 一致的 UUID, iOS 后台
  /// Dynamic Island 才能正确消失. 空字符串 = 老版 server / cache miss,
  /// 算法回退用 (fromUid + roomId), 行为退化到旧 bug 模式.
  final String callInstanceId;

  final IncomingCallKind kind;
  final String fromUid;

  /// Display name of the caller / inviter, included in the server
  /// CMD payload (`from_name` for P2P, `inviter_name` for group)
  /// so the IncomingCallPage can show a real name even when the
  /// callee isn't yet friends with / hasn't met the caller. Empty
  /// when the CMD didn't include it (older server, fallback path).
  final String fromName;

  /// 0 = audio, 1 = video — matches RtcCallType enum on the wire and
  /// the iOS WKRTCCallType enum.
  final int callType;
  final String roomId;
  final int seconds;

  /// True when this event came from a `room.*` group CMD instead of
  /// the P2P 5-tuple. The UI then renders the IncomingCallPage with
  /// the group's name + avatar (looked up via `groupChannelId`)
  /// rather than treating `fromUid` as a single peer.
  final bool isGroupCall;

  /// Source group channel id from the `room.invoke` payload — used
  /// by the acceptance path to wire the post-accept `_CallPage`'s
  /// conversation back to the right group, so hangup/leave go
  /// through `/rtc/rooms/{id}/hangup` instead of the P2P path.
  final String groupChannelId;
  final int groupChannelType;

  /// `room.invoke` CMD only: invited uids list (excluding the inviter
  /// and self). Lets the callee render the same "邀请中…" tiles the
  /// caller sees instead of staring at an empty grid until invitees
  /// actually join. Source: server `room.invoke` payload
  /// `participants` field (modules/rtc/api.go:382).
  final List<String> groupParticipants;

  /// `rtc.p2p.switchToVideoReply` only: callee's verdict on the
  /// switch-to-video request. true → both sides switch local to video;
  /// false → requester shows "对方拒绝" toast and stays in audio.
  final bool agreed;

  /// `room.hangup` CMD only: set when the *owner* hung up and the
  /// whole group call is over (server fired `endRoom` + ended_at>0).
  /// callee's _CallPage uses this to differentiate "someone left"
  /// (default, just remove tile via LiveKit) vs "room ended"
  /// (must disconnect + close _CallPage). Without this flag joined
  /// callees stay in the LiveKit room with mic open after owner
  /// hangup until LiveKit's empty-room GC (~5 min).
  final bool roomEnded;
}
