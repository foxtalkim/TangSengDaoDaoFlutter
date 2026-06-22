import 'package:flutter/material.dart';

import '../chat/chat_message.dart';
import '../l10n/app_localizations.dart';
import '../media/chat_media_service.dart';
import '../settings/bubble_radius_controller.dart';
import '../settings/bubble_radius_store.dart';
import 'chat_image_bubble.dart';
import 'chat_merge_forward_logic.dart';
import 'chat_module_bubble.dart';
import 'chat_rich_message_bubbles.dart';
import 'chat_voice_bubble.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

/// Preview bubble shown floating above the long-press menu — mirrors the
/// focused bubble pop-out behavior of native iOS `WKContextMenusVC`.
class MessagePreviewBubble extends StatelessWidget {
  const MessagePreviewBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachment;

    if (message.isCardMessage) {
      return CardBubble(
        isMine: isMine,
        name: message.cardName,
        uid: message.cardUid,
      );
    }
    if (message.isMergeForwardMessage) {
      return MergeForwardBubble(
        isMine: isMine,
        title: localizedMergeForwardTitle(
          AppLocalizations.of(context),
          message,
        ),
        entries: message.mergeForwardEntries,
      );
    }
    if (message.kind == ChatMediaKind.file && attachment != null) {
      return Container(
        decoration: BoxDecoration(
          color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
          gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
          borderRadius: _previewBubbleBorderRadius(context, isMine: isMine),
        ),
        child:
            renderModuleMessageBubble(
              context,
              kind: message.kind,
              attachment: attachment,
              fileName: attachment.fileName.isEmpty
                  ? message.text
                  : attachment.fileName,
              isMine: isMine,
            ) ??
            const UnsupportedModuleBubble(),
      );
    }
    if (message.kind == ChatMediaKind.image && attachment != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.all(4),
          child: ImageBubbleContent(
            text: message.text,
            attachment: attachment,
            captionColor: MoyuColors.of(context).textPrimary,
            mediaGateway: null,
          ),
        ),
      );
    }
    if (message.kind == ChatMediaKind.video && attachment != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.all(4),
          child:
              renderModuleMessageBubble(
                context,
                kind: message.kind,
                attachment: attachment,
                fileName: message.fileName,
                isMine: isMine,
              ) ??
              const UnsupportedModuleBubble(),
        ),
      );
    }
    if (message.kind == ChatMediaKind.sticker) {
      return renderModuleMessageBubble(
            context,
            kind: message.kind,
            attachment: attachment,
            fileName: message.fileName,
            isMine: isMine,
          ) ??
          const UnsupportedModuleBubble();
    }
    if (message.kind == ChatMediaKind.voice && attachment != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
          gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
          borderRadius: _previewBubbleBorderRadius(context, isMine: isMine),
        ),
        child: VoiceBubbleContent(
          attachment: attachment,
          isMine: isMine,
          // Use a stable but distinct key for the preview so it doesn't try
          // to share playback state with the live row.
          messageKey: 'preview-voice',
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMine ? null : MoyuColors.of(context).bubbleReceiveBg,
        gradient: isMine ? MoyuInk.bubbleSendGradientOf(context) : null,
        borderRadius: _previewBubbleBorderRadius(context, isMine: isMine),
      ),
      child: Text(
        message.effectiveText.isEmpty
            ? AppLocalizations.of(context).chatMessageDigestFallback
            : message.effectiveText,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: isMine
              ? MoyuInk.bubbleSendForegroundOf(context)
              : MoyuColors.of(context).textPrimary,
        ),
      ),
    );
  }
}

BorderRadius _previewBubbleBorderRadius(
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
