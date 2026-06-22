import 'package:flutter/widgets.dart';

/// InheritedWidget 暴露当前气泡圆角偏好 (4-24pt double) 给设置页 +
/// 所有气泡 widget. 跟 FontScaleController / ThemeModeController 同模式.
/// 气泡 build 时 `BubbleRadiusController.of(context).current` 拿到主圆角值,
/// tail 一侧用 `BubbleRadiusStore.tailRadiusFor(main)` 算副圆角.
class BubbleRadiusController extends InheritedWidget {
  const BubbleRadiusController({
    super.key,
    required this.current,
    required this.change,
    required super.child,
  });

  /// 当前主圆角值 (4-24pt). 实际气泡 borderRadius 4 角:
  ///   topLeft / topRight = current
  ///   tail 角 (isMine bottomRight / !isMine bottomLeft) = tailRadiusFor(current)
  ///   其余 bottom 角 = current
  final double current;

  /// 设置页 Slider 拖动 / picker 选定时调, 异步存 SharedPreferences +
  /// setState 触发 rebuild → 所有气泡 borderRadius 立刻刷新.
  final Future<void> Function(double radius) change;

  static BubbleRadiusController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<BubbleRadiusController>();
    assert(
      controller != null,
      'BubbleRadiusController.of called from a context without a '
      'BubbleRadiusController ancestor. Wrap MaterialApp.builder output with '
      'BubbleRadiusController.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(BubbleRadiusController oldWidget) =>
      oldWidget.current != current;
}
