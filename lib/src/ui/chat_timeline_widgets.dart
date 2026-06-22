import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';

/// Compact "已读 / 未读" count tile inside the readers-summary bottom sheet.
class ReadedSummaryCell extends StatelessWidget {
  const ReadedSummaryCell({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).backgroundSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: MoyuColors.of(context).textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// "以上为历史消息" divider rendered between messages from a prior session and
/// messages that arrived since.
class HistorySplitRow extends StatelessWidget {
  const HistorySplitRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: MoyuColors.of(context).line,
              thickness: 0.5,
              endIndent: 8,
            ),
          ),
          Text(
            AppLocalizations.of(context).chatHistoryAbove,
            style: TextStyle(
              fontSize: 11,
              color: MoyuColors.of(context).textTertiary,
            ),
          ),
          Expanded(
            child: Divider(
              color: MoyuColors.of(context).line,
              thickness: 0.5,
              indent: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class UnreadHistoryDivider extends StatelessWidget {
  const UnreadHistoryDivider({super.key, this.count = 0});

  final int count;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final label = count > 0
        ? t.chatUnreadNewMessages(count)
        : t.chatUnreadDivider;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: MoyuColors.of(context).line,
              thickness: 0.5,
              endIndent: 8,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: MoyuColors.of(context).textTertiary,
            ),
          ),
          Expanded(
            child: Divider(
              color: MoyuColors.of(context).line,
              thickness: 0.5,
              indent: 8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder bubble for unsupported server content types.
class UnknownContentRow extends StatelessWidget {
  const UnknownContentRow({super.key, required this.isMine, this.text});

  final bool isMine;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 120,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: MoyuColors.of(context).backgroundSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MoyuColors.of(context).line,
                  width: 0.5,
                ),
              ),
              child: Text(
                text ?? AppLocalizations.of(context).chatUnknownContentFallback,
                style: TextStyle(
                  fontSize: 12,
                  color: MoyuColors.of(context).textTertiary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder shown in place of the input bar when the channel is locked.
class ComposerLockedBanner extends StatelessWidget {
  const ComposerLockedBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 22),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).backgroundSoft,
        border: Border(
          top: BorderSide(color: MoyuColors.of(context).line, width: 0.5),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FIcons.lock,
              size: 14,
              color: MoyuColors.of(context).textTertiary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: MoyuColors.of(context).textTertiary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating "@ mention" hint shown above the unread FAB.
class MentionScrollHint extends StatelessWidget {
  const MentionScrollHint({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: MoyuColors.of(context).background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: MoyuColors.of(context).line, width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              spreadRadius: -2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.alternate_email,
              size: 14,
              color: MoyuColors.of(context).primary,
            ),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context).chatMentionSomeone,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MoyuColors.of(context).primary,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JumpToBottomButton extends StatelessWidget {
  const JumpToBottomButton({
    super.key,
    required this.unreadCount,
    required this.onTap,
  });

  final int unreadCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MoyuColors.of(context).background,
              shape: BoxShape.circle,
              border: Border.all(
                color: MoyuColors.of(context).line,
                width: 0.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_downward_rounded,
              size: 18,
              color: MoyuColors.of(context).textPrimary,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: MoyuColors.of(context).red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: TextStyle(
                      color: MoyuColors.of(context).background,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
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

class HistoryLoadingRow extends StatelessWidget {
  const HistoryLoadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.6,
            color: MoyuColors.of(context).textTertiary,
          ),
        ),
      ),
    );
  }
}
