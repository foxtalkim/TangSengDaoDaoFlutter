import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'moyu_directionality.dart';
import 'moyu_theme.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.showChevron = true,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: MoyuColors.of(context).background,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.08,
              color: MoyuColors.of(context).textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: MoyuColors.of(context).textTertiary,
                fontSize: 14,
              ),
            ),
          ),
          if (onTap != null && showChevron) ...[
            const SizedBox(width: 4),
            Icon(
              moyuForwardChevronIcon(context),
              size: 16,
              color: MoyuColors.of(context).textTertiary,
            ),
          ],
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

class PlainSettingRow extends StatelessWidget {
  const PlainSettingRow({
    super.key,
    required this.title,
    this.leading,
    this.value = '',
    this.valueMuted = false,
    this.trailing,
    this.showChevron = false,
    this.danger = false,
    this.center = false,
    this.onTap,
  });

  final String title;
  final Widget? leading;
  final String value;
  final bool valueMuted;
  final Widget? trailing;
  final bool showChevron;
  final bool danger;
  final bool center;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      textAlign: center ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.08,
        color: danger
            ? MoyuColors.of(context).red
            : MoyuColors.of(context).textPrimary,
      ),
    );
    final Widget content;
    if (center) {
      content = Center(child: titleWidget);
    } else {
      content = Row(
        children: [
          if (leading != null) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: IconTheme(
                data: IconThemeData(
                  color: MoyuColors.of(context).textSecondary,
                  size: 20,
                ),
                child: leading!,
              ),
            ),
            const SizedBox(width: 14),
          ],
          titleWidget,
          const SizedBox(width: 12),
          Expanded(
            child: value.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: valueMuted
                          ? MoyuColors.of(context).textTertiary
                          : MoyuColors.of(context).textSecondary,
                      fontSize: 14,
                    ),
                  ),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
          if (showChevron) ...[
            const SizedBox(width: 4),
            Icon(
              moyuForwardChevronIcon(context),
              size: 16,
              color: MoyuColors.of(context).textTertiary,
            ),
          ],
        ],
      );
    }
    final row = Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: MoyuColors.of(context).background,
      child: content,
    );
    if (onTap == null) return row;
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}
