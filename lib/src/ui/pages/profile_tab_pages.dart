// 我 tab (ProfilePage) + 我的邀请码。从 home_shell.dart 拆出。
import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:forui/forui.dart';

import '../../auth/auth_repository.dart' show ChatServerAppConfig;
import '../../auth/user_session.dart';
import '../../app/app_runtime.dart';
import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../im/wukong_im_service.dart' show ChatImGateway;
import '../../l10n/app_localizations.dart';
import '../../modules/feature_registry.dart' show FeatureKind;
import '../../modules/module_route.dart'
    show ModuleContactTarget, ModuleRouteContext, ModuleRouteDescriptor;
import '../../modules/module_ids.dart' show ModuleRouteIds;
import '../../social/social_service.dart'
    show ChatInviteCode, ChatSocialGateway;
import '../chat_navigation.dart';
import '../contact_list_widgets.dart' show contactChannelId;
import '../detail_scaffold.dart';
import '../models/contact_models.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_layout.dart';
import '../settings_row_widgets.dart';
import 'pickers_pages.dart';
import 'profile_detail_pages.dart';

const double kProfileHeaderAvatarSize = 80;
const double kProfileHeaderTopExtra = 48;
const double kProfileHeaderBottomPadding = 34;

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.session,
    required this.config,
    required this.onLogout,
    required this.displayName,
    required this.shortNo,
    required this.sex,
    required this.onProfileChanged,
    required this.appearancePageBuilder,
    required this.securityPrivacyPageBuilder,
    required this.notificationSettingsPageBuilder,
    required this.commonSettingsPageBuilder,
    this.contacts = const [],
    this.imGateway,
    this.socialGateway,
    this.runtime,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final UserSession session;
  final AppConfig config;
  final VoidCallback onLogout;
  final String displayName;
  final String shortNo;
  final String sex;
  final void Function({String? name, String? shortNo, String? sex})
  onProfileChanged;
  final WidgetBuilder appearancePageBuilder;
  final WidgetBuilder securityPrivacyPageBuilder;
  final WidgetBuilder notificationSettingsPageBuilder;
  final WidgetBuilder commonSettingsPageBuilder;

  /// 收藏页 → "发送给朋友" 联系人选择器需要拿到通讯录
  /// (iOS WKMessageActionManager.sendContentToFriend 同等行为)。
  final List<UiContact> contacts;
  final ChatImGateway? imGateway;
  final ChatSocialGateway? socialGateway;
  final AppRuntime? runtime;
  final ChatServerAppConfig serverAppConfig;

  Future<ModuleContactTarget?> _pickFavoriteContactTarget(
    BuildContext context,
  ) async {
    final t = AppLocalizations.of(context);
    final contact = await Navigator.of(context).push<UiContact>(
      MaterialPageRoute(
        builder: (_) => ContactCardPickerPage(
          contacts: contacts,
          title: t.favoriteSendToFriend,
          sectionTitle: t.chatRecentContactsSection,
        ),
      ),
    );
    if (contact == null) return null;
    final channelId = contactChannelId(contact);
    if (channelId.isEmpty) return null;
    return ModuleContactTarget(channelId: channelId, displayName: contact.name);
  }

  ModuleRouteDescriptor? _favoriteRoute(AppRuntime? activeRuntime) {
    if (activeRuntime == null) return null;
    for (final feature in activeRuntime.registry.enabledFeatures(
      kind: FeatureKind.route,
    )) {
      final value = feature.value;
      if (feature.id == ModuleRouteIds.favorite &&
          value is ModuleRouteDescriptor) {
        return value;
      }
    }
    return null;
  }

  void _openFavoriteRoute(BuildContext context) {
    final activeRuntime = runtime;
    final route = _favoriteRoute(activeRuntime);
    if (route == null) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      return;
    }
    pushPage(
      context,
      route.build(
        context,
        ModuleRouteContext(
          socialGateway: socialGateway,
          imGateway: imGateway,
          config: config,
          loginUid: session.uid,
          pickContactTarget: _pickFavoriteContactTarget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = AvatarResolver.user(
      config: config,
      uid: session.uid,
      imageUrl: session.avatar,
    );
    final t = AppLocalizations.of(context);
    final tabBarInset =
        kTabBarReservedHeight + MediaQuery.viewPaddingOf(context).bottom;
    // 我 tab has no title bar — the white avatar card sits flush at
    // the top with its bg extending UP through the status bar (iOS
    // WeChat 我 same pattern). Push the inner card padding-top by
    // the status bar height so avatar / name themselves stay below
    // the system icons.
    final statusBarHeight = MediaQuery.viewPaddingOf(context).top;

    return ColoredBox(
      color: MoyuColors.of(context).backgroundSoft,
      child: ListView(
        // Disable scrolling — user wants 我 tab fixed (no swipe-up).
        // ListView 保留是为不大改原结构；content 通常装得下，
        // tab bar 半透明 overlay 在底部即使内容稍微超出也只是
        // 被半透模糊覆盖，可读性可接受。
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: tabBarInset),
        children: [
          Container(
            color: MoyuColors.of(context).background,
            padding: EdgeInsets.fromLTRB(
              16,
              statusBarHeight + kProfileHeaderTopExtra,
              16,
              kProfileHeaderBottomPadding,
            ),
            child: FTappable(
              onPress: () => pushPage(
                context,
                ProfileDetailPage(
                  session: session,
                  config: config,
                  displayName: displayName,
                  shortNo: shortNo,
                  sex: sex,
                  serverAppConfig: serverAppConfig,
                  socialGateway: socialGateway,
                  onProfileChanged: onProfileChanged,
                ),
              ),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  MoyuResolvedAvatar.raw(
                    label: displayName.isEmpty
                        ? t.profileDefaultName
                        : displayName,
                    size: kProfileHeaderAvatarSize,
                    colors: [Color(0xFFFF9A8B), MoyuColors.of(context).primary],
                    imageUrl: avatarUrl,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.32,
                            color: MoyuColors.of(context).textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          t.profileMoyuIdLabel(
                            AppBrand.displayName,
                            shortNo.isEmpty ? session.uid : shortNo,
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MoyuColors.of(context).textTertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    FIcons.qrCode,
                    color: MoyuColors.of(context).textTertiary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    moyuForwardChevronIcon(context),
                    color: MoyuColors.of(context).textTertiary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          settingsBlockGap(context),
          if (_favoriteRoute(runtime) != null) ...[
            // 收藏 — 单独一组
            settingsFlatGroup(
              context,
              rows: [
                PlainSettingRow(
                  leading: const Icon(FIcons.star),
                  title: t.profileRowFavorites,
                  showChevron: true,
                  onTap: () => _openFavoriteRoute(context),
                ),
              ],
            ),
            settingsBlockGap(context),
          ],
          // 主菜单组 — 线条 icon, 无背景色块, 跟 forui 主体风格一致.
          // 颜色由 PlainSettingRow 内部 IconTheme 统一调成 textSecondary
          // (深色模式自动适配, 不再用 hardcode 渐变).
          // 退出登录 / 关于 已挪到 通用设置 里, 这里不再有.
          settingsFlatGroup(
            context,
            rows: [
              PlainSettingRow(
                leading: const Icon(FIcons.palette),
                title: t.appearanceTitle,
                showChevron: true,
                onTap: () => pushPage(context, appearancePageBuilder(context)),
              ),
              const RowDivider(),
              PlainSettingRow(
                leading: const Icon(FIcons.shield),
                title: t.profileRowSecurityPrivacy,
                showChevron: true,
                onTap: () =>
                    pushPage(context, securityPrivacyPageBuilder(context)),
              ),
              const RowDivider(),
              PlainSettingRow(
                leading: const Icon(FIcons.bell),
                title: t.profileRowNotifications,
                showChevron: true,
                onTap: () =>
                    pushPage(context, notificationSettingsPageBuilder(context)),
              ),
              if (serverAppConfig.registerInviteOn) ...[
                const RowDivider(),
                PlainSettingRow(
                  leading: const Icon(FIcons.ticket),
                  title: t.profileRowInviteCode,
                  showChevron: true,
                  onTap: () => pushPage(
                    context,
                    MyInviteCodePage(
                      session: session,
                      config: config,
                      socialGateway: socialGateway,
                    ),
                  ),
                ),
              ],
              const RowDivider(),
              PlainSettingRow(
                leading: const Icon(FIcons.settings),
                title: t.profileRowGeneral,
                showChevron: true,
                onTap: () =>
                    pushPage(context, commonSettingsPageBuilder(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // _confirmLogout 已迁移到 _CommonSettingsPageState — 退出登录入口现
  // 在 通用设置 末尾 (用户 requirement: "退出登陆样式做对齐，且这个入口
  // 应该是在通用设置里的").
}

class MyInviteCodePage extends StatefulWidget {
  const MyInviteCodePage({
    super.key,
    required this.session,
    required this.config,
    this.socialGateway,
  });

  final UserSession session;
  final AppConfig config;
  final ChatSocialGateway? socialGateway;

  @override
  State<MyInviteCodePage> createState() => _MyInviteCodePageState();
}

class _MyInviteCodePageState extends State<MyInviteCodePage> {
  ChatInviteCode _inviteCode = const ChatInviteCode(code: '');
  bool _loading = true;
  bool _toggling = false;
  _InviteStatus? _status;
  String _statusError = '';

  @override
  void initState() {
    super.initState();
    unawaited(_loadInviteCode());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final avatarUrl = AvatarResolver.user(
      config: widget.config,
      uid: widget.session.uid,
      imageUrl: widget.session.avatar,
    );
    final displayName = widget.session.name.isEmpty
        ? t.profileDefaultName
        : widget.session.name;
    final code = _inviteCode.code.isEmpty ? '-------' : _inviteCode.code;
    final enabled = _inviteCode.enabled;
    final statusText = _statusText(t);
    return DetailScaffold(
      title: t.profileRowInviteCode,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
          rows: [
            Center(
              child: MoyuResolvedAvatar.raw(
                label: displayName,
                size: 72,
                colors: [Color(0xFFFFB86C), MoyuColors.of(context).primary],
                imageUrl: avatarUrl,
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                displayName,
                style: TextStyle(
                  color: MoyuColors.of(context).textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 28),
            Center(
              child: SelectableText(
                code,
                style: TextStyle(
                  color: MoyuColors.of(context).textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FButton(
                  size: FButtonSizeVariant.sm,
                  onPress: _inviteCode.code.isEmpty ? null : _copyInviteCode,
                  child: Text(t.chatActionCopy),
                ),
                const SizedBox(width: 28),
                FButton(
                  size: FButtonSizeVariant.sm,
                  variant: FButtonVariant.outline,
                  onPress: _toggling ? null : () => unawaited(_toggleStatus()),
                  child: Text(enabled ? t.actionDisable : t.actionEnable),
                ),
              ],
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                _loading
                    ? t.profileInviteLoading
                    : enabled
                    ? t.profileInviteEnabled
                    : t.profileInviteDisabled,
                style: TextStyle(
                  color: MoyuColors.of(context).textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (statusText.isNotEmpty) ...[
              SizedBox(height: 10),
              Center(
                child: Text(
                  statusText,
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

  Future<void> _loadInviteCode() async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final inviteCode = await gateway.loadInviteCode();
      if (!mounted) {
        return;
      }
      setState(() {
        _inviteCode = inviteCode;
        _loading = false;
        _status = null;
        _statusError = '';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _status = _InviteStatus.loadFailed;
        _statusError = '$error';
      });
    }
  }

  void _copyInviteCode() {
    unawaited(Clipboard.setData(ClipboardData(text: _inviteCode.code)));
    setState(() {
      _status = _InviteStatus.copied;
      _statusError = '';
    });
  }

  Future<void> _toggleStatus() async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      return;
    }
    setState(() {
      _toggling = true;
      _status = null;
      _statusError = '';
    });
    try {
      await gateway.toggleInviteCodeStatus();
      await _loadInviteCode();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = _InviteStatus.updateFailed;
        _statusError = '$error';
      });
    } finally {
      if (mounted) {
        setState(() => _toggling = false);
      }
    }
  }

  String _statusText(AppLocalizations t) {
    return switch (_status) {
      _InviteStatus.loadFailed => t.profileInviteLoadFailed(_statusError),
      _InviteStatus.copied => t.profileInviteCopied,
      _InviteStatus.updateFailed => t.profileInviteUpdateFailed(_statusError),
      null => '',
    };
  }
}

enum _InviteStatus { loadFailed, copied, updateFailed }

// _ProfileAboutRow 已删除 — 关于入口已迁到 通用设置 (_CommonSettingsPage)
// 内, 用 PlainSettingRow 线条风格 row 渲染. 用户 requirement:
// "【关于】也是在通用里".
