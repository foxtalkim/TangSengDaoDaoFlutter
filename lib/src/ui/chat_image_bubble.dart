import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../media/chat_media_service.dart';
import 'moyu_theme.dart';

class ImageBubbleContent extends StatefulWidget {
  const ImageBubbleContent({
    super.key,
    required this.text,
    required this.captionColor,
    this.attachment,
    this.mediaGateway,
    this.uploadProgress,
  });

  final String text;
  final Color captionColor;
  final ChatMediaAttachment? attachment;

  /// Used to fetch the remote image through the *authenticated* ApiClient
  /// when the URL points at our `file/upload`-served path (which requires
  /// the `token` header). Plain `Image.network` can't carry that header
  /// without extra setup.
  final ChatMediaGateway? mediaGateway;

  /// 0-1 上传进度. 跟 video/file bubble 同款 — 父 bubble 透传
  /// upload progress, peer message hardcode null. 上传中显示 44pt circular
  /// progress 覆盖在图上, 上传完 (>= 1.0) 显回正常图.
  final ValueListenable<double>? uploadProgress;

  @override
  State<ImageBubbleContent> createState() => _ImageBubbleContentState();
}

class _ImageBubbleContentState extends State<ImageBubbleContent> {
  /// Decoded image 的实际 dim — 从 ImageStream listener 拿. attachment.width/
  /// height 可能跟 server 实际图不一致, 用真实 dim 重算 aspect 避免变形.
  int? _decodedW;
  int? _decodedH;
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;
  String _lastResolvedUrl = '';

  @override
  void dispose() {
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
    super.dispose();
  }

  void _resolveDecodedDim(String url) {
    if (url.isEmpty || url == _lastResolvedUrl) return;
    _lastResolvedUrl = url;
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
    final provider = CachedNetworkImageProvider(url);
    _imageStream = provider.resolve(const ImageConfiguration());
    _imageListener = ImageStreamListener((info, _) {
      final w = info.image.width;
      final h = info.image.height;
      if (!mounted) return;
      if (_decodedW != w || _decodedH != h) {
        setState(() {
          _decodedW = w;
          _decodedH = h;
        });
      }
    });
    _imageStream!.addListener(_imageListener!);
  }

  /// 长边 cap, 跟 live-photo / video bubble 同款.
  static const double _maxSide = 192.0;

  /// width/height 都 0 时的 fallback (e.g. 老消息没 size 字段, 或第三方
  /// client 漏 width/height 字段). 取 4:3 landscape 占位.
  static const double _fallbackAspect = 4 / 3;

  @override
  Widget build(BuildContext context) {
    final localPath = widget.attachment?.localPath.trim() ?? '';
    final remoteUrl = widget.attachment?.remoteUrl.trim() ?? '';
    final remoteUrlEarly = widget.attachment?.remoteUrl.trim() ?? '';
    if (remoteUrlEarly.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _resolveDecodedDim(remoteUrlEarly);
      });
    }

    final attachW = (widget.attachment?.width ?? 0).toDouble();
    final attachH = (widget.attachment?.height ?? 0).toDouble();
    final natW = (_decodedW ?? 0) > 0 ? _decodedW!.toDouble() : attachW;
    final natH = (_decodedH ?? 0) > 0 ? _decodedH!.toDouble() : attachH;
    final aspect = natW > 0 && natH > 0 ? natW / natH : _fallbackAspect;
    double w;
    double h;
    if (aspect >= 1) {
      w = _maxSide;
      h = _maxSide / aspect;
    } else {
      w = _maxSide * aspect;
      h = _maxSide;
    }

    // memCache dim 按原图 aspect 算, 避免方形 decode bitmap 造成内容拉伸。
    const cacheLong = 1024;
    final cacheW = aspect >= 1 ? cacheLong : (cacheLong * aspect).round();
    final cacheH = aspect >= 1 ? (cacheLong / aspect).round() : cacheLong;
    final placeholder = Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: MoyuColors.of(context).backgroundSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.image_outlined,
        color: MoyuColors.of(context).textTertiary,
        size: 36,
      ),
    );

    Widget preview = placeholder;
    if (localPath.isNotEmpty) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          File(localPath),
          width: w,
          height: h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            if (remoteUrl.startsWith('http://') ||
                remoteUrl.startsWith('https://')) {
              return CachedNetworkImage(
                imageUrl: remoteUrl,
                width: w,
                height: h,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                memCacheWidth: cacheW,
                memCacheHeight: cacheH,
                errorWidget: (context, url, error) => placeholder,
              );
            }
            return placeholder;
          },
        ),
      );
    } else if (remoteUrl.startsWith('http://') ||
        remoteUrl.startsWith('https://')) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CachedNetworkImage(
          imageUrl: remoteUrl,
          width: w,
          height: h,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          memCacheWidth: cacheW,
          memCacheHeight: cacheH,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
                width: w,
                height: h,
                decoration: BoxDecoration(
                  color: MoyuColors.of(context).backgroundSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: downloadProgress.progress,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
              ),
          errorWidget: (context, url, error) => placeholder,
        ),
      );
    }

    final progress = widget.uploadProgress;
    final previewWithOverlay = SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          Positioned.fill(child: preview),
          if (progress != null)
            Positioned.fill(
              child: ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (context, value, child) {
                  if (value >= 1.0) return const SizedBox.shrink();
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: ColoredBox(
                      color: const Color(0x66000000),
                      child: Center(
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: value.clamp(0.0, 1.0),
                                strokeWidth: 3,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.3,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                              Text(
                                '${(value * 100).clamp(0, 99).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    final hasRealCaption =
        widget.text.isNotEmpty &&
        widget.text != '[图片]' &&
        !widget.text.startsWith('[图片]');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        previewWithOverlay,
        if (hasRealCaption) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.captionColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
