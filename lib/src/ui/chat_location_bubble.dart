import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import '../settings/bubble_radius_controller.dart';
import '../settings/bubble_radius_store.dart';
import 'chat_media_time_chip.dart';
import 'chat_message_status_widgets.dart';
import 'chat_peer_frame.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

/// Location-message bubble shell: bubble background + tap handlers wrapping
/// `LocationBubbleContent`. Mirrors `CardBubble`'s shape so location messages
/// feel native alongside cards.
class LocationBubble extends StatelessWidget {
  const LocationBubble({
    super.key,
    required this.isMine,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.imageUrl = '',
    this.onTap,
    this.onLongPress,
    this.onLongPressAt,
    this.status,
    this.readed = false,
    this.readedCount = 0,
    this.unreadCount = 0,
    this.onReceiptTap,
    this.onRetry,
    this.onDelete,
    this.hasAvatarSlot = false,
    this.showAvatar = false,
    this.avatarUrl = '',
    this.avatarLabel = '',
    this.avatarColors = const [],
    this.senderName = '',
    this.onAvatarTap,
    this.timeText = '',
  });

  final bool isMine;
  final String title;
  final String address;
  final double latitude;
  final double longitude;
  final bool hasAvatarSlot;
  final bool showAvatar;
  final String avatarUrl;
  final String avatarLabel;
  final List<Color> avatarColors;
  final String senderName;
  final VoidCallback? onAvatarTap;
  final String timeText;

  /// 服务端 mini-map 截图 URL. 非空时 preview 区域用 CachedNetworkImage 渲染,
  /// 空时显占位.
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(Offset globalPosition)? onLongPressAt;
  final String? status;
  final bool readed;
  final int readedCount;
  final int unreadCount;
  final VoidCallback? onReceiptTap;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
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
      }
      // 已发送回执 (✓✓) 改走 MediaTimeChip overlay (时间旁), 不走 leadingStatus,
      // 跟图片/语音消息一致 (TG 风)。leadingStatus 只保留发送中 / 失败。
    }

    final bubbleBox = GestureDetector(
      onTap: onTap,
      onLongPress: onLongPressAt == null ? onLongPress : null,
      onLongPressStart: onLongPressAt == null
          ? null
          : (d) => onLongPressAt!(d.globalPosition),
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: _locationBubbleBorderRadius(context, isMine: isMine),
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
            gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
          ),
          child: LocationBubbleContent(
            title: title,
            address: address,
            latitude: latitude,
            longitude: longitude,
            imageUrl: imageUrl,
            isMine: isMine,
          ),
        ),
      ),
    );
    // 时间 overlay 浮在卡片右下角 (半透明黑胶囊白字), 对齐图片/视频消息 +
    // Telegram。回执仍走 leadingStatus (isMine 卡片左侧)。
    final bubbleWithTime = Stack(
      clipBehavior: Clip.none,
      children: [
        bubbleBox,
        Positioned(
          right: 8,
          bottom: 8,
          child: MediaTimeChip(
            timeText: timeText,
            isMine: isMine,
            status: status,
            readed: readed,
            readedCount: readedCount,
            unreadCount: unreadCount,
            onReceiptTap: onReceiptTap,
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: !isMine && hasAvatarSlot
          ? MoyuPeerBubbleFrame(
              bubble: bubbleWithTime,
              hasAvatarSlot: true,
              showAvatar: showAvatar,
              avatarUrl: avatarUrl,
              avatarLabel: avatarLabel,
              avatarColors: avatarColors,
              senderName: senderName,
              onAvatarTap: onAvatarTap,
            )
          : Row(
              mainAxisAlignment: isMine
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (leadingStatus != null) ...[
                  leadingStatus,
                  const SizedBox(width: 6),
                ],
                bubbleWithTime,
              ],
            ),
    );
  }
}

/// Location-message bubble: 240 宽卡片样式，顶部 mini-map preview，下方标题地址。
class LocationBubbleContent extends StatelessWidget {
  const LocationBubbleContent({
    super.key,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.isMine,
  });

  final String title;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final fg = isMine
        ? MoyuInk.bubbleSendForegroundOf(context)
        : MoyuColors.of(context).textPrimary;
    final sub = isMine
        ? Colors.white.withValues(alpha: 0.75)
        : MoyuColors.of(context).textTertiary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 240,
          height: 120,
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  memCacheWidth: 1024,
                  memCacheHeight: 512,
                  placeholder: (context, url) => _miniMapPlaceholder(),
                  errorWidget: (context, url, error) => _miniMapPlaceholder(),
                )
              : _miniMapPlaceholder(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.isEmpty
                    ? AppLocalizations.of(context).chatLocationDefaultTitle
                    : title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: fg,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (address.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(fontSize: 12, color: sub, height: 1.35),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniMapPlaceholder() {
    return Container(
      width: 240,
      height: 120,
      color: const Color(0xFFF1EBDF),
      alignment: Alignment.center,
      child: const Icon(FIcons.mapPin, size: 32, color: Color(0xFFE5413E)),
    );
  }
}

BorderRadius _locationBubbleBorderRadius(
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
