import 'package:flutter/material.dart';

import 'chat_message_status_widgets.dart';

class MediaTimeChip extends StatelessWidget {
  const MediaTimeChip({
    super.key,
    required this.timeText,
    this.isMine = false,
    this.status,
    this.readed = false,
    this.readedCount = 0,
    this.unreadCount = 0,
    this.onReceiptTap,
  });

  final String timeText;

  /// 自己发的消息且 status=='已发送' 时,时间右侧带已读回执(✓✓)。
  final bool isMine;
  final String? status;
  final bool readed;
  final int readedCount;
  final int unreadCount;
  final VoidCallback? onReceiptTap;

  @override
  Widget build(BuildContext context) {
    if (timeText.trim().isEmpty) return const SizedBox.shrink();
    final showReceipt = isMine && status == '已发送';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                height: 1.0,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            if (showReceipt) ...[
              const SizedBox(width: 4),
              SendReceiptIndicator(
                readed: readed,
                readedCount: readedCount,
                unreadCount: unreadCount,
                onTap: onReceiptTap,
                foreground: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
