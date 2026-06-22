// 共享 widget + 模型：scaffold / setting row / switch row / divider / section title /
// info row / contact tiles / static action row + ChatConversation / UiContact / UiGroup /
// UiFriendRequest / UiContactAction / MemberRoleBadge。
// 这些被 home_shell.dart 主体 + 各 page part-file 共用，集中放一处。
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../auth/session_store.dart';
import '../../auth/user_session.dart';
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart' show ChatSocialGateway;
import '../contact_list_widgets.dart' show StaticActionRow;
import '../models/contact_models.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';

/// Member-row variant for group admin lists (黑名单 / 退群用户 / 管理员).
/// Shows avatar + name + role-or-subtitle + optional trailing widget,
/// rendered flat (no card, white panel) so it matches `PlainSettingRow`
/// inside `settingsFlatGroup` blocks.
class GroupMemberContactTile extends StatelessWidget {
  const GroupMemberContactTile({
    super.key,
    required this.contact,
    this.trailing,
    this.subtitle,
    this.onTap,
  });

  final UiContact contact;
  final Widget? trailing;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      color: MoyuColors.of(context).background,
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          MoyuResolvedAvatar.raw(
            label: contact.avatarLabel,
            size: 42,
            colors: contact.colors,
            online: contact.online,
            imageUrl: contact.avatarPath,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w400,
                    color: MoyuColors.of(context).textPrimary,
                  ),
                ),
                if ((subtitle ?? contact.subtitle).isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle ?? contact.subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: MoyuColors.of(context).textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
    if (onTap == null) return tile;
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: tile,
    );
  }
}

/// 用户 setting 持久化 helper. 调 gateway PUT /user/my/setting + 写回
/// `UserSession.current.settings` (全局 source of truth) + `SessionStore.save`
/// 持久化到 SharedPreferences. 调用方 setState 乐观更新 _local 后 await 这个;
/// 抛错由调用方决定回滚.
/// 修复高频踩坑「假开关 / 切完退出再进 page 失效」: 之前所有 _toggle 只更新
/// 子 widget 局部 _local, 没回写 source of truth, pop 再进 widget.settings
/// 还是 stale → 开关弹回。
Future<void> persistUserSetting({
  required ChatSocialGateway? socialGateway,
  required String key,
  required bool value,
}) async {
  await socialGateway?.updateCurrentUserSetting(key: key, value: value ? 1 : 0);
  final current = UserSession.current;
  if (current != null) {
    final nextSettings = <String, Object?>{
      ...current.settings,
      key: value ? 1 : 0,
    };
    final updated = current.copyWith(settings: nextSettings);
    UserSession.current = updated;
    await SessionStore.save(updated);
  }
}

/// 读 user setting bool 值. 优先 UserSession.current.settings (上次
/// persistUserSetting 写回 + persisted), fallback 到传入的 widgetSettings
/// (父 widget 传的初始 snapshot). 这样 pop 再进 page 不会回弹到 stale 值.
bool readPersistedSetting(
  String key,
  Map<String, Object?> widgetSettings, {
  bool fallback = false,
}) {
  final session = UserSession.current;
  final source = (session != null && session.settings.containsKey(key))
      ? session.settings
      : widgetSettings;
  final value = source[key];
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is num) return value.toInt() == 1;
  final text = value.toString().trim().toLowerCase();
  return text == '1' || text == 'true';
}

class SwitchRow extends StatefulWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<SwitchRow> createState() => _SwitchRowState();
}

class _SwitchRowState extends State<SwitchRow> {
  late bool _value = widget.value;

  @override
  void didUpdateWidget(covariant SwitchRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Match `PlainSettingRow` typography (regular weight, 15.5px,
    // -0.08 letter-spacing) and edge padding so toggle rows visually
    // line up with navigation rows on the same settings page —
    // mixing w700 toggles next to w400 nav rows is what made the
    // page read as "some lines bolded, some not".
    final row = Container(
      constraints: BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.08,
                color: MoyuColors.of(context).textPrimary,
              ),
            ),
          ),
          FSwitch(value: _value, onChange: _changeValue),
        ],
      ),
    );

    return FTappable(
      onPress: () => _changeValue(!_value),
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }

  void _changeValue(bool value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }
}

class SelectableContactRow extends StatelessWidget {
  const SelectableContactRow({
    super.key,
    required this.contact,
    required this.selected,
    required this.onChanged,
  });

  final UiContact contact;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FTappable(
      onPress: () => onChanged(!selected),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(
              selected ? FIcons.circleCheck : FIcons.circle,
              color: selected
                  ? MoyuColors.of(context).primary
                  : MoyuColors.of(context).textTertiary,
            ),
            const SizedBox(width: 12),
            MoyuResolvedAvatar.raw(
              label: contact.avatarLabel,
              size: 42,
              colors: contact.colors,
              online: contact.online,
              imageUrl: contact.avatarPath,
            ),
            SizedBox(width: 12),
            Text(
              contact.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MoyuColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  const ActionTile({super.key, required this.action, this.onTap});

  final UiContactAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return StaticActionRow(
      icon: action.icon,
      iconColor: action.color,
      iconColors: action.colors,
      title: action.title,
      subtitle: action.subtitle,
      badge: action.badge,
      onTap: onTap,
    );
  }
}

class MemberRoleBadge extends StatelessWidget {
  const MemberRoleBadge({super.key, required this.role});

  /// Server-side role values (see `modules/group/const.go`):
  ///   0 = MemberRoleCommon  — no badge
  ///   1 = MemberRoleCreator — red pill 「群主」
  ///   2 = MemberRoleManager — blue pill 「管理员」
  /// Previous implementation had these inverted (`role >= 2` was treated
  /// as owner), which mislabelled every admin as the group owner.
  final int role;

  @override
  Widget build(BuildContext context) {
    final isCreator = role == 1;
    final color = isCreator
        ? const Color(0xFFFFA000)
        : MoyuColors.of(context).primary;
    final t = AppLocalizations.of(context);
    final label = isCreator ? t.groupOwnerRole : t.groupAdminRole;
    return Semantics(
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 30, minHeight: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MoyuColors.of(context).background,
            borderRadius: BorderRadius.circular(7.5),
            border: Border.all(color: MoyuColors.of(context).line, width: 0.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
