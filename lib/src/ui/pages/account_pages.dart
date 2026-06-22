// 账号/密码 + 通知 + 群备注 + 完善资料。从 home_shell.dart 拆出。
import 'dart:async' show Timer, unawaited;
import 'dart:collection' show SplayTreeMap;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../app/app_runtime.dart';
import '../../auth/auth_repository.dart' show ChatServerAppConfig;
import '../../auth/user_session.dart';
import '../../call/chat_call_gateway.dart';
import '../../config/app_config.dart';
import '../../im/wukong_im_service.dart' show ChatImGateway;
import '../../l10n/app_localizations.dart';
import '../../media/chat_media_service.dart' show ChatMediaGateway;
import '../../modules/feature_registry.dart' show FeatureKind;
import '../../modules/module_ids.dart' show ModuleActionIds;
import '../../modules/module_route.dart';
import '../../modules/module_settings_row.dart';
import '../../scan/chat_scan_service.dart';
import '../../social/social_service.dart'
    show ChatSocialGateway, ChatUserOnlineState;
import '../chat_navigation.dart';
import '../contact_list_widgets.dart'
    show ContactTile, StaticActionRow, contactChannelId, isSystemAccount;
import '../detail_scaffold.dart';
import '../home_seed_data.dart' show coreContactActions;
import '../identity_display.dart' show moyuDisplayName;
import '../models/contact_models.dart';
import '../moyu_ink.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_layout.dart' show kTabBarReservedHeight;
import '../settings_row_widgets.dart';
import 'friend_pages.dart';
import 'group_pages.dart';
import 'shared_widgets_models.dart';

class ResetLoginPasswordPage extends StatefulWidget {
  const ResetLoginPasswordPage({
    super.key,
    required this.phone,
    this.socialGateway,
  });

  final String phone;
  final ChatSocialGateway? socialGateway;

  @override
  State<ResetLoginPasswordPage> createState() => ResetLoginPasswordPageState();
}

class ResetLoginPasswordPageState extends State<ResetLoginPasswordPage> {
  late final TextEditingController _codeController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _sendingCode = false;
  bool _submitting = false;
  String _status = '';
  String _error = '';

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _codeController.addListener(() => setState(() => _error = ''));
    _passwordController.addListener(() => setState(() => _error = ''));
    _confirmPasswordController.addListener(() => setState(() => _error = ''));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final displayPhone = displayLoginPhone(widget.phone);
    return DetailScaffold(
      title: t.securityLoginPassword,
      children: [
        settingsBlockGap(context),
        // 顶部说明 — 灰色一行小字, 跟 ChatPasswordPage 同款
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            t.passwordResetInstruction,
            style: TextStyle(
              fontSize: 13,
              color: MoyuColors.of(context).textTertiary,
              height: 1.4,
            ),
          ),
        ),
        settingsBlockGap(context),
        // 当前账号信息 + 密码规则 (信息卡片)
        settingsFlatGroup(
          context,
          rows: [
            InfoRow(label: t.accountPhoneLabel, value: displayPhone),
            const RowDivider(),
            InfoRow(label: t.passwordRuleLabel, value: t.passwordAtLeastSix),
          ],
        ),
        settingsBlockGap(context),
        // 输入字段卡片 — Moyu 风格 (label 左 / 输入框右 / hairline 分隔)
        settingsFlatGroup(
          context,
          rows: [
            MoyuCodeRow(
              label: t.authVerificationCodeLabel,
              hint: t.authVerificationCodeRequired,
              controller: _codeController,
              enabled: !_submitting,
              buttonLabel: _sendingCode
                  ? t.statusSending
                  : t.authGetVerificationCode,
              onSend: _sendingCode ? null : () => unawaited(_sendCode()),
            ),
            const RowDivider(),
            _MoyuPasswordRow(
              label: t.authNewPasswordLabel,
              hint: t.authNewPasswordLabel,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              enabled: !_submitting,
            ),
            const RowDivider(),
            _MoyuPasswordRow(
              label: t.passwordConfirmLabel,
              hint: t.passwordConfirmHint,
              controller: _confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              enabled: !_submitting,
            ),
          ],
        ),
        if (_error.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              _error,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
        if (_status.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              _status,
              style: TextStyle(
                color: MoyuColors.of(context).primary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MoyuPrimaryButton(
            label: t.securityLoginPassword,
            loading: _submitting,
            loadingLabel: t.authSubmitting,
            onPressed: _submitting ? null : _submit,
          ),
        ),
      ],
    );
  }

  Future<void> _sendCode() async {
    final phone = displayLoginPhone(widget.phone);
    setState(() {
      _sendingCode = true;
      _error = '';
      _status = '';
    });
    try {
      await widget.socialGateway?.sendPasswordResetCode(phone: phone);
      if (mounted) {
        setState(
          () => _status = AppLocalizations.of(context).authVerificationCodeSent,
        );
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context).settingsSaveFailedRetry,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sendingCode = false);
      }
    }
  }

  Future<void> _submit() async {
    final phone = displayLoginPhone(widget.phone);
    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final error = _validate(
      AppLocalizations.of(context),
      phone,
      code,
      password,
      confirmPassword,
    );
    if (error.isNotEmpty) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _submitting = true;
      _error = '';
      _status = '';
    });
    try {
      await widget.socialGateway?.resetPassword(
        phone: phone,
        code: code,
        password: password,
      );
      if (mounted) {
        setState(() => _status = AppLocalizations.of(context).passwordChanged);
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context).settingsSaveFailedRetry,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  String _validate(
    AppLocalizations t,
    String phone,
    String code,
    String password,
    String confirmPassword,
  ) {
    if (phone.trim().isEmpty) {
      return t.phoneRequired;
    }
    if (code.isEmpty) {
      return t.authCodeEmpty;
    }
    if (password.trim().length < 6) {
      return t.authPasswordLengthInvalid;
    }
    if (password != confirmPassword) {
      return t.passwordMismatch;
    }
    return '';
  }
}

class ChatPasswordPage extends StatefulWidget {
  const ChatPasswordPage({super.key, this.loginUid = '', this.socialGateway});

  final String loginUid;
  final ChatSocialGateway? socialGateway;

  @override
  State<ChatPasswordPage> createState() => ChatPasswordPageState();
}

class ChatPasswordPageState extends State<ChatPasswordPage> {
  late final TextEditingController _loginPasswordController;
  late final TextEditingController _chatPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _enabled = false;
  bool _submitting = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loginPasswordController = TextEditingController();
    _chatPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _loginPasswordController.addListener(() => setState(() => _error = ''));
    _chatPasswordController.addListener(() => setState(() => _error = ''));
    _confirmPasswordController.addListener(() => setState(() => _error = ''));
  }

  @override
  void dispose() {
    _loginPasswordController.dispose();
    _chatPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.securityChatPassword,
      children: [
        settingsBlockGap(context),
        // 顶部说明 — 灰色一行小字, 解释功能
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            t.chatPasswordInstruction,
            style: TextStyle(
              fontSize: 13,
              color: MoyuColors.of(context).textTertiary,
              height: 1.4,
            ),
          ),
        ),
        settingsBlockGap(context),
        // 当前状态 row + 密码规则 row (信息卡片)
        settingsFlatGroup(
          context,
          rows: [
            InfoRow(
              label: t.currentStatusLabel,
              value: _enabled ? t.valueOn : t.valueNotEnabled,
            ),
            const RowDivider(),
            InfoRow(label: t.passwordRuleLabel, value: t.passwordSixDigits),
          ],
        ),
        settingsBlockGap(context),
        // 输入字段卡片 — Moyu 风格 flat group + hairline divider 分隔
        settingsFlatGroup(
          context,
          rows: [
            _MoyuPasswordRow(
              label: t.securityLoginPassword,
              hint: t.securityLoginPassword,
              controller: _loginPasswordController,
              keyboardType: TextInputType.visiblePassword,
              enabled: !_enabled && !_submitting,
            ),
            const RowDivider(),
            _MoyuPasswordRow(
              label: t.authNewPasswordLabel,
              hint: t.passwordSixDigits,
              controller: _chatPasswordController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              enabled: !_enabled && !_submitting,
            ),
            const RowDivider(),
            _MoyuPasswordRow(
              label: t.passwordConfirmLabel,
              hint: t.passwordSixDigits,
              controller: _confirmPasswordController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              enabled: !_enabled && !_submitting,
            ),
          ],
        ),
        if (_error.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              _error,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MoyuPrimaryButton(
            label: _enabled ? t.valueEnabled : t.chatPasswordEnableAction,
            loading: _submitting,
            loadingLabel: t.authSubmitting,
            onPressed: _enabled || _submitting ? null : _submit,
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final loginPassword = _loginPasswordController.text.trim();
    final chatPassword = _chatPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final shouldValidate =
        widget.socialGateway != null ||
        loginPassword.isNotEmpty ||
        chatPassword.isNotEmpty ||
        confirmPassword.isNotEmpty;

    if (shouldValidate) {
      final error = _validatePasswords(
        t: AppLocalizations.of(context),
        loginPassword: loginPassword,
        password: chatPassword,
        confirmPassword: confirmPassword,
      );
      if (error.isNotEmpty) {
        setState(() => _error = error);
        return;
      }
    }

    setState(() {
      _submitting = true;
      _error = '';
    });
    try {
      await widget.socialGateway?.setChatPassword(
        uid: widget.loginUid,
        loginPassword: loginPassword,
        chatPassword: chatPassword,
      );
      if (mounted) {
        setState(() => _enabled = true);
        // 通知 caller 全局密码已成功设置, caller 用返回值决定下一步
        // (例如 conv-settings 接着开 channel chat_pwd_on switch).
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context).settingsSaveFailedRetry,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  String _validatePasswords({
    required AppLocalizations t,
    required String loginPassword,
    required String password,
    required String confirmPassword,
  }) {
    if (loginPassword.isEmpty) {
      return t.loginPasswordRequired;
    }
    if (!sixDigitPassword(password)) {
      return t.chatPasswordSixDigitsRequired;
    }
    if (password != confirmPassword) {
      return t.passwordMismatch;
    }
    return '';
  }
}

/// 密码输入 row — Moyu 风格 settings row, label 左 + 隐式输入框右.
/// 高度 56pt, 视觉跟 PlainSettingRow 同款, 输入框 obscure + counter 隐藏.
class _MoyuPasswordRow extends StatelessWidget {
  const _MoyuPasswordRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    this.enabled = true,
    this.maxLength,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MoyuColors.of(context).background,
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.08,
                color: MoyuColors.of(context).textPrimary,
              ),
            ),
          ),
          Expanded(
            // FScaffold 内没 Material ancestor, 用 Material wrap TextField
            child: Material(
              color: Colors.transparent,
              child: TextField(
                controller: controller,
                obscureText: true,
                enabled: enabled,
                keyboardType: keyboardType,
                maxLength: maxLength,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.08,
                  color: MoyuColors.of(context).textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 15.5,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  counterText: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 验证码 row — Moyu 风格 settings row, label 左 + 输入框中间 + "获取验证码"
/// 文字按钮右. 跟 `_MoyuPasswordRow` 视觉同款 (56pt min-height, hairline
/// divider 由父 settingsFlatGroup 给), 但不 obscure 文本 + 右侧带 action.
class MoyuCodeRow extends StatelessWidget {
  const MoyuCodeRow({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.buttonLabel,
    required this.onSend,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String buttonLabel;

  /// null = disabled (灰色) / loading 中
  final VoidCallback? onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MoyuColors.of(context).background,
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.08,
                color: MoyuColors.of(context).textPrimary,
              ),
            ),
          ),
          Expanded(
            // FScaffold 内没 Material ancestor, 用 Material wrap TextField
            child: Material(
              color: Colors.transparent,
              child: TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.08,
                  color: MoyuColors.of(context).textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 15.5,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FTappable(
            onPress: onSend,
            behavior: HitTestBehavior.opaque,
            child: Text(
              buttonLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: onSend == null
                    ? MoyuColors.of(context).textTertiary
                    : MoyuColors.of(context).primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    super.key,
    required this.contacts,
    required this.groups,
    required this.groupCandidates,
    required this.friendRequests,
    required this.friendRequestUnread,
    required this.loginUid,
    this.loginName = '',
    this.showTopSearchEntry = true,
    required this.callGateway,
    required this.config,
    required this.onAcceptFriendRequest,
    required this.onRefuseFriendRequest,
    required this.onDeleteFriendRequest,
    required this.onRefreshFriendRequests,
    required this.onMarkFriendRequestsRead,
    required this.onOpenContactChat,
    required this.onOpenGroupChat,
    required this.onSaveGroup,
    this.imGateway,
    this.onSocialChanged,
    this.onContactChanged,
    this.onContactRemoved,
    this.socialGateway,
    this.scanGateway,
    this.runtime,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final List<UiContact> contacts;
  final List<UiGroup> groups;
  final List<UiGroup> groupCandidates;
  final List<UiFriendRequest> friendRequests;

  /// 未读好友请求数 — 走 home_shell 持有的 _readFriendRequestUids 计算
  /// (持久化在 SharedPreferences), 对齐 iOS WKFriendRequestDB.readed=0
  /// count. _withDynamicBadge + tab badge 都读这个值.
  final int friendRequestUnread;
  final String loginUid;
  final String loginName;
  final bool showTopSearchEntry;
  final ChatCallGateway? callGateway;
  final ChatImGateway? imGateway;
  final AppConfig config;
  final ChatSocialGateway? socialGateway;
  final ChatScanGateway? scanGateway;
  final AppRuntime? runtime;
  final ChatServerAppConfig serverAppConfig;
  final Future<void> Function(UiFriendRequest request) onAcceptFriendRequest;
  final Future<void> Function(UiFriendRequest request) onRefuseFriendRequest;
  final Future<void> Function(UiFriendRequest request) onDeleteFriendRequest;
  final Future<void> Function() onRefreshFriendRequests;

  /// 用户点"新的朋友"入口时调用 — 把当前所有 friendRequests uid 加入
  /// 已读 set + 持久化, 跟 iOS WKContactsModule.m:71
  /// markAllFriendRequestToReaded 同时机.
  final VoidCallback onMarkFriendRequestsRead;
  final Future<void> Function(UiContact contact) onOpenContactChat;
  final Future<bool> Function(String groupNo) onOpenGroupChat;
  final Future<UiGroup?> Function(UiGroup group) onSaveGroup;
  final Future<void> Function()? onSocialChanged;
  final ValueChanged<UiContact>? onContactChanged;
  final ValueChanged<String>? onContactRemoved;

  @override
  State<ContactsPage> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  List<UiContact>? _groupedContactsSource;
  Map<String, List<UiContact>> _groupedContacts = const {};
  Timer? _contactPresenceTimer;
  Set<String> _lastPresenceUids = const <String>{};
  Map<String, ChatUserOnlineState> _presenceByUid =
      const <String, ChatUserOnlineState>{};

  @override
  void initState() {
    super.initState();
    _restartContactPresencePolling();
  }

  @override
  void didUpdateWidget(covariant ContactsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.socialGateway != widget.socialGateway ||
        oldWidget.contacts != widget.contacts) {
      _restartContactPresencePolling();
    }
  }

  /// public: 双击 tab 回顶用. home_shell 持 GlobalKey for ContactsPageState
  /// 调. 跟 _MessagesPageState.scrollToTop 同 pattern (300ms easeOutCubic).
  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _contactPresenceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Set<String> _contactPresenceUids() {
    final uids = <String>{};
    for (final contact in widget.contacts) {
      if (contact.uid.isEmpty || isSystemAccount(contact)) continue;
      uids.add(contact.uid);
    }
    return uids;
  }

  void _restartContactPresencePolling() {
    _contactPresenceTimer?.cancel();
    _contactPresenceTimer = null;
    _lastPresenceUids = const <String>{};
    if (widget.socialGateway == null) {
      if (_presenceByUid.isNotEmpty) {
        setState(() => _presenceByUid = const <String, ChatUserOnlineState>{});
      }
      return;
    }
    unawaited(_pollContactPresence(force: true));
    _contactPresenceTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_pollContactPresence(force: true));
    });
  }

  Future<void> _pollContactPresence({bool force = false}) async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    final uids = _contactPresenceUids();
    if (uids.isEmpty) {
      if (mounted && _presenceByUid.isNotEmpty) {
        setState(() => _presenceByUid = const <String, ChatUserOnlineState>{});
      }
      return;
    }
    if (!force &&
        uids.length == _lastPresenceUids.length &&
        uids.containsAll(_lastPresenceUids) &&
        _presenceByUid.isNotEmpty) {
      return;
    }
    _lastPresenceUids = uids;
    try {
      final states = await gateway.loadOnlineForUids(uids.toList());
      final byUid = {
        for (final state in states)
          if (state.uid.isNotEmpty) state.uid: state,
      };
      if (!mounted) return;
      setState(() {
        _presenceByUid = {
          for (final uid in uids)
            uid: byUid[uid] ?? ChatUserOnlineState(uid: uid),
        };
      });
    } catch (_) {
      // Online status is display-only; keep the previous snapshot.
    }
  }

  ChatUserOnlineState? _contactPresenceFor(UiContact contact) {
    if (contact.uid.isEmpty || isSystemAccount(contact)) return null;
    if (widget.socialGateway == null) return null;
    return _presenceByUid[contact.uid] ?? ChatUserOnlineState(uid: contact.uid);
  }

  Map<String, List<UiContact>> _ensureGroupedContacts(AppLocalizations t) {
    if (identical(_groupedContactsSource, widget.contacts)) {
      return _groupedContacts;
    }
    _groupedContactsSource = widget.contacts;
    _groupedContacts = _groupContactsByInitial(
      widget.contacts,
      t.contactUnknownUser,
    );
    _sectionKeys
      ..removeWhere((letter, _) => !_groupedContacts.containsKey(letter))
      ..addEntries(
        _groupedContacts.keys
            .where((letter) => !_sectionKeys.containsKey(letter))
            .map((letter) => MapEntry(letter, GlobalKey())),
      );
    return _groupedContacts;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final grouped = _ensureGroupedContacts(t);

    final tabBarInset =
        kTabBarReservedHeight + MediaQuery.viewPaddingOf(context).bottom;
    // Glass header overlay 通顶 — same iOS-WeChat pattern as
    // _MessagesPage: status bar icons render on the blurred header,
    // content scrolls under it. The +12 buffer keeps the search bar
    // breathing room below the title row instead of touching the
    // glass edge (which clipped the search bar's top in the prior
    // pass).
    final headerInset =
        MediaQuery.viewPaddingOf(context).top +
        60 +
        (widget.showTopSearchEntry ? 12 : 0);
    final contactActions = [...coreContactActions, ..._moduleContactActions(t)];
    // 包一层 ColoredBox 让 ListView 顶部 padding 区域 (nav glass 下方留给
    // header 的空白带) 跟下方 list cell 同色. 没这层会透出 FScaffold default
    // bg = forui zinc dark, 跟 MoyuColors._dark.background (#0F0F12) 不一致,
    // dark 下 nav 跟第一行间出 seam (用户报"间隔色没适配, 与上下颜色不同").
    return ColoredBox(
      color: MoyuColors.of(context).background,
      child: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(top: headerInset, bottom: tabBarInset),
            children: [
              if (widget.showTopSearchEntry) _buildContactSearchEntry(context),
              ColoredBox(
                color: MoyuColors.of(context).background,
                child: Column(
                  children: [
                    for (var i = 0; i < contactActions.length; i++) ...[
                      ActionTile(
                        action: _localizedContactAction(
                          t,
                          _withDynamicBadge(contactActions[i]),
                          source: contactActions[i],
                        ),
                        onTap: () =>
                            _openContactAction(context, contactActions[i]),
                      ),
                      if (i != contactActions.length - 1)
                        const MoyuDivider(indent: 68),
                    ],
                  ],
                ),
              ),
              if (widget.contacts.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: MoyuEmptyState(
                    icon: FIcons.users,
                    title: t.contactsEmptyTitle,
                    subtitle: t.contactsEmptySubtitle,
                  ),
                )
              else
                ...grouped.entries.map(
                  (entry) => Column(
                    key: _sectionKeys[entry.key],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MoyuSectionLetter(letter: entry.key),
                      ColoredBox(
                        color: MoyuColors.of(context).background,
                        child: Column(
                          children: [
                            for (var i = 0; i < entry.value.length; i++) ...[
                              ContactTile(
                                contact: entry.value[i],
                                presence: _contactPresenceFor(entry.value[i]),
                                // 用户规范：通讯录列表 tap 直接进聊天（不进
                                // 名片详情页）。详情页从聊天页头像 / 长按
                                // action sheet 进入。
                                onTap: () => unawaited(
                                  widget.onOpenContactChat(entry.value[i]),
                                ),
                                onLongPress: () => _showContactActions(
                                  context,
                                  entry.value[i],
                                ),
                              ),
                              if (i != entry.value.length - 1)
                                const MoyuDivider(indent: 64),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.contacts.isNotEmpty) ...[
                SizedBox(height: 24),
                Center(
                  child: Text(
                    t.contactsCount(widget.contacts.length),
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (grouped.isNotEmpty)
            Positioned(
              right: 4,
              top: 60,
              bottom: 60,
              child: _AzIndexBar(
                letters: grouped.keys.toList(),
                onLetter: (letter) {
                  final key = _sectionKeys[letter];
                  final ctx = key?.currentContext;
                  if (ctx != null) {
                    Scrollable.ensureVisible(
                      ctx,
                      alignment: 0,
                      duration: const Duration(milliseconds: 180),
                    );
                  }
                },
              ),
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
                  title: AppLocalizations.of(context).pageContactsTitle,
                  onTitleDoubleTap: scrollToTop,
                  actions: [
                    Semantics(
                      identifier: 'moyu.contacts.add',
                      container: true,
                      child: MoyuRoundIconButton(
                        icon: FIcons.userRoundPlus,
                        tooltip: t.contactAddTooltip,
                        onPressed: () => pushPage(
                          context,
                          AddFriendPage(
                            config: widget.config,
                            socialGateway: widget.socialGateway,
                            scanGateway: widget.scanGateway,
                            callGateway: widget.callGateway,
                            imGateway: widget.imGateway,
                            contacts: widget.contacts,
                            onOpenContactChat: widget.onOpenContactChat,
                            onOpenGroupChat: widget.onOpenGroupChat,
                            onSocialChanged: widget.onSocialChanged,
                            onContactChanged: widget.onContactChanged,
                            onContactRemoved: widget.onContactRemoved,
                            loginUid: widget.loginUid,
                            loginName: widget.loginName,
                          ),
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

  Widget _buildContactSearchEntry(BuildContext context) {
    return ColoredBox(
      color: MoyuColors.of(context).background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Semantics(
          identifier: 'moyu.contacts.search.field',
          container: true,
          child: FTappable(
            onPress: () => _openContactSearch(context),
            child: IgnorePointer(
              child: MoyuReadOnlyField(
                text: AppLocalizations.of(context).contactSearchHint,
                prefix: Icon(FIcons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openContactSearch(BuildContext context) {
    pushPage(
      context,
      ContactSearchPage(
        contacts: widget.contacts,
        loginUid: widget.loginUid,
        loginName: widget.loginName,
        callGateway: widget.callGateway,
        socialGateway: widget.socialGateway,
        imGateway: widget.imGateway,
        onSocialChanged: widget.onSocialChanged,
        onContactChanged: widget.onContactChanged,
        onContactRemoved: widget.onContactRemoved,
        onOpenContactChat: widget.onOpenContactChat,
      ),
    );
  }

  Future<void> _showContactActions(
    BuildContext context,
    UiContact contact,
  ) async {
    await MoyuActionSheet.show(
      context,
      title: contact.name,
      items: [
        MoyuActionSheetItem(
          title: AppLocalizations.of(context).contactSetRemark,
          onSelected: () {
            // Placeholder — push existing remark editor in detail page.
            pushPage(
              context,
              ContactDetailPage(
                contact: contact,
                loginUid: widget.loginUid,
                loginName: widget.loginName,
                callGateway: widget.callGateway,
                socialGateway: widget.socialGateway,
                imGateway: widget.imGateway,
                onSocialChanged: widget.onSocialChanged,
                onContactChanged: widget.onContactChanged,
                onContactRemoved: widget.onContactRemoved,
                config: widget.config,
                onOpenChat: widget.onOpenContactChat,
              ),
            );
          },
        ),
        MoyuActionSheetItem(
          title: AppLocalizations.of(context).contactAddToBlacklist,
          onSelected: () => _addToBlacklist(contact),
        ),
        MoyuActionSheetItem(
          title: AppLocalizations.of(context).contactDeleteFriend,
          destructive: true,
          onSelected: () => _confirmDeleteFriend(context, contact),
        ),
      ],
    );
  }

  Future<void> _addToBlacklist(UiContact contact) async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      MoyuToast.show(context, AppLocalizations.of(context).chatImDisconnected);
      return;
    }
    try {
      await gateway.addUserBlacklist(contact.uid);
      await widget.imGateway?.deleteConversation(
        channelId: contact.uid,
        channelType: 1,
      );
      if (!mounted) return;
      widget.onContactRemoved?.call(contact.uid);
      MoyuToast.show(
        context,
        AppLocalizations.of(context).contactAddedToBlacklist,
      );
      unawaited(widget.onSocialChanged?.call() ?? Future<void>.value());
    } catch (error) {
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).operationFailed);
      }
    }
  }

  Future<void> _confirmDeleteFriend(
    BuildContext context,
    UiContact contact,
  ) async {
    await MoyuActionSheet.show(
      context,
      title: AppLocalizations.of(
        context,
      ).contactDeleteFriendConfirm(contact.name),
      items: [
        MoyuActionSheetItem(
          title: AppLocalizations.of(context).contactConfirmDelete,
          destructive: true,
          onSelected: () => _deleteFriend(contact),
        ),
      ],
    );
  }

  Future<void> _deleteFriend(UiContact contact) async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    try {
      await gateway.deleteFriend(contact.uid);
      await widget.imGateway?.deleteConversation(
        channelId: contact.uid,
        channelType: 1,
      );
      if (!mounted) return;
      widget.onContactRemoved?.call(contact.uid);
      MoyuToast.show(context, AppLocalizations.of(context).contactDeleted);
      unawaited(widget.onSocialChanged?.call() ?? Future<void>.value());
    } catch (error) {
      if (mounted) {
        MoyuToast.show(context, AppLocalizations.of(context).operationFailed);
      }
    }
  }

  UiContactAction _withDynamicBadge(UiContactAction action) {
    if (identical(action, coreContactActions[0])) {
      // badge = unread (未在 read set 内), 跟 iOS WKContactsHeaderItem
      // 的 getFriendRequestUnreadCount 一致. 用户点击后会走
      // _openContactAction → onMarkFriendRequestsRead 清掉 badge.
      return UiContactAction(
        icon: action.icon,
        color: action.color,
        colors: action.colors,
        title: action.title,
        subtitle: action.subtitle,
        badge: widget.friendRequestUnread,
        routeId: action.routeId,
      );
    }
    return action;
  }

  void _openContactAction(BuildContext context, UiContactAction action) {
    final routeId = action.routeId;
    if (routeId != null) {
      _openContactModuleRoute(context, routeId);
      return;
    }
    // case '朋友圈' 已删 — 朋友圈入口统一收在 发现 tab.
    if (identical(action, coreContactActions[0])) {
      // 对齐 iOS WKContactsModule.m:71: 点击"新的朋友"入口时
      // markAllFriendRequestToReaded, 再 push VC. 顺序很重要 —
      // 先清未读再 push, 让 TAB / row badge 立即消失.
      widget.onMarkFriendRequestsRead();
      pushPage(
        context,
        FriendRequestsPage(
          requests: widget.friendRequests,
          socialGateway: widget.socialGateway,
          scanGateway: widget.scanGateway,
          config: widget.config,
          loginUid: widget.loginUid,
          loginName: widget.loginName,
          onAccept: widget.onAcceptFriendRequest,
          onRefuse: widget.onRefuseFriendRequest,
          onDelete: widget.onDeleteFriendRequest,
          onRefresh: widget.onRefreshFriendRequests,
        ),
      );
      return;
    }
    if (identical(action, coreContactActions[1])) {
      pushPage(
        context,
        GroupListPage(
          groups: widget.groups,
          groupCandidates: widget.groupCandidates,
          contacts: widget.contacts,
          socialGateway: widget.socialGateway,
          config: widget.config,
          serverAppConfig: widget.serverAppConfig,
          onOpenGroupChat: widget.onOpenGroupChat,
          onSaveGroup: widget.onSaveGroup,
        ),
      );
    }
  }

  UiContactAction _localizedContactAction(
    AppLocalizations t,
    UiContactAction action, {
    required UiContactAction source,
  }) {
    if (identical(source, coreContactActions[0])) {
      return UiContactAction(
        icon: action.icon,
        color: action.color,
        colors: action.colors,
        title: t.contactActionNewFriends,
        subtitle: action.subtitle,
        badge: action.badge,
        routeId: action.routeId,
      );
    }
    if (identical(source, coreContactActions[1])) {
      return UiContactAction(
        icon: action.icon,
        color: action.color,
        colors: action.colors,
        title: t.contactActionSavedGroups,
        subtitle: action.subtitle,
        badge: action.badge,
        routeId: action.routeId,
      );
    }
    return action;
  }

  List<UiContactAction> _moduleContactActions(AppLocalizations t) {
    final runtime = widget.runtime;
    if (runtime == null) return const [];
    final rows =
        runtime.registry
            .enabledFeatures(kind: FeatureKind.settingsRow)
            .map((feature) => feature.value)
            .whereType<ModuleSettingsRow>()
            .where(
              (row) => row.placement == ModuleSettingsRowPlacement.contacts,
            )
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return [
      for (final row in rows)
        UiContactAction(
          icon: row.icon,
          color: row.color,
          colors: row.colors,
          title: row.id == ModuleActionIds.contactTags
              ? t.tagsTitle
              : row.title,
          subtitle: row.subtitle,
          routeId: row.routeId,
        ),
    ];
  }

  void _openContactModuleRoute(BuildContext context, String routeId) {
    final activeRuntime = widget.runtime;
    final feature = activeRuntime?.registry.featureById(routeId);
    final route = feature?.value;
    final isEnabled =
        feature != null &&
        (activeRuntime?.registry.isModuleEnabled(feature.moduleId) ?? false);
    if (route is! ModuleRouteDescriptor) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      return;
    }
    if (!isEnabled) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      return;
    }
    pushPage(
      context,
      route.build(
        context,
        ModuleRouteContext(
          socialGateway: widget.socialGateway,
          contacts: [
            for (final contact in widget.contacts)
              ModuleRouteContact(
                channelId: contactChannelId(contact),
                uid: contact.uid,
                name: contact.name,
                avatarPath: contact.avatarPath,
              ),
          ],
          groups: [
            for (final group in widget.groups)
              ModuleRouteGroup(
                groupNo: group.groupNo,
                name: group.name,
                avatarLabel: group.avatarLabel,
                avatarPath: group.avatarPath,
                color: group.color,
              ),
          ],
        ),
      ),
    );
  }
}

/// Groups contacts by their first character — A-Z buckets when ASCII letter,
/// otherwise lumped under '#'. Returns a sorted map (A→Z then '#').
Map<String, List<UiContact>> _groupContactsByInitial(
  List<UiContact> contacts,
  String unknownUser,
) {
  final groups = <String, List<UiContact>>{};
  for (final contact in contacts) {
    final letter = _initialOf(
      moyuDisplayName(
        name: contact.name,
        rawIdentity: contact.uid,
        placeholder: unknownUser,
      ),
    );
    groups.putIfAbsent(letter, () => []).add(contact);
  }
  final sorted = SplayTreeMap<String, List<UiContact>>((a, b) {
    if (a == '#') return 1;
    if (b == '#') return -1;
    return a.compareTo(b);
  });
  for (final entry in groups.entries) {
    entry.value.sort((x, y) {
      final xn = moyuDisplayName(
        name: x.name,
        rawIdentity: x.uid,
        placeholder: unknownUser,
      ).toUpperCase();
      final yn = moyuDisplayName(
        name: y.name,
        rawIdentity: y.uid,
        placeholder: unknownUser,
      ).toUpperCase();
      return xn.compareTo(yn);
    });
    sorted[entry.key] = entry.value;
  }
  return sorted;
}

String _initialOf(String text) {
  if (text.isEmpty) return '#';
  final first = text[0];
  final code = first.toUpperCase().codeUnitAt(0);
  if (code >= 0x41 && code <= 0x5A) return String.fromCharCode(code);
  return '#';
}

/// Right-side A-Z jump bar — shows actual letters present in the list,
/// taps scroll the list to that section. WeChat-style minimal column.
class _AzIndexBar extends StatelessWidget {
  const _AzIndexBar({required this.letters, required this.onLetter});

  final List<String> letters;
  final ValueChanged<String> onLetter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final letter in letters)
            FTappable(
              behavior: HitTestBehavior.opaque,
              onPress: () => onLetter(letter),
              child: SizedBox(
                height: 16,
                width: 16,
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: MoyuColors.of(context).primary,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// `SwitchRow` variant with a fixed-position subtitle paragraph below
/// the toggle row. Used by `消息回执` to render the iOS-native
/// "开启后…" hint that lives directly under the row, instead of the
/// standalone `MoyuSection` footer.
class SwitchRowWithSubtitle extends StatelessWidget {
  const SwitchRowWithSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchRow(title: title, value: value, onChanged: onChanged),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: Text(
            subtitle,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Local-only group nickname editor. The wukong server has no per-user
/// channel-remark write API, so we persist via SharedPreferences and
/// surface the row anyway — the iOS native page also exposes a 群备注
/// row even when the backend round-trip is unimplemented; the user
/// can still set a private label visible only to themself.
class GroupRemarkEditorPage extends StatefulWidget {
  const GroupRemarkEditorPage({
    super.key,
    required this.initialValue,
    required this.onSaved,
  });

  final String initialValue;
  final ValueChanged<String> onSaved;

  @override
  State<GroupRemarkEditorPage> createState() => GroupRemarkEditorPageState();
}

class GroupRemarkEditorPageState extends State<GroupRemarkEditorPage> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.groupRemarkTitle,
      children: [
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.groupRemarkHint,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 48,
            child: FButton(
              onPress: () {
                widget.onSaved(_controller.text.trim());
                Navigator.of(context).pop();
              },
              child: Text(t.actionSave),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sub-page collecting per-channel notification toggles for personal
/// chats (mirrors the iOS `WKConversationPersonSettingVC` "消息通知设置"
/// drill-down). Group chats keep these toggles inline because the
/// surface already has dedicated rows for member management — only
/// person settings get the drill-down.
class ChatNotificationSettingsPage extends StatefulWidget {
  const ChatNotificationSettingsPage({
    super.key,
    required this.screenshotNotify,
    required this.revokeNotify,
    required this.onScreenshotChanged,
    required this.onRevokeChanged,
  });

  final bool screenshotNotify;
  final bool revokeNotify;
  final ValueChanged<bool> onScreenshotChanged;
  final ValueChanged<bool> onRevokeChanged;

  @override
  State<ChatNotificationSettingsPage> createState() =>
      ChatNotificationSettingsPageState();
}

class ChatNotificationSettingsPageState
    extends State<ChatNotificationSettingsPage> {
  late bool _screenshot = widget.screenshotNotify;
  late bool _revoke = widget.revokeNotify;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.chatNotificationSettingsTitle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.chatScreenshotNotification,
              value: _screenshot,
              onChanged: (value) {
                setState(() => _screenshot = value);
                widget.onScreenshotChanged(value);
              },
            ),
            const RowDivider(),
            SwitchRow(
              title: t.chatRevokeNotification,
              value: _revoke,
              onChanged: (value) {
                setState(() => _revoke = value);
                widget.onRevokeChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({
    super.key,
    required this.session,
    required this.onComplete,
    this.socialGateway,
    this.mediaGateway,
  });

  final UserSession session;
  final ChatSocialGateway? socialGateway;
  final ChatMediaGateway? mediaGateway;
  final ValueChanged<UserSession> onComplete;

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

bool sixDigitPassword(String value) => RegExp(r'^\d{6}$').hasMatch(value);

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  late final TextEditingController _nameController;
  late String _avatar;
  String _status = '';
  bool _statusIsError = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.session.name);
    _nameController.addListener(() => setState(() {}));
    _avatar = widget.session.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.completeProfileTitle,
      trailing: MoyuTextButton(
        label: t.actionConfirm,
        onPressed: _saving ? null : () => unawaited(_submit()),
      ),
      children: [
        MoyuSection(
          padding: EdgeInsets.zero,
          children: [
            StaticActionRow(
              icon: FIcons.image,
              iconColor: MoyuColors.of(context).primary,
              title: _avatar.isEmpty
                  ? t.completeProfileUploadAvatar
                  : t.completeProfileReuploadAvatar,
              subtitle: _avatar.isEmpty
                  ? t.completeProfileChooseAvatar
                  : t.completeProfileAvatarUploaded,
              onTap: () => unawaited(_uploadAvatar()),
            ),
            const MoyuDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: FTextField(
                control: FTextFieldControl.managed(controller: _nameController),
                label: Text(t.nicknameLabel),
                hint: t.nicknameInputHint,
              ),
            ),
          ],
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
            child: Text(
              _status,
              style: TextStyle(
                color: _statusIsError
                    ? MoyuColors.of(context).red
                    : MoyuColors.of(context).primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _uploadAvatar() async {
    final attachment = await widget.mediaGateway?.pickImage();
    if (attachment == null || attachment.localPath.isEmpty) {
      return;
    }
    await widget.socialGateway?.uploadCurrentUserAvatar(
      uid: widget.session.uid,
      filePath: attachment.localPath,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _avatar = AvatarResolver.userPath(widget.session.uid);
      _status = AppLocalizations.of(context).completeProfileAvatarUploaded;
      _statusIsError = false;
    });
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (_avatar.isEmpty) {
      setState(() {
        _status = AppLocalizations.of(context).completeProfileAvatarRequired;
        _statusIsError = true;
      });
      return;
    }
    if (name.isEmpty) {
      setState(() {
        _status = AppLocalizations.of(context).nicknameRequired;
        _statusIsError = true;
      });
      return;
    }
    setState(() {
      _saving = true;
      _statusIsError = false;
    });
    try {
      if (name != widget.session.name) {
        await widget.socialGateway?.updateCurrentUserInfo(
          key: 'name',
          value: name,
        );
      }
      if (!mounted) {
        return;
      }
      widget.onComplete(widget.session.copyWith(name: name, avatar: _avatar));
      setState(() {
        _status = AppLocalizations.of(context).completeProfileSaved;
        _statusIsError = false;
      });
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
