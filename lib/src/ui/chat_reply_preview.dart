import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

class ReplyPreview extends StatelessWidget {
  const ReplyPreview({
    super.key,
    required this.senderName,
    required this.text,
    required this.onClose,
    this.avatarUrl,
    this.avatarLabel,
    this.avatarColors,
  });

  final String senderName;
  final String text;
  final VoidCallback onClose;

  /// Optional avatar metadata mirroring native iOS `WKReplyView`'s 26pt sender
  /// avatar slot. When absent, the preview falls back to the previous text-only
  /// layout.
  final String? avatarUrl;
  final String? avatarLabel;
  final List<Color>? avatarColors;

  static const double _avatarSize = 26;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).backgroundSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 28,
            decoration: BoxDecoration(
              color: MoyuColors.of(context).primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          if (avatarLabel != null && avatarColors != null) ...[
            const SizedBox(width: 8),
            MoyuResolvedAvatar.raw(
              label: avatarLabel!,
              size: _avatarSize,
              colors: avatarColors!,
              online: false,
              imageUrl: (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? avatarUrl
                  : null,
            ),
          ] else
            const SizedBox(width: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.replyPreviewTitle(senderName),
                  style: TextStyle(
                    color: MoyuColors.of(context).primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MoyuColors.of(context).textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          MoyuRoundIconButton(
            icon: FIcons.x,
            tooltip: t.replyPreviewCancel,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
