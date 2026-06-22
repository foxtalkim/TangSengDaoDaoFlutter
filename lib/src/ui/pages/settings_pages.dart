// 设置子页面集合：安全隐私 / 账号注销 / 锁屏密码 / 设备 / 黑名单 /
// 通用设置 / 聊天背景 / App 模块 / 错误日志 / 通知 / 关于 / 隐私协议。
// 从 home_shell.dart 拆出。
import 'dart:async' show unawaited;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Directory, File;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationCacheDirectory;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/auth_repository.dart' show ChatServerAppConfig;
import '../../auth/locale_controller.dart';
import '../../auth/locale_store.dart';
import '../../auth/recent_account_store.dart';
import '../../auth/session_store.dart';
import '../../auth/user_session.dart';
import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../im/wukong_im_service.dart' show ChatImGateway;
import '../../l10n/app_localizations.dart';
import '../../logs/error_log_service.dart';
import '../../settings/bubble_color_controller.dart';
import '../../settings/bubble_color_store.dart';
import '../../settings/bubble_radius_controller.dart';
import '../../settings/bubble_radius_store.dart';
import '../../settings/font_scale_controller.dart';
import '../../settings/font_scale_store.dart';
import '../../settings/tab_bar_style_controller.dart';
import '../../settings/tab_bar_style_store.dart';
import '../../settings/theme_mode_controller.dart';
import '../../social/social_service.dart'
    show
        ChatAppModule,
        ChatAppVersion,
        ChatDevice,
        ChatSocialGateway,
        lockScreenDigest;
import '../chat_navigation.dart';
import '../contact_list_widgets.dart'
    show SectionTitle, StaticActionRow, contactChannelId;
import '../detail_scaffold.dart';
import '../home_seed_data.dart' show conversationColors;
import '../models/contact_models.dart';
import '../moyu_ink.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_row_widgets.dart';
import 'account_pages.dart'
    show ChatPasswordPage, MoyuCodeRow, ResetLoginPasswordPage;
import 'app_icon_settings_page.dart' show AppIconSettingsPage;
import 'chat_background_pages.dart' show ChatBackgroundsPage;
import '../onboarding_screen.dart' show OnboardingScreen;
import 'shared_widgets_models.dart'
    show SwitchRow, persistUserSetting, readPersistedSetting;

class SecurityPrivacyPage extends StatefulWidget {
  const SecurityPrivacyPage({
    super.key,
    required this.loginUid,
    required this.loginPhone,
    this.chatPwd = '',
    this.lockAfterMinute = 0,
    this.settings = const {},
    this.socialGateway,
    this.config,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final String loginUid;
  final String loginPhone;
  final String chatPwd;
  final int lockAfterMinute;
  final Map<String, Object?> settings;
  final ChatSocialGateway? socialGateway;
  final AppConfig? config;
  final ChatServerAppConfig serverAppConfig;

  @override
  State<SecurityPrivacyPage> createState() => SecurityPrivacyPageState();
}

class SecurityPrivacyPageState extends State<SecurityPrivacyPage> {
  late final Map<String, bool> _local;
  String _status = '';

  @override
  void initState() {
    super.initState();
    // _local 优先用 UserSession.current.settings (全局 source of truth,
    // 上次 _toggle 写回的最新值), fallback 到 widget.settings (父 widget
    // 传的初始值). 这样 pop 再进 page 时不会回弹到 stale widget.settings.
    _local = {
      'offline_protection': _readEnabled('offline_protection'),
      'search_by_short': _readEnabled('search_by_short'),
      'search_by_phone': _readEnabled('search_by_phone'),
      'join_group_need_confirm': _readEnabled('join_group_need_confirm'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // settingsFlatGroup + settingsBlockGap (满铺白色 + 0.5px hairline +
    // 12px 浅灰间隔) 对齐 iOS UITableViewStyleGrouped.
    //
    // Section 排序严格对齐 iOS WKSecuritySettingVM (WuKongSecurity/.../
    // WKSecuritySettingVM.m:38-167): 6 个 section 按原版顺序:
    //  1. 搜索好友 (2 switch + remark "关闭后...")
    //  2. 登录密码
    //  3. 聊天密码
    //  4. 屏幕保护 (锁屏密码 + 断网屏保)
    //  5. 登录设备管理 (+ remark "查看并管理设备...")
    //  6. 黑名单 + 注销账号
    // iOS WKSecuritySettingVM:26-30 同款判断: lock_screen_pwd 非空 = 已开启.
    final lockEnabled = (UserSession.current?.lockScreenPwd ?? '').isNotEmpty;
    return DetailScaffold(
      title: t.profileRowSecurityPrivacy,
      children: [
        // Section 1: 搜索好友 — iOS 原版无 section title, 仅 remark 在底部
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            if (!widget.serverAppConfig.phoneSearchOff) ...[
              SwitchRow(
                title: t.securityAllowPhoneSearch,
                value: _local['search_by_phone']!,
                onChanged: (v) => _toggle('search_by_phone', v),
              ),
              const RowDivider(),
            ],
            SwitchRow(
              title: t.securityAllowFoxIdSearch(AppBrand.displayName),
              value: _local['search_by_short']!,
              onChanged: (v) => _toggle('search_by_short', v),
            ),
          ],
        ),
        _sectionRemark(context, t.securitySearchRemark),

        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.securityJoinGroupNeedConfirm,
              value: _local['join_group_need_confirm']!,
              onChanged: (v) => _toggle('join_group_need_confirm', v),
            ),
          ],
        ),
        _sectionRemark(context, t.securityJoinGroupNeedConfirmRemark),

        // Section 2: 登录密码
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.securityLoginPassword,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ResetLoginPasswordPage(
                  phone: widget.loginPhone,
                  socialGateway: widget.socialGateway,
                ),
              ),
            ),
          ],
        ),

        // Section 3: 聊天密码
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.securityChatPassword,
              value: widget.chatPwd.isEmpty
                  ? t.valueNotEnabled
                  : t.valueConfigured,
              valueMuted: widget.chatPwd.isEmpty,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ChatPasswordPage(
                  loginUid: widget.loginUid,
                  socialGateway: widget.socialGateway,
                ),
              ),
            ),
          ],
        ),

        // Section 4: 屏幕保护 — 这一 section iOS 有 title
        SectionTitle(t.securityScreenProtection),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.securityLockPassword,
              value: lockEnabled ? t.valueOn : t.valueOff,
              valueMuted: !lockEnabled,
              showChevron: true,
              // pop 回来后 setState 让 lockEnabled 重新读 UserSession.current
              // (子页改了 digest 但父 widget 默认不 rebuild → 状态显示 stale).
              // 同款修复也加到 device_lock 那个 row.
              onTap: () async {
                await pushPage(
                  context,
                  _LockScreenPasswordPage(
                    loginUid: widget.loginUid,
                    socialGateway: widget.socialGateway,
                  ),
                );
                if (mounted) setState(() {});
              },
            ),
            const RowDivider(),
            SwitchRow(
              title: t.securityOfflineProtection,
              value: _local['offline_protection']!,
              onChanged: (v) => _toggle('offline_protection', v),
            ),
          ],
        ),

        // Section 5: 登录设备管理 — iOS 原版无 section title, 有底部 remark
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.securityDeviceManagement,
              value: _readEnabled('device_lock') ? t.valueOn : t.valueOff,
              valueMuted: !_readEnabled('device_lock'),
              showChevron: true,
              onTap: () => pushPage(
                context,
                _DeviceManagerPage(
                  deviceLockEnabled: _readEnabled('device_lock'),
                  socialGateway: widget.socialGateway,
                ),
              ),
            ),
          ],
        ),
        _sectionRemark(context, t.securityDeviceRemark),

        // Section 6: 黑名单 + 注销账号
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.securityBlacklist,
              showChevron: true,
              onTap: () => pushPage(
                context,
                _BlacklistPage(
                  socialGateway: widget.socialGateway,
                  config: widget.config,
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.securityAccountDeletion,
              showChevron: true,
              onTap: () => pushPage(
                context,
                _AccountDeletionPage(socialGateway: widget.socialGateway),
              ),
            ),
          ],
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Text(
              _status,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  /// iOS UITableViewStyleGrouped section 底部 remark 灰色小字
  /// (跟原版 WKSectionRemarkModel 视觉对齐). 13pt 浅灰, 边距 16/8/16/4.
  Widget _sectionRemark(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        height: 1.4,
        color: MoyuColors.of(context).textTertiary,
      ),
    ),
  );

  Future<void> _toggle(String key, bool value) async {
    final prev = _local[key]!;
    setState(() {
      _local[key] = value;
      _status = '';
    });
    try {
      await persistUserSetting(
        socialGateway: widget.socialGateway,
        key: key,
        value: value,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _local[key] = prev;
        _status = AppLocalizations.of(context).settingsSaveFailedRetry;
      });
    }
  }

  bool _readEnabled(String key, {bool fallback = false}) =>
      readPersistedSetting(key, widget.settings, fallback: fallback);
}

class _AccountDeletionPage extends StatefulWidget {
  const _AccountDeletionPage({this.socialGateway});

  final ChatSocialGateway? socialGateway;

  @override
  State<_AccountDeletionPage> createState() => _AccountDeletionPageState();
}

class _AccountDeletionPageState extends State<_AccountDeletionPage> {
  final _controller = TextEditingController();
  bool _codeSent = false;
  bool _submitted = false;
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.securityAccountDeletion,
      children: [
        settingsBlockGap(context),
        // 顶部说明 — 灰色一行小字, 跟 ChatPasswordPage 同款风格
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            t.accountDeletionBody,
            style: TextStyle(
              fontSize: 13,
              color: MoyuColors.of(context).textTertiary,
              height: 1.4,
            ),
          ),
        ),
        if (_codeSent && !_submitted) ...[
          settingsBlockGap(context),
          // 验证码输入卡片 — Moyu 风格 label + 输入
          settingsFlatGroup(
            context,
            rows: [
              MoyuCodeRow(
                label: t.authVerificationCodeLabel,
                hint: t.authVerificationCodeRequired,
                controller: _controller,
                enabled: !_loading,
                buttonLabel: t.statusSent,
                onSend: null,
              ),
            ],
          ),
        ],
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
        settingsBlockGap(context),
        // 主按钮 → PlainSettingRow(danger,center) 红字居中, 跟 退出登录 /
        // 锁屏密码"关闭"行 同款样式. 用户 requirement: "这个按钮的样式和
        // 退出登陆是一样的, 都没有在规范里出现的".
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: _buttonText(t),
              danger: !_submitted,
              center: true,
              onTap: _actionEnabled ? _submit : null,
            ),
          ],
        ),
        if (_submitted)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              t.accountDeletionSubmitted,
              style: TextStyle(
                color: MoyuColors.of(context).primary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }

  bool get _actionEnabled {
    if (_submitted || _loading) {
      return false;
    }
    return !_codeSent || _controller.text.trim().isNotEmpty;
  }

  String _buttonText(AppLocalizations t) {
    if (_submitted) {
      return t.statusSubmitted;
    }
    if (_loading) {
      return t.statusProcessing;
    }
    return _codeSent ? t.securityAccountDeletion : t.accountDeletionGetCode;
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      if (!_codeSent) {
        await widget.socialGateway?.sendDestroyAccountCode();
        if (mounted) {
          setState(() => _codeSent = true);
        }
        return;
      }
      await widget.socialGateway?.destroyAccount(_controller.text);
      if (mounted) {
        setState(() => _submitted = true);
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context).settingsSaveFailedRetry,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}

class _LockScreenPasswordPage extends StatefulWidget {
  const _LockScreenPasswordPage({required this.loginUid, this.socialGateway});

  final String loginUid;
  final ChatSocialGateway? socialGateway;

  @override
  State<_LockScreenPasswordPage> createState() =>
      _LockScreenPasswordPageState();
}

class _LockScreenPasswordPageState extends State<_LockScreenPasswordPage> {
  late final TextEditingController _passwordController;
  final FocusNode _passwordFocus = FocusNode();
  bool _enabled = false;
  bool _unlocked = false; // whether current lock password was verified
  bool _submitting = false;
  bool _shaking = false;
  int _lockAfterMinute = 0;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    final session = UserSession.current;
    if (session != null) {
      _enabled = session.lockScreenPwd.isNotEmpty;
      _lockAfterMinute = session.lockAfterMinute;
    }
    // 三态:
    //   1. 未开启 (_enabled=false) → 设新密码 (输完 6 位自动 _setPassword)
    //   2. 已开启 + 未解锁 (_enabled=true, _unlocked=false) → challenge 输旧密码 → _verifyCurrent
    //   3. 已开启 + 已解锁 (_unlocked=true) → 显示自动锁定 + 更改 + 关闭
    // 对齐 iOS WKSecuritySettingVM:97-110 (已开 → WKScreenPasswordVC challenge → WKScreenPasswordSettingVC)
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    if (_error.isNotEmpty) setState(() => _error = '');
    if (value.length != 6) {
      setState(() {});
      return;
    }
    if (!_enabled) {
      unawaited(_setPassword(value));
    } else if (!_unlocked) {
      _verifyCurrent(value);
    } else {
      // _unlocked 状态没有 pin input - 不会走到这.
    }
  }

  void _wrongPin(String msg) {
    HapticFeedback.heavyImpact();
    setState(() {
      _error = msg;
      _passwordController.clear();
      _shaking = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _shaking = false);
    });
  }

  void _verifyCurrent(String pwd) {
    final digest = lockScreenDigest(uid: widget.loginUid, password: pwd);
    final expected = UserSession.current?.lockScreenPwd ?? '';
    if (digest != expected) {
      _wrongPin(AppLocalizations.of(context).lockWrongPassword);
      return;
    }
    setState(() {
      _unlocked = true;
      _passwordController.clear();
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.securityLockPassword,
      children: [
        if (!_enabled) ..._setNewPasswordView(context),
        if (_enabled && !_unlocked) ..._challengeView(context),
        if (_enabled && _unlocked) ..._unlockedView(context),
      ],
    );
  }

  /// 没设密码 — 显示「设置 6 位锁屏密码」+ 6 dot indicator.
  List<Widget> _setNewPasswordView(BuildContext context) {
    return [
      settingsBlockGap(context),
      _pinPromptHeader(
        context,
        title: AppLocalizations.of(context).lockSetTitle,
        subtitle: AppLocalizations.of(
          context,
        ).lockSetSubtitle(AppBrand.displayName),
      ),
      _pinDotsAndInput(context),
    ];
  }

  /// 已设密码 + 没解锁 — 显示「请输入当前锁屏密码」+ 6 dot.
  List<Widget> _challengeView(BuildContext context) {
    return [
      settingsBlockGap(context),
      _pinPromptHeader(
        context,
        title: AppLocalizations.of(context).lockCurrentPromptTitle,
        subtitle: AppLocalizations.of(context).lockCurrentPromptSubtitle,
      ),
      _pinDotsAndInput(context),
    ];
  }

  /// 已解锁 — 显示自动锁定 + 更改解锁密码 + 关闭解锁密码 (danger row).
  /// 视觉对齐 iOS WKScreenPasswordSettingVC (3 section grouped style).
  List<Widget> _unlockedView(BuildContext context) {
    return [
      SectionTitle(AppLocalizations.of(context).lockAutoLock),
      settingsFlatGroup(
        context,
        rows: [
          for (var i = 0; i < _lockAfterOptions.length; i++) ...[
            PlainSettingRow(
              title: _lockAfterOptionLabel(
                AppLocalizations.of(context),
                _lockAfterOptions[i],
              ),
              trailing: _lockAfterMinute == _lockAfterOptions[i].minute
                  ? Icon(
                      FIcons.check,
                      size: 18,
                      color: MoyuColors.of(context).primary,
                    )
                  : null,
              onTap: () =>
                  unawaited(_setLockAfterMinute(_lockAfterOptions[i].minute)),
            ),
            if (i != _lockAfterOptions.length - 1) const RowDivider(),
          ],
        ],
      ),
      settingsBlockGap(context),
      settingsFlatGroup(
        context,
        rows: [
          PlainSettingRow(
            title: AppLocalizations.of(context).lockChangePassword,
            showChevron: true,
            onTap: () {
              // 进入"重新输入新密码"流程: 清回 _enabled=false, _unlocked=false
              // 状态 (内部状态机). server 端 setLockScreenPassword 覆盖旧 digest.
              setState(() {
                _enabled = false;
                _unlocked = false;
                _passwordController.clear();
                _error = '';
              });
            },
          ),
        ],
      ),
      settingsBlockGap(context),
      settingsFlatGroup(
        context,
        rows: [
          PlainSettingRow(
            title: AppLocalizations.of(context).lockClosePassword,
            danger: true,
            center: true,
            onTap: _submitting ? null : _closePassword,
          ),
        ],
      ),
    ];
  }

  /// Dot indicator 上方的 lock icon + 标题 + 副标题 hero header.
  /// 跟 _LockScreenInputPage 同款风格 (lockKeyhole 圆角图标 + 标题副标).
  Widget _pinPromptHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final colors = MoyuColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(FIcons.lockKeyhole, size: 28, color: colors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  /// 6 dot indicator + 隐藏 TextField (autofocus 调起数字键盘).
  /// 用 ValueListenableBuilder 监听 controller — dot 实时跟随输入 rebuild,
  Widget _pinDotsAndInput(BuildContext context) {
    final colors = MoyuColors.of(context);
    return GestureDetector(
      onTap: () => _passwordFocus.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 90),
              offset: _shaking ? const Offset(0.02, 0) : Offset.zero,
              curve: Curves.elasticIn,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _passwordController,
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    final filled = i < value.text.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? colors.textPrimary : null,
                          border: Border.all(
                            color: colors.textPrimary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(
                  color: colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            // 可见但完全透明的 TextField — autofocus 必生效. transparent
            // text/cursor + fontSize 0.01 让视觉看不见, 但 widget 仍参与
            // layout 接键盘. 跟 _LockScreenInputPage 同款方案 (Offstage 在
            // 嵌套 layout 下 autofocus 不稳定).
            SizedBox(
              height: 1,
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  obscureText: true,
                  showCursor: false,
                  cursorColor: Colors.transparent,
                  enableInteractiveSelection: false,
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 0.01,
                    height: 0.01,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: _onPinChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setPassword(String password) async {
    if (!sixDigitPassword(password)) {
      _wrongPin(AppLocalizations.of(context).lockSixDigitsRequired);
      return;
    }
    setState(() {
      _submitting = true;
      _error = '';
    });
    try {
      await widget.socialGateway?.setLockScreenPassword(
        uid: widget.loginUid,
        password: password,
      );
      final current = UserSession.current;
      if (current != null) {
        final digest = lockScreenDigest(
          uid: widget.loginUid,
          password: password,
        );
        final updated = current.copyWith(lockScreenPwd: digest);
        UserSession.current = updated;
        unawaited(SessionStore.save(updated));
      }
      // 设密码成功 pop 出去回安全页 (跟 iOS WKScreenPasswordSetVC 同款行为).
      // 父 SecurityPrivacyPage onTap.then setState → row 立即变"已开启".
      // 下次再点入 → initState 看到 _enabled=true, _unlocked=false → 走
      // challenge view 要旧密码. 不在本 page setState `_unlocked=true` 留
      // 在"自动锁定/更改/关闭" view, 用户会误以为"没要求密码就让我看了
      // 后续设置".
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) _wrongPin(AppLocalizations.of(context).lockSetFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _setLockAfterMinute(int minute) async {
    setState(() {
      _submitting = true;
      _error = '';
    });
    try {
      await widget.socialGateway?.updateLockAfterMinute(minute);
      // Mirror the new threshold into the active session + persisted
      // store so the LockScreenGuard's resume check uses the new
      // value without waiting for the next `/user/info` refresh.
      final current = UserSession.current;
      if (current != null) {
        final updated = current.copyWith(lockAfterMinute: minute);
        UserSession.current = updated;
        unawaited(SessionStore.save(updated));
      }
      if (mounted) {
        setState(() => _lockAfterMinute = minute);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _closePassword() async {
    setState(() {
      _submitting = true;
      _error = '';
    });
    try {
      await widget.socialGateway?.closeLockScreenPassword();
      // Clear the local digest in lockstep with the server so the
      // guard stops gating resumes immediately. Persist so a cold
      // restart sees the same state.
      final current = UserSession.current;
      if (current != null) {
        final updated = current.copyWith(lockScreenPwd: '');
        UserSession.current = updated;
        unawaited(SessionStore.save(updated));
      }
      // 关闭成功直接 pop 出去回安全页 (父 onTap 用 .then setState 会刷新
      // "锁屏密码 已关闭" row). 不要 setState `_enabled=false` 留在本 page,
      // 否则 build 进 _setNewPasswordView 让用户误以为"关闭没生效, 又回到
      // 设密码页".
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          _submitting = false;
        });
      }
    }
  }
}

class _LockAfterOption {
  const _LockAfterOption(this.minute, this.label);

  final int minute;
  final String label;
}

const _lockAfterOptions = [
  _LockAfterOption(0, 'immediate'),
  _LockAfterOption(5, '5m'),
  _LockAfterOption(30, '30m'),
  _LockAfterOption(60, '1h'),
];

String _lockAfterOptionLabel(AppLocalizations t, _LockAfterOption option) {
  return switch (option.minute) {
    0 => t.lockImmediately,
    5 => t.lockAfter5Minutes,
    30 => t.lockAfter30Minutes,
    60 => t.lockAfter1Hour,
    _ => option.label,
  };
}

bool sixDigitPassword(String value) => RegExp(r'^\d{6}$').hasMatch(value);

class _DeviceManagerPage extends StatefulWidget {
  const _DeviceManagerPage({
    this.deviceLockEnabled = false,
    this.socialGateway,
  });

  final bool deviceLockEnabled;
  final ChatSocialGateway? socialGateway;

  @override
  State<_DeviceManagerPage> createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<_DeviceManagerPage> {
  final _devices = <ChatDevice>[];
  late bool _deviceLockEnabled = widget.deviceLockEnabled;
  String _status = '';

  @override
  void initState() {
    super.initState();
    if (widget.socialGateway == null) {
      _deviceLockEnabled = true;
      _devices.add(
        const ChatDevice(
          id: 'local-current',
          name: 'Current Device',
          platform: 'iPhone / Android debug device',
          current: true,
        ),
      );
    }
    unawaited(_loadDevices());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.securityDeviceManagement,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.deviceLoginProtection,
              value: _deviceLockEnabled,
              onChanged: (value) => unawaited(_setDeviceLock(value)),
            ),
          ],
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              _status,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: MoyuColors.of(context).primary,
              ),
            ),
          ),
        if (!_deviceLockEnabled)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              t.deviceProtectionRemark,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: MoyuColors.of(context).textTertiary,
              ),
            ),
          )
        else if (_devices.isEmpty) ...[
          settingsBlockGap(context),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(
                t.deviceNone,
                style: TextStyle(color: MoyuColors.of(context).textTertiary),
              ),
            ),
          ),
        ] else ...[
          settingsBlockGap(context),
          settingsFlatGroup(
            context,
            rows: [
              for (var i = 0; i < _devices.length; i++) ...[
                PlainSettingRow(
                  title: _devices[i].id == 'local-current'
                      ? t.deviceDebugName
                      : _devices[i].name,
                  value: _devices[i].current
                      ? t.valueCurrentDevice
                      : t.groupRemove,
                  valueMuted: _devices[i].current,
                  onTap: _devices[i].current
                      ? null
                      : () => unawaited(_deleteDevice(_devices[i])),
                ),
                if (i != _devices.length - 1) const RowDivider(),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _loadDevices() async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      return;
    }
    try {
      final devices = await gateway.loadDevices();
      if (!mounted) {
        return;
      }
      setState(() {
        _devices
          ..clear()
          ..addAll(devices);
      });
    } catch (_) {
      // Keep the page empty when device list is unavailable.
    }
  }

  Future<void> _deleteDevice(ChatDevice device) async {
    await widget.socialGateway?.deleteDevice(device.id);
    if (!mounted) {
      return;
    }
    setState(() => _devices.remove(device));
  }

  Future<void> _setDeviceLock(bool enabled) async {
    setState(() {
      _deviceLockEnabled = enabled;
      _status = '';
    });
    try {
      await persistUserSetting(
        socialGateway: widget.socialGateway,
        key: 'device_lock',
        value: enabled,
      );
      if (mounted) {
        setState(
          () => _status = enabled
              ? AppLocalizations.of(context).deviceProtectionEnabled
              : AppLocalizations.of(context).deviceProtectionDisabled,
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _deviceLockEnabled = !enabled;
        _status = AppLocalizations.of(context).deviceProtectionUpdateFailed;
      });
    }
  }
}

class _BlacklistPage extends StatefulWidget {
  const _BlacklistPage({this.socialGateway, this.config});

  final ChatSocialGateway? socialGateway;
  final AppConfig? config;

  @override
  State<_BlacklistPage> createState() => _BlacklistPageState();
}

class _BlacklistPageState extends State<_BlacklistPage> {
  final _blocked = <UiContact>[];

  @override
  void initState() {
    super.initState();
    // 删 mock: 不再用 seedContacts 占位, 空起步由 _loadBlacklist 填。
    unawaited(_loadBlacklist());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.securityBlacklist,
      children: [
        settingsBlockGap(context),
        if (_blocked.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(
                t.blacklistEmpty,
                style: TextStyle(color: MoyuColors.of(context).textTertiary),
              ),
            ),
          )
        else
          settingsFlatGroup(
            context,
            rows: [
              for (var i = 0; i < _blocked.length; i++) ...[
                PlainSettingRow(
                  title: _blocked[i].name,
                  value: t.groupRemove,
                  onTap: () => unawaited(_removeBlocked(_blocked[i])),
                ),
                if (i != _blocked.length - 1) const RowDivider(),
              ],
            ],
          ),
      ],
    );
  }

  Future<void> _loadBlacklist() async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      return;
    }
    try {
      final contacts = await gateway.loadBlacklist();
      if (!mounted) {
        return;
      }
      setState(() {
        _blocked
          ..clear()
          ..addAll([
            for (var i = 0; i < contacts.length; i++)
              UiContact.fromSocial(
                contacts[i],
                colors: conversationColors(i),
                config: widget.config,
              ),
          ]);
      });
    } catch (_) {
      // Keep the page empty when the service is unreachable.
    }
  }

  Future<void> _removeBlocked(UiContact contact) async {
    await widget.socialGateway?.removeUserBlacklist(contactChannelId(contact));
    if (!mounted) {
      return;
    }
    setState(() => _blocked.remove(contact));
  }
}

class CommonSettingsPage extends StatefulWidget {
  const CommonSettingsPage({
    super.key,
    required this.config,
    required this.serverScope,
    required this.session,
    required this.loginUid,
    required this.onLogout,
    this.imGateway,
    this.socialGateway,
  });

  final AppConfig config;
  final String serverScope;
  final UserSession session;
  final String loginUid;

  /// 退出登录 callback — 跟 _ProfilePage.onLogout 同一路径 (清 prefs +
  /// 跳回 LoginPage). 入口已从 我 tab 主页挪到 通用设置 末尾 (用户
  /// requirement: "退出登陆样式做对齐，且这个入口应该是在通用设置里的").
  final VoidCallback onLogout;
  final ChatImGateway? imGateway;
  final ChatSocialGateway? socialGateway;

  @override
  State<CommonSettingsPage> createState() => CommonSettingsPageState();
}

class CommonSettingsPageState extends State<CommonSettingsPage> {
  static const _versionStatusLatest = 'latest';
  static const _versionStatusFailed = 'failed';

  String _cacheSize = '—';
  ChatAppVersion? _appVersion;
  bool _versionLoading = false;
  String _versionStatus = '';
  // _fontSize / _themeMode 都改成从 controller 读, 不再 local state.
  // 全局 textScaler / themeMode 由 main.dart 的 ChatImApp 持有真相, 设置页
  // 通过 InheritedWidget controller 读 + change.
  bool _clearingMessages = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    unawaited(_computeCacheSize());
    unawaited(_checkNewVersion(showDialogOnUpdate: false));
  }

  Future<void> _computeCacheSize() async {
    try {
      final dir = await getApplicationCacheDirectory();
      final size = await _directorySizeBytes(dir);
      if (!mounted) return;
      setState(() => _cacheSize = _formatBytes(size));
    } catch (_) {
      if (!mounted) return;
      setState(() => _cacheSize = '—');
    }
  }

  static Future<int> _directorySizeBytes(Directory dir) async {
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        try {
          total += await entity.length();
        } catch (_) {
          // ignore unreadable entries
        }
      }
    }
    return total;
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    const units = ['KB', 'MB', 'GB'];
    var value = bytes / 1024;
    for (final unit in units) {
      if (value < 1024) return '${value.toStringAsFixed(1)} $unit';
      value /= 1024;
    }
    return '${value.toStringAsFixed(1)} TB';
  }

  Future<void> _purgeDiskCache() async {
    try {
      final dir = await getApplicationCacheDirectory();
      if (!await dir.exists()) return;
      await for (final entity in dir.list(followLinks: false)) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (_) {
          /* skip locked entries */
        }
      }
    } catch (_) {
      /* best-effort; UI already shows 0 B */
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final appVersion = _appVersion;
    return DetailScaffold(
      title: t.generalPageTitle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            // 字号 / 聊天背景 / 深色模式 已迁移到 我 → 外观 (AppearancePage).
            // 通用页保留清缓存 / 清记录 / 语言 / 关于 等
            // "工具类"设置, 视觉外观相关全去外观入口.
            PlainSettingRow(
              title: t.generalClearCache,
              value: _cacheSize,
              valueMuted: true,
              onTap: _confirmClearCache,
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.generalClearMessages,
              value: _clearingMessages ? t.statusProcessing : t.valueClear,
              valueMuted: true,
              onTap: _clearingMessages ? null : _confirmClearAllMessages,
            ),
            const RowDivider(),
            Builder(
              builder: (rowContext) {
                final controller = LocaleController.of(rowContext);
                final t = AppLocalizations.of(rowContext);
                final ordered = <String>[
                  LocaleStore.systemPreference,
                  ...LocaleStore.supportedPreferences,
                ];
                final current = LocaleStore.normalizePreference(
                  controller.current,
                );
                String labelFor(String key) =>
                    key == LocaleStore.systemPreference
                    ? t.settingsLanguageSystem
                    : LocaleStore.nativeLanguageName(key);
                return PlainSettingRow(
                  title: t.settingsLanguageRow,
                  value: labelFor(current),
                  onTap: () => _openOptionPage(
                    title: t.settingsLanguageRow,
                    value: labelFor(current),
                    options: [for (final key in ordered) labelFor(key)],
                    onSelected: (picked) {
                      for (final key in ordered) {
                        if (labelFor(key) == picked) {
                          unawaited(controller.change(key));
                          break;
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.settingsCheckNewVersion,
              value: _versionLoading
                  ? t.settingsChecking
                  : appVersion?.hasDownload == true
                  ? t.settingsVersionFound
                  : _localizedVersionStatus(t),
              valueMuted: true,
              onTap: () =>
                  unawaited(_checkNewVersion(showDialogOnUpdate: true)),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.settingsUserAgreement,
              value: t.settingsView,
              showChevron: true,
              onTap: () => unawaited(_openPolicyUrl('user_agreement.html')),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.settingsPrivacyPolicy,
              value: t.settingsView,
              showChevron: true,
              onTap: () => unawaited(_openPolicyUrl('privacy_policy.html')),
            ),
          ],
        ),
        settingsBlockGap(context),
        // 关于 — 单独一组 (从 我 tab 主页迁入, 用户 requirement:
        // "【关于】也是在通用里")
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.profileRowAbout(AppBrand.displayName),
              showChevron: true,
              onTap: () => pushPage(context, const AboutPage()),
            ),
          ],
        ),
        settingsBlockGap(context),
        // 切换账号 / 退出登录 — 单独一组, danger 居中红字 confirm row, 跟 锁屏密码
        // "关闭" + 账号注销 confirm 行 同款样式. 用户 requirement:
        // "退出登陆样式做对齐".
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.settingsSwitchAccount,
              center: true,
              onTap: () => pushPage(
                context,
                _SwitchAccountPage(
                  config: widget.config,
                  serverScope: widget.serverScope,
                  session: widget.session,
                  onLogout: widget.onLogout,
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.profileLogout,
              danger: true,
              center: true,
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              _status,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: MoyuColors.of(context).primary,
              ),
            ),
          ),
      ],
    );
  }

  String _localizedVersionStatus(AppLocalizations t) {
    return switch (_versionStatus) {
      _versionStatusLatest => t.settingsAlreadyLatestVersion,
      _versionStatusFailed => t.settingsCheckFailed,
      _ => _versionStatus,
    };
  }

  Future<void> _openPolicyUrl(String path) async {
    final baseUrl = widget.config.webBaseUrl;
    final separator = baseUrl.endsWith('/') ? '' : '/';
    await launchUrl(
      Uri.parse('$baseUrl$separator$path'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _confirmClearAllMessages() {
    final t = AppLocalizations.of(context);
    MoyuActionSheet.show(
      context,
      title: '${t.dialogClearAllTitle}\n${t.dialogClearAllBody}',
      cancelLabel: t.actionCancel,
      items: [
        MoyuActionSheetItem(
          title: t.valueClear,
          destructive: true,
          onSelected: () => unawaited(_clearAllMessages()),
        ),
      ],
    );
  }

  void _clearImageCache() {
    final t = AppLocalizations.of(context);
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    setState(() {
      _cacheSize = '0 B';
      _status = t.settingsCacheCleared;
    });
    unawaited(_purgeDiskCache());
  }

  void _confirmClearCache() {
    final t = AppLocalizations.of(context);
    MoyuActionSheet.show(
      context,
      title: t.settingsClearCacheSheetTitle,
      items: [
        MoyuActionSheetItem(
          title: t.settingsClearCacheAction,
          destructive: true,
          onSelected: _clearImageCache,
        ),
      ],
    );
  }

  Future<void> _clearAllMessages() async {
    final t = AppLocalizations.of(context);
    setState(() {
      _clearingMessages = true;
      _status = '';
    });
    try {
      await widget.imGateway?.clearAllMessages();
      if (!mounted) {
        return;
      }
      setState(() => _status = t.settingsMessagesCleared);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _status = t.settingsClearMessagesFailed('$error'));
    } finally {
      if (mounted) {
        setState(() => _clearingMessages = false);
      }
    }
  }

  Future<void> _checkNewVersion({required bool showDialogOnUpdate}) async {
    if (_versionLoading) {
      return;
    }
    setState(() {
      _versionLoading = true;
      if (showDialogOnUpdate) {
        _versionStatus = '';
      }
    });
    try {
      final version = await widget.socialGateway?.loadAppVersion(
        os: _currentAppVersionOs(),
        currentVersion: _flutterAppVersion,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _appVersion = version?.hasDownload == true ? version : null;
        _versionStatus = version?.hasDownload == true
            ? ''
            : _versionStatusLatest;
      });
      if (showDialogOnUpdate && version?.hasDownload == true) {
        _showUpdateDialog(version!);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _versionStatus = _versionStatusFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _versionLoading = false;
        });
      }
    }
  }

  void _showUpdateDialog(ChatAppVersion version) {
    final t = AppLocalizations.of(context);
    final description = version.updateDescription.trim();
    final title = description.isEmpty
        ? t.settingsUpdateDialogTitle(version.appVersion)
        : t.settingsUpdateDialogTitleWithDescription(
            version.appVersion,
            description,
          );
    MoyuActionSheet.show(
      context,
      title: title,
      cancelLabel: t.settingsLater,
      showCancel: !version.force,
      isDismissible: !version.force,
      enableDrag: !version.force,
      items: [
        MoyuActionSheetItem(
          title: t.settingsUpdateNow,
          onSelected: () => unawaited(
            launchUrl(
              Uri.parse(widget.config.showUrl(version.downloadUrl)),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),
      ],
    );
  }

  void _openOptionPage({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    pushPage(
      context,
      _CommonOptionPage(
        title: title,
        value: value,
        options: options,
        onSelected: onSelected,
      ),
    );
  }

  /// 退出登录确认 sheet — 复用 _ProfilePage 原有 confirm 流程.
  /// 用 MoyuActionSheet (iOS UIAlertController .actionSheet 同款),
  /// destructive 红字, onSelected 走 widget.onLogout (清 prefs + 跳
  /// LoginPage, 真相源在 _ChatImAppState).
  void _confirmLogout(BuildContext context) {
    final t = AppLocalizations.of(context);
    MoyuActionSheet.show(
      context,
      title: t.profileLogoutConfirm,
      items: [
        MoyuActionSheetItem(
          title: t.profileLogout,
          destructive: true,
          onSelected: _returnToLogin,
        ),
      ],
    );
  }

  void _returnToLogin() {
    final onLogout = widget.onLogout;
    Navigator.of(context).popUntil((route) => route.isFirst);
    onLogout();
  }
}

class _SwitchAccountPage extends StatefulWidget {
  const _SwitchAccountPage({
    required this.config,
    required this.serverScope,
    required this.session,
    required this.onLogout,
  });

  final AppConfig config;
  final String serverScope;
  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<_SwitchAccountPage> createState() => _SwitchAccountPageState();
}

class _SwitchAccountPageState extends State<_SwitchAccountPage> {
  List<RecentAccount> _accounts = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAccounts());
  }

  Future<void> _loadAccounts() async {
    final accounts = await RecentAccountStore.load(
      serverScope: widget.serverScope,
    );
    if (!mounted) return;
    setState(() {
      _accounts = accounts;
      _loading = false;
    });
  }

  List<RecentAccount> get _visibleAccounts {
    final current = RecentAccount.fromSession(widget.session);
    return [
      current,
      for (final account in _accounts)
        if (account.uid != current.uid) account,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final accounts = _visibleAccounts;
    return DetailScaffold(
      title: t.settingsSwitchAccount,
      children: [
        SectionTitle(t.switchAccountRecent),
        settingsFlatGroup(
          context,
          rows: [
            for (var i = 0; i < accounts.length; i++) ...[
              _SwitchAccountRow(
                config: widget.config,
                account: accounts[i],
                current: accounts[i].uid == widget.session.uid,
                onTap: accounts[i].uid == widget.session.uid
                    ? null
                    : () => unawaited(_switchTo(accounts[i])),
              ),
              if (i != accounts.length - 1) const RowDivider(),
            ],
          ],
        ),
        if (_loading)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              t.switchAccountLoading,
              style: TextStyle(
                color: MoyuColors.of(context).textTertiary,
                fontSize: 12,
              ),
            ),
          ),
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.switchAccountAddOther,
              center: true,
              onTap: () => unawaited(_loginOther()),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _switchTo(RecentAccount account) async {
    await RecentAccountStore.setLoginPrefill(
      account.loginId,
      serverScope: widget.serverScope,
    );
    if (!mounted) return;
    _returnToLogin();
  }

  Future<void> _loginOther() async {
    await RecentAccountStore.setLoginPrefill(
      '',
      serverScope: widget.serverScope,
    );
    if (!mounted) return;
    _returnToLogin();
  }

  void _returnToLogin() {
    final onLogout = widget.onLogout;
    Navigator.of(context).popUntil((route) => route.isFirst);
    onLogout();
  }
}

class _SwitchAccountRow extends StatelessWidget {
  const _SwitchAccountRow({
    required this.config,
    required this.account,
    required this.current,
    this.onTap,
  });

  final AppConfig config;
  final RecentAccount account;
  final bool current;
  final VoidCallback? onTap;

  String get _avatarUrl {
    final avatar = account.avatar.trim();
    return AvatarResolver.user(
      config: config,
      uid: account.uid,
      imageUrl: avatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final row = Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: MoyuColors.of(context).background,
      child: Row(
        children: [
          MoyuResolvedAvatar.raw(
            label: account.displayName,
            size: 44,
            imageUrl: _avatarUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MoyuColors.of(context).textPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.08,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  account.loginId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MoyuColors.of(context).textTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (current)
            Text(
              t.switchAccountCurrent,
              style: TextStyle(
                color: MoyuColors.of(context).textTertiary,
                fontSize: 14,
              ),
            )
          else
            Icon(
              moyuForwardChevronIcon(context),
              size: 16,
              color: MoyuColors.of(context).textTertiary,
            ),
        ],
      ),
    );
    if (onTap == null) return row;
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}

class _AppModulesPage extends StatefulWidget {
  const _AppModulesPage({required this.loginUid, required this.socialGateway});

  final String loginUid;
  final ChatSocialGateway? socialGateway;

  @override
  State<_AppModulesPage> createState() => _AppModulesPageState();
}

class _AppModulesPageState extends State<_AppModulesPage> {
  final List<ChatAppModule> _modules = [];
  final Set<String> _checkedModuleIds = {};
  bool _loading = true;
  bool _saving = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    unawaited(_loadModules());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.generalAppModules,
      trailing: _loading || _modules.isEmpty
          ? null
          : FButton(
              size: FButtonSizeVariant.sm,
              onPress: _saving ? null : () => unawaited(_saveModules()),
              child: Text(t.actionSave),
            ),
      children: [
        if (_loading)
          _moduleEmpty(t.appModulesLoading)
        else if (_modules.isEmpty)
          _moduleEmpty(t.appModulesEmpty)
        else
          MoyuSection(
            padding: EdgeInsets.zero,
            children: [
              for (var i = 0; i < _modules.length; i++) ...[
                if (_modules[i].enabled && !_modules[i].locked)
                  SwitchRow(
                    title: _modules[i].name,
                    value: _checkedModuleIds.contains(_modules[i].sid),
                    onChanged: (value) =>
                        _setModuleChecked(_modules[i].sid, value),
                  )
                else if (_modules[i].locked)
                  StaticActionRow(
                    icon: FIcons.settings,
                    iconColor: MoyuColors.of(context).primary,
                    title: _modules[i].name,
                    subtitle: _moduleDescription(_modules[i]),
                    value: t.valueEnabled,
                  )
                else
                  StaticActionRow(
                    icon: FIcons.settings,
                    iconColor: MoyuColors.of(context).textTertiary,
                    title: _modules[i].name,
                    subtitle: _moduleDescription(_modules[i]),
                    value: t.valueDisabled,
                  ),
                if (_modules[i].enabled &&
                    _modules[i].description.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Text(
                      _modules[i].description,
                      style: TextStyle(
                        color: MoyuColors.of(context).textTertiary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                if (i != _modules.length - 1) MoyuDivider(),
              ],
              if (_status.isNotEmpty) ...[
                MoyuDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: MoyuColors.of(context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _moduleEmpty(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 42, 16, 0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: MoyuColors.of(context).textTertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _loadModules() async {
    final modules = await widget.socialGateway?.loadAppModules() ?? const [];
    final localChecked = await _loadLocalCheckedModuleIds();
    if (!mounted) {
      return;
    }
    setState(() {
      _modules
        ..clear()
        ..addAll(modules.where((module) => module.name.trim().isNotEmpty));
      _checkedModuleIds
        ..clear()
        ..addAll(
          _modules
              .where((module) => module.enabled && module.checked)
              .map((module) => module.sid),
        );
      if (localChecked != null) {
        _checkedModuleIds
          ..clear()
          ..addAll(
            _modules
                .where((module) => module.locked)
                .map((module) => module.sid),
          )
          ..addAll(localChecked);
      }
      _loading = false;
    });
  }

  void _setModuleChecked(String sid, bool value) {
    setState(() {
      if (value) {
        _checkedModuleIds.add(sid);
      } else {
        _checkedModuleIds.remove(sid);
      }
    });
  }

  Future<void> _saveModules() async {
    setState(() {
      _saving = true;
      _status = '';
    });
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode([
      for (final module in _modules.where((module) => module.enabled))
        if (!module.locked)
          {
            'sid': module.sid,
            'name': module.name,
            'desc': module.description,
            'status': 1,
            'checked': _checkedModuleIds.contains(module.sid),
          },
    ]);
    await preferences.setString(_appModuleStorageKey(widget.loginUid), encoded);
    if (!mounted) {
      return;
    }
    setState(() {
      _saving = false;
      _status = AppLocalizations.of(context).statusSaved;
    });
  }

  Future<Set<String>?> _loadLocalCheckedModuleIds() async {
    final preferences = await SharedPreferences.getInstance();
    final text = preferences.getString(_appModuleStorageKey(widget.loginUid));
    if (text == null || text.isEmpty) {
      return null;
    }
    try {
      final data = jsonDecode(text);
      if (data is! List) {
        return null;
      }
      return data
          .whereType<Map>()
          .where((item) => item['checked'] == true || item['checked'] == 1)
          .map((item) => '${item['sid']}')
          .where((sid) => sid.isNotEmpty)
          .toSet();
    } catch (_) {
      return null;
    }
  }

  String _moduleDescription(ChatAppModule module) {
    return module.description.trim().isEmpty
        ? AppLocalizations.of(context).appModulesUnavailable
        : module.description;
  }

  static String _appModuleStorageKey(String uid) => 'chatim_app_module_$uid';
}

class _ErrorLogsPage extends StatefulWidget {
  const _ErrorLogsPage();

  @override
  State<_ErrorLogsPage> createState() => _ErrorLogsPageState();
}

class _ErrorLogsPageState extends State<_ErrorLogsPage> {
  late final ChatErrorLogService _service = ChatErrorLogService();
  List<ChatErrorLogEntry> _logs = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLogs());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.generalErrorLogs,
      children: [
        MoyuSection(
          padding: EdgeInsets.zero,
          children: _loading
              ? [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 34, 16, 34),
                    child: Center(
                      child: Text(
                        t.errorLogsLoading,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ]
              : _logs.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 34, 16, 34),
                    child: Center(
                      child: Text(
                        t.errorLogsEmpty,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  for (var i = 0; i < _logs.length; i++) ...[
                    StaticActionRow(
                      icon: FIcons.fileExclamationPoint,
                      iconColor: MoyuColors.of(context).primary,
                      title: _logs[i].name,
                      subtitle: '${_logs[i].sizeLabel} · ${_logs[i].timeLabel}',
                      value: t.valueView,
                      onTap: () =>
                          pushPage(context, _ErrorLogDetailPage(log: _logs[i])),
                    ),
                    if (i != _logs.length - 1) const MoyuDivider(),
                  ],
                ],
        ),
      ],
    );
  }

  Future<void> _loadLogs() async {
    List<ChatErrorLogEntry> logs;
    try {
      logs = await _service.loadLogs().timeout(
        const Duration(milliseconds: 200),
        onTimeout: () => const [],
      );
    } catch (_) {
      logs = const [];
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _logs = logs;
      _loading = false;
    });
  }
}

class _ErrorLogDetailPage extends StatelessWidget {
  const _ErrorLogDetailPage({required this.log});

  final ChatErrorLogEntry log;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: log.name,
      children: [
        MoyuSection(
          padding: EdgeInsets.zero,
          children: [
            InfoRow(label: t.errorLogFileName, value: log.name),
            const MoyuDivider(),
            InfoRow(label: t.errorLogFileSize, value: log.sizeLabel),
            MoyuDivider(),
            InfoRow(label: t.errorLogGeneratedAt, value: log.timeLabel),
            MoyuDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.errorLogFilePath,
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    log.path,
                    style: TextStyle(
                      color: MoyuColors.of(context).textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommonOptionPage extends StatelessWidget {
  const _CommonOptionPage({
    required this.title,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      title: title,
      children: [
        MoyuSection(
          padding: EdgeInsets.zero,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              InfoRow(
                label: options[i],
                value: options[i] == value
                    ? AppLocalizations.of(context).valueSelected
                    : '',
                showChevron: false,
                onTap: () {
                  onSelected(options[i]);
                  Navigator.of(context).pop();
                },
              ),
              if (i != options.length - 1) const MoyuDivider(),
            ],
          ],
        ),
      ],
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({
    super.key,
    this.settings = const {},
    this.socialGateway,
  });

  final Map<String, Object?> settings;
  final ChatSocialGateway? socialGateway;

  @override
  State<NotificationSettingsPage> createState() =>
      NotificationSettingsPageState();
}

class NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late final Map<String, bool> _local;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _local = {
      'new_msg_notice': _readEnabled('new_msg_notice', fallback: true),
      'voice_on': _readEnabled('voice_on', fallback: true),
      'shock_on': _readEnabled('shock_on'),
      'msg_show_detail': _readEnabled('msg_show_detail', fallback: true),
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.profileRowNotifications,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.notificationReceiveNew,
              value: _local['new_msg_notice']!,
              onChanged: (v) => _toggle('new_msg_notice', v),
            ),
            const RowDivider(),
            SwitchRow(
              title: t.notificationSound,
              value: _local['voice_on']!,
              onChanged: (v) => _toggle('voice_on', v),
            ),
            const RowDivider(),
            SwitchRow(
              title: t.notificationVibration,
              value: _local['shock_on']!,
              onChanged: (v) => _toggle('shock_on', v),
            ),
            const RowDivider(),
            SwitchRow(
              title: t.notificationShowDetails,
              value: _local['msg_show_detail']!,
              onChanged: (v) => _toggle('msg_show_detail', v),
            ),
          ],
        ),
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.notificationSystem,
              value: t.settingsGoToSystem,
              valueMuted: true,
              onTap: () => unawaited(_openSystemNotificationSettings()),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.notificationCalls,
              value: t.settingsGoToSystem,
              valueMuted: true,
              onTap: () => unawaited(_openSystemNotificationSettings()),
            ),
          ],
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Text(
              _status,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openSystemNotificationSettings() async {
    await launchUrl(
      Uri.parse('app-settings:'),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _toggle(String key, bool value) async {
    final prev = _local[key]!;
    setState(() {
      _local[key] = value;
      _status = '';
    });
    try {
      await persistUserSetting(
        socialGateway: widget.socialGateway,
        key: key,
        value: value,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _local[key] = prev;
        _status = AppLocalizations.of(context).settingsSaveFailedRetry;
      });
    }
  }

  bool _readEnabled(String key, {bool fallback = false}) =>
      readPersistedSetting(key, widget.settings, fallback: fallback);
}

const _flutterAppVersion = '1.0.0';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.profileRowAbout(AppBrand.displayName),
      children: [
        MoyuSection(
          padding: const EdgeInsets.all(22),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/icons/foxtalk-app-icon-01.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  semanticLabel: t.aboutAppIconSemantic(AppBrand.displayName),
                ),
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                AppBrand.displayName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Text(
                '${AppBrand.displayName} · v$_flutterAppVersion',
                style: TextStyle(color: MoyuColors.of(context).textTertiary),
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                t.aboutCopyright(AppBrand.displayName),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MoyuColors.of(context).textTertiary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: AppLocalizations.of(context).onboardingMenuTitle,
              showChevron: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (routeContext) => OnboardingScreen(
                      onComplete: () => Navigator.of(routeContext).pop(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

String _currentAppVersionOs() {
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => 'iOS',
    TargetPlatform.android => 'android',
    TargetPlatform.macOS => 'macOS',
    TargetPlatform.windows => 'windows',
    TargetPlatform.linux => 'linux',
    TargetPlatform.fuchsia => 'android',
  };
}

class PolicyPage extends StatelessWidget {
  const PolicyPage({
    super.key,
    required this.title,
    required this.body,
    required this.url,
  });

  final String title;
  final String body;
  final String url;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      title: title,
      children: [
        MoyuSection(
          padding: EdgeInsets.zero,
          children: [
            InfoRow(
              label: AppLocalizations.of(context).policyWebUrl,
              value: url,
              onTap: () => unawaited(_openUrl()),
            ),
          ],
        ),
        MoyuSection(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              body,
              style: TextStyle(
                color: MoyuColors.of(context).textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openUrl() async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class AppearancePage extends StatefulWidget {
  const AppearancePage({
    super.key,
    required this.config,
    required this.loginUid,
    this.socialGateway,
  });

  final AppConfig config;
  final String loginUid;
  final ChatSocialGateway? socialGateway;

  @override
  State<AppearancePage> createState() => AppearancePageState();
}

class AppearancePageState extends State<AppearancePage> {
  /// 拷贝自 CommonSettingsPage._openOptionPage — picker 页 push helper.
  /// 不抽到 top-level 因为这个 widget 跟 CommonSettingsPage 共用 inline
  /// 模式, 拷贝 6 行比抽 helper class 简单.
  void _openOptionPage({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    pushPage(
      context,
      _CommonOptionPage(
        title: title,
        value: value,
        options: options,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final fontSizeLabel = <String, String>{
      'small': t.fontSizeSmall,
      'standard': t.fontSizeStandard,
      'large': t.fontSizeLarge,
      'extra_large': t.fontSizeExtraLarge,
    };
    final darkModeLabel = <String, String>{
      'system': t.darkModeSystem,
      'light': t.darkModeLight,
      'dark': t.darkModeDark,
    };
    final darkModeOrder = const ['system', 'light', 'dark'];
    return DetailScaffold(
      title: t.appearanceTitle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            Builder(
              builder: (rowContext) {
                final fontCtrl = FontScaleController.of(rowContext);
                return PlainSettingRow(
                  title: t.generalFontSize,
                  value: fontSizeLabel[fontCtrl.current] ?? t.fontSizeStandard,
                  onTap: () => pushPage(context, const _FontScalePage()),
                );
              },
            ),
            const RowDivider(),
            Builder(
              builder: (rowContext) {
                final themeCtrl = ThemeModeController.of(rowContext);
                return PlainSettingRow(
                  title: t.generalDarkMode,
                  value: darkModeLabel[themeCtrl.current] ?? t.darkModeSystem,
                  onTap: () => _openOptionPage(
                    title: t.generalDarkMode,
                    value: darkModeLabel[themeCtrl.current] ?? t.darkModeSystem,
                    options: [for (final k in darkModeOrder) darkModeLabel[k]!],
                    onSelected: (picked) {
                      for (final k in darkModeOrder) {
                        if (darkModeLabel[k] == picked) {
                          themeCtrl.change(k);
                          break;
                        }
                      }
                    },
                  ),
                );
              },
            ),
            const RowDivider(),
            Builder(
              builder: (rowContext) {
                final tabBarStyleCtrl = TabBarStyleController.of(rowContext);
                return PlainSettingRow(
                  title: t.appearanceTabBarStyle,
                  value: _tabBarStyleValue(t, tabBarStyleCtrl.current),
                  showChevron: true,
                  onTap: () =>
                      pushPage(context, const _BottomNavigationSettingsPage()),
                );
              },
            ),
          ],
        ),
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.generalChatBackground,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ChatBackgroundsPage(
                  config: widget.config,
                  loginUid: widget.loginUid,
                  socialGateway: widget.socialGateway,
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.appearanceAppIcon,
              showChevron: true,
              onTap: () => pushPage(context, const AppIconSettingsPage()),
            ),
            const RowDivider(),
            Builder(
              builder: (rowContext) {
                final colorCtrl = BubbleColorController.of(rowContext);
                return PlainSettingRow(
                  title: t.appearanceChatColor,
                  value: _bubbleColorLabel(t, colorCtrl.current),
                  onTap: () => pushPage(context, const _BubbleColorPage()),
                );
              },
            ),
            const RowDivider(),
            Builder(
              builder: (rowContext) {
                final radiusCtrl = BubbleRadiusController.of(rowContext);
                return PlainSettingRow(
                  title: t.appearanceBubbleRadius,
                  value: '${radiusCtrl.current.toStringAsFixed(0)} pt',
                  onTap: () => pushPage(context, const _BubbleRadiusPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomNavigationSettingsPage extends StatelessWidget {
  const _BottomNavigationSettingsPage();

  void _openOptionPage(
    BuildContext context, {
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    pushPage(
      context,
      _CommonOptionPage(
        title: title,
        value: value,
        options: options,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tabBarStyleLabel = _tabBarStyleLabels(t);
    return DetailScaffold(
      title: t.appearanceTabBarStyle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            Builder(
              builder: (rowContext) {
                final tabBarStyleCtrl = TabBarStyleController.of(rowContext);
                return PlainSettingRow(
                  title: t.appearanceTabBarStyleMode,
                  value: _tabBarStyleValue(t, tabBarStyleCtrl.current),
                  showChevron: true,
                  onTap: () => _openOptionPage(
                    context,
                    title: t.appearanceTabBarStyleMode,
                    value: _tabBarStyleValue(t, tabBarStyleCtrl.current),
                    options: [
                      for (final key in TabBarStyleStore.orderedKeys)
                        tabBarStyleLabel[key]!,
                    ],
                    onSelected: (picked) {
                      for (final key in TabBarStyleStore.orderedKeys) {
                        if (tabBarStyleLabel[key] == picked) {
                          tabBarStyleCtrl.change(key);
                          break;
                        }
                      }
                    },
                  ),
                );
              },
            ),
            const RowDivider(),
            Builder(
              builder: (rowContext) {
                final tabBarStyleCtrl = TabBarStyleController.of(rowContext);
                return SwitchRow(
                  title: t.appearanceDockFollowsChatColor,
                  value: tabBarStyleCtrl.dockFollowsChatColor,
                  onChanged: (enabled) => unawaited(
                    tabBarStyleCtrl.changeDockFollowsChatColor(enabled),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

Map<String, String> _tabBarStyleLabels(AppLocalizations t) => {
  TabBarStyleStore.glassDock: t.appearanceTabBarStyleGlassDock,
  TabBarStyleStore.classic: t.appearanceTabBarStyleClassic,
};

String _tabBarStyleValue(AppLocalizations t, String key) =>
    _tabBarStyleLabels(t)[key] ?? t.appearanceTabBarStyleGlassDock;

/// 信息框圆角设置页 — Telegram「外观 → 信息框圆角」同款 layout:
///   * 满屏 chat 预览 (4 条假气泡 用当前 _localRadius 渲染)
///   * 底部固定 panel: Slider + 取消/设置 双按钮
///   * 取消 = pop 不保存 / 设置 = controller.change 持久化 + pop (用户可悔)
class _BubbleRadiusPage extends StatefulWidget {
  const _BubbleRadiusPage();

  @override
  State<_BubbleRadiusPage> createState() => _BubbleRadiusPageState();
}

class _BubbleRadiusPageState extends State<_BubbleRadiusPage> {
  double? _localRadius;

  @override
  Widget build(BuildContext context) {
    final controller = BubbleRadiusController.of(context);
    _localRadius ??= controller.current;
    final r = _localRadius!;
    // 预览跟用户当前字号档位 + 1.14 chatScale 对齐, 跟 _FontScalePage 同款.
    // 之前 hardcode 1.0 → 在 large 档位用户看圆角预览还是 standard 视觉.
    final scale =
        FontScaleStore.scaleFor(FontScaleController.of(context).current) * 1.14;
    return _AppearancePreviewScaffold(
      title: AppLocalizations.of(context).appearanceBubbleRadius,
      previewRadius: r,
      previewScale: scale,
      controlBuilder: (ctx) => _RadiusControl(
        value: r,
        onChanged: (v) => setState(() => _localRadius = v),
      ),
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        controller.change(r);
        Navigator.of(context).pop();
      },
    );
  }
}

/// 字号设置页 — 跟 _BubbleRadiusPage 同款 Telegram layout, Slider 4 档
/// 离散 (small / standard / large / extra_large). 预览 chat 内文字大小
/// 跟当前 _localScale 联动让用户拖 Slider 时立刻看到效果, 设置才保存.
/// 聊天颜色设置页 — 跟 _FontScalePage / _BubbleRadiusPage 同款 Telegram
/// layout. swatch 6 预设 (ink/紫/绿/蓝/橙/粉), tap swatch 改本地 _localKey
/// 预览实时跟动, 取消不保存 / 设置持久化全局生效.
/// 关键技巧: 内层包一层 BubbleColorController(current: _localKey, change: dummy),
/// 这样 _AppearancePreviewStrip 内 MoyuInk.bubbleSendGradientOf(context) 读
/// 到 inner controller 的 _localKey 而不是父级 controller, 预览跟着 swatch
/// 选择变. 点设置时调外层 controller.change 持久化.
class _BubbleColorPage extends StatefulWidget {
  const _BubbleColorPage();

  @override
  State<_BubbleColorPage> createState() => _BubbleColorPageState();
}

class _BubbleColorPageState extends State<_BubbleColorPage> {
  String? _localKey;

  @override
  Widget build(BuildContext context) {
    final outerController = BubbleColorController.of(context);
    _localKey ??= outerController.current;
    final key = _localKey!;
    return BubbleColorController(
      current: key,
      // dummy change: 内层 swatch 拖动改 _localKey, 不通过 controller.change
      // (避免提前持久化). 点设置才走 outerController.change.
      change: (_) async {},
      child: _AppearancePreviewScaffold(
        title: AppLocalizations.of(context).appearanceChatColor,
        previewRadius: BubbleRadiusController.of(context).current,
        // 跟 _FontScalePage / _BubbleRadiusPage 同款 — 预览乘 chatScale 1.14
        // + 用户当前字号档位, 跟切回聊天看到的视觉一致.
        previewScale:
            FontScaleStore.scaleFor(FontScaleController.of(context).current) *
            1.14,
        controlBuilder: (ctx) => _BubbleColorSwatchRow(
          current: key,
          onChanged: (k) => setState(() => _localKey = k),
        ),
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () {
          outerController.change(key);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

String _bubbleColorLabel(AppLocalizations t, String key) => switch (key) {
  BubbleColorStore.defaultPreference => t.appearanceBubbleColorInk,
  'purple' => t.appearanceBubbleColorPurple,
  'green' => t.appearanceBubbleColorGreen,
  'blue' => t.appearanceBubbleColorBlue,
  'orange' => t.appearanceBubbleColorOrange,
  'pink' => t.appearanceBubbleColorPink,
  _ => t.appearanceBubbleColorInk,
};

/// 6 swatch 横排 — ink/紫/绿/蓝/橙/粉, 当前选中圆圈外加 2pt 圆环.
class _BubbleColorSwatchRow extends StatelessWidget {
  const _BubbleColorSwatchRow({required this.current, required this.onChanged});

  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final key in BubbleColorStore.orderedKeys)
            _SwatchDot(
              color: BubbleColorStore.colorsFor(key, brightness).bg1,
              selected: key == current,
              onTap: () => onChanged(key),
            ),
        ],
      ),
    );
  }
}

class _SwatchDot extends StatelessWidget {
  const _SwatchDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // selected 时外圈描边 (用 line 色), 非 selected 透明.
          border: Border.all(
            color: selected
                ? MoyuColors.of(context).primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _FontScalePage extends StatefulWidget {
  const _FontScalePage();

  @override
  State<_FontScalePage> createState() => _FontScalePageState();
}

class _FontScalePageState extends State<_FontScalePage> {
  /// canonical key — small / standard / large / extra_large.
  /// 拖 Slider 改这个, 预览内 Text 用 TextScaler.linear(scale) 缩放.
  String? _localKey;

  static const _order = ['small', 'standard', 'large', 'extra_large'];

  int _indexOf(String key) => _order.indexOf(key).clamp(0, _order.length - 1);

  @override
  Widget build(BuildContext context) {
    final controller = FontScaleController.of(context);
    _localKey ??= controller.current;
    final key = _localKey!;
    final scale = FontScaleStore.scaleFor(key);
    return _AppearancePreviewScaffold(
      title: AppLocalizations.of(context).generalFontSize,
      // 圆角用 controller 当前值 (字号页不改圆角, 用真实当前值预览).
      previewRadius: BubbleRadiusController.of(context).current,
      // 对齐 home_shell.dart:4433 chatScale = scaleFor × 1.14:
      // 聊天页消息 ListView 外面额外包一层 MediaQuery × 1.14 让标准档
      // 也比 raw 14pt 略大. 预览不乘的话用户在这里看 standard 是 14pt,
      // 切回聊天看 standard 是 16pt, 跟用户预期不符.
      previewScale: scale * 1.14,
      controlBuilder: (ctx) => _FontScaleControl(
        index: _indexOf(key),
        max: _order.length - 1,
        onChanged: (i) => setState(() => _localKey = _order[i]),
      ),
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        controller.change(key);
        Navigator.of(context).pop();
      },
    );
  }
}

/// 共享 layout for 外观设置 sub-page: 满屏预览 chat + 底部 control panel +
/// 取消 / 设置 双按钮. 字号 / 圆角两页都用.
class _AppearancePreviewScaffold extends StatelessWidget {
  const _AppearancePreviewScaffold({
    required this.title,
    required this.previewRadius,
    required this.previewScale,
    required this.controlBuilder,
    required this.onCancel,
    required this.onConfirm,
  });

  final String title;

  /// 预览气泡当前圆角值 (圆角页跟着 Slider 变, 字号页固定 controller 当前).
  final double previewRadius;

  /// 预览文字当前 textScaler 值 (字号页跟着 Slider 变, 圆角页固定 1.0).
  final double previewScale;

  /// 底部 Slider 控件 (圆角页 Slider 4-24, 字号页 Slider 0-3 离散).
  final WidgetBuilder controlBuilder;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Material(
      color: Colors.transparent,
      child: Container(
        color: MoyuColors.of(context).backgroundSoft,
        child: Stack(
          children: [
            // 1) 预览区 — 撑满 minus top header height minus bottom panel.
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  top: topInset + 56, // header
                  bottom: 200 + bottomInset, // control panel + buttons
                ),
                child: _AppearancePreviewStrip(
                  radius: previewRadius,
                  textScale: previewScale,
                ),
              ),
            ),
            // 2) 顶部 header (返回 + 标题). 简化版 MoyuGlass header.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MoyuGlass(
                borderRadius: BorderRadius.zero,
                showHairline: false,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 56,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: MoyuRoundIconButton(
                              icon: moyuBackChevronIcon(context),
                              tooltip: AppLocalizations.of(context).actionBack,
                              onPressed: onCancel,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MoyuColors.of(context).textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 3) 底部 control panel (Slider + 取消/设置).
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MoyuGlass(
                borderRadius: BorderRadius.zero,
                showHairline: false,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controlBuilder(context),
                        const SizedBox(height: 12),
                        // 双按钮 row: 取消 (text button) + 设置 (text button)
                        // 中间 1px divider 切两半.
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              Expanded(
                                child: FTappable(
                                  onPress: onCancel,
                                  behavior: HitTestBehavior.opaque,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).actionCancel,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MoyuColors.of(
                                          context,
                                        ).textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 0.5,
                                color: MoyuColors.of(context).line,
                              ),
                              Expanded(
                                child: FTappable(
                                  onPress: onConfirm,
                                  behavior: HitTestBehavior.opaque,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      ).valueConfigure,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: MoyuColors.of(context).primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 圆角 Slider 控件 — 4-24, divisions 20.
class _RadiusControl extends StatelessWidget {
  const _RadiusControl({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context).appearanceSquare,
            style: TextStyle(
              fontSize: 13,
              color: MoyuColors.of(context).textTertiary,
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: BubbleRadiusStore.minRadius,
              max: BubbleRadiusStore.maxRadius,
              divisions:
                  (BubbleRadiusStore.maxRadius - BubbleRadiusStore.minRadius)
                      .toInt(),
              activeColor: MoyuColors.of(context).primary,
              onChanged: onChanged,
            ),
          ),
          Text(
            AppLocalizations.of(context).appearanceRound,
            style: TextStyle(
              fontSize: 13,
              color: MoyuColors.of(context).textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 字号 Slider 控件 — 离散 4 档.
class _FontScaleControl extends StatelessWidget {
  const _FontScaleControl({
    required this.index,
    required this.max,
    required this.onChanged,
  });

  final int index;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            'A',
            style: TextStyle(
              fontSize: 12,
              color: MoyuColors.of(context).textTertiary,
            ),
          ),
          Expanded(
            child: Slider(
              value: index.toDouble(),
              min: 0,
              max: max.toDouble(),
              divisions: max,
              activeColor: MoyuColors.of(context).primary,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          Text(
            'A',
            style: TextStyle(
              fontSize: 20,
              color: MoyuColors.of(context).textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 满屏预览 chat strip — 4 条假气泡覆盖常见场景:
///   1) receive 短文本 with quote (引用前一条)
///   2) send 文本
///   3) receive 文本 (mention 引用 send)
///   4) send 长文本
/// 用 [radius] 控制气泡圆角, [textScale] 控制字体大小, 让预览实时跟动.
class _AppearancePreviewStrip extends StatelessWidget {
  const _AppearancePreviewStrip({
    required this.radius,
    required this.textScale,
  });

  final double radius;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        children: [
          _PreviewBubble(
            radius: radius,
            isMine: false,
            text: AppLocalizations.of(context).appearancePreviewOne,
          ),
          const SizedBox(height: 6),
          _PreviewBubble(
            radius: radius,
            isMine: true,
            text: AppLocalizations.of(context).appearancePreviewTwo,
          ),
          const SizedBox(height: 6),
          _PreviewBubble(
            radius: radius,
            isMine: false,
            quoteName: AppLocalizations.of(context).profileDefaultName,
            quoteText: AppLocalizations.of(context).appearancePreviewTwo,
            text: AppLocalizations.of(context).appearancePreviewThree,
          ),
          const SizedBox(height: 6),
          _PreviewBubble(
            radius: radius,
            isMine: true,
            text: AppLocalizations.of(context).appearancePreviewFour,
          ),
        ],
      ),
    );
  }
}

/// 单条预览气泡 — 支持可选 quote 引用块.
class _PreviewBubble extends StatelessWidget {
  const _PreviewBubble({
    required this.radius,
    required this.isMine,
    required this.text,
    this.quoteName,
    this.quoteText,
  });

  final double radius;
  final bool isMine;
  final String text;
  final String? quoteName;
  final String? quoteText;

  @override
  Widget build(BuildContext context) {
    final tail = BubbleRadiusStore.tailRadiusFor(radius);
    final shape = BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(isMine ? radius : tail),
      bottomRight: Radius.circular(isMine ? tail : radius),
    );
    final fg = isMine
        ? MoyuColors.of(context).bubbleSendForeground
        : MoyuColors.of(context).textPrimary;
    final hasQuote = quoteName != null && quoteText != null;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
            gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
            borderRadius: shape,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasQuote) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: fg.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quoteName!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: fg.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        quoteText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: fg.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                text,
                style: TextStyle(fontSize: 14, height: 1.45, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
