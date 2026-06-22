import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../app/app_runtime.dart';
import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../modules/module_ids.dart';
import '../modules/module_message_bubble.dart';
import '../social/social_service.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

Widget buildStickerThumbnailFromRegistry(
  ChatSticker sticker,
  AppConfig config,
) {
  final feature = AppRuntime.current?.registry.featureById(
    ModuleFeatureIds.stickerThumbnailBuilder,
  );
  if (feature != null &&
      AppRuntime.current?.registry.isModuleEnabled(feature.moduleId) == true) {
    final builder = feature.value;
    if (builder is ModuleStickerThumbnailBuilder) {
      return Builder(builder: (context) => builder(context, sticker, config));
    }
  }
  return const Icon(FIcons.smile, color: MoyuColors.primary);
}

class StickerSearchResults extends StatelessWidget {
  const StickerSearchResults({
    super.key,
    required this.config,
    required this.searching,
    required this.results,
    required this.onSendSticker,
  });

  final AppConfig config;
  final bool searching;
  final List<ChatSticker> results;
  final ValueChanged<ChatSticker> onSendSticker;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (searching) {
      return Text(
        t.stickerSearching,
        style: TextStyle(
          color: MoyuColors.of(context).textSecondary,
          fontSize: 13,
        ),
      );
    }
    if (results.isEmpty) {
      return Text(
        t.stickerNoSearchResults,
        style: TextStyle(
          color: MoyuColors.of(context).textTertiary,
          fontSize: 13,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.stickerSearchResultsTitle,
          style: TextStyle(
            color: MoyuColors.of(context).textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < results.length; i++) ...[
          Row(
            children: [
              StickerCover(config: config, url: results[i].path),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      results[i].title.isEmpty
                          ? results[i].placeholder
                          : results[i].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: MoyuColors.of(context).textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (results[i].placeholder.isNotEmpty)
                      Text(
                        results[i].placeholder,
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
              FButton(
                size: FButtonSizeVariant.sm,
                mainAxisSize: MainAxisSize.min,
                onPress: () => onSendSticker(results[i]),
                child: Text(t.actionSend),
              ),
            ],
          ),
          if (i != results.length - 1) const MoyuDivider(),
        ],
      ],
    );
  }
}

/// 贴纸 grid — 4 列网格 cell, tap 发送, 长按弹大图预览. emoji panel
/// 内"用户贴纸包" / "自定义"两个 tab 切到时渲染. 对齐 iOS
/// WKStickerContentView + WKStickerBigViewModal.
/// cell 内根据 sticker.format / url 后缀分流: .gif → Image.network 自动播,
/// .lim/.json → Lottie 渲染, 否则静态图.
class StickerGrid extends StatefulWidget {
  const StickerGrid({
    super.key,
    required this.stickers,
    required this.config,
    required this.onSendSticker,
    this.columns = 5,
    this.spacing = 10,
    this.padding = EdgeInsets.zero,
    this.onAddCustomSticker,
  });

  final List<ChatSticker> stickers;
  final AppConfig config;
  final ValueChanged<ChatSticker> onSendSticker;

  /// 默认 5 (对齐 iOS WKStickerGIFContentView.m:124 服务端贴纸包 lineItemCount).
  /// 收藏 grid (WKStickerCollectedContentView.m:85) 传 4.
  final int columns;

  /// item + line 间距, iOS 服务端包 10 / 收藏 5.
  final double spacing;

  /// content inset, iOS 服务端包 (0,0,0,0) / 收藏 (5,5,5,5).
  final EdgeInsets padding;

  /// 非 null 时 grid 头一个 cell 渲染 "+" 添加入口, tap 触发 callback.
  /// 对齐 iOS WKStickerCollectedContentView.m:148-169:
  /// dataArray 头一个是 WKStickerCollectAddCellModel, 点 "+" → push
  /// WKStickerCollectionVC 相册添加 / 整理 / 删除.
  final VoidCallback? onAddCustomSticker;

  @override
  State<StickerGrid> createState() => StickerGridState();
}

class StickerGridState extends State<StickerGrid> {
  // 长按预览 overlay — 对齐 iOS WKStickerBigViewModal:
  // - 140×140 浮窗在 cell 正上方 (m:138-143, 居中于 cell 水平, top = cellTop - 140)
  // - 圆角 8, shadow 0,0,0,0.4 offset (-1,-1) blurRadius 0 (m:170-184)
  // - **无半透明 backdrop** (m:54-63, 注释掉了 0.4 alpha black line)
  // - 左右边界 clamp: 出屏左 → left=0, 出屏右 → left=screenW-boxW
  // - 内 image 120×120 AspectFit (m:160-165)
  OverlayEntry? _previewOverlay;

  void _showPreview(BuildContext cellContext, ChatSticker sticker) {
    _hidePreview();
    final renderBox = cellContext.findRenderObject();
    if (renderBox is! RenderBox || !renderBox.attached) return;
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final overlay = Overlay.maybeOf(cellContext, rootOverlay: true);
    if (overlay == null) return;
    const previewSize = 140.0;
    const verticalGap = 4.0;
    final mq = MediaQuery.of(cellContext).size;
    var left = topLeft.dx + size.width / 2 - previewSize / 2;
    if (left < 0) left = 0;
    if (left + previewSize > mq.width) left = mq.width - previewSize;
    final top = topLeft.dy - previewSize - verticalGap;
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        left: left,
        top: top,
        child: IgnorePointer(
          child: Container(
            width: previewSize,
            height: previewSize,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MoyuColors.of(context).background,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  offset: Offset(-1, -1),
                  blurRadius: 0,
                ),
              ],
            ),
            child: buildStickerThumbnailFromRegistry(sticker, widget.config),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    _previewOverlay = entry;
  }

  void _hidePreview() {
    _previewOverlay?.remove();
    _previewOverlay = null;
  }

  @override
  void dispose() {
    _hidePreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasAddCell = widget.onAddCustomSticker != null;
    final addOffset = hasAddCell ? 1 : 0;
    return GridView.builder(
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
        crossAxisSpacing: widget.spacing,
        mainAxisSpacing: widget.spacing,
        childAspectRatio: 1,
      ),
      itemCount: widget.stickers.length + addOffset,
      itemBuilder: (context, i) {
        if (hasAddCell && i == 0) {
          // 对齐 iOS WKStickerCollectAddCell (m:53): 单 UIImageView 撑满
          // cell, 资源 Conversation/Panel/CollectionAdd. Flutter 等价用
          // FIcons.plus + 灰文.
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onAddCustomSticker,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MoyuColors.of(context).backgroundSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                FIcons.plus,
                size: 28,
                color: MoyuColors.of(context).textTertiary,
              ),
            ),
          );
        }
        final sticker = widget.stickers[i - addOffset];
        return Builder(
          builder: (cellContext) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onSendSticker(sticker),
            // 长按预览大图 — 释放手指 / 拖出区域自动关闭.
            onLongPressStart: (_) => _showPreview(cellContext, sticker),
            onLongPressEnd: (_) => _hidePreview(),
            onLongPressCancel: _hidePreview,
            // 对齐 iOS WKStickerGIFCell (m:40-41): cell 内嵌 image_view 大小
            // 同 cell, 无 background/borderRadius (之前 Flutter 自创的灰
            // 圆角底 + 选中蓝色态删).
            child: buildStickerThumbnailFromRegistry(sticker, widget.config),
          ),
        );
      },
    );
  }
}

class StickerCover extends StatelessWidget {
  const StickerCover({super.key, required this.config, required this.url});

  final AppConfig config;
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).primarySoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(FIcons.smile, color: MoyuColors.of(context).primary),
      );
    }
    // 商店 / 包详情 / 搜索结果用的同款 cover renderer. DB 里 cover_lim
    // 字段值是 cover.lim — **gzip 压缩的 Lottie JSON**, 不是图片. 之前
    // _StickerPackRow 优先用 coverLimit → 传到这里 Image.network 加载
    // .lim 永远 fail → 整个商店 cover 全是 smile placeholder (Android
    // 真机走查发现). 走 registry sticker renderer 渲染 .lim, 其他后缀走
    // Image.network.
    final fullUrl = url.startsWith('http') ? url : config.showUrl(url);
    if (fullUrl.toLowerCase().endsWith('.lim')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: 48,
          child: buildStickerThumbnailFromRegistry(
            ChatSticker(path: fullUrl),
            config,
          ),
        ),
      );
    }
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: fullUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        memCacheHeight: (48 * pixelRatio).round(),
        errorWidget: (context, error, stackTrace) =>
            Icon(FIcons.smile, color: MoyuColors.of(context).primary),
      ),
    );
  }
}
