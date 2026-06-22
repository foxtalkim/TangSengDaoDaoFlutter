import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';

class GroupInviteApprovalBubble extends StatelessWidget {
  const GroupInviteApprovalBubble({
    super.key,
    required this.text,
    required this.onConfirm,
    this.onLongPress,
  });

  final String text;
  final VoidCallback onConfirm;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final colors = MoyuColors.of(context);
    final displayText = text.isEmpty ? t.chatGroupInviteApprovalBody : text;
    return FTappable(
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Center(
          key: const ValueKey('moyu.groupInviteApproval.row'),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Row(
              key: const ValueKey('moyu.groupInviteApproval.content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.backgroundSoft,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    FIcons.userRoundPlus,
                    size: 14,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.backgroundSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      displayText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                FTappable(
                  onPress: onConfirm,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Text(
                      t.chatGroupInviteGoConfirm,
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
