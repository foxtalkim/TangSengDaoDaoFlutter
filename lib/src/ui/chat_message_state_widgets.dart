import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';

/// Sticky banner pinned above the chat message list while a group call is in
/// progress. Hidden when there's no active room.
class GroupCallActiveBanner extends StatelessWidget {
  const GroupCallActiveBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    final t = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.12),
            border: Border(bottom: BorderSide(color: colors.line, width: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(FIcons.phone, size: 16, color: colors.background),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.chatGroupCallActive,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  t.actionJoin,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SystemMessageRow extends StatelessWidget {
  const SystemMessageRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 32),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: MoyuColors.of(context).textTertiary,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

/// Centered "你撤回了一条消息 · 重新编辑" / "<from> 撤回了一条消息" row that
/// replaces a bubble after revoke.
class RevokeRow extends StatelessWidget {
  const RevokeRow({
    super.key,
    required this.isMine,
    required this.fromName,
    required this.revokerIsSelf,
    required this.originalText,
    required this.recallable,
    this.onReedit,
  });

  final bool isMine;
  final String fromName;
  final bool revokerIsSelf;
  final String originalText;
  final bool recallable;
  final VoidCallback? onReedit;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final who = revokerIsSelf
        ? t.chatSelfName
        : (fromName.isNotEmpty ? fromName : t.chatPeerPlaceholder);
    final showReedit =
        isMine && revokerIsSelf && recallable && onReedit != null;
    final baseStyle = TextStyle(
      fontSize: 11,
      color: MoyuColors.of(context).textTertiary,
      height: 1.4,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 32),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.chatMessageRevokedBy(who), style: baseStyle),
            if (showReedit) ...[
              Text(' · ', style: baseStyle),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onReedit,
                child: Text(
                  t.chatReedit,
                  style: TextStyle(
                    fontSize: 11,
                    color: MoyuColors.of(context).blue,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
