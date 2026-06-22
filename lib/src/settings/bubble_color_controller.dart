import 'package:flutter/widgets.dart';

/// InheritedWidget 暴露聊天颜色偏好 (ink/purple/green/blue/orange/pink)
/// 给设置页 + 气泡 widget. 跟 BubbleRadiusController / FontScaleController
/// 同模式. 气泡 build 时 `BubbleColorController.of(context).current` 拿 key,
/// 用 BubbleColorStore.colorsFor(key, brightness) 算 bg + fg.
class BubbleColorController extends InheritedWidget {
  const BubbleColorController({
    super.key,
    required this.current,
    required this.change,
    required super.child,
  });

  /// canonical key — ink / purple / green / blue / orange / pink.
  final String current;

  /// 设置页 swatch tap 改这个 → main.dart 写 SharedPreferences + setState
  /// 让所有气泡 rebuild.
  final Future<void> Function(String preference) change;

  static BubbleColorController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<BubbleColorController>();
    assert(
      controller != null,
      'BubbleColorController.of called from a context without a '
      'BubbleColorController ancestor. Wrap MaterialApp.builder output with '
      'BubbleColorController.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(BubbleColorController oldWidget) =>
      oldWidget.current != current;
}
