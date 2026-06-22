import 'package:flutter/widgets.dart';

/// InheritedWidget 暴露深色模式偏好 (system / light / dark) 给设置页,
/// 同 LocaleController / FontScaleController 模式. ThemeMode 实际应用
/// 在 MaterialApp.themeMode (跟随 Flutter 框架) + forui FTheme (Brightness
/// 感知的 zinc.light vs zinc.dark) 两端, 这个 controller 只负责把 selection
/// state 串到设置页选项。
class ThemeModeController extends InheritedWidget {
  const ThemeModeController({
    super.key,
    required this.current,
    required this.change,
    required super.child,
  });

  /// canonical key — 'system' / 'light' / 'dark'.
  final String current;

  /// 设置页选定一档调 change → 走 _ChatImAppState._setThemeModePreference
  /// 写 SharedPreferences + setState 让 MaterialApp / FTheme rebuild.
  final Future<void> Function(String preference) change;

  static ThemeModeController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<ThemeModeController>();
    assert(
      controller != null,
      'ThemeModeController.of called from a context without a '
      'ThemeModeController ancestor. Wrap MaterialApp.builder output with '
      'ThemeModeController.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(ThemeModeController oldWidget) =>
      oldWidget.current != current;
}
