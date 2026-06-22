// Live Photo toggle picker — wechat_assets_picker custom delegate.
//
// 上游 wechat_assets_picker 10.x 提供了 `AssetPicker.pickAssetsWithDelegate`
// 这个高级入口, 接受自定义 `DefaultAssetPickerBuilderDelegate` 子类来覆盖
// picker UI 行为. 我们 override `buildLivePhotoIndicator` 让 LIVE 角标本身
// 变成一个 tap toggle: 默认绿色 LIVE = 保留 Live 效果; 点一下变灰色 LIVE +
// 划线 = 当作普通图片发送 (跟微信 picker 内 toggle 体验一致).
//
// 不 fork 上游包. 这条扩展点 (`buildLivePhotoIndicator`) 是上游 protected
// virtual method, override 是官方支持的扩展模式, 升级风险低.

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// Override 角标 → 给 Live Photo 缩略图加 tap toggle.
/// 状态机: `_keepLive` 默认空 map. asset.id 不在 map 内时 = 默认保留
/// Live (跟上游 default 一致). 用户 tap 角标 → 切换到 `false` (不保留),
/// 再 tap → 切回 `true`. 主 app 调用前先 new 一个 instance, picker 关闭
/// 后通过 `isKeepLive(asset)` 读取每张图的最终状态.
/// **必须显式指定 generic `<DefaultAssetPickerProvider>`** (wechat_assets_picker
/// 10.0 breaking change: delegate 现在 generic over provider type). 不指定会让
/// Dart 推 dynamic → runtime AssetPickerState 类型不匹配, picker push 时崩.
class LivePhotoTogglePickerDelegate
    extends DefaultAssetPickerBuilderDelegate<DefaultAssetPickerProvider> {
  LivePhotoTogglePickerDelegate({
    required super.provider,
    required super.initialPermission,
    super.gridCount,
    super.pickerTheme,
    super.specialItems,
    super.loadingIndicatorBuilder,
    super.selectPredicate,
    super.shouldRevertGrid,
    super.limitedPermissionOverlayPredicate,
    super.pathNameBuilder,
    super.assetsChangeCallback,
    super.assetsChangeRefreshPredicate,
    super.viewerUseRootNavigator,
    super.viewerPageRouteSettings,
    super.viewerPageRouteBuilder,
    super.themeColor,
    super.textDelegate,
    super.locale,
    super.gridThumbnailSize,
    super.previewThumbnailSize,
    super.specialPickerType,
    super.keepScrollOffset,
    super.shouldAutoplayPreview,
    super.dragToSelect,
    super.enableLivePhoto,
  });

  /// asset.id → keepLive flag. 不在 map 内 = 默认 true (跟上游
  /// "enableLivePhoto: true" 默认行为一致). 用 ValueNotifier 让 tap
  /// 只 rebuild 角标 widget, 不重绘整张 grid.
  final ValueNotifier<Map<String, bool>> _keepLive =
      ValueNotifier<Map<String, bool>>(<String, bool>{});

  /// 主 app 在 pickAssetsWithDelegate 返回后调用, 检查某 asset 是否要
  /// 保留 Live 效果. 非 Live Photo 永远返回 false.
  bool isKeepLive(AssetEntity asset) {
    if (!asset.isLivePhoto) return false;
    return _keepLive.value[asset.id] ?? true;
  }

  /// `buildLivePhotoIndicator` 显示 LIVE 标识 (跟上游默认风格), 但实际
  /// **toggle 功能放在 selectedBackdrop override 内** — 因为上游 Stack 顺序
  /// 是 [imageBuilder, selectedBackdrop, selectIndicator], selectedBackdrop
  /// 是 Positioned.fill 全屏 GestureDetector(onTap: viewAsset), 它在上层会截
  /// 走所有 tap. 我们必须把 toggle button 放到 selectedBackdrop 之上 (即
  /// 它 child 里的 Stack 顶层) 才能让 tap 先 hit toggle 而不是 viewAsset.
  @override
  Widget buildLivePhotoIndicator(BuildContext context, AssetEntity asset) {
    // Live Photo 默认上游底部 LIVE 角标 (显示用), 实际 toggle 走 selectedBackdrop.
    return super.buildLivePhotoIndicator(context, asset);
  }

  @override
  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) {
    final defaultBackdrop = super.selectedBackdrop(context, index, asset);
    // 只给 Live Photo 加 toggle 按钮 - 普通图继续走上游默认 backdrop.
    if (!asset.isLivePhoto) return defaultBackdrop;
    return Stack(
      fit: StackFit.expand,
      children: [
        defaultBackdrop,
        Positioned(
          left: 4,
          top: 4,
          child: ValueListenableBuilder<Map<String, bool>>(
            valueListenable: _keepLive,
            builder: (_, map, __) {
              final keep = map[asset.id] ?? true;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _keepLive.value = <String, bool>{
                    ..._keepLive.value,
                    asset.id: !keep,
                  };
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: keep
                        ? const Color(0xE6FFB800) // 醒目的黄色 = Live ON
                        : const Color(0xE6555555), // 灰色 = Live OFF
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        keep ? Icons.bolt : Icons.bolt_outlined,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        keep ? 'LIVE' : 'OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 主 app 应该在 picker 关闭后调用 dispose, 释放 ValueNotifier.
  void disposeKeepLive() => _keepLive.dispose();
}
