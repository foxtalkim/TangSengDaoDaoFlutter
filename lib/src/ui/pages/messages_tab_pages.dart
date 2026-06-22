// 消息 tab + 全局搜索 + 会话 tile。从 home_shell.dart 拆出。
import 'dart:async' show StreamSubscription, Timer, unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:forui/forui.dart';
import 'package:wukongimfluttersdk/type/const.dart' show WKChannelType;

import '../../auth/auth_repository.dart' show ChatServerAppConfig;
import '../../config/app_config.dart';
import '../../conversation/chat_conversation.dart';
import '../../im/wukong_im_service.dart'
    show ChatConnectionStatus, ChatImGateway, ChatUserPresence;
import '../../l10n/app_localizations.dart';
import '../../scan/chat_scan_service.dart';
import '../../social/social_service.dart'
    show ChatGlobalChannel, ChatGlobalMessage, ChatSocialGateway;
import '../chat_navigation.dart';
import '../contact_list_widgets.dart'
    show ContactTile, SectionTitle, specialAccountDisplayName;
import '../detail_scaffold.dart';
import '../home_seed_data.dart' show conversationColors;
import '../identity_display.dart';
import '../models/contact_models.dart';
import '../moyu_ink.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_layout.dart' show kTabBarReservedHeight;
import 'friend_pages.dart'
    show AddFriendPage, ContactDetailPage, WebLoginConfirmPage;
import 'group_pages.dart' show CreateGroupPage, GroupDetailPage, GroupTile;
import 'scan_page.dart' show ScanPage;
import 'search_message_widgets.dart'
    show SearchMessageTile, SearchTabChip, searchConversationFromGlobalMessage;

class MessagesPage extends StatefulWidget {
  const MessagesPage({
    super.key,
    required this.conversations,
    required this.contacts,
    required this.groups,
    required this.config,
    required this.onOpenChat,
    required this.onOpenContactChat,
    required this.onOpenGroupChat,
    required this.onCreateGroup,
    this.imGateway,
    this.socialGateway,
    this.scanGateway,
    this.loginUid = '',
    this.loginName = '',
    this.serverAppConfig = const ChatServerAppConfig(),
    this.showTopSearchEntry = true,
    this.onConversationCleared,
    this.onSocialChanged,
    this.onContactChanged,
    this.onContactRemoved,
  });

  final List<ChatConversation> conversations;
  final List<UiContact> contacts;
  final List<UiGroup> groups;
  final AppConfig config;
  final ChatImGateway? imGateway;
  final ChatSocialGateway? socialGateway;
  final ChatScanGateway? scanGateway;
  final String loginUid;
  final String loginName;
  final ChatServerAppConfig serverAppConfig;
  final bool showTopSearchEntry;
  final ValueChanged<ChatConversation> onOpenChat;
  final Future<void> Function(UiContact contact) onOpenContactChat;
  final Future<bool> Function(String groupNo) onOpenGroupChat;
  final Future<UiGroup?> Function(List<UiContact> members) onCreateGroup;
  final Future<void> Function()? onSocialChanged;
  final ValueChanged<UiContact>? onContactChanged;
  final ValueChanged<String>? onContactRemoved;

  /// 会话列表清空聊天记录后通知 home_shell — 让 home_shell 清掉
  /// `_messageThreads[key]` in-memory cache. 没这个 callback 用户清空后
  /// **第一次重进会话, _initialMessagesForOpenChat 还会从 _messageThreads
  /// 拿到清空前 N 条立即渲染**, 几百 ms 后异步 loadMessages 拿 0 条 setState
  /// 才覆盖刷成空 — UI 上看就是 "进去消息还在, 又秒消失" 的诡异闪烁.
  /// (聊天页内部"清空"走 home_shell.dart:861 callback 已自带 cache 清,
  /// 这一条只补会话列表 action sheet 路径.)
  final ValueChanged<ChatConversation>? onConversationCleared;

  @override
  State<MessagesPage> createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  static const double _messagesSearchFieldExtent = 64;
  static const double _connectStatusBannerExtent = 41;
  static const double _conversationRowExtent = 72.5;

  bool _autoOpenedChat = false;
  StreamSubscription<Map<String, String>>? _typingSubscription;
  StreamSubscription<ChatConnectionStatus>? _connectStatusSubscription;
  // #3: 连接 banner 防抖 — 前台重连瞬态在 1.2s 内连上就不闪 banner。
  Timer? _connectBannerTimer;
  Map<String, String> _typingByKey = const <String, String>{};
  Map<String, ChatUserPresence> _presenceByUid =
      const <String, ChatUserPresence>{};
  Timer? _presenceTimer;
  Set<String> _lastPolledUids = const <String>{};

  /// IM 长连接状态. 初始 seed `gateway.currentConnectionStatus`, 然后随
  /// connectionStatusSignals stream 实时更新. 给顶部 status banner 用.
  ChatConnectionStatus _connectStatus = ChatConnectionStatus.disconnected;

  /// 双击 tab / header 滚动用 ScrollController. 外部 home_shell 持 GlobalKey<
  /// MessagesPageState> 拿到 state 调 scrollToUnreadOrTop().
  final ScrollController _scrollController = ScrollController();

  /// public: 滚到列表顶. home_shell 4 个 tab 的 onDoubleTap 调用.
  /// hasClients 守卫处理 first frame / page 还没构建完的情况.
  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  /// 双击"消息"Tab: 优先滚到第一条有未读的会话；全部已读时才回到顶部。
  void scrollToUnreadOrTop() {
    if (!_scrollController.hasClients) return;
    final unreadIndex = widget.conversations.indexWhere((c) => c.unread > 0);
    if (unreadIndex == -1) {
      scrollToTop();
      return;
    }
    final hasStatusBanner = _connectStatus != ChatConnectionStatus.connected;
    final target =
        _messagesSearchFieldExtent +
        (hasStatusBanner ? _connectStatusBannerExtent : 0) +
        unreadIndex * _conversationRowExtent;
    _scrollController.animateTo(
      target.clamp(0, _scrollController.position.maxScrollExtent).toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();
    const autoOpen = bool.fromEnvironment('DEV_OPEN_CHAT');
    if (autoOpen) {
      _scheduleAutoOpen();
    }
    _subscribeTyping();
    _subscribeConnectStatus();
    _restartPresencePolling();
  }

  @override
  void didUpdateWidget(covariant MessagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imGateway != widget.imGateway) {
      _subscribeTyping();
      _subscribeConnectStatus();
      _restartPresencePolling();
    } else if (oldWidget.conversations != widget.conversations) {
      unawaited(_pollPresenceIfNeeded());
    }
  }

  @override
  void dispose() {
    unawaited(_typingSubscription?.cancel());
    unawaited(_connectStatusSubscription?.cancel());
    _connectBannerTimer?.cancel();
    _presenceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _subscribeConnectStatus() {
    unawaited(_connectStatusSubscription?.cancel());
    _connectStatusSubscription = null;
    final gateway = widget.imGateway;
    if (gateway == null) {
      if (_connectStatus != ChatConnectionStatus.disconnected) {
        setState(() => _connectStatus = ChatConnectionStatus.disconnected);
      }
      return;
    }
    // seed 初始状态, 不依赖第一次 stream emit
    _connectStatus = gateway.currentConnectionStatus;
    _connectStatusSubscription = gateway.connectionStatusSignals.listen((
      status,
    ) {
      if (!mounted) return;
      // #3: connected → 立即隐藏 banner; noNetwork(真没网) → 立即显示。
      if (status == ChatConnectionStatus.connected ||
          status == ChatConnectionStatus.noNetwork) {
        _connectBannerTimer?.cancel();
        _connectBannerTimer = null;
        if (_connectStatus != status) setState(() => _connectStatus = status);
        return;
      }
      // disconnected/connecting/syncing 多是前台重连的瞬态。若 banner 已显示
      // 就直接更新文案; 否则防抖 1.2s —— 1.2s 内重连成功(回 connected)就
      // 完全不闪 banner, 解决"每次进入都明显断线-连接中"。
      if (_connectStatus != ChatConnectionStatus.connected) {
        setState(() => _connectStatus = status);
        return;
      }
      _connectBannerTimer?.cancel();
      _connectBannerTimer = Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        final cur = gateway.currentConnectionStatus;
        if (cur != ChatConnectionStatus.connected) {
          setState(() => _connectStatus = cur);
        }
      });
    });
  }

  void _subscribeTyping() {
    unawaited(_typingSubscription?.cancel());
    _typingSubscription = null;
    final gateway = widget.imGateway;
    if (gateway == null) {
      if (_typingByKey.isNotEmpty) {
        setState(() => _typingByKey = const <String, String>{});
      }
      return;
    }
    _typingSubscription = gateway.typingSnapshots.listen((map) {
      if (!mounted) return;
      setState(() => _typingByKey = map);
    });
  }

  void _restartPresencePolling() {
    _presenceTimer?.cancel();
    _presenceTimer = null;
    _lastPolledUids = const <String>{};
    if (widget.imGateway == null) {
      if (_presenceByUid.isNotEmpty) {
        setState(() => _presenceByUid = const <String, ChatUserPresence>{});
      }
      return;
    }
    unawaited(_pollPresenceIfNeeded());
    _presenceTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_pollPresenceIfNeeded());
    });
  }

  Set<String> _visiblePersonalUids() {
    final uids = <String>{};
    for (final c in widget.conversations) {
      if (c.channelType == WKChannelType.personal && c.channelId.isNotEmpty) {
        uids.add(c.channelId);
      }
    }
    return uids;
  }

  Future<void> _pollPresenceIfNeeded() async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    final uids = _visiblePersonalUids();
    if (uids.isEmpty) return;
    if (uids.length == _lastPolledUids.length &&
        uids.containsAll(_lastPolledUids) &&
        _presenceByUid.isNotEmpty) {
      // Same set already polled and we have data — let the timer drive the
      // next refresh instead of re-querying on every conversation snapshot.
      return;
    }
    _lastPolledUids = uids;
    try {
      final map = await gateway.queryUserPresence(uids.toList());
      if (!mounted) return;
      setState(() => _presenceByUid = map);
    } catch (_) {
      // Network errors are benign — fall back to existing channel.online state.
    }
  }

  void _scheduleAutoOpen() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _autoOpenedChat) return;
      if (widget.conversations.isEmpty) {
        _scheduleAutoOpen();
        return;
      }
      _autoOpenedChat = true;
      widget.onOpenChat(widget.conversations.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final conversations = widget.conversations;
    final searchEntryCount = widget.showTopSearchEntry ? 1 : 0;

    // Reserve room at the bottom for the translucent tab bar overlay
    // + system safe area so the last conversation row isn't hidden
    // behind the bar when scrolled all the way down.
    final tabBarInset =
        kTabBarReservedHeight + MediaQuery.viewPaddingOf(context).bottom;
    return Semantics(
      identifier: 'moyu.messages.page',
      container: true,
      child: Stack(
        children: [
          ListView.builder(
            // ListView starts at y=0. Top padding clears the glass
            // header (status bar inset + exact header content height).
            // 不再加 12pt breathing room — user 反馈 nav 跟第一条
            // 会话之间显得有距离不贴, 跟微信 conversation list 紧贴
            // header 视觉对齐.
            controller: _scrollController,
            padding: EdgeInsets.only(
              top:
                  MediaQuery.viewPaddingOf(context).top +
                  MoyuPageHeader.contentHeight,
              bottom: tabBarInset,
            ),
            itemCount:
                searchEntryCount +
                (_connectStatus != ChatConnectionStatus.connected ? 1 : 0) +
                (conversations.isEmpty ? 1 : conversations.length),
            itemBuilder: (context, index) {
              if (widget.showTopSearchEntry && index == 0) {
                return _buildSearchEntry(context);
              }
              // 连接状态 banner — 对齐 iOS WKConversationListHeaderView 的
              // showNetworkError + WKConversationListVC.refreshTitle 合并版.
              // connected 状态不显示.
              final hasStatusBanner =
                  _connectStatus != ChatConnectionStatus.connected;
              final contentIndex = index - searchEntryCount;
              if (hasStatusBanner && contentIndex == 0) {
                return _ConnectStatusBanner(status: _connectStatus);
              }
              final itemIndex = contentIndex - (hasStatusBanner ? 1 : 0);
              if (conversations.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: MoyuEmptyState(
                    title: t.messagesEmptyTitle,
                    subtitle: t.messagesEmptySubtitle,
                  ),
                );
              }
              final conversation = conversations[itemIndex];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ConversationTile(
                    identifier: 'moyu.conversation.$itemIndex',
                    conversation: conversation,
                    typingText:
                        _typingByKey['${conversation.channelType}_${conversation.channelId}'],
                    presence: conversation.channelType == WKChannelType.personal
                        ? _presenceByUid[conversation.channelId]
                        : null,
                    onTap: () => widget.onOpenChat(conversation),
                    onPin: () => _togglePin(conversation),
                    onMute: () => _toggleMute(conversation),
                    onDelete: () => _confirmDelete(context, conversation),
                  ),
                  if (itemIndex != conversations.length - 1)
                    MoyuDivider(
                      // Two adjacent pinned tiles should read as one
                      // continuous gray block — without filling the
                      // divider's indent gap with the same pinned
                      // highlight color, the 0.5px hairline strip
                      // shows ListView white through the 0-68 indent
                      // and appears as a white seam at the avatar
                      // column.
                      background:
                          conversation.pinned &&
                              conversations[itemIndex + 1].pinned
                          ? MoyuColors.of(context).backgroundSoft
                          : null,
                    ),
                ],
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: MoyuGlass(
              borderRadius: BorderRadius.zero,
              showHairline: false,
              child: SafeArea(
                bottom: false,
                child: MoyuPageHeader(
                  title: AppLocalizations.of(context).pageMessagesTitle,
                  onTitleDoubleTap: scrollToTop,
                  actions: [
                    Semantics(
                      identifier: 'moyu.messages.add',
                      container: true,
                      child: FPopoverMenu(
                        menuAnchor: Alignment.topRight,
                        childAnchor: Alignment.bottomRight,
                        offset: const Offset(0, 6),
                        menuBuilder: (_, controller, _) => [
                          FItemGroupMixin.group(
                            children: [
                              FItemMixin.item(
                                title: Text(t.messagesStartGroupChat),
                                prefix: const Icon(FIcons.messagesSquare),
                                onPress: () {
                                  unawaited(controller.hide(animated: false));
                                  pushPage(
                                    context,
                                    CreateGroupPage(
                                      contacts: widget.contacts,
                                      onCreateGroup: widget.onCreateGroup,
                                      serverAppConfig: widget.serverAppConfig,
                                    ),
                                  );
                                },
                              ),
                              FItemMixin.item(
                                title: Text(t.addFriendTitle),
                                prefix: const Icon(FIcons.userRoundPlus),
                                onPress: () {
                                  unawaited(controller.hide(animated: false));
                                  pushPage(
                                    context,
                                    AddFriendPage(
                                      config: widget.config,
                                      socialGateway: widget.socialGateway,
                                      scanGateway: widget.scanGateway,
                                      imGateway: widget.imGateway,
                                      contacts: widget.contacts,
                                      onOpenContactChat:
                                          widget.onOpenContactChat,
                                      onOpenGroupChat: widget.onOpenGroupChat,
                                      onSocialChanged: widget.onSocialChanged,
                                      onContactChanged: widget.onContactChanged,
                                      onContactRemoved: widget.onContactRemoved,
                                      loginUid: widget.loginUid,
                                      loginName: widget.loginName,
                                    ),
                                  );
                                },
                              ),
                              FItemMixin.item(
                                title: Text(t.scanTitle),
                                prefix: const Icon(FIcons.scan),
                                onPress: () {
                                  unawaited(controller.hide(animated: false));
                                  pushPage(
                                    context,
                                    ScanPage(
                                      config: widget.config,
                                      socialGateway: widget.socialGateway,
                                      scanGateway: widget.scanGateway,
                                      contacts: widget.contacts,
                                      onOpenContactChat:
                                          widget.onOpenContactChat,
                                      onOpenGroupChat: widget.onOpenGroupChat,
                                      loginUid: widget.loginUid,
                                      loginName: widget.loginName,
                                      webLoginConfirmPageBuilder:
                                          (_, authCode, socialGateway) =>
                                              WebLoginConfirmPage(
                                                authCode: authCode,
                                                socialGateway: socialGateway,
                                              ),
                                      contactDetailPageBuilder:
                                          (
                                            _, {
                                            required contact,
                                            required isStranger,
                                          }) => ContactDetailPage(
                                            contact: contact,
                                            loginUid: widget.loginUid,
                                            loginName: widget.loginName,
                                            socialGateway: widget.socialGateway,
                                            imGateway: widget.imGateway,
                                            onSocialChanged:
                                                widget.onSocialChanged,
                                            onContactChanged:
                                                widget.onContactChanged,
                                            onContactRemoved:
                                                widget.onContactRemoved,
                                            config: widget.config,
                                            isStranger: isStranger,
                                            onOpenChat:
                                                widget.onOpenContactChat,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                        builder: (_, controller, _) => MoyuRoundIconButton(
                          icon: FIcons.plus,
                          tooltip: t.messagesNewConversation,
                          onPressed: () => unawaited(controller.toggle()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEntry(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ColoredBox(
      color: MoyuColors.of(context).background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Semantics(
          identifier: 'moyu.messages.search.field',
          container: true,
          child: FTappable(
            onPress: () => _openGlobalSearch(context),
            child: IgnorePointer(
              child: MoyuReadOnlyField(
                text: t.actionSearch,
                prefix: const Icon(FIcons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openGlobalSearch(BuildContext context) {
    pushPage(
      context,
      GlobalSearchPage(
        conversations: widget.conversations,
        contacts: widget.contacts,
        groups: widget.groups,
        socialGateway: widget.socialGateway,
        config: widget.config,
        serverAppConfig: widget.serverAppConfig,
        onOpenChat: widget.onOpenChat,
        onOpenContactChat: widget.onOpenContactChat,
      ),
    );
  }

  Future<void> _togglePin(ChatConversation conversation) async {
    final gateway = widget.imGateway;
    final t = AppLocalizations.of(context);
    if (gateway == null) {
      MoyuToast.show(context, t.messagesImDisconnected);
      return;
    }
    try {
      await gateway.updateChannelSetting(
        channelId: conversation.channelId,
        channelType: conversation.channelType,
        setting: {'top': conversation.pinned ? 0 : 1},
      );
      if (mounted) {
        MoyuToast.show(
          context,
          conversation.pinned ? t.messagesUnpinned : t.messagesPinned,
        );
      }
    } catch (error) {
      if (mounted) {
        MoyuToast.show(context, t.operationFailedWithError('$error'));
      }
    }
  }

  Future<void> _toggleMute(ChatConversation conversation) async {
    final gateway = widget.imGateway;
    final t = AppLocalizations.of(context);
    if (gateway == null) {
      MoyuToast.show(context, t.messagesImDisconnected);
      return;
    }
    try {
      await gateway.updateChannelSetting(
        channelId: conversation.channelId,
        channelType: conversation.channelType,
        setting: {'mute': conversation.muted ? 0 : 1},
      );
      if (mounted) {
        MoyuToast.show(
          context,
          conversation.muted ? t.messagesNotificationsOn : t.messagesMuted,
        );
      }
    } catch (error) {
      if (mounted) {
        MoyuToast.show(context, t.operationFailedWithError('$error'));
      }
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ChatConversation conversation,
  ) async {
    final t = AppLocalizations.of(context);
    await MoyuActionSheet.show(
      context,
      title: t.messagesDeleteConversationTitle(conversation.name),
      items: [
        MoyuActionSheetItem(
          title: t.generalClearMessages,
          onSelected: () => _clearMessagesAction(conversation),
        ),
        MoyuActionSheetItem(
          title: t.messagesConfirmDelete,
          destructive: true,
          onSelected: () => _deleteConversationAction(conversation),
        ),
      ],
    );
  }

  Future<void> _clearMessagesAction(ChatConversation conversation) async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    final t = AppLocalizations.of(context);
    try {
      await gateway.clearConversationMessages(
        channelId: conversation.channelId,
        channelType: conversation.channelType,
      );
      // 通知 home_shell 清 _messageThreads[key] in-memory cache, 否则用户
      // 清空后第一次重进会话 _initialMessagesForOpenChat 还会渲染清空前的
      // 消息, 几百 ms 后 loadMessages 拿到 0 条才刷成空 — 闪烁 + 用户误以为
      // "清空没成功". 见 MessagesPage.onConversationCleared 注释.
      widget.onConversationCleared?.call(conversation);
      if (mounted) MoyuToast.show(context, t.messagesCleared);
    } catch (error) {
      if (mounted) {
        MoyuToast.show(context, t.operationFailedWithError('$error'));
      }
    }
  }

  Future<void> _deleteConversationAction(ChatConversation conversation) async {
    final gateway = widget.imGateway;
    if (gateway == null) return;
    final t = AppLocalizations.of(context);
    try {
      await gateway.deleteConversation(
        channelId: conversation.channelId,
        channelType: conversation.channelType,
      );
      if (mounted) MoyuToast.show(context, t.messagesConversationDeleted);
    } catch (error) {
      if (mounted) {
        MoyuToast.show(context, t.operationFailedWithError('$error'));
      }
    }
  }
}

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({
    super.key,
    required this.conversations,
    required this.contacts,
    required this.groups,
    required this.onOpenChat,
    required this.onOpenContactChat,
    this.socialGateway,
    this.config,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final List<ChatConversation> conversations;
  final List<UiContact> contacts;
  final List<UiGroup> groups;
  final ChatSocialGateway? socialGateway;
  final AppConfig? config;
  final ChatServerAppConfig serverAppConfig;
  final ValueChanged<ChatConversation> onOpenChat;
  final Future<void> Function(UiContact contact) onOpenContactChat;

  @override
  State<GlobalSearchPage> createState() => GlobalSearchPageState();
}

/// 全局搜索 tab — 严格对齐 iOS WKGlobalSearchVM.tabType. iOS 没有 conversation
/// 单独 tab, "all" 时 server 返 friends/groups/messages 三块, 其余 tab 客户端
/// 清掉对应类别 (见 handleSearchResult).
///   all      → friends + groups + messages (onlyMessage=0)
///   contacts → 只显 friends (清 messages + groups)
///   group    → 只显 groups (清 friends + messages)
///   file     → onlyMessage=1, contentTypes=[file], 只显 file messages
enum _GlobalSearchTab { all, contacts, group, file }

class GlobalSearchPageState extends State<GlobalSearchPage> {
  late final TextEditingController _controller;
  final _remoteContacts = <UiContact>[];
  final _remoteGroups = <UiGroup>[];
  final _remoteMessages = <ChatConversation>[];
  final _remoteFiles = <ChatConversation>[];
  int _searchRevision = 0;
  String _remoteQuery = '';
  String _remoteError = '';
  bool _remoteSearching = false;
  _GlobalSearchTab _tab = _GlobalSearchTab.all;

  /// pullup 分页: 当前 tab 已加载的页数, 1 起
  int _currentPage = 1;

  /// 是否还有下一页 (server 返回 limit 满即可能有更多)
  bool _hasMore = false;

  /// 当前正在 pullup 加载中, 避免重复触发
  bool _loadingMore = false;
  static const int _pageLimit = 20;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleQueryChanged);
    // 对齐 iOS WKBaseTableVC.viewDidLoad → reloadRemoteData: 进入搜索
    // 页立即用空关键字 fire 一次. 服务端 onlyMessage=0 + keyword="" →
    // 返回所有好友 + 所有加入群组, 用户看到默认列表, 不用先打字才出东
    // 西. 不依赖 socialGateway 存在性 (无 gateway 时也走 local 列表).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_searchRemote(''));
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleQueryChanged() {
    final query = _controller.text.trim();
    setState(() {});
    unawaited(_searchRemote(query));
  }

  /// 滚动到底部 120pt 内 — 触发 pullup load more. NotificationListener
  /// 包外面就行 (不依赖 ScrollController, DetailScaffold 内自己的 ListView
  /// 不暴露 controller). 仅 file tab 走分页 (iOS WKGlobalSearchVM.pullup
  /// 也只在 all/file/media 三个走 — 这里 all 客户端过滤无需分页, file 分页).
  bool _onScrollNotification(ScrollNotification notif) {
    if (_tab != _GlobalSearchTab.file) return false;
    if (_loadingMore || _remoteSearching || !_hasMore) return false;
    final pos = notif.metrics;
    if (pos.maxScrollExtent - pos.pixels < 120) {
      unawaited(_loadMore());
    }
    return false;
  }

  Future<void> _selectTab(_GlobalSearchTab tab) async {
    if (_tab == tab) return;
    setState(() {
      _tab = tab;
      _currentPage = 1;
      _hasMore = false;
      _remoteContacts.clear();
      _remoteGroups.clear();
      _remoteMessages.clear();
      _remoteFiles.clear();
    });
    final query = _controller.text.trim();
    // 切 tab 一律 fire — iOS WKGlobalSearchVM.changeTabType 同款行为 (空
    // 关键字也搜, media tab 本就需要空关键字拉全部图片).
    await _searchRemote(query);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final query = _controller.text.trim().toLowerCase();
    // remoteReady: server 返回的 _remoteQuery 和当前输入框一致即可 (含空
    // 输入). 初始空载完成后 query=='' && _remoteQuery=='' → 显示默认列表
    // (全量好友 + 全量加入群; iOS QueryFriendsWithKeyword 在 keyword=""
    // 时不加 LIKE 全返).
    final remoteReady =
        widget.socialGateway != null && _remoteQuery.toLowerCase() == query;
    // tab → 该 tab 应该显示哪些 section. iOS WKGlobalSearchVM.handleSearchResult
    // 在 contacts/group/file tab 客户端清掉其他 section, all 全显.
    final showFriends =
        _tab == _GlobalSearchTab.all || _tab == _GlobalSearchTab.contacts;
    final showGroups =
        _tab == _GlobalSearchTab.all || _tab == _GlobalSearchTab.group;
    final showMessages = _tab == _GlobalSearchTab.all;
    final showFiles = _tab == _GlobalSearchTab.file;

    final contacts = remoteReady && showFriends
        ? _remoteContacts
        : const <UiContact>[];
    final groups = remoteReady && showGroups
        ? _remoteGroups
        : const <UiGroup>[];
    final messages = remoteReady && showMessages
        ? _remoteMessages
        : const <ChatConversation>[];
    final files = remoteReady && showFiles
        ? _remoteFiles
        : const <ChatConversation>[];

    final hasResults =
        contacts.isNotEmpty ||
        groups.isNotEmpty ||
        messages.isNotEmpty ||
        files.isNotEmpty;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: DetailScaffold(
        // 对齐 iOS WKConversationListHeaderView.searchbarView placeholder + iOS
        // 搜索入口 tooltip 都是 "搜索", 不是 "全局搜索".
        title: t.globalSearchTitle,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: FTextField(
              control: FTextFieldControl.managed(controller: _controller),
              hint: t.actionSearch,
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.search),
                  ),
            ),
          ),
          // tab chip row — 对齐 iOS WKGlobalSearchResultController.tabbar:
          //   全局 (searchInChannel=false): 聊天 / 联系人 / 群组 / 文件
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                for (final tab in _GlobalSearchTab.values) ...[
                  SearchTabChip(
                    label: switch (tab) {
                      _GlobalSearchTab.all => t.globalSearchTabChats,
                      _GlobalSearchTab.contacts => t.globalSearchTabContacts,
                      _GlobalSearchTab.group => t.globalSearchTabGroups,
                      _GlobalSearchTab.file => t.globalSearchTabFiles,
                    },
                    active: _tab == tab,
                    onTap: () => unawaited(_selectTab(tab)),
                  ),
                  if (tab != _GlobalSearchTab.values.last)
                    const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          if (_remoteSearching)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (_remoteError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Text(
                _remoteError,
                style: TextStyle(color: MoyuColors.of(context).red),
              ),
            ),
          if (contacts.isNotEmpty) ...[
            SectionTitle(t.globalSearchContactsSection),
            MoyuSection(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < contacts.length; i++) ...[
                  ContactTile(
                    contact: contacts[i],
                    onTap: () {
                      Navigator.of(context).pop();
                      unawaited(widget.onOpenContactChat(contacts[i]));
                    },
                  ),
                  if (i != contacts.length - 1) const MoyuDivider(),
                ],
              ],
            ),
          ],
          if (groups.isNotEmpty) ...[
            SectionTitle(t.globalSearchGroupsSection),
            MoyuSection(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < groups.length; i++) ...[
                  GroupTile(
                    group: groups[i],
                    onTap: () => pushPage(
                      context,
                      GroupDetailPage(
                        group: groups[i],
                        contacts: widget.contacts,
                        socialGateway: widget.socialGateway,
                        config: widget.config,
                        serverAppConfig: widget.serverAppConfig,
                      ),
                    ),
                  ),
                  if (i != groups.length - 1) const MoyuDivider(),
                ],
              ],
            ),
          ],
          if (messages.isNotEmpty) ...[
            SectionTitle(t.globalSearchMessagesSection),
            MoyuSection(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < messages.length; i++) ...[
                  // 对齐 iOS WKSearchMessageCell: avatar (channel logo) +
                  // name + content (高亮命中关键字) + time. 不加固定 leading
                  // icon — channel avatar 就是它的"图标".
                  SearchMessageTile(
                    conversation: messages[i],
                    keyword: query,
                    config: widget.config,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onOpenChat(messages[i]);
                    },
                  ),
                  if (i != messages.length - 1) const MoyuDivider(),
                ],
              ],
            ),
          ],
          if (files.isNotEmpty) ...[
            SectionTitle(t.globalSearchFilesSection),
            MoyuSection(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < files.length; i++) ...[
                  SearchMessageTile(
                    conversation: files[i],
                    keyword: query,
                    config: widget.config,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onOpenChat(files[i]);
                    },
                  ),
                  if (i != files.length - 1) MoyuDivider(),
                ],
              ],
            ),
          ],
          if (!hasResults && !_remoteSearching)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Text(
                  t.globalSearchNoMatches,
                  style: TextStyle(color: MoyuColors.of(context).textTertiary),
                ),
              ),
            ),
          // pullup load more loader — file tab 支持 pullup 分页
          if (_loadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (_tab == _GlobalSearchTab.file && !_hasMore && hasResults)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  t.globalSearchNoMore,
                  style: TextStyle(
                    fontSize: 12,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _searchRemote(String rawQuery) async {
    final gateway = widget.socialGateway;
    final revision = ++_searchRevision;
    final query = rawQuery.trim();
    final t = AppLocalizations.of(context);
    // 无 socialGateway → 走纯本地内存搜, 不再 fire server. 但保留空 query
    // 默认列表用本地 conversations/contacts/groups 兜底.
    if (gateway == null) {
      if (mounted) {
        setState(() {
          _remoteQuery = '';
          _remoteError = '';
          _remoteSearching = false;
          _remoteContacts.clear();
          _remoteGroups.clear();
          _remoteMessages.clear();
          _remoteFiles.clear();
          _currentPage = 1;
          _hasMore = false;
        });
      }
      return;
    }

    setState(() {
      _remoteSearching = true;
      _remoteError = '';
      _currentPage = 1;
      _hasMore = false;
    });
    try {
      // tab → searchGlobal 参数 (对齐 iOS WKGlobalSearchVM):
      //   all: contentTypes=[1,8] (text+file), onlyMessage=0 → 同时返
      //        friends/groups/messages 多 section
      //   file: contentTypes=[8] (file), onlyMessage=1 → 只 messages
      //   media: contentTypes=[2] (image), onlyMessage=1, keyword=''
      //          (iOS 同款 — 图片/视频不按 keyword 搜)
      final params = _searchParamsForTab(_tab, query);
      final result = await gateway.searchGlobal(
        keyword: params.keyword,
        onlyMessage: params.onlyMessage,
        contentTypes: params.contentTypes,
        page: 1,
        limit: _pageLimit,
      );
      if (!mounted || revision != _searchRevision) {
        return;
      }
      final remoteMessages = <ChatConversation>[];
      final remoteFiles = <ChatConversation>[];
      for (var i = 0; i < result.messages.length; i++) {
        final message = result.messages[i];
        final conversation = _conversationFromGlobalMessage(message, i);
        if (message.contentType == 8) {
          remoteFiles.add(conversation);
        } else {
          remoteMessages.add(conversation);
        }
      }
      setState(() {
        _remoteQuery = query;
        _remoteContacts
          ..clear()
          ..addAll([
            for (var i = 0; i < result.friends.length; i++)
              _contactFromGlobalChannel(
                result.friends[i],
                i,
                config: widget.config,
                l10n: t,
              ),
          ]);
        _remoteGroups
          ..clear()
          ..addAll([
            for (var i = 0; i < result.groups.length; i++)
              _groupFromGlobalChannel(
                result.groups[i],
                i,
                config: widget.config,
                l10n: t,
              ),
          ]);
        _remoteMessages
          ..clear()
          ..addAll(remoteMessages);
        _remoteFiles
          ..clear()
          ..addAll(remoteFiles);
        // 对齐 iOS WKGlobalSearchVM.pullup: 仅 all/file/media 支持 pullup
        // (Flutter 这里 all/contacts/group 共用同一请求, 不分页).
        // 当且仅当 file 满 limit 视为可能有下一页.
        if (_tab == _GlobalSearchTab.file) {
          _hasMore = remoteFiles.length >= _pageLimit;
        } else {
          _hasMore = false;
        }
      });
    } catch (error) {
      if (!mounted || revision != _searchRevision) {
        return;
      }
      setState(() {
        _remoteQuery = query;
        _remoteError = error.toString();
        _remoteContacts.clear();
        _remoteGroups.clear();
        _remoteMessages.clear();
        _remoteFiles.clear();
      });
    } finally {
      if (mounted && revision == _searchRevision) {
        setState(() => _remoteSearching = false);
      }
    }
  }

  Future<void> _loadMore() async {
    final gateway = widget.socialGateway;
    if (gateway == null || !_hasMore || _loadingMore) return;
    final query = _remoteQuery;
    // 空 query 也允许 pullup — media/file tab 服务端按 channel+contentType
    // 返回, 不需要关键字. iOS pullup 同样不要求 keyword 非空.
    setState(() {
      _loadingMore = true;
      _currentPage += 1;
    });
    try {
      final params = _searchParamsForTab(_tab, query);
      final result = await gateway.searchGlobal(
        keyword: params.keyword,
        onlyMessage: params.onlyMessage,
        contentTypes: params.contentTypes,
        page: _currentPage,
        limit: _pageLimit,
      );
      if (!mounted) return;
      final newMessages = <ChatConversation>[];
      final newFiles = <ChatConversation>[];
      for (var i = 0; i < result.messages.length; i++) {
        final m = result.messages[i];
        final c = _conversationFromGlobalMessage(
          m,
          _remoteMessages.length + _remoteFiles.length + i,
        );
        if (m.contentType == 8) {
          newFiles.add(c);
        } else {
          newMessages.add(c);
        }
      }
      setState(() {
        _remoteMessages.addAll(newMessages);
        _remoteFiles.addAll(newFiles);
        if (_tab == _GlobalSearchTab.file) {
          _hasMore = newFiles.length >= _pageLimit;
        } else {
          _hasMore = false;
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _currentPage -= 1);
      }
    } finally {
      if (mounted) {
        setState(() => _loadingMore = false);
      }
    }
  }

  _SearchTabParams _searchParamsForTab(_GlobalSearchTab tab, String query) {
    // 严格对齐 iOS WKGlobalSearchVM.search:
    //   all/contacts/group: 不设 onlyMessage, 不设 contentTypes
    //     (server 返 friends + groups + messages 三块, 客户端按 tab 过滤)
    //   file: onlyMessage=1, contentTypes=[WK_FILE=8]
    switch (tab) {
      case _GlobalSearchTab.all:
      case _GlobalSearchTab.contacts:
      case _GlobalSearchTab.group:
        return _SearchTabParams(
          keyword: query,
          onlyMessage: 0,
          contentTypes: const [],
        );
      case _GlobalSearchTab.file:
        return _SearchTabParams(
          keyword: query,
          onlyMessage: 1,
          contentTypes: const [8],
        );
    }
  }

  static UiContact _contactFromGlobalChannel(
    ChatGlobalChannel channel,
    int i, {
    AppConfig? config,
    required AppLocalizations l10n,
  }) {
    final name = moyuDisplayName(
      name: channel.channelName,
      rawIdentity: channel.channelId,
      placeholder: l10n.messagesUnknownUser,
    );
    final avatarPath = AvatarResolver.user(
      config: config,
      uid: channel.channelId,
    );
    return UiContact(
      uid: channel.channelId,
      name: name,
      avatarLabel: name.isEmpty
          ? l10n.messagesFriendAvatarFallback
          : name.characters.first,
      avatarPath: avatarPath,
      colors: conversationColors(i),
      subtitle: channel.channelRemark,
    );
  }

  static UiGroup _groupFromGlobalChannel(
    ChatGlobalChannel channel,
    int i, {
    AppConfig? config,
    required AppLocalizations l10n,
  }) {
    final name = moyuDisplayName(
      name: channel.channelName,
      rawIdentity: channel.channelId,
      placeholder: l10n.messagesGroupFallback,
    );
    final avatarPath = AvatarResolver.group(
      config: config,
      groupNo: channel.channelId,
    );
    return UiGroup(
      groupNo: channel.channelId,
      name: name,
      avatarLabel: name.isEmpty
          ? l10n.messagesGroupAvatarFallback
          : name.characters.first,
      avatarPath: avatarPath,
      memberCount: 0,
      subtitle: channel.channelRemark.isEmpty
          ? l10n.messagesGroupFallback
          : channel.channelRemark,
      color: conversationColors(i).first,
    );
  }

  ChatConversation _conversationFromGlobalMessage(
    ChatGlobalMessage message,
    int i,
  ) => searchConversationFromGlobalMessage(
    message: message,
    index: i,
    config: widget.config,
    l10n: AppLocalizations.of(context),
  );
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.identifier,
    required this.conversation,
    required this.onTap,
    this.typingText,
    this.presence,
    this.onPin,
    this.onMute,
    this.onDelete,
  });

  final String identifier;
  final ChatConversation conversation;
  final VoidCallback onTap;
  final String? typingText;
  final ChatUserPresence? presence;
  final VoidCallback? onPin;
  final VoidCallback? onMute;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final pinLabel = conversation.pinned
        ? t.messagesConversationUnpin
        : t.messagesConversationPin;
    final muteLabel = conversation.muted
        ? t.messagesConversationUnmute
        : t.messagesConversationMute;
    return Slidable(
      key: ValueKey('slidable_${conversation.channelId}'),
      groupTag: 'conversation_list',
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.6,
        children: [
          if (onMute != null)
            SlidableAction(
              onPressed: (_) => onMute!.call(),
              backgroundColor: const Color(0xFF8E8E93),
              foregroundColor: Colors.white,
              icon: conversation.muted
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              label: muteLabel,
            ),
          if (onPin != null)
            SlidableAction(
              onPressed: (_) => onPin!.call(),
              backgroundColor: const Color(0xFFFF9500),
              foregroundColor: Colors.white,
              icon: conversation.pinned
                  ? Icons.push_pin_outlined
                  : Icons.push_pin,
              label: pinLabel,
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete!.call(),
              backgroundColor: const Color(0xFFFF3B30),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: t.actionDelete,
            ),
        ],
      ),
      child: MoyuConvRow(
        identifier: identifier,
        // #10: 系统账号/文件助手按 ID 映射本地化名, 否则用会话名。
        name:
            specialAccountDisplayName(t, conversation.channelId) ??
            conversation.name,
        timeLabel: conversation.time,
        avatarLabel: conversation.avatarLabel,
        gradientColors: conversation.colors,
        avatarUrl: conversation.avatarPath,
        unread: conversation.unread,
        online: presence?.online ?? conversation.online,
        muted: conversation.muted,
        pinned: conversation.pinned,
        // 官方账号 tag (Service/Visitor) — 跟 iOS WKOfficialTag 同款.
        channelCategory: conversation.channelCategory,
        isAIBot: conversation.isRobot,
        // 自动删除 TTL — 列表 cell 头像角标 1d/2w/3m (iOS WKAutoDeleteView).
        msgAutoDeleteSeconds: conversation.msgAutoDeleteSeconds,
        // 4 种消息状态 icon (对齐 iOS WKConversationListCell.updateStatus).
        // 优先级 failed > sending > read > sent. 互斥, 仅自己发的消息显示.
        sendStatus: conversation.lastIsMine
            ? (conversation.lastMsgFailed
                  ? MoyuConvSendStatus.failed
                  : conversation.lastMsgSending
                  ? MoyuConvSendStatus.sending
                  : conversation.lastMsgRead
                  ? MoyuConvSendStatus.read
                  : MoyuConvSendStatus.sent)
            : MoyuConvSendStatus.none,
        onTap: onTap,
        preview: typingText != null
            ? TextSpan(
                text: typingText,
                style: TextStyle(color: MoyuColors.of(context).green),
              )
            : MoyuConvPreviewBuilder.build(
                content: conversation.preview,
                draft: conversation.draft,
                reminderText: conversation.reminderText,
                senderName: conversation.lastSenderName,
                draftLabel: AppLocalizations.of(context).chatDraftLabel,
                isGroup: conversation.channelType == WKChannelType.group,
                isOwnMessage: conversation.lastIsMine,
                chatPasswordEnabled: conversation.chatPasswordEnabled,
              ),
      ),
    );
  }
}

/// 顶部连接状态 banner — 对齐 iOS WKConversationListHeaderView 的
/// showNetworkError + WKConversationListVC.refreshTitle 合并版.
/// connected 状态不渲染 (调用方 gate).
/// 视觉:
/// - noNetwork: 浅红底 + 红字 "当前网络不可用，请检查网络设置" + 警告图标
/// - disconnected: 浅红底 + 红字 "已断开" (轻量级)
/// - connecting: 浅灰底 + 灰字 "连接中" + 转圈
/// - syncing: 浅灰底 + 灰字 "收取中" + 转圈 (拉离线消息中)
class _ConnectStatusBanner extends StatelessWidget {
  const _ConnectStatusBanner({required this.status});

  final ChatConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // #3: 只有 noNetwork(真没网络) 才红色 ⚠️ 告警。disconnected 多是前台
    // 重连的瞬态, 走软提示(灰底+spinner), 不做成"app 挂了"的红色大字。
    final isError = status == ChatConnectionStatus.noNetwork;
    final bg = isError
        ? const Color(0xFFFBEAE7)
        : MoyuColors.of(context).backgroundSoft;
    final fg = isError
        ? const Color(0xFFE75849)
        : MoyuColors.of(context).textSecondary;
    final text = switch (status) {
      ChatConnectionStatus.noNetwork => t.messagesConnectionNoNetwork,
      // disconnected 显示成"连接中"软提示 (它本就在重连), 不显"已断开"红字。
      ChatConnectionStatus.disconnected => t.messagesConnectionConnecting,
      ChatConnectionStatus.connecting => t.messagesConnectionConnecting,
      ChatConnectionStatus.syncing => t.messagesConnectionSyncing,
      ChatConnectionStatus.connected => '',
    };
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (isError)
            Icon(FIcons.triangleAlert, size: 16, color: fg)
          else
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(fg),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: fg, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTabParams {
  const _SearchTabParams({
    required this.keyword,
    required this.onlyMessage,
    required this.contentTypes,
  });

  final String keyword;
  final int onlyMessage;
  final List<int> contentTypes;
}
