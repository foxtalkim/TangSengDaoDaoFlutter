import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

void showSendFailActionSheet(
  BuildContext context, {
  VoidCallback? onRetry,
  VoidCallback? onDelete,
}) {
  final t = AppLocalizations.of(context);
  MoyuActionSheet.show(
    context,
    title: t.chatSendFailedShort,
    items: [
      MoyuActionSheetItem(
        title: t.chatResend,
        onSelected: () => onRetry?.call(),
      ),
      MoyuActionSheetItem(
        title: t.actionDelete,
        destructive: true,
        onSelected: () => onDelete?.call(),
      ),
    ],
  );
}

/// Red exclamation icon shown next to an outgoing bubble whose send failed.
class SendFailIconButton extends StatelessWidget {
  const SendFailIconButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Semantics(
      identifier: 'moyu.chat.send_fail',
      label: t.chatSendFailedShort,
      button: true,
      child: FTappable(
        onPress: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MoyuColors.of(context).red,
            shape: BoxShape.circle,
          ),
          child: Text(
            '!',
            style: TextStyle(
              color: MoyuColors.of(context).background,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

/// Indeterminate sending spinner with the same footprint as receipt status.
class SendingSpinner extends StatelessWidget {
  const SendingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Semantics(
      label: t.statusSending,
      child: SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 1.4,
          valueColor: AlwaysStoppedAnimation(
            MoyuColors.of(context).textTertiary,
          ),
        ),
      ),
    );
  }
}

class SendReceiptIndicator extends StatelessWidget {
  const SendReceiptIndicator({
    super.key,
    required this.readed,
    required this.readedCount,
    required this.unreadCount,
    this.onTap,
    this.foreground,
  });

  final bool readed;
  final int readedCount;
  final int unreadCount;
  final VoidCallback? onTap;

  /// Optional color override for the check icon + count text. Used when
  /// the indicator is rendered inside the own (mine) gradient bubble's
  /// bottom meta-row, where the default gray `textTertiary` would be
  /// low-contrast on the dark gradient — the caller passes the bubble's
  /// `bubbleSendForeground` so the ✓✓ stays visible (DESIGN §5.9.3 trap
  /// 5). Null falls back to the standalone blue/gray scheme used when
  /// the indicator sits on the chat page background.
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final total = readedCount + unreadCount;
    final bool fullyRead;
    final bool isGroup = total > 0;
    final String label;
    if (total == 0 && !readed) {
      fullyRead = false;
      label = t.statusSent;
    } else if (total == 0 && readed) {
      fullyRead = true;
      label = t.chatStatusRead;
    } else {
      fullyRead = readedCount >= total;
      label = fullyRead ? t.chatStatusRead : t.statusSent;
    }

    final override = foreground;
    final color = override != null
        ? (fullyRead ? override : override.withValues(alpha: 0.7))
        : (fullyRead
              ? MoyuColors.of(context).blue
              : MoyuColors.of(context).textTertiary);
    final body = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isGroup && !fullyRead)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              '$readedCount/$total',
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        Icon(fullyRead ? Icons.done_all : Icons.done, size: 14, color: color),
      ],
    );
    return Semantics(
      label: label,
      button: onTap != null,
      child: onTap == null
          ? body
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: body,
            ),
    );
  }
}

class SensitiveWordTipRow extends StatelessWidget {
  const SensitiveWordTipRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x1FF0A04B),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(FIcons.triangleAlert, size: 12, color: Color(0xFFC07F2C)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                height: 1.3,
                color: Color(0xFFC07F2C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateStamp extends StatelessWidget {
  const DateStamp(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: MoyuColors.of(context).textTertiary,
          ),
        ),
      ),
    );
  }
}
