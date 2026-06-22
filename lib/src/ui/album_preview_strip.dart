import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'moyu_theme.dart';

class AlbumPreviewItem {
  const AlbumPreviewItem({required this.asset, required this.thumbnail});

  final AssetEntity asset;
  final Uint8List thumbnail;
}

class AlbumPreviewStrip extends StatelessWidget {
  const AlbumPreviewStrip({
    super.key,
    required this.items,
    required this.loading,
    required this.onTap,
  });

  static const double _tileExtent = 76;
  static const double _railHeight = 84;
  static const double _tileRadius = 8;

  final List<AlbumPreviewItem> items;
  final bool loading;
  final Future<void> Function(AlbumPreviewItem item) onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    return Semantics(
      identifier: 'moyu.chat.album.preview.rail',
      container: true,
      child: SizedBox(
        height: _railHeight,
        child: loading && items.isEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: _tileExtent,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(_tileRadius),
                      border: Border.all(color: colors.line, width: 0.5),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return FTappable(
                    onPress: () => unawaited(onTap(item)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox.square(
                        dimension: _tileExtent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(_tileRadius),
                          child: Image.memory(
                            item.thumbnail,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
