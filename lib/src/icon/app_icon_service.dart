import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

/// 5 个 launcher 图标的 metadata。
/// `iosName` 对应 ios/Runner/Info.plist 的 `CFBundleAlternateIcons` key。
/// `androidName` 对应 android/app/src/main/AndroidManifest.xml 的
/// `<activity-alias android:name=".XXX">` 的 alias 名（不带 `.` 前缀）。
/// 主图（id=1）的 `iosName` 为 null —— iOS 上 setAlternateIconName(null)
/// 恢复 plist 中的 CFBundlePrimaryIcon。
class AppIcon {
  const AppIcon({
    required this.id,
    required this.label,
    required this.assetPath,
    required this.iosName,
    required this.androidName,
  });

  final int id;
  final String label;
  final String assetPath;
  final String? iosName;
  final String androidName;
}

const List<AppIcon> kAppIcons = [
  AppIcon(
    id: 1,
    label: 'classic',
    assetPath: 'assets/icons/foxtalk-app-icon-01.png',
    iosName: null,
    androidName: 'IconAliasMain',
  ),
  AppIcon(
    id: 2,
    label: 'simple',
    assetPath: 'assets/icons/foxtalk-app-icon-02.png',
    iosName: 'alt2',
    androidName: 'IconAlias2',
  ),
  AppIcon(
    id: 3,
    label: 'dark',
    assetPath: 'assets/icons/foxtalk-app-icon-03.png',
    iosName: 'alt3',
    androidName: 'IconAlias3',
  ),
  AppIcon(
    id: 4,
    label: 'festive',
    assetPath: 'assets/icons/foxtalk-app-icon-04.png',
    iosName: 'alt4',
    androidName: 'IconAlias4',
  ),
  AppIcon(
    id: 5,
    label: 'gradient',
    assetPath: 'assets/icons/foxtalk-app-icon-05.png',
    iosName: 'alt5',
    androidName: 'IconAlias5',
  ),
];

/// 包装 flutter_dynamic_icon_plus，集中处理 iOS / Android 平台差异。
class AppIconService {
  const AppIconService();

  static const MethodChannel _nativeChannel = MethodChannel('foxtalk/app_icon');

  /// 当前激活的图标。查询失败或不支持平台返回 [kAppIcons]`[0]`（主图）。
  Future<AppIcon> current() async {
    if (!await _supported()) return kAppIcons.first;
    try {
      if (Platform.isAndroid) {
        final androidName = await _nativeChannel.invokeMethod<String>(
          'getCurrentIcon',
        );
        if (androidName != null && androidName.isNotEmpty) {
          for (final icon in kAppIcons) {
            if (matchesAndroidAliasForTest(androidName, icon.androidName)) {
              return icon;
            }
          }
        }
      }
      final name = await FlutterDynamicIconPlus.alternateIconName;
      if (name == null || name.isEmpty) return kAppIcons.first;
      // iOS 直接返回 alt name；Android 不同插件版本返回简短或 fully-qualified
      // alias 名，统一按后缀比对。
      for (final icon in kAppIcons) {
        final ios = icon.iosName;
        final android = icon.androidName;
        if (Platform.isIOS && ios != null && name == ios) return icon;
        if (Platform.isAndroid &&
            (name == android || name.endsWith('.$android'))) {
          return icon;
        }
      }
      return kAppIcons.first;
    } catch (_) {
      return kAppIcons.first;
    }
  }

  /// 切换到指定图标。无异常即视为成功。
  ///
  /// iOS：系统会弹原生 alert "App icon has changed"。
  ///
  /// Android：走 Runner/MainActivity 注册的 `foxtalk/app_icon` native
  /// channel，直接启用目标 activity-alias、禁用其他 alias。不要回退到
  /// flutter_dynamic_icon_plus：该插件在 Android 会把 `IconAlias2`
  /// 当成完整 component，三星等设备会报 `Component class ... does not
  /// exist`。
  Future<bool> setIcon(AppIcon icon) async {
    if (!await _supported()) return false;
    try {
      if (Platform.isAndroid) {
        await _nativeChannel.invokeMethod<void>('setIcon', {
          'aliasName': icon.androidName,
        });
        return true;
      }
      final name = icon.iosName;
      await FlutterDynamicIconPlus.setAlternateIconName(iconName: name);
      return true;
    } catch (error, stackTrace) {
      debugPrint('[app-icon] setIcon failed: $error\n$stackTrace');
      return false;
    }
  }

  @visibleForTesting
  static bool matchesAndroidAliasForTest(String nativeName, String aliasName) =>
      nativeName == aliasName || nativeName.endsWith('.$aliasName');

  Future<bool> _supported() async {
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    if (Platform.isAndroid) {
      try {
        return await _nativeChannel.invokeMethod<bool>(
              'supportsAlternateIcons',
            ) ??
            false;
      } catch (error, stackTrace) {
        debugPrint(
          '[app-icon] supportsAlternateIcons failed: $error\n$stackTrace',
        );
        return false;
      }
    }
    try {
      return await FlutterDynamicIconPlus.supportsAlternateIcons;
    } catch (_) {
      return false;
    }
  }
}
