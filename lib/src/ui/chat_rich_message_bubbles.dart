import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../im/wukong_im_service.dart' show MergeForwardEntry;
import '../l10n/app_localizations.dart';
import 'chat_message_status_widgets.dart';
import 'chat_peer_frame.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

class CardBubble extends StatelessWidget {
  const CardBubble({
    super.key,
    required this.isMine,
    required this.name,
    required this.uid,
    this.config,
    this.onTap,
    this.onLongPress,
    this.onLongPressAt,
  });

  final bool isMine;
  final String name;
  final String uid;
  final AppConfig? config;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(Offset globalPosition)? onLongPressAt;

  static const double _cardWidth = 240;
  static const double _topHeight = 68;
  static const double _bottomHeight = 24;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final avatarUrl = AvatarResolver.user(config: config, uid: uid);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPressAt == null ? onLongPress : null,
      onLongPressStart: onLongPressAt == null
          ? null
          : (d) => onLongPressAt!(d.globalPosition),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _cardWidth,
        height: _topHeight + _bottomHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: ColoredBox(
            color: MoyuColors.of(context).background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _topHeight,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: MoyuResolvedAvatar.raw(
                            label: name.isEmpty ? '·' : name.characters.first,
                            size: 48,
                            colors: [
                              MoyuColors.of(context).primarySoft,
                              MoyuColors.of(context).primary,
                            ],
                            imageUrl: avatarUrl,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            name.isEmpty ? t.chatContactFallback : name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: MoyuColors.of(context).textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _bottomHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 0.5,
                        color: MoyuColors.of(context).line,
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          t.chatPersonalCard,
                          style: TextStyle(
                            fontSize: 10,
                            color: MoyuColors.of(context).textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MergeForwardBubble extends StatelessWidget {
  const MergeForwardBubble({
    super.key,
    required this.isMine,
    required this.title,
    required this.entries,
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
  });

  final bool isMine;
  final String title;
  final List<MergeForwardEntry> entries;
  final bool hasAvatarSlot;
  final bool showAvatar;
  final String avatarUrl;
  final String avatarLabel;
  final List<Color> avatarColors;
  final String senderName;
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
    final t = AppLocalizations.of(context);
    final fg = isMine
        ? MoyuInk.bubbleSendForegroundOf(context)
        : MoyuColors.of(context).textPrimary;
    final secondary = isMine
        ? Colors.white.withValues(alpha: 0.65)
        : MoyuColors.of(context).textSecondary;
    final divider = isMine
        ? Colors.white.withValues(alpha: 0.18)
        : MoyuColors.of(context).line;
    final previewCount = entries.length > 4 ? 4 : entries.length;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 120,
        minWidth: 200,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
          gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMine ? 14 : 6),
            bottomRight: Radius.circular(isMine ? 6 : 14),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.isEmpty ? t.globalSearchMessagesSection : title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < previewCount; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  _mergeForwardEntryPreview(entries[i], t),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: secondary),
                ),
              ),
            const SizedBox(height: 6),
            Container(height: 0.5, color: divider),
            const SizedBox(height: 6),
            Text(
              t.globalSearchMessagesSection,
              style: TextStyle(fontSize: 12, color: secondary),
            ),
          ],
        ),
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
      child: !isMine && hasAvatarSlot
          ? MoyuPeerBubbleFrame(
              bubble: interactiveBubble,
              hasAvatarSlot: true,
              showAvatar: showAvatar,
              avatarUrl: avatarUrl,
              avatarLabel: avatarLabel,
              avatarColors: avatarColors,
              senderName: senderName,
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
                interactiveBubble,
              ],
            ),
    );
  }
}

String _mergeForwardEntryPreview(MergeForwardEntry entry, AppLocalizations t) {
  final name = entry.fromName.trim().isEmpty
      ? entry.fromUid
      : entry.fromName.trim();
  final digest = entry.digest.trim().isEmpty
      ? mergeForwardDigestFromPayload(entry.contentType, entry.payload, t)
      : entry.digest.trim();
  return '$name：$digest';
}

String mergeForwardDigestFromPayload(
  int contentType,
  Map<String, dynamic> p,
  AppLocalizations t,
) {
  switch (contentType) {
    case 1:
      final c = p['content'];
      return (c is String && c.trim().isNotEmpty)
          ? c.trim()
          : t.chatMessageDigestMessage;
    case 2:
    case 3:
      return t.chatMessageDigestImage;
    case 4:
      return t.chatMessageDigestVoice;
    case 5:
      return t.chatMessageDigestVideo;
    case 6:
      return t.chatMessageDigestLocation;
    case 7:
      return t.chatMessageDigestCard;
    case 8:
      return t.chatMessageDigestFile;
    case 11:
      return t.chatMessageDigestHistory;
    case 12:
    case 13:
      return t.chatMessageDigestSticker;
    default:
      return t.chatMessageDigestMessage;
  }
}
