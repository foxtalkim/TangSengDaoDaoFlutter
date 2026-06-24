import 'package:flutter/material.dart';

import '../chat/chat_message.dart';
import '../l10n/app_localizations.dart';
import '../settings/bubble_radius_controller.dart';
import '../settings/bubble_radius_store.dart';
import 'chat_message_status_widgets.dart';
import 'chat_peer_frame.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

/// RTC call bubble (9989-9999). Looks like a regular bubble but with a
/// phone icon prefix and the call status / duration text. Aligns left for
/// inbound calls and right for outbound, mirroring native WKMessageCell.
class CallBubble extends StatelessWidget {
  const CallBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.onTap,
    this.onLongPress,
    this.onLongPressAt,
    this.hasAvatarSlot = false,
    this.showAvatar = false,
    this.avatarLabel = '',
    this.avatarUrl = '',
    this.avatarColors = const [],
    this.senderName = '',
    this.status,
    this.readed = false,
    this.readedCount = 0,
    this.unreadCount = 0,
    this.onReceiptTap,
    this.onRetry,
    this.onDelete,
    this.timeText = '',
  });

  final ChatMessage message;
  final bool isMine;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(Offset globalPosition)? onLongPressAt;

  /// 群聊 peer 时占位 32x32 avatar slot, 让通话气泡跟其他气泡左对齐.
  final bool hasAvatarSlot;

  /// 是否真画 avatar. 配 hasAvatarSlot=true 一起用, visible 时显头像,
  /// 隐藏时占位不画.
  final bool showAvatar;
  final String avatarLabel;
  final String avatarUrl;
  final List<Color> avatarColors;

  /// 群聊 streak start 时显发送者名字, 跟普通气泡同款 14pt.
  final String senderName;
  final String? status;
  final bool readed;
  final int readedCount;
  final int unreadCount;
  final VoidCallback? onReceiptTap;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    final fg = isMine
        ? MoyuInk.bubbleSendForegroundOf(context)
        : MoyuColors.of(context).textPrimary;
    final IconData icon = message.callType == 1 ? Icons.videocam : Icons.phone;
    final bubble = Container(
      margin: EdgeInsets.only(left: isMine ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
        gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
        borderRadius: _callBubbleBorderRadius(context, isMine: isMine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.text.isEmpty
                ? AppLocalizations.of(context).callMessage
                : message.text,
            style: TextStyle(fontSize: 14, height: 1.45, color: fg),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: fg),
          // 通话气泡一行小, time 走 inline (跟在图标后), 不叠 overlay 压图标。
          // 弱化色, 对齐文本气泡 inline time + Telegram 通话记录。
          if (timeText.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              timeText,
              style: TextStyle(fontSize: 11, color: fg.withValues(alpha: 0.6)),
            ),
          ],
        ],
      ),
    );

    Widget? leadingStatus;
    if (isMine) {
      if (status == '发送失败') {
        leadingStatus = SendFailIconButton(
          onTap: () => showSendFailActionSheet(
            context,
            onRetry: onRetry,
            onDelete: onDelete,
          ),
        );
      } else if (status == '发送中') {
        leadingStatus = const SendingSpinner();
      } else if (status == '已发送') {
        leadingStatus = SendReceiptIndicator(
          readed: readed,
          readedCount: readedCount,
          unreadCount: unreadCount,
          onTap: onReceiptTap,
        );
      }
    }

    final interactiveBubble = GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: onTap,
      onLongPress: onLongPressAt == null ? onLongPress : null,
      onLongPressStart: onLongPressAt == null
          ? null
          : (d) => onLongPressAt!(d.globalPosition),
      child: bubble,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: isMine
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (leadingStatus != null) ...[
                  leadingStatus,
                  const SizedBox(width: 6),
                ],
                interactiveBubble,
              ],
            )
          : MoyuPeerBubbleFrame(
              bubble: interactiveBubble,
              hasAvatarSlot: hasAvatarSlot,
              showAvatar: showAvatar,
              avatarUrl: avatarUrl,
              avatarLabel: avatarLabel,
              avatarColors: avatarColors,
              senderName: senderName,
            ),
    );
  }
}

BorderRadius _callBubbleBorderRadius(
  BuildContext context, {
  required bool isMine,
}) {
  final r = BubbleRadiusController.of(context).current;
  final tail = BubbleRadiusStore.tailRadiusFor(r);
  return BorderRadius.only(
    topLeft: Radius.circular(r),
    topRight: Radius.circular(r),
    bottomLeft: Radius.circular(isMine ? r : tail),
    bottomRight: Radius.circular(isMine ? tail : r),
  );
}
