import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:io';
import 'dart:ui' show instantiateImageCodec;

import 'package:audioplayers/audioplayers.dart'
    show DeviceFileSource, Source, UrlSource;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wukongimfluttersdk/type/const.dart' show WKChannelType;

import '../../app/app_runtime.dart';
import '../../auth/auth_repository.dart';
import '../../auth/locale_controller.dart';
import '../../auth/locale_store.dart';
import '../../call/chat_call_gateway.dart';
import '../../chat/agui_stream_message.dart';
import '../../chat/chat_message.dart';
import '../../chat/chat_message_action.dart';
import '../../chat/chat_message_dedupe.dart';
import '../../chat/chat_tool_action.dart';
import '../../chat/module_content_gate.dart';
import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../conversation/chat_conversation.dart';
import '../../im/wukong_im_service.dart';
import '../../l10n/app_localizations.dart';
import '../../media/image_editor_gateway.dart';
import '../../media/chat_media_service.dart';
import '../../media/voice_player.dart';
import '../../modules/feature_registry.dart';
import '../../modules/module_ids.dart';
import '../../modules/module_location_route.dart';
import '../../modules/module_message_ai.dart';
import '../../modules/module_message_bubble.dart';
import '../../modules/module_rtc_route.dart';
import '../../scan/chat_scan_service.dart';
import '../../social/social_service.dart';
import '../album_preview_strip.dart';
import '../chat_bubble_shell.dart';
import '../chat_call_bubble.dart';
import '../chat_bot_command_panel.dart';
import '../chat_composer_widgets.dart';
import '../chat_emoji_panel.dart';
import '../chat_flame_logic.dart';
import '../chat_group_invite_approval_bubble.dart';
import '../chat_image_lightbox.dart';
import '../chat_location_bubble.dart';
import '../chat_mention_logic.dart';
import '../chat_merge_forward_logic.dart';
import '../chat_message_action_policy.dart';
import '../chat_message_audience_pages.dart';
import '../chat_message_ai_logic.dart';
import '../chat_message_ai_widgets.dart';
import '../chat_message_context_menu.dart';
import '../chat_message_state_widgets.dart';
import '../chat_message_status_widgets.dart';
import '../chat_more_panel.dart';
import '../chat_navigation.dart';
import '../chat_peer_frame.dart';
import '../chat_reply_preview.dart';
import '../chat_rich_message_bubbles.dart';
import '../chat_selection_widgets.dart';
import '../chat_sticker_display.dart';
import '../chat_timeline_widgets.dart';
import '../chat_timeline_logic.dart';
import '../contact_list_widgets.dart'
    show contactChannelId, specialAccountDisplayName;
import '../home_seed_data.dart';
import '../identity_display.dart';
import '../merge_forward_detail_page.dart';
import '../models/contact_models.dart';
import '../moyu_ink.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../pinned_message_widgets.dart';
import '../settings_layout.dart';
import '../voice_input_panel.dart';
import '../../settings/font_scale_controller.dart';
import '../../settings/font_scale_store.dart';
import 'chat_background_pages.dart';
import 'chat_settings_pages.dart';
import 'friend_pages.dart';
import 'pickers_pages.dart';
import 'settings_pages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversation,
    required this.initialMessages,
    required this.initialUnread,
    this.initialOtherChatsUnread = 0,
    required this.config,
    required this.serverAppConfig,
    required this.contacts,
    required this.groups,
    required this.loginUid,
    required this.loginName,
    required this.loginChatPwd,
    required this.loginToken,
    required this.onSendText,
    required this.onSendMedia,
    required this.onSendSticker,
    required this.onSendLocation,
    required this.onClearMessages,
    required this.onDeleteConversation,
    this.onContactRemoved,
    this.onOpenContactChat,
    this.imGateway,
    this.socialGateway,
    this.mediaGateway,
    this.scanGateway,
    this.callGateway,
    this.runtime,
    this.messageStream,
    this.aguiEventStream,
    this.initialAnchorMessageId = '',
  });

  final ChatConversation conversation;
  final List<ChatMessage> initialMessages;

  /// 首屏打开后立即滚动到这条消息 id (best-effort). 用在搜索结果跳转
  /// (对齐 iOS WKConversationVC.locationAtOrderSeq). 消息若不在初始
  /// chunk 内, 当前实现暂只 no-op — 完整 "load around seq" 留 TODO.
  final String initialAnchorMessageId;

  /// Pre-zeroed unread count from the conversation list. Used by
  /// the chat screen to position the `以下是新消息` divider and
  /// to seed the `@-mention` scroll FAB from the messages that
  /// were unread on open. `conversation.unread` itself is always
  /// `0` because `_openChat` clears it before push to remove the
  /// red dot. Defaults to 0 (no unread window).
  final int initialUnread;

  /// 其他会话累计未读 (不含本会话). chat header 返回箭头右侧显示
  /// "(N)" badge 用 — 跟微信 chat 页 nav back 同模式. parent push 时
  /// 算 sum(其他 conversations.unread, 排除 mute), conversationSnapshots
  /// listener 之后实时刷新.
  final int initialOtherChatsUnread;
  final AppConfig config;
  final ChatServerAppConfig serverAppConfig;
  final List<UiContact> contacts;
  final List<UiGroup> groups;
  final String loginUid;
  final String loginName;
  final String loginChatPwd;

  /// Session API token — used as `token` HTTP header when video / file
  /// bubbles load media from the server. Without it the CDN paths
  /// (`/file/upload` etc.) 401 on Android with no helpful UI cue.
  final String loginToken;

  /// Send the composed text up to the parent. Optional named args
  /// thread mention metadata so admin-only `@全体成员` and
  /// regular `@member` picks reach the gateway's `sendText` payload
  /// (`mention.all = 1` / `mention.uids = [...]`). Defaults to a
  /// plain text send, which preserves backwards compatibility with
  /// composer paths that don't track mentions (re-edit, retry, etc).
  ///
  /// `replyMessageId` etc thread the reply quote target through to the
  /// gateway's `sendText` so the outgoing WKTextContent carries a
  /// WKReply payload. Without these the server records no reply
  /// linkage and the receiver's bubble shows no quote.
  final Future<void> Function(
    String text, {
    List<String> mentionUids,
    bool mentionAll,
    String replyMessageId,
    int replyMessageSeq,
    String replyFromUid,
    String replyFromName,
    String replyText,
  })
  onSendText;
  final Future<void> Function(ChatMediaAttachment attachment) onSendMedia;
  final Future<void> Function(ChatSticker sticker) onSendSticker;
  final Future<void> Function(ChatLocation location) onSendLocation;
  final VoidCallback onClearMessages;
  final Future<void> Function() onDeleteConversation;
  final ValueChanged<String>? onContactRemoved;

  /// 从聊天页内点 @mention / 资料页"发消息" 打开**另一个**联系人的会话.
  /// 不传则降级为提示"请到联系人页打开" (chatim 旧行为). home_shell 注入
  /// `_openContactChat`, 把目标会话 push 叠在当前聊天页上 (返回键回原会话).
  /// 修掉 chatim 既有 TODO (chat_screen_page onOpenContactChat 没接通).
  final Future<void> Function(UiContact contact)? onOpenContactChat;

  final ChatImGateway? imGateway;
  final ChatSocialGateway? socialGateway;
  final ChatMediaGateway? mediaGateway;
  final ChatScanGateway? scanGateway;
  final ChatCallGateway? callGateway;
  final AppRuntime? runtime;
  final Stream<WukongMessageSnapshot>? messageStream;
  final Stream<WukongAguiEventSnapshot>? aguiEventStream;

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  /// 当前打开的 chat 页对应 conversation key. 由 chat 页 `initState` set
  /// + `dispose` clear. home shell 的 `_applyRemoteMessage` 用它判断:
  /// 收到的 IM 消息所属 conversation == 此值 → 用户正在看, **不弹本地通知**.
  /// 跟微信"当前会话不响铃"同模式. null = chat 页未打开 (在主页 / 其他).
  static String? activeChannelKey;

  late final TextEditingController _composerController;
  // FocusNode 显式管理 composer 焦点 — 让 toggle emoji/more panel 能
  // 准确 unfocus 它 (FocusScope.of(context).unfocus() 在 round rect
  // 内嵌 Material+TextField 场景下偶发不生效, user 报"点 emoji 面板
  // 还会唤出键盘"). 也用于 reactive 跟踪 focus state 切换 textfield
  // 行数 (未 focus 1 行, focus 后 2 行).
  final FocusNode _composerFocus = FocusNode();
  late final ScrollController _messageScrollController;
  late List<ChatMessage> _messages;
  StreamSubscription<WukongMessageSnapshot>? _messageSubscription;
  StreamSubscription<WukongAguiEventSnapshot>? _aguiEventSubscription;
  StreamSubscription<List<WukongConversationSnapshot>>?
  _conversationSubscription;
  // 频道清空 / 消息删除事件订阅 — 让当前打开的聊天页跟 home_shell
  // 一样实时反映 SDK / 远端 clear/delete. 没这条之前: 另一台设备 (或
  // 本设备会话列表上) 清空, ChatScreen 内 _messages 不会变, 用户看到
  StreamSubscription<WukongChannelClearedSignal>? _channelClearedSub;
  StreamSubscription<String>? _messageDeletedSub;
  final Map<String, _MessageAiUiState> _messageAiStates =
      <String, _MessageAiUiState>{};
  ModuleMessageAiGateway? _messageAiGatewayCache;

  /// Subscription for the RTC call CMD stream — used to refresh the
  /// group-call banner when room.invoke (a new call started in this
  /// group) or room.hangup (caller ended it) lands. Only active for
  /// group conversations; null in 1:1.
  StreamSubscription<IncomingCallEvent>? _activeCallSubscription;

  /// Subscription for _CallSessionStore.endStream so the banner
  /// re-queries whenever a call ends from the local side (own hangup
  /// has no incoming CMD to react to).
  StreamSubscription<void>? _callEndSubscription;

  /// LiveKit room id of the active group call in this conversation,
  /// empty when there's no call. Drives the top "通话进行中" banner.
  String _activeGroupCallRoomId = '';

  /// 0 = audio / 1 = video for the active room — populated by the
  /// banner refresh poll so banner-tap accepts with the right
  /// modality. Without this, video groups would be joined as audio.
  int _activeGroupCallType = 0;

  AppRuntime? get _runtime => widget.runtime ?? AppRuntime.current;

  ModuleMessageAiGateway? get _messageAiGateway {
    final runtime = _runtime;
    final feature = runtime?.registry.featureById(
      ModuleFeatureIds.messageAiGatewayFactory,
    );
    if (runtime == null ||
        feature == null ||
        !runtime.isModuleEnabled(feature.moduleId)) {
      _messageAiGatewayCache = null;
      return null;
    }
    final cached = _messageAiGatewayCache;
    if (cached != null) return cached;
    final value = feature.value;
    if (value is! ModuleMessageAiGatewayFactory) return null;
    return _messageAiGatewayCache = value(
      config: widget.config,
      token: widget.loginToken,
    );
  }

  ModuleRtcSessionApi? get _rtcSessionApi {
    final runtime = _runtime;
    final feature = runtime?.registry.featureById(
      ModuleFeatureIds.rtcSessionApi,
    );
    if (feature == null || !runtime!.isModuleEnabled(feature.moduleId)) {
      return null;
    }
    final value = feature.value;
    return value is ModuleRtcSessionApi ? value : null;
  }

  ModuleCallPageBuilder? get _rtcCallPageBuilder {
    final runtime = _runtime;
    final feature = runtime?.registry.featureById(ModuleRouteIds.rtcCall);
    if (feature == null || !runtime!.isModuleEnabled(feature.moduleId)) {
      return null;
    }
    final value = feature.value;
    return value is ModuleCallPageBuilder ? value : null;
  }

  // 订阅 pinnedSyncSignals —— 服务端推 `syncPinnedMessage` CMD 时只对
  // 当前会话 channel 匹配的信号做 re-fetch (对齐 iOS WKPinnedModule:
  // cmdManager:onCMD: → requestSyncPinnedMessages)。
  StreamSubscription<WukongPinnedSyncSignal>? _pinnedSyncSubscription;
  StreamSubscription<WukongGroupMemberSyncSignal>? _groupMemberSyncSubscription;

  /// Mid-session shadow of `widget.conversation` — gets replaced when
  /// the gateway's conversation stream emits a fresher snapshot for
  /// this channel (e.g. group rename, avatar upload, mute toggle).
  /// `widget.conversation` itself is immutable from a single push,
  /// so without this the chat header would keep showing the stale
  /// title/avatar even after the SDK cache updated.
  late ChatConversation _conversation;
  String _groupOriginalName = '';
  String _groupRemarkTitle = '';
  // server 权威群成员数 (来自 loadGroupInfo => GET groups/<no> 的 member_count,
  // 跟群资料页同源)。0 = 尚未拿到。用于群聊标题 "(N)" 显示, 不再用群名 regex 瞎猜。
  int _groupServerMemberCount = 0;
  bool _showMorePanel = false;
  bool _showEmojiPanel = false;
  bool _showVoicePanel = false;
  // #3: 系统账号对话页底部"键盘/按钮"切换态 (微信公众号同款)。
  // false=显示关于按钮(默认), true=切到键盘输入。
  bool _systemAcctKeyboard = false;

  // robot command 菜单 (Telegram bot command 同款): 对方是 bot 时 composer
  // 显示 [/] 按钮, 点开命令面板, 点某条发 "/cmd" 文本给 bot。
  bool _showCommandPanel = false;
  bool _botCommandsLoaded = false;
  List<BotCommand> _botCommands = const [];

  // 对方是否 bot — initState 时 resolve (见 _resolvePeerBot). 不能只查
  // widget.contacts: 从「我的 Bots」进的 bot 或 friend version=0 的 bot 不在
  // contacts 快照里, 会漏判. 兜底问 server getUserInfo (robot 字段最权威).
  bool _peerBot = false;
  String _peerBotUname = '';
  BotRuntimeStatus? _peerBotRuntime;

  bool _peerIsBot() => _peerBot;
  String _peerBotUsername() => _peerBotUname;
  bool _peerBotAvailable() => _peerBotRuntime?.available == true;

  void _setPeerBot(String username) {
    if (!mounted) return;
    setState(() {
      _peerBot = true;
      _peerBotUname = username;
    });
    _startBotRuntimePolling();
  }

  Future<void> _resolvePeerBot() async {
    if (widget.conversation.channelType != WKChannelType.personal) return;
    final cid = widget.conversation.channelId;
    // 快路径: contacts 快照命中
    for (final c in widget.contacts) {
      if (c.uid == cid) {
        if (c.isRobot) {
          _setPeerBot(c.username);
        }
        // 命中 contacts (不管是不是 bot) → 真人不必再问 server
        if (c.isRobot || c.username.isNotEmpty || c.name.isNotEmpty) return;
        break;
      }
    }
    // 慢路径: contacts 没有 (bot 不在好友快照 / version=0) → 问 server
    final gw = widget.socialGateway;
    if (gw == null) return;
    try {
      final info = await gw.getUserInfo(cid);
      if (!mounted || info == null || !info.isRobot) return;
      _setPeerBot(info.username);
    } catch (_) {}
  }

  Future<void> _loadBotCommands() async {
    final gw = widget.socialGateway;
    final uname = _peerBotUsername();
    if (gw == null || uname.isEmpty) {
      if (mounted) setState(() => _botCommandsLoaded = true);
      return;
    }
    try {
      final cmds = await gw.botCommands(uname);
      if (!mounted) return;
      setState(() {
        _botCommands = cmds;
        _botCommandsLoaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _botCommandsLoaded = true);
    }
  }

  void _toggleCommandPanel() {
    if (_showCommandPanel) {
      setState(() => _showCommandPanel = false);
      return;
    }
    _dismissComposerKeyboard();
    setState(() {
      _showCommandPanel = true;
      _showEmojiPanel = false;
      _showMorePanel = false;
      _showVoicePanel = false;
    });
    if (!_botCommandsLoaded) unawaited(_loadBotCommands());
  }

  void _sendCommand(String cmd) {
    setState(() => _showCommandPanel = false);
    _composerController.text = cmd;
    _sendText();
  }

  /// #2: 系统账号按钮态 (非键盘态) — 在原 composer Row 内把中间文本框换成
  /// "关于"按钮 (同 Row 同高, 不另起控件)。仅系统账号 (u_10000)。
  bool get _sysAcctButtonMode =>
      widget.conversation.channelId == kSystemUID && !_systemAcctKeyboard;

  // #6 大表情: 单 emoji → emoji 大贴纸 映射表 (key = unicode emoji)。从内置
  // manifest (assets/emoji_stickers/manifest.json) 加载一次, static 全 app 共享,
  // 不每次进页重建。空 = 没加载到 → 发送照常走文本。对齐 Android 原版
  // StickerDBManager.emojiStickerList。
  static final Map<String, ChatSticker> _emojiStickerMap = {};
  static bool _emojiStickersLoaded = false;
  bool _albumPreviewLoading = false;
  bool _albumPreviewLoaded = false;
  List<AlbumPreviewItem> _albumPreviewItems = const [];
  ChatMessage? _actionMessage;
  ChatMessage? _replyTo;
  ChatMessage? _editingMessage;
  String? _actionNotice;
  List<WukongPinnedMessageSnapshot> _pinnedMessages = const [];

  /// Mid-session shadow of `widget.conversation.memberRemoved`. Flips
  /// to true when a 1003 / 1020 / 1021 system message arrives that
  /// names the current user — locks the composer with `你已离开该聊天`
  /// without waiting for the conversation list refresh that updates
  /// `widget.conversation`. Mirrors native iOS
  /// `WKSystemMessageHandler` side-effect that disables the input
  /// bar the moment the kick / leave event lands. Stays false for
  /// 1:1 chats and group events affecting other members.
  bool _localMemberRemoved = false;
  ChatBackground _chatBackground = const ChatBackground();
  bool _hasComposerText = false;
  ChatUserPresence? _peerPresence;

  /// Render-ready typing label sourced from the gateway's
  /// `typingSnapshots` stream for this channel. The gateway already
  /// produces full strings like `对方正在输入...` (1:1) or
  /// `Alice 正在输入...` (group), so this is rendered as-is — no
  /// suffix appended on the UI side. Empty when nobody is typing,
  /// which falls back to the presence-based subtitle.
  String _typingLabel = '';
  StreamSubscription<Map<String, String>>? _typingStreamSub;

  /// 用户已添加的贴纸包. _EmojiPanel 顶部 tab 在 emoji 8 类之后插这些
  /// 包作为 tab. 进 chat 时 lazy load, 商店/管理页 pop 后 reload.
  /// 对齐 iOS WKEmojiPanel + WKStickerContentView 的 panelContentNewList
  /// 动态注册逻辑.
  // #缓存: 贴纸面板数据改 static, 全 app 会话级共享 — 进对话页用缓存秒开,
  // 不再每次重拉 (只在 _stickerPanelLoaded=false 或商店返回 force 时拉)。
  static List<ChatStickerPack> _userStickerPacks = const [];

  /// 用户自定义贴纸 (从 chat 长按图片"添加到表情"收藏的单张图).
  /// emoji panel 末尾"⭐自定义" tab 显示. 对齐 iOS
  /// WKStickerCollectedContentView.
  static List<ChatSticker> _customStickers = const [];

  /// per-pack stickers 缓存 — emoji panel 切到某个包 tab 时 lazy load
  /// stickers, 不重复请求. key = pack.category. static 会话级共享。
  static final Map<String, List<ChatSticker>> _stickerPackStickers = {};

  /// 贴纸面板数据是否已加载过 (会话级)。false → 进页拉一次; 商店返回 force 刷。
  static bool _stickerPanelLoaded = false;
  Timer? _presencePollTimer;
  Timer? _botRuntimePollTimer;
  bool _isLoadingOlder = false;
  bool _hasMoreHistory = true;
  static const int _historyPageSize = 30;
  bool _showJumpToBottom = false;
  int _newMessagesBelow = 0;

  /// messageId of the OLDEST unread incoming message that mentions
  /// the current user (either via `mentionAll` or by listing
  /// `loginUid` in `mentionUids`). Empty when nothing matches —
  /// hides the mention FAB. Mirrors native iOS
  /// `WKConversationViewController`'s `@-mention hint button` which
  /// stacks above the unread `↓` FAB.
  String _pendingMentionMessageId = '';

  /// True when `_pendingMentionMessageId` was latched from a live
  /// incoming gateway message (user was scrolled up when it
  /// arrived). False when seeded from `widget.initialMessages` on
  /// chat-open. Used by the scroll callback to decide whether to
  /// auto-clear the FAB on bottom-reached: incoming mentions
  /// dismiss when the user reaches bottom (they implicitly read
  /// the message), seeded mentions stay until explicitly handled
  /// since the message itself can be far above the bottom.
  bool _pendingMentionFromIncoming = false;
  static const double _jumpToBottomThreshold = 240;

  /// Index in `_messages` of the first message that was unread when the
  /// chat was opened — drives the "以下是新消息" divider. Negative when
  /// there were no unread messages. Latched at initState; doesn't move
  /// as new messages stream in. Recomputed via `_firstUnreadAnchorId`
  /// after pagination so prepending older history doesn't shift the
  /// divider to the wrong row.
  int _firstUnreadIndex = -1;

  /// messageId of the first unread message on chat open. Stable across
  /// pagination — used to recompute `_firstUnreadIndex` whenever
  /// older history is prepended via `_loadOlderMessages`. Empty when
  /// there were no unread messages on open. Mirrors native iOS
  /// `WKConversationContext.firstUnreadMessageID` which anchors the
  /// divider by id, not index.
  String _firstUnreadAnchorId = '';

  /// Snapshot of the unread count on open — used by the divider
  /// label `<count> 条新消息`. Doesn't change as new messages arrive
  /// (matches native iOS where the count is the post-open snapshot).
  int _initialUnreadCount = 0;

  /// messageId of the FIRST renderable unread message (bubble — not
  /// hidden RTC frame, system row, etc.) used by the post-frame
  /// auto-scroll. May differ from `_firstUnreadAnchorId` when the
  /// divider falls on a non-bubble row whose `GlobalKey` doesn't
  /// register in `_messageBubbleKeys`. Empty when no bubble is
  /// available — auto-scroll then falls through to the existing
  /// bottom-aligned default.
  String _autoScrollAnchorId = '';

  /// Count of messages appended to `_messages` AFTER the chat
  /// screen opened — incoming peer messages, the user's own sends.
  /// Subtracted from `_messages.length` when computing the unread
  /// divider's index in the overflow path so live arrivals don't
  /// drift the divider downward (the open-time unread snapshot is
  /// fixed; new arrivals don't belong inside the unread window).
  int _liveAppendsCount = 0;

  /// Per-message destruction timers for flame (阅后即焚) channels.
  /// Keyed by `messageId`; entry exists once a timer has been scheduled
  /// for that message so we don't double-fire on rebuilds. Cancelled on
  /// dispose so we don't ghost-mutate after the chat is gone.
  final Map<String, Timer> _flameTimers = {};

  /// Per-message upload progress notifiers. Keyed by `clientMsgNo`,
  /// created in `_uploadAndSendMedia` when upload starts, disposed and
  /// removed in the `finally` block. `_FileBubbleContent` subscribes
  /// via ValueListenableBuilder so per-tick progress updates only
  /// rebuild that single bubble (vs. setState on the whole message
  /// list). Mirrors iOS WKMessageFileUploadTask listener pattern
  /// (WKFileCell.m:133-155) without coupling Flutter UI to dio.
  final Map<String, ValueNotifier<double>> _uploadProgress = {};

  /// OS-level screenshot detection. iOS fires immediately on
  /// UIApplicationUserDidTakeScreenshotNotification; Android requires
  /// storage permission to observe the DCIM/Screenshots dir.
  /// Stays nullable so the chat keeps working if the plugin throws on
  /// init (e.g. permission denied on Android).
  ScreenCaptureEvent? _screenCapture;
  DateTime? _lastScreenshotAt;

  /// Live mirror of `widget.conversation.notifyScreenshot`. Seeded in
  /// `initState`, mutated via the settings page callback when the user
  /// toggles "截屏通知". Without this state the gate would read the
  /// stale conversation snapshot held since chat-open and miss in-
  /// session toggles (settings page → back → screenshot).
  late bool _notifyScreenshot;

  /// Live mirrors of `widget.conversation.flameEnabled / flameSecond`
  /// for the same reason as `_notifyScreenshot` above. Header chip
  /// (block 5.7) reads these so toggling 阅后即焚 in the settings page
  /// updates the chip immediately, not after a snapshot refresh.
  late bool _flameEnabled;
  late int _flameSecond;

  /// Last time we emitted a typing notice over the wire. Used by
  /// `_emitTypingThrottled` to enforce the 4s cadence native iOS
  /// `WKTypingManager` uses (typing-flow.md §1.1). Reset to `now` at
  /// `_sendText` time so the next throttled emit doesn't go out
  /// immediately after the user has already sent the message they
  /// were typing.
  DateTime? _lastTypingEmitAt;
  static const Duration _typingThrottle = Duration(seconds: 4);

  /// True during the `_restoreDraft` controller assignment so the
  /// composer-changed listener can ignore the synthetic insert and
  /// skip the typing emit. Without this flag, opening a chat with a
  /// saved draft would surface a misleading "正在输入" indicator on
  /// the peer side and burn the local 4s throttle window before the
  /// user has actually typed anything.
  bool _isRestoringDraft = false;

  /// Group-only: cached member list used by the @ picker. Loaded lazily on
  /// first chat-open and reused.
  List<ChatContact> _groupMembers = const [];

  /// True iff the current login user is owner (role=1) or manager
  /// (role=2) of the open group. Drives the picker's `@全体成员` row
  /// visibility — non-admins shouldn't even see the option per
  /// native iOS `WKUserHandleVC` admin gate (mention-picker.md §1.3).
  /// Stays false outside group chats. Refreshed alongside the
  /// roster in `_loadGroupMembers` via `syncGroupMembers` (which
  /// returns role) and falls back to `false` on fetch error.
  bool _isGroupAdmin = false;

  /// Per-message mention bookkeeping populated by `_selectMention`
  /// and consumed + reset by `_sendText`.
  ///
  /// Ordered list of mention picks for the current composer entry,
  /// each pairing a uid with the inserted display label. Stored as
  /// a list (not a map) so two members sharing the same label both
  /// get tracked independently — at send time we count how many
  /// `@<label>` chips actually remain in the text and take the
  /// FIRST N matching uids in pick order. Dropping a chip therefore
  /// removes a uid by occurrence rather than by name.
  ///
  /// `_pendingMentionAllLabel` (non-empty when admin picked
  /// `@全体成员`) flips false at send time when the bounded
  /// `@全体成员` substring is no longer in the composer text.
  final List<MentionPick> _pendingMentionPicks = [];
  String _pendingMentionAllLabel = '';

  /// MessageIds of received voice messages the user has tapped-play
  /// during this chat session. Used by the bubble's `voiceUnread`
  /// gate alongside the snapshot's `voiceStatus`. The set is the
  /// authoritative source for "I just heard it" since the SDK 1.7.9
  /// `wkSyncExtraMsg2WKMsgExtra` mapping doesn't carry
  /// `message_extra.voice_status` back through the sync path —
  /// refreshed messages can come back as voiceStatus=0 even after
  /// the server-side flip lands. Local set survives until the chat
  /// screen disposes.
  final Set<String> _locallyHeardVoiceIds = <String>{};

  /// Per-message mention metadata attached out-of-band so retries
  /// after a send-failure can re-fire `mentionUids` / `mentionAll`
  /// without modifying every `ChatMessage` constructor. Identity-
  /// keyed via `Expando`; entries clean up implicitly when the
  /// message is removed from `_messages` (Dart GCs it).
  final Expando<({List<String> mentionUids, bool mentionAll})>
  _messageMentionMeta = Expando();

  /// Active @ query (lowercased without '@') — non-null while the picker
  /// should be visible. Empty string means picker is open with no filter.
  String? _mentionQuery;

  /// Index in the composer text where the active `@` lives.
  int _mentionAnchor = -1;

  /// Multi-select mode flag. When true, bubble taps toggle selection
  /// instead of invoking the bubble's normal onTap; long-press is
  /// disabled; the composer is hidden behind a batch-action bar.
  bool _isMultiSelect = false;

  /// Stable selection keys (messageId or clientMsgNo) of the currently
  /// selected messages. Using keys instead of object references survives
  /// list mutations from refresh listeners.
  final Set<String> _selectedMessageKeys = <String>{};

  /// Find this chat's snapshot in the gateway emission and refresh
  /// our local `_conversation` copy when title / avatar / mute / pin
  /// change. The conversation list page subscribes to the same stream
  /// at `_HomeShellState`, so this is purely so the open chat page
  /// follows along — without it the chat header keeps showing the
  /// stale group title after a rename.
  /// 其他会话累计未读 (不含本会话, 排除 mute). 跟微信 chat header 返回
  /// 箭头右侧 "(N)" badge 同源. initState 用 widget.initialOtherChatsUnread
  /// seed, 之后每次 _handleConversationSnapshots 收到 imGateway 全量
  /// snapshots 重算.
  late int _otherChatsUnread;

  void _handleConversationSnapshots(List<WukongConversationSnapshot> list) {
    if (!mounted) return;
    var otherUnread = 0;
    for (final s in list) {
      if (s.channelId == widget.conversation.channelId &&
          s.channelType == widget.conversation.channelType) {
        continue;
      }
      if (s.muted) continue;
      otherUnread += s.unread;
    }
    if (otherUnread != _otherChatsUnread) {
      setState(() => _otherChatsUnread = otherUnread);
    }
    for (final snap in list) {
      if (snap.channelId == widget.conversation.channelId &&
          snap.channelType == widget.conversation.channelType) {
        final next = ChatConversation.fromSnapshot(
          snap,
          colors: _conversation.colors,
        );
        // 漏 diff 任何 setting 字段 → 用户改完 server 后 _conversation
        // 还是 stale, 再 push ConversationSettingsPage 显示旧值. 之前漏
        // chatPasswordEnabled 用户报 "聊天密码设置完重进显关闭". sweep
        // 所有 chat-settings 内 switch / picker 驱动的字段:
        if (next.name != _conversation.name ||
            next.avatarPath != _conversation.avatarPath ||
            next.muted != _conversation.muted ||
            next.pinned != _conversation.pinned ||
            next.receiptEnabled != _conversation.receiptEnabled ||
            next.chatPasswordEnabled != _conversation.chatPasswordEnabled ||
            next.flameEnabled != _conversation.flameEnabled ||
            next.flameSecond != _conversation.flameSecond ||
            next.notifyScreenshot != _conversation.notifyScreenshot ||
            next.forbidden != _conversation.forbidden ||
            next.memberRemoved != _conversation.memberRemoved) {
          // Track `forbidden` and `memberRemoved` here too so 全员禁言
          // toggles + 退群 / 踢出 events reach the composer lock without
          // waiting for the user to re-navigate. Composer reads from
          // `_conversation`, not `widget.conversation`, so this diff
          // must include every field that drives the lock banner.
          setState(() => _conversation = next);
        }
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    if (widget.conversation.channelType == WKChannelType.group) {
      _groupOriginalName = _initialGroupOriginalName();
      unawaited(_loadGroupTitleMetadata());
    } else {
      // 单聊: resolve 对方是否 bot (决定 composer 是否显示 [/] 命令按钮)
      unawaited(_resolvePeerBot());
    }
    _otherChatsUnread = widget.initialOtherChatsUnread;
    _notifyScreenshot = widget.conversation.notifyScreenshot;
    _flameEnabled = widget.conversation.flameEnabled;
    _flameSecond = widget.conversation.flameSecond;
    // 标记当前 chat 页打开的 channel — home_shell `_applyRemoteMessage`
    // 收到 IM 消息时查这个 static, 等于当前 channel 就**不弹本地通知**
    // (用户正在看, 弹了反而吵). 跟微信"当前会话不响"同模式.
    activeChannelKey =
        '${widget.conversation.channelId}|${widget.conversation.channelType}';
    // Group-call banner state. Fire-and-forget query + listen to
    // incoming RTC CMD stream so the banner appears as soon as a call
    // starts in this group (no need to wait for the next chat-open).
    if (widget.callGateway != null &&
        widget.conversation.channelType == WKChannelType.group) {
      unawaited(_refreshActiveGroupCall());
      _activeCallSubscription = widget.imGateway?.incomingCallSignals.listen(
        _handleRtcCallSignal,
      );
      // Also re-check the banner when ANY call in this app ends
      // (own hangup, peer hangup, auto-end). The hangup CMD path
      // alone doesn't cover the "I'm the one hanging up" case —
      // there's no incoming CMD when we trigger our own hangup,
      // so without this signal the banner could stay "通话进行中"
      // after the last person (me) left. User-facing bug:
      // "最后一个挂断后, 群 banner 还在".
      final rtcSessionApi = _rtcSessionApi;
      _callEndSubscription = rtcSessionApi?.endStream.listen((_) {
        if (!mounted) return;
        // Clear the banner state IMMEDIATELY so the UI hides without
        // waiting on the server round-trip. The server-side
        // queryActiveRoomBySource is eventually consistent (the
        // current user's own status flip from Joined→Hangup races
        // the refresh request), so an immediate clear is the right
        // optimistic outcome — if another call somehow appeared
        // concurrently the room.invoke CMD listener will set it
        // back. Then fire a delayed refresh as the source-of-truth
        // re-sync.
        if (_activeGroupCallRoomId.isNotEmpty) {
          setState(() {
            _activeGroupCallRoomId = '';
            _activeGroupCallType = 0;
          });
        }
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          unawaited(_refreshActiveGroupCall());
        });
      });
    }
    // Sync our local conversation copy from the IM gateway whenever
    // a fresher snapshot arrives — this is what lets the chat header
    // pick up `name` / `avatarPath` / `muted` / `pinned` updates that
    // happen while the chat page is open (group rename, avatar
    // upload, channel-info push from another device).
    _conversationSubscription = widget.imGateway?.conversationSnapshots.listen(
      _handleConversationSnapshots,
    );
    _composerController = ComposerTextEditingController();
    _composerController.addListener(_handleComposerChanged);
    // Reactive 重建 composer 让 minLines 跟随 focus 状态 (1 行 ↔ 2 行).
    _composerFocus.addListener(_handleComposerFocusChanged);
    // Restore the persisted draft, if any. Async fire-and-forget so
    // initState stays sync; the user lands on the chat with an empty
    // composer for ~1 frame, then the draft (if present) populates.
    // Mirrors native iOS `WKConversationContext.drafts` which restores
    // synchronously from disk during the input panel's `init`.
    unawaited(_restoreDraft());
    _messageScrollController = ScrollController()
      ..addListener(_onMessageListScroll);
    _messages = List.of(widget.initialMessages);
    // If we already opened with fewer than a page of messages there may be
    // nothing older on the server either — start optimistic and let the
    // first fetch confirm.
    _hasMoreHistory = widget.initialMessages.length >= _historyPageSize;
    if (widget.initialUnread > 0 && widget.initialMessages.isNotEmpty) {
      // Clamp the unread window to the loaded page. When the server
      // reports more unread than fit in the initial fetch (e.g. 80
      // unread but `loadMessages` only returned the latest 30),
      // every row is in the unread tail — the divider sits at row 0.
      final unreadOverflow =
          widget.initialUnread >= widget.initialMessages.length;
      _firstUnreadIndex = unreadOverflow
          ? 0
          : widget.initialMessages.length - widget.initialUnread;
      _initialUnreadCount = widget.initialUnread;
      // Only anchor by messageId when the FIRST unread message is
      // actually present in the initial page. If the unread window
      // overflowed (older unread messages still paginated out), the
      // initial page's row 0 is NOT the true first-unread; anchoring
      // there would keep the divider glued at the wrong row after
      // `_loadOlderMessages` prepends the real first-unread above.
      // Leave the anchor empty in that case so the divider stays at
      // index 0 (clamped) and naturally moves up as older unread
      // history loads in.
      if (!unreadOverflow) {
        final anchor = widget.initialMessages[_firstUnreadIndex];
        _firstUnreadAnchorId = anchor.messageId;
      }
      // Pick the auto-scroll target separately. The divider anchor
      // can fall on a non-bubble row (system message, hidden RTC
      // signaling frame) — those don't get a `GlobalKey` registered
      // by `_bubbleKeyFor`, so `_scrollToMessage` would no-op and
      // leave the user at the bottom. Walk forward from the unread
      // boundary picking the FIRST rendered-bubble message id;
      // empty when none qualifies.
      for (var i = _firstUnreadIndex; i < widget.initialMessages.length; i++) {
        final m = widget.initialMessages[i];
        if (m.messageId.isEmpty) continue;
        if (m.isHiddenRtcSignalingFrame) continue;
        if (m.isSystemMessage) continue;
        _autoScrollAnchorId = m.messageId;
        break;
      }
    }
    // Seed the @-mention scroll hint from already-loaded messages
    // when there's an unread window. Walk the unread tail
    // (oldest-first) so the hint targets the FIRST mention the
    // user hasn't seen — mirrors native iOS which surfaces the
    // FAB on chat-open when prior messages contain `@me`.
    if (_firstUnreadIndex >= 0 && widget.loginUid.isNotEmpty) {
      for (var i = _firstUnreadIndex; i < widget.initialMessages.length; i++) {
        final m = widget.initialMessages[i];
        if (m.isMine || m.revoked) continue;
        if (m.messageId.isEmpty) continue;
        if (m.mentionsLoginUser(widget.loginUid)) {
          _pendingMentionMessageId = m.messageId;
          break;
        }
      }
    }
    // 进 chat 后 fire-and-forget 拉远程最新消息 (跟微信进 chat 立刻
    // 显示 cached + 后台 sync 同模式). 必须等 `_messages` 初始化后再启动,
    // 否则 remote 很快返回时会读到 late 字段未初始化。
    unawaited(_fetchRemoteMessagesOnOpen());
    _messageSubscription = widget.messageStream?.listen(_handleGatewayMessage);
    _aguiEventSubscription = widget.aguiEventStream?.listen(_handleAguiEvent);
    _channelClearedSub = widget.imGateway?.channelClearedSignals.listen(
      _handleChannelClearedInChat,
    );
    _messageDeletedSub = widget.imGateway?.messageDeletedSignals.listen(
      _handleMessageDeletedInChat,
    );
    _typingStreamSub = widget.imGateway?.typingSnapshots.listen(
      _onTypingSnapshot,
    );
    // Seed from the gateway's current map so opening a chat that
    // already had an active typing event surfaces the indicator
    // immediately — broadcast streams don't replay last-known state
    // to new listeners, so without this seed the header stays
    // blank until the peer hits the keyboard again.
    final initialTyping = widget.imGateway?.currentTypingSnapshot;
    if (initialTyping != null) {
      final key =
          '${widget.conversation.channelType}_${widget.conversation.channelId}';
      final seeded = initialTyping[key] ?? '';
      if (seeded.isNotEmpty) {
        _typingLabel = seeded;
      }
    }
    unawaited(_loadChatBackground());
    unawaited(_loadSessionWatermark());
    unawaited(_loadPinnedMessages());
    unawaited(_warmSensitiveWords());
    // 订阅 pinnedSyncSignals: 服务端推 `syncPinnedMessage` CMD 后 (来
    // 自其它设备 pin/unpin 同一频道)，匹配当前 channel 就 re-fetch
    // pin 列表更新 banner。对齐 iOS WKPinnedModule.cmdManager:onCMD:
    // → WKPinnedService.requestSyncPinnedMessages。
    _pinnedSyncSubscription = widget.imGateway?.pinnedSyncSignals.listen((
      signal,
    ) {
      if (!mounted) return;
      if (signal.channelId == widget.conversation.channelId &&
          signal.channelType == widget.conversation.channelType) {
        unawaited(_loadPinnedMessages());
      }
    });
    // Reconnect hydration signal: if the active chat is a group, refresh
    // member roster + role gate through the existing social gateway path.
    _groupMemberSyncSubscription = widget.imGateway?.groupMemberSyncSignals
        .listen((signal) {
          if (!mounted) return;
          if (signal.channelId == widget.conversation.channelId &&
              signal.channelType == widget.conversation.channelType) {
            unawaited(_loadGroupMembers());
          }
        });
    _startPresencePolling();
    // Mark whatever the chat opened with as read so the sender sees the ✓✓
    // receipt (mirrors native iOS WKChatViewController -[viewWillAppear]
    // which fires `message/readed` for the currently visible page).
    unawaited(_markVisibleMessagesRead());
    // Tell the gateway which channel the user is in so server-pushed
    // `syncMessageExtra` cmds without a param (1:1 case) can fall back to
    // this channel, and proactively pull the latest extras now in case a
    // cmd fired before the listener was wired.
    widget.imGateway?.setActiveChannel(
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
    );
    unawaited(
      widget.imGateway?.syncAndStoreMessageExtras(
            channelId: widget.conversation.channelId,
            channelType: widget.conversation.channelType,
          ) ??
          Future<void>.value(),
    );
    // Pull the latest reaction delta from server into the SDK reaction
    // DB the moment the chat opens — without this, every chat re-entry
    // shows an empty reaction strip even though the user tapped an
    // emoji earlier (the SDK only auto-stores reactions for the
    // current session; once the WKMsg is re-queried from local DB it
    // joins reactionList from the DB, which was never written).
    // Mirrors iOS WKMessageListView.viewDidLoad calling
    // `[[WKSDK shared].reactionManager sync:self.channel]`.
    unawaited(
      widget.imGateway?.syncAndStoreReactions(
            channelId: widget.conversation.channelId,
            channelType: widget.conversation.channelType,
          ) ??
          Future<void>.value(),
    );
    // Lazy-load group members for the @ mention picker.
    if (widget.conversation.channelType == WKChannelType.group) {
      unawaited(_loadGroupMembers());
    }
    // Lazy-load 用户贴纸包 + 自定义贴纸 — emoji panel 顶部 tab 在 emoji
    // 8 类之后插用户已添加的每个包 + "⭐自定义" tab. 商店/管理页 pop
    // 后会 reload 一次保证 hot reload.
    unawaited(_loadStickerPanelData());
    unawaited(_loadEmojiStickers()); // #6: 单 emoji → 大表情 映射表
    _initScreenshotWatch();
    // ListView uses reverse:true so the initial position (offset 0) is the
    // visual bottom — we open already pinned to the latest message with no
    // scroll animation needed. When the conversation has unread
    // messages the spec mandates opening AT the divider instead, so
    // post-frame we shift up to it. Mirrors native iOS
    // `WKConversationViewController -[scrollToFirstUnread]`.
    // Two paths:
    //   1. Anchored (first unread in initial page): scroll to the
    //      anchor messageId via `_scrollToMessage`.
    //   2. Overflow (`_initialUnreadCount > 0` but anchor empty —
    //      first unread paginated out): scroll to the OLDEST loaded
    //      message in the initial page, since that's the topmost
    //      currently-visible row of the unread window. The divider
    //      naturally sits above it.
    if (_initialUnreadCount > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Prefer the renderable-bubble target picked in initState
        // (skips system rows / hidden RTC frames). Falls through to
        // the divider anchor or the oldest-loaded message id when
        // no bubble qualified. Last resort: keep default
        // bottom-aligned position.
        final target = _autoScrollAnchorId.isNotEmpty
            ? _autoScrollAnchorId
            : (_firstUnreadAnchorId.isNotEmpty
                  ? _firstUnreadAnchorId
                  : _firstRenderableInitialMessageId());
        if (target.isNotEmpty) {
          unawaited(_scrollToMessage(target));
        }
      });
    }

    // 搜索结果跳转 — 对齐 iOS WKConversationVC.locationAtOrderSeq.
    // 进聊天后, 后帧尝试 _scrollToMessage(anchorMessageId). 消息已在
    // initialMessages 内即可命中. 不在的话当前 best-effort no-op (完整
    // "load chunk around seq" 需要 SDK getOrSyncHistoryMessages 改造,
    // 留 TODO).
    final searchAnchor = widget.initialAnchorMessageId;
    if (searchAnchor.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(_scrollToMessage(searchAnchor));
      });
    }
  }

  /// First initial-page message id whose row will actually render
  /// (skips hidden RTC frames + system rows that don't register
  /// `_messageBubbleKeys`). Used as a last-resort scroll target when
  /// neither anchor is set. Empty when nothing qualifies.
  String _firstRenderableInitialMessageId() {
    for (final m in widget.initialMessages) {
      if (m.messageId.isEmpty) continue;
      if (m.isHiddenRtcSignalingFrame) continue;
      if (m.isSystemMessage) continue;
      return m.messageId;
    }
    return '';
  }

  @override
  void dispose() {
    // 清当前 active channel — chat 页 pop 后, 收到该 channel 的 IM 消息
    // 应该弹本地通知 (用户不在看). 跟 initState 的 set 配对.
    final key =
        '${widget.conversation.channelId}|${widget.conversation.channelType}';
    if (activeChannelKey == key) {
      activeChannelKey = null;
    }
    widget.imGateway?.clearActiveChannel();
    // Persist the current composer text as a draft before tearing
    // the controller down — mirrors native iOS where the draft is
    // saved to `WKConversationContext.drafts` whenever the input
    // panel's view disappears. Fire-and-forget; the user is leaving
    // the screen so we don't gate on completion.
    unawaited(_persistDraft());
    // Stamp the session-watermark so the next chat-open can drop a
    // "以上为历史消息" divider above whatever arrives in the gap.
    unawaited(_persistSessionWatermark());
    unawaited(_messageSubscription?.cancel());
    unawaited(_aguiEventSubscription?.cancel());
    unawaited(_conversationSubscription?.cancel());
    unawaited(_channelClearedSub?.cancel());
    unawaited(_messageDeletedSub?.cancel());
    unawaited(_activeCallSubscription?.cancel());
    unawaited(_callEndSubscription?.cancel());
    unawaited(_typingStreamSub?.cancel());
    unawaited(_pinnedSyncSubscription?.cancel());
    unawaited(_groupMemberSyncSubscription?.cancel());
    _composerController.removeListener(_handleComposerChanged);
    _composerFocus.removeListener(_handleComposerFocusChanged);
    _composerFocus.dispose();
    _presencePollTimer?.cancel();
    _botRuntimePollTimer?.cancel();
    _messageScrollController.removeListener(_onMessageListScroll);
    _messageScrollController.dispose();
    _composerController.dispose();
    _highlightTimer?.cancel();
    for (final t in _flameTimers.values) {
      t.cancel();
    }
    for (final n in _uploadProgress.values) {
      n.dispose();
    }
    _uploadProgress.clear();
    _flameTimers.clear();
    if (VoicePlayer.instance.clearAutoAdvanceResolver(this)) {
      unawaited(VoicePlayer.instance.stop());
    }
    _screenCapture?.dispose();
    super.dispose();
  }

  /// Wire OS screenshot detection for the duration the chat is on screen.
  /// On a successful capture, broadcasts a contentType-20 system message
  /// so all peers see "{name}在聊天中截屏了" (matches native iOS).
  /// Debounced to 1.5 s so a screen recorder doesn't spam the channel.
  ///
  /// 验证状态 (2026-05-15): Android 真机 (SM-F731U1) 截屏触发 +
  /// 接收端渲染 "{name}在聊天中截屏了" 系统消息 ✓. iOS 模拟器永远测不
  /// 出 — UIApplicationUserDidTakeScreenshotNotification 不会 fire,
  /// simctl io screenshot 也不触发. 必须真机物理截屏 (Side+Volume Up).
  void _initScreenshotWatch() {
    try {
      final watcher = ScreenCaptureEvent();
      watcher.addScreenShotListener((_) => _onScreenshotDetected());
      watcher.watch();
      _screenCapture = watcher;
    } catch (_) {
      // Plugin init can fail on Android when storage permission is
      // denied — chat keeps working, just without screenshot
      // notification.
    }
  }

  void _onScreenshotDetected() {
    // Apply eligibility gates BEFORE consuming the 1.5s debounce window.
    // Native iOS WKSystemMessageHandler bails on these without occupying
    // the throttle, so a quick toggle from on→off→on doesn't spuriously
    // suppress the next eligible event.
    final gateway = widget.imGateway;
    if (gateway == null || !widget.conversation.isRemote) return;
    // Per-channel toggle gate (screenshot-broadcast-flow.md §6 P1):
    // skip broadcast when the channel's `notify_screenshot` flag is
    // off. Native defaults already applied by the snapshot mapper —
    // 1:1 off, group on. Without this gate the t=20 row would fire in
    // every chat, mismatching native iOS behaviour.
    //
    // Read from the local mirror (`_notifyScreenshot`) rather than
    // `widget.conversation.notifyScreenshot` so the toggle the user
    // just flipped in the settings page applies immediately on the
    // very next screenshot, without waiting for a fresh conversation
    // snapshot to arrive.
    if (!_notifyScreenshot) return;
    final now = DateTime.now();
    if (_lastScreenshotAt != null &&
        now.difference(_lastScreenshotAt!).inMilliseconds < 1500) {
      return;
    }
    _lastScreenshotAt = now;
    unawaited(
      gateway.sendScreenshotNotice(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        senderName: widget.loginName,
      ),
    );
  }

  /// Schedule a destruction timer for an ephemeral message — once
  /// `flameSecond` elapses we flip it to revoked locally and ask the
  /// server to erase it. Mirrors native iOS WKMessageCell.flameNode
  /// behaviour without the radial UI countdown (the bubble shows a
  /// flame badge with the seconds-left label instead).
  ///
  /// Voice messages get an extended TTL of
  /// `max(channel.flameSecond, voice.durationSeconds + 1)` so a
  /// flame channel with a short TTL doesn't destroy a voice message
  /// while the recipient is still listening to it. Mirrors native
  /// iOS `WKVoiceContent.flameSecond` override (flame-flow.md §6.8).
  void _maybeStartFlameTimer(ChatMessage message) {
    if (!_flameEnabled) return;
    if (message.messageId.isEmpty) return;
    if (message.revoked) return;
    if (_flameTimers.containsKey(message.messageId)) return;
    // Anchor the destroy on `message.timestamp + TTL` rather than
    // `now + TTL` so the badge's per-second countdown (block 5.6 —
    // also keyed off `message.timestamp`) and the destroy fire
    // agree to the same deadline. Without this alignment a message
    // from 30s ago with TTL 120s would show "90s" in the badge
    // while still living for the full 120s after a chat-reopen.
    // Optimistic local messages (timestamp == 0) fall back to the
    // legacy "TTL from now" behaviour so they don't insta-expire.
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final remainingMs = flameRemainingMsForTimer(
      flameEnabled: _flameEnabled,
      flameSecond: _flameSecond,
      message: message,
      nowMs: nowMs,
    );
    if (remainingMs <= 0) return;
    _flameTimers[message.messageId] = Timer(
      Duration(milliseconds: remainingMs),
      () => _expireFlameMessage(message.messageId),
    );
  }

  void _expireFlameMessage(String messageId) {
    if (!mounted) return;
    final index = _messages.indexWhere((m) => m.messageId == messageId);
    if (index < 0) {
      _flameTimers.remove(messageId);
      return;
    }
    final message = _messages[index];
    // 对齐 iOS WKMessageCell.m:505-507 + WKMessageManager.deleteMessages —
    // flame 倒计时结束是**直接删除**消息 (从列表移除, 无 trace), 不是当
    // 撤回处理 (revoke 会留"你撤回了一条消息"系统提示). 之前 Flutter
    // markRevoked 把销毁后的消息显示成"撤回"是 bug.
    setState(() => _messages.removeAt(index));
    _flameTimers.remove(messageId);
    // Server-side delete (best-effort, 跟 iOS deleteMessages 一致).
    final reference = _remoteReference(message);
    if (reference != null) {
      unawaited(widget.imGateway?.deleteMessages([reference]));
    }
  }

  /// ListView is `reverse:true` — large offset = scrolled toward older
  /// messages, offset 0 = visual bottom (latest). Two responsibilities here:
  ///   1. Within ~120 px of max → prefetch older history.
  ///   2. Drift away from the bottom past `_jumpToBottomThreshold` → show
  ///      the floating "回到底部" button; back near the bottom → hide it
  ///      and clear the new-message badge.
  void _onMessageListScroll() {
    if (!_messageScrollController.hasClients) return;
    final position = _messageScrollController.position;

    if (_hasMoreHistory &&
        !_isLoadingOlder &&
        position.maxScrollExtent - position.pixels < 120) {
      unawaited(_loadOlderMessages());
    }

    final shouldShow = position.pixels > _jumpToBottomThreshold;
    final shouldDismissIncomingMention =
        !shouldShow &&
        _pendingMentionFromIncoming &&
        _pendingMentionMessageId.isNotEmpty;
    if (shouldShow != _showJumpToBottom) {
      setState(() {
        _showJumpToBottom = shouldShow;
        if (!shouldShow) {
          _newMessagesBelow = 0;
          // Live-incoming mentions auto-clear on bottom-reached
          // because the user scrolling down means they read the
          // newly arrived message. Seeded-from-history mentions
          // (`_pendingMentionFromIncoming == false`) stay because
          // the target is far ABOVE the bottom — bottom doesn't
          // imply they were read.
          if (shouldDismissIncomingMention) {
            _pendingMentionMessageId = '';
            _pendingMentionFromIncoming = false;
          }
        }
      });
    } else if (!shouldShow &&
        (_newMessagesBelow != 0 || shouldDismissIncomingMention)) {
      setState(() {
        _newMessagesBelow = 0;
        if (shouldDismissIncomingMention) {
          _pendingMentionMessageId = '';
          _pendingMentionFromIncoming = false;
        }
      });
    }
  }

  void _scrollToLatestAndClear() {
    setState(() {
      _newMessagesBelow = 0;
      _showJumpToBottom = false;
      // Tapping the unread FAB also clears any pending mention hint
      // — mirrors native iOS where jumping to bottom drops both
      // floating buttons.
      _pendingMentionMessageId = '';
      _pendingMentionFromIncoming = false;
    });
    if (!_messageScrollController.hasClients) return;
    _messageScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  /// Tap handler for the `@-mention` scroll FAB. Scrolls the oldest
  /// unread mention into view and clears the pending state so the
  /// FAB hides. Falls through silently when the message has been
  /// paginated out — the FAB shouldn't have been visible in that
  /// case anyway.
  Future<void> _scrollToOldestMention() async {
    final t = AppLocalizations.of(context);
    final id = _pendingMentionMessageId;
    if (id.isEmpty) return;
    final ok = await _scrollToMessage(id);
    if (!mounted) return;
    if (ok) {
      // Only clear the hint after a successful scroll so a tap on
      // an off-mounted (paginated-out / not-laid-out) target keeps
      // the FAB visible — the user can re-tap once the message
      // becomes reachable (e.g. after history loads).
      setState(() {
        _pendingMentionMessageId = '';
        _pendingMentionFromIncoming = false;
      });
    } else {
      setState(() => _actionNotice = t.chatMentionLoadedOrInvisible);
    }
  }

  /// Tap handler for location bubbles. Opens the system map app via
  /// `url_launcher` (already a project dep). Platform-specific
  /// deep-link:
  ///   * iOS / fallback: `https://maps.apple.com/?ll=<lat>,<lng>&q=<title>`
  ///     — Apple Maps opens directly on iOS, every other platform
  ///     opens the URL in the default browser.
  ///   * Android: `geo:<lat>,<lng>?q=<lat>,<lng>(<title>)` resolves
  ///     to the user's installed map app via the Android intent.
  /// On launch failure (no installed map / sandbox restriction)
  /// falls back to clipboard-copy + notice so the address is at
  /// least recoverable.
  /// Tap handler for location bubbles — push app 内查看页 (`LocationViewPage`,
  /// 跟微信参考截图 3 一致). 不再调系统地图 (Apple Maps / Android geo:) —
  /// 旧实现 fallthrough 到 clipboard copy 作为兜底, 现在改成 app 内打开.
  /// 没有坐标时退回复制 (兜底, 罕见路径).
  Future<void> _openLocation(ChatMessage message) async {
    final t = AppLocalizations.of(context);
    final title = message.locationTitle;
    final address = message.locationAddress;
    final lat = message.locationLat;
    final lng = message.locationLng;
    final hasCoords = lat != 0 || lng != 0;
    if (hasCoords) {
      final route = widget.runtime?.registry.featureById(
        ModuleRouteIds.locationViewer,
      );
      final viewer =
          route != null && widget.runtime!.isModuleEnabled(route.moduleId)
          ? route.value
          : null;
      if (viewer is ModuleLocationViewer) {
        await viewer(
          context,
          ChatLocation(
            title: title.isEmpty ? t.chatLocationDefaultTitle : title,
            address: address,
            latitude: lat,
            longitude: lng,
          ),
        );
        return;
      }
    }
    // 没坐标: copy 兜底 (罕见路径 — 服务端协议保证 lat/lng 至少 0,0 而非 nil,
    // 这里防御性 fallthrough).
    final shareable =
        '${title.isEmpty ? t.chatLocationDefaultTitle : title}'
        '${address.isEmpty ? '' : '\n$address'}';
    await Clipboard.setData(ClipboardData(text: shareable));
    if (mounted) {
      setState(() => _actionNotice = t.chatLocationCopied);
    }
  }

  /// Surface a readers-summary bottom sheet for an own group
  /// message. Mirrors native iOS `WKReadedListVC` push trigger
  /// (read-receipt-flow.md §6 P1). Backend currently exposes
  /// only the aggregate `readed_count`/`unread_count` totals on
  /// `message_extra`, not the per-uid readers list — so the
  /// sheet renders the count split + a notice that the full
  /// readers roster will arrive when the server adds the endpoint.
  /// Acceptable v1 scaffold; the native VC's tab UI plugs in
  /// once the data is available.
  void _showReadedListSheet(ChatMessage message) {
    final t = AppLocalizations.of(context);
    final readedCount = message.readedCount;
    final unreadCount = message.unreadCount;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: MoyuColors.of(context).background,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 36,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: MoyuColors.of(context).line,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  t.chatReadStatusTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MoyuColors.of(context).textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ReadedSummaryCell(
                        title: t.chatReadStatusRead,
                        count: readedCount,
                        color: MoyuColors.of(context).blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ReadedSummaryCell(
                        title: t.chatReadStatusUnread,
                        count: unreadCount,
                        color: MoyuColors.of(context).textTertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Text(
                  t.chatReadStatusUnavailable,
                  style: TextStyle(
                    fontSize: 12,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  VoidCallback? _receiptTapFor(ChatMessage message, {required bool disabled}) {
    if (!_isGroupChat ||
        disabled ||
        message.messageId.isEmpty ||
        message.status != '已发送' ||
        message.readedCount + message.unreadCount <= 0) {
      return null;
    }
    return () => _showReadedListSheet(message);
  }

  Widget? _leadingStatusFor(ChatMessage message, {required bool disabled}) {
    if (!message.isMine) return null;
    if (message.status == '发送失败') {
      return SendFailIconButton(
        onTap: () => showSendFailActionSheet(
          context,
          onRetry: () => _retryMessage(message),
          onDelete: () => setState(() => _messages.remove(message)),
        ),
      );
    }
    if (message.status == '发送中') {
      return const SendingSpinner();
    }
    if (message.status == '已发送') {
      return SendReceiptIndicator(
        readed: message.readed,
        readedCount: message.readedCount,
        unreadCount: message.unreadCount,
        onTap: _receiptTapFor(message, disabled: disabled),
      );
    }
    return null;
  }

  /// Resolve the composer-lock banner text by priority. Empty
  /// string when the composer should remain interactive. Mirrors
  /// native iOS `WKConversationVC` lock-condition tree
  /// (composer-locked.md §6 P1):
  ///   1. memberRemoved (kicked / left) → `你已离开该聊天`
  ///   2. channel forbidden (全员禁言) → `当前聊天已禁言`
  ///   3. per-user time-bound mute → `你已被禁言至 HH:mm`
  ///      (countdown re-evaluated on the next tick from
  ///      `_muteCountdownTimer`)
  ///
  /// Future states (channelBlacklisted, e2ee handshake) plug in as
  /// new branches without changing the call site. `_localMemberRemoved`
  /// shadow flag (set by `_applySystemSideEffects` on incoming kick
  /// events) participates here so the UI flips before the
  /// conversation refresh lands.
  /// #2: 系统账号 composer 按钮态中间的"关于"可点击区域 — 不做成深色按钮块,
  /// 就是 composer 浅底上一行居中文字(textSecondary), 点了进关于页 (参考微信
  /// 公众号底部菜单的纯文字风格)。44 高跟输入框等高。
  Widget _aboutButton(AppLocalizations t) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => pushPage(context, const AboutPage()),
      child: SizedBox(
        height: 44,
        child: Center(
          child: Text(
            t.profileRowAbout(AppBrand.displayName),
            style: TextStyle(
              color: MoyuColors.of(context).textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  String _composerLockedText() {
    final t = AppLocalizations.of(context);
    if (_conversation.memberRemoved || _localMemberRemoved) {
      return t.chatComposerLeft;
    }
    // iOS WKConversationView.setGroupForbiddenIfNeed: creator + manager
    // bypass the forbid lock entirely — they can still speak when the
    // group is in 全员禁言 mode, and they're not subject to per-user
    // mute. `_isGroupAdmin` is loaded async from `loadGroupMembers`;
    // first render before it lands will lock then unlock, matching
    // iOS's same async resolution.
    if (_isGroupAdmin) {
      return '';
    }
    if (_conversation.forbidden) {
      return t.chatComposerMuted;
    }
    final until = _muteUntilSeconds;
    if (until > 0) {
      final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (until > nowSec) {
        final dt = DateTime.fromMillisecondsSinceEpoch(until * 1000);
        final hh = dt.hour.toString().padLeft(2, '0');
        final mm = dt.minute.toString().padLeft(2, '0');
        return t.chatComposerMutedUntil('$hh:$mm');
      }
    }
    return '';
  }

  /// Per-user mute expiry in unix seconds. 0 when not muted.
  /// Surfaced from `cmd:channelUpdate` payload; not yet wired to
  /// the gateway (P1 follow-up block) — getter exists so the lock
  /// resolver and countdown-tick code is in place for when the
  /// snapshot field lands.
  int get _muteUntilSeconds => 0;

  /// Resolve the history-split divider's index in `_messages`.
  /// Returns -1 (no divider) when:
  ///   * `_sessionWatermarkSeconds == 0` (first chat-open ever).
  ///   * All loaded messages predate the watermark (no boundary
  ///     above which "以上为历史消息" would make sense).
  ///   * All loaded messages are newer than the watermark (also
  ///     nothing to mark as history).
  /// Otherwise returns the index of the FIRST message whose
  /// timestamp >= watermark — the divider goes above that row.
  int _resolveHistorySplitIndex() {
    if (_sessionWatermarkSeconds <= 0 || _messages.isEmpty) return -1;
    final cutoff = _sessionWatermarkSeconds;
    // Only consider messages loaded on chat-open (initial page +
    // history paginated since). Messages appended live via
    // `_handleGatewayMessage` while the user is still on the screen
    // shouldn't push the divider forward — the divider marks the
    // boundary that EXISTED at open time. Same `_liveAppendsCount`
    // accounting as `_resolveUnreadDividerIndex`.
    final scanLimit = _messages.length - _liveAppendsCount;
    if (scanLimit <= 0) return -1;
    var hasOlder = false;
    var splitAt = -1;
    for (var i = 0; i < scanLimit; i++) {
      final ts = _messages[i].timestamp;
      if (ts <= 0) continue;
      // Strictly greater than the watermark so a message stamped
      // in the same second the user closed the chat (or arrived
      // just before close) doesn't get pushed below the divider —
      // the user has already seen it. Watermark is second-precision
      // so `==` is ambiguous; native iOS sidesteps this by using
      // server message_seq, which we don't have on the snapshot.
      if (ts <= cutoff) {
        hasOlder = true;
      } else if (splitAt < 0) {
        splitAt = i;
      }
    }
    if (!hasOlder || splitAt < 0) return -1;
    return splitAt;
  }

  /// Resolve the unread divider's current index in `_messages`.
  /// Two paths:
  ///   1. **Anchored** (`_firstUnreadAnchorId` set): the first
  ///      unread message was in the initial page; find it by id so
  ///      pagination keeps the divider glued to that exact row.
  ///   2. **Unanchored / overflow**: `initialUnread >=
  ///      initialMessages.length` on open — the loaded page is
  ///      entirely inside the unread window with older unread
  ///      messages still paginated out. Position the divider via
  ///      tail-count: `messages.length - _initialUnreadCount`
  ///      clamped to [0, length). As `_loadOlderMessages` brings
  ///      more rows in, the divider naturally moves up; once all
  ///      unread have loaded the math settles on the true boundary.
  ///      Returns -1 when no unread on open.
  int _resolveUnreadDividerIndex() {
    if (_firstUnreadAnchorId.isNotEmpty) {
      for (var i = 0; i < _messages.length; i++) {
        if (_messages[i].messageId == _firstUnreadAnchorId) return i;
      }
      return -1;
    }
    if (_initialUnreadCount <= 0 || _messages.isEmpty) return -1;
    // Compute against historical-only count (initial page +
    // history paginated since open) so live appends don't drift the
    // divider downward. Live arrivals are appended at the bottom
    // (newer = higher index) and shouldn't affect the unread
    // boundary, which is fixed at the open-time snapshot.
    final historical = _messages.length - _liveAppendsCount;
    if (historical <= 0) return -1;
    if (_initialUnreadCount >= historical) return 0;
    return historical - _initialUnreadCount;
  }

  /// Track a freshly-arrived peer mention while the user is away
  /// from the bottom. Sets `_pendingMentionMessageId` to the oldest
  /// such message so tapping the FAB scrolls there. Idempotent —
  /// later mentions don't overwrite the recorded oldest. Marks
  /// the source as `_pendingMentionFromIncoming` so the bottom-
  /// reached scroll callback dismisses the FAB once the user
  /// scrolls down to read.
  void _trackUnreadMention(ChatMessage message) {
    if (_pendingMentionMessageId.isNotEmpty) return;
    if (message.isMine) return;
    if (message.messageId.isEmpty) return;
    if (!message.mentionsLoginUser(widget.loginUid)) return;
    _pendingMentionMessageId = message.messageId;
    _pendingMentionFromIncoming = true;
  }

  Future<void> _loadOlderMessages() async {
    final gateway = widget.imGateway;
    if (gateway == null || _isLoadingOlder || !_hasMoreHistory) return;
    final oldestSeq = _oldestMessageSeq();
    if (oldestSeq <= 0) {
      // Either we have no remote-anchored message yet (purely local
      // optimistic) or the SDK hasn't assigned ids — bail; the next refresh
      // will surface ids and a future scroll attempt will succeed.
      return;
    }
    setState(() => _isLoadingOlder = true);
    try {
      final older = await gateway.loadMessages(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        beforeSeq: oldestSeq,
        limit: _historyPageSize,
      );
      if (!mounted) return;
      // Drop entries that already exist locally (matched by messageId).
      final existingIds = <String>{
        for (final m in _messages)
          if (m.messageId.isNotEmpty) m.messageId,
      };
      final fresh = <ChatMessage>[];
      for (final snapshot in older) {
        if (shouldSuppressEmptyInboundSnapshot(snapshot)) {
          continue;
        }
        if (snapshot.messageId.isNotEmpty &&
            existingIds.contains(snapshot.messageId)) {
          continue;
        }
        fresh.add(ChatMessage.fromSnapshot(snapshot));
      }
      setState(() {
        _isLoadingOlder = false;
        if (fresh.isEmpty) {
          _hasMoreHistory = false;
        } else {
          // SDK returns ascending; prepend so they sit above existing.
          //
          // Scroll preservation: this ListView is `reverse: true`
          // with children `_buildChatRows().reversed.toList()`.
          // Prepending to `_messages` puts new rows at the END of the
          // reversed children list, which is the visual TOP. Since
          // the offset origin (0) is the visual BOTTOM, the
          // currently visible rows keep their pixel distance from
          // offset 0 — Flutter's scrollable preserves the anchor
          // automatically. No manual `jumpTo` adjustment needed
          // (an earlier attempt to add `delta` actually moved the
          // viewport UP to the just-loaded top content).
          _messages.insertAll(0, fresh);
          if (older.length < _historyPageSize) {
            _hasMoreHistory = false;
          }
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingOlder = false);
    }
  }

  int _oldestMessageSeq() {
    var oldest = 0;
    for (final m in _messages) {
      if (m.messageSeq <= 0) continue;
      if (oldest == 0 || m.messageSeq < oldest) oldest = m.messageSeq;
    }
    return oldest;
  }

  /// 进 chat 后 fire-and-forget 拉远程最新消息. 拿到后 setState 替换
  /// `_messages` (跟微信进 chat 立刻 cached + 后台 sync 同模式).
  /// Replaces the old blocking await in _openChat — user 反馈"点击对话
  /// 很久才能进入" 即根因. 即使 remote 慢 / 失败, chat 已经 push 显示
  /// local cached, UI 不会卡.
  Future<void> _fetchRemoteMessagesOnOpen() async {
    final gateway = widget.imGateway;
    if (gateway == null || !widget.conversation.isRemote) return;
    try {
      final remote = await gateway.loadMessages(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
      );
      if (!mounted || remote.isEmpty) {
        return;
      }
      final fresh = remote
          .where((snapshot) => !shouldSuppressEmptyInboundSnapshot(snapshot))
          .map(ChatMessage.fromSnapshot)
          .toList();
      // 已收到新消息 (像 send / 实时推送进来)? merge 避免覆盖 in-flight.
      // 简化策略: 如果 remote 跟 _messages 长度 / 末尾 id 一致就跳过, 否则
      // 用 remote 替换 (旧版 await 路径就是直接替换).
      if (fresh.length == _messages.length &&
          fresh.isNotEmpty &&
          _messages.isNotEmpty &&
          fresh.last.messageId == _messages.last.messageId) {
        return;
      }
      final merged = _mergedWithLocal(fresh);
      setState(() {
        // 清掉 stale bubble GlobalKey — 否则 fresh 跟 cached 同 messageId
        // 时, `_bubbleKeyFor.putIfAbsent` 复用同一 GlobalKey, widget tree
        // 中新旧 element 短暂同框触发 framework `_elements.contains(element)`
        // assertion failed 红屏 (user 报). 清掉让 putIfAbsent 给新 message
        // 创建新 key, reply tap 跳转后续按需重建.
        _messageBubbleKeys.clear();
        // merge 而非整体覆盖 fresh: 保留你刚发、SDK 还没同步进来的本地消息
        // (见 _mergedWithLocal)。否则进对话瞬间 SDK 没同步全自己发的消息时,
        // 直接 _messages = fresh 会吞掉它们 + 打乱时间线, 等 stream 再 emit
        _messages = merged;
        _hasMoreHistory = fresh.length >= _historyPageSize;
      });
    } catch (_) {
      // 网络失败保留 cached, 不弹错误 — 跟旧版静默 fallback 一致.
    }
  }

  /// Tracks composer text from the previous tick so [_handleComposerChanged]
  /// can detect single-char deletions and atomically remove the surrounding
  /// `@xxx ` mention chip in one keypress (D9 — backspace deletes the
  /// whole token, not one Chinese codepoint at a time).
  String _prevComposerText = '';
  bool _atomicDeleting = false;

  /// FocusNode listener — focus 改变时 rebuild 让 TextField 的 minLines
  /// 跟着切换 (未 focus 1 行 / focus 2 行). 跟 Kimi 输入框同模式.
  void _handleComposerFocusChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _handleComposerChanged() {
    if (_atomicDeleting) return; // re-entrant guard during the rewrite below
    final newText = _composerController.text;
    if (newText.length == _prevComposerText.length - 1 &&
        _rewriteAtomicMentionDelete(newText, _prevComposerText)) {
      // _rewriteAtomicMentionDelete rewrote the controller; let the next
      // listener fire handle the rest of the bookkeeping uniformly.
      _prevComposerText = _composerController.text;
      return;
    }
    _prevComposerText = newText;
    final hasText = _composerController.text.trim().isNotEmpty;
    final shouldCancelEdit = !hasText && _editingMessage != null;
    if (hasText != _hasComposerText || shouldCancelEdit) {
      setState(() {
        _hasComposerText = hasText;
        if (shouldCancelEdit) _editingMessage = null;
      });
    }
    _syncMentionStateFromComposer();
    _syncPendingMentionPicks();
    if (hasText && !_isRestoringDraft) {
      // Only emit typing while the composer has actual content.
      // Erasing back to empty shouldn't keep the indicator alive on
      // the peer side — letting their 6s TTL run out matches native.
      // Draft restore also synthesizes a hasText==true edit; gating
      // on `!_isRestoringDraft` prevents the indicator from showing
      // when the user merely opens a chat with a saved draft.
      _emitTypingThrottled();
    }
  }

  /// Emits a typing notice with native-parity rules (typing-flow.md):
  /// - 4s throttle between emits.
  /// - Group-channel gate: only when server config
  ///   `app_config.typing_in_group` is true. The fork defaults this to
  ///   false to avoid keystroke fan-out in large rooms.
  /// - Skip when there's no IM gateway / the channel isn't remote.
  void _emitTypingThrottled() {
    final gateway = widget.imGateway;
    if (gateway == null || !widget.conversation.isRemote) return;
    if (widget.conversation.channelType == WKChannelType.group &&
        !widget.serverAppConfig.allowTypingInGroup) {
      return;
    }
    final now = DateTime.now();
    if (_lastTypingEmitAt != null &&
        now.difference(_lastTypingEmitAt!) < _typingThrottle) {
      return;
    }
    _lastTypingEmitAt = now;
    unawaited(
      gateway.sendTyping(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
      ),
    );
  }

  /// On a single-character deletion, check whether the deleted char was
  /// inside a previously-inserted `@xxx ` mention label. If so, rewrite
  /// the controller to drop the entire label in one go — matches native
  /// iOS / Android behavior where backspace eats the whole chip atomically.
  /// Returns true when an atomic delete fired (caller skips the normal
  /// per-char processing for this tick).
  bool _rewriteAtomicMentionDelete(String newText, String oldText) {
    final rewrite = atomicMentionDeleteRewrite(
      newText: newText,
      oldText: oldText,
      labels: [
        for (final pick in _pendingMentionPicks) pick.label,
        if (_pendingMentionAllLabel.isNotEmpty) _pendingMentionAllLabel,
      ],
    );
    if (rewrite == null) return false;
    _atomicDeleting = true;
    _composerController.value = TextEditingValue(
      text: rewrite.text,
      selection: TextSelection.collapsed(offset: rewrite.selectionOffset),
    );
    _atomicDeleting = false;
    return true;
  }

  /// Drop pending mention metadata whose `@<label>` is no longer in
  /// the composer text. Run on every composer-change so the user
  /// deleting an inserted chip immediately clears the corresponding
  /// uid — preventing a later manual re-type of the same label
  /// from resurrecting the original picker pick. Mirrors native iOS
  /// `WKConversationContext` chip-tracker which decouples picker
  /// state from typed text the moment the chip is removed.
  void _syncPendingMentionPicks() {
    final text = _composerController.text;
    if (_pendingMentionPicks.isEmpty && _pendingMentionAllLabel.isEmpty) {
      return;
    }
    final result = reconcileMentionPicks(
      text: text,
      picks: _pendingMentionPicks,
      mentionAllLabel: _pendingMentionAllLabel,
    );
    if (result.picks.length != _pendingMentionPicks.length) {
      _pendingMentionPicks
        ..clear()
        ..addAll(result.picks);
    }
    _pendingMentionAllLabel = result.mentionAllLabel;
    // No setState — fields don't drive any visible widget.
  }

  /// Detect the last unmatched `@<query>` segment ending at the caret and
  /// open the mention picker if so. Bails out for non-group chats.
  void _syncMentionStateFromComposer() {
    if (widget.conversation.channelType != WKChannelType.group) {
      if (_mentionQuery != null) {
        setState(() {
          _mentionQuery = null;
          _mentionAnchor = -1;
        });
      }
      return;
    }
    final text = _composerController.text;
    final selection = _composerController.selection;
    if (!selection.isValid || !selection.isCollapsed) {
      if (_mentionQuery != null) {
        setState(() {
          _mentionQuery = null;
          _mentionAnchor = -1;
        });
      }
      return;
    }
    final query = detectMentionQuery(text, selection.baseOffset);
    final nextQuery = query?.query;
    final nextAnchor = query?.anchor ?? -1;
    if (nextQuery == _mentionQuery && nextAnchor == _mentionAnchor) return;
    setState(() {
      _mentionQuery = nextQuery;
      _mentionAnchor = nextAnchor;
    });
  }

  Future<void> _loadGroupMembers() async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    try {
      final members = await gateway.loadGroupMembers(
        widget.conversation.channelId,
      );
      if (!mounted) return;
      setState(() => _groupMembers = members);
    } catch (_) {}
    // Refresh role-aware membership for the @-picker `@全体成员`
    // gate. `loadGroupMembers` returns a `ChatContact` shape with no
    // role info; `syncGroupMembers` returns `ChatGroupMember` with
    // role (1=owner, 2=manager, 0=plain member). Cache only the bool
    // we care about so the picker can show / hide the @全体成员 row.
    try {
      final detailed = await gateway.syncGroupMembers(
        groupNo: widget.conversation.channelId,
      );
      if (!mounted) return;
      var admin = false;
      for (final m in detailed) {
        if (m.uid == widget.loginUid && (m.role == 1 || m.role == 2)) {
          admin = true;
          break;
        }
      }
      if (admin != _isGroupAdmin) {
        setState(() => _isGroupAdmin = admin);
      }
    } catch (_) {
      // Best-effort. On error keep the previous flag (default false)
      // so non-admins keep the safe, restrictive view.
    }
  }

  /// 拉用户已添加的贴纸包 + 自定义贴纸列表. 进 chat 时一次, 商店/管理
  /// 页 pop 后通过 `_reloadStickerPanelData` 触发重拉, 实现 hot reload —
  /// 对齐 iOS WKStickerContentView.stickerUserCategoryLoadFinished
  /// 后 reloadTabPageView.
  Future<void> _loadStickerPanelData({bool force = false}) async {
    // #缓存: 已加载过且非强刷 → 直接用 static 会话缓存, 不重拉 (进对话页秒开,
    // 不再每次重新加载)。商店/管理页返回时 force=true 刷新。
    if (_stickerPanelLoaded && !force) {
      return;
    }
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    try {
      // 并行拉 — 包列表 + 自定义贴纸两个独立 endpoint
      final results = await Future.wait([
        gateway.loadStickerCategories(),
        gateway.loadCustomStickers(),
      ]);
      if (!mounted) return;
      setState(() {
        _userStickerPacks = results[0] as List<ChatStickerPack>;
        _customStickers = results[1] as List<ChatSticker>;
        // 旧的 per-pack 缓存可能 stale (用户删了包, 加了新的); 全清,
        // 让 panel 切到对应 tab 时 lazy load.
        _stickerPackStickers.clear();
        _stickerPanelLoaded = true;
      });
    } catch (_) {
      // 拉失败不阻塞聊天, panel 退化成只显 emoji.
    }
  }

  /// 商店/管理页 pop 后触发. 调用方: `_openStickerStore` 等 `pushPage`
  /// 加 `.then((_) => _reloadStickerPanelData())`.
  void _reloadStickerPanelData() {
    // 商店/管理页返回 → 强刷 (用户可能加/删了包)。
    unawaited(_loadStickerPanelData(force: true));
  }

  /// _EmojiPanel 切到某个用户包 tab 时调, lazy load 包内 stickers.
  /// 缓存在 `_stickerPackStickers[category]` 避免重复请求.
  Future<List<ChatSticker>> _loadStickersForPack(String category) async {
    final cached = _stickerPackStickers[category];
    if (cached != null) return cached;
    final gateway = widget.socialGateway;
    if (gateway == null) return const [];
    try {
      final detail = await gateway.loadStickerDetail(category);
      if (!mounted) return detail.stickers;
      setState(() => _stickerPackStickers[category] = detail.stickers);
      return detail.stickers;
    } catch (_) {
      return const [];
    }
  }

  /// Compose the tap-to-scroll callback for an inline reply quote. Returns
  /// null when the original message isn't currently in the local list (it
  /// might have been paginated out, never delivered, or just be a local
  /// optimistic placeholder without a server id).
  VoidCallback? _buildReplyTap(ChatMessage message) {
    final targetId = message.replyToMessageId;
    if (targetId.isEmpty) return null;
    final hasTarget = _messages.any((m) => m.messageId == targetId);
    if (!hasTarget) return null;
    return () => _scrollToMessage(targetId);
  }

  /// Pulse-highlight key for the current jump target. The target bubble
  /// renders a translucent yellow tint while this matches its key, then
  /// the timer clears it.
  String _highlightedKey = '';
  Timer? _highlightTimer;

  /// Scroll the message with `messageId` into view and pulse-flash
  /// it. Returns true when the scroll succeeds; false when the
  /// message has been paginated out of `_messages`. Two-phase
  /// approach to handle ListView's lazy-mounted children:
  ///   1. If the bubble's `GlobalKey` already has a
  ///      `currentContext` (mounted), call `ensureVisible` directly.
  ///   2. Otherwise approximate the scroll offset from the row's
  ///      index (reverse ListView: oldest = top, newest = bottom),
  ///      animate the controller there to force the row into the
  ///      build window, then re-check the context and complete with
  ///      `ensureVisible` for pixel-accurate positioning.
  Future<bool> _scrollToMessage(String messageId) async {
    final index = _messages.indexWhere((m) => m.messageId == messageId);
    if (index < 0) return false;
    if (_messageBubbleKeys[messageId]?.currentContext == null &&
        _messageScrollController.hasClients) {
      // Reverse list: 0 = bottom (newest). Scroll-up offset
      // increases with distance from the latest message. 70pt per
      // row is a rough average — works fine as a first approximation
      // because we follow it with `ensureVisible` for the precise
      // alignment once the target is mounted.
      const approxRowHeight = 70.0;
      final estimated = (_messages.length - 1 - index) * approxRowHeight;
      final maxExtent = _messageScrollController.position.maxScrollExtent;
      final target = estimated.clamp(0.0, maxExtent);
      await _messageScrollController.animateTo(
        target.toDouble(),
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
      // Wait one frame for layout to settle so the GlobalKey has a
      // mounted element.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    final targetContext = _messageBubbleKeys[messageId]?.currentContext;
    if (targetContext == null) return false;
    if (!targetContext.mounted) return false;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      alignment: 0.3,
    );
    _highlightTimer?.cancel();
    setState(() => _highlightedKey = messageId);
    _highlightTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _highlightedKey = '');
    });
    return true;
  }

  /// Per-message GlobalKeys for `Scrollable.ensureVisible`. Populated on
  /// row construction; entries are kept around since map churn is cheap.
  final Map<String, GlobalKey> _messageBubbleKeys = {};

  GlobalKey _bubbleKeyFor(ChatMessage message) {
    final id = message.messageId;
    if (id.isEmpty) return GlobalKey();
    return _messageBubbleKeys.putIfAbsent(id, () => GlobalKey());
  }

  String _selectionKey(ChatMessage message) {
    if (message.messageId.isNotEmpty) return 'm:${message.messageId}';
    if (message.clientMsgNo.isNotEmpty) return 'c:${message.clientMsgNo}';
    return '';
  }

  bool _isSelected(ChatMessage message) {
    final key = _selectionKey(message);
    return key.isNotEmpty && _selectedMessageKeys.contains(key);
  }

  bool _canMultiSelect(ChatMessage message) {
    return canMultiSelectMessage(
      revoked: message.revoked,
      isSystemMessage: message.isSystemMessage,
      selectionKey: _selectionKey(message),
    );
  }

  void _toggleSelection(ChatMessage message) {
    final key = _selectionKey(message);
    if (key.isEmpty) return;
    setState(() {
      if (!_selectedMessageKeys.add(key)) {
        _selectedMessageKeys.remove(key);
      }
    });
  }

  void _exitMultiSelect() {
    setState(() {
      _isMultiSelect = false;
      _selectedMessageKeys.clear();
    });
  }

  Future<void> _multiSelectDelete() async {
    if (_selectedMessageKeys.isEmpty) return;
    final targets = _messages.where(_isSelected).toList();
    setState(() {
      _messages.removeWhere((m) => targets.contains(m));
      _selectedMessageKeys.clear();
      _isMultiSelect = false;
    });
    for (final message in targets) {
      unawaited(_deleteRemoteMessage(message));
    }
  }

  /// 批量收藏 — 对齐 iOS WKMultiplePanel 收藏按钮. 当前 _favoriteMessage
  /// 是单条调用, 这里 for-loop 触发, 每条独立失败 / 成功. iOS 也是逐条
  /// post, 不是 batch endpoint.
  Future<void> _multiSelectFavorite() async {
    final t = AppLocalizations.of(context);
    if (!_isFavoriteModuleEnabled) {
      _showFavoriteModuleFallback();
      return;
    }
    if (_selectedMessageKeys.isEmpty) return;
    final targets = _messages.where(_isSelected).toList();
    if (targets.isEmpty) return;
    var success = 0;
    var failed = 0;
    for (final message in targets) {
      try {
        await _favoriteMessage(message);
        success++;
      } catch (_) {
        failed++;
      }
    }
    if (!mounted) return;
    setState(() {
      _isMultiSelect = false;
      _selectedMessageKeys.clear();
    });
    if (failed == 0) {
      MoyuToast.show(context, t.chatFavoriteCount(success));
    } else {
      MoyuToast.show(context, t.chatFavoritePartial(success, failed));
    }
  }

  Future<void> _multiSelectForward() async {
    final t = AppLocalizations.of(context);
    if (_selectedMessageKeys.isEmpty) return;
    final targets = _messages.where(_isSelected).toList();
    if (targets.isEmpty) return;
    final mode = await _showForwardModeSheet();
    if (!mounted || mode == null) return;
    final contact = await Navigator.of(context).push<UiContact>(
      MaterialPageRoute(
        builder: (_) => ContactCardPickerPage(
          contacts: widget.contacts,
          title: t.chatForwardPickerTitle,
          sectionTitle: t.chatRecentContactsSection,
        ),
      ),
    );
    if (!mounted || contact == null) return;
    final gateway = widget.imGateway;
    if (gateway == null) {
      setState(() => _actionNotice = t.chatForwardUnavailable);
      return;
    }

    // Resolve the target channel id ONCE so seed/local contacts whose
    // `uid` is empty still hit the right channel via the helper. Both
    // modes need to send through the same channel id.
    final targetChannelId = contactChannelId(contact);

    if (mode == ForwardMode.merge) {
      // 合并转发: build ONE WKMergeForwardContent (t=11) embedding every
      // selected message and send it once. Receiver sees a single
      // MergeForwardBubble. Mirrors WKMergeForwardContent.msgs:users.
      final content = WKMergeForwardContent()
        ..sourceChannelType = widget.conversation.channelType
        ..users = mergeForwardUsersForMessages(
          messages: targets,
          loginUid: widget.loginUid,
          loginName: widget.loginName,
          isPersonChannel:
              widget.conversation.channelType == WKChannelType.personal,
          peerUid: widget.conversation.channelId,
          peerName: widget.conversation.name,
        )
        ..msgs = targets
            .map(
              (message) => chatMessageToMergeForwardEntry(
                message: message,
                sourceChannelType: widget.conversation.channelType,
                loginUid: widget.loginUid,
                loginName: widget.loginName,
                isPersonChannel:
                    widget.conversation.channelType == WKChannelType.personal,
                peerUid: widget.conversation.channelId,
                peerName: widget.conversation.name,
                groupMembers: _groupMembers,
                l10n: AppLocalizations.of(context),
              ),
            )
            .toList(growable: false);
      try {
        await gateway.sendMergeForward(
          channelId: targetChannelId,
          channelType: WKChannelType.personal,
          content: content,
        );
        if (!mounted) return;
        setState(() {
          _isMultiSelect = false;
          _selectedMessageKeys.clear();
          _actionNotice = t.chatMergedForwardedTo(targets.length, contact.name);
        });
      } catch (error) {
        if (mounted) {
          setState(() => _actionNotice = error.toString());
        }
      }
      return;
    }

    // 逐条转发: per-message dispatch using the same per-type clone as the
    // single-message _forwardMessage path. Best-effort: failure on one
    // message doesn't abort the rest.
    var failures = 0;
    for (final m in targets) {
      try {
        await _forwardSingle(
          message: m,
          targetChannelId: targetChannelId,
          targetChannelType: WKChannelType.personal,
        );
      } catch (_) {
        failures += 1;
      }
    }
    if (!mounted) return;
    setState(() {
      _isMultiSelect = false;
      _selectedMessageKeys.clear();
      _actionNotice = failures == 0
          ? t.chatForwardedIndividuallyTo(targets.length, contact.name)
          : t.chatForwardedPartialTo(
              targets.length - failures,
              targets.length,
              contact.name,
            );
    });
  }

  Future<ForwardMode?> _showForwardModeSheet() async {
    final t = AppLocalizations.of(context);
    return MoyuActionSheet.showChoice<ForwardMode>(
      context,
      items: [
        MoyuActionSheetChoiceItem<ForwardMode>(
          title: t.chatForwardModeIndividual,
          value: ForwardMode.individual,
        ),
        MoyuActionSheetChoiceItem<ForwardMode>(
          title: t.chatForwardModeMerge,
          value: ForwardMode.merge,
        ),
      ],
    );
  }

  /// Splice "`@<displayName>` " over the partial @query at the anchor and
  /// move the caret past the inserted span. Closes the picker. Also
  /// records the pick into `_pendingMentionUids` /
  /// `_pendingMentionAll` so `_sendText` can fire the right
  /// `mentionAll = true` / `mentionUids = [...]` payload at send.
  void _selectMention(ChatContact member) {
    if (_mentionAnchor < 0) return;
    final text = _composerController.text;
    final selection = _composerController.selection;
    final caret = selection.isValid && selection.isCollapsed
        ? selection.baseOffset
        : text.length;
    if (_mentionAnchor > caret || _mentionAnchor >= text.length) return;
    final insert = '@${member.name} ';
    final next = text.replaceRange(_mentionAnchor, caret, insert);
    final cursor = _mentionAnchor + insert.length;
    _composerController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: cursor),
    );
    setState(() {
      _mentionQuery = null;
      _mentionAnchor = -1;
      // Record the pick alongside the inserted display label so
      // `_sendText` can drop the metadata if the user deletes the
      // visible chip before sending. uid `all` is the wire-level
      // sentinel for `mention.all = 1` — flag it separately and
      // don't bleed it into the regular uids list.
      if (member.uid == 'all') {
        _pendingMentionAllLabel = member.name;
      } else if (member.uid.isNotEmpty) {
        // Append in pick order. Duplicate display names are kept as
        // separate entries so partial-delete reconciliation can
        // count occurrences vs picks at send time.
        _pendingMentionPicks.add((uid: member.uid, label: member.name));
      }
    });
  }

  void _startPresencePolling() {
    if (widget.conversation.channelType != WKChannelType.personal) return;
    final gateway = widget.imGateway;
    if (gateway == null) return;
    unawaited(_pollPeerPresence());
    _presencePollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_pollPeerPresence());
    });
  }

  Future<void> _pollPeerPresence() async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    try {
      final map = await gateway.queryUserPresence([
        widget.conversation.channelId,
      ]);
      if (!mounted) return;
      setState(() => _peerPresence = map[widget.conversation.channelId]);
    } catch (_) {
      // network errors are non-fatal — keep prior state.
    }
  }

  void _startBotRuntimePolling() {
    if (widget.conversation.channelType != WKChannelType.personal) return;
    if (_botRuntimePollTimer != null) return;
    unawaited(_pollPeerBotRuntime());
    _botRuntimePollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      unawaited(_pollPeerBotRuntime());
    });
  }

  Future<void> _pollPeerBotRuntime() async {
    if (!_peerIsBot()) return;
    final gw = widget.socialGateway;
    if (gw == null) return;
    try {
      final statuses = await gw.botRuntimeStatuses();
      if (!mounted) return;
      final next =
          statuses[widget.conversation.channelId] ??
          BotRuntimeStatus.offline(widget.conversation.channelId);
      setState(() => _peerBotRuntime = next);
    } catch (_) {
      // Bot runtime is optional on older prod servers; keep prior state.
    }
  }

  /// Listen for typing-events from the IM gateway and surface the
  /// render-ready label for this channel in the header subtitle.
  /// Empty string clears the indicator. Mirrors native iOS
  /// `WKConversationChannelHeader` which swaps the subtitle to the
  /// typing label while the event is active.
  void _onTypingSnapshot(Map<String, String> snapshot) {
    final key =
        '${widget.conversation.channelType}_${widget.conversation.channelId}';
    final next = snapshot[key] ?? '';
    if (next == _typingLabel) return;
    setState(() => _typingLabel = next);
  }

  /// #6: 从内置 manifest (assets/emoji_stickers/manifest.json) 加载 emoji 大表情
  /// 映射表 (一次, static, 全 app 共享)。秒就绪、离线、不依赖网络 —— 彻底解决
  /// "网络挂→映射空→不转"。理论不失败 (bundled asset); 万一失败放开重试标志。
  Future<void> _loadEmojiStickers() async {
    if (_emojiStickersLoaded) return;
    _emojiStickersLoaded = true;
    try {
      final raw = await rootBundle.loadString(
        'assets/emoji_stickers/manifest.json',
      );
      final list = jsonDecode(raw);
      if (list is List) {
        for (final e in list) {
          if (e is! Map) continue;
          final word = (e['word'] ?? '').toString().trim();
          if (word.isEmpty) continue;
          _emojiStickerMap[word] = ChatSticker(
            path: (e['path'] ?? '').toString(),
            placeholder: (e['placeholder'] ?? '').toString(),
            category: 'emoji',
            format: 'lim',
            searchableWord: word,
            width: e['width'] is num ? (e['width'] as num).toInt() : 0,
            height: e['height'] is num ? (e['height'] as num).toInt() : 0,
          );
        }
      }
    } catch (_) {
      _emojiStickersLoaded = false; // 放开下次重试
    }
  }

  String _chatTitleText(ChatConversation conversation) {
    if (conversation.channelType != WKChannelType.group) {
      // #10: 系统账号/文件助手按 ID 映射本地化名, 否则用会话名。
      return specialAccountDisplayName(
            AppLocalizations.of(context),
            conversation.channelId,
          ) ??
          conversation.name;
    }
    final count = _chatGroupMemberCount(conversation);
    final currentName = _groupRemarkTitle.trim().isNotEmpty
        ? _groupRemarkTitle.trim()
        : conversation.name;
    if (count <= 0) return currentName;
    final name = _stripGroupCountSuffix(currentName);
    return '$name($count)';
  }

  int _chatGroupMemberCount(ChatConversation conversation) {
    // 1. server 权威值 (loadGroupInfo, 跟群资料页同源) — 最优先。
    if (_groupServerMemberCount > 0) {
      return _groupServerMemberCount;
    }
    // 2. 会话列表带来的 server 快照 (首帧、loadGroupInfo 未回来前)。
    for (final group in widget.groups) {
      if (group.groupNo == conversation.channelId && group.memberCount > 0) {
        return group.memberCount;
      }
    }
    // 3. conversation 自带 (真实会话恒 0, 仅 seed/特殊路径有值)。
    if (conversation.memberCount > 0) {
      return conversation.memberCount;
    }
    // 4. 拿不到就不显示 "(N)" (_chatTitleText 对 count<=0 返回纯群名),
    //    不再用群名 regex / 默认 2 编造一个偏少的数字 (§4.9.8 精神)。
    return 0;
  }

  String _stripGroupCountSuffix(String name) {
    return name
        .replaceFirst(RegExp(r'\s*[\(（]\s*\d+\s*[\)）]$'), '')
        .replaceFirst(RegExp(r'\s*·\s*\d+$'), '')
        .trim();
  }

  String _groupOriginalNameSubtitle() {
    if (_conversation.channelType != WKChannelType.group) return '';
    if (_groupRemarkTitle.trim().isEmpty) return '';
    final currentTitle = _stripGroupCountSuffix(
      _groupRemarkTitle.trim().isNotEmpty
          ? _groupRemarkTitle.trim()
          : _conversation.name,
    );
    final knownOriginal = _stripGroupCountSuffix(_groupOriginalName);
    if (knownOriginal.isNotEmpty && knownOriginal != currentTitle) {
      return knownOriginal;
    }
    for (final group in widget.groups) {
      if (group.groupNo != _conversation.channelId) continue;
      final original = _stripGroupCountSuffix(group.name);
      if (original.isNotEmpty && original != currentTitle) {
        return original;
      }
    }
    return '';
  }

  String _groupRemarkKey() =>
      'group_remark::${widget.loginUid}::${widget.conversation.channelId}';

  String _initialGroupOriginalName() {
    for (final group in widget.groups) {
      if (group.groupNo == widget.conversation.channelId) {
        return _stripGroupCountSuffix(group.name);
      }
    }
    return _stripGroupCountSuffix(widget.conversation.name);
  }

  Future<void> _loadGroupTitleMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRemark = prefs.getString(_groupRemarkKey()) ?? '';
      if (storedRemark.isNotEmpty && mounted) {
        setState(() => _groupRemarkTitle = storedRemark);
      }
    } catch (_) {
      // Local remark fallback is best-effort.
    }

    final gateway = widget.socialGateway;
    final groupNo = widget.conversation.channelId;
    if (gateway == null || groupNo.isEmpty) return;
    try {
      final group = await gateway.loadGroupInfo(groupNo);
      if (!mounted || group == null) return;
      final name = _stripGroupCountSuffix(group.name);
      if (name.isNotEmpty && name != _groupOriginalName) {
        setState(() => _groupOriginalName = name);
      }
      // 捕获 server 权威人数, 让标题 "(N)" 跟群资料页一致 (修 #11: 之前丢弃
      // 这个值, 标题掉进 widget.groups 过期快照 / 群名 regex 兜底显示偏少)。
      if (group.memberCount > 0 &&
          group.memberCount != _groupServerMemberCount) {
        setState(() => _groupServerMemberCount = group.memberCount);
      }
    } catch (_) {
      // Keep snapshot / local fallback.
    }
  }

  String _navSubtitle() {
    final t = AppLocalizations.of(context);
    // Typing wins over presence — matches native iOS where the header
    // subtitle flips to the typing label for the typing window before
    // restoring the online/last-seen string. The gateway's typing
    // stream already supplies a full label (e.g. `对方正在输入...`
    // or `Alice 正在输入...`), so we render it as-is to avoid
    // double-suffixing in group chats.
    if (_typingLabel.isNotEmpty) {
      return _typingLabel;
    }
    if (widget.conversation.channelType == WKChannelType.group) {
      return _groupOriginalNameSubtitle();
    }
    if (_peerIsBot()) {
      return _peerBotAvailable() ? t.chatPresenceOnline : t.chatPresenceOffline;
    }
    final presence = _peerPresence;
    if (presence == null) {
      return widget.conversation.online ? t.chatPresenceOnline : '';
    }
    if (presence.online) return t.chatPresenceOnline;
    if (presence.lastOffline <= 0) return t.chatPresenceOffline;
    final last = DateTime.fromMillisecondsSinceEpoch(
      presence.lastOffline * 1000,
    );
    final diff = DateTime.now().difference(last);
    if (diff.inMinutes < 1) return t.chatPresenceJustActive;
    if (diff.inMinutes < 60) return t.chatPresenceMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return t.chatPresenceHoursAgo(diff.inHours);
    if (diff.inDays < 7) return t.chatPresenceDaysAgo(diff.inDays);
    return t.chatPresenceOffline;
  }

  bool _headerOnlineDotVisible() {
    if (widget.conversation.channelType != WKChannelType.personal) return false;
    if (_peerIsBot()) return _peerBotAvailable();
    return _peerPresence?.online ?? widget.conversation.online;
  }

  Future<void> _loadChatBackground() async {
    final preferences = await SharedPreferences.getInstance();
    final channelScope = chatBackgroundChannelScope(
      widget.conversation.channelType,
      widget.conversation.channelId,
    );
    final channelUrl = preferences.getString(
      chatBackgroundUrlKey(widget.loginUid, channelScope),
    );
    final scope = channelUrl == null ? '' : channelScope;
    final url =
        channelUrl ??
        preferences.getString(chatBackgroundUrlKey(widget.loginUid)) ??
        '';
    final background = ChatBackground(
      url: url,
      isSvg:
          preferences.getBool(chatBackgroundIsSvgKey(widget.loginUid, scope)) ??
          false,
      lightColors:
          preferences.getStringList(
            chatBackgroundLightColorsKey(widget.loginUid, scope),
          ) ??
          const [],
      darkColors:
          preferences.getStringList(
            chatBackgroundDarkColorsKey(widget.loginUid, scope),
          ) ??
          const [],
    );
    if (!mounted) {
      return;
    }
    setState(() => _chatBackground = background);
  }

  Future<void> _loadPinnedMessages() async {
    final gateway = widget.imGateway;
    if (gateway == null) {
      debugPrint('[pinned] _loadPinnedMessages: gateway null, skip');
      return;
    }
    if (!widget.conversation.isRemote) {
      debugPrint('[pinned] _loadPinnedMessages: isRemote=false, skip');
      return;
    }
    try {
      final pinnedMessages = await gateway.syncPinnedMessages(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
      );
      debugPrint(
        '[pinned] _loadPinnedMessages got ${pinnedMessages.length} item(s) '
        'firstText="${pinnedMessages.isEmpty ? '' : pinnedMessages.first.text}"',
      );
      if (!mounted) return;
      setState(() => _pinnedMessages = pinnedMessages);
    } catch (e) {
      debugPrint('[pinned] _loadPinnedMessages FAILED: $e');
    }
  }

  /// Warm the sensitive-words cache so received text bubbles can show
  /// the inline 可能涉及敏感信息 row. Idempotent — the gateway
  /// dedup-coalesces concurrent calls and uses the cached version
  /// number to short-circuit unchanged server responses.
  /// SharedPreferences key for the persisted composer draft. Scoped by
  /// (loginUid, channelType, channelId) so different users on the
  /// same device and different chats don't bleed into each other.
  String get _draftKey =>
      'chat.draft.${widget.loginUid}.'
      '${widget.conversation.channelType}.${widget.conversation.channelId}';

  /// Restore a persisted composer draft on chat-screen open. No-op
  /// when nothing has been saved (or when reading prefs fails).
  /// Mirrors native iOS `WKConversationContext.drafts[channelKey]`
  /// restore inside `WKConversationInputPanel.viewDidLoad`.
  Future<void> _restoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_draftKey) ?? '';
      if (saved.isEmpty || !mounted) return;
      // Only restore when the user hasn't already started typing
      // (avoids racing the user's first keystroke).
      if (_composerController.text.isNotEmpty) return;
      _isRestoringDraft = true;
      try {
        _composerController.value = TextEditingValue(
          text: saved,
          selection: TextSelection.collapsed(offset: saved.length),
        );
      } finally {
        _isRestoringDraft = false;
      }
    } catch (_) {
      // Reading prefs is best-effort; drafts are convenience only.
    }
  }

  /// Persist the current composer text as a draft. Called from
  /// `dispose` so leaving the chat captures whatever the user typed.
  /// Empty text wipes the slot so a no-op exit doesn't leave a stale
  /// draft hanging around. Mirrors native iOS save-on-disappear.
  ///
  /// 同时调 server `conversations/<id>/<ct>/extra` PUT 把 draft 同步到
  /// server, 让会话列表预览显示 `[草稿] xxx` 橙色前缀 + 多端共享草稿.
  /// 之前只本地 prefs 保存 → 列表 conversation.draft 字段一直空 (因为
  /// snapshot 从 SDK getRemoteMsgExtra 拿) → [草稿] 前缀永远不显示.
  Future<void> _persistDraft() async {
    final text = _composerController.text;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (text.isEmpty) {
        await prefs.remove(_draftKey);
      } else {
        await prefs.setString(_draftKey, text);
      }
    } catch (_) {
      // Best-effort; nothing the user can do about it.
    }
    final gateway = widget.imGateway;
    if (gateway == null || !widget.conversation.isRemote) return;
    try {
      await gateway.updateConversationExtra(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        draft: text,
      );
    } catch (_) {
      // server 写失败不阻塞 — 本地 prefs 已保存, 恢复输入框还能 work.
    }
  }

  /// Unix-second timestamp of the last time this chat was closed
  /// on this device. Drives the "以上为历史消息" history-split row
  /// — when the loaded message list straddles this watermark, a
  /// divider is rendered between the older + newer halves so the
  /// user can see at a glance which messages arrived since they
  /// last looked. Mirrors native iOS `WKHistorySplitTipCell`
  /// (history-split.md §6).
  ///
  /// Zero when no prior session was recorded (first-ever open) —
  /// the divider is suppressed in that case.
  int _sessionWatermarkSeconds = 0;

  /// SharedPreferences key for the session watermark, scoped per
  /// (loginUid, channelType, channelId).
  String get _sessionWatermarkKey =>
      'chat.sessionWatermark.${widget.loginUid}.'
      '${widget.conversation.channelType}.${widget.conversation.channelId}';

  Future<void> _loadSessionWatermark() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getInt(_sessionWatermarkKey) ?? 0;
      if (saved > 0 && mounted) {
        setState(() => _sessionWatermarkSeconds = saved);
      }
    } catch (_) {
      // Best-effort; the divider is a polish feature.
    }
  }

  Future<void> _persistSessionWatermark() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setInt(_sessionWatermarkKey, now);
    } catch (_) {
      // Best-effort.
    }
  }

  Future<void> _warmSensitiveWords() async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    await gateway.warmSensitiveWords();
    if (!mounted) return;
    // Trigger a rebuild so freshly-received messages pick up the new
    // word list. The cache itself lives on the gateway; we just need
    // to re-run `_isSensitiveText` against the current bubbles.
    setState(() {});
  }

  /// Returns true when the given text body contains any cached
  /// sensitive word. Mirrors native iOS `WKSecurityTipManager match:`
  /// (substring contains, case-sensitive). Cheap O(n*w) scan — no
  /// pre-compiled regex because the word list updates often and most
  /// chats have a small list.
  bool _isSensitiveText(String text) {
    if (text.isEmpty) return false;
    final words = widget.imGateway?.cachedSensitiveWords.list ?? const [];
    if (words.isEmpty) return false;
    for (final word in words) {
      if (word.isEmpty) continue;
      if (text.contains(word)) return true;
    }
    return false;
  }

  /// Per-arrival side-effect dispatcher for system messages. Caller
  /// must already be inside `setState` so flag flips trigger a
  /// rebuild without an extra pass. Mirrors native iOS
  /// `WKSystemMessageHandler` which routes group events to roster /
  /// composer / banner state changes.
  ///
  /// Currently handles:
  ///   * 1003 (被移出群聊) — when one of the named users matches
  ///     `widget.loginUid`, flip `_localMemberRemoved` so the
  ///     composer is replaced by a `你已离开该聊天` banner.
  ///   * 1020 (已被移出群聊) — already keyed to the current user by
  ///     the server; flip unconditionally.
  ///   * 1021 (退出了群聊) — covers the case where the user left
  ///     the group on another device and this session is just
  ///     observing the broadcast.
  void _applySystemSideEffects(ChatMessage message) {
    if (!message.isSystemMessage) return;
    final type = message.contentType;
    if (type == 1020) {
      _localMemberRemoved = true;
      return;
    }
    if (type != 1003 && type != 1021) return;
    final selfUid = widget.loginUid;
    if (selfUid.isEmpty) return;
    final users = _affectedUsers(message);
    if (users == null) return;
    for (final entry in users) {
      final uid = _systemUserUid(entry);
      if (uid != null && uid == selfUid) {
        _localMemberRemoved = true;
        return;
      }
    }
  }

  /// Resolve the affected-users list for a system message across the
  /// shapes the server actually emits:
  ///   * `data.extra` as a list of `{uid, name}` objects (Go server's
  ///     1003/1021 group events — see `SendGroupExit` /
  ///     `SendGroupKick` in `TangSengDaoDaoServer/common/msg.go`).
  ///   * `data.extra.users` as a list (older payload shape kept for
  ///     compatibility).
  ///   * `data.users` as a top-level list (group-approve invites and
  ///     legacy hotline events).
  /// Returns null when none match — caller treats that as "no
  /// affected users named in this payload".
  List? _affectedUsers(ChatMessage message) {
    final extra = message.data['extra'];
    if (extra is List) return extra;
    if (extra is Map) {
      final nested = extra['users'];
      if (nested is List) return nested;
    }
    final top = message.data['users'];
    if (top is List) return top;
    return null;
  }

  /// Extract a uid from one entry in a system-message users list,
  /// handling both the `{uid, name}` map shape and bare-string uids.
  String? _systemUserUid(dynamic entry) {
    if (entry is Map) {
      final raw = entry['uid'] ?? entry['user_id'] ?? entry['id'];
      if (raw != null) return raw.toString();
    } else if (entry != null) {
      return entry.toString();
    }
    return null;
  }

  /// Walk the visible message list and flip `replyToRevoked` on every
  /// other bubble whose inline quote points at the just-revoked
  /// message. Lets the UI swap the cached preview to `原消息已撤回`
  /// the moment the user taps revoke, without waiting for the
  /// server's revoke-cmd round-trip. Caller must already hold the
  /// `setState` mutation lock — this only mutates `_messages` in
  /// place. No-op when the revoked message has no messageId yet
  /// (locally optimistic, no remote referrers possible).
  void _flipDependentReplies(ChatMessage revokedMessage) {
    final targetId = revokedMessage.messageId;
    if (targetId.isEmpty) return;
    for (var i = 0; i < _messages.length; i++) {
      final m = _messages[i];
      if (m.replyToMessageId != targetId) continue;
      if (m.replyToRevoked) continue;
      _messages[i] = m.markReplyRevoked();
    }
  }

  /// Tip string shown under a sensitive-word bubble. Server-provided
  /// (`message/sync/sensitivewords` returns a `tips` field); falls
  /// back to the native iOS default copy when unset so the row stays
  /// useful even before the first sync lands.
  String get _sensitiveTipText {
    final tips = widget.imGateway?.cachedSensitiveWords.tips ?? '';
    return tips.isEmpty
        ? AppLocalizations.of(context).chatSensitiveDefaultTip
        : tips;
  }

  Decoration _chatBackgroundDecoration() {
    final colors = _chatBackground.lightColors
        .map(parseHexColor)
        .whereType<Color>()
        .toList();
    if (_chatBackground.url.isEmpty) {
      // 默认 / 未选背景: 纯色 (跟随主题 light/dark backgroundSoft)。
      return BoxDecoration(color: MoyuColors.of(context).backgroundSoft);
    }
    if (_chatBackground.isSvg && colors.length >= 2) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      );
    }
    // 真图 (is_svg=0): 走 CachedNetworkImageProvider 吃 disk cache (spec §9.5.5,
    // 不用 NetworkImage 否则无磁盘缓存每次重拉)。OSS 缺图时显 backgroundSoft 底色
    // (对齐 iOS 真图加载失败的空白行为), OSS 补图后自动显示。
    return BoxDecoration(
      color: MoyuColors.of(context).backgroundSoft,
      image: DecorationImage(
        image: CachedNetworkImageProvider(
          widget.config.showUrl(_chatBackground.url),
        ),
        fit: BoxFit.cover,
        onError: (_, _) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // Use the live mirror, not `widget.conversation` (immutable from
    // a single push). `_handleConversationSnapshots` keeps this in
    // sync with the IM gateway so renames / avatar uploads update
    // the chat header without re-pushing the screen.
    final conversation = _conversation;
    final hasCustomBackground = _chatBackground.url.isNotEmpty;

    // Surface transient action notices (`_actionNotice`) as a floating
    // overlay toast instead of an inline strip above the composer.
    // Inline rendering pushed the input bar up every time a notice
    // fired ("已复制" / "已收藏" / etc), causing the composer to jump.
    // Schedule the toast post-frame so we can safely call
    // `setState(_actionNotice = null)` without mutating during build.
    if (_actionNotice != null) {
      final pending = _actionNotice!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        MoyuToast.show(context, pending);
        if (_actionNotice == pending) {
          setState(() => _actionNotice = null);
        }
      });
    }

    // Chat 详情页**消息气泡**字号 base 升一档 — 用户反馈"标准档气泡正文
    // 偏小, 应该是当前大档视觉". 实施: 只在消息 ListView 外面包一层
    // MediaQuery × 1.14, 让气泡正文 / 时间戳 / quote 等自动放大.
    //
    // ⚠ 不能包在最外层 — 之前 wrap 在 build 顶部, 把顶 nav title /
    // 输入栏 / emoji 面板 / + 加号工具面板字号也一起放大了, 用户反馈
    // "面板字号跟聊天字体一起放大了". UI chrome 跟用户内容是两套字号
    // 体系, 不该共享.
    //
    // 不影响其他 tab (会话列表 / 通讯录 / 设置 / 朋友圈) — 它们走 root
    // textScaler 不变.
    //
    // 用户档位实际气泡 scale:
    //   small (0.88) → 1.003 ≈ 当前标准视觉 (可降回)
    //   standard (1.0) → 1.14 = 当前大档视觉 (默认体验提升)
    //   large (1.12) → 1.28 = 更大
    //   extra_large (1.24) → 1.41 = 最大
    final fontKey = FontScaleController.of(context).current;
    final chatScale = FontScaleStore.scaleFor(fontKey) * 1.14;

    return Semantics(
      identifier: 'moyu.chat.screen',
      container: true,
      child: FScaffold(
        childPad: false,
        child: ColoredBox(
          color: MoyuColors.of(context).backgroundSoft,
          child: SafeArea(
            child: DecoratedBox(
              key: hasCustomBackground
                  ? ValueKey('moyu.chat.background.custom')
                  : null,
              decoration: _chatBackgroundDecoration(),
              child: Column(
                children: [
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: MoyuColors.of(context).backgroundSoft,
                      border: Border(
                        // nav 与聊天背景的分隔线 — 0.5 在高分屏几乎看不见,
                        // 加到 1 让它明显一点。
                        bottom: BorderSide(
                          color: MoyuColors.of(context).line,
                          width: 1,
                        ),
                      ),
                    ),
                    // Stack 把 title 放在屏幕水平中心 (Center), 左右按钮独立
                    // 一层 Row 走 Spacer 分隔. 之前 Row + Expanded 把 title 撑在
                    // 左右按钮中间, 因为左 (back + unread + 8pt) 跟右 (more) 数学
                    // 上不对称, name 偏左; 改 Stack 后 name 永远屏幕水平居中,
                    // 跟微信单聊 nav 对齐.
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 居中 title — horizontal 80pt 留给左右按钮空间, 长 name
                        // 通过 Flexible + ellipsis 自动收缩.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_headerOnlineDotVisible()) ...[
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: MoyuColors.of(context).green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                  ],
                                  Flexible(
                                    child: Text(
                                      _chatTitleText(conversation),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.16,
                                        color: MoyuColors.of(
                                          context,
                                        ).textPrimary,
                                      ),
                                    ),
                                  ),
                                  // 官方账号 verified badge (chatim 独有, iOS 原版
                                  // WKConversationChannelHeader.m:135-154 只覆盖
                                  // 标题文案不加 badge). 跟会话列表 / 通讯录同款.
                                  // #1: server category 优先; 系统账号/文件助手
                                  // 按 ID 兜底 'system' (聊天页 conversation 常没带
                                  // channelCategory, 跟 #10 名映射同思路保证星标显示)。
                                  if (conversation.channelCategory.isNotEmpty ||
                                      conversation.channelId == kSystemUID ||
                                      conversation.channelId ==
                                          kFileHelperUID ||
                                      conversation.channelId ==
                                          kBotFatherUID) ...[
                                    const SizedBox(width: 4),
                                    MoyuOfficialTag(
                                      category:
                                          conversation
                                              .channelCategory
                                              .isNotEmpty
                                          ? conversation.channelCategory
                                          : 'system',
                                    ),
                                  ] else if (_peerIsBot() ||
                                      (() {
                                        // AI bot 单聊页 header 显示紫色 "AI" badge.
                                        if (conversation.channelType !=
                                            WKChannelType.personal) {
                                          return false;
                                        }
                                        for (final c in widget.contacts) {
                                          if (c.uid == conversation.channelId) {
                                            return c.isRobot;
                                          }
                                        }
                                        return false;
                                      }())) ...[
                                    const SizedBox(width: 4),
                                    const MoyuOfficialTag(category: 'ai'),
                                  ],
                                ],
                              ),
                              SizedBox(height: 1),
                              if (_navSubtitle().isNotEmpty)
                                Text(
                                  _navSubtitle(),
                                  style: TextStyle(
                                    color: MoyuColors.of(context).textTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 左右按钮层 — back + unread badge 左对齐, more 右对齐.
                        Row(
                          children: [
                            Semantics(
                              identifier: 'moyu.chat.back',
                              container: true,
                              child: MoyuRoundIconButton(
                                icon: moyuBackChevronIcon(context),
                                tooltip: t.actionBack,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            // 返回箭头右侧 unread badge — 其他会话累计未读,
                            // 对齐微信 chat header 返回箭头右"(N)"红点数字.
                            // Transform.translate 让 badge 往左挤 8pt 紧贴 <
                            // (MoyuRoundIconButton 44 命中区内 icon 右边缘距按钮
                            // 右边缘 ~12pt, 不挤就视觉离 < 太远).
                            if (_otherChatsUnread > 0)
                              Transform.translate(
                                offset: const Offset(-8, 0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: MoyuUnreadBadge(
                                    count: _otherChatsUnread,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            Semantics(
                              identifier: 'moyu.chat.settings',
                              container: true,
                              child: MoyuRoundIconButton(
                                icon: FIcons.ellipsis,
                                tooltip: t.chatDetailsTooltip,
                                onPressed: () => pushPage(
                                  context,
                                  ConversationSettingsPage(
                                    conversation: conversation,
                                    messages: _messages,
                                    config: widget.config,
                                    loginUid: widget.loginUid,
                                    loginName: widget.loginName,
                                    loginChatPwd: widget.loginChatPwd,
                                    imGateway: widget.imGateway,
                                    socialGateway: widget.socialGateway,
                                    contacts: widget.contacts,
                                    onClearMessages: _clearMessages,
                                    onDeleteConversation:
                                        widget.onDeleteConversation,
                                    onContactRemoved: widget.onContactRemoved,
                                    onScreenshotNotifyChanged: (v) {
                                      // The settings PUT is async; if the
                                      // user pops the chat between toggle
                                      // and round-trip, this callback fires
                                      // after dispose — guard before
                                      // setState to avoid the assertion.
                                      if (!mounted) return;
                                      setState(() => _notifyScreenshot = v);
                                    },
                                    // 搜索结果跳转 — settings → 搜索页 tap 一条
                                    // 结果会沿 callback 链回到这里, 用 _scrollToMessage
                                    // 滚到目标消息 id (对齐 iOS WKConversationVC.
                                    // locationAtOrderSeq 跳转).
                                    onJumpToMessage: (messageId) {
                                      if (!mounted || messageId.isEmpty) return;
                                      // 留一帧让 settings pop 完, 否则 _scrollToMessage
                                      // 的 ensureVisible 可能跑在过渡动画里被裁掉.
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            if (!mounted) return;
                                            unawaited(
                                              _scrollToMessage(messageId),
                                            );
                                          });
                                    },
                                    onFlameChanged: (enabled, seconds) {
                                      if (!mounted) return;
                                      // Cancel any in-flight destroy timers
                                      // — they were scheduled against the
                                      // previous TTL/enabled state. The
                                      // next build pass re-runs
                                      // `_maybeStartFlameTimer` per visible
                                      // bubble against the new mirror, so
                                      // expired-by-old / extended-by-new
                                      // semantics agree with the badge.
                                      for (final t in _flameTimers.values) {
                                        t.cancel();
                                      }
                                      _flameTimers.clear();
                                      setState(() {
                                        _flameEnabled = enabled;
                                        _flameSecond = seconds;
                                      });
                                    },
                                    onGroupRemarkChanged: (value) {
                                      if (!mounted) return;
                                      setState(
                                        () => _groupRemarkTitle = value.trim(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_pinnedMessages.isNotEmpty)
                    PinnedMessagesBanner(
                      messages: _pinnedMessages,
                      onOpenList: _openPinnedMessages,
                      onClearAll: _confirmClearPinnedMessages,
                      onLocate: _locatePinnedMessage,
                    ),
                  if (_isMultiSelect)
                    MultiSelectTopBar(
                      count: _selectedMessageKeys.length,
                      onCancel: _exitMultiSelect,
                    ),
                  // Group-call "通话进行中" banner — sticky above the
                  // message list, visible to every group member (even
                  // those not on the caller's invite list). Hides when
                  // there's no active room. WeChat / WhatsApp style.
                  if (_activeGroupCallRoomId.isNotEmpty)
                    GroupCallActiveBanner(onTap: _joinActiveGroupCall),
                  Expanded(
                    // reverse: true makes ListView's natural origin (offset 0)
                    // sit at the bottom, so the chat opens already pinned to
                    // the latest message — no jumpTo, no scroll animation, no
                    // chance to land mid-list while async layout settles.
                    // Children are reversed so chronological order still goes
                    // top→bottom on screen (oldest visually above latest).
                    //
                    // Tap on empty list area → dismiss keyboard + 关 panel
                    // (跟 iOS 原版 / 微信一致行为, 唤起键盘/面板时点列表收起).
                    // GestureDetector 在 ListView 外, behavior.opaque 接到
                    // ListView 没消费的空白 tap; row 内 GestureDetector 自带
                    // tap handler 仍优先命中.
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_composerFocus.hasFocus ||
                            _showEmojiPanel ||
                            _showMorePanel ||
                            _showVoicePanel) {
                          _dismissComposerKeyboard();
                          if (_showEmojiPanel ||
                              _showMorePanel ||
                              _showVoicePanel) {
                            setState(() {
                              _showEmojiPanel = false;
                              _showMorePanel = false;
                              _showVoicePanel = false;
                            });
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          // 字号 wrap 只包消息 ListView, 不包顶 nav / 输入栏 /
                          // 工具面板. chatScale 在外面 build scope 算好.
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaler: TextScaler.linear(chatScale),
                            ),
                            child: ListView(
                              controller: _messageScrollController,
                              reverse: true,
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                18,
                                16,
                                18,
                              ),
                              children: _buildChatRows().reversed.toList(),
                            ),
                          ),
                          if (_showJumpToBottom)
                            // 整个按钮在聊天列表水平居中显示, 不再贴右下角.
                            // left:0/right:0 让 Positioned 横向撑满, Center 居中
                            // 包住按钮; bottom 12pt 跟原偏移一致.
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 12,
                              child: Center(
                                child: JumpToBottomButton(
                                  unreadCount: _newMessagesBelow,
                                  onTap: _scrollToLatestAndClear,
                                ),
                              ),
                            ),
                          if (_pendingMentionMessageId.isNotEmpty)
                            Positioned(
                              // Stack the mention FAB above the unread one
                              // so both stay visible. 56pt = 36 button +
                              // 12pt bottom offset on the unread + 8pt gap.
                              right: 12,
                              bottom: _showJumpToBottom ? 60 : 12,
                              child: MentionScrollHint(
                                onTap: _scrollToOldestMention,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_isMultiSelect)
                    MultiSelectActionBar(
                      selectedCount: _selectedMessageKeys.length,
                      onDelete: _selectedMessageKeys.isEmpty
                          ? null
                          : _multiSelectDelete,
                      onForward: _selectedMessageKeys.isEmpty
                          ? null
                          : _multiSelectForward,
                      onFavorite:
                          _selectedMessageKeys.isEmpty ||
                              !_isFavoriteModuleEnabled
                          ? null
                          : _multiSelectFavorite,
                    )
                  else if (_composerLockedText().isNotEmpty)
                    ComposerLockedBanner(text: _composerLockedText())
                  else ...[
                    if (_mentionQuery != null)
                      MentionPicker(
                        members: filterMentionMembers(
                          query: _mentionQuery!,
                          members: _groupMembers,
                          loginUid: widget.loginUid,
                          isGroupAdmin: _isGroupAdmin,
                          mentionAllName: t.mentionAllMembers,
                          mentionAllSubtitle: t.mentionAllMembersSubtitle,
                        ),
                        config: widget.config,
                        onSelect: _selectMention,
                      ),
                    Container(
                      // 删 padding (之前 12/8/12/16) — 之前 composer + panel 都
                      // 被 12px 左右 + 16px 下 padding 缩进, 让 panel 视觉浮成
                      // 圆角白色"卡片"飘在浅灰背景上. iOS 原版 panel 撑满左右
                      // 边 + 贴底, 跟 composer 紧贴无间隔. 把 padding 内迁到
                      // composer 自己的 Padding(12/8/12/8) wrapper, panel 在
                      // 外面无 padding 撑满贴底.
                      decoration: BoxDecoration(
                        color: MoyuColors.of(context).backgroundSoft,
                        border: Border(
                          // 输入框与聊天背景的分隔线 — 同 nav, 加到 1 更明显。
                          top: BorderSide(
                            color: MoyuColors.of(context).line,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // _actionNotice was previously rendered inline above
                                // the composer, which pushed the input bar up every
                                // time a transient notice fired. Surface it as a
                                // floating toast instead so the composer height
                                // stays put — see the post-build hook below.
                                if (_replyTo != null)
                                  () {
                                    final replyTo = _replyTo!;
                                    final displayName = _senderName(replyTo);
                                    // Mirror the existing `Bubble` avatar fallback —
                                    // first character of the display name, '友' if empty.
                                    final label = displayName.isEmpty
                                        ? AppLocalizations.of(
                                            context,
                                          ).messagesFriendAvatarFallback
                                        : displayName.characters.first;
                                    // 自己消息 ChatMessage.right 构造 fromAvatarUrl
                                    // 硬编码空串 (line 98/145), 走 config.avatarUrl
                                    // SOP, 不让自己引用自己时头像缺失只剩 label。对方
                                    // 消息 fromAvatarUrl 已由 fromSnapshot 填充, 不动。
                                    final replyAvatarUrl = replyTo.isMine
                                        ? widget.config.avatarUrl(
                                            widget.loginUid,
                                          )
                                        : replyTo.fromAvatarUrl;
                                    return ReplyPreview(
                                      senderName: displayName,
                                      text: replyTo.text,
                                      avatarUrl: replyAvatarUrl,
                                      avatarLabel: label,
                                      avatarColors: _bubbleSenderColors(
                                        replyTo,
                                        widget.conversation,
                                      ),
                                      onClose: () =>
                                          setState(() => _replyTo = null),
                                    );
                                  }(),
                                if (_showMorePanel &&
                                    (_albumPreviewLoading ||
                                        _albumPreviewItems.isNotEmpty)) ...[
                                  AlbumPreviewStrip(
                                    items: _albumPreviewItems,
                                    loading: _albumPreviewLoading,
                                    onTap: _sendRecentAlbumPreview,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                // composer: inline Row [mic][textfield-round-rect]
                                // [smile][send/+]. placeholder "输入消息..." 跟语音
                                // 输入 icon 在同一行, 跟微信/Kimi 视觉一致 (user
                                // 反馈不要 vertical 两层). textfield 自带 round rect
                                // 边框 (8 圆角 + 1px line + 白底), 默认 1 行高,
                                // focus 时 maxLines:2 让自动 grow 到 2 行.
                                Row(
                                  // icon (44 高) 跟 FTextField (44 高) 中心垂直
                                  // 对齐. textfield grow 到 2 行时 (~64pt) 仍以
                                  // 中心轴对齐让左右 icon 看起来居中.
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // #3: 系统账号 leading 做键盘/按钮切换 (微信
                                    // 公众号同款): 按钮态显键盘图标→点切键盘;
                                    // 键盘态显网格图标→点切回按钮。其余会话保持 mic。
                                    if (widget.conversation.channelId ==
                                        kSystemUID)
                                      ComposerIcon(
                                        icon: _systemAcctKeyboard
                                            ? FIcons.layoutGrid
                                            : FIcons.keyboard,
                                        tooltip: _systemAcctKeyboard
                                            ? t.profileRowAbout(
                                                AppBrand.displayName,
                                              )
                                            : t.chatInputHint,
                                        onPressed: () => setState(
                                          () => _systemAcctKeyboard =
                                              !_systemAcctKeyboard,
                                        ),
                                      )
                                    else if (_peerIsBot())
                                      // 对方是 bot → [/] 命令入口取代语音 mic.
                                      // 放输入框**外**左侧 (不进 textfield prefix:
                                      // 否则点它 textfield 抢 focus 唤键盘, 跟命令
                                      // 面板同时弹). TG 同款位置.
                                      CommandPrefixButton(
                                        onTap: _toggleCommandPanel,
                                      )
                                    else
                                      ComposerIcon(
                                        icon: FIcons.mic,
                                        tooltip: t.chatVoiceInputTooltip,
                                        onPressed: _toggleVoicePanel,
                                      ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      // #2: 系统账号按钮态 → 中间换成"关于"按钮
                                      // (同 Row 同高, 替代文本框); 否则正常输入框。
                                      child: _sysAcctButtonMode
                                          ? _aboutButton(t)
                                          : Semantics(
                                              identifier: 'moyu.chat.input',
                                              container: true,
                                              // 直接用 FTextField 走 forui zinc 主题默认
                                              // chrome (44 高 + 8 圆角 + 1px line border +
                                              // 白底 + 15pt w400), 跟 DESIGN.md §6.5
                                              // 对齐. emoji 视觉放大交给
                                              // _ComposerTextEditingController 的
                                              // buildTextSpan, 不再整体放大输入文字.
                                              child: FTextField(
                                                control:
                                                    FTextFieldControl.managed(
                                                      controller:
                                                          _composerController,
                                                    ),
                                                focusNode: _composerFocus,
                                                hint: t.chatInputHint,
                                                minLines: 1,
                                                maxLines: 2,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                textInputAction:
                                                    TextInputAction.newline,
                                                // panel 期间 readOnly hard guarantee
                                                // textfield 不拿 focus, keyboard 不唤起.
                                                readOnly:
                                                    _showEmojiPanel ||
                                                    _showMorePanel ||
                                                    _showVoicePanel ||
                                                    _showCommandPanel,
                                                onTap: () {
                                                  // panel 期间点 textfield → 关 panel +
                                                  // re-focus, 跟微信切回打字模式一致.
                                                  if (_showEmojiPanel ||
                                                      _showMorePanel ||
                                                      _showVoicePanel ||
                                                      _showCommandPanel) {
                                                    setState(() {
                                                      _showEmojiPanel = false;
                                                      _showMorePanel = false;
                                                      _showVoicePanel = false;
                                                      _showCommandPanel = false;
                                                    });
                                                    _refocusComposerAfterPanel();
                                                  }
                                                },
                                              ),
                                            ),
                                    ),
                                    // #2: 系统账号按钮态隐藏右侧 emoji/火焰/发送/+,
                                    // 让"关于"按钮独占中间 (同 Row 同高)。
                                    if (!_sysAcctButtonMode) ...[
                                      const SizedBox(width: 6),
                                      // 阅后即焚开启时显红色火焰 icon, cue 用户当前 chat
                                      // 在 flame 状态. 对齐 iOS WKAdvancedModule.m:191
                                      // conversationinput.textview.rightview.flame:
                                      // channelInfo.flame=true 时 composer 右侧加 28×28
                                      // 红色 SecretMediaIcon button. iOS tap 弹
                                      // WKFlameSettingView 在 composer 顶部 (popover),
                                      // Flutter 简化为 tap 弹 toast 提示 user 进右上"..."
                                      // 设置可关闭 (实际功能 visual cue 为主).
                                      if (_flameEnabled)
                                        ComposerIcon(
                                          icon: FIcons.flame,
                                          tooltip: t.chatFlameEnabledTooltip,
                                          color: MoyuColors.of(context).red,
                                          onPressed: () {
                                            final secLabel = _flameSecond <= 0
                                                ? t.chatFlameDestroyOnExit
                                                : (_flameSecond >= 60
                                                      ? t.chatFlameDestroyAfterMinutes(
                                                          _flameSecond ~/ 60,
                                                        )
                                                      : t.chatFlameDestroyAfterSeconds(
                                                          _flameSecond,
                                                        ));
                                            MoyuToast.show(
                                              context,
                                              t.chatFlameEnabledNotice(
                                                secLabel,
                                              ),
                                            );
                                          },
                                        ),
                                      if (_flameEnabled)
                                        const SizedBox(width: 6),
                                      ComposerIcon(
                                        icon: FIcons.smile,
                                        tooltip: t.chatEmojiTooltip,
                                        onPressed: _toggleEmojiPanel,
                                      ),
                                      if (_hasComposerText)
                                        Semantics(
                                          identifier: 'moyu.chat.send',
                                          container: true,
                                          child: GestureDetector(
                                            onTap: _sendText,
                                            behavior: HitTestBehavior.opaque,
                                            // 36 高 + 18 圆角 pill, 跟左右
                                            // _ComposerIcon (44 命中区) 视觉
                                            // 高度协调, FTextField 中心轴对齐.
                                            child: Container(
                                              height: 36,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 14,
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient:
                                                    MoyuInk.bubbleSendGradientOf(
                                                      context,
                                                    ),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: Text(
                                                t.actionSend,
                                                style: TextStyle(
                                                  color: MoyuColors.of(
                                                    context,
                                                  ).background,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Semantics(
                                          identifier: 'moyu.chat.more',
                                          container: true,
                                          child: ComposerIcon(
                                            icon: FIcons.plus,
                                            tooltip: t.actionMore,
                                            onPressed: _toggleMorePanel,
                                          ),
                                        ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              child: _showMorePanel
                                  ? ChatMorePanel(
                                      key: const ValueKey('more'),
                                      actions: _enabledChatToolActions(),
                                      onAction: _handleChatToolAction,
                                    )
                                  : _showEmojiPanel
                                  ? EmojiPanel(
                                      key: const ValueKey('emoji'),
                                      onSelect: _insertEmoji,
                                      config: widget.config,
                                      socialGateway: widget.socialGateway,
                                      onSendSticker: _sendSticker,
                                      onOpenStickerStore:
                                          _isStickerStoreModuleEnabled
                                          ? _openStickerStore
                                          : null,
                                      onBackspace: _backspaceComposer,
                                      onOpenCustomManager: _openCustomManager,
                                      onSendComposerText: _sendText,
                                      // 用户已添加的贴纸包 / 自定义贴纸 →
                                      // 顶部 tab 在 emoji 8 类之后展开. 切到
                                      // 某个 pack tab 时 lazy load stickers.
                                      userStickerPacks: _userStickerPacks,
                                      customStickers: _customStickers,
                                      loadStickersForPack: _loadStickersForPack,
                                    )
                                  : _showVoicePanel
                                  ? VoiceInputPanel(
                                      key: const ValueKey('voice'),
                                      onStart: _startVoiceRecording,
                                      onStop: _stopAndSendVoice,
                                      onCancel: _cancelVoiceRecording,
                                      amplitudes:
                                          widget.mediaGateway?.voiceAmplitudes,
                                    )
                                  : _showCommandPanel
                                  ? BotCommandPanel(
                                      key: const ValueKey('command'),
                                      commands: _botCommands,
                                      loaded: _botCommandsLoaded,
                                      onSelect: _sendCommand,
                                    )
                                  : const SizedBox(
                                      key: ValueKey('none'),
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendText() {
    final text = _composerController.text.trim();
    if (text.isEmpty) {
      return;
    }
    final editingMessage = _editingMessage;
    if (editingMessage != null) {
      _lastTypingEmitAt = DateTime.now();
      unawaited(_submitMessageEdit(editingMessage, text));
      return;
    }
    // #6 大表情: 输入恰好是单个、且服务端有对应大贴纸的 emoji + 非回复 →
    // 发 type-13 大表情 (对齐 Android 原版 text_to_emoji_sticker)。映射表 key
    // 是单 emoji, containsKey 本身即"单 emoji"判断: "好的😊"/"😊😊" 都不命中
    // → 照常发文本; 服务端无此包时映射表空 → 也照常发文本 (优雅降级)。
    if (_replyTo == null) {
      final emojiSticker = _emojiStickerMap[text];
      if (emojiSticker != null) {
        _lastTypingEmitAt = DateTime.now();
        _composerController.clear();
        _pendingMentionPicks.clear();
        _pendingMentionAllLabel = '';
        unawaited(_persistDraft());
        _sendSticker(emojiSticker); // 内部 setState 清 panel/reply + 加消息
        return;
      }
    }
    // Suppress the next throttled typing emit — the message is now
    // on its way, so a follow-up t=101 would be redundant. Mirrors
    // native iOS `WKTypingManager`'s sender-side stop-on-send
    // (typing-flow.md §1.4).
    _lastTypingEmitAt = DateTime.now();
    final replyTo = _replyTo;
    final message = ChatMessage.right(
      text,
      status: '发送中',
      timestamp: nowSeconds(),
      replyToSender: replyTo == null ? '' : _senderName(replyTo),
      replyToText: replyTo?.text ?? '',
      // Carry the source's messageId so a later in-chat revoke can
      // find this optimistic reply via `_flipDependentReplies` and
      // swap its quote to `原消息已撤回` immediately. Empty when the
      // source itself is still local (rare — replies to in-flight
      // messages); we accept the tiny window of staleness in that
      // case since the source can't have been revoked anyway.
      replyToMessageId: replyTo?.messageId ?? '',
    );
    // Resolve pending mentions to the wire payload, dropping any
    // whose visible `@<label>` substring no longer appears in the
    // composer text (user deleted the chip before sending). Mirrors
    // native iOS `WKConversationContext` chip-tracker which only
    // forwards uids the user actually chose to keep.
    // Count how many bounded `@<label>` occurrences each label has
    // in the current composer text, then walk picks in order and
    // emit a uid for each remaining occurrence. Decrementing the
    // remaining count means duplicates resolve fairly: `@张三 @张三`
    // with two picks for different uids keeps both; deleting one
    // chip drops the second pick (FIFO ordering matches insertion).
    final remaining = <String, int>{};
    for (final pick in _pendingMentionPicks) {
      remaining[pick.label] ??= countMentionOccurrences(text, pick.label);
    }
    final activeUids = <String>[];
    for (final pick in _pendingMentionPicks) {
      final count = remaining[pick.label] ?? 0;
      if (count > 0) {
        activeUids.add(pick.uid);
        remaining[pick.label] = count - 1;
      }
    }
    final mentionAll = mentionStillPresent(text, _pendingMentionAllLabel);
    final mentionUids = List<String>.unmodifiable(activeUids);
    // Stash on the optimistic message instance so a "重新发送" retry
    // can re-fire the same mention metadata if the first send fails.
    if (mentionUids.isNotEmpty || mentionAll) {
      _messageMentionMeta[message] = (
        mentionUids: mentionUids,
        mentionAll: mentionAll,
      );
    }
    setState(() {
      _messages.add(message);
      _liveAppendsCount += 1;
      _composerController.clear();
      _replyTo = null;
      _showMorePanel = false;
      _showEmojiPanel = false;
      _showVoicePanel = false;
      _actionNotice = null;
      _pendingMentionPicks.clear();
      _pendingMentionAllLabel = '';
    });
    // Clear the persisted draft slot so reopening the chat doesn't
    // resurrect text the user already sent. Fire-and-forget; the
    // composer is already visually cleared above.
    unawaited(_persistDraft());
    // Capture reply target into local variables BEFORE the setState
    // above cleared `_replyTo`. The send chain reads these so the
    // outgoing WKTextContent carries a WKReply payload.
    final replyMessageId = replyTo?.messageId ?? '';
    final replyMessageSeq = replyTo?.messageSeq ?? 0;
    final replyFromUid = replyTo?.fromUid ?? '';
    final replyFromName = replyTo == null ? '' : _senderName(replyTo);
    final replyText = replyTo?.text ?? '';
    unawaited(
      _sendMessage(
        message,
        () => widget.onSendText(
          text,
          mentionUids: mentionUids,
          mentionAll: mentionAll,
          replyMessageId: replyMessageId,
          replyMessageSeq: replyMessageSeq,
          replyFromUid: replyFromUid,
          replyFromName: replyFromName,
          replyText: replyText,
        ),
      ),
    );
    _scrollMessagesToBottom();
  }

  Future<void> _sendMessage(
    ChatMessage message,
    Future<void> Function() send,
  ) async {
    try {
      // 30s send timeout. The SDK's sendWithOption has several internal
      // awaits (channel lookup, MessageDB.saveMsg, conversation save,
      // upload callback for media) and any one of them can hang on a
      // wedged DB / dropped IM connection — leaving the bubble
      // permanently in "发送中". Without a timeout, the UI offers no
      // affordance to recover; with it the user gets a "发送失败" bubble
      // with the long-press → 重发 path.
      await send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('[send] sendText timed out after 30s for ${message.text}');
          throw TimeoutException('sendWithOption stalled (30s)');
        },
      );
      if (!mounted) {
        return;
      }
      final ok = message.copyWith(status: '已发送');
      _carryMentionMeta(message, ok);
      _replaceMessage(message, ok);
    } catch (error, stack) {
      debugPrint('[send] failed: $error\n$stack');
      if (!mounted) {
        return;
      }
      // Preserve mention metadata across the copyWith — `_retryMessage`
      // looks the meta up by object identity on the failed bubble, so
      // dropping it here would silently downgrade an `@member` /
      // `@全体成员` retry to a plain text send.
      final failed = message.copyWith(status: '发送失败');
      _carryMentionMeta(message, failed);
      _replaceMessage(message, failed);
    }
  }

  /// Forward mention metadata stashed on `from` to `to` so identity-
  /// keyed lookups still resolve after a copyWith. Called whenever
  /// the chat replaces an optimistic message instance with a status-
  /// updated copy. No-op when nothing was stashed.
  void _carryMentionMeta(ChatMessage from, ChatMessage to) {
    if (identical(from, to)) return;
    final meta = _messageMentionMeta[from];
    if (meta == null) return;
    _messageMentionMeta[to] = meta;
  }

  void _replaceMessage(ChatMessage oldMessage, ChatMessage newMessage) {
    final index = _messages.indexOf(oldMessage);
    if (index == -1) {
      return;
    }
    setState(() {
      _messages = [
        ..._messages.take(index),
        newMessage,
        ..._messages.skip(index + 1),
      ];
    });
    _scrollMessagesToBottom();
  }

  void _retryMessage(ChatMessage message) {
    final sending = message.copyWith(status: '发送中');
    _replaceMessage(message, sending);
    final attachment = sending.attachment;
    if (attachment == null) {
      // Carry the original mention metadata across the retry so a
      // failed `@member` / `@全体成员` send still notifies the right
      // people on resend. Stashed by `_sendText` on the original
      // optimistic message; the copy preserves the same identity
      // path via Expando lookup against the new `sending` instance
      // by way of the just-stashed `message` key.
      final meta = _messageMentionMeta[message] ?? _messageMentionMeta[sending];
      final retryUids = meta?.mentionUids ?? const <String>[];
      final retryAll = meta?.mentionAll ?? false;
      // Re-stash on the new instance so a further retry still has
      // access (Expando is identity-keyed; copyWith returns a new
      // object).
      if (retryUids.isNotEmpty || retryAll) {
        _messageMentionMeta[sending] = (
          mentionUids: retryUids,
          mentionAll: retryAll,
        );
      }
      unawaited(
        _sendMessage(
          sending,
          () => widget.onSendText(
            sending.text,
            mentionUids: retryUids,
            mentionAll: retryAll,
            replyMessageId: sending.replyToMessageId,
            replyFromName: sending.replyToSender,
            replyText: sending.replyToText,
          ),
        ),
      );
      return;
    }
    unawaited(_sendMessage(sending, () => widget.onSendMedia(attachment)));
  }

  /// FocusScope.of(context).unfocus() 在 round rect 内嵌 Material+TextField
  /// 场景下偶发不生效 — user 报"点 emoji 面板还会唤出键盘". 用显式
  /// _composerFocus.unfocus() + post-frame primaryFocus.unfocus() 双保险,
  /// 确保 panel 出现前 keyboard 真正 dismiss.
  void _dismissComposerKeyboard() {
    if (_composerFocus.hasFocus) _composerFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// panel close 时让 textfield re-focus → keyboard 自动起 (跟微信
  /// 二次点 + 或表情 关面板回到打字模式同行为). post-frame 等
  /// setState 把 readOnly 设回 false 再 requestFocus, 否则 readOnly:true
  /// 期间 focus 拿不住.
  void _refocusComposerAfterPanel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _composerFocus.requestFocus();
    });
  }

  void _toggleMorePanel() {
    if (_showMorePanel) {
      setState(() => _showMorePanel = false);
      _refocusComposerAfterPanel();
      return;
    }
    _dismissComposerKeyboard();
    setState(() {
      _showMorePanel = true;
      _showEmojiPanel = false;
      _showVoicePanel = false;
      _actionMessage = null;
      _actionNotice = null;
    });
    unawaited(_loadRecentAlbumPreviews());
  }

  Future<void> _loadRecentAlbumPreviews() async {
    if (_albumPreviewLoaded || _albumPreviewLoading) return;
    if (widget.mediaGateway == null) {
      setState(() => _albumPreviewLoaded = true);
      return;
    }
    setState(() => _albumPreviewLoading = true);
    try {
      final permission = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(
          androidPermission: AndroidPermission(
            type: RequestType.image,
            mediaLocation: false,
          ),
        ),
      );
      if (!permission.hasAccess) {
        if (!mounted) return;
        setState(() {
          _albumPreviewItems = const [];
          _albumPreviewLoaded = true;
          _albumPreviewLoading = false;
        });
        return;
      }

      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      final assets = paths.isEmpty
          ? const <AssetEntity>[]
          : await paths.first.getAssetListRange(start: 0, end: 16);
      final previews = <AlbumPreviewItem>[];
      for (final asset in assets) {
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize.square(240),
          quality: 82,
        );
        if (thumbnail == null || thumbnail.isEmpty) continue;
        previews.add(AlbumPreviewItem(asset: asset, thumbnail: thumbnail));
      }
      if (!mounted) return;
      setState(() {
        _albumPreviewItems = List.unmodifiable(previews);
        _albumPreviewLoaded = true;
        _albumPreviewLoading = false;
      });
    } catch (error, stack) {
      debugPrint('[album-preview] load failed: $error\n$stack');
      if (!mounted) return;
      setState(() {
        _albumPreviewItems = const [];
        _albumPreviewLoaded = true;
        _albumPreviewLoading = false;
      });
    }
  }

  Future<void> _sendRecentAlbumPreview(AlbumPreviewItem item) async {
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatMediaServiceUnavailable,
      );
      return;
    }
    final picked = await chatMediaAttachmentFromGalleryAsset(item.asset);
    if (picked == null) return;
    _queueMediaMessage(picked, gateway);
  }

  void _toggleEmojiPanel() {
    if (_showEmojiPanel) {
      setState(() => _showEmojiPanel = false);
      _refocusComposerAfterPanel();
      return;
    }
    _dismissComposerKeyboard();
    setState(() {
      _showEmojiPanel = true;
      _showMorePanel = false;
      _showVoicePanel = false;
      _actionMessage = null;
      _actionNotice = null;
    });
  }

  void _toggleVoicePanel() {
    if (_showVoicePanel) {
      setState(() => _showVoicePanel = false);
      _refocusComposerAfterPanel();
      return;
    }
    _dismissComposerKeyboard();
    setState(() {
      _showVoicePanel = true;
      _showMorePanel = false;
      _showEmojiPanel = false;
      _actionMessage = null;
      _actionNotice = null;
    });
  }

  void _insertEmoji(String emoji) {
    final selection = _composerController.selection;
    final text = _composerController.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final nextText = text.replaceRange(start, end, emoji);
    final offset = start + emoji.length;
    _composerController.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  /// In-grid ⌫ handler. Mirrors native iOS WKEmojiPanel: delete one
  /// grapheme cluster (or the active selection) so multi-codepoint
  /// emojis (👨‍👩‍👧‍👦, 🏳️‍🌈, 👍🏽, 🇨🇳, …) collapse atomically rather
  /// than leaving orphan ZWJs / variation selectors / surrogate halves.
  void _backspaceComposer() {
    final value = _composerController.value;
    final sel = value.selection;
    if (!sel.isValid) return;
    if (sel.start != sel.end) {
      // Active selection — delete the whole range, like the system
      // backspace would.
      final next = value.text.replaceRange(sel.start, sel.end, '');
      _composerController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: sel.start),
      );
      return;
    }
    if (sel.start <= 0) return;
    final before = value.text.substring(0, sel.start);
    final after = value.text.substring(sel.end);
    final beforeChars = before.characters;
    if (beforeChars.isEmpty) return;
    final dropped = beforeChars.skipLast(1).join();
    _composerController.value = TextEditingValue(
      text: dropped + after,
      selection: TextSelection.collapsed(offset: dropped.length),
    );
  }

  void _openStickerStore() {
    final feature = _runtime?.registry.featureById(
      ModuleFeatureIds.stickerStorePageBuilder,
    );
    final builder = feature?.value;
    if (feature == null ||
        _runtime?.registry.isModuleEnabled(feature.moduleId) != true ||
        builder is! ModuleStickerStorePageBuilder) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).moduleUnsupported,
      );
      return;
    }
    // pop 回来后触发 _reloadStickerPanelData 重拉用户包列表 + 自定义
    // 贴纸, 让 emoji panel 顶部 tab 立即反映新加/删的包 (对齐 iOS
    // WKStickerContentView hot reload 行为).
    unawaited(
      pushPage(
        context,
        builder(config: widget.config, socialGateway: widget.socialGateway),
      ).then((_) => _reloadStickerPanelData()),
    );
  }

  /// 自定义贴纸"+"入口 — emoji panel custom tab grid 头一个 "+" cell tap
  /// 触发. push _StickerManagerPage(mode: custom) 让用户从相册添加 / 整理
  /// / 删除. 对齐 iOS WKStickerCollectedContentView.m:148-169 → push
  /// WKStickerCollectionVC. pop 回来后 _reloadStickerPanelData 重拉自定
  /// 义贴纸列表, panel 立即反映改动.
  void _openCustomManager() {
    final feature = _runtime?.registry.featureById(
      ModuleFeatureIds.stickerManagerPageBuilder,
    );
    final builder = feature?.value;
    if (feature == null ||
        _runtime?.registry.isModuleEnabled(feature.moduleId) != true ||
        builder is! ModuleStickerManagerPageBuilder) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).moduleUnsupported,
      );
      return;
    }
    unawaited(
      pushPage(
        context,
        builder(
          config: widget.config,
          socialGateway: widget.socialGateway,
          custom: true,
        ),
      ).then((_) => _reloadStickerPanelData()),
    );
  }

  void _showMessageActions(ChatMessage message) {
    _showMessageActionsAt(message, null);
  }

  void _showMessageActionsAt(ChatMessage message, Offset? globalPos) {
    // Native iOS WKContextMenusVC fires `UIImpactFeedbackGenerator(.light)`
    // on present (`presentOnWindow:` line 82). Match the light impact
    // exactly — medium felt heavier than iOS native.
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();
    setState(() {
      _showMorePanel = false;
      _actionNotice = null;
    });
    // Pin/Unpin 切换 + 群权限：对齐 iOS WKPinnedModule —— 已 pin 显
    // "取消置顶"，未 pin 显"置顶"；群里普通成员看不到该 menu item。
    final pinnedMessageIds = {
      for (final p in _pinnedMessages)
        if (p.messageId.isNotEmpty) p.messageId,
    };
    final isAlreadyPinned = pinnedMessageIds.contains(message.messageId);
    // 1v1 任何人可 pin；群里只群主/管理员可 pin。当前用户角色靠
    // widget.conversation.localUserRole（如果暴露）—— 否则简化：1v1
    // 总允许，群默认禁用直到 group settings 有 myRole 暴露。
    // 长按"置顶"对齐 iOS WKPinnedModule:
    //   * 1v1: 任何人都可 pin
    //   * 群里: 之前简化为禁用 (TODO 等群角色暴露), 现放开 — 后端依据
    //     `userRole` 字段判管理员权限, 普通用户 pin 后端会 403, 客户端
    //     接到错误时 MoyuToast 提示 "无权限". 优于完全隐藏入口让群主/管
    //     理员看不到按钮.
    const canPin = true;
    final actions = filterChatMessageActionsForModules(
      messageActionsFor(
        message,
        l10n: AppLocalizations.of(context),
        serverAppConfig: widget.serverAppConfig,
        isAlreadyPinned: isAlreadyPinned,
        canPin: canPin,
        moduleLongPressActions: _enabledModuleLongPressActions(),
        moduleMessageActionFactories: _enabledModuleMessageActionFactories(),
        messageAiModuleAvailable: _messageAiGateway != null,
      ),
      isModuleEnabled: (moduleId) =>
          widget.runtime?.isModuleEnabled(moduleId) ?? false,
    );
    // Quick-reactions bar: show only on bubbles that can actually
    // render `_ReactionStrip` feedback below the row (i.e. the standard
    // `Bubble` widget — text/image/video/voice/file/sticker). Custom
    // cards (call / merge-forward / location / card / group-invite)
    // don't host the strip yet, so a tap would silently succeed
    // server-side without any visible UI confirmation.
    //
    // Also require a real server-side messageId — `_toggleReaction`
    // bails on empty ids, so a bar tap on an optimistic / failed-send
    // bubble would be a dead button. And require `imGateway` so the
    // toggle has a transport to actually fire on.
    final canReact =
        !message.isSystemMessage &&
        !message.revoked &&
        !message.isCallMessage &&
        !message.isMergeForwardMessage &&
        !message.isLocationMessage &&
        !message.isCardMessage &&
        !message.isGroupInviteApproval &&
        !message.isUnknownMessage &&
        message.messageId.isNotEmpty &&
        widget.imGateway != null;

    MessageContextMenu.show(
      context,
      message: message,
      isMine: message.isMine,
      actions: actions,
      anchor: globalPos,
      onSelected: (action) {
        _actionMessage = message;
        _handleMessageAction(action);
      },
      onPickReaction: canReact
          ? (emoji) => unawaited(_toggleReaction(message, emoji))
          : null,
    );
  }

  void _handleMessageAction(ChatMessageAction action) {
    final message = _actionMessage;
    if (message == null) {
      return;
    }
    final t = AppLocalizations.of(context);

    if (action.id == 'message.forward') {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      unawaited(_forwardMessage(message));
      return;
    }
    if (action.id == 'message.edit') {
      _restoreToComposer(message, preferEditedText: true, asEdit: true);
      return;
    }
    if (action.id == ModuleActionIds.messageEditImage) {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      unawaited(_editImageMessage(message));
      return;
    }
    if (action.id == 'message.translate') {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      unawaited(_translateTextMessage(message));
      return;
    }
    if (action.id == 'message.transcribe') {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      unawaited(_transcribeVoiceMessage(message));
      return;
    }
    if (action.id == 'message.add_friend') {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      // 名片长按弹添加好友 sheet, 对齐 iOS WKCardCell. _openCardProfile
      // 已经支持 stranger 模式 (走 users/<uid> fetch + 在名片详情页点"添加")
      // - 复用入口避免 fork 第二条 add-friend 链路.
      unawaited(_openCardProfile(message.cardUid));
      return;
    }
    if (action.id == ModuleActionIds.messageReactions) {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      unawaited(_openReactionUsersList(message));
      return;
    }
    if (action.id == ModuleActionIds.messageReceipts) {
      setState(() {
        _actionMessage = null;
        _actionNotice = null;
      });
      unawaited(_openReceiptList(message));
      return;
    }
    if (action.id == 'message.reply') {
      _startReplyToMessage(message);
      return;
    }

    setState(() {
      switch (action.id) {
        case 'message.delete':
          _messages.remove(message);
          _replyTo = _replyTo == message ? null : _replyTo;
          _actionNotice = t.chatNoticeDeleted;
          unawaited(_deleteRemoteMessage(message));
        case 'message.copy':
          unawaited(Clipboard.setData(ClipboardData(text: message.text)));
          _actionNotice = t.chatNoticeCopied;
        case ModuleActionIds.messageFavorite:
          // 不预 toast：交给 _favoriteMessage 根据服务端结果再 toast
          // 成功 / 失败，对齐 iOS WKFavoriteModule 行为。
          unawaited(_favoriteMessage(message));
        case ModuleActionIds.messagePin:
          // 不要预先弹"已置顶"——pin 可能因服务端上限 / 权限 / 网络
          // 失败。让 _pinRemoteMessage 自己根据结果 toast 成功 / 错误。
          unawaited(_pinRemoteMessage(message));
        case ModuleActionIds.messageUnpin:
          unawaited(_unpinRemoteMessage(message));
        case 'message.revoke':
          // Flip the local bubble to the system "你撤回了一条消息" row
          // immediately for a responsive UX; the server's refresh push will
          // arrive later and replace the entry with the same revoked state.
          final index = _messages.indexOf(message);
          if (index >= 0) {
            _messages[index] = message.markRevoked(widget.loginUid);
          }
          _flipDependentReplies(message);
          _replyTo = _replyTo == message ? null : _replyTo;
          _actionNotice = null;
          unawaited(_revokeRemoteMessage(message));
        case 'message.multi_select':
          _isMultiSelect = true;
          _selectedMessageKeys.clear();
          final key = _selectionKey(message);
          if (key.isNotEmpty) _selectedMessageKeys.add(key);
          _replyTo = null;
          _actionNotice = null;
      }
      _actionMessage = null;
    });
  }

  void _startReplyToMessage(ChatMessage message) {
    if (message.messageId.isEmpty ||
        message.revoked ||
        message.isUnknownMessage) {
      return;
    }
    setState(() {
      _replyTo = message;
      _editingMessage = null;
      _actionMessage = null;
      _actionNotice = null;
      _showEmojiPanel = false;
      _showMorePanel = false;
      _showVoicePanel = false;
    });
    _refocusComposerAfterPanel();
  }

  Future<void> _forwardMessage(ChatMessage message) async {
    final t = AppLocalizations.of(context);
    final contact = await Navigator.of(context).push<UiContact>(
      MaterialPageRoute(
        builder: (_) => ContactCardPickerPage(
          contacts: widget.contacts,
          title: t.chatForwardPickerTitle,
          sectionTitle: t.chatRecentContactsSection,
        ),
      ),
    );
    if (!mounted || contact == null) {
      return;
    }
    final channelId = contactChannelId(contact);
    try {
      await _forwardSingle(
        message: message,
        targetChannelId: channelId,
        targetChannelType: WKChannelType.personal,
      );
      if (!mounted) return;
      setState(() => _actionNotice = t.chatForwardedTo(contact.name));
    } catch (error) {
      if (mounted) {
        setState(() => _actionNotice = error.toString());
      }
    }
  }

  /// Per-content-type clone for forward. Mirrors native iOS behavior of
  /// the registered allowForwards path: each type re-uses its dedicated
  /// gateway send method so server-stored URLs / payloads are preserved
  /// instead of degrading to a `[图片]` text digest. Falls back to
  /// `sendText` for types we don't have an explicit gateway for so the
  /// receiver still gets a usable placeholder line.
  Future<void> _forwardSingle({
    required ChatMessage message,
    required String targetChannelId,
    required int targetChannelType,
  }) async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    final messageFallback = AppLocalizations.of(
      context,
    ).chatMessageDigestFallback;
    final attachment = message.attachment;
    // Resolve contentType the same way `_chatMessageToMergeEntry` does.
    // Locally-sent media bubbles created by `ChatMessage.rightMedia`
    // before SDK round-trip have `contentType == 0` but a populated
    // `kind` + `attachment`. Without this fallback, choosing 多选 →
    // 逐条转发 right after sending would degrade media to text.
    final resolvedType = message.contentType > 0
        ? message.contentType
        : inferMergeForwardContentType(message);
    switch (resolvedType) {
      case 1: // text
        await gateway.sendText(
          channelId: targetChannelId,
          channelType: targetChannelType,
          text: message.effectiveText,
        );
        return;
      case 2: // image
      case 3: // gif
      case 4: // voice
      case 5: // small video
      case 8: // file
        if (attachment != null) {
          await gateway.sendMedia(
            channelId: targetChannelId,
            channelType: targetChannelType,
            attachment: attachment,
          );
          return;
        }
        break;
      case 7: // card
        if (message.cardUid.isNotEmpty) {
          await gateway.sendCard(
            channelId: targetChannelId,
            channelType: targetChannelType,
            cardUid: message.cardUid,
            cardName: message.cardName,
            vercode: message.cardVercode,
          );
          return;
        }
        break;
      case 11: // merge-forward — re-send original payload verbatim
        if (message.mergeForwardEntries.isNotEmpty) {
          // Preserve the ORIGINAL channel_type + users[] so re-forwarding
          // a 1:1 merge into a group still resolves the title to
          // "<name>的聊天记录" rather than degrading to "群的聊天记录".
          // Mirrors native iOS WKMergeForwardCell forward path.
          final content = WKMergeForwardContent()
            ..sourceChannelType = message.mergeForwardSourceChannelType > 0
                ? message.mergeForwardSourceChannelType
                : widget.conversation.channelType
            ..users = message.mergeForwardUsers.isNotEmpty
                ? message.mergeForwardUsers
                : const []
            ..msgs = message.mergeForwardEntries;
          await gateway.sendMergeForward(
            channelId: targetChannelId,
            channelType: targetChannelType,
            content: content,
          );
          return;
        }
        break;
      case 12: // lottie sticker
      case 13: // emoji sticker
        // Sticker forward via attachment is not yet round-trippable through
        // sendMedia; fall through to text digest until we add a dedicated
        // sendSticker re-send path that preserves category/format.
        break;
      default:
        break;
    }
    // Fallback: send the digest text so the receiver still sees something.
    await gateway.sendText(
      channelId: targetChannelId,
      channelType: targetChannelType,
      text: message.effectiveText.isEmpty
          ? messageFallback
          : message.effectiveText,
    );
  }

  Future<void> _deleteRemoteMessage(ChatMessage message) async {
    final reference = _remoteReference(message);
    if (reference == null) {
      return;
    }
    await widget.imGateway?.deleteMessages([reference]);
  }

  Future<void> _pinRemoteMessage(ChatMessage message) async {
    final reference = _remoteReference(message);
    debugPrint(
      '[pinned] _pinRemoteMessage msgId=${message.messageId} '
      'ref=${reference == null ? 'NULL' : 'ok'}',
    );
    if (reference == null) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatPinFailedNotSent,
        );
      }
      return;
    }
    try {
      await widget.imGateway?.pinMessage(reference);
      debugPrint('[pinned] pinMessage POST done');
    } catch (e) {
      debugPrint('[pinned] pinMessage POST FAILED: $e');
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).chatPinFailed);
      }
      return;
    }
    if (mounted) {
      MoyuToast.show(context, AppLocalizations.of(context).chatPinned);
    }
    await _loadPinnedMessages();
  }

  /// 取消单条置顶。服务端 `/v1/message/pinned` 本身就是 toggle 接口
  /// (api_pinned.go: 已存在 + isDeleted=0 → 软删 + isPinned=0)，所以
  /// 不需要单独的 unpin endpoint，复用 `pinMessage` 即可。对齐 iOS
  /// WKPinnedModule.requestPin (同一 onTap 既 pin 也 unpin)。
  Future<void> _unpinRemoteMessage(ChatMessage message) async {
    final reference = _remoteReference(message);
    if (reference == null) return;
    try {
      await widget.imGateway?.pinMessage(reference);
    } catch (e) {
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).chatUnpinFailed);
      }
      return;
    }
    if (mounted) {
      MoyuToast.show(context, AppLocalizations.of(context).chatUnpinned);
    }
    await _loadPinnedMessages();
  }

  Future<void> _openPinnedMessages() async {
    // 抽屉风 modal — 从底部 slide up, 占屏 ~95% 高, 顶部圆角. 对齐 iOS
    // WKPinnedMessageListVC 用 presentViewController 的 modal 默认动画.
    final messageById = <String, ChatMessage>{
      for (final m in _messages)
        if (m.messageId.isNotEmpty) m.messageId: m,
    };
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      // safe-area top 不裁掉 — 让 page 自己处理 nav bar 高度.
      useSafeArea: true,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.95,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          child: PinnedMessagesPage(
            messages: _pinnedMessages,
            onClearAll: _clearPinnedMessages,
            // 跟主聊天页同一 chatBackground decoration. 让置顶列表跟主
            // 聊天视觉连续, 对齐原版 iOS WKPinnedMessageListVC.
            backgroundDecoration: _chatBackgroundDecoration(),
            // 当前已加载 _messages 的 messageId → ChatMessage map.
            // tile 用这个 lookup 真实 message, 走 Bubble.left 渲染所有 kind.
            // 找不到 (pin 太旧已滚出 list) → 走 snapshot.text digest fallback.
            messageById: messageById,
            messageBuilder: _buildPinnedMessageBubble,
            onLocate: (pinned) {
              unawaited(_locatePinnedMessage(pinned));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedMessageBubble(
    BuildContext context,
    ChatMessage msg,
    String timeLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bubble.left 自带 bottom 12pt padding (跟聊天列表行间距同款), 这里
        // 不强行去掉避免破坏 Bubble 内部布局.
        Bubble.left(
          avatarLabel: '',
          text: msg.effectiveText,
          colors: const [],
          kind: msg.kind,
          attachment: msg.attachment,
          hasAvatarSlot: false,
          showAvatar: false,
          mediaGateway: widget.mediaGateway,
        ),
        if (timeLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 0, bottom: 4),
            child: PinnedMetaRow(time: timeLabel),
          ),
      ],
    );
  }

  Future<void> _clearPinnedMessages() async {
    await widget.imGateway?.clearPinnedMessages(
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
    );
    if (!mounted) {
      return;
    }
    setState(() => _pinnedMessages = const []);
  }

  /// Banner 右侧 close X 触发。对齐 iOS WKPinnedView.closePressed:
  /// 弹 ActionSheet "您确定要为所有人解除此消息的置顶吗？"，确认后
  /// 调 clearPinnedMessages（对应 iOS WKPinnedService.requestCancelAllPinned）。
  Future<void> _confirmClearPinnedMessages() async {
    final confirmed = <bool>[false];
    await MoyuActionSheet.show(
      context,
      title: AppLocalizations.of(context).chatClearPinnedConfirm,
      items: [
        MoyuActionSheetItem(
          title: AppLocalizations.of(context).chatClearPinnedAction,
          destructive: true,
          onSelected: () => confirmed[0] = true,
        ),
      ],
    );
    if (!confirmed[0] || !mounted) return;
    try {
      await _clearPinnedMessages();
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).chatAllUnpinned);
      }
    } catch (e) {
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).chatUnpinFailed);
      }
    }
  }

  /// Banner tap 单条 / 多条切换后调用。iOS WKPinnedView.pressed →
  /// `[self.context locateMessageCell:pinnedMessage.messageSeq]`。
  /// Flutter 复用现成的 `_scrollToMessage(messageId)` —— 找到对应
  /// 消息滚到屏幕中并 highlight pulse；找不到（被 SDK 清出本地缓存
  /// 或在更早分页）则 toast 提示用户去列表页查看。
  Future<void> _locatePinnedMessage(WukongPinnedMessageSnapshot pinned) async {
    final ok = await _scrollToMessage(pinned.messageId);
    if (!ok && mounted) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatPinnedMessageNotVisible,
      );
    }
  }

  /// 长按图片消息 → "编辑图片" → pro_image_editor 编辑后作为新图片消息发.
  /// 跟 iOS 原版 WuKongBase WKImageBrowser.handleEdit: → ZLEditImageView
  /// Controller → onEditFinish → sendMessage(content) 完全同协议.
  /// 不修改原消息 (不是 update), 而是发新的图片消息.
  Future<void> _editImageMessage(ChatMessage message) async {
    final attachment = message.attachment;
    if (attachment == null) {
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).chatImageMissing);
      }
      return;
    }
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatMediaServiceUnavailable,
        );
      }
      return;
    }

    // 拿图源 — 优先 local path (发送方刚发的图本地有原图), fallback 远程下载
    // (接收方/历史图只有 remoteUrl). 远程下载走 ChatMediaService.downloadToCache
    // 跟图片消息其他下载 (e.g. lightbox) 同模式, 用 token 鉴权.
    File? sourceFile;
    final local = attachment.localPath.trim();
    if (local.isNotEmpty && await File(local).exists()) {
      sourceFile = File(local);
    } else if (attachment.remoteUrl.isNotEmpty) {
      try {
        sourceFile = await gateway.downloadToCache(
          url: widget.config.showUrl(attachment.remoteUrl),
          filename: 'edit_src_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
      } catch (e) {
        debugPrint('[editImage] downloadToCache failed: $e');
      }
    }
    if (sourceFile == null) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatImageDownloadFailedEdit,
        );
      }
      return;
    }

    // 打开编辑器 — 用户编辑完成返 PNG/JPEG bytes; 用户 cancel 返 null.
    if (!mounted) return;
    final feature = widget.runtime?.registry.featureById(
      ModuleFeatureIds.imageEditorLauncher,
    );
    final launcher =
        feature != null &&
            (widget.runtime?.isModuleEnabled(feature.moduleId) ?? false)
        ? feature.value
        : null;
    if (launcher is! ImageEditorLauncher) {
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      }
      return;
    }
    final bytes = await launcher(context, sourceFile);
    if (bytes == null || bytes.isEmpty) return;

    // 写编辑后的图到临时文件 → 构造新 ChatMediaAttachment → 走标准发送链路.
    final tempDir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final editedFile = File('${tempDir.path}/edited_$ts.jpg');
    await editedFile.writeAsBytes(bytes, flush: true);

    // 拿编辑后图的真实 width / height — pro_image_editor 编辑后 image 维度
    // 可能跟原图不同 (裁剪 / 旋转 改变了). 不填 width/height 接收方 fallback
    // 4:3 + BoxFit.cover 会裁切, 视觉"变形" (跟 #1 bug 同根因, 见
    // _ImageBubbleContent 的 stream resolve 兜底). 这里走 decodeImageFromList
    // 同步从 bytes 解析尺寸, 跟 attachment 一起编码进 IM payload.
    var natW = 0;
    var natH = 0;
    try {
      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      natW = frame.image.width;
      natH = frame.image.height;
      frame.image.dispose();
    } catch (_) {
      // 解析失败保留 0/0, 接收方走 stream resolve 兜底.
    }

    if (!mounted) return;
    final editedAttachment = ChatMediaAttachment(
      kind: ChatMediaKind.image,
      localPath: editedFile.path,
      fileName: 'edited_$ts.jpg',
      fileSize: bytes.length,
      width: natW,
      height: natH,
    );
    _queueMediaMessage(editedAttachment, gateway);
  }

  /// Toggle one of the standard 6 reaction emojis on a message. Optimistic
  /// update of the local count; the server's refresh push will reconcile
  /// the canonical list later.
  Future<void> _toggleReaction(ChatMessage message, String emoji) async {
    if (message.messageId.isEmpty) return;
    setState(() {
      final index = _messages.indexOf(message);
      if (index < 0) return;
      _messages[index] = _messages[index].toggleReaction(emoji);
    });
    try {
      await widget.imGateway?.sendReaction(
        messageId: message.messageId,
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        emoji: emoji,
      );
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatReactionFailed,
      );
    }
  }

  Future<void> _revokeRemoteMessage(ChatMessage message) async {
    final reference = _remoteReference(message);
    if (reference == null) {
      return;
    }
    await widget.imGateway?.revokeMessage(reference);
  }

  /// Re-edit hook for "你撤回了一条消息 · 重新编辑" — pushes the original
  /// text back into the composer so the user can tweak and re-send. Mirrors
  /// native iOS WKConversationInputPanel restore behavior. When the
  /// revoked message had an inline reply quote, also restore the
  /// reply attachment so the re-sent message preserves its target.
  /// Best-effort: if the original reply target has been paginated
  /// out / revoked, the attachment is silently skipped — the user
  /// still gets the text back.
  void _restoreToComposer(
    ChatMessage source, {
    bool preferEditedText = false,
    bool asEdit = false,
  }) {
    final text = preferEditedText && source.editedText.isNotEmpty
        ? source.editedText
        : source.text;
    if (text.isEmpty) return;
    _composerController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    // Reply-attachment restore: 重新编辑 of a revoked reply should
    // recover the original quote target, not preserve whatever the
    // user was replying to before they tapped re-edit. We always
    // overwrite `_replyTo` with the resolved target — null when the
    // source had no reply OR the target's been paginated out /
    // revoked — so the next send doesn't attach a stale quote.
    ChatMessage? target;
    if (!asEdit && source.replyToMessageId.isNotEmpty) {
      for (final m in _messages) {
        if (m.messageId == source.replyToMessageId) {
          if (!m.revoked) target = m;
          break;
        }
      }
    }
    setState(() {
      _actionMessage = null;
      _actionNotice = null;
      _editingMessage = asEdit ? source : null;
      _replyTo = asEdit ? null : target;
      _showEmojiPanel = false;
      _showMorePanel = false;
      _showVoicePanel = false;
      _pendingMentionPicks.clear();
      _pendingMentionAllLabel = '';
      _mentionQuery = null;
      _mentionAnchor = -1;
    });
    _refocusComposerAfterPanel();
  }

  Future<void> _submitMessageEdit(ChatMessage source, String text) async {
    final reference = _remoteReference(source);
    final gateway = widget.imGateway;
    if (reference == null || gateway == null) {
      if (mounted) {
        setState(
          () => _actionNotice = AppLocalizations.of(context).chatEditNotSynced,
        );
      }
      return;
    }

    final index = _indexOfMessage(source);
    final current = index >= 0 ? _messages[index] : source;
    final currentText = current.editedText.isNotEmpty
        ? current.editedText
        : current.text;
    final changed = text != currentText.trim();

    setState(() {
      if (changed && index >= 0) {
        _messages[index] = current.markEdited(text);
      }
      _editingMessage = null;
      _replyTo = null;
      _composerController.clear();
      _showEmojiPanel = false;
      _showMorePanel = false;
      _showVoicePanel = false;
      _actionNotice = null;
      _pendingMentionPicks.clear();
      _pendingMentionAllLabel = '';
      _mentionQuery = null;
      _mentionAnchor = -1;
    });
    unawaited(_persistDraft());
    if (!changed) return;

    try {
      await gateway.editMessage(message: reference, content: text);
    } catch (e) {
      if (mounted) {
        setState(
          () => _actionNotice = AppLocalizations.of(context).chatEditFailed,
        );
      }
    }
  }

  int _indexOfMessage(ChatMessage target) {
    if (target.messageId.isNotEmpty) {
      final index = _messages.indexWhere(
        (m) => m.messageId == target.messageId,
      );
      if (index >= 0) return index;
    }
    if (target.clientMsgNo.isNotEmpty) {
      final index = _messages.indexWhere(
        (m) => m.clientMsgNo == target.clientMsgNo,
      );
      if (index >= 0) return index;
    }
    return _messages.indexOf(target);
  }

  WukongMessageReference? _remoteReference(ChatMessage message) {
    final reference = WukongMessageReference(
      messageId: message.messageId,
      messageSeq: message.messageSeq,
      clientMsgNo: message.clientMsgNo,
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
    );
    return reference.hasRemoteIdentity ? reference : null;
  }

  /// 对齐 iOS WKFavoriteModule (WKPOINT_LONGMENUS_FAVORITE handler)：
  ///   req.uniqueKey = messageId       (TEXT 被编辑过则追加 "-edit")
  ///   req.type      = contentType     (WK_TEXT=1 / WK_IMAGE=2)
  ///   req.authorUID = message.fromUid
  ///   req.authorName= message.from.name
  ///   req.payload   = { content: textContent.content }   // TEXT
  ///               or { content: imageContent.remoteUrl } // IMAGE (绝对 URL)
  /// 失败要给用户反馈，不能像之前那样静默。
  Future<void> _favoriteMessage(ChatMessage message) async {
    if (!_isFavoriteModuleEnabled) {
      _showFavoriteModuleFallback();
      return;
    }
    final gateway = widget.socialGateway;
    if (gateway == null) return;

    // iOS 只允许 TEXT / IMAGE 进入收藏入口 (addMessageAllowFavorite:WK_TEXT/WK_IMAGE)
    final hasAttachment = message.attachment != null;
    final isTextOnly =
        message.kind == ChatMediaKind.file &&
        !hasAttachment &&
        message.text.isNotEmpty;
    final isImage =
        message.kind == ChatMediaKind.image &&
        (message.attachment?.remoteUrl.isNotEmpty ?? false);
    if (!isTextOnly && !isImage) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatFavoriteUnsupportedType,
        );
      }
      return;
    }
    if (message.messageId.isEmpty) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatFavoriteNotSent,
        );
      }
      return;
    }

    // TEXT 被编辑过 → uniqueKey 末尾追加 "-edit"，跟 iOS 一致防止跟原文本冲突
    final edited = isTextOnly && message.editedText.isNotEmpty;
    final uniqueKey = edited ? '${message.messageId}-edit' : message.messageId;

    // authorUid: 自己发的也要带自己的 uid (iOS 直接取 message.fromUid)
    var authorUid = message.fromUid;
    if (authorUid.isEmpty && message.isMine) {
      authorUid = widget.loginUid;
    }

    // authorName: iOS 直接取 message.from.name；这里按相同优先级解析：
    //   1) message.fromName (SDK 给的)
    //   2) 自己 → widget.loginName
    //   3) 1v1 对端 → conversation.name
    //   4) 群成员 → _groupMembers 里 remark > name > uid
    var authorName = message.fromName.trim();
    if (authorName.isEmpty) {
      if (message.isMine) {
        authorName = widget.loginName.trim();
      } else if (widget.conversation.channelType == WKChannelType.personal) {
        authorName = widget.conversation.name;
      } else if (authorUid.isNotEmpty) {
        for (final member in _groupMembers) {
          if (member.uid == authorUid) {
            authorName = moyuDisplayName(
              remark: member.remark,
              name: member.name,
              rawIdentity: member.uid,
              placeholder: '',
            );
            break;
          }
        }
      }
    }

    // content + type
    final int type;
    final String content;
    if (isImage) {
      type = 2; // WK_IMAGE
      content = message.attachment!.remoteUrl;
    } else {
      type = 1; // WK_TEXT
      content = edited ? message.editedText : message.text;
    }

    try {
      await gateway.addFavorite(
        uniqueKey: uniqueKey,
        authorUid: authorUid,
        authorName: authorName,
        type: type,
        content: content,
      );
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatFavoriteSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).chatFavoriteFailed,
        );
      }
    }
  }

  bool get _isFavoriteModuleEnabled => _enabledModuleLongPressActions().any(
    (action) => action.id == ModuleActionIds.messageFavorite,
  );

  Iterable<ChatMessageAction> _enabledModuleLongPressActions() {
    final runtime = widget.runtime;
    if (runtime == null) return const <ChatMessageAction>[];
    return runtime.registry
        .enabledFeatures(kind: FeatureKind.longPressAction)
        .map((feature) => feature.value)
        .whereType<ChatMessageAction>();
  }

  Iterable<ChatMessageActionFactory> _enabledModuleMessageActionFactories() {
    final runtime = widget.runtime;
    if (runtime == null) return const <ChatMessageActionFactory>[];
    return runtime.registry
        .enabledFeatures(kind: FeatureKind.longPressAction)
        .map((feature) => feature.value)
        .whereType<ChatMessageActionFactory>();
  }

  bool get _isStickerStoreModuleEnabled {
    final runtime = widget.runtime;
    if (runtime == null) return true;
    return runtime.registry
        .enabledFeatures(kind: FeatureKind.discoverItem)
        .any((feature) => feature.id == ModuleActionIds.stickerStoreOpen);
  }

  List<ChatToolAction> _enabledChatToolActions() {
    final runtime = widget.runtime;
    final moduleActions = runtime == null
        ? const <ChatToolAction>[]
        : runtime.registry
              .enabledFeatures(kind: FeatureKind.composerPanelItem)
              .map((feature) => feature.value)
              .whereType<ChatToolAction>();
    return filterChatToolActionsForModules(
      mergeChatToolActions(coreChatToolActions, moduleActions),
      isModuleEnabled: (moduleId) =>
          widget.runtime?.isModuleEnabled(moduleId) ?? false,
    );
  }

  void _showFavoriteModuleFallback() {
    if (mounted) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
    }
  }

  void _clearMessages() {
    widget.onClearMessages();
    setState(() {
      _messages = [];
      _actionMessage = null;
      _replyTo = null;
      _actionNotice = null;
      _showMorePanel = false;
      _showEmojiPanel = false;
      _showVoicePanel = false;
    });
  }

  /// 远端 / 跨设备 / 同设备会话列表清空 → SDK clearWithChannel →
  /// service emit channelClearedSignals → 这里只在 channel 匹配当前
  /// 打开会话时清自己的 _messages. 不匹配的事件 (其它 channel 被清)
  /// 由 HomeShell 的 _handleChannelCleared 处理.
  void _handleChannelClearedInChat(WukongChannelClearedSignal signal) {
    if (!mounted) return;
    if (signal.channelId != widget.conversation.channelId ||
        signal.channelType != widget.conversation.channelType) {
      return;
    }
    if (_messages.isEmpty) return;
    setState(() {
      _messages = [];
      _actionMessage = null;
      _replyTo = null;
      _actionNotice = null;
      _showMorePanel = false;
      _showEmojiPanel = false;
      _showVoicePanel = false;
    });
  }

  /// 单条消息删除 (撤回 / 跨设备 sync) → SDK addOnDeleteMsgListener
  /// → 按 clientMsgNo 从 _messages 移除. 已经移除过的或不在当前列表
  /// 的视为 no-op.
  void _handleMessageDeletedInChat(String clientMsgNo) {
    if (!mounted || clientMsgNo.isEmpty) return;
    final next = _messages
        .where((m) => m.clientMsgNo != clientMsgNo)
        .toList(growable: false);
    if (next.length == _messages.length) return;
    setState(() => _messages = List.of(next));
  }

  void _handleAguiEvent(WukongAguiEventSnapshot event) {
    if (!mounted) return;
    if (event.channelId != widget.conversation.channelId ||
        event.channelType != widget.conversation.channelType) {
      return;
    }
    final next = mergeAguiStreamEvent(_messages, event);
    if (identical(next, _messages)) return;
    setState(() => _messages = next);
    _scrollMessagesToBottom();
  }

  void _handleChatToolAction(ChatToolAction action) {
    setState(() {
      _actionMessage = null;
      _actionNotice = null;
      _showEmojiPanel = false;
      _showVoicePanel = false;
    });

    final moduleHandler = action.onSelected;
    if (moduleHandler != null) {
      unawaited(
        Future<void>.sync(() => moduleHandler(_chatToolActionContext())),
      );
      return;
    }

    switch (action.id) {
      case ModuleActionIds.composerAlbum:
        unawaited(_pickAndSendFromGallery());
      case ModuleActionIds.composerCamera:
        unawaited(_pickAndSendFromCamera());
      case ModuleActionIds.composerContactCard:
        unawaited(_selectAndSendContactCard());
      default:
        final t = AppLocalizations.of(context);
        setState(
          () => _actionNotice = t.chatToolSelected(
            chatToolActionTitle(t, action),
          ),
        );
    }
  }

  ChatToolActionContext _chatToolActionContext() {
    return ChatToolActionContext(
      buildContext: context,
      pushPage: (page) => pushPage(context, page),
      pickAndSendFile: () => _pickAndSendMedia(ChatMediaKind.file),
      sendLocation: _sendLocation,
      openAudioCall: () => _openCallFromComposer(ChatCallType.audio),
      openVideoCall: () => _openCallFromComposer(ChatCallType.video),
    );
  }

  Future<void> _openCallFromComposer(ChatCallType type) async {
    if (widget.conversation.channelType == WKChannelType.group) {
      await _openGroupCall(type);
    } else {
      _openCall(type);
    }
  }

  Future<void> _selectAndSendContactCard() async {
    final contact = await Navigator.of(context).push<UiContact>(
      MaterialPageRoute(
        builder: (_) => ContactCardPickerPage(contacts: widget.contacts),
      ),
    );
    if (!mounted || contact == null) {
      return;
    }
    _sendContactCard(contact);
  }

  void _sendContactCard(UiContact contact) {
    final gateway = widget.imGateway;
    if (gateway == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatImDisconnected,
      );
      return;
    }
    // 走真正的 card content type (WK_CARD=7), 不再发 text "[名片] xxx".
    // 之前误用 ChatMessage.right(text) 让发出去的是 text 类型, 收方
    // 渲染成普通文本气泡 (跟 iOS 双端 hidden bubble card cell 不一致).
    // 现在 contentType=7 + cardUid + cardName, 走 Bubble.isCardMessage
    // 分支 → CardBubble.
    final text = AppLocalizations.of(context).chatCardDigest(contact.name);
    final message = ChatMessage.right(
      text,
      status: '发送中',
      timestamp: nowSeconds(),
      contentType: 7,
      cardUid: contact.uid,
      cardName: contact.name,
      cardVercode: contact.vercode,
    );
    setState(() {
      _messages.add(message);
      _liveAppendsCount += 1;
      _replyTo = null;
      _showMorePanel = false;
      _actionNotice = null;
    });
    unawaited(
      _sendMessage(
        message,
        () => gateway.sendCard(
          channelId: widget.conversation.channelId,
          channelType: widget.conversation.channelType,
          cardUid: contact.uid,
          cardName: contact.name,
          vercode: contact.vercode,
        ),
      ),
    );
    _scrollMessagesToBottom();
  }

  Future<void> _startVoiceRecording() async {
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatMediaServiceUnavailable,
      );
      return;
    }
    try {
      await gateway.startVoiceRecording();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _actionNotice = error.toString());
      rethrow;
    }
  }

  Future<void> _stopAndSendVoice() async {
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatMediaServiceUnavailable,
      );
      return;
    }
    final picked = await gateway.stopVoiceRecording();
    if (picked == null) {
      return;
    }
    _queueMediaMessage(picked, gateway, closeVoicePanel: true);
  }

  Future<void> _cancelVoiceRecording() async {
    await widget.mediaGateway?.cancelVoiceRecording();
    if (!mounted) {
      return;
    }
    setState(() {
      _showVoicePanel = false;
      _actionNotice = null;
    });
  }

  /// `snapshotPath` = picker takeSnapshot 拿到的 mini-map JPEG 临时文件路径
  /// (null = 截图失败兜底, 走无 preview 路径). 跟 iOS 原版 WKLocationCell.
  /// mapImgView 同模式: 上传 server → URL 填进 location.imageUrl, 接收方
  /// 气泡 preview 用 CachedNetworkImage 渲染. 上传是 best-effort, 失败
  /// 不阻塞 IM send (= 用户至少看到 title/address 文本卡片).
  void _sendLocation(ChatLocation location, String? snapshotPath) {
    final text = location.displayText;
    final message = ChatMessage.right(
      text,
      status: '发送中',
      timestamp: nowSeconds(),
      // Stamp contentType + location metadata so the optimistic
      // bubble renders via `LocationBubble` immediately. Without
      // these the row would show a plain text bubble until the SDK
      // snapshot round-trips back.
      contentType: 6,
      locationLat: location.latitude,
      locationLng: location.longitude,
      locationTitle: location.title,
      locationAddress: location.address,
      locationImageUrl: location.imageUrl,
    );
    setState(() {
      _messages.add(message);
      _liveAppendsCount += 1;
      _replyTo = null;
      _showMorePanel = false;
      _actionNotice = null;
    });
    unawaited(
      _sendMessage(message, () async {
        // 1. 先 await 上传 snapshot 拿 URL — 必须在 SDK send 之前完成,
        //    因为 WKLocationContent.encodeJson 时已经把 url 字段写进 IM
        //    payload, send 后无法 update. 上传失败则 location.imageUrl
        //    保留空 (= 接收方 fallback 占位图, iOS 原版同模式).
        ChatLocation finalLocation = location;
        final mediaGateway = widget.mediaGateway;
        if (snapshotPath != null &&
            snapshotPath.isNotEmpty &&
            mediaGateway != null) {
          try {
            final att = ChatMediaAttachment(
              kind: ChatMediaKind.image,
              localPath: snapshotPath,
              fileName: snapshotPath.split('/').last,
            );
            final uploaded = await mediaGateway.uploadAttachment(
              channelId: widget.conversation.channelId,
              channelType: widget.conversation.channelType,
              attachment: att,
            );
            if (uploaded.remoteUrl.isNotEmpty) {
              finalLocation = ChatLocation(
                title: location.title,
                address: location.address,
                latitude: location.latitude,
                longitude: location.longitude,
                imageUrl: uploaded.remoteUrl,
              );
              // 把 imageUrl propagate 回本地 optimistic message, 这样
              // 自己气泡 preview 区域也能立刻显示真实小地图 (接收方走
              // SDK 推回的 IM payload, 这里只更新 sender 本地).
              final ready = message.copyWith(
                locationImageUrl: uploaded.remoteUrl,
              );
              _replaceMessage(message, ready);
            }
          } catch (e) {
            debugPrint('[sendLocation] snapshot upload failed: $e');
            // 兜底: finalLocation 保留无 imageUrl, IM send 仍然进行.
          }
        }

        // 2. SDK send (encodeJson 自动用 finalLocation.imageUrl 填 img 字段).
        await widget.imGateway?.sendLocation(
          channelId: widget.conversation.channelId,
          channelType: widget.conversation.channelType,
          location: finalLocation,
        );
        await widget.onSendLocation(finalLocation);
      }),
    );
    _scrollMessagesToBottom();
  }

  void _sendSticker(ChatSticker sticker) {
    // 本地 echo 走 rightMedia(kind: sticker, attachment) 让 _StickerBubbleContent
    // 立刻渲染贴图气泡, 不是 .right(text) 派发到 text 气泡. 之前 .right 默认
    // kind=file → 12430 派发 if (kind==sticker) 永远走不到 → 渲染成 text 气泡
    // 一闪 (内容把 sticker.placeholder 当 SVG raw) →
    // 等 server snapshot round-trip 回来才被替换成真贴图. 跟 location/card
    // (5494/5410) 同 pattern, 跟 _queueMediaMessage (6105) 黄金标准对齐.
    final rawPath = sticker.path;
    final remoteUrl = rawPath.isEmpty
        ? ''
        : (rawPath.startsWith('http')
              ? rawPath
              : widget.config.showUrl(rawPath));
    final attachment = ChatMediaAttachment(
      kind: ChatMediaKind.sticker,
      localPath: '',
      fileName: '',
      remoteUrl: remoteUrl,
      width: sticker.width,
      height: sticker.height,
    );
    final message = ChatMessage.rightMedia(
      stickerDisplayText(AppLocalizations.of(context), sticker),
      kind: ChatMediaKind.sticker,
      fileName: '',
      attachment: attachment,
      status: '发送中',
      timestamp: nowSeconds(),
    );
    setState(() {
      _messages.add(message);
      _liveAppendsCount += 1;
      _replyTo = null;
      _showEmojiPanel = false;
      _actionNotice = null;
    });
    unawaited(
      _sendMessage(message, () async {
        await widget.imGateway?.sendSticker(
          channelId: widget.conversation.channelId,
          channelType: widget.conversation.channelType,
          sticker: sticker,
        );
        await widget.onSendSticker(sticker);
      }),
    );
    _scrollMessagesToBottom();
  }

  String _bubbleSenderLabel(ChatMessage message, ChatConversation conv) {
    final displayName = _senderName(message);
    if (displayName.isNotEmpty &&
        displayName != AppLocalizations.of(context).chatSelfName) {
      return displayName.characters.first;
    }
    final fromUid = message.fromUid;
    if (fromUid.isNotEmpty) {
      // Look up the sender in the loaded contact list. If absent, keep the
      // avatar neutral instead of leaking the uid's first character.
      for (final contact in widget.contacts) {
        if (contact.uid == fromUid) {
          return contact.avatarLabel;
        }
      }
      return AppLocalizations.of(context).chatFriendAvatarFallback;
    }
    return conv.avatarLabel;
  }

  String _bubbleSenderAvatar(ChatMessage message, ChatConversation conv) {
    // Personal chat: use the conversation's avatar (the peer).
    // Group chat: use the message sender's individual avatar so each bubble
    // shows the actual person who sent it instead of the group composite.
    if (conv.channelType != WKChannelType.group) {
      return message.fromAvatarUrl.isNotEmpty
          ? message.fromAvatarUrl
          : conv.avatarPath;
    }
    return message.fromAvatarUrl;
  }

  List<Color> _bubbleSenderColors(ChatMessage message, ChatConversation conv) {
    final fromUid = message.fromUid;
    if (fromUid.isEmpty) {
      return conv.colors;
    }
    final hash = fromUid.codeUnits.fold<int>(0, (a, b) => a + b);
    return MoyuAvatarGradients.at(hash);
  }

  /// 群聊对方消息的头像 / 名字参数, 给独立 bubble widget (位置 / 合并转发 /
  /// 未知) 传入 MoyuPeerBubbleFrame。streak 末条显头像、首条显名字; 1v1 或
  /// 自己消息返回空槽 (hasAvatarSlot=false)。i 是 _messages 索引。
  ({
    bool hasAvatarSlot,
    bool showAvatar,
    String avatarUrl,
    String avatarLabel,
    List<Color> avatarColors,
    String senderName,
  })
  _peerBubbleArgs(ChatMessage message, int i) {
    if (!_isGroupChat || message.isMine) {
      return (
        hasAvatarSlot: false,
        showAvatar: false,
        avatarUrl: '',
        avatarLabel: '',
        avatarColors: const <Color>[],
        senderName: '',
      );
    }
    final isStreakStart = !isSameLeftMessageStreak(
      _messages,
      i,
      previousVisibleMessageIndex(_messages, i),
    );
    final isStreakEnd = !isSameLeftMessageStreak(
      _messages,
      i,
      nextVisibleMessageIndex(_messages, i),
    );
    return (
      hasAvatarSlot: true,
      showAvatar: isStreakEnd,
      avatarUrl: _bubbleSenderAvatar(message, widget.conversation),
      avatarLabel: _bubbleSenderLabel(message, widget.conversation),
      avatarColors: _bubbleSenderColors(message, widget.conversation),
      senderName: isStreakStart ? _senderName(message) : '',
    );
  }

  /// True for messages whose content type isn't recognized by this
  /// client build — typically a newer message format the server has
  /// rolled out before this version was released. Mirrors native iOS
  /// WKUnkownMessageCell which prompts the user to upgrade.
  bool _isUnknownContent(ChatMessage message) {
    if (message.isSystemMessage) return false;
    if (message.isCallMessage) return false;
    if (message.isGroupInviteApproval) return false;
    if (message.isCardMessage) return false;
    if (message.revoked) return false;
    if (message.contentType == 0) return false;
    // Recognized non-system content types we render natively.
    const known = <int>{
      1, // text (WkMessageContentType.text)
      2, // image
      3, // voice
      4, // card (handled above)
      5, // file
      6, // video
      7, // multi-merge (rendered as text fallback for now)
      9, // sticker
      11, // gif
      12, // lottie sticker
      13, // emoji sticker
    };
    if (known.contains(message.contentType)) return false;
    if (message.kind != ChatMediaKind.file) return false;
    return message.text.isEmpty || message.text == '[未知]';
  }

  /// Tracks in-flight stranger-profile fetches keyed by uid so a
  /// double-tap on a card bubble doesn't fire two `users/<uid>` GETs.
  /// Cleared once the fetch resolves (success or error).
  final Set<String> _strangerProfileFetches = <String>{};

  /// Open the contact profile for a card-message tap (or any other
  /// uid-keyed jump like a mention-tap stranger fallback). Resolution
  /// order mirrors native iOS `WKChannelInfoVC` opener:
  ///   1. Already a friend → push `ContactDetailPage` from
  ///      `widget.contacts`. Synchronous, no network.
  ///   2. Stranger → fetch `socialGateway.getUserInfo(uid)`. While
  ///      the request is in flight surface a brief 加载中 notice so
  ///      the user knows something's happening on slow networks.
  ///      On success build a synthetic `UiContact` (uid-hash keyed
  ///      avatar colors via `MoyuAvatarGradients.at`) and push the
  ///      detail page.
  ///   3. Fetch fails / no social gateway → neutral toast. uid stays an
  ///      internal lookup key and must not be rendered.

  /// 长按消息 menu "N 人回应" 触发 — push 点赞人列表页. 对齐 iOS
  /// WKAdvancedModule.m:108-112 WKReactionsListVC: 接 message.reactions
  /// per-user list (含 uid + name + emoji), tap row → push 用户名片.
  Future<void> _openReactionUsersList(ChatMessage message) async {
    if (message.messageId.isEmpty) return;
    final users =
        await widget.imGateway?.queryReactionUsers(message.messageId) ??
        const [];
    if (!mounted) return;
    unawaited(
      pushPage(
        context,
        ReactionReactorListPage(
          reactionUsers: users,
          config: widget.config,
          onTapUser: (uid, _) => unawaited(_openCardProfile(uid)),
        ),
      ),
    );
  }

  /// 长按消息 menu "N 人已读" 触发 — push 已读/未读列表页. 对齐 iOS
  /// WKAdvancedModule.m:79-87 WKReceiptListVC: 接 messageId + channel +
  /// readedCount/unreadCount, page 内 2 tab (已读/未读) 各 GET /receipt 拉
  /// per-user list, tap row → push 用户名片. 仅自己发的消息 + readedCount>0
  /// 时显 menu item (gating 在 messageActionsFor).
  Future<void> _openReceiptList(ChatMessage message) async {
    if (message.messageId.isEmpty) return;
    final gateway = widget.imGateway;
    if (gateway == null) return;
    unawaited(
      pushPage(
        context,
        ReceiptListPage(
          messageId: message.messageId,
          channelId: widget.conversation.channelId,
          channelType: widget.conversation.channelType,
          initialReadedCount: message.readedCount,
          initialUnreadCount: message.unreadCount,
          gateway: gateway,
          config: widget.config,
          onTapUser: (uid, _) => unawaited(_openCardProfile(uid)),
        ),
      ),
    );
  }

  Future<void> _openCardProfile(String uid) async {
    final normalized = uid.trim();
    if (normalized.isEmpty) return;
    for (final c in widget.contacts) {
      if (c.uid == normalized) {
        unawaited(
          pushPage(
            context,
            ContactDetailPage(
              contact: c,
              loginUid: widget.loginUid,
              loginName: widget.loginName,
              callGateway: widget.callGateway,
              socialGateway: widget.socialGateway,
              imGateway: widget.imGateway,
              config: widget.config,
              onContactRemoved: widget.onContactRemoved,
              onOpenChat: (target) async {
                if (!mounted) return;
                if (target.uid == widget.conversation.channelId) return;
                // 接通: 有 onOpenContactChat 就 push 目标会话 (叠在当前聊天页上,
                // 返回键回原会话); 没接则降级旧提示.
                final opener = widget.onOpenContactChat;
                if (opener != null) {
                  await opener(target);
                  return;
                }
                setState(
                  () => _actionNotice = AppLocalizations.of(
                    context,
                  ).chatOpenFromContacts(target.name),
                );
              },
            ),
          ),
        );
        return;
      }
    }

    final gateway = widget.socialGateway;
    if (gateway == null) {
      if (mounted) {
        setState(
          () => _actionNotice = moyuProfileFallbackNotice(
            rawIdentity: normalized,
          ),
        );
      }
      return;
    }
    if (_strangerProfileFetches.contains(normalized)) return;
    _strangerProfileFetches.add(normalized);
    if (mounted) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatLoadingCard,
      );
    }
    try {
      final fetched = await gateway.getUserInfo(normalized);
      if (!mounted) return;
      if (fetched == null || fetched.uid.isEmpty) {
        setState(
          () => _actionNotice = moyuProfileFallbackNotice(
            rawIdentity: normalized,
            notFound: true,
          ),
        );
        return;
      }
      final hash = fetched.uid.codeUnits.fold<int>(0, (a, b) => a + b);
      final colors = MoyuAvatarGradients.at(hash);
      final stranger = UiContact.fromSocial(
        fetched,
        colors: colors,
        config: widget.config,
      );
      setState(() => _actionNotice = null);
      unawaited(
        pushPage(
          context,
          ContactDetailPage(
            contact: stranger,
            loginUid: widget.loginUid,
            loginName: widget.loginName,
            callGateway: widget.callGateway,
            socialGateway: widget.socialGateway,
            imGateway: widget.imGateway,
            config: widget.config,
            onContactRemoved: widget.onContactRemoved,
            // 非联系人 → stranger 模式: 底部显示「申请添加」(加好友), 不是
            // 「发消息」。陌生人本就该先加好友才能聊天, 不能直接打开会话
            // (对齐 iOS isStranger 分支 + ContactDetailPage bottomSticky)。
            // 修「点别人(非联系人)发的名片错显示发消息且报错去通讯录」bug。
            isStranger: true,
            // stranger 模式不渲染发消息按钮, onOpenChat 不会触发; 空实现满足
            // required 参数。
            onOpenChat: (_) async {},
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => _actionNotice = moyuProfileFallbackNotice(
            rawIdentity: normalized,
          ),
        );
      }
    } finally {
      _strangerProfileFetches.remove(normalized);
    }
  }

  void _openImagePreview(ChatMessage message) {
    ImageLightbox.show(
      context,
      message: message,
      // Lightbox 内 "..." 按钮 → 弹 [保存到相册 / 识别二维码 / 添加到表情]
      // 3 个图片相关 action (跟 iOS WKImageBrowser 长按图弹 ActionSheet 同
      // 模式 — 之前错放在气泡长按, 现在改回 lightbox 内).
      onSaveToAlbum: () => unawaited(_saveImageToAlbum(message)),
      onRecognizeQrcode: () => unawaited(_resolveImageQrcode(message)),
      onAddToStickers: () => unawaited(_addImageToStickers(message)),
    );
  }

  /// Open the fullscreen video player on tap. Resolves the playback URL
  /// in this priority order (matches the bubble cover-render fallback):
  ///   1. remote URL from the attachment (server-uploaded video) —
  ///      passed with the session `token` header for the auth-gated
  ///      /file/upload CDN paths.
  ///   2. local path (just-recorded outgoing video pending upload) —
  ///      _VideoPlayerPage detects this and uses VideoPlayerController.file
  /// Empty URL → toast, otherwise push the player page.
  /// 文件消息点击 — 对齐 iOS WKFileCell.onTap → push WKFileInfoVC.
  /// 跟 _openVideoPlayback 同 pattern: 远程 URL 走 config.showUrl
  /// resolve 成绝对地址 + 透传 loginToken 用作鉴权.
  void _openFileInfo(ChatMessage message) {
    final attachment = message.attachment;
    if (attachment == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatFileMissing,
      );
      return;
    }
    final raw = attachment.remoteUrl.trim();
    final resolvedUrl = raw.isEmpty ? '' : widget.config.showUrl(raw);
    final feature = _runtime?.registry.featureById(
      ModuleFeatureIds.fileInfoPageBuilder,
    );
    final builder = feature?.value;
    if (feature == null ||
        _runtime?.registry.isModuleEnabled(feature.moduleId) != true ||
        builder is! ModuleFileInfoPageBuilder) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).moduleUnsupported,
      );
      return;
    }
    unawaited(
      pushPage(
        context,
        builder(
          fileName: attachment.fileName,
          fileSize: attachment.fileSize,
          localPath: attachment.localPath,
          remoteUrl: resolvedUrl,
          token: resolvedUrl.isEmpty ? '' : widget.loginToken,
        ),
      ),
    );
  }

  void _openVideoPlayback(ChatMessage message) {
    final attachment = message.attachment;
    if (attachment == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatVideoUnavailable,
      );
      return;
    }
    final isRemote = attachment.remoteUrl.trim().isNotEmpty;
    final url = isRemote
        ? widget.config.showUrl(attachment.remoteUrl.trim())
        : attachment.localPath.trim();
    if (url.isEmpty) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatVideoSourceEmpty,
      );
      return;
    }
    final feature = _runtime?.registry.featureById(
      ModuleFeatureIds.videoPlayerPageBuilder,
    );
    final builder = feature?.value;
    if (feature == null ||
        _runtime?.registry.isModuleEnabled(feature.moduleId) != true ||
        builder is! ModuleVideoPlayerPageBuilder) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).moduleUnsupported,
      );
      return;
    }
    pushPage(
      context,
      builder(url: url, token: isRemote ? widget.loginToken : ''),
    );
  }

  /// Live Photo 点击 → 全屏 viewer, 静态图 + 自动播放 paired MOV 一次 (含声音).
  /// 没 paired MOV (iCloud 没下完整 / 字段空) 时降级显示纯静态图.
  void _openLivePhotoPlayback(ChatMessage message) {
    final attachment = message.attachment;
    if (attachment == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatLivePhotoUnavailable,
      );
      return;
    }
    final stillRaw = attachment.remoteUrl.trim();
    final stillLocal = attachment.localPath.trim();
    final stillUrl = stillRaw.isNotEmpty
        ? widget.config.showUrl(stillRaw)
        : stillLocal;
    final videoRaw = attachment.livePhotoVideoUrl.trim();
    final videoLocal = attachment.livePhotoVideoLocalPath.trim();
    final isVideoRemote = videoRaw.isNotEmpty;
    final videoUrl = isVideoRemote
        ? widget.config.showUrl(videoRaw)
        : videoLocal;
    final feature = _runtime?.registry.featureById(
      ModuleFeatureIds.livePhotoViewerPageBuilder,
    );
    final builder = feature?.value;
    if (feature == null ||
        _runtime?.registry.isModuleEnabled(feature.moduleId) != true ||
        builder is! ModuleLivePhotoViewerPageBuilder) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).moduleUnsupported,
      );
      return;
    }
    pushPage(
      context,
      builder(
        stillUrl: stillUrl,
        videoUrl: videoUrl,
        token: (stillRaw.isNotEmpty || isVideoRemote) ? widget.loginToken : '',
      ),
    );
  }

  /// Auto-advance resolver: given the playback key of the voice that
  /// just finished, find the next unread voice message in the chat
  /// after it and return its (key, source). Returns null when no
  /// further unread voice exists OR when a stop-the-chain rule fires
  /// — mirrors the native iOS `iteraPlayVoice` recursion in
  /// `WKVoiceMessageCell`. Stop rules (voice-continuous-flow.md
  /// §2.3):
  ///   * Different sender (`fromUid` differs from finished voice).
  ///     The chain only auto-plays the SAME peer's contiguous run.
  ///   * Any non-voice / non-peer / heard-or-revoked gap encountered
  ///     ends the chain (we don't skip past it).
  Future<({String key, Source source})?> _resolveNextVoice(
    String finishedKey,
  ) async {
    final finishedIdx = _messages.indexWhere(
      (m) => _messagePlaybackKey(m) == finishedKey,
    );
    if (finishedIdx < 0) return null;
    final chainSenderUid = _messages[finishedIdx].fromUid;
    for (var i = finishedIdx + 1; i < _messages.length; i++) {
      final m = _messages[i];
      // Stop the chain — don't skip past — when any of these fire.
      // This is what makes it a "chain": only the same peer's
      // contiguous run of voice messages plays; interruptions
      // (own message, different sender, non-voice) end it.
      if (m.kind != ChatMediaKind.voice) return null;
      if (m.isMine) return null;
      if (chainSenderUid.isNotEmpty && m.fromUid != chainSenderUid) {
        return null;
      }
      if (m.revoked) return null;
      // Already-played voices skip silently — `unread A → heard B
      // → unread C` from the same peer should still chain to C.
      // Spec voice-continuous-flow.md §6 P1 sample explicitly
      // `continue`s on heard voices.
      if (m.readed) continue;
      if (m.voiceStatus == 1) continue;
      if (m.messageId.isNotEmpty &&
          _locallyHeardVoiceIds.contains(m.messageId)) {
        continue;
      }
      // Unplayable voice (missing attachment / resolved source)
      // ENDS the chain rather than skipping past — otherwise
      // playback would jump over a failed voice and silently mark
      // a later one as read, hiding the failure from the user.
      final attachment = m.attachment;
      if (attachment == null) return null;
      final source = await _resolveVoiceSource(attachment);
      if (source == null) return null;
      final key = _messagePlaybackKey(m);
      if (key.isEmpty) continue;
      // Mark the next as read since we're about to play it.
      if (m.messageId.isNotEmpty) {
        unawaited(
          widget.imGateway?.markVoiceMessageRead(
                WukongMessageReference(
                  messageId: m.messageId,
                  messageSeq: m.messageSeq,
                  clientMsgNo: m.clientMsgNo,
                  channelId: widget.conversation.channelId,
                  channelType: widget.conversation.channelType,
                ),
              ) ??
              Future<void>.value(),
        );
        // Also clear the local unread red dot for the auto-advance
        // path so it matches the manual `_playVoice` behavior.
        // Without this, letting voice messages auto-chain leaves
        // their red dots behind even after server-side flip lands.
        if (mounted) {
          setState(() {
            _locallyHeardVoiceIds.add(m.messageId);
          });
        }
      }
      return (key: key, source: source);
    }
    return null;
  }

  /// Stable identifier for binding a voice bubble to the global player —
  /// prefer the server message id, fall back to the local clientMsgNo so a
  /// just-sent voice (still pending ack) can play before the id arrives.
  String _messagePlaybackKey(ChatMessage message) {
    if (message.messageId.isNotEmpty) return message.messageId;
    return message.clientMsgNo;
  }

  String _messageAiKey(ChatMessage message) {
    if (message.messageId.isNotEmpty) return 'm:${message.messageId}';
    return 'c:${message.clientMsgNo}';
  }

  Widget? _voiceAiActionFor(ChatMessage message, {required bool disabled}) {
    final gateway = _messageAiGateway;
    if (!shouldShowVoiceTranscribeAction(
      disabled: disabled,
      isMine: message.isMine,
      kind: message.kind,
      revoked: message.revoked,
      messageId: message.messageId,
      moduleAvailable: gateway != null,
    )) {
      return null;
    }
    final state = _messageAiStates[_messageAiKey(message)];
    final hasText = state?.transcript.trim().isNotEmpty == true;
    return VoiceTranscribeButton(
      loading: state?.transcribing == true,
      done: hasText,
      onTap: hasText ? null : () => unawaited(_transcribeVoiceMessage(message)),
    );
  }

  Widget? _messageAiAddonFor(ChatMessage message) {
    final state = _messageAiStates[_messageAiKey(message)];
    final transcript = state?.transcript.trim() ?? '';
    final translation = state?.translation.trim() ?? '';
    if (transcript.isNotEmpty) {
      return MessageAiResultPanel(text: transcript);
    }
    if (translation.isNotEmpty) {
      return MessageAiResultPanel(text: '', translation: translation);
    }
    if (state?.translating == true) {
      return MessageAiResultPanel(
        text: AppLocalizations.of(context).messageAiTranslating,
      );
    }
    return null;
  }

  String _messageAiLanguageCode() {
    final controller = context
        .dependOnInheritedWidgetOfExactType<LocaleController>();
    return messageAiLanguageCode(
      preference: controller?.current ?? LocaleStore.systemPreference,
      effectiveLanguageCode:
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'zh',
    );
  }

  Future<void> _transcribeVoiceMessage(ChatMessage message) async {
    final gateway = _messageAiGateway;
    if (gateway == null) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      return;
    }
    if (message.messageId.isEmpty) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).messageAiVoiceSendingWait,
      );
      return;
    }
    final key = _messageAiKey(message);
    final current = _messageAiStates[key] ?? const _MessageAiUiState();
    if (current.transcribing) return;
    setState(() {
      _messageAiStates[key] = current.copyWith(
        transcribing: true,
        errorMessage: '',
      );
    });
    try {
      final result = await gateway.transcribe(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        messageId: message.messageId,
        messageSeq: message.messageSeq,
        sourceLanguage: _messageAiLanguageCode(),
      );
      if (!mounted) return;
      if (!result.succeeded) {
        throw StateError(
          result.errorMessage.trim().isEmpty
              ? AppLocalizations.of(context).messageAiNoTranscript
              : result.errorMessage.trim(),
        );
      }
      setState(() {
        _messageAiStates[key] =
            (_messageAiStates[key] ?? const _MessageAiUiState()).copyWith(
              transcribing: false,
              transcript: result.text.trim(),
              sourceLanguage: result.sourceLanguage.trim(),
              errorMessage: '',
            );
      });
    } catch (e) {
      if (!mounted) return;
      final messageText = messageAiFailureText(
        e,
        fallback: AppLocalizations.of(context).messageAiTemporarilyUnavailable,
      );
      setState(() {
        _messageAiStates[key] =
            (_messageAiStates[key] ?? const _MessageAiUiState()).copyWith(
              transcribing: false,
              errorMessage: messageText,
            );
      });
      MoyuToast.show(context, messageText);
    }
  }

  Future<void> _translateTextMessage(ChatMessage message) async {
    final gateway = _messageAiGateway;
    if (gateway == null) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      return;
    }
    if (message.messageId.isEmpty) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).messageAiMessageSendingWait,
      );
      return;
    }
    final sourceText = message.text.trim();
    if (sourceText.isEmpty) return;
    final key = _messageAiKey(message);
    final current = _messageAiStates[key] ?? const _MessageAiUiState();
    if (current.translating) return;
    setState(() {
      _messageAiStates[key] = current.copyWith(
        translating: true,
        errorMessage: '',
      );
    });
    try {
      final result = await gateway.translate(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        messageId: message.messageId,
        text: sourceText,
        sourceLanguage: 'auto',
        targetLanguage: _messageAiLanguageCode(),
      );
      if (!mounted) return;
      if (!result.succeeded) {
        throw StateError(
          result.errorMessage.trim().isEmpty
              ? AppLocalizations.of(context).messageAiNoTranslation
              : result.errorMessage.trim(),
        );
      }
      setState(() {
        _messageAiStates[key] =
            (_messageAiStates[key] ?? const _MessageAiUiState()).copyWith(
              translating: false,
              translation: result.text.trim(),
              sourceLanguage: result.sourceLanguage.trim(),
              errorMessage: '',
            );
      });
    } catch (e) {
      if (!mounted) return;
      final messageText = messageAiFailureText(
        e,
        fallback: AppLocalizations.of(context).messageAiTemporarilyUnavailable,
      );
      setState(() {
        _messageAiStates[key] =
            (_messageAiStates[key] ?? const _MessageAiUiState()).copyWith(
              translating: false,
              errorMessage: messageText,
            );
      });
      MoyuToast.show(context, messageText);
    }
  }

  /// Resolve an audioplayers [Source] for a voice attachment.
  ///
  /// Local file (the just-recorded path on the sender) wins; otherwise the
  /// remote URL is downloaded through the *authenticated* ApiClient and
  /// cached on disk, then played as a [DeviceFileSource]. We avoid
  /// [UrlSource] for remote audio because audioplayers' MediaPlayer can't
  /// attach the `token` header the server requires for `file/upload`-served
  /// URLs (causes Android `MEDIA_ERROR_UNKNOWN` on play).
  Future<Source?> _resolveVoiceSource(ChatMediaAttachment attachment) async {
    final localPath = attachment.localPath.trim();
    if (localPath.isNotEmpty && File(localPath).existsSync()) {
      return DeviceFileSource(localPath);
    }
    final remote = attachment.remoteUrl.trim();
    if (remote.isEmpty) return null;
    final absoluteUrl =
        remote.startsWith('http://') || remote.startsWith('https://')
        ? remote
        : widget.config.showUrl(remote);
    final cached = await widget.mediaGateway?.downloadToCache(
      url: absoluteUrl,
      filename: 'voice_${absoluteUrl.hashCode.abs()}.m4a',
    );
    if (cached != null) {
      return DeviceFileSource(cached.path);
    }
    // Last-ditch: try plain network — typically 401 if the server requires
    // auth, but at least we surface a usable error path.
    return UrlSource(absoluteUrl);
  }

  Future<void> _playVoice(ChatMessage message) async {
    final attachment = message.attachment;
    if (attachment == null) {
      if (mounted) {
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatVoiceFileUnavailable,
        );
      }
      return;
    }
    final key = _messagePlaybackKey(message);
    if (key.isEmpty) return;
    final source = await _resolveVoiceSource(attachment);
    if (source == null) {
      if (mounted) {
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatVoiceFileUnavailable,
        );
      }
      return;
    }
    // Install / refresh the auto-advance resolver each time a voice is
    // played manually so it always points at this chat's message list.
    VoicePlayer.instance.setAutoAdvanceResolver(
      owner: this,
      resolver: _resolveNextVoice,
    );
    try {
      await VoicePlayer.instance.playOrToggle(key: key, source: source);
      // Voice receipt: report the incoming voice as listened so the sender's
      // bubble gets ✓✓ (mirrors native WKVoiceMessageCell `voiceReaded`).
      // Skip own messages and messages without a remote id.
      if (!message.isMine && message.messageId.isNotEmpty) {
        unawaited(
          widget.imGateway?.markVoiceMessageRead(
                WukongMessageReference(
                  messageId: message.messageId,
                  messageSeq: message.messageSeq,
                  clientMsgNo: message.clientMsgNo,
                  channelId: widget.conversation.channelId,
                  channelType: widget.conversation.channelType,
                ),
              ) ??
              Future<void>.value(),
        );
        // Track locally-heard voice ids so the bubble's red unread
        // dot clears immediately and stays cleared even if a later
        // snapshot refresh comes back with voiceStatus=0 (SDK 1.7.9
        // doesn't carry message_extra.voice_status into WKMsgExtra).
        // The set is OR'd into `voiceUnread` at render time, so
        // every refresh / copyWith path keeps the dot hidden without
        // having to plumb voiceStatus through every constructor.
        if (mounted) {
          setState(() {
            _locallyHeardVoiceIds.add(message.messageId);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(
          () =>
              _actionNotice = AppLocalizations.of(context).chatVoicePlayFailed,
        );
      }
    }
  }

  Future<void> _saveImageToAlbum(ChatMessage message) async {
    final attachment = message.attachment;
    if (attachment == null || attachment.localPath.isEmpty) return;
    try {
      await widget.mediaGateway?.saveImageToAlbum(attachment.localPath);
      if (!mounted) return;
      setState(
        () =>
            _actionNotice = AppLocalizations.of(context).groupImageSavedToAlbum,
      );
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _actionNotice = AppLocalizations.of(context).groupImageSaveFailed,
      );
    }
  }

  Future<void> _resolveImageQrcode(ChatMessage message) async {
    final attachment = message.attachment;
    if (attachment == null || attachment.localPath.isEmpty) return;
    final payload = await widget.scanGateway?.decodeQrImage(
      attachment.localPath,
    );
    if (!mounted) return;
    if (payload == null || payload.isEmpty) {
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatQrcodeNotFound,
      );
      return;
    }
    // Try to resolve through the social gateway to surface native login /
    // friend / group flows. If the result is a web-login confirm, ask the
    // user to grant.
    final scanResult = await widget.socialGateway?.resolveScanResult(payload);
    if (!mounted) return;
    if (scanResult != null && scanResult.type == 'loginConfirm') {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatWebLoginQrcodeDetected(payload),
      );
      await MoyuActionSheet.show(
        context,
        title: AppLocalizations.of(context).chatWebLoginConfirmTitle,
        items: [
          MoyuActionSheetItem(
            title: AppLocalizations.of(context).chatWebLoginConfirmAction,
            onSelected: () async {
              try {
                await widget.socialGateway?.grantWebLogin(scanResult.authCode);
                if (!mounted) return;
                setState(
                  () => _actionNotice = AppLocalizations.of(
                    context,
                  ).chatWebLoginConfirmed,
                );
              } catch (e) {
                if (!mounted) return;
                setState(() => _actionNotice = '$e');
              }
            },
          ),
        ],
      );
      return;
    }
    setState(
      () => _actionNotice = AppLocalizations.of(
        context,
      ).chatQrcodeDetected(payload),
    );
  }

  Future<void> _addImageToStickers(ChatMessage message) async {
    final attachment = message.attachment;
    if (attachment == null) return;
    try {
      final remote = attachment.remoteUrl.isNotEmpty
          ? attachment.remoteUrl
          : attachment.localPath;
      await widget.socialGateway?.addCustomSticker(
        ChatSticker(
          path: remote,
          title: '',
          placeholder: AppLocalizations.of(context).chatStickerPlaceholder,
        ),
      );
      if (!mounted) return;
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatStickerAdded,
      );
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatStickerAddFailed,
      );
    }
  }

  Future<void> _openGroupInviteConfirm(ChatMessage message) async {
    try {
      final groupNo = message.groupInviteGroupNo.isNotEmpty
          ? message.groupInviteGroupNo
          : widget.conversation.channelId;
      final url = await widget.socialGateway?.loadGroupInviteConfirmUrl(
        groupNo: groupNo,
        inviteNo: message.groupInviteNo,
      );
      if (!mounted) {
        return;
      }
      if (url == null || url.isEmpty) {
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatGroupInviteApprovalUrlEmpty,
        );
        return;
      }
      pushPage(
        context,
        PolicyPage(
          title: AppLocalizations.of(context).chatGroupInviteApprovalTitle,
          body: AppLocalizations.of(context).chatGroupInviteApprovalBody,
          url: url,
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatGroupInviteApprovalOpenFailed,
        );
      }
    }
  }

  Future<void> _pickAndSendMedia(
    ChatMediaKind kind, {
    bool camera = false,
  }) async {
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      if (kind == ChatMediaKind.file) {
        pushPage(context, const FilePickerPage());
        return;
      }
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatMediaServiceUnavailable,
      );
      return;
    }
    final picked = switch (kind) {
      ChatMediaKind.image => await gateway.pickImage(camera: camera),
      ChatMediaKind.file => await gateway.pickFile(),
      // 视频走 pickFromCamera 路径 (composer「拍摄」), 不会进到这里;
      // 保留分支让 switch exhaustive.
      ChatMediaKind.video => null,
      // Live Photo 走 pickFromGallery 路径 (composer「相册」), 不会进这里.
      ChatMediaKind.livePhoto => null,
      ChatMediaKind.voice => null,
      ChatMediaKind.sticker => null, // stickers go via sendSticker
    };
    if (picked == null) {
      return;
    }

    _queueMediaMessage(picked, gateway);
  }

  /// composer「拍摄」按钮入口 — 进微信式相机, 用户拍照或录像后回调,
  /// 按 picked.kind (image/video) 走统一的发送流程 (sendMedia 已 wire 全 kind).
  /// 对齐 iOS WKPanelCameraFuncItem.onPressed → WKPhotoBrowser takePhoto:.
  Future<void> _pickAndSendFromCamera() async {
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatMediaServiceUnavailable,
      );
      return;
    }
    final picked = await gateway.pickFromCamera(context);
    if (picked == null) return;
    _queueMediaMessage(picked, gateway);
  }

  /// composer「相册」按钮入口 — 进微信式相册混选 (图片 + 视频),
  /// 按 picked.kind 分发. 对齐 iOS WKMoreItemClickEvent.m:111
  /// WKPhotoBrowser showPreviewWithSender:...allowSelectVideo:YES.
  /// Live Photo 的"保留/关闭 Live 效果"toggle 由 picker 内部处理 (见
  /// LivePhotoTogglePickerDelegate), 这里只关心最终 picked.kind 已经
  /// 是 livePhoto 还是 image.
  Future<void> _pickAndSendFromGallery() async {
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      setState(
        () => _actionNotice = AppLocalizations.of(
          context,
        ).chatMediaServiceUnavailable,
      );
      return;
    }
    final picked = await gateway.pickFromGallery(context);
    if (picked == null) return;
    _queueMediaMessage(picked, gateway);
  }

  void _queueMediaMessage(
    ChatMediaAttachment picked,
    ChatMediaGateway gateway, {
    bool closeVoicePanel = false,
  }) {
    final message = ChatMessage.rightMedia(
      picked.displayText,
      kind: picked.kind,
      fileName: picked.fileName,
      attachment: picked,
      status: '发送中',
      timestamp: nowSeconds(),
    );
    setState(() {
      _messages.add(message);
      _liveAppendsCount += 1;
      _showMorePanel = false;
      if (closeVoicePanel) {
        _showVoicePanel = false;
      }
      _actionNotice = null;
    });
    _scrollMessagesToBottom();
    unawaited(_uploadAndSendMedia(message, picked, gateway));
  }

  Future<void> _uploadAndSendMedia(
    ChatMessage message,
    ChatMediaAttachment picked,
    ChatMediaGateway gateway,
  ) async {
    // Create a per-message progress notifier when we have a stable
    // local id (clientMsgNo). The bubble looks it up by the same key
    // and subscribes via ValueListenableBuilder. setState only fires
    // around create / remove so the message list rebuilds twice per
    // upload, never per progress tick.
    final progressKey = message.clientMsgNo;
    ValueNotifier<double>? progress;
    if (progressKey.isNotEmpty) {
      progress = ValueNotifier<double>(0);
      _uploadProgress[progressKey] = progress;
      if (mounted) setState(() {});
    }
    try {
      debugPrint(
        '[media-send] upload start clientMsgNo=${message.clientMsgNo} kind=${picked.kind}',
      );
      final uploaded = await gateway.uploadAttachment(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        attachment: picked,
        onProgress: progress == null
            ? null
            : (p) {
                if (progress != null) progress.value = p;
              },
      );
      final ready = message.copyWith(attachment: uploaded);
      _replaceMessage(message, ready);
      // Bug fix: do NOT route media through `_sendMessage` (it flips to
      // '已发送' the instant onSendMedia returns; sendWithOption returns right
      // after saveMsg + firing the upload callback, NOT after socket ACK).
      // Keep '发送中' and let the SDK insert+refresh listeners drive the real
      // status. Mirrors iOS where the media spinner clears only on sendack.
      await widget.onSendMedia(uploaded);
      debugPrint('[media-send] sendMedia returned (still 发送中, awaiting ACK)');
    } catch (e, stack) {
      // Capture the actual error so users + logs can see why media send
      // failed. Previously this was silently swallowed which masked
      // upload-API and IM gateway problems.
      debugPrint('[media-send] FAILED before SDK ack: $e\n$stack');
      // Persist the failed media into the SDK DB BEFORE the mounted check.
      // The upload can fail AFTER the user already left the chat (quit while
      // it was still pending → dispose → mounted=false). Persisting is a pure
      // SDK-singleton call that does NOT touch this widget's context/setState,
      // so it is safe post-dispose. If we put it after `if (!mounted) return`
      // (as before), quitting mid-upload dropped the bubble entirely — user
      // report: "断网发图一退出聊天就消失，重进看不到". The insert listener
      // adopts the clientMsgNo onto the orphan bubble (no double bubble); on
      // re-enter loadMessages re-surfaces it as 发送失败 with retry.
      unawaited(
        widget.imGateway?.persistFailedMedia(
              channelId: widget.conversation.channelId,
              channelType: widget.conversation.channelType,
              attachment: picked,
            ) ??
            Future<void>.value(),
      );
      if (!mounted) {
        return;
      }
      _replaceMessage(message, message.copyWith(status: '发送失败'));
      setState(
        () => _actionNotice = AppLocalizations.of(context).chatSendFailed,
      );
    } finally {
      if (progressKey.isNotEmpty) {
        final removed = _uploadProgress.remove(progressKey);
        removed?.dispose();
        if (mounted) setState(() {});
      }
    }
  }

  void _openMergeForwardDetail(ChatMessage message) {
    if (!message.isMergeForwardMessage) return;
    pushPage(
      context,
      MergeForwardDetailPage(
        title: localizedMergeForwardTitle(
          AppLocalizations.of(context),
          message,
        ),
        entries: message.mergeForwardEntries,
      ),
    );
  }

  void _openCall(ChatCallType type) {
    // PIP 通话进行时拦截 — 之前用户最小化后回聊天页又点通话, 新 call
    // 会覆盖 RTC session + connectRoom disconnect 旧 room, 但
    if (_rtcSessionApi?.hasActiveCall() ?? false) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatCallActiveHangupFirst,
      );
      return;
    }
    final callBuilder = _rtcCallPageBuilder;
    if (callBuilder == null) {
      MoyuToast.show(context, AppLocalizations.of(context).chatCallUnsupported);
      return;
    }
    pushPage(
      context,
      callBuilder(
        ModuleCallPageRequest(
          // Use mutable `_conversation` so group name reflects the
          // latest SDK channelInfo snapshot. On Android the IM SDK can
          // hydrate channelName a beat after chat-open, so passing
          // `widget.conversation` (immutable) shows raw channelId until
          // reopen. user-facing: "安卓上不显示群名".
          conversation: _conversation,
          callGateway: widget.callGateway,
          imGateway: widget.imGateway,
          type: type,
          config: widget.config,
          selfUid: widget.loginUid,
          selfName: widget.loginName,
        ),
      ),
    );
  }

  /// Group-conversation call entry. Mirrors iOS WKRTCManager.call:
  /// when channelType==WK_GROUP it switches to Conference mode and
  /// calls delegate `didInviteAtChannel:complete:` to let the UI
  /// collect participant uids before `startCall`. Flutter analogue:
  /// push the multi-select member picker, then push `_CallPage` with
  /// `isGroupCall=true` + the picked contacts so initState routes
  /// through `startGroupCall` instead of `startP2pCall`.
  /// Tap-to-join handler for a contentType=9988 invite row in the
  /// chat screen. The message carries the LiveKit roomId in
  /// `data['room_id']`. We mirror the IncomingCallPage acceptance
  /// path: gateway.acceptGroupCall first (connectRoom + markJoined
  /// + emit connected), THEN push _CallPage with isIncoming=true so
  /// initState skips _startCall and renders the connected UI. If the
  /// caller has already hung up, acceptGroupCall throws (server
  /// returns 4xx / LiveKit refuses) — we surface that as a toast
  /// instead of stranding the user on a dead _CallPage.
  /// One-shot fetch: ask the server whether this group has an active
  /// LiveKit room right now. Result drives the top banner. Called on
  /// chat-open and after a room.hangup CMD to refresh.
  Future<void> _refreshActiveGroupCall() async {
    final gateway = widget.callGateway;
    if (gateway == null) return;
    if (widget.conversation.channelType != WKChannelType.group) return;
    try {
      final active = await gateway.queryActiveGroupCall(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
      );
      if (!mounted) return;
      final newRoomId = active?.roomId ?? '';
      final newCallType = active?.callType ?? 0;
      if (_activeGroupCallRoomId != newRoomId ||
          _activeGroupCallType != newCallType) {
        setState(() {
          _activeGroupCallRoomId = newRoomId;
          _activeGroupCallType = newCallType;
        });
      }
    } catch (_) {
      // Silent — banner just stays in its prior state.
    }
  }

  /// React to RTC call CMDs for the *current* group. invoke → set
  /// the banner roomId; hangup → re-check (might be one of several
  /// participants leaving, or the caller ending the room).
  void _handleRtcCallSignal(IncomingCallEvent event) {
    if (!event.isGroupCall) return;
    if (event.groupChannelId != widget.conversation.channelId) return;
    if (event.kind == IncomingCallKind.invoke && event.roomId.isNotEmpty) {
      if (_activeGroupCallRoomId != event.roomId ||
          _activeGroupCallType != event.callType) {
        setState(() {
          _activeGroupCallRoomId = event.roomId;
          // Use the CMD's call_type so banner-tap below joins as the
          // right modality (video groups were being joined as audio).
          _activeGroupCallType = event.callType;
        });
      }
    } else if (event.kind == IncomingCallKind.hangup) {
      // Could be anyone leaving — re-query truth from server.
      unawaited(_refreshActiveGroupCall());
    }
  }

  /// Banner tap: join the active room (callee path through
  /// acceptGroupCall). Same flow as _joinGroupCallFromInvite but
  /// pulls roomId from banner state instead of a message payload.
  Future<void> _joinActiveGroupCall() async {
    final roomId = _activeGroupCallRoomId;
    if (roomId.isEmpty) return;
    if (_rtcSessionApi?.hasActiveCall() ?? false) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatCallActiveCannotJoinAgain,
      );
      return;
    }
    final callBuilder = _rtcCallPageBuilder;
    if (callBuilder == null) {
      MoyuToast.show(context, AppLocalizations.of(context).chatCallUnsupported);
      return;
    }
    final gateway = widget.callGateway;
    if (gateway == null) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatCallServiceUnavailable,
      );
      return;
    }
    // Pick the modality the room was created with (server returns
    // `call_type`). Previously hardcoded to audio so video groups
    final callType = _activeGroupCallType == 1
        ? ChatCallType.video
        : ChatCallType.audio;
    try {
      await gateway.acceptGroupCall(
        roomId: roomId,
        groupName: _conversation.name,
        type: callType,
      );
    } catch (e) {
      if (!mounted) return;
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatCallJoinFailedEnded,
      );
      // Banner likely stale, refresh.
      unawaited(_refreshActiveGroupCall());
      return;
    }
    if (!mounted) return;
    pushPage(
      context,
      callBuilder(
        ModuleCallPageRequest(
          conversation: _conversation,
          callGateway: gateway,
          imGateway: widget.imGateway,
          type: callType,
          isIncoming: true,
          incomingRoomId: roomId,
          isGroupCall: true,
          knownContacts: _allKnownGroupContacts(),
          config: widget.config,
          selfUid: widget.loginUid,
          selfName: widget.loginName,
        ),
      ),
    );
  }

  Future<void> _openGroupCall(ChatCallType type) async {
    if (_rtcSessionApi?.hasActiveCall() ?? false) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatCallActiveHangupFirst,
      );
      return;
    }
    final callBuilder = _rtcCallPageBuilder;
    if (callBuilder == null) {
      MoyuToast.show(context, AppLocalizations.of(context).chatCallUnsupported);
      return;
    }
    final loginUid = widget.loginUid;
    // _groupMembers is List<ChatContact>; the picker UI takes UiContact.
    // Strip the login user (server rejects self-invite) and wrap each
    // row through UiContact.fromSocial so avatar colors / display names
    // match the rest of the chat UI.
    final candidates = <UiContact>[];
    for (var i = 0; i < _groupMembers.length; i++) {
      final m = _groupMembers[i];
      if (m.uid == loginUid) continue;
      candidates.add(
        UiContact.fromSocial(
          m,
          colors: conversationColors(candidates.length),
          config: widget.config,
        ),
      );
    }
    if (candidates.isEmpty) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).chatGroupNoInviteCandidates,
      );
      return;
    }
    final picked = await Navigator.of(context).push<List<UiContact>>(
      MaterialPageRoute(
        builder: (_) => MoyuContactPickerPage(
          title: type == ChatCallType.video
              ? AppLocalizations.of(context).chatInviteGroupMembersVideo
              : AppLocalizations.of(context).chatInviteGroupMembersAudio,
          contacts: candidates,
          selectedContacts: const [],
        ),
      ),
    );
    if (!mounted || picked == null || picked.isEmpty) return;
    pushPage(
      context,
      callBuilder(
        ModuleCallPageRequest(
          conversation: _conversation,
          callGateway: widget.callGateway,
          imGateway: widget.imGateway,
          type: type,
          isGroupCall: true,
          invitedContacts: picked,
          knownContacts: _allKnownGroupContacts(),
          config: widget.config,
          selfUid: widget.loginUid,
          selfName: widget.loginName,
        ),
      ),
    );
  }

  /// Compose a best-effort uid→contact lookup for group-call participant
  /// tiles. Combines (a) the loaded group roster and (b) the user's
  /// friend list, deduped by uid. Used to translate LiveKit remote
  /// uids to display names in _CallPage.
  List<UiContact> _allKnownGroupContacts() {
    final seen = <String>{};
    final out = <UiContact>[];
    for (final m in _groupMembers) {
      if (m.uid.isEmpty || seen.contains(m.uid)) continue;
      seen.add(m.uid);
      out.add(
        UiContact.fromSocial(
          m,
          colors: conversationColors(out.length),
          config: widget.config,
        ),
      );
    }
    for (final c in widget.contacts) {
      if (c.uid.isEmpty || seen.contains(c.uid)) continue;
      seen.add(c.uid);
      out.add(c);
    }
    return out;
  }

  String _senderName(ChatMessage message) {
    if (message.isMine) return AppLocalizations.of(context).chatSelfName;
    final payloadName = moyuDisplayName(
      name: message.fromName,
      rawIdentity: message.fromUid,
      placeholder: '',
    );
    if (payloadName.isNotEmpty) return payloadName;
    if (!_isGroupChat) {
      return moyuDisplayName(
        name: widget.conversation.name,
        rawIdentity: widget.conversation.channelId,
        placeholder: AppLocalizations.of(context).chatPeerPlaceholder,
      );
    }
    for (final member in _groupMembers) {
      if (member.uid == message.fromUid) {
        return moyuDisplayName(
          remark: member.remark,
          name: member.name,
          rawIdentity: member.uid,
          placeholder: '',
        );
      }
    }
    return '';
  }

  bool get _isGroupChat =>
      widget.conversation.channelType == WKChannelType.group;

  /// True when both indices point to non-mine, non-system messages from the
  /// same sender on the same calendar day AND within 5 minutes of each
  /// other. Used to detect left-bubble streak boundaries —
  /// `_isSameLeftStreak(i, i-1) == false` means streak start (show sender
  /// name); `_isSameLeftStreak(i, i+1) == false` means streak end (show
  /// avatar). The 5-minute gap matches the date-stamp insertion threshold
  /// in `_shouldInsertDateStamp` so a long-gap same-sender block always
  /// gets its avatar back, mirroring how the native app re-anchors after a
  /// time divider.
  /// Substitute `{0}`, `{1}` ... placeholders in a system-message text using
  /// the `extra.users` payload that native iOS resolves via WKChannelInfo
  /// lookup. Falls back to '某人' when the lookup fails so the placeholder
  /// never bleeds through.
  String _resolveSystemText(ChatMessage message) {
    var text = message.text;
    if (!text.contains('{')) return text;
    final users = _affectedUsers(message);
    if (users != null) {
      for (var i = 0; i < users.length; i++) {
        final entry = users[i];
        var name = AppLocalizations.of(context).chatSomeonePlaceholder;
        if (entry is Map) {
          name =
              (entry['name'] ??
                      entry['nickname'] ??
                      entry['display_name'] ??
                      AppLocalizations.of(context).chatSomeonePlaceholder)
                  .toString();
        } else if (entry != null) {
          name = entry.toString();
        }
        text = text.replaceAll('{$i}', name);
      }
    }
    // Strip leftover unsubstituted placeholders so we don't leak `{0}` to UI.
    text = text.replaceAll(
      RegExp(r'\{\d+\}'),
      AppLocalizations.of(context).chatSomeonePlaceholder,
    );
    return text;
  }

  /// Build a flat widget list out of [_messages] inserting:
  ///   - centered date-stamp dividers when timestamps cross days or have a
  ///     5-minute (300s) gap (V2)
  ///   - centered system rows for call/system content types (C1/F1)
  ///   - left bubbles whose avatar shows only on the streak END (matches
  ///     native iOS: First/Middle hidden, Last/Single shown) and whose
  ///     sender name shows only on the streak START (First/Single)
  ///   - in 1:1 (personal) chats, peer bubbles render with no avatar slot at
  ///     all — matching native `isPersonChannel` behavior
  List<Widget> _buildChatRows() {
    final rows = <Widget>[];
    if (_isLoadingOlder) {
      rows.add(const HistoryLoadingRow());
    }
    // Mark where the unread page started so we can drop a "以下是新
    // 消息" divider above the first unread row. Re-resolves from the
    // anchor messageId when set so older history paginated in via
    // `_loadOlderMessages` doesn't shift the divider to the wrong
    // row. Falls back to the latched `_firstUnreadIndex` (legacy path
    // for in-flight migrations) when the anchor isn't available.
    final unreadDividerIndex = _resolveUnreadDividerIndex();
    int? prevTimestamp;
    // When the first unread message turns out to be a hidden RTC signaling
    // frame, the divider would normally vanish (we `continue` before any
    // row is appended). Defer the divider to the next visible row so the
    // user still sees "以下为新消息" above their first real unread bubble.
    bool pendingUnreadDivider = false;

    // History-split divider index: the position of the FIRST message
    // whose timestamp is at or after the session watermark, when at
    // least one earlier message exists. Native iOS calls this the
    // `WKHistorySplitTipCell`. `-1` when no split should render —
    // either no watermark recorded yet, all messages predate it
    // (no boundary), or all are newer (also no boundary).
    final historySplitIndex = _resolveHistorySplitIndex();
    bool pendingHistorySplit = false;

    for (var i = 0; i < _messages.length; i++) {
      final message = _messages[i];

      // Hidden frames must not produce a row. Besides RTC signaling, AG-UI
      // bots can carry `/message/event` streams alongside an empty text
      // message (`{"content":"","type":1}`); that carrier belongs to the
      // event pipeline and must not render as a blank bubble.
      if (message.isHiddenRtcSignalingFrame ||
          message.isEmptyInboundTextMessage) {
        if (i == unreadDividerIndex) {
          pendingUnreadDivider = true;
        }
        if (i == historySplitIndex) {
          pendingHistorySplit = true;
        }
        continue;
      }

      if (shouldInsertChatDateStamp(prevTimestamp, message.timestamp)) {
        rows.add(
          DateStamp(
            formatChatDateStamp(
              AppLocalizations.of(context),
              message.timestamp,
            ),
          ),
        );
      }
      // Order matters when both anchor at the same row: history
      // split first ('以上为历史消息') THEN unread divider
      // ('以下为新消息') so the user reads:
      //   …old messages
      //   ──── 以上为历史消息 ────
      //   ──── 3 条新消息 ────
      //   …new messages
      if (i == historySplitIndex || pendingHistorySplit) {
        rows.add(const HistorySplitRow());
        pendingHistorySplit = false;
      }
      if (i == unreadDividerIndex || pendingUnreadDivider) {
        rows.add(UnreadHistoryDivider(count: _initialUnreadCount));
        pendingUnreadDivider = false;
      }
      prevTimestamp = message.timestamp;

      // For flame-enabled channels: schedule a destruction timer the
      // first time a real-id message hits the row builder.
      if (_flameEnabled && !message.revoked) {
        _maybeStartFlameTimer(message);
      }

      if (message.revoked) {
        rows.add(
          RevokeRow(
            isMine: message.isMine,
            fromName: _senderName(message),
            revokerIsSelf:
                message.revoker.isEmpty || message.revoker == widget.loginUid,
            originalText: message.text,
            // 对齐 iOS WKMessageRevokeCell: 仅**文本消息**显示"重新编辑"
            // (图片/视频/语音/文件 撤回后没有可恢复的 raw 文本). iOS
            // 判断 `messageModel.contentType == WK_TEXT (1)`. 之前 Flutter
            // 写成 `kind == ChatMediaKind.file` — 因为 ChatMessage.kind
            // 默认值就是 file (文本消息 fromSnapshot 走 _ => null 分支后
            // .right() 回到默认), 意外能命中文本; 但文件消息也是 file,
            // 仅靠 text.isNotEmpty 才把文件撤回卡掉, 语义混乱. 直接用
            // contentType 判更准确.
            recallable:
                message.isMine &&
                // WkMessageContentType.text == 1 (跟 line 5358 同写法,
                // 避免 import SDK 常量到 mega-file 顶层)
                message.contentType == 1 &&
                message.text.isNotEmpty &&
                // Spec §6 P2: hide 重新编辑 on already-edited messages
                // since restoring the original text would discard the
                // edit. Mirrors native iOS guard.
                message.editedText.isEmpty,
            onReedit: message.isMine ? () => _restoreToComposer(message) : null,
          ),
        );
        continue;
      }
      if (message.isSystemMessage) {
        // All system messages — including the group-call invite —
        // render as the usual non-tappable centered tip. The join
        // action moved to the top-of-screen banner (more visible,
        // matches WeChat / WhatsApp), so the 9988 message is now
        // purely a historical breadcrumb.
        rows.add(SystemMessageRow(text: _resolveSystemText(message)));
        continue;
      }

      if (message.isCallMessage) {
        // Tap-to-recall preserves the original modality of this call. Native
        // iOS WKVideoCallSystemCell.onTap shows an action sheet with both
        // 视频聊天 / 语音聊天; our condensed UX just re-opens with the same
        // type. Previously hardcoded `audio` regardless of the bubble — see
        // call-bubble.md §2.4.
        final recallType = message.callType == 1
            ? ChatCallType.video
            : ChatCallType.audio;
        // 跟普通 Bubble.left 同款 streak 计算 + avatar 数据透传, 让通话气泡
        // 跟其他气泡左对齐 (私聊 bubble.margin 8) + 群聊显头像 + 显发送者名.
        // 跟前 / 后条同 streak 时不显头像 / 不显名 (streak start/end 才显).
        final isStreakStart = !isSameLeftMessageStreak(
          _messages,
          i,
          previousVisibleMessageIndex(_messages, i),
        );
        final isStreakEnd = !isSameLeftMessageStreak(
          _messages,
          i,
          nextVisibleMessageIndex(_messages, i),
        );
        final showAvatar = _isGroupChat && !message.isMine && isStreakEnd;
        final showSenderName = _isGroupChat && !message.isMine && isStreakStart;
        rows.add(
          _wrapForMultiSelect(
            message,
            CallBubble(
              message: message,
              isMine: message.isMine,
              hasAvatarSlot: _isGroupChat,
              showAvatar: showAvatar,
              avatarLabel: _bubbleSenderLabel(message, widget.conversation),
              avatarUrl: _bubbleSenderAvatar(message, widget.conversation),
              avatarColors: _bubbleSenderColors(message, widget.conversation),
              senderName: showSenderName ? _senderName(message) : '',
              // In a group conversation re-tap on an old call bubble
              // must NOT go through the P2P path — that would send
              // `/rtc/p2p/invoke` with the group id as peer_uid and
              // generate a fake private-chat record (user-facing bug:
              // "点击曾经的通话气泡发起不知道去哪的对话"). Route to
              // the group picker instead.
              onTap: () {
                if (_conversation.channelType == WKChannelType.group) {
                  unawaited(_openGroupCall(recallType));
                } else {
                  _openCall(recallType);
                }
              },
              onLongPress: () => _showMessageActions(message),
              onLongPressAt: (pos) => _showMessageActionsAt(message, pos),
              status: message.status,
              readed: message.readed,
              readedCount: message.readedCount,
              unreadCount: message.unreadCount,
              onReceiptTap: _receiptTapFor(message, disabled: false),
              onRetry: message.status == '发送失败'
                  ? () => _retryMessage(message)
                  : null,
              onDelete: message.status == '发送失败'
                  ? () => setState(() => _messages.remove(message))
                  : null,
              timeText: formatChatClock(message.timestamp),
            ),
          ),
        );
        continue;
      }

      if (message.isMergeForwardMessage) {
        final isMs = _isMultiSelect && _canMultiSelect(message);
        final pa = _peerBubbleArgs(message, i);
        rows.add(
          _wrapForMultiSelect(
            message,
            MergeForwardBubble(
              isMine: message.isMine,
              title: localizedMergeForwardTitle(
                AppLocalizations.of(context),
                message,
              ),
              entries: message.mergeForwardEntries,
              onTap: isMs
                  ? () => _toggleSelection(message)
                  : () => _openMergeForwardDetail(message),
              onLongPress: isMs ? null : () => _showMessageActions(message),
              onLongPressAt: isMs
                  ? null
                  : (pos) => _showMessageActionsAt(message, pos),
              status: message.status,
              readed: message.readed,
              readedCount: message.readedCount,
              unreadCount: message.unreadCount,
              onReceiptTap: _receiptTapFor(message, disabled: isMs),
              onRetry: message.status == '发送失败'
                  ? () => _retryMessage(message)
                  : null,
              onDelete: message.status == '发送失败'
                  ? () => setState(() => _messages.remove(message))
                  : null,
              hasAvatarSlot: pa.hasAvatarSlot,
              showAvatar: pa.showAvatar,
              avatarUrl: pa.avatarUrl,
              avatarLabel: pa.avatarLabel,
              avatarColors: pa.avatarColors,
              senderName: pa.senderName,
              timeText: formatChatClock(message.timestamp),
            ),
          ),
        );
        continue;
      }

      if (message.isGroupInviteApproval) {
        rows.add(
          _wrapForMultiSelect(
            message,
            GroupInviteApprovalBubble(
              text: message.text,
              onConfirm: () => unawaited(_openGroupInviteConfirm(message)),
              onLongPress: () => _showMessageActions(message),
            ),
          ),
        );
        continue;
      }

      if (message.isScreenshotMessage) {
        rows.add(
          SystemMessageRow(
            text: AppLocalizations.of(
              context,
            ).chatScreenshotNotice(message.screenshotFromName),
          ),
        );
        continue;
      }

      if (shouldRenderModuleContentFallback(message, widget.runtime)) {
        final pa = _peerBubbleArgs(message, i);
        rows.add(
          _wrapForMultiSelect(
            message,
            UnknownContentRow(
              isMine: message.isMine,
              text: AppLocalizations.of(context).moduleUnsupported,
              hasAvatarSlot: pa.hasAvatarSlot,
              showAvatar: pa.showAvatar,
              avatarUrl: pa.avatarUrl,
              avatarLabel: pa.avatarLabel,
              avatarColors: pa.avatarColors,
              senderName: pa.senderName,
            ),
          ),
        );
        continue;
      }

      if (message.isLocationMessage) {
        final isMs = _isMultiSelect && _canMultiSelect(message);
        final pa = _peerBubbleArgs(message, i);
        rows.add(
          _wrapForMultiSelect(
            message,
            LocationBubble(
              isMine: message.isMine,
              title: message.locationTitle,
              address: message.locationAddress,
              latitude: message.locationLat,
              longitude: message.locationLng,
              imageUrl: message.locationImageUrl,
              onTap: isMs
                  ? () => _toggleSelection(message)
                  : () => unawaited(_openLocation(message)),
              onLongPress: isMs ? null : () => _showMessageActions(message),
              onLongPressAt: isMs
                  ? null
                  : (pos) => _showMessageActionsAt(message, pos),
              status: message.status,
              readed: message.readed,
              readedCount: message.readedCount,
              unreadCount: message.unreadCount,
              onReceiptTap: _receiptTapFor(message, disabled: isMs),
              onRetry: message.status == '发送失败'
                  ? () => _retryMessage(message)
                  : null,
              onDelete: message.status == '发送失败'
                  ? () => setState(() => _messages.remove(message))
                  : null,
              hasAvatarSlot: pa.hasAvatarSlot,
              showAvatar: pa.showAvatar,
              avatarUrl: pa.avatarUrl,
              avatarLabel: pa.avatarLabel,
              avatarColors: pa.avatarColors,
              senderName: pa.senderName,
              timeText: formatChatClock(message.timestamp),
            ),
          ),
        );
        continue;
      }

      if (message.isCardMessage) {
        final isMs = _isMultiSelect && _canMultiSelect(message);
        // 群聊 cell 框架 — 跟 Bubble.left 同模式: streak end 显头像,
        // streak start 显发送者名, 否则只一行卡片. 1v1 无头像无名字.
        final isStreakStart = !isSameLeftMessageStreak(
          _messages,
          i,
          previousVisibleMessageIndex(_messages, i),
        );
        final isStreakEnd = !isSameLeftMessageStreak(
          _messages,
          i,
          nextVisibleMessageIndex(_messages, i),
        );
        final showAvatar = _isGroupChat && !message.isMine && isStreakEnd;
        final showSenderName = _isGroupChat && !message.isMine && isStreakStart;
        final senderName = showSenderName ? _senderName(message) : '';
        final leadingStatus = _leadingStatusFor(message, disabled: isMs);
        final card = CardBubble(
          isMine: message.isMine,
          name: message.cardName,
          uid: message.cardUid,
          // 透传 config 用于拼 avatar URL (DESIGN.md §5.5 / SOP §4.8).
          config: widget.config,
          onTap: isMs
              ? () => _toggleSelection(message)
              : () => unawaited(_openCardProfile(message.cardUid)),
          onLongPress: isMs ? null : () => _showMessageActions(message),
          onLongPressAt: isMs
              ? null
              : (pos) => _showMessageActionsAt(message, pos),
          timeText: formatChatClock(message.timestamp),
        );
        // 名片头像 + 名字 + 底部对齐布局收口到 MoyuPeerBubbleFrame
        // (跟文本/图片气泡同款), 不再外包手写 avatarSlot + Row。
        final cellRow = Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: message.isMine
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (leadingStatus != null) ...[
                      leadingStatus,
                      const SizedBox(width: 6),
                    ],
                    card,
                  ],
                )
              : MoyuPeerBubbleFrame(
                  bubble: card,
                  hasAvatarSlot: _isGroupChat,
                  showAvatar: showAvatar,
                  avatarUrl: _bubbleSenderAvatar(message, widget.conversation),
                  avatarLabel: _bubbleSenderLabel(message, widget.conversation),
                  avatarColors: _bubbleSenderColors(message, widget.conversation),
                  senderName: senderName,
                ),
        );
        rows.add(_wrapForMultiSelect(message, cellRow));
        continue;
      }

      if (_isUnknownContent(message)) {
        final pa = _peerBubbleArgs(message, i);
        rows.add(
          _wrapForMultiSelect(
            message,
            UnknownContentRow(
              isMine: message.isMine,
              hasAvatarSlot: pa.hasAvatarSlot,
              showAvatar: pa.showAvatar,
              avatarUrl: pa.avatarUrl,
              avatarLabel: pa.avatarLabel,
              avatarColors: pa.avatarColors,
              senderName: pa.senderName,
            ),
          ),
        );
        continue;
      }

      if (message.isMine) {
        final isMs = _isMultiSelect && _canMultiSelect(message);
        final aiAction = _voiceAiActionFor(message, disabled: isMs);
        final aiAddon = _messageAiAddonFor(message);
        rows.add(
          _wrapForMultiSelect(
            message,
            Bubble.right(
              text: message.effectiveText,
              streamingPlaceholder: isAguiStreamingPlaceholder(message),
              timeText: formatChatClock(message.timestamp),
              edited: message.isEdited,
              reactions: message.reactions,
              onReactionTap: (emoji) =>
                  unawaited(_toggleReaction(message, emoji)),
              uploadProgress: message.clientMsgNo.isEmpty
                  ? null
                  : _uploadProgress[message.clientMsgNo],
              flameSecond: _flameEnabled ? _flameSecond : 0,
              // Per-message flame deadline so the badge ticks down
              // independently per bubble. Falls back to 0 when we
              // don't yet have a server timestamp (local optimistic
              // message), in which case the badge renders the static
              // channel TTL instead of a stale countdown.
              flameExpiresAtMs: flameExpiresAtMsForMessage(
                flameEnabled: _flameEnabled,
                flameSecond: _flameSecond,
                message: message,
              ),
              mediaGateway: widget.mediaGateway,
              kind: message.kind,
              attachment: message.attachment,
              status: message.status,
              readed: message.readed,
              readedCount: message.readedCount,
              unreadCount: message.unreadCount,
              onReceiptTap: _receiptTapFor(message, disabled: isMs),
              replyToSender: message.replyToSender,
              replyToText: message.replyToText,
              replyToRevoked: message.replyToRevoked,
              onReplyTap: _buildReplyTap(message),
              messageKey: _messagePlaybackKey(message),
              voiceSideAction: aiAction,
              messageAddon: aiAddon,
              onSwipeReply: isMs ? null : () => _startReplyToMessage(message),
              onTap: isMs
                  ? () => _toggleSelection(message)
                  : switch (message.kind) {
                      ChatMediaKind.image => () => _openImagePreview(message),
                      ChatMediaKind.voice => () => unawaited(
                        _playVoice(message),
                      ),
                      ChatMediaKind.video => () => _openVideoPlayback(message),
                      ChatMediaKind.livePhoto => () => _openLivePhotoPlayback(
                        message,
                      ),
                      // ChatMessage.left/right 默认 kind=file 但 attachment=null
                      // (纯文本消息构造时不传 kind → 落 file 分支). 加 when
                      // guard 让 fallback 走 _ => null, 避免纯文本气泡 tap
                      // 触发 _openFileInfo → 弹 "文件信息缺失" toast.
                      ChatMediaKind.file when message.attachment != null =>
                        () => _openFileInfo(message),
                      _ => null,
                    },
              // 双击文本 = 快速 ❤️ reaction. 编辑入口保留在长按菜单,
              // 但只把原文本回填到输入框给用户再操作, 不再弹 modal.
              // isMs 多选模式期间不要触发 reaction (会跟 toggleSelection
              // 抢手势). messageId 非空保证 `_toggleReaction` 能发到服务端.
              onDoubleTap:
                  !isMs &&
                      message.contentType == 1 &&
                      !message.revoked &&
                      message.messageId.isNotEmpty
                  ? () => unawaited(_toggleReaction(message, 'love'))
                  : null,
              onRetry: message.status == '发送失败'
                  ? () => _retryMessage(message)
                  : null,
              onDelete: message.status == '发送失败'
                  ? () => setState(() => _messages.remove(message))
                  : null,
              onMentionTap: isMs ? null : _resolveMentionTap,
              mentionCandidates: _mentionCandidates,
              // 所有消息 kind 走统一通用 context menu (含 reaction strip +
              // 回复 / 转发 / 收藏 / 编辑图片 / 多选 / 撤回 / 删除). 跟 iOS
              // 原版气泡长按 → WKMessageActionMenu 同模式. [保存到相册 /
              // 识别二维码 / 添加到表情] 3 个图片相关 action 在 _ImageLightbox
              // (点图进全屏) 提供, 跟 iOS WKImageBrowser 长按全屏图同位置.
              onLongPress: isMs ? null : () => _showMessageActions(message),
              onLongPressAt: isMs
                  ? null
                  : (pos) => _showMessageActionsAt(message, pos),
            ),
          ),
        );
        continue;
      }

      // left bubble — avatar appears only at the streak END and the sender
      // name only at the streak START (matches native iOS bubble position
      // rules). In 1:1 chats there is no avatar slot at all.
      // Walk past hidden RTC signaling frames when picking streak
      // neighbors so an invisible 9990..9998 frame between two visible
      // bubbles from the same sender doesn't split their visual streak
      // (no orphan avatar/name break around something the user can't see).
      final isStreakStart = !isSameLeftMessageStreak(
        _messages,
        i,
        previousVisibleMessageIndex(_messages, i),
      );
      final isStreakEnd = !isSameLeftMessageStreak(
        _messages,
        i,
        nextVisibleMessageIndex(_messages, i),
      );
      final showAvatar = _isGroupChat && isStreakEnd;
      final showSenderName = _isGroupChat && isStreakStart;
      final isMs = _isMultiSelect && _canMultiSelect(message);
      final aiAction = _voiceAiActionFor(message, disabled: isMs);
      final aiAddon = _messageAiAddonFor(message);
      rows.add(
        _wrapForMultiSelect(
          message,
          Bubble.left(
            avatarLabel: _bubbleSenderLabel(message, widget.conversation),
            avatarUrl: _bubbleSenderAvatar(message, widget.conversation),
            text: message.effectiveText,
            streamingPlaceholder: isAguiStreamingPlaceholder(message),
            timeText: formatChatClock(message.timestamp),
            // 被回复计数 — 对方/群消息气泡末尾显示 ⬅️N. 数据来自 server
            // message_extra.reply_count → SDK 本地表 → ChatMessage.replyCount.
            replyCount: message.replyCount,
            edited: message.isEdited,
            reactions: message.reactions,
            onReactionTap: (emoji) =>
                unawaited(_toggleReaction(message, emoji)),
            flameSecond: _flameEnabled ? _flameSecond : 0,
            flameExpiresAtMs: flameExpiresAtMsForMessage(
              flameEnabled: _flameEnabled,
              flameSecond: _flameSecond,
              message: message,
            ),
            mediaGateway: widget.mediaGateway,
            kind: message.kind,
            attachment: message.attachment,
            // Show the trailing red dot on received voice bubbles
            // until the user plays it. Two clear paths:
            //   1. Server-side flip: `_playVoice` POSTs
            //      `markVoiceMessageRead`; the next snapshot
            //      refresh carries `voiceStatus = 1`.
            //   2. Local optimistic: `_locallyHeardVoiceIds`
            //      tracks ids the user just played; OR'd here so
            //      the dot clears instantly even if the SDK's
            //      sync path drops the extra-side voice_status
            //      back to 0 (a known SDK 1.7.9 gap).
            voiceUnread:
                message.kind == ChatMediaKind.voice &&
                message.voiceStatus == 0 &&
                !_locallyHeardVoiceIds.contains(message.messageId),
            colors: _bubbleSenderColors(message, widget.conversation),
            hasAvatarSlot: _isGroupChat,
            showAvatar: showAvatar,
            senderName: showSenderName ? _senderName(message) : '',
            replyToSender: message.replyToSender,
            replyToText: message.replyToText,
            replyToRevoked: message.replyToRevoked,
            onReplyTap: _buildReplyTap(message),
            messageKey: _messagePlaybackKey(message),
            voiceSideAction: aiAction,
            messageAddon: aiAddon,
            onSwipeReply: isMs ? null : () => _startReplyToMessage(message),
            onTap: isMs
                ? () => _toggleSelection(message)
                : switch (message.kind) {
                    ChatMediaKind.image => () => _openImagePreview(message),
                    ChatMediaKind.voice => () => unawaited(_playVoice(message)),
                    ChatMediaKind.video => () => _openVideoPlayback(message),
                    ChatMediaKind.livePhoto => () => _openLivePhotoPlayback(
                      message,
                    ),
                    // attachment==null guard — 见 Bubble.left 同款注释.
                    ChatMediaKind.file when message.attachment != null =>
                      () => _openFileInfo(message),
                    _ => null,
                  },
            onMentionTap: isMs ? null : _resolveMentionTap,
            mentionCandidates: _mentionCandidates,
            // Sensitive-word warning is only attached to received text
            // bubbles (per native iOS rule `!model.isSend`). Outgoing
            // bubbles never reach this branch, so the only gates here
            // are: actually a text-kind message, and the body matches
            // a cached word. The tip helper falls back to a Chinese
            // default when the server hasn't pushed a custom string.
            sensitiveTipText:
                message.isTextMessage && _isSensitiveText(message.effectiveText)
                ? _sensitiveTipText
                : null,
            // 图片消息长按走通用 _showMessageActions (见上方注释).
            onLongPress: isMs ? null : () => _showMessageActions(message),
            onLongPressAt: isMs
                ? null
                : (pos) => _showMessageActionsAt(message, pos),
          ),
        ),
      );
    }
    return rows;
  }

  /// Tap handler for `@mention` spans inside text bubbles. Mirrors the
  /// native iOS chat-cell mention tap. Resolution order:
  ///   1. Trim trailing sentence punctuation (`.,;:!?。，；：！？`) so
  ///      `@Alice.` and `@张三，` still resolve cleanly.
  ///   2. Group members (`_groupMembers`) — match `name` or `remark`,
  ///      collected by uid so duplicate display names surface as
  ///      ambiguous instead of silently picking the first.
  ///   3. Friend contacts (`widget.contacts`) — match `name` (display),
  ///      `rawName` (raw nickname), or `remark` (local alias). Same
  ///      dedup-by-uid rule.
  ///   4. Ambiguous (≥2 distinct uids) → `存在同名` notice. Display
  ///      text is not stable identity, so we refuse to guess.
  ///   5. Resolved + full `UiContact` available → push
  ///      `ContactDetailPage`. uid-only (group stranger) →
  ///      `_openCardProfile` placeholder until a stranger-fetch lands.
  ///   6. Miss → `未找到 @name` notice.
  void _resolveMentionTap(String rawName) {
    if (rawName.isEmpty) return;
    final resolved = resolveMentionTapTarget(
      rawName: rawName,
      groupMembers: _groupMembers,
      contacts: widget.contacts,
    );
    switch (resolved.kind) {
      case MentionTapResolutionKind.empty:
        return;
      case MentionTapResolutionKind.groupDuplicate:
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatDuplicateGroupMention(resolved.name),
        );
        return;
      case MentionTapResolutionKind.contactDuplicate:
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatDuplicateContactMention(resolved.name),
        );
        return;
      case MentionTapResolutionKind.notFound:
        setState(
          () => _actionNotice = AppLocalizations.of(
            context,
          ).chatMentionNotFound(resolved.name),
        );
        return;
      case MentionTapResolutionKind.contact:
        final hitContact = resolved.contact;
        if (hitContact == null) return;
        unawaited(
          pushPage(
            context,
            ContactDetailPage(
              contact: hitContact,
              loginUid: widget.loginUid,
              loginName: widget.loginName,
              callGateway: widget.callGateway,
              socialGateway: widget.socialGateway,
              imGateway: widget.imGateway,
              config: widget.config,
              onContactRemoved: widget.onContactRemoved,
              // `ContactDetailPage` already pops itself before invoking
              // `onOpenChat`, leaving the user back on this chat screen.
              // Inside a chat we don't push a second chat for the same
              // partner; for a different contact, jumping into a fresh
              // chat from here would need `onOpenContactChat` plumbed
              // through `ChatScreen` which isn't wired yet — surface a
              // notice so the user knows to use the contacts tab. No
              // extra navigation pop here so we don't dump them out of
              // the current chat.
              onOpenChat: (target) async {
                if (!mounted) return;
                if (target.uid == widget.conversation.channelId) return;
                // 接通: 有 onOpenContactChat 就 push 目标会话 (叠在当前聊天页上,
                // 返回键回原会话); 没接则降级旧提示.
                final opener = widget.onOpenContactChat;
                if (opener != null) {
                  await opener(target);
                  return;
                }
                setState(
                  () => _actionNotice = AppLocalizations.of(
                    context,
                  ).chatOpenFromContacts(target.name),
                );
              },
            ),
          ),
        );
        return;
      case MentionTapResolutionKind.uid:
        final uid = resolved.uid;
        if (uid == null || uid.isEmpty) return;
        unawaited(_openCardProfile(uid));
        return;
    }
  }

  /// Cache for the sorted mention-candidate list. Built once per
  /// `_groupMembers` / `widget.contacts` change and reused across
  /// every bubble render. Without this, opening a 10k-member group
  /// rebuilds the list (de-dupe + sort) once per text bubble per
  /// frame, blocking the UI thread on scroll.
  List<String>? _cachedMentionCandidates;
  List<UiContact>? _cachedMentionContactsRef;
  List<ChatContact>? _cachedMentionMembersRef;

  /// Display labels the inline-text parser should treat as candidate
  /// `@mention` targets. Union of group-member labels (`name` +
  /// `remark`) and friend-contact labels (`name` + `rawName` +
  /// `remark`). Returned **already sorted longest-first** so the
  /// parser can skip its own sort. Threaded into bubble text
  /// rendering so multi-word names like `@John Doe` capture as a
  /// single span instead of just `@John`. Empty entries are filtered.
  List<String> get _mentionCandidates {
    if (_cachedMentionCandidates != null &&
        identical(_cachedMentionContactsRef, widget.contacts) &&
        identical(_cachedMentionMembersRef, _groupMembers)) {
      return _cachedMentionCandidates!;
    }
    final sorted = buildMentionCandidateLabels(
      groupMembers: _groupMembers,
      contacts: widget.contacts,
    );
    _cachedMentionCandidates = sorted;
    _cachedMentionContactsRef = widget.contacts;
    _cachedMentionMembersRef = _groupMembers;
    return sorted;
  }

  /// Wrap a bubble row with selection / flash-highlight overlays and tag
  /// it with a per-message GlobalKey so reply-tap can `ensureVisible` it.
  /// Selected rows get a pale blue fill (multi-select), the flash target
  /// gets a pale yellow tint that fades out after ~1.4s.
  ///
  /// 横条贴边: ListView 有 16pt h-padding, AnimatedContainer 默认只在
  /// padding 内画 → 横条左右各让出 16pt. 用 Stack + Positioned(left:-16,
  /// right:-16) + Clip.none, 让 bg 层突破 padding 延伸到屏宽. 不用
  /// Container.margin 负值 (`margin.isNonNegative` 断言会红屏),
  /// Positioned 允许负偏移.
  Widget _wrapForMultiSelect(ChatMessage message, Widget child) {
    final selectable = _isMultiSelect && _canMultiSelect(message);
    final selected = selectable && _isSelected(message);
    final flash =
        message.messageId.isNotEmpty && message.messageId == _highlightedKey;
    final bg = selected
        ? const Color(0x1A2F6BFF) // 选中态背景加深 (0x14 → 0x1A, 约 10%)
        : (flash ? const Color(0x33FFE066) : null);
    final body = Stack(
      clipBehavior: Clip.none,
      children: [
        if (bg != null)
          Positioned(
            left: -16,
            right: -16,
            // 修 #12: flash 定位高亮顶部上探 12 (镜像消息行 bottom:12 的 gap),
            // 让高亮上下对称罩住气泡, 不再顶部贴死气泡。仅 flash 上探, 多选选中态
            // 保持 top:0 (否则连续选中行的半透明 band 会在 gap 叠加变暗)。
            top: flash ? -12 : 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              color: bg,
            ),
          ),
        // 多选 checkbox — 对齐 iOS `WKMessageBaseCell` 在 multiSelectMode
        // 时左侧 26px 圆环 / 选中蓝色实心 + 白勾. iOS native UITableView
        // editingStyle 内置, Flutter 这里手写覆盖在 row 左侧.
        // 仅 selectable 时显示 (系统消息/撤回不能选).
        if (selectable)
          Positioned(
            left: -2,
            top: 0,
            bottom: 0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? MoyuColors.of(context).primary
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? MoyuColors.of(context).primary
                        : Color(0xFFCCCCCC),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(
                        FIcons.check,
                        size: 14,
                        color: MoyuColors.of(context).background,
                      )
                    : null,
              ),
            ),
          ),
        // child 在多选时缩 24 px 给 checkbox 让位 (避免头像/气泡被压住).
        if (selectable)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: IgnorePointer(child: child),
          )
        else
          child,
      ],
    );
    final row = selectable
        ? FTappable(
            onPress: () => _toggleSelection(message),
            behavior: HitTestBehavior.opaque,
            child: body,
          )
        : body;
    return KeyedSubtree(key: _bubbleKeyFor(message), child: row);
  }

  /// Upsert messages coming from the IM gateway. Three paths:
  ///   1. Refresh of an already-tracked message (matched by messageId or
  ///      clientMsgNo) — replace in place so receipt / status changes flow
  ///      through to the bubble. This is how the sender's ✓ → ✓✓ flip
  ///      arrives when the peer marks the message read.
  ///   2. SDK-side insert of an outgoing message we just sent locally —
  ///      adopt the SDK-assigned messageId/clientMsgNo onto the most
  ///      recent local placeholder so future refreshes can match.
  ///   3. Fresh incoming message — append + auto-mark read.
  void _handleGatewayMessage(WukongMessageSnapshot snapshot) {
    if (!widget.conversation.matches(
      snapshot.channelId,
      snapshot.channelType,
    )) {
      return;
    }
    final streamEvent = aguiEventFromStreamSnapshot(snapshot);
    if (streamEvent != null) {
      _handleAguiEvent(streamEvent);
      return;
    }
    final existingIndex = _findMessageIndex(snapshot);
    if (shouldSuppressEmptyInboundSnapshot(snapshot)) {
      if (existingIndex >= 0) {
        final existing = _messages[existingIndex];
        if (existing.isAguiStreamingPlaceholder) {
          return;
        }
        if (existing.isEmptyInboundTextMessage) {
          setState(() => _messages.removeAt(existingIndex));
        }
      }
      return;
    }
    final aguiFinalIndex = findMatchingAguiFinalIndex(_messages, snapshot);
    if (aguiFinalIndex >= 0) {
      final updated = ChatMessage.fromSnapshot(snapshot);
      setState(() {
        _messages[aguiFinalIndex] = updated;
      });
      return;
    }
    if (existingIndex >= 0) {
      final previous = _messages[existingIndex];
      final updated = ChatMessage.fromSnapshot(snapshot);
      setState(() {
        _messages[existingIndex] = updated;
        // Server pushed a revoke for an already-rendered message —
        // mirrors native iOS where extra-sync stamps `revoke=1` on
        // the original. Other bubbles in the open chat that quote
        // this message must flip their reply preview to
        // `原消息已撤回` immediately so the user doesn't see stale
        // body text. Local-revoke paths handle this themselves; this
        // covers peer / admin revokes that arrive via the stream.
        if (updated.revoked && !previous.revoked) {
          _flipDependentReplies(updated);
        }
      });
      return;
    }
    if (snapshot.isMine) {
      // Adopt SDK identity onto the local optimistic placeholder so a later
      // refresh (carrying the read receipt) can match this message.
      final orphanIndex = findOwnOptimisticMessageIndex(_messages, snapshot);
      final mineFresh = ChatMessage.fromSnapshot(snapshot);
      if (orphanIndex >= 0) {
        debugPrint(
          '[media-send] orphan HIT idx=$orphanIndex adopt clientMsgNo=${snapshot.clientMsgNo} status=${snapshot.status}',
        );
        setState(() {
          _messages[orphanIndex] = _messages[orphanIndex].withSdkIdentity(
            snapshot,
          );
          // Multi-device leave: a 1021 (退出了群聊) broadcast can be
          // authored by the current uid when the user left from
          // another device. The orphan-match path returns early
          // without running the side-effect dispatcher used by the
          // append path, so we apply it here too. Mirrors native iOS
          // where `WKSystemMessageHandler` fires regardless of who
          // authored the system frame.
          _applySystemSideEffects(mineFresh);
        });
      } else {
        final duplicateIndex =
            snapshot.messageId.isEmpty && snapshot.clientMsgNo.isEmpty
            ? findEquivalentOwnMessageIndex(_messages, snapshot)
            : -1;
        if (duplicateIndex >= 0) {
          debugPrint(
            '[media-send] duplicate own echo DROP idx=$duplicateIndex status=${snapshot.status}',
          );
          return;
        }
        debugPrint(
          '[media-send] orphan MISS clientMsgNo=${snapshot.clientMsgNo} status=${snapshot.status} (watch double bubble)',
        );
        // No orphan to adopt — the SDK echoed back a message we
        // didn't send locally. Three cases:
        //   1. Self-leave system event from another device (1003/1020/
        //      1021 etc): run side-effect dispatcher to flip the
        //      composer lock.
        //   2. Screenshot notification fired by `_onScreenshotDetected`
        //      (sendScreenshotNotice does NOT create a local optimistic
        //      bubble) — append so the user sees "你在聊天中截屏了"
        //      immediately, not only on chat re-open.
        //   3. Any other own-side message echoed without a local
        //      placeholder: append. Worst case is a duplicate that
        //      the next refresh dedupes via messageId match.
        setState(() {
          if (mineFresh.isSystemMessage) {
            _applySystemSideEffects(mineFresh);
          } else {
            _insertSorted(mineFresh);
            _liveAppendsCount += 1;
          }
        });
      }
      return;
    }
    final awayFromBottom = _isAwayFromBottom();
    final fresh = ChatMessage.fromSnapshot(snapshot);
    final lastTs = _messages.isEmpty ? 0 : _messages.last.timestamp;
    final isStraggler = fresh.timestamp < lastTs;
    setState(() {
      _insertSorted(fresh);
      // STRAGGLER (server sync 灌历史) 不算 live append — 它跟 open 前已加载的
      // 历史消息同性质, 不该往 unread divider 后面推 (`_liveAppendsCount` 给
      // divider 用于区分 "open 时已有" vs "open 后实时来的"). 实时新消息才 +=1.
      if (!isStraggler) {
        _liveAppendsCount += 1;
      }
      if (awayFromBottom && !isStraggler) {
        // STRAGGLER (server sync 灌历史) 不算"新消息到底", 不弹 jump-to-bottom,
        // 不 mark unread mention — 只有真实 newer ts 的实时消息才走那条路径.
        _newMessagesBelow += 1;
        _showJumpToBottom = true;
        // Surface the @-mention scroll FAB when the just-arrived
        // message names the current user. Tracker only records the
        // OLDEST pending mention so multiple incoming mentions
        // don't fight for the FAB target.
        _trackUnreadMention(fresh);
      }
      // Side-effect dispatch (mirrors native
      // `WKSystemMessageHandler -[handle:]`): kick / leave events
      // that name the current user must lock the composer
      // immediately so the user can't keep typing into a chat they
      // no longer belong to.
      _applySystemSideEffects(fresh);
    });
    // STRAGGLER 是 server sync 灌历史, 它的位置在 `_messages` 中间 (binary
    // insert), 强制 scrollToBottom 会把用户从浏览位置弹走 — 只有实时新消息
    // (append 到末尾) 才需要 scrollToBottom.
    if (!awayFromBottom && !isStraggler) {
      _scrollMessagesToBottom();
    }
    if (snapshot.messageId.isNotEmpty) {
      unawaited(
        widget.imGateway?.markMessagesRead(
              channelId: snapshot.channelId,
              channelType: snapshot.channelType,
              messageIds: [snapshot.messageId],
            ) ??
            Future<void>.value(),
      );
    }
  }

  bool _isAwayFromBottom() {
    if (!_messageScrollController.hasClients) return false;
    return _messageScrollController.position.pixels > _jumpToBottomThreshold;
  }

  int _findMessageIndex(WukongMessageSnapshot snapshot) {
    for (var i = _messages.length - 1; i >= 0; i--) {
      final message = _messages[i];
      if (snapshot.messageId.isNotEmpty &&
          message.messageId == snapshot.messageId) {
        return i;
      }
      if (snapshot.clientMsgNo.isNotEmpty &&
          message.clientMsgNo == snapshot.clientMsgNo) {
        return i;
      }
    }
    return -1;
  }

  /// 把 [fresh] 插入到 `_messages` 内, 保证按 `(timestamp, messageSeq)` 升序.
  /// 解决冷启动 + 重装后, SDK 通过 `addOnRefreshMsgListener` 在 server sync
  /// 期间倒序灌历史 message → `_messages.add` 直接 append 导致 list 顺序错乱
  /// → ListView reverse=true 渲染时"老消息从顶部冒出"的 bug.
  ///
  /// chatim 不像 iOS / Android 每次都从 DB 重新拉 (WKMessageList.arrangeMessages),
  /// 而是维护 in-memory `_messages` 列表 (跟 `_messageThreads` cache 同模式,
  /// sync 路径 fire 的乱序 message 累积 → UI 错乱.
  void _insertSorted(ChatMessage fresh) {
    // Hot path: 新消息 timestamp >= 末尾 → 直接 append (实时收发 99% case).
    if (_messages.isEmpty) {
      _messages.add(fresh);
      return;
    }
    final last = _messages.last;
    if (fresh.timestamp > last.timestamp ||
        (fresh.timestamp == last.timestamp &&
            fresh.messageSeq >= last.messageSeq)) {
      _messages.add(fresh);
      return;
    }
    // STRAGGLER path — binary search 找正确位置, 避免 O(n²) 全局 sort.
    var lo = 0;
    var hi = _messages.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      final mt = _messages[mid].timestamp;
      final ms = _messages[mid].messageSeq;
      final less =
          mt < fresh.timestamp ||
          (mt == fresh.timestamp && ms < fresh.messageSeq);
      if (less) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    _messages.insert(lo, fresh);
  }

  /// Merge SDK 权威历史 [fresh] 与当前 `_messages` 里 fresh 没覆盖到的本地消息
  /// (你刚发、SDK 还没同步的 optimistic placeholder / id 不在 fresh)。进对话那一
  /// 瞬 SDK 常还没同步全自己发的消息, `_fetchRemoteMessagesOnOpen` 直接
  /// `_messages = fresh` 会吞掉它们 + 打乱时间线, 等 `messageStream` 再 emit 才
  /// "灌回来" (用户报: 切语言/进对话后自己的消息消失, 过一下回来)。chatim 加的
  /// 不能让后台 sync 覆盖本地 in-flight。去重键跟 `_findMessageIndex` 一致
  /// (messageId / clientMsgNo), 排序键跟 `_insertSorted` 一致 (timestamp,
  /// messageSeq) 升序。
  List<ChatMessage> _mergedWithLocal(List<ChatMessage> fresh) {
    return mergeFreshWithLocalMessages(fresh, _messages);
  }

  /// Mark every currently-loaded incoming (non-mine) message with a remote
  /// id as read in one call. Matches native iOS behavior of firing
  /// `message/readed` once per chat-open / scroll-to-bottom batch.
  Future<void> _markVisibleMessagesRead() async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    final ids = <String>[];
    for (final message in _messages) {
      if (message.isMine) continue;
      if (message.messageId.isEmpty) continue;
      ids.add(message.messageId);
    }
    if (ids.isEmpty) return;
    try {
      await gateway.markMessagesRead(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        messageIds: ids,
      );
    } catch (_) {
      // Read receipts are best-effort — surface no UI on transient failures.
    }
  }

  void _scrollMessagesToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_messageScrollController.hasClients) {
        return;
      }
      // ListView is reverse:true → offset 0 is the visual bottom.
      _messageScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }
}

class _MessageAiUiState {
  const _MessageAiUiState({
    this.transcribing = false,
    this.translating = false,
    this.transcript = '',
    this.translation = '',
    this.sourceLanguage = '',
    this.errorMessage = '',
  });

  final bool transcribing;
  final bool translating;
  final String transcript;
  final String translation;
  final String sourceLanguage;
  final String errorMessage;

  _MessageAiUiState copyWith({
    bool? transcribing,
    bool? translating,
    String? transcript,
    String? translation,
    String? sourceLanguage,
    String? errorMessage,
  }) {
    return _MessageAiUiState(
      transcribing: transcribing ?? this.transcribing,
      translating: translating ?? this.translating,
      transcript: transcript ?? this.transcript,
      translation: translation ?? this.translation,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
