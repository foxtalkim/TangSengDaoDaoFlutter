import 'package:flutter/widgets.dart';

/// 暴露首页底部导航样式偏好给 HomeShell 与外观页.
class TabBarStyleController extends InheritedWidget {
  const TabBarStyleController({
    super.key,
    required this.current,
    required this.change,
    required this.dockFollowsChatColor,
    required this.changeDockFollowsChatColor,
    required super.child,
  });

  /// canonical key — see TabBarStyleStore.
  final String current;

  /// 外观页选择后写 SharedPreferences + 触发 app rebuild.
  final Future<void> Function(String preference) change;

  /// 玻璃 Dock 是否跟随聊天颜色设置.
  final bool dockFollowsChatColor;

  /// 外观页开关后写 SharedPreferences + 触发 app rebuild.
  final Future<void> Function(bool enabled) changeDockFollowsChatColor;

  static TabBarStyleController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<TabBarStyleController>();
    assert(
      controller != null,
      'TabBarStyleController.of called from a context without a '
      'TabBarStyleController ancestor. Wrap MaterialApp.builder output with '
      'TabBarStyleController.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(TabBarStyleController oldWidget) =>
      oldWidget.current != current ||
      oldWidget.dockFollowsChatColor != dockFollowsChatColor;
}
