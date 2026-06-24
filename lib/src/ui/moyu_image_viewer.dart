import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 单张图全屏预览 —— 点头像 / 单图看大图用。黑底 + `InteractiveViewer`
/// pinch-zoom + 任意 tap dismiss。
/// 跟 `ImageLightbox` / `ImagePreviewPage` 区分:那两个接 `ChatMessage`、带
/// 保存相册 / 识别二维码 / 加表情等动作,是为「聊天图片消息」设计的;这个只
/// 接一个 url,给头像、封面这类「看一眼大图」的轻量场景。
class MoyuImageViewer {
  const MoyuImageViewer._();

  static Future<void> show(
    BuildContext context, {
    required String imageUrl,
  }) {
    final url = imageUrl.trim();
    if (url.isEmpty) return Future<void>.value();
    return showGeneralDialog<void>(
      context: context,
      barrierColor: Colors.black,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, _, _) => _MoyuImageViewerOverlay(imageUrl: url),
      transitionBuilder: (_, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
    );
  }
}

class _MoyuImageViewerOverlay extends StatelessWidget {
  const _MoyuImageViewerOverlay({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // 整屏 tap dismiss; 图本身 InteractiveViewer 支持双指放大 / 拖动。
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: SizedBox.expand(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (_, _) => const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              errorWidget: (_, _, _) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
