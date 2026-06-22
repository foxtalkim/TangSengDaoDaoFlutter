import 'package:flutter/widgets.dart';

/// InheritedWidget 把字号偏好暴露给设置页, 避免穿 4-5 层 widget 把
/// callback 透传到 `_CommonSettingsPage`. 对齐 LocaleController 同模式 ——
/// MaterialApp.builder 里包一层, 任何 descendant 用 `.of(context)` 读取
/// 当前 canonical key (small / standard / large / extra_large) 与 change
/// 回调. 字号实际缩放由 root 包的 MediaQuery(textScaler) 注入, 这个
/// controller 只暴露 selection state.
class FontScaleController extends InheritedWidget {
  const FontScaleController({
    super.key,
    required this.current,
    required this.change,
    required super.child,
  });

  /// canonical key — one of `FontScaleStore.scaleByKey` 的键.
  final String current;

  /// 设置页选定一档后调 change, 异步存 SharedPreferences 并触发
  /// App state setState → MediaQuery.textScaler 刷新.
  final Future<void> Function(String preference) change;

  static FontScaleController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<FontScaleController>();
    assert(
      controller != null,
      'FontScaleController.of called from a context without a '
      'FontScaleController ancestor. Wrap MaterialApp.builder output with '
      'FontScaleController.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(FontScaleController oldWidget) =>
      oldWidget.current != current;
}
