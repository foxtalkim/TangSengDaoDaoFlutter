import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../im/wukong_im_service.dart' show MergeForwardEntry;
import '../l10n/app_localizations.dart';
import 'chat_rich_message_bubbles.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

/// Detail page pushed from `MergeForwardBubble` — lists every embedded entry as
/// a row (sender + timestamp + payload digest). Mirrors native iOS
/// `WKMergeForwardDetailVC` minimally.
class MergeForwardDetailPage extends StatelessWidget {
  const MergeForwardDetailPage({
    super.key,
    required this.title,
    required this.entries,
  });

  final String title;
  final List<MergeForwardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: MoyuColors.of(context).background,
      appBar: AppBar(
        title: Text(title.isEmpty ? t.globalSearchMessagesSection : title),
        backgroundColor: MoyuColors.of(context).background,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: entries.length,
        separatorBuilder: (context, index) =>
            Divider(color: MoyuColors.of(context).line, height: 25),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final name = entry.fromName.trim().isEmpty
              ? entry.fromUid
              : entry.fromName.trim();
          final digest = entry.digest.trim().isNotEmpty
              ? entry.digest.trim()
              : mergeForwardDigestFromPayload(
                  entry.contentType,
                  entry.payload,
                  t,
                );
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: digest.isEmpty
                ? null
                : () => _showEntryActions(context, digest, name),
            // 修 #8: 每条记录加上下内边距 + 放宽 name→digest 间距 + 正文行高,
            // 不再挤成一坨。
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: MoyuColors.of(context).textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (entry.timestamp > 0)
                        Text(
                          _formatRelativeTimestamp(entry.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: MoyuColors.of(context).textTertiary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    digest,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: MoyuColors.of(context).textSecondary,
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

  static void _showEntryActions(
    BuildContext context,
    String digest,
    String name,
  ) {
    MoyuActionSheet.show(
      context,
      title: name,
      items: [
        MoyuActionSheetItem(
          title: AppLocalizations.of(context).chatActionCopy,
          onSelected: () async {
            await Clipboard.setData(ClipboardData(text: digest));
            if (context.mounted) {
              MoyuToast.show(
                context,
                AppLocalizations.of(context).chatNoticeCopied,
              );
            }
          },
        ),
      ],
    );
  }

  static String _formatRelativeTimestamp(int seconds) {
    final dt = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} $hh:$mm';
  }
}
