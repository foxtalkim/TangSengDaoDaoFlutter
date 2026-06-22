import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../social/social_service.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

/// Multi-select forward mode picked from the bottom sheet.
/// `individual` re-uses the per-content-type clone, while `merge` packs the
/// selected messages into one merge-forward content.
enum ForwardMode { individual, merge }

bool canMultiSelectMessage({
  required bool revoked,
  required bool isSystemMessage,
  required String selectionKey,
}) {
  if (revoked) return false;
  if (isSystemMessage) return false;
  return selectionKey.isNotEmpty;
}

/// Floating dropdown shown above the composer when the user is typing an
/// @mention in a group chat. Mirrors native iOS WKUserHandleVC inline member
/// list.
class MentionPicker extends StatelessWidget {
  const MentionPicker({
    super.key,
    required this.members,
    required this.onSelect,
    this.config,
  });

  final List<ChatContact> members;
  final void Function(ChatContact) onSelect;
  final AppConfig? config;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).background,
        border: Border(
          top: BorderSide(color: MoyuColors.of(context).line, width: 0.5),
          bottom: BorderSide(color: MoyuColors.of(context).line, width: 0.5),
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 4),
        shrinkWrap: true,
        itemCount: members.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 0.5,
          color: MoyuColors.of(context).line,
          indent: 56,
        ),
        itemBuilder: (_, index) {
          final member = members[index];
          final displayName = member.displayName;
          final hash = member.uid.codeUnits.fold<int>(0, (a, b) => a + b);
          return FTappable(
            onPress: () => onSelect(member),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  MoyuResolvedAvatar.user(
                    config: config,
                    uid: member.uid,
                    name: displayName,
                    imageUrl: member.avatar,
                    size: 28,
                    colors: MoyuAvatarGradients.at(hash),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 14,
                        color: MoyuColors.of(context).textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Slim banner above the message list while in multi-select mode. Shows
/// "已选 N 项" and a 取消 button so the user can exit the mode without touching
/// the composer / action bar. Mirrors native iOS WKMessageActionToolbarView
/// header.
class MultiSelectTopBar extends StatelessWidget {
  const MultiSelectTopBar({
    super.key,
    required this.count,
    required this.onCancel,
  });

  final int count;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).backgroundSoft,
        border: Border(
          bottom: BorderSide(color: MoyuColors.of(context).line, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            t.chatSelectedCount(count),
            style: TextStyle(
              fontSize: 13,
              color: MoyuColors.of(context).textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onCancel,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                t.actionCancel,
                style: TextStyle(
                  fontSize: 13,
                  color: MoyuColors.of(context).blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom action bar shown in place of the composer while in multi-select mode.
class MultiSelectActionBar extends StatelessWidget {
  const MultiSelectActionBar({
    super.key,
    required this.selectedCount,
    required this.onDelete,
    required this.onForward,
    this.onFavorite,
  });

  final int selectedCount;
  final VoidCallback? onDelete;
  final VoidCallback? onForward;

  /// 收藏按钮回调 — 对齐 iOS WKMultiplePanel 第三个 button. 之前 toolbar 只有
  /// 转发 + 删除, 用户多选完没办法批量收藏, 要逐条进长按菜单点收藏.
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final disabled = selectedCount == 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).backgroundSoft,
        border: Border(
          top: BorderSide(color: MoyuColors.of(context).line, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MultiSelectActionButton(
            icon: Icons.share_outlined,
            label: t.chatActionForward,
            disabled: disabled,
            onTap: onForward,
          ),
          if (onFavorite != null)
            _MultiSelectActionButton(
              icon: Icons.star_outline,
              label: t.chatActionFavorite,
              disabled: disabled,
              onTap: onFavorite,
            ),
          _MultiSelectActionButton(
            icon: Icons.delete_outline,
            label: t.chatActionDelete,
            disabled: disabled,
            danger: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _MultiSelectActionButton extends StatelessWidget {
  const _MultiSelectActionButton({
    required this.icon,
    required this.label,
    required this.disabled,
    this.danger = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool disabled;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = disabled
        ? MoyuColors.of(context).textTertiary
        : danger
        ? MoyuColors.of(context).red
        : MoyuColors.of(context).textPrimary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
