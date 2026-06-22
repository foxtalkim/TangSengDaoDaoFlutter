import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';

/// Inline reply-quote header drawn inside a message bubble.
class BubbleQuote extends StatelessWidget {
  const BubbleQuote({
    super.key,
    required this.sender,
    required this.text,
    required this.isMine,
    this.revoked = false,
    this.onTap,
  });

  final String sender;
  final String text;
  final bool isMine;
  final bool revoked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final accent = isMine
        ? Colors.white.withValues(alpha: 0.85)
        : MoyuColors.of(context).primary;
    final bodyColor = isMine
        ? Colors.white.withValues(alpha: 0.78)
        : MoyuColors.of(context).textSecondary;
    final bg = isMine
        ? Colors.white.withValues(alpha: 0.14)
        : MoyuColors.of(context).backgroundSoft;
    final body = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (sender.isNotEmpty && !revoked)
                      Text(
                        sender,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: accent,
                          height: 1.25,
                          letterSpacing: -0.05,
                        ),
                      ),
                    if (text.isNotEmpty || revoked) ...[
                      if (sender.isNotEmpty && !revoked)
                        const SizedBox(height: 1),
                      Text(
                        revoked ? t.chatQuoteOriginalRevoked : text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: bodyColor,
                          height: 1.3,
                          fontStyle: revoked
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (onTap == null) return body;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: body,
    );
  }
}
