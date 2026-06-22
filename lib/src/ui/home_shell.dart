import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart' show md5;
import '../push/push_service.dart'
    show LocalNotificationCenter, PushRouter, PushService, PushTapEvent;
import 'in_app_banner.dart' show InAppBanner;
import '../call/callkit_bridge.dart';
import 'package:wukongimfluttersdk/type/const.dart' show WKChannelType;
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_repository.dart';
import '../auth/session_store.dart';
import '../auth/user_session.dart';
import '../l10n/app_localizations.dart';
import '../app/app_runtime.dart';
import '../config/app_config.dart';
import '../chat/chat_message.dart';
import '../conversation/chat_conversation.dart';
import '../conversation/conversation_thread_store.dart';
import '../db/friend_request_db.dart';
import '../im/wukong_im_service.dart';
import '../media/chat_media_service.dart';
import '../modules/module_ids.dart';
import '../modules/module_rtc_route.dart';
import '../call/chat_call_gateway.dart';
import '../scan/chat_scan_service.dart';
import '../settings/bubble_color_controller.dart';
import '../settings/bubble_color_store.dart';
import '../settings/tab_bar_style_controller.dart';
import '../settings/tab_bar_style_store.dart';
import '../social/moment_msg_gateway.dart';
import '../social/social_cache_lifecycle.dart';
import '../social/social_service.dart';
import 'pages/chat_screen_page.dart';
import 'pages/account_pages.dart';
import 'pages/discover_page.dart';
import 'pages/friend_pages.dart';
import 'pages/messages_tab_pages.dart';
import 'pages/profile_tab_pages.dart';
import 'pages/scan_page.dart';
import 'pages/settings_pages.dart';
import 'chat_password_sheet.dart';
import 'contact_list_widgets.dart';
import 'chat_sticker_display.dart';
import 'identity_display.dart';
import 'models/contact_models.dart';
import 'home_seed_data.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

// part files — legacy private helpers that still share this library.
// Page files under lib/src/ui/pages/ should be normal imports.

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.session,
    required this.config,
    required this.onLogout,
    this.serverScope = '',
    this.imGateway,
    this.socialGateway,
    this.mediaGateway,
    this.scanGateway,
    this.callGateway,
    this.runtime,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final UserSession session;
  final AppConfig config;
  final String serverScope;
  final VoidCallback onLogout;
  final ChatImGateway? imGateway;
  final ChatSocialGateway? socialGateway;
  final ChatMediaGateway? mediaGateway;
  final ChatScanGateway? scanGateway;
  final ChatCallGateway? callGateway;
  final AppRuntime? runtime;
  final ChatServerAppConfig serverAppConfig;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = const int.fromEnvironment('DEV_TAB', defaultValue: 0);

  bool get _isRtcEnabled {
    final runtime = widget.runtime;
    if (runtime == null) return widget.callGateway != null;
    return runtime.registry.enabledFeatures().any(
      (feature) => feature.id == ModuleFeatureIds.rtcCallGatewayFactory,
    );
  }

  ModuleRtcSessionApi? get _rtcSessionApi {
    final runtime = widget.runtime;
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
    final runtime = widget.runtime;
    final feature = runtime?.registry.featureById(ModuleRouteIds.rtcCall);
    if (feature == null || !runtime!.isModuleEnabled(feature.moduleId)) {
      return null;
    }
    final value = feature.value;
    return value is ModuleCallPageBuilder ? value : null;
  }

  ModuleIncomingCallPageBuilder? get _rtcIncomingCallPageBuilder {
    final runtime = widget.runtime;
    final feature = runtime?.registry.featureById(
      ModuleRouteIds.rtcIncomingCall,
    );
    if (feature == null || !runtime!.isModuleEnabled(feature.moduleId)) {
      return null;
    }
    final value = feature.value;
    return value is ModuleIncomingCallPageBuilder ? value : null;
  }

  /// 双击 tab 回顶用. 持 GlobalKey 拿 MessagesPageState / ContactsPageState
  /// 调对应 scrollToTop(). 对齐 iOS UITabBarController.scrollsToTop 默认行为 +
  /// 微信/Telegram 在已选中 tab 上双击 → 列表 animateTo(0).
  /// tab 2 (发现) 是 fixed Column 不滚, tab 3 (我) 故意 NeverScrollableScrollPhysics,
  /// 这俩不需要 key.
  final GlobalKey<MessagesPageState> _messagesKey =
      GlobalKey<MessagesPageState>();
  final GlobalKey<ContactsPageState> _contactsKey =
      GlobalKey<ContactsPageState>();

  late List<ChatConversation> _conversations;
  late ConversationThreadStore _messageThreads;
  late List<UiContact> _contacts;
  late List<UiGroup> _groups;
  late List<UiFriendRequest> _friendRequests;
  late String _profileName;
  late String _profileShortNo;
  late String _profileSex;
  StreamSubscription<List<WukongConversationSnapshot>>?
  _conversationSubscription;
  StreamSubscription<WukongMessageSnapshot>? _messageSubscription;
  StreamSubscription<void>? _friendChangeSubscription;
  StreamSubscription<IncomingCallEvent>? _incomingCallSubscription;
  // 远端 / 跨设备清空频道事件 — 收到时清 _messageThreads + 会话 preview.
  // 没这条之前 A 设备清空, B 设备打开聊天还能看到旧消息 (SDK DB 已 sync
  StreamSubscription<WukongChannelClearedSignal>? _channelClearedSubscription;
  // 单条消息删除事件 (clientMsgNo 维度) — 远端撤回 / 其它设备删消息 sync.
  StreamSubscription<String>? _messageDeletedSubscription;

  /// Push 通知点击 → 跳对应 chat 页. 三条来源 (iOS APNS native /
  /// Android FCM / 本地通知) 都 emit 到 `PushRouter.instance.tapStream`,
  /// HomeShell 订阅一次, 收 `PushTapEvent` → 找对应 `ChatConversation` →
  /// 调 `_openChat`.
  StreamSubscription<PushTapEvent>? _pushTapSubscription;

  /// 朋友圈通知本地服务: 持久化通知列表 + 未读 + 监听 IM CMD
  /// `momentMsg` (对齐 iOS WKMomentMsgManager 单例).
  late final MomentNotificationGateway? _momentMsgService =
      createMomentNotificationGateway(widget.session.uid);

  /// 已读好友请求 uid set — 持久化在 SharedPreferences. 对齐 iOS
  /// WKFriendRequestDB.readed 列. 用户点击"新的朋友"入口时
  /// (ContactsPage 的 _openContactAction case) markAllRead 一次性把
  /// 当前 _friendRequests 全部 uid 加进去, badge 立刻清零. 接受/拒绝
  /// 操作走 accepted/refused 字段不需要塞进这里.
  Set<String> _readFriendRequestUids = <String>{};
  String get _readFriendRequestPrefsKey =>
      'friend_request_read_uids::${widget.session.uid}';

  /// True while an IncomingCallPage is mounted on top of the
  /// navigator. Prevents stacking a second incoming-call page when
  /// the SDK delivers the same `invoke` CMD multiple times in a row
  /// (the IM long-connection retries on weak network).
  bool _incomingCallVisible = false;

  /// 当前 IncomingCallPage 对应的 call key — 用来匹配后续 cancel/refuse
  /// /hangup CMD 是不是同一通来电. 之前只看 _incomingCallVisible, 别的
  /// 会话延迟到达的 hangup CMD 会误把当前来电 dismiss 掉 → 用户漏接.
  /// 格式: P2P → fromUid; group → roomId. 空 = 没有挂着的来电.
  String _incomingCallKey = '';

  // ── CallKit (系统级来电 UI) 桥接 ─────────────────────────────────
  // 收到 invoke CMD → 同时弹 IncomingCallPage + 调 CallKitBridge.showIncoming.
  // 锁屏 / 后台时 native CallKit UI 接管 (前提 IM 长连接还活); 用户从 CallKit
  // 接听/拒绝 → broadcast 回 home_shell, 走跟 IncomingCallPage 同款的
  // gateway.accept/refuse 路径. mutex 用 _currentIncomingEvent (Page 接听 +
  // CallKit 接听任一方处理后 set null).
  StreamSubscription<CallKitAction>? _callKitAcceptSub;
  StreamSubscription<CallKitAction>? _callKitDeclineSub;
  StreamSubscription<CallKitAction>? _callKitEndSub;
  IncomingCallEvent? _currentIncomingEvent;

  /// CallKit 已 accept / decline 过的来电 tombstone — 防 IM CMD invoke 延迟
  /// 到达 (FCM data + IM 长连接可能数秒不同步), 我们已经在 native CallKit
  /// 处理完成后再弹一个 Flutter IncomingCallPage.
  ///
  /// **Key = call_instance_id** (server invoke 生成的 uuid, 一次通话唯一).
  /// tombstone → 第二次通话被 suppress. 现在用 instance id, 同一对人下
  /// 一次通话有新 id 不冲突. 即使如此仍保留 60s TTL 防 cache 涨.
  final Map<String, DateTime> _handledCallKeys = <String, DateTime>{};
  static const Duration _handledCallKeyTtl = Duration(seconds: 60);

  /// CallKit accept/decline plugin event 防重入 — plugin 可能 burst-fire
  /// (Android ConnectionService 内部 race), 用户也可能 double-tap. 没
  /// mutex 时多发 → 双倍 gateway.refuse → 对方对话页收 N 条 hangup.
  bool _processingCallKitEvent = false;

  bool _isCallHandled(String key) {
    if (key.isEmpty) return false;
    final at = _handledCallKeys[key];
    if (at == null) return false;
    if (DateTime.now().difference(at) > _handledCallKeyTtl) {
      _handledCallKeys.remove(key);
      return false;
    }
    return true;
  }

  /// 用旧 schema (fromUid / roomId) 兼容老 server.
  String _callKeyFor(IncomingCallEvent event) {
    if (event.callInstanceId.isNotEmpty) return event.callInstanceId;
    return event.isGroupCall ? event.roomId : event.fromUid;
  }

  void _markCallHandled(IncomingCallEvent event) {
    final key = _callKeyFor(event);
    if (key.isEmpty) return;
    _handledCallKeys[key] = DateTime.now();
    final now = DateTime.now();
    _handledCallKeys.removeWhere(
      (_, at) => now.difference(at) > _handledCallKeyTtl,
    );
  }

  // Tombstone state 已迁到 CallSessionController.state.endedRoomIds +
  // controller.markRoomEnded() (Phase 1C step 1). 这里读取改走 controller,
  // 不再有 HomeShell-local field. controller dispose 时 reset, 跟 _CallSession
  // 同生命周期对齐. iOS WKRTCManager 也是把这种 process-local cache 放在
  // manager 单例里, 跟 view 解耦.

  /// Guard against double-push when the user taps multiple
  /// conversation rows while `loadMessages` is in flight. The fetch
  /// is awaited before `Navigator.push`, so without this every queued
  /// tap fires its own push and the user lands on a stack of chat
  /// pages opened in rapid succession.
  bool _openingChat = false;

  @override
  void initState() {
    super.initState();
    final hasIm = widget.imGateway != null;
    // Cold-start fast-path: 用 main.dart 预加载的 cached snapshots 直接 seed
    // _conversations, 让 first frame 就显示完整列表 (跨 process 也秒显, SDK
    // db 持久化 + main 启动期间 await 预热). 没 cache (登录前 / 预热失败) 走
    // 空列表, _loadRemoteConversations 异步填充 — 跟旧行为一致.
    final preloaded = hasIm ? widget.imGateway!.cachedConversations : null;
    if (hasIm && preloaded != null && preloaded.isNotEmpty) {
      _conversations = [
        for (var i = 0; i < preloaded.length; i++)
          ChatConversation.fromSnapshot(
            preloaded[i],
            colors: conversationColors(i),
          ),
      ];
    } else {
      // 删 mock: 不再用 seedConversations 占位, 空起步由 _loadRemoteConversations 填。
      _conversations = <ChatConversation>[];
    }
    _messageThreads = ConversationThreadStore.seed(
      _conversations,
      fallbackBuilder: (_) => const <ChatMessage>[],
    );
    // 删 mock: contacts / groups / friendRequests 一律空起步, 由 social 同步填,
    // 不再 fallback seedContacts / seedGroups / seedFriendRequests。
    _contacts = <UiContact>[];
    _groups = <UiGroup>[];
    _friendRequests = <UiFriendRequest>[];
    _profileName = widget.session.displayName;
    _profileShortNo = widget.session.shortNo;
    _profileSex = widget.session.sexLabel;
    _conversationSubscription = widget.imGateway?.conversationSnapshots.listen(
      _applyRemoteConversations,
    );
    _messageSubscription = widget.imGateway?.messageSnapshots.listen(
      _applyRemoteMessage,
    );
    // Re-pull contacts / friend-requests whenever the IM gateway
    // surfaces a friendRequest / friendAccept / friendDeleted CMD.
    // Mirrors iOS WKContactsManager which re-syncs on each event.
    _friendChangeSubscription = widget.imGateway?.friendChangeSignals.listen(
      (_) => unawaited(_loadSocialSnapshot()),
    );
    _channelClearedSubscription = widget.imGateway?.channelClearedSignals
        .listen(_handleChannelCleared);
    _messageDeletedSubscription = widget.imGateway?.messageDeletedSignals
        .listen(_handleMessageDeleted);
    // Incoming RTC P2P calls — surface as a full-screen modal route
    // on top of whatever the user is currently looking at. iOS
    // equivalent: `WKRTCManager.onCmd:` pushing WKP2PChatView in
    // WKRTCViewTypeResponse mode.
    if (_isRtcEnabled) {
      _incomingCallSubscription = widget.imGateway?.incomingCallSignals.listen(
        _onIncomingCallEvent,
      );
      // CallKit 桥接 init + 3 个 broadcast listener. plugin event channel 全局
      // 一份 (CallKitBridge 单例 internal), 重复 initialize idempotent.
      unawaited(CallKitBridge.instance.initialize());
      _callKitAcceptSub = CallKitBridge.instance.onAccept.listen(
        _handleCallKitAccept,
      );
      _callKitDeclineSub = CallKitBridge.instance.onDecline.listen(
        _handleCallKitDecline,
      );
      _callKitEndSub = CallKitBridge.instance.onEnd.listen(_handleCallKitEnd);
      // CallSessionState immutable + 广播给 UI. 现在还在 scaffold 阶
      // 段 (Phase 1B), controller 跟原 _CallPage / _CallSessionStore
      // 并存. 渐进迁移走 Phase 1C/1D.
      _rtcSessionApi?.init?.call(
        callGateway: widget.callGateway,
        imGateway: widget.imGateway,
      );
    }
    // 朋友圈通知服务: 加载历史 + 监听 momentMsg CMD
    // 同模式: 当前登录会话也设全局单例, 给 _resolveSelfName / 各 helper
    // fallback 用 (loginName 跨 widget tree 不便处处 thread).
    UserSession.current = widget.session;
    AppRuntime.current = widget.runtime;
    // 同模式: 全局 imGateway 单例, 给 group_pages 等跨多层透传场景用.
    ChatImGateway.current = widget.imGateway;
    unawaited(_momentMsgService?.start(widget.imGateway) ?? Future.value());
    // 朋友圈未读 → 发现 TAB badge: 监听 ValueNotifier 让 unreadCount
    // 变化触发 setState (TAB bar 在 build 内读 .value). 跟好友请求
    // _friendRequests 已经走 state 字段、改动经 setState 已 reactive
    // 不同, ValueNotifier 不会自动驱动 ancestor rebuild.
    _momentMsgService?.unreadCount.addListener(_onMomentUnreadChanged);
    // Bind MomentFeedCache to current loginUid. logout-then-login-as-B (无杀进程)
    // main.dart 的 logout 路径也调 clear() 做 belt-and-suspenders, 二者协作.
    if (widget.session.uid.isNotEmpty) {
      bindSocialProcessCaches(widget.session.uid);
    }
    unawaited(_loadReadFriendRequestUids());
    unawaited(_loadRemoteConversations());
    unawaited(_loadSocialSnapshot());
    // Push tap → 跳 chat 页. 三条来源 (iOS APNS native / Android FCM /
    // 本地通知) 都 emit 到 `PushRouter`, 这里订阅一次. 见 push_service.dart.
    _pushTapSubscription = PushRouter.instance.tapStream.listen(_handlePushTap);
  }

  /// 算当前总未读 (排除 mute) 上报 server → server 推 push 时塞到 APNS
  /// badge / FCM badge field, 客户端图标角标实时同步. 对齐 iOS 原版
  /// WKApp.m:639 `[[WKAPIClient sharedClient] POST:@"user/device_badge"]`.
  /// 同时调 iOS native `setApplicationIconBadgeNumber:` 立即清桌面图标
  /// (对齐 WKApp.m:638) — server 接口只影响**下次 push 时**塞到 badge 字段,
  /// 不立即更新桌面图标, 用户读完消息没收新 push 桌面角标永远不减.
  /// 频率: _applyRemoteMessage / _applyRemoteConversations / _openChat
  /// (清 unread) 后调, fire-and-forget 失败静默.
  void _syncBadge() {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    final total = _conversations.fold<int>(
      0,
      (sum, c) => sum + (c.muted ? 0 : c.unread),
    );
    unawaited(
      gateway.updateBadge(total).catchError((e) {
        debugPrint('[badge] updateBadge fail: $e');
      }),
    );
    unawaited(PushService.setIconBadge(total));
  }

  /// 收到 push tap event → 找对应 ChatConversation 调 _openChat. 找不到
  /// (e.g. 这条 push 对应的会话还没出现在 list, 或者 conversation list 还
  /// 在 hydrate) → 先切到 messages tab + 静默 skip (用户可以手动找).
  Future<void> _handlePushTap(PushTapEvent event) async {
    if (!mounted) return;
    setState(() => _tabIndex = 0);
    // RTC 邀请 push tap — 直接构造 `IncomingCallEvent` 走 `_onIncomingCallEvent`
    // push 接听 modal. server `/rtc/rooms/pending` 只查群通话 (RTCRoom 表),
    // P2P 邀请没 room state 查不到, 必须靠 push payload 直接重建. callType
    // 跟 fromUid 来自 server APNS payload (call_type / from_uid 字段).
    //
    // 风险: caller 可能已经 cancel, callee 拿过期 invite 强 push modal 看到
    // "假来电". 实际接听后 server 内 accept 流程会校验 caller 在线, 不在则
    // accept 失败 modal dismiss. 用户感知 = 看到来电 → 接 → 接不通, 比
    // 完全不弹 modal "为什么点 push 没反应" 体验好.
    if (event.isRtcInvite) {
      debugPrint('[push][router] RTC invite tap, push call modal — $event');
      _onIncomingCallEvent(
        IncomingCallEvent(
          kind: IncomingCallKind.invoke,
          fromUid: event.fromUid,
          callType: event.callType,
        ),
      );
      return;
    }
    final idx = _conversations.indexWhere(
      (c) =>
          c.channelId == event.channelId && c.channelType == event.channelType,
    );
    if (idx < 0) {
      debugPrint(
        '[push][router] tap target not in conversations, skip — '
        'event=$event',
      );
      return;
    }
    unawaited(_openChat(_conversations[idx]));
  }

  void _onMomentUnreadChanged() {
    if (!mounted) return;
    setState(() {});
  }

  /// SharedPreferences 加载已读 uid set, app 启动期一次性恢复.
  Future<void> _loadReadFriendRequestUids() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_readFriendRequestPrefsKey);
    if (list == null || list.isEmpty) return;
    if (!mounted) return;
    setState(() => _readFriendRequestUids = list.toSet());
  }

  Future<void> _saveReadFriendRequestUids() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _readFriendRequestPrefsKey,
      _readFriendRequestUids.toList(),
    );
  }

  /// 把当前 _friendRequests 全部 uid 加进 read set + 持久化. 对齐 iOS
  /// WKContactsModule.m:71 markAllFriendRequestToReaded 调用时机.
  /// 已经在 set 内的 uid noop, 否则 setState + persist.
  void _markAllFriendRequestsRead() {
    final allUids = <String>{
      for (final r in _friendRequests)
        if (r.uid.isNotEmpty) r.uid,
    };
    if (allUids.isEmpty) return;
    final added = allUids.difference(_readFriendRequestUids);
    if (added.isEmpty) return;
    setState(() {
      _readFriendRequestUids = {..._readFriendRequestUids, ...added};
    });
    unawaited(_saveReadFriendRequestUids());
  }

  /// 未读好友请求数 = _friendRequests 里 !accepted && !refused 且 uid
  /// 不在 read set 的数量. 跟 TAB bar 和 ContactsPage._withDynamicBadge
  /// 共用同一个 source of truth.
  int get _friendRequestUnreadCount {
    var count = 0;
    for (final r in _friendRequests) {
      if (r.accepted || r.refused) continue;
      if (r.uid.isEmpty) continue;
      if (_readFriendRequestUids.contains(r.uid)) continue;
      count += 1;
    }
    return count;
  }

  @override
  void dispose() {
    unawaited(_conversationSubscription?.cancel());
    unawaited(_messageSubscription?.cancel());
    unawaited(_friendChangeSubscription?.cancel());
    unawaited(_incomingCallSubscription?.cancel());
    unawaited(_pushTapSubscription?.cancel());
    unawaited(_channelClearedSubscription?.cancel());
    unawaited(_messageDeletedSubscription?.cancel());
    unawaited(_callKitAcceptSub?.cancel());
    unawaited(_callKitDeclineSub?.cancel());
    unawaited(_callKitEndSub?.cancel());
    // logout / 切账号 nuclear option — 关掉所有挂着的 CallKit UI, 防 native
    // 残留来电界面悬空 (用户切账号后旧账号的来电仍弹出).
    unawaited(CallKitBridge.instance.endAllCalls());
    unawaited(CallKitBridge.instance.dispose());
    if (UserSession.current == widget.session) {
      UserSession.current = null;
    }
    if (AppRuntime.current == widget.runtime) {
      AppRuntime.current = null;
    }
    if (ChatImGateway.current == widget.imGateway) {
      ChatImGateway.current = null;
    }
    _momentMsgService?.unreadCount.removeListener(_onMomentUnreadChanged);
    unawaited(_momentMsgService?.dispose() ?? Future.value());
    unawaited(_rtcSessionApi?.disposeAll?.call() ?? Future.value());
    super.dispose();
  }

  /// Dispatch logic for the 5 P2P call CMDs. `invoke` pushes the
  /// IncomingCallPage; `cancel`/`refuse`/`hangup` (when the page is
  /// up) pops it; `accept` is the caller-side echo and only matters
  /// while the user is on the outgoing _CallPage (handled there).
  void _onIncomingCallEvent(IncomingCallEvent event) {
    if (!mounted) return;
    switch (event.kind) {
      case IncomingCallKind.invoke:
        if (_incomingCallVisible) {
          // Duplicate retry — ignore.
          return;
        }
        // Tombstone guard ONLY for group calls — group roomId 是 server
        // 每次新生成, 安全 tombstone. P2P roomId 是 deterministic
        // (liveKitP2PRoomID = "A@B"), 同 A-B 永远同一个, tombstone 后
        // 第二次通话被永久 suppress → callee 收不到邀请. **真实 bug**.
        if (event.isGroupCall &&
            event.roomId.isNotEmpty &&
            (_rtcSessionApi?.isRoomEnded?.call(event.roomId) ?? false)) {
          debugPrint(
            '[call] suppressing invoke for ended group room ${event.roomId}',
          );
          return;
        }
        // CallKit 已处理过的来电 — IM CMD 延迟到 (FCM data 跟 IM 长连接异
        // 步, 可能差几秒). 后台 user 在 native CallKit 已 decline / accept,
        // 这条 IM CMD 再到达不能再弹一遍 IncomingCallPage.
        final invokeKey = _callKeyFor(event);
        if (_isCallHandled(invokeKey)) {
          debugPrint(
            '[call] suppressing invoke for already-handled call key=$invokeKey (TTL ${_handledCallKeyTtl.inSeconds}s)',
          );
          return;
        }
        // 不再 mark handled (tombstone 只在用户真正 accept/decline 之后才设).
        // 这样 bug 4 "新通话无 UI" 不会再发生 — 哪怕 FCM 丢了 / 上次 CallKit
        // 卡了, IM 长连接的 invoke CMD 仍能 push IncomingCallPage 让用户感知.
        // _pushIncomingCallPage 内 lifecycle 检查).
        // In-call guard: if we're already in a live call (own _CallPage
        // active, or PIP overlay), suppress the new invite. The
        // alternative (popping an incoming-call page on top of the
        // current call) was what users perceived as "挂断后还有莫名
        // 邀请打进来" + "可能收到多次" — typically a caller restarting
        // the group call while we were still in the previous one.
        if (_rtcSessionApi?.hasActiveCall() ?? false) {
          debugPrint('[call] suppressing invoke — already in an active call');
          return;
        }
        _incomingCallVisible = true;
        _incomingCallKey = event.isGroupCall ? event.roomId : event.fromUid;
        _pushIncomingCallPage(event);
      case IncomingCallKind.cancel:
      case IncomingCallKind.refuse:
      case IncomingCallKind.hangup:
        // The caller cancelled / a parallel device picked up / the
        // call ended remotely. If our IncomingCallPage is still up,
        // tear it down so the user isn't left staring at a stale
        // ringer page.
        //
        // Tombstone this roomId so any delayed `invoke` that arrives
        // after we dismiss the page can't re-open it. ONLY mark group
        // roomIds — P2P deterministic roomId 永久 tombstone 会让 A-B
        // 第二次通话 callee 收不到邀请.
        if (event.isGroupCall && event.roomId.isNotEmpty) {
          _rtcSessionApi?.markRoomEnded?.call(event.roomId);
        }
        // **关 native CallKit UI** — 无论 IncomingCallPage 是否挂着. VoIP
        // push 触发的 CallKit (iOS 后台) 跟 Flutter 主 isolate 脱钩 (跨
        // isolate), _currentIncomingEvent 是 null + _incomingCallVisible
        // false. 对方挂断时只关 IncomingCallPage 不关 native UI → CallKit
        // /Dynamic Island 卡死 (用户报"对方挂断后灵动岛 call 还在, 只能
        // 杀 app"). 直接用 event 算 UUID 给 plugin endCall(uuid).
        unawaited(CallKitBridge.instance.endCall(event: event));
        // **不要 mark handled** — 之前在这里加 _markCallHandled 是个 bug:
        // hangup CMD 是对方挂断 (call 真结束), 不是本机用户已处理. 加 mark
        // → 同一对人 60s 内再拨 → 我们 invoke 路径 _isCallHandled 命中 →
        // suppress (用户报"挂断一次后再呼不进去"根因). tombstone 只该
        // 在本机用户**主动** accept/decline 时设, 防 delayed CMD 重弹 UI;
        // hangup/cancel 已经天然结束了状态, 不需要再 tombstone.
        if (_incomingCallVisible) {
          // 延迟到达的 hangup/cancel/refuse CMD 误关当前来电 → 用户漏接.
          // P2P 比 fromUid, group 比 roomId.
          final eventKey = event.isGroupCall ? event.roomId : event.fromUid;
          if (eventKey.isNotEmpty &&
              _incomingCallKey.isNotEmpty &&
              eventKey != _incomingCallKey) {
            debugPrint(
              '[call] ignore unrelated ${event.kind} CMD (key=$eventKey current=$_incomingCallKey)',
            );
            break;
          }
          // 防止 Navigator pop race / 页面 dispose 没及时释放 audio
          // session — 先强制停铃声再 dismiss. IncomingCallPage dispose
          // 内也会 stopAll, 这里是 double-tap safety.
          unawaited(_rtcSessionApi?.stopRinging?.call() ?? Future.value());
          _dismissIncomingCallPage();
        }
      case IncomingCallKind.accept:
      case IncomingCallKind.switchToVideo:
      case IncomingCallKind.switchToVideoReply:
      case IncomingCallKind.switchToVoice:
        // All caller/callee-side _CallPage concerns. The home shell
        // doesn't react — `_handlePeerSideCmd` inside _CallPageState
        // handles these per active call.
        break;
    }
  }

  void _pushIncomingCallPage(IncomingCallEvent event) {
    // Group invite: prefer the group name + avatar over the lone
    // inviter so the callee sees "[群名] 邀请你加入语音通话" rather
    // than "[张三] 来电" which loses context (张三 might not even
    // be in callee's contacts).
    final String name;
    final String avatarLabel;
    final List<Color> avatarColors;
    final String avatarUrl;
    if (event.isGroupCall) {
      // Try _groups (saved groups) first, then fall back to
      // _conversations (any chat the user has open — includes
      // unsaved groups they're just members of). Without the
      // conversation fallback the user sees the raw 32-char
      // groupNo as the "name" whenever the group isn't pinned
      // into 保存的群聊.
      final group = _groups.cast<UiGroup?>().firstWhere(
        (g) => g?.groupNo == event.groupChannelId,
        orElse: () => null,
      );
      String resolvedName = group?.name ?? '';
      if (resolvedName.isEmpty) {
        final conv = _conversations.cast<ChatConversation?>().firstWhere(
          (c) =>
              c?.channelId == event.groupChannelId &&
              c?.channelType == WKChannelType.group,
          orElse: () => null,
        );
        resolvedName = conv?.name ?? '';
      }
      name = moyuIncomingCallTitle(
        isGroupCall: true,
        cachedName: resolvedName,
        rawIdentity: event.groupChannelId,
      );
      avatarLabel = name.isEmpty
          ? AppLocalizations.of(context).messagesGroupAvatarFallback
          : name.characters.first;
      avatarColors = conversationColors(name.hashCode.abs());
      // Group avatars go through AvatarResolver so the IncomingCallPage
      // keeps the same config/showUrl path as conversation list and chat
      // header.
      avatarUrl = AvatarResolver.group(
        config: widget.config,
        groupNo: event.groupChannelId,
      );
      // Trigger a server fetch so the local cache is populated for
      // the post-accept _CallPage even if the group wasn't loaded.
      // Fire-and-forget — the IncomingCallPage already has its best-
      // effort name from above.
      if (event.groupChannelId.isNotEmpty && resolvedName.isEmpty) {
        unawaited(
          widget.imGateway?.refreshChannel(
                channelId: event.groupChannelId,
                channelType: WKChannelType.group,
              ) ??
              Future.value(),
        );
      }
    } else {
      // Resolve display info — prefer (1) CMD-payload from_name,
      // (2) cached contact name, (3) neutral placeholder. uid remains
      // an internal key and must not be rendered as caller name.
      final fromUid = event.fromUid;
      final contact = _contacts.cast<UiContact?>().firstWhere(
        (c) => c?.uid == fromUid,
        orElse: () => null,
      );
      name = moyuIncomingCallTitle(
        isGroupCall: false,
        payloadName: event.fromName,
        cachedName: contact?.name ?? '',
        rawIdentity: fromUid,
      );
      // Reuse the same avatar-derivation rule as conversation list:
      // first character of the name (or '友' fallback) + palette by
      // stable name hash. Without it the IncomingCallPage avatar
      // diverges from the contacts row for the same uid.
      avatarLabel = name.isEmpty
          ? AppLocalizations.of(context).messagesFriendAvatarFallback
          : name.characters.first;
      avatarColors = conversationColors(name.hashCode.abs());
      avatarUrl = contact?.avatarPath ?? '';
    }
    // 记录当前来电 metadata — CallKit accept/decline 路径要复用这套
    // resolved name + avatar (CallKit native UI 不持有 Flutter 端的 name
    // resolution 结果). 必须在 push route + showIncoming **之前** set,
    // 防 plugin 事件先于此返回触发 _handleCallKitAccept 空读 event.
    _currentIncomingEvent = event;
    // 前台 IM CMD 路径已经 push IncomingCallPage, 再调 CallKit.showIncoming
    // → 两个 UI 同时拥有 accept/decline. CallKit accept 会 maybePop
    // IncomingCallPage; IncomingCallPage.dispose() 在 accept 飞行中又会
    // 主动 disconnectActiveRoom 防热麦 (5194f53b 历史修复) → 被刚加入的
    // LiveKit 房间反向断开 → callee 无音视频, caller 看到 callee 已进
    // 但 UI 空白.
    //
    // 正确分工: 前台 → IncomingCallPage (Flutter 自绘); 后台/锁屏 → CallKit
    // (走 VoIP push iOS / FCM data Android 路径自动触发 plugin showIncoming
    // 在 background isolate 弹起). 同一通通话永远只有一个 owner.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final isForeground = lifecycle == AppLifecycleState.resumed;
    if (!isForeground) {
      // 后台 / inactive → 调 plugin 显 CallKit. 通常这条路被 VoIP push / FCM
      // data 在 background isolate 早一步抢着 show 了; 这里是 IM 长连接还活
      // 着但 app 已 backgrounded 的 edge case 兜底.
      unawaited(
        CallKitBridge.instance.showIncoming(
          event: event,
          displayName: name,
          avatarUrl: avatarUrl,
        ),
      );
    } else {
      debugPrint('[call] 前台不调 showIncoming, IncomingCallPage owns this call');
    }
    final incomingCallBuilder = _rtcIncomingCallPageBuilder;
    if (incomingCallBuilder == null) {
      debugPrint('[call] incoming call ignored: RTC module route unavailable');
      return;
    }
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => incomingCallBuilder(
              ModuleIncomingCallPageRequest(
                event: event,
                callGateway: widget.callGateway,
                peerName: name,
                avatarLabel: avatarLabel,
                avatarColors: avatarColors,
                avatarUrl: avatarUrl,
                onAcceptedNavigate: (type, roomId) {
                  // IncomingCallPage 内的 _accept 成功 — 也要关 CallKit UI
                  // (防 native 界面悬空), 同时清 mutex.
                  unawaited(CallKitBridge.instance.endCall(event: event));
                  _currentIncomingEvent = null;
                  _onIncomingAccepted(
                    event: event,
                    type: type,
                    roomId: roomId,
                    peerName: name,
                    avatarLabel: avatarLabel,
                    avatarColors: avatarColors,
                    avatarUrl: avatarUrl,
                  );
                },
                onDismiss: _dismissIncomingCallPage,
              ),
            ),
          ),
        )
        .whenComplete(() {
          // Whatever path closes the page (pop / hang up / accept-and-
          // replace), clear the gate so the next invoke can push again.
          _incomingCallVisible = false;
          _incomingCallKey = '';
          _currentIncomingEvent = null;
        });
  }

  void _dismissIncomingCallPage() {
    if (!_incomingCallVisible) return;
    _incomingCallVisible = false;
    _incomingCallKey = '';
    // 同步关 CallKit native UI — IncomingCallPage 被 dismiss 时 (peer cancel
    // / refuse / hangup / timeout), CallKit 界面也得收, 否则用户能看到一个
    // 残留的 system 来电界面 (锁屏 / 拉下控制中心都会显).
    unawaited(CallKitBridge.instance.endCall(event: _currentIncomingEvent));
    _currentIncomingEvent = null;
    Navigator.of(context).maybePop();
  }

  // ── CallKit handlers ─────────────────────────────────────────────
  //
  // 用户从系统级来电 UI (CallKit / Android ConnectionService) 点接听 /
  // 拒绝 → plugin event → broadcast 到 home_shell. 跟 IncomingCallPage
  // 内部 _accept / _decline 同款路径 (gateway.accept / refuse). 两路
  // 互斥靠 _currentIncomingEvent: 任一方处理后 set null, 另一方 noop.

  /// 把 CallKit native UI accept 路由到跟 IncomingCallPage._accept 同款 flow.
  ///
  /// 两条事件来源:
  ///   1. IM CMD 路径 — home_shell._onIncomingCallEvent → _pushIncomingCallPage
  ///      已经 set _currentIncomingEvent + showIncoming. accept 时 event 在.
  ///   2. **FCM/VoIP push 路径** — background isolate 起 foxtalkFcmBackgroundHandler
  ///      或 iOS pushRegistry didReceiveIncomingPushWith 直接调 plugin showCallkitIncoming.
  ///      main isolate 的 _currentIncomingEvent 是 **null** (跨 isolate 数据没回传).
  ///      → fallback: 从 action.extra 重建 IncomingCallEvent (showIncoming 时塞的
  ///      字段在 plugin event payload 里原样回来).
  Future<void> _handleCallKitAccept(CallKitAction action) async {
    if (!mounted) return;
    if (_processingCallKitEvent) {
      debugPrint('[call] CallKit accept reentry blocked by mutex');
      return;
    }
    _processingCallKitEvent = true;
    try {
      await _handleCallKitAcceptInner(action);
    } finally {
      _processingCallKitEvent = false;
    }
  }

  /// 只 dismiss 系统 UI + push IncomingCallPage 让用户在 Flutter 里重新点接听.
  ///
  /// 原因: native CallKit event 不可靠 (跨 isolate race / lifecycle resume race
  /// / accept echo 触发 ended / audio session 死锁), 直接 gateway.accept 链路
  /// 已经 4 轮调试仍然失败. CallKit 改成"系统级唤醒 + 让用户感知有来电",
  /// 实际业务 accept/decline 由 Flutter IncomingCallPage 统一处理 → 状态立刻
  /// 收敛.
  ///
  /// 流程:
  ///   1. 后台 FCM/VoIP push → bg handler showCallkitIncoming
  ///   2. 用户 tap accept on system UI → plugin fire actionCallAccept
  ///   3. 本函数: endCall plugin UI + 确保 IncomingCallPage 已 push (没 push 就
  ///      reconstruct event 从 extra + _pushIncomingCallPage)
  ///   4. OS 自动 wake app to foreground (CallKit 行为)
  ///   5. 用户看到 IncomingCallPage → 再 tap 接听 → 正常 IncomingCallPage._accept
  ///      流程 (gateway.accept + LiveKit + _CallPage)
  ///
  /// 不再调 gateway, 不再考虑 lifecycle race.
  Future<void> _handleCallKitAcceptInner(CallKitAction action) async {
    final event = _currentIncomingEvent ?? _eventFromCallKitExtra(action.extra);
    if (event == null) {
      debugPrint(
        '[call] CallKit accept ignored — no event from state or extra',
      );
      unawaited(CallKitBridge.instance.endAllCalls());
      return;
    }
    if (action.uuid.isNotEmpty && action.uuid != CallKitBridge.uuidFor(event)) {
      debugPrint('[call] CallKit accept uuid mismatch — stale event ignored');
      unawaited(CallKitBridge.instance.endCall(event: event));
      return;
    }
    // 关 plugin 系统 UI — 让 OS 释放系统级 "正在响铃" 状态. 不再 gateway.accept,
    // 真业务 accept 走 IncomingCallPage. expectedEndUuids 保护 _handleCallKitEnd
    // 不会被这个 endCall echo 误触发 hangup.
    unawaited(CallKitBridge.instance.endCall(event: event));
    if (!mounted) return;
    // 如果 IncomingCallPage 还没 push (后台 invoke CMD 可能延迟或丢), 主动 push
    // 让用户进 app 时看到来电界面. _pushIncomingCallPage 已有 _incomingCallVisible
    // 去重, 重复调安全.
    if (!_incomingCallVisible) {
      debugPrint('[call] CallKit accept → push IncomingCallPage');
      _pushIncomingCallPage(event);
    } else {
      debugPrint('[call] CallKit accept → IncomingCallPage already visible');
    }
  }

  /// 把 CallKit native UI decline 路由到跟 IncomingCallPage._decline 同款 flow.
  /// 同 _handleCallKitAccept 注释: event 可能来自 IM CMD 路径 (state 里有)
  /// 或 FCM/VoIP push 路径 (state null, 从 action.extra 重建).
  Future<void> _handleCallKitDecline(CallKitAction action) async {
    if (_processingCallKitEvent) {
      debugPrint('[call] CallKit decline reentry blocked by mutex');
      return;
    }
    _processingCallKitEvent = true;
    try {
      await _handleCallKitDeclineInner(action);
    } finally {
      _processingCallKitEvent = false;
    }
  }

  Future<void> _handleCallKitDeclineInner(CallKitAction action) async {
    final event = _currentIncomingEvent ?? _eventFromCallKitExtra(action.extra);
    if (event == null) {
      debugPrint(
        '[call] CallKit decline ignored — no event from state or extra',
      );
      // 兜底关 plugin UI, 防 Android ConnectionService 卡在 "ringing" 不消失.
      unawaited(CallKitBridge.instance.endAllCalls());
      return;
    }
    // **立即 mark handled** — 在任何 await 之前, 防 IM CMD invoke 并行到
    // 弹 IncomingCallPage.
    _markCallHandled(event);
    if (action.uuid.isNotEmpty && action.uuid != CallKitBridge.uuidFor(event)) {
      unawaited(CallKitBridge.instance.endCall(event: event));
      return;
    }
    final gateway = widget.callGateway;
    final type = event.callType == 1 ? ChatCallType.video : ChatCallType.audio;
    _currentIncomingEvent = null;
    // 显式关 CallKit native UI — Android ConnectionService 不会因为 user tap
    // decline 自动消失, 必须 plugin.endCall(uuid). 早关防 gateway.refuse await
    // 期间用户感知 UI 卡住. iOS CallKit decline 已自动 dismiss, 这里多余调用
    // 也无害 (plugin internal idempotent).
    unawaited(CallKitBridge.instance.endCall(event: event));
    // gateway.refuse 加超时 — 后台 process 网络可能不通, 没超时无限挂.
    try {
      final task = event.isGroupCall
          ? gateway?.refuseCall(event.roomId)
          : gateway?.refuse(peerId: event.fromUid, type: type);
      await (task ?? Future.value()).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('[call] CallKit-triggered refuse failed: $e');
    }
    await (_rtcSessionApi?.stopRinging?.call() ?? Future.value());
    if (!mounted) return;
    if (_incomingCallVisible) {
      _incomingCallVisible = false;
      _incomingCallKey = '';
      Navigator.of(context).maybePop();
    }
  }

  /// 从 CallKit event payload 重建 IncomingCallEvent — 仅在 FCM bg / VoIP push
  /// 路径的 accept/decline 用 (main isolate 的 _currentIncomingEvent 是 null).
  /// extra schema 跟 CallKitBridge.showIncoming + fcm_call_background_handler
  /// 双写, 字段名严格对齐.
  IncomingCallEvent? _eventFromCallKitExtra(Map<String, dynamic> extra) {
    if (extra.isEmpty) return null;
    final fromUid = (extra['fromUid'] as String?) ?? '';
    final roomId = (extra['roomId'] as String?) ?? '';
    // P2P 至少要 fromUid, group 至少要 roomId.
    final isGroup = extra['isGroup'] == true;
    if (isGroup && roomId.isEmpty) return null;
    if (!isGroup && fromUid.isEmpty) return null;
    final callType = extra['callType'] is int
        ? extra['callType'] as int
        : (extra['callType'] is num ? (extra['callType'] as num).toInt() : 0);
    final groupChannelType = extra['groupChannelType'] is int
        ? extra['groupChannelType'] as int
        : (extra['groupChannelType'] is num
              ? (extra['groupChannelType'] as num).toInt()
              : 0);
    return IncomingCallEvent(
      kind: IncomingCallKind.invoke,
      fromUid: fromUid,
      fromName: (extra['fromName'] as String?) ?? '',
      callType: callType,
      roomId: roomId,
      isGroupCall: isGroup,
      groupChannelId: (extra['groupChannelId'] as String?) ?? '',
      groupChannelType: groupChannelType,
      callInstanceId: (extra['callInstanceId'] as String?) ?? '',
    );
  }

  /// CallKit / ConnectionService 系统挂断按钮 (Android 状态栏 / iOS 灵动岛/
  /// 锁屏 hangup) → plugin fire actionCallEnded.
  ///
  /// **expectedEndUuids 已经 filter 掉我们自己 endCall 的 echo** (CallKitBridge
  /// 收到的只可能是用户真的从系统 UI 挂断.
  ///
  /// 处理 end 事件.
  ///
  /// r3 #2). tombstone 只在用户真正 accept/decline 之后才设.
  Future<void> _handleCallKitEnd(CallKitAction action) async {
    if (!mounted) return;
    if (_processingCallKitEvent) {
      debugPrint('[call] CallKit end ignored — _processingCallKitEvent=true');
      return;
    }
    final event = _currentIncomingEvent ?? _eventFromCallKitExtra(action.extra);
    if (_incomingCallVisible) {
      _incomingCallVisible = false;
      _incomingCallKey = '';
      Navigator.of(context).maybePop();
    }
    _currentIncomingEvent = null;
    // 接业务挂断 — 走 controller.hangup, 跟 _CallPage hangup 同流程.
    // controller.hangup 内置 phase 防重入, 重复调安全.
    final sessionApi = _rtcSessionApi;
    if ((sessionApi?.hasActiveCall() ?? false) && event != null) {
      final peerOrRoom = event.isGroupCall ? event.roomId : event.fromUid;
      if (peerOrRoom.isNotEmpty) {
        debugPrint(
          '[call] CallKit end → trigger controller.hangup peerOrRoom=$peerOrRoom',
        );
        try {
          await sessionApi?.hangup?.call(peerOrRoomId: peerOrRoom);
        } catch (e) {
          debugPrint('[call] CallKit-end hangup failed: $e');
        }
      }
    } else if (event != null && widget.callGateway != null) {
      // 还没 active call (例如 ringing 时被系统挂断), 直接发 refuse/cancel.
      final type = event.callType == 1
          ? ChatCallType.video
          : ChatCallType.audio;
      try {
        if (event.isGroupCall) {
          await widget.callGateway!
              .refuseCall(event.roomId)
              .timeout(const Duration(seconds: 5));
        } else if (event.fromUid.isNotEmpty) {
          await widget.callGateway!
              .refuse(peerId: event.fromUid, type: type)
              .timeout(const Duration(seconds: 5));
        }
      } catch (e) {
        debugPrint('[call] CallKit-end refuse failed: $e');
      }
    }
  }

  /// User tapped 接听 on IncomingCallPage and the gateway resolved.
  /// Swap the modal for the connected _CallPage. We `pushReplacement`
  /// so the in-call page doesn't sit on top of a stale incoming page.
  void _onIncomingAccepted({
    required IncomingCallEvent event,
    required ChatCallType type,
    required String roomId,
    required String peerName,
    required String avatarLabel,
    required List<Color> avatarColors,
    required String avatarUrl,
  }) {
    // Group acceptance: conversation hangs on the group's channelId
    // so hangup routes through `/rtc/rooms/{id}/hangup` (we still
    // need _groupRoomId in _CallPage for that). Otherwise the
    // conversation is the peer 1:1 channel.
    final conversation = event.isGroupCall
        ? ChatConversation(
            channelId: event.groupChannelId,
            channelType: WKChannelType.group,
            name: peerName,
            avatarLabel: avatarLabel,
            avatarPath: avatarUrl,
            colors: avatarColors,
            preview: '',
            time: '',
          )
        : ChatConversation(
            channelId: event.fromUid,
            channelType: WKChannelType.personal,
            name: peerName,
            avatarLabel: avatarLabel,
            avatarPath: avatarUrl,
            colors: avatarColors,
            preview: '',
            time: '',
          );
    _incomingCallVisible = false;
    _incomingCallKey = '';
    // Build invitedContacts so the callee sees the same "邀请中…"
    // tile grid the caller sees, including the inviter + every other
    // invitee. Without this the callee only saw their own tile + any
    // remote that already joined LiveKit, never the pending ones.
    final invitedContacts = <UiContact>[];
    if (event.isGroupCall) {
      final seen = <String>{};
      void addUid(String uid) {
        if (uid.isEmpty || seen.contains(uid)) return;
        if (uid == widget.session.uid) return;
        seen.add(uid);
        final match = _contacts.cast<UiContact?>().firstWhere(
          (c) => c?.uid == uid,
          orElse: () => null,
        );
        if (match != null) {
          invitedContacts.add(match);
        } else {
          // Synthesize a minimal contact so the tile renders even
          // when the callee isn't friends with this uid, without
          // leaking the raw uid as display text.
          final shortLabel = AppLocalizations.of(context).messagesUnknownUser;
          invitedContacts.add(
            UiContact(
              uid: uid,
              name: shortLabel,
              avatarLabel: shortLabel.characters.first,
              colors: conversationColors(invitedContacts.length),
              avatarPath: AvatarResolver.user(config: widget.config, uid: uid),
            ),
          );
        }
      }

      addUid(event.fromUid);
      for (final uid in event.groupParticipants) {
        addUid(uid);
      }
    }
    final callBuilder = _rtcCallPageBuilder;
    if (callBuilder == null) {
      debugPrint('[call] accepted call ignored: RTC module route unavailable');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => callBuilder(
          ModuleCallPageRequest(
            conversation: conversation,
            callGateway: widget.callGateway,
            imGateway: widget.imGateway,
            type: type,
            isIncoming: true,
            incomingRoomId: roomId,
            isGroupCall: event.isGroupCall,
            invitedContacts: invitedContacts,
            // Best-effort: from the home shell we only have the global
            // friend list. The chat-screen path layers in group members
            // on top, but for incoming-call acceptance there's no chat
            // page open yet — pass friends so the inviter at least
            // shows their name if we're already friends.
            knownContacts: event.isGroupCall ? _contacts : const [],
            config: widget.config,
            selfUid: widget.session.uid,
            selfName: widget.session.name,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tabBarStyleCtrl = context
        .dependOnInheritedWidgetOfExactType<TabBarStyleController>();
    final tabBarStyle = tabBarStyleCtrl?.current ?? TabBarStyleStore.glassDock;
    final useGlassDock = tabBarStyle == TabBarStyleStore.glassDock;
    final tabBarAccentColor =
        useGlassDock && tabBarStyleCtrl?.dockFollowsChatColor == true
        ? BubbleColorStore.colorsFor(
            BubbleColorController.of(context).current,
            Theme.of(context).brightness,
          ).bg1
        : null;
    // Tab bar is now drawn as a Positioned overlay on top of the page
    // body (instead of FScaffold's footer slot) so the page content can
    // scroll UNDER it — same iOS-WeChat-style layout where the last
    // conversation row partially shows behind a translucent tab bar
    // rather than ending at a hard "content → empty gap → tab bar"
    // boundary. Pages bake `kTabBarReservedHeight` into their bottom
    // padding so the very last item is still tappable when scrolled
    // all the way down.
    return Semantics(
      identifier: 'moyu.home.screen',
      container: true,
      child: FScaffold(
        childPad: false,
        child: Stack(
          children: [
            // 修 #7: 最底铺一层 MoyuColors.background, 让 4 个 tab 页面底色跟
            // 顶部 nav / 底部 tab bar 的 glass 基色 (dark #0F0F12) 同源。否则
            // 页面透出 forui FScaffold 的 dark 底色, 跟 nav 有明显色差。
            Positioned.fill(
              child: ColoredBox(color: MoyuColors.of(context).background),
            ),
            // Page extends fully to screen top + bottom. Each page's
            // own MoyuGlass header (Positioned top:0) handles status
            // bar inset internally via SafeArea(bottom:false) inside
            // the glass, so the glass bg + blur extend UP to y=0 and
            // status bar icons render on the blurred header — the
            // iOS-WeChat-style "通顶" header. Tab bar overlay below
            // similarly extends INTO the safe-bottom area.
            Positioned.fill(child: _activePage()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MoyuTabBar(
                style: useGlassDock
                    ? MoyuTabBarStyle.glassDock
                    : MoyuTabBarStyle.classic,
                accentColor: tabBarAccentColor,
                index: _tabIndex,
                onChange: (index) => setState(() => _tabIndex = index),
                onSearch: useGlassDock ? _openGlobalSearch : null,
                items: [
                  MoyuTabBarItemSpec(
                    icon: MoyuIconName.message,
                    label: t.tabMessages,
                    identifier: 'moyu.tab.messages',
                    // 累计未读 — 排除 mute 会话 (对齐 iOS
                    // WKConversationListVM.getAllUnreadCount).
                    badge: _conversations.fold<int>(
                      0,
                      (sum, c) => sum + (c.muted ? 0 : c.unread),
                    ),
                    // 双击 tab → 第一条未读；都已读时回顶。
                    onDoubleTap: () =>
                        _messagesKey.currentState?.scrollToUnreadOrTop(),
                  ),
                  MoyuTabBarItemSpec(
                    icon: MoyuIconName.contacts,
                    label: t.tabContacts,
                    identifier: 'moyu.tab.contacts',
                    // 未读好友请求 — 跟 ContactsPage._withDynamicBadge
                    // 共用同一 source of truth (_friendRequestUnreadCount),
                    // 用户点击"新的朋友"入口会 markAllRead 清零 badge.
                    // 对齐 iOS WKContactsHeaderItem 走
                    // WKFriendRequestDB.readed=0 count.
                    badge: _friendRequestUnreadCount,
                    onDoubleTap: () => _contactsKey.currentState?.scrollToTop(),
                  ),
                  MoyuTabBarItemSpec(
                    icon: MoyuIconName.discover,
                    label: t.tabDiscover,
                    identifier: 'moyu.tab.discover',
                    // 朋友圈通知未读 — 走 MomentMsgService.unreadCount
                    // ValueNotifier. listener 在 initState 已挂, 变化
                    // 触发 setState → 这里读到新值.
                    badge: _momentMsgService?.unreadCount.value ?? 0,
                  ),
                  MoyuTabBarItemSpec(
                    icon: MoyuIconName.me,
                    label: t.tabMe,
                    identifier: 'moyu.tab.me',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGlobalSearch() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => GlobalSearchPage(
          conversations: _conversations,
          contacts: _contacts,
          groups: _groups,
          socialGateway: widget.socialGateway,
          config: widget.config,
          serverAppConfig: widget.serverAppConfig,
          onOpenChat: _openChat,
          onOpenContactChat: _openContactChat,
        ),
      ),
    );
  }

  Future<void> _openChat(ChatConversation conversation) async {
    // Drop taps that arrive while a previous open is still loading
    // — otherwise queued micro-tasks all fire their own push and the
    // user lands on a stack of chat pages.
    if (_openingChat) {
      return;
    }
    _openingChat = true;
    try {
      // 聊天密码拦截 — 对齐 iOS WKConversationListVC.didSelectRow:
      //   if (channelInfo.chat_pwd_on && loginInfo.chat_pwd != '') → prompt
      // 用户输 6 位数字, MD5(pwd+uid) 跟全局密码 digest 比, 错 3 次清记录.
      // 错误次数本地 prefs 持久化, key 跟 iOS 同名:
      //   chatpwderror_<loginUid>_<channelId>_<channelType>
      // 全局 chatPwd digest 也走 prefs (`chatPwdDigest:<uid>`) — session
      // 字段 cold snapshot 不刷新, 用户设密码后那里永远空, 必须查 prefs
      // 拿到 setChatPassword 时持久化的 digest.
      if (conversation.chatPasswordEnabled) {
        final prefs = await SharedPreferences.getInstance();
        final loginChatPwd =
            prefs.getString('chatPwdDigest:${widget.session.uid}') ??
            widget.session.chatPwd;
        if (loginChatPwd.isNotEmpty) {
          if (!mounted) return;
          final ok = await _promptChatPassword(conversation, loginChatPwd);
          if (!ok || !mounted) {
            return;
          }
        }
      }
      // Capture the pre-zeroed unread count BEFORE clearing it so
      // `ChatScreen` can position the unread divider and seed the
      // @-mention FAB from the messages that were unread on open.
      // Zeroing in `openedConversation` is what removes the chat-list
      // red dot but it would otherwise hide the unread window from
      // the chat screen entirely.
      final preOpenUnread = conversation.unread;
      final openedConversation = conversation.copyWith(unread: 0);
      _replaceConversation(openedConversation);
      unawaited(_clearRemoteUnread(openedConversation));
      // 打开会话后该 conversation unread 清 0 → 总 badge 同步.
      _syncBadge();

      final initialMessages = _initialMessagesForOpenChat(openedConversation);
      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatScreen(
            conversation: openedConversation,
            initialUnread: preOpenUnread,
            // 算 push 时其他会话未读 — chat header back 右 badge 用,
            // 跟微信 chat 页返回箭头右"(N)"同源. 排除本会话 + mute.
            initialOtherChatsUnread: _conversations.fold<int>(
              0,
              (sum, c) =>
                  sum +
                  ((c.muted ||
                          (c.channelId == openedConversation.channelId &&
                              c.channelType == openedConversation.channelType))
                      ? 0
                      : c.unread),
            ),
            initialMessages: initialMessages,
            initialAnchorMessageId: conversation.searchAnchorMessageId,
            config: widget.config,
            serverAppConfig: widget.serverAppConfig,
            contacts: _contacts,
            groups: _groups,
            loginUid: widget.session.uid,
            loginName: widget.session.displayName,
            loginChatPwd: widget.session.chatPwd,
            loginToken: widget.session.token,
            imGateway: widget.imGateway,
            messageStream: widget.imGateway?.messageSnapshots,
            aguiEventStream: widget.imGateway?.aguiEventSnapshots,
            socialGateway: widget.socialGateway,
            mediaGateway: widget.mediaGateway,
            scanGateway: widget.scanGateway,
            callGateway: widget.callGateway,
            runtime: widget.runtime,
            onSendText:
                (
                  text, {
                  List<String> mentionUids = const [],
                  bool mentionAll = false,
                  String replyMessageId = '',
                  int replyMessageSeq = 0,
                  String replyFromUid = '',
                  String replyFromName = '',
                  String replyText = '',
                }) => _recordSentText(
                  openedConversation,
                  text,
                  mentionUids: mentionUids,
                  mentionAll: mentionAll,
                  replyMessageId: replyMessageId,
                  replyMessageSeq: replyMessageSeq,
                  replyFromUid: replyFromUid,
                  replyFromName: replyFromName,
                  replyText: replyText,
                ),
            onSendMedia: (attachment) =>
                _recordSentMedia(openedConversation, attachment),
            onSendSticker: (sticker) =>
                _recordSentSticker(openedConversation, sticker),
            onSendLocation: (location) =>
                _recordSentLocation(openedConversation, location),
            onClearMessages: () =>
                _clearConversationMessages(openedConversation),
            onDeleteConversation: () => _deleteConversation(openedConversation),
            onContactRemoved: _removeContactEverywhere,
            // 接通: 聊天页内点 @mention/资料页发消息 → 打开目标会话 (叠当前页上).
            onOpenContactChat: _openContactChat,
          ),
        ),
      );
    } finally {
      // Always release the guard — even when the chat page is popped
      // back, mounted-check fails, or the load throws.
      _openingChat = false;
    }
  }

  Widget _activePage() {
    // IndexedStack 让 4 个 tab page 同时存在 widget tree, 仅 paint index 指向的
    // 那个. 切 tab 不销毁旧 widget → 滚动位置 / ScrollController / 图片
    // ImageStream cache / cell state 全保留. 对齐 iOS UITabBarController 默认
    // 行为 (切 tab 不 dealloc childVC), 修复用户报"每次进入仿佛重新加载".
    // 代价: 启动时 4 个 page 都 initState 一次. 但 _DiscoverPage / _ProfilePage
    // 是 Stateless 无 initState 开销, MessagesPage / ContactsPage initState
    // 主要订阅 IM stream + 联系人, 都已经在 home_shell 层做过, 不重复 fetch.
    return IndexedStack(
      index: _tabIndex,
      children: [
        MessagesPage(
          key: _messagesKey,
          conversations: _conversations,
          contacts: _contacts,
          groups: _groups,
          config: widget.config,
          imGateway: widget.imGateway,
          socialGateway: widget.socialGateway,
          scanGateway: widget.scanGateway,
          loginUid: widget.session.uid,
          loginName: _profileName,
          serverAppConfig: widget.serverAppConfig,
          showTopSearchEntry:
              (context
                      .dependOnInheritedWidgetOfExactType<
                        TabBarStyleController
                      >()
                      ?.current ??
                  TabBarStyleStore.glassDock) !=
              TabBarStyleStore.glassDock,
          onOpenChat: _openChat,
          onOpenContactChat: _openContactChat,
          onOpenGroupChat: _openGroupChat,
          onCreateGroup: _createGroup,
          onConversationCleared: _clearConversationMessages,
          onSocialChanged: _loadSocialSnapshot,
          onContactChanged: _updateContactEverywhere,
          onContactRemoved: _removeContactEverywhere,
        ),
        ContactsPage(
          key: _contactsKey,
          contacts: _contacts,
          groups: _groups,
          groupCandidates: _knownGroupCandidates,
          friendRequests: _friendRequests,
          friendRequestUnread: _friendRequestUnreadCount,
          loginUid: widget.session.uid,
          loginName: _profileName,
          showTopSearchEntry:
              (context
                      .dependOnInheritedWidgetOfExactType<
                        TabBarStyleController
                      >()
                      ?.current ??
                  TabBarStyleStore.glassDock) !=
              TabBarStyleStore.glassDock,
          callGateway: widget.callGateway,
          imGateway: widget.imGateway,
          config: widget.config,
          socialGateway: widget.socialGateway,
          scanGateway: widget.scanGateway,
          runtime: widget.runtime,
          serverAppConfig: widget.serverAppConfig,
          onAcceptFriendRequest: _acceptFriendRequest,
          onRefuseFriendRequest: _refuseFriendRequest,
          onDeleteFriendRequest: _deleteFriendRequest,
          onRefreshFriendRequests: _loadSocialSnapshot,
          onMarkFriendRequestsRead: _markAllFriendRequestsRead,
          onOpenContactChat: _openContactChat,
          onOpenGroupChat: _openGroupChat,
          onSaveGroup: _saveExistingGroup,
          onSocialChanged: _loadSocialSnapshot,
          onContactChanged: _updateContactEverywhere,
          onContactRemoved: _removeContactEverywhere,
        ),
        DiscoverPage(
          socialGateway: widget.socialGateway,
          scanGateway: widget.scanGateway,
          loginUid: widget.session.uid,
          loginName: _profileName,
          contacts: _contacts,
          config: widget.config,
          onOpenGroupChat: _openGroupChat,
          onCreateGroup: _createGroup,
          momentMsgService: _momentMsgService,
          runtime: widget.runtime,
          scanPageBuilder: (_) => ScanPage(
            config: widget.config,
            socialGateway: widget.socialGateway,
            scanGateway: widget.scanGateway,
            callGateway: widget.callGateway,
            contacts: _contacts,
            onOpenContactChat: _openContactChat,
            onOpenGroupChat: _openGroupChat,
            loginUid: widget.session.uid,
            loginName: _profileName,
            webLoginConfirmPageBuilder: (_, authCode, socialGateway) =>
                WebLoginConfirmPage(
                  authCode: authCode,
                  socialGateway: socialGateway,
                ),
            contactDetailPageBuilder:
                (_, {required contact, required isStranger}) =>
                    ContactDetailPage(
                      contact: contact,
                      loginUid: widget.session.uid,
                      loginName: _profileName,
                      callGateway: widget.callGateway,
                      socialGateway: widget.socialGateway,
                      imGateway: widget.imGateway,
                      onSocialChanged: _loadSocialSnapshot,
                      onContactChanged: _updateContactEverywhere,
                      onContactRemoved: _removeContactEverywhere,
                      config: widget.config,
                      isStranger: isStranger,
                      onOpenChat: _openContactChat,
                    ),
          ),
          onOpenUserCard: (context, uid, displayName) => openUserCardByUid(
            context,
            uid: uid,
            displayName: displayName,
            loginUid: widget.session.uid,
            loginName: _profileName,
            contacts: _contacts,
            socialGateway: widget.socialGateway,
            config: widget.config,
          ),
        ),
        ProfilePage(
          session: widget.session,
          config: widget.config,
          imGateway: widget.imGateway,
          socialGateway: widget.socialGateway,
          runtime: widget.runtime,
          serverAppConfig: widget.serverAppConfig,
          displayName: _profileName,
          shortNo: _profileShortNo,
          sex: _profileSex,
          contacts: _contacts,
          appearancePageBuilder: (_) => AppearancePage(
            config: widget.config,
            loginUid: widget.session.uid,
            socialGateway: widget.socialGateway,
          ),
          securityPrivacyPageBuilder: (_) => SecurityPrivacyPage(
            loginUid: widget.session.uid,
            loginPhone: widget.session.displayPhone.isEmpty
                ? widget.session.uid
                : widget.session.displayPhone,
            chatPwd: widget.session.chatPwd,
            lockAfterMinute: widget.session.lockAfterMinute,
            settings: widget.session.settings,
            socialGateway: widget.socialGateway,
            config: widget.config,
            serverAppConfig: widget.serverAppConfig,
          ),
          notificationSettingsPageBuilder: (_) => NotificationSettingsPage(
            settings: widget.session.settings,
            socialGateway: widget.socialGateway,
          ),
          commonSettingsPageBuilder: (_) => CommonSettingsPage(
            config: widget.config,
            serverScope: widget.serverScope,
            session: widget.session,
            loginUid: widget.session.uid,
            imGateway: widget.imGateway,
            socialGateway: widget.socialGateway,
            onLogout: widget.onLogout,
          ),
          onProfileChanged: _updateProfile,
          onLogout: widget.onLogout,
        ),
      ],
    );
  }

  void _updateProfile({String? name, String? shortNo, String? sex}) {
    setState(() {
      if (name != null && name.isNotEmpty) {
        _profileName = name;
      }
      if (shortNo != null && shortNo.isNotEmpty) {
        _profileShortNo = shortNo;
      }
      if (sex != null && sex.isNotEmpty) {
        _profileSex = sex;
      }
    });
    // 写回 UserSession.current + SessionStore.save 持久化, 避免假保存
    // (改完 server 但客户端 UserSession 没动 → app 重启 / page rebuild
    // 时回弹 stale 数据).
    final current = UserSession.current;
    if (current == null) return;
    final updated = current.copyWith(
      name: (name != null && name.isNotEmpty) ? name : null,
      shortNo: (shortNo != null && shortNo.isNotEmpty) ? shortNo : null,
      sex: (sex == AppLocalizations.of(context).profileGenderMale || sex == '1')
          ? 1
          : (sex == AppLocalizations.of(context).profileGenderFemale ||
                sex == '0')
          ? 0
          : null,
    );
    UserSession.current = updated;
    unawaited(SessionStore.save(updated));
  }

  Future<void> _loadRemoteConversations() async {
    final gateway = widget.imGateway;
    if (gateway == null) {
      return;
    }

    final snapshots = await gateway.loadConversations();
    if (!mounted || snapshots.isEmpty) {
      return;
    }

    _applyRemoteConversations(snapshots);
  }

  Future<void> _loadSocialSnapshot() async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      return;
    }
    final loginUid = widget.session.uid;

    // ── Cold-start fast-path: 从 sqflite cache emit 好友请求列表 ──
    // 对齐 iOS WKContactsHeaderItem cold-start 读 WKFriendRequestDB.getAllFriendRequest
    // → UI 立即出列表 + badge 不闪. 没 cache (首次登录) skip, 走原 API 路径.
    if (loginUid.isNotEmpty) {
      try {
        final cachedRows = await FriendRequestDb.instance.queryAll(
          loginUid,
          serverScope: widget.serverScope,
        );
        if (cachedRows.isNotEmpty && mounted) {
          debugPrint(
            '[friend] cold-start emit friend_req cache n=${cachedRows.length}',
          );
          setState(() {
            _friendRequests = [
              for (var i = 0; i < cachedRows.length; i++)
                UiFriendRequest.fromSocial(
                  ChatFriendRequest(
                    uid: cachedRows[i].uid,
                    token: cachedRows[i].token,
                    name: cachedRows[i].name,
                    message: cachedRows[i].remark,
                    accepted: cachedRows[i].status == 1,
                    refused: cachedRows[i].status == 2,
                  ),
                  colors: conversationColors(i),
                  config: widget.config,
                ),
            ];
          });
        }
      } catch (e) {
        debugPrint('[friend] friend_req cache load fail: $e');
      }
    }

    final ChatSocialSnapshot snapshot;
    try {
      snapshot = await gateway.loadSnapshot();
    } catch (error) {
      debugPrint('[friend] loadSnapshot error=$error');
      return;
    }
    if (!mounted) {
      return;
    }
    // Trace what the server returned so we can verify whether the
    // friendRequest CMD's downstream refresh actually surfaces a row
    // on the recipient side ("dasha 收不到通知" debug path).
    debugPrint(
      '[friend] loadSnapshot contacts=${snapshot.contacts.length} '
      'groups=${snapshot.groups.length} '
      'friendRequests=${snapshot.friendRequests.length}',
    );
    if (snapshot.friendRequests.isNotEmpty) {
      for (final req in snapshot.friendRequests) {
        debugPrint(
          '[friend]   row uid=${req.uid} name="${req.name}" '
          'accepted=${req.accepted}',
        );
      }
    }

    setState(() {
      // Always replace with the gateway's view even when empty — the seed
      // data is only a placeholder for the no-gateway preview / test mode
      // and must not bleed into a logged-in session that legitimately
      // returns an empty contact / group / friend-request list.
      _contacts = [
        for (var i = 0; i < snapshot.contacts.length; i++)
          // BotFather 已废弃 (创建 bot 改走发现页「我的 Bots」+ 入口), 通讯录
          // 不再显示这个系统账号. 防 server 残留 / SDK channel cache 残留.
          if (snapshot.contacts[i].uid != kBotFatherUID)
            UiContact.fromSocial(
              snapshot.contacts[i],
              colors: conversationColors(i),
              config: widget.config,
            ),
      ];
      _groups = [
        for (var i = 0; i < snapshot.groups.length; i++)
          UiGroup.fromSocial(
            snapshot.groups[i],
            color: conversationColors(i).first,
            config: widget.config,
          ),
      ];
      _friendRequests = [
        for (var i = 0; i < snapshot.friendRequests.length; i++)
          UiFriendRequest.fromSocial(
            snapshot.friendRequests[i],
            colors: conversationColors(i),
            config: widget.config,
          ),
      ];
    });

    // ── Write-back: 把 server snapshot 写回 sqflite 给下次 cold-start 用 ──
    // 对齐 iOS CMD friendRequest handler `[WKFriendRequestDB addFriendRequest:]`
    // 增量写回. async 不 await: UI 已 emit 不阻塞.
    if (loginUid.isNotEmpty && snapshot.friendRequests.isNotEmpty) {
      final rows = [
        for (final req in snapshot.friendRequests)
          FriendRequestRow(
            uid: req.uid,
            name: req.name,
            remark: req.message,
            token: req.token,
            status: req.accepted ? 1 : (req.refused ? 2 : 0),
          ),
      ];
      unawaited(
        FriendRequestDb.instance
            .upsertAll(loginUid, rows, serverScope: widget.serverScope)
            .catchError((e) {
              debugPrint('[friend] upsert friend_req fail: $e');
            }),
      );
    }
  }

  void _updateContactEverywhere(UiContact contact) {
    if (!mounted || contact.uid.isEmpty) return;
    final index = _contacts.indexWhere((item) => item.uid == contact.uid);
    if (index < 0) return;
    setState(() {
      _contacts = [
        ..._contacts.take(index),
        contact,
        ..._contacts.skip(index + 1),
      ];
    });
  }

  void _removeContactEverywhere(String uid) {
    final normalizedUid = uid.trim();
    if (!mounted || normalizedUid.isEmpty) return;
    var changed = false;
    final removedConversations = <ChatConversation>[];
    final nextContacts = <UiContact>[];
    for (final contact in _contacts) {
      if (contact.uid == normalizedUid) {
        changed = true;
        continue;
      }
      nextContacts.add(contact);
    }
    final nextConversations = <ChatConversation>[];
    for (final conversation in _conversations) {
      if (conversation.channelType == WKChannelType.personal &&
          conversation.channelId == normalizedUid) {
        changed = true;
        removedConversations.add(conversation);
        continue;
      }
      nextConversations.add(conversation);
    }
    if (!changed) return;
    setState(() {
      _contacts = nextContacts;
      for (final conversation in removedConversations) {
        _messageThreads.removeConversation(conversation);
      }
      _conversations = nextConversations;
    });
  }

  void _applyRemoteConversations(List<WukongConversationSnapshot> snapshots) {
    if (!mounted) {
      return;
    }
    // 之前: `snapshots.isEmpty` 也 early return → 删除最后一条会话时
    // gateway emit 空 list 被吞掉, UI 不清空. 改成只在 _conversations
    // 已经为空时跳过 (防 init / SDK 暂态 empty emit 抖动), 用户真的删
    // 到 0 条时 setState 让 UI 清空.
    if (snapshots.isEmpty && _conversations.isEmpty) {
      return;
    }

    setState(() {
      _conversations = [
        for (var i = 0; i < snapshots.length; i++)
          ChatConversation.fromSnapshot(
            snapshots[i],
            colors: conversationColors(i),
          ),
      ];
      _messageThreads.retainConversations(_conversations);
    });
    // server snapshot 重算 → badge 也要同步 (mark-as-read / 清空聊天后
    // server 端 unread 已减, client 跟着同步上报).
    _syncBadge();
  }

  void _applyRemoteMessage(WukongMessageSnapshot snapshot) {
    if (!mounted || snapshot.isMine) {
      return;
    }
    final index = _conversations.indexWhere(
      (conversation) =>
          conversation.matches(snapshot.channelId, snapshot.channelType),
    );
    if (index == -1) {
      return;
    }

    final message = ChatMessage.fromSnapshot(snapshot);
    ChatConversation? promotedConversation;
    setState(() {
      final conversation = _conversations[index];
      _messageThreads.upsertMessage(conversation, message);
      if (!conversation.shouldPromoteSnapshot(snapshot)) {
        return;
      }
      final updated = conversation.copyWith(
        preview: snapshot.text,
        time: AppLocalizations.of(context).dateJustNow,
        unread: conversation.unread + 1,
        lastMsgSeq: snapshot.messageSeq,
        lastMsgTimestamp: snapshot.timestamp,
        lastClientMsgNo: snapshot.clientMsgNo,
      );
      promotedConversation = updated;
      _conversations = [
        updated,
        ..._conversations.take(index),
        ..._conversations.skip(index + 1),
      ];
    });
    final conv = promotedConversation;
    if (conv == null) {
      return;
    }
    // 本地通知 — app 在后台 / 锁屏但 process 还活时给用户提示. 静默条件
    // (跟 iOS 原版 WKLocalNotificationManager 对齐):
    //   1. mute 会话不弹 (跟微信 muted 同行为, mute 不响只角标)
    //   2. 用户正在看该 chat 页 不弹 (`ChatScreenState.activeChannelKey` 判定)
    //   3. mine 已在最前面 early-return 过滤
    //   4. CMD / 无内容消息跳过 (原版 `WK_CMD || !showUnread` 过滤. chatim
    //      用 kind=unknown + text=empty 兜底, 覆盖 sync*Extra cmd / typing
    //      / 透明系统通知, 这些不该弹横幅).
    //   5. app 前台 (`AppLifecycleState.resumed`) 跳过 — 由
    //      `LocalNotificationCenter.showMessage` 内部判定.
    // server FCM/APNS 在杀进程时推 (这条是 client 进程活时的兜底).
    final isCmdOrEmpty = snapshot.text.trim().isEmpty;
    final convKey = '${conv.channelId}|${conv.channelType}';
    if (!isCmdOrEmpty &&
        !conv.muted &&
        ChatScreenState.activeChannelKey != convKey) {
      final senderName = moyuDisplayName(
        name: snapshot.fromName,
        rawIdentity: snapshot.fromUid,
        placeholder: conv.name,
      );
      final preview = snapshot.text.isNotEmpty
          ? snapshot.text
          : AppLocalizations.of(context).messagesNewMessageDigest;
      // 前台 vs 后台 分流:
      //   - resumed → 应用内 banner (顶部下拉小卡, 跟微信前台行为一致)
      //   - 其他 (paused / inactive / hidden) → LocalNotificationCenter
      //     弹本地通知 (process 还活, app 杀进程走 server APNS/FCM)
      // LocalNotificationCenter.showMessage 内部也判 lifecycle==resumed
      // 跳过, 但这里显式分流让逻辑更清晰: 前台直接弹 banner 不进 local
      // notification 路径, 不依赖 race-prone lifecycle check.
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      if (lifecycle == AppLifecycleState.resumed) {
        final avatarUrl = snapshot.channelType == WKChannelType.group
            ? AvatarResolver.group(
                config: widget.config,
                groupNo: conv.channelId,
              )
            : AvatarResolver.user(config: widget.config, uid: snapshot.fromUid);
        InAppBanner.show(
          context,
          title: senderName,
          body: preview,
          avatarUrl: avatarUrl,
          avatarLabel: senderName,
          onTap: () {
            // 复用 PushRouter — push tap / 本地通知 tap / banner tap 三条
            // 来源都走 _handlePushTap, 跳 chat 页同一条入口.
            PushRouter.instance.emit(
              PushTapEvent(
                channelId: conv.channelId,
                channelType: conv.channelType,
              ),
            );
          },
        );
      } else {
        unawaited(
          LocalNotificationCenter.instance.showMessage(
            id: snapshot.messageId.hashCode,
            messageId: snapshot.messageId,
            title: senderName,
            body: preview,
            channelKey: convKey,
          ),
        );
      }
    }
    // 同步 badge — unread+1 后让 server 知道最新值 (下次 push 用).
    _syncBadge();
  }

  /// 立即返回本地缓存的消息列表 — 用于 _openChat 即时 push chat screen
  /// 不再等远程 loadMessages (旧版 await 拉 remote 让点击对话到 push
  /// 有 几百 ms ~ 几秒延迟, user 报"点击对话很久才能进入"). 远程消息
  /// fetch 已搬到 ChatScreenState.initState 异步执行, 拿到后 setState
  /// 合并进 _messages, 用户感知 = 立刻进 chat + 短暂 cached → 几百 ms
  /// 后 silently 刷新为 remote.
  List<ChatMessage> _initialMessagesForOpenChat(ChatConversation conversation) {
    return _messageThreads.initialMessagesFor(
      conversation,
      // 删 mock: 不再用 seed preview 造假气泡 (§4.9.7), 空起步由 SDK 拉。
      fallback: () => const <ChatMessage>[],
    );
  }

  /// 聊天密码 prompt — Moyu 风格底部 sheet, 6 格 PIN 圆点 + 系统数字键盘.
  /// 校验 md5(pwd+uid) 跟 loginChatPwd, 对齐 iOS WKConversationListVC.
  /// didSelectRow. 返回 true 通过 / false 取消或失败.
  ///
  /// 视觉: 圆角 14 + 白底 + 标题 "聊天密码" + 6 格 PIN dots + 提示文本.
  /// 跟 MoyuActionSheet 同款卡片样式, 不再用 Material AlertDialog.
  ///
  /// 错误次数本地 prefs 持久化 (`chatpwderror_<uid>_<channelId>_<channelType>`),
  /// 错 3 次 → clearConversationMessages + 重置 + 提示, 不放行.
  Future<bool> _promptChatPassword(
    ChatConversation conversation,
    String loginChatPwd,
  ) async {
    final loginUid = widget.session.uid;
    final errorKey =
        'chatpwderror_${loginUid}_${conversation.channelId}_${conversation.channelType}';
    final prefs = await SharedPreferences.getInstance();
    var errorCount = prefs.getInt(errorKey) ?? 0;
    var result = false;
    if (!mounted) return false;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x66000000),
      isScrollControlled: true,
      builder: (sheetCtx) {
        return ChatPasswordSheet(
          onSubmit: (pwd) async {
            final digest = md5.convert(utf8.encode('$pwd$loginUid')).toString();
            if (digest == loginChatPwd) {
              await prefs.setInt(errorKey, 0);
              result = true;
              return PwdSubmitResult.ok;
            }
            errorCount += 1;
            await prefs.setInt(errorKey, errorCount);
            if (errorCount >= 3) {
              await prefs.setInt(errorKey, 0);
              unawaited(
                widget.imGateway?.clearConversationMessages(
                  channelId: conversation.channelId,
                  channelType: conversation.channelType,
                ),
              );
              return PwdSubmitResult.errorWiped;
            }
            return PwdSubmitResult.errorWith(3 - errorCount);
          },
          onWiped: () {
            // sheet 内部 pop 后回调, 主页面再 toast 提示
            if (mounted) {
              MoyuToast.show(
                context,
                AppLocalizations.of(context).homeChatPasswordWiped,
              );
            }
          },
        );
      },
    );
    return result;
  }

  Future<void> _clearRemoteUnread(ChatConversation conversation) async {
    final gateway = widget.imGateway;
    if (gateway == null || !conversation.isRemote) {
      return;
    }

    try {
      await gateway.clearUnread(
        session: widget.session,
        channelId: conversation.channelId,
        channelType: conversation.channelType,
      );
    } catch (_) {}
  }

  Future<void> _openContactChat(UiContact contact) async {
    final conversation = _conversationFromContact(contact);
    final existingIndex = _conversations.indexWhere(
      (item) => item.matches(conversation.channelId, conversation.channelType),
    );
    final target = existingIndex == -1
        ? conversation
        : _conversations[existingIndex];

    if (existingIndex == -1) {
      setState(() {
        _conversations = [conversation, ..._conversations];
        _messageThreads.ensureEmpty(conversation);
      });
    }

    await _openChat(target);
  }

  Future<bool> _openGroupChat(String groupNo) async {
    final normalized = groupNo.trim();
    if (normalized.isEmpty) {
      return false;
    }
    final existingIndex = _conversations.indexWhere(
      (item) => item.matches(normalized, WKChannelType.group),
    );
    UiGroup? existingGroup;
    for (final group in _groups) {
      if (group.groupNo == normalized) {
        existingGroup = group;
        break;
      }
    }

    ChatGroup? groupInfo;
    try {
      groupInfo = await widget.socialGateway?.loadGroupInfo(normalized);
    } catch (_) {
      groupInfo = null;
    }
    if (groupInfo == null) {
      try {
        groupInfo = await widget.socialGateway?.loadPublicGroupInfo(normalized);
      } catch (_) {
        groupInfo = null;
      }
    }
    if (!mounted) {
      return false;
    }

    if (groupInfo == null && existingIndex == -1 && existingGroup == null) {
      MoyuToast.show(context, AppLocalizations.of(context).homeGroupNotFound);
      return false;
    }

    final color = conversationColors(normalized.hashCode.abs()).first;
    final fallbackGroup =
        existingGroup ??
        UiGroup(
          groupNo: normalized,
          name: AppLocalizations.of(context).messagesGroupFallback,
          avatarLabel: AppLocalizations.of(context).messagesGroupAvatarFallback,
          memberCount: 0,
          subtitle: AppLocalizations.of(context).messagesGroupFallback,
          color: color,
          avatarPath: AvatarResolver.group(
            config: widget.config,
            groupNo: normalized,
          ),
        );
    final group = groupInfo == null
        ? fallbackGroup
        : _groupFromServer(groupInfo, fallbackGroup);

    final groupIndex = _groups.indexWhere((item) => item.groupNo == normalized);
    if (groupIndex == -1) {
      setState(() => _groups = [group, ..._groups]);
    } else if (groupInfo != null) {
      setState(() {
        final next = [..._groups];
        next[groupIndex] = group;
        _groups = next;
      });
    }

    final conversation = existingIndex == -1
        ? _conversationFromGroup(group)
        : _conversations[existingIndex];
    if (existingIndex == -1) {
      setState(() {
        _conversations = [conversation, ..._conversations];
        _messageThreads.ensureEmpty(conversation);
      });
    }
    unawaited(
      widget.imGateway?.refreshChannel(
            channelId: normalized,
            channelType: WKChannelType.group,
          ) ??
          Future.value(),
    );
    await _openChat(conversation);
    return true;
  }

  List<UiGroup> get _knownGroupCandidates {
    final t = AppLocalizations.of(context);
    final byNo = <String, UiGroup>{};
    for (final group in _groups) {
      final no = group.groupNo.trim();
      if (no.isEmpty) continue;
      byNo[no] = group;
    }
    for (final conversation in _conversations) {
      if (conversation.channelType != WKChannelType.group ||
          conversation.memberRemoved) {
        continue;
      }
      final no = conversation.channelId.trim();
      if (no.isEmpty || byNo.containsKey(no)) continue;
      final name = conversation.name.trim().isEmpty
          ? t.messagesGroupFallback
          : conversation.name.trim();
      byNo[no] = UiGroup(
        groupNo: no,
        name: name,
        avatarLabel: name.characters.isEmpty
            ? t.messagesGroupAvatarFallback
            : name.characters.first,
        avatarPath: AvatarResolver.group(
          config: widget.config,
          groupNo: no,
          imageUrl: conversation.avatarPath,
        ),
        memberCount: conversation.memberCount,
        subtitle: conversation.preview.isEmpty
            ? t.messagesGroupFallback
            : conversation.preview,
        color: conversation.colors.isEmpty
            ? conversationColors(no.hashCode.abs()).first
            : conversation.colors.first,
        muted: conversation.muted,
        saved: false,
        forbidden: conversation.forbidden,
      );
    }
    return byNo.values.toList(growable: false);
  }

  Future<UiGroup?> _saveExistingGroup(UiGroup group) async {
    final groupNo = group.groupNo.trim();
    if (groupNo.isEmpty) return null;
    await widget.socialGateway?.updateGroupSetting(
      groupNo: groupNo,
      setting: const {'save': 1},
    );
    await widget.imGateway?.refreshChannel(
      channelId: groupNo,
      channelType: WKChannelType.group,
    );
    if (!mounted) return null;
    final saved = group.copyWith(saved: true);
    setState(() {
      final index = _groups.indexWhere((item) => item.groupNo == groupNo);
      if (index == -1) {
        _groups = [saved, ..._groups];
      } else {
        final next = [..._groups];
        next[index] = saved;
        _groups = next;
      }
    });
    return saved;
  }

  ChatConversation _conversationFromContact(UiContact contact) {
    final t = AppLocalizations.of(context);
    final channelId = contactChannelId(contact);
    return ChatConversation(
      channelId: channelId,
      channelType: 1,
      name: contact.name,
      avatarLabel: contact.avatarLabel,
      preview: contact.subtitle.isEmpty
          ? t.homeConversationStartChat
          : contact.subtitle,
      time: t.dateJustNow,
      colors: contact.colors,
      online: contact.online,
      isRemote: widget.imGateway != null && contact.uid.isNotEmpty,
    );
  }

  ChatConversation _conversationFromGroup(UiGroup group) {
    final t = AppLocalizations.of(context);
    final channelId = group.groupNo;
    final name = group.name.trim().isEmpty
        ? t.messagesGroupFallback
        : group.name.trim();
    return ChatConversation(
      channelId: channelId,
      channelType: WKChannelType.group,
      name: name,
      avatarLabel: name.characters.isEmpty
          ? t.messagesGroupAvatarFallback
          : name.characters.first,
      avatarPath: AvatarResolver.group(
        config: widget.config,
        groupNo: channelId,
        imageUrl: group.avatarPath,
      ),
      preview: group.subtitle.isEmpty ? t.homeEnterGroupChat : group.subtitle,
      time: t.dateJustNow,
      colors: conversationColors(channelId.hashCode.abs()),
      muted: group.muted,
      isRemote: widget.imGateway != null && channelId.isNotEmpty,
      forbidden: group.forbidden,
      memberCount: group.memberCount,
    );
  }

  Future<void> _recordSentText(
    ChatConversation conversation,
    String text, {
    List<String> mentionUids = const [],
    bool mentionAll = false,
    String replyMessageId = '',
    int replyMessageSeq = 0,
    String replyFromUid = '',
    String replyFromName = '',
    String replyText = '',
  }) async {
    await _sendRemoteText(
      conversation,
      text,
      mentionUids: mentionUids,
      mentionAll: mentionAll,
      replyMessageId: replyMessageId,
      replyMessageSeq: replyMessageSeq,
      replyFromUid: replyFromUid,
      replyFromName: replyFromName,
      replyText: replyText,
    );
    final sentMessage = ChatMessage.right(
      text,
      status: '已发送',
      timestamp: nowSeconds(),
    );

    setState(() {
      _messageThreads.appendOptimistic(conversation, sentMessage);

      final index = _conversations.indexWhere(
        (item) =>
            item.matches(conversation.channelId, conversation.channelType),
      );
      if (index == -1) {
        return;
      }

      final updated = _conversations[index].copyWith(
        preview: text,
        time: AppLocalizations.of(context).dateJustNow,
        unread: 0,
      );
      _conversations = [
        updated,
        ..._conversations.take(index),
        ..._conversations.skip(index + 1),
      ];
    });
  }

  Future<void> _recordSentMedia(
    ChatConversation conversation,
    ChatMediaAttachment attachment,
  ) async {
    await _sendRemoteMedia(conversation, attachment);
    final sentMessage = ChatMessage.rightMedia(
      attachment.displayText,
      kind: attachment.kind,
      fileName: attachment.fileName,
      attachment: attachment,
      status: '已发送',
      timestamp: nowSeconds(),
    );

    setState(() {
      _messageThreads.appendOptimistic(conversation, sentMessage);
      final index = _conversations.indexWhere(
        (item) =>
            item.matches(conversation.channelId, conversation.channelType),
      );
      if (index == -1) {
        return;
      }
      final updated = _conversations[index].copyWith(
        preview: attachment.displayText,
        time: AppLocalizations.of(context).dateJustNow,
        unread: 0,
      );
      _conversations = [
        updated,
        ..._conversations.take(index),
        ..._conversations.skip(index + 1),
      ];
    });
  }

  Future<void> _recordSentSticker(
    ChatConversation conversation,
    ChatSticker sticker,
  ) async {
    // 跟 ChatScreen._sendSticker (5531) 同 pattern: 用 rightMedia + sticker
    // attachment 让本地 thread / 会话列表 preview 都拿到正确气泡形态. 之前
    // .right(text) 把 sticker placeholder SVG 当 digest
    // 写进 thread + 1081 preview, 用户看到 "<svg ..." raw 闪过.
    final text = stickerDisplayText(AppLocalizations.of(context), sticker);
    final rawPath = sticker.path;
    final remoteUrl = rawPath.isEmpty
        ? ''
        : (rawPath.startsWith('http')
              ? rawPath
              : widget.config.showUrl(rawPath));
    final sentMessage = ChatMessage.rightMedia(
      text,
      kind: ChatMediaKind.sticker,
      fileName: '',
      attachment: ChatMediaAttachment(
        kind: ChatMediaKind.sticker,
        localPath: '',
        fileName: '',
        remoteUrl: remoteUrl,
        width: sticker.width,
        height: sticker.height,
      ),
      status: '已发送',
      timestamp: nowSeconds(),
    );

    setState(() {
      _messageThreads.appendOptimistic(conversation, sentMessage);
      final index = _conversations.indexWhere(
        (item) =>
            item.matches(conversation.channelId, conversation.channelType),
      );
      if (index == -1) {
        return;
      }
      final updated = _conversations[index].copyWith(
        preview: text,
        time: AppLocalizations.of(context).dateJustNow,
        unread: 0,
      );
      _conversations = [
        updated,
        ..._conversations.take(index),
        ..._conversations.skip(index + 1),
      ];
    });
  }

  Future<void> _recordSentLocation(
    ChatConversation conversation,
    ChatLocation location,
  ) async {
    final text = location.displayText;
    final sentMessage = ChatMessage.right(
      text,
      status: '已发送',
      timestamp: nowSeconds(),
    );

    setState(() {
      _messageThreads.appendOptimistic(conversation, sentMessage);
      final index = _conversations.indexWhere(
        (item) =>
            item.matches(conversation.channelId, conversation.channelType),
      );
      if (index == -1) {
        return;
      }
      final updated = _conversations[index].copyWith(
        preview: text,
        time: AppLocalizations.of(context).dateJustNow,
        unread: 0,
      );
      _conversations = [
        updated,
        ..._conversations.take(index),
        ..._conversations.skip(index + 1),
      ];
    });
  }

  Future<void> _sendRemoteText(
    ChatConversation conversation,
    String text, {
    List<String> mentionUids = const [],
    bool mentionAll = false,
    String replyMessageId = '',
    int replyMessageSeq = 0,
    String replyFromUid = '',
    String replyFromName = '',
    String replyText = '',
  }) async {
    final gateway = widget.imGateway;
    if (gateway == null || !conversation.isRemote) {
      return;
    }

    await gateway.sendText(
      channelId: conversation.channelId,
      channelType: conversation.channelType,
      text: text,
      mentionUids: mentionUids,
      mentionAll: mentionAll,
      replyMessageId: replyMessageId,
      replyMessageSeq: replyMessageSeq,
      replyFromUid: replyFromUid,
      replyFromName: replyFromName,
      replyText: replyText,
    );
  }

  Future<void> _sendRemoteMedia(
    ChatConversation conversation,
    ChatMediaAttachment attachment,
  ) async {
    final gateway = widget.imGateway;
    if (gateway == null || !conversation.isRemote) {
      return;
    }

    await gateway.sendMedia(
      channelId: conversation.channelId,
      channelType: conversation.channelType,
      attachment: attachment,
    );
  }

  // 三个 handler 都遵循同一个模板：调 gateway → 成功 toast →
  // _loadSocialSnapshot 拉服务端最新状态（避免本地 optimistic state 与
  // 服务端 status 不一致看起来"假"）→ 失败 toast。
  // 对应原版 iOS WKContactsFriendRequestVC.requestFriendSure（POST
  // /friend/sure 后 startSyncContacts）+ 拒绝/删除走相同 sync 思路。
  Future<void> _acceptFriendRequest(UiFriendRequest request) async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    try {
      await gateway.acceptFriendRequest(request.token);
    } catch (error) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).homeFriendRequestAcceptFailed('$error'),
        );
      }
      rethrow;
    }
    if (!mounted) return;
    MoyuToast.show(
      context,
      AppLocalizations.of(context).homeFriendRequestAccepted,
    );
    // 拉最新通讯录 + 好友申请列表。服务端 friendSure 写好友表 + 把
    // apply.Status 改成 1，刷一遍后名片才会出现在'通讯录'里。
    unawaited(_loadSocialSnapshot());
  }

  Future<void> _refuseFriendRequest(UiFriendRequest request) async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    final uid = request.uid.isEmpty ? request.name : request.uid;
    try {
      await gateway.refuseFriendRequest(uid);
    } catch (error) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).homeFriendRequestRefuseFailed('$error'),
        );
      }
      rethrow;
    }
    if (!mounted) return;
    MoyuToast.show(context, AppLocalizations.of(context).friendRequestRefused);
    unawaited(_loadSocialSnapshot());
  }

  Future<void> _deleteFriendRequest(UiFriendRequest request) async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    final uid = request.uid.isEmpty ? request.name : request.uid;
    try {
      await gateway.deleteFriendRequest(uid);
    } catch (error) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).homeFriendRequestDeleteFailed('$error'),
        );
      }
      rethrow;
    }
    if (!mounted) return;
    MoyuToast.show(context, AppLocalizations.of(context).chatNoticeDeleted);
    unawaited(_loadSocialSnapshot());
  }

  void _clearConversationMessages(ChatConversation conversation) {
    if (!mounted) {
      return;
    }

    setState(() {
      _messageThreads.clearConversation(conversation);
      final index = _conversations.indexWhere(
        (item) =>
            item.matches(conversation.channelId, conversation.channelType),
      );
      if (index == -1) {
        return;
      }
      final updated = _conversations[index].copyWith(
        preview: AppLocalizations.of(context).homeConversationNoHistory,
        time: AppLocalizations.of(context).momentJustNow,
        unread: 0,
      );
      _conversations = [
        ..._conversations.take(index),
        updated,
        ..._conversations.skip(index + 1),
      ];
    });
  }

  /// SDK `addOnClearChannelMsgListener` 回调桥接而来 — 任何路径 (本端
  /// _clearMessages / 其它设备 sync / 远端 messageEerase CMD) 触发
  /// SDK clearWithChannel 都会走到这, 统一调本端已有的内存清理逻辑.
  /// 防止 SDK DB 已删但 home_shell._messageThreads 残留, 用户切走
  /// 再回会话看到旧消息复活.
  void _handleChannelCleared(WukongChannelClearedSignal signal) {
    if (!mounted) return;
    final index = _conversations.indexWhere(
      (item) => item.matches(signal.channelId, signal.channelType),
    );
    if (index == -1) {
      // 会话不在当前列表 — 仍把对应 thread key 清掉, 防止下次新建
      // 同 channelId 的会话时 cache 残留.
      if (_messageThreads.containsChannel(
        signal.channelId,
        signal.channelType,
      )) {
        setState(
          () => _messageThreads.removeChannel(
            signal.channelId,
            signal.channelType,
          ),
        );
      }
      return;
    }
    _clearConversationMessages(_conversations[index]);
  }

  /// SDK `addOnDeleteMsgListener` 回调桥接而来 — 单条消息删除 (撤回 /
  /// 删除 / 跨设备 sync). 按 clientMsgNo 从所有 thread cache 里移除.
  void _handleMessageDeleted(String clientMsgNo) {
    if (!mounted || clientMsgNo.isEmpty) return;
    if (!_messageThreads.deleteByClientMsgNo(clientMsgNo)) return;
    setState(() {});
  }

  Future<void> _deleteConversation(ChatConversation conversation) async {
    final gateway = widget.imGateway;
    if (gateway != null && conversation.isRemote) {
      await gateway.deleteConversation(
        channelId: conversation.channelId,
        channelType: conversation.channelType,
      );
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _messageThreads.removeConversation(conversation);
      _conversations = [
        for (final item in _conversations)
          if (!item.matches(conversation.channelId, conversation.channelType))
            item,
      ];
    });
  }

  Future<UiGroup?> _createGroup(List<UiContact> members) async {
    final memberUids = [
      for (final member in members) contactChannelId(member),
    ].where((uid) => uid.isNotEmpty).toList();
    if (memberUids.isEmpty) {
      return null;
    }

    final memberNames = members.map((member) => member.name).toList();
    final fallbackGroup = _groupFromMembers(members);
    final createdGroup = await widget.socialGateway?.createGroup(
      memberUids,
      name: fallbackGroup.name,
      memberNames: memberNames,
    );
    if (!mounted) {
      return null;
    }

    final group = createdGroup == null
        ? fallbackGroup
        : _groupFromServer(createdGroup, fallbackGroup);
    setState(() {
      _groups = [group, ..._groups];
    });
    // Server-side group/create returns immediately, but the IM
    // long-connection's `addOrUpdateConversations` push (which is
    // what wires the new group into `_conversations`) can lag by
    // several seconds — long enough that the user sees the group
    // missing from the message list right after creation. Pull the
    // channel info eagerly + re-emit conversations so the list
    // reflects the new group within the same frame.
    if (group.groupNo.isNotEmpty) {
      unawaited(
        widget.imGateway?.refreshChannel(
              channelId: group.groupNo,
              channelType: 2,
            ) ??
            Future.value(),
      );
    }
    return group;
  }

  UiGroup _groupFromServer(ChatGroup group, UiGroup fallbackGroup) {
    final name = group.name.isEmpty ? fallbackGroup.name : group.name;
    return UiGroup(
      groupNo: group.groupNo,
      name: name,
      avatarLabel: name.isEmpty
          ? fallbackGroup.avatarLabel
          : name.characters.first,
      avatarPath: fallbackGroup.avatarPath,
      memberCount: group.memberCount == 0
          ? fallbackGroup.memberCount
          : group.memberCount,
      subtitle: group.notice.isEmpty
          ? AppLocalizations.of(context).homeNewGroup
          : group.notice,
      muted: group.muted,
      saved: group.saved,
      inviteConfirm: group.inviteConfirm,
      forbidden: group.forbidden,
      forbiddenAddFriend: group.forbiddenAddFriend,
      allowViewHistoryMsg: group.allowViewHistoryMsg,
      allowMemberPinnedMessage: group.allowMemberPinnedMessage,
      color: fallbackGroup.color,
    );
  }

  UiGroup _groupFromMembers(List<UiContact> members) {
    final names = members.map((member) => member.name).toList();
    final name = names.take(3).join('、');
    final avatarLabel = name.isEmpty
        ? AppLocalizations.of(context).messagesGroupAvatarFallback
        : name.characters.first;
    return UiGroup(
      groupNo: 'local-${contactChannelId(members.first)}',
      name: name.isEmpty ? AppLocalizations.of(context).homeNewGroup : name,
      avatarLabel: avatarLabel,
      memberCount: members.length + 1,
      subtitle: AppLocalizations.of(context).homeNewGroup,
      color: conversationColors(_groups.length).first,
    );
  }

  void _replaceConversation(ChatConversation updated) {
    final index = _conversations.indexWhere(
      (conversation) =>
          conversation.matches(updated.channelId, updated.channelType),
    );
    if (index == -1) {
      return;
    }

    setState(() {
      _conversations = [
        ..._conversations.take(index),
        updated,
        ..._conversations.skip(index + 1),
      ];
    });
  }
}

// _MessageActionBar / _MessageActionButton replaced by _MessageContextMenu
// (modal Cupertino-style long-press menu, see ~line 4014).

/// Public escape hatch so main.dart can tear down the active call
/// session on logout / kick / session switch without reaching into
/// RTC module internals. Without this, switching account
/// while in a call leaves the mic open + LiveKit room joined +
/// floating PIP visible — the user has no UI to control it.
void endActiveRtcSession() {
  final feature = AppRuntime.current?.registry.featureById(
    ModuleFeatureIds.rtcSessionApi,
  );
  final sessionApi = feature?.value;
  if (sessionApi is ModuleRtcSessionApi) {
    sessionApi.end();
  }
}

/// CallKit accept 在后台 (lifecycle != resumed) 时, _CallPage push 会被
/// Flutter 静默 drop. 缓存 payload, didChangeAppLifecycleState(resumed) 时
