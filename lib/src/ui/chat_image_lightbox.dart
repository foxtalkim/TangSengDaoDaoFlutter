import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../chat/chat_message.dart';
import '../l10n/app_localizations.dart';
import 'moyu_widgets.dart';

/// Fullscreen lightbox over the chat. Tap to dismiss, pinch to zoom, drag
/// vertically to swipe away. Replaces the routed image preview for the "tap an
/// image bubble" path — long-press still surfaces actions inline.
class ImageLightbox {
  static Future<void> show(
    BuildContext context, {
    required ChatMessage message,
    VoidCallback? onSaveToAlbum,
    VoidCallback? onRecognizeQrcode,
    VoidCallback? onAddToStickers,
  }) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context).actionCancel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, _) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
        );
        return _ImageLightboxOverlay(
          animation: curved,
          message: message,
          onSaveToAlbum: onSaveToAlbum,
          onRecognizeQrcode: onRecognizeQrcode,
          onAddToStickers: onAddToStickers,
        );
      },
    );
  }
}

class _ImageLightboxOverlay extends StatelessWidget {
  const _ImageLightboxOverlay({
    required this.animation,
    required this.message,
    this.onSaveToAlbum,
    this.onRecognizeQrcode,
    this.onAddToStickers,
  });

  final Animation<double> animation;
  final ChatMessage message;
  final VoidCallback? onSaveToAlbum;
  final VoidCallback? onRecognizeQrcode;
  final VoidCallback? onAddToStickers;

  /// 右上角 "..." 按钮 — 跟 iOS WKImageBrowser 长按图弹 ActionSheet 同位置.
  /// chatim 用按钮替代长按避免跟 InteractiveViewer 的 zoom/pan gesture 冲突.
  Future<void> _openActionSheet(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final items = <MoyuActionSheetItem>[];
    if (onSaveToAlbum != null) {
      items.add(
        MoyuActionSheetItem(
          title: t.saveToAlbum,
          onSelected: () {
            Navigator.of(context).maybePop();
            onSaveToAlbum!();
          },
        ),
      );
    }
    if (onRecognizeQrcode != null) {
      items.add(
        MoyuActionSheetItem(
          title: t.chatRecognizeImageQrcode,
          onSelected: () {
            Navigator.of(context).maybePop();
            onRecognizeQrcode!();
          },
        ),
      );
    }
    if (onAddToStickers != null) {
      items.add(
        MoyuActionSheetItem(
          title: t.chatAddToStickers,
          onSelected: () {
            Navigator.of(context).maybePop();
            onAddToStickers!();
          },
        ),
      );
    }
    if (items.isEmpty) return;
    await MoyuActionSheet.show(context, items: items);
  }

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachment;
    final localPath = attachment?.localPath ?? '';
    final remoteUrl = attachment?.remoteUrl ?? '';
    Widget image;
    if (localPath.isNotEmpty) {
      image = Image.file(
        File(localPath),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => remoteUrl.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: remoteUrl,
                fit: BoxFit.contain,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
              )
            : const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 48,
              ),
      );
    } else if (remoteUrl.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: remoteUrl,
        fit: BoxFit.contain,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
      );
    } else {
      image = const Icon(
        Icons.broken_image_outlined,
        color: Colors.white54,
        size: 48,
      );
    }

    final hasActions =
        onSaveToAlbum != null ||
        onRecognizeQrcode != null ||
        onAddToStickers != null;
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) {
        return Container(
          color: Colors.black.withValues(alpha: 0.94 * animation.value),
          child: Opacity(
            opacity: animation.value,
            child: Stack(
              children: [
                // 主体 — 点空白处关闭, InteractiveViewer 内置 zoom/pan gesture.
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Center(
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: image,
                      ),
                    ),
                  ),
                ),
                // 右上角 "..." 按钮 — 跟 iOS WKImageBrowser 长按图弹 sheet
                // 同 UX, 但用 button 触发避免跟 InteractiveViewer gesture 冲突.
                if (hasActions)
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 8,
                    right: 12,
                    child: SafeArea(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => unawaited(_openActionSheet(context)),
                          child: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FIcons.ellipsis,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
