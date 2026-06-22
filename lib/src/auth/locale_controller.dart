import 'package:flutter/widgets.dart';

/// InheritedWidget that exposes the app-wide language preference to
/// any descendant. The 通用 → 语言 picker reads `current` to mark the
/// selected option, and calls `change(...)` to flip the locale at
/// app root. Avoids threading the same callback through 4-5 widget
/// constructors (HomeShell → ProfilePage → _CommonSettingsPage →
/// option picker).
class LocaleController extends InheritedWidget {
  const LocaleController({
    super.key,
    required this.current,
    required this.change,
    required super.child,
  });

  /// `LocaleStore.systemPreference` or a supported locale preference
  /// such as `zh`, `en`, `zh_TW`, or `pt_BR`. Mirrors what's saved in
  /// SharedPreferences.
  final String current;

  /// Asynchronously updates the persisted preference and rebuilds the
  /// app root with the new MaterialApp.locale.
  final Future<void> Function(String preference) change;

  static LocaleController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<LocaleController>();
    assert(
      controller != null,
      'LocaleController.of called from a context without a LocaleController '
      'ancestor. Wrap MaterialApp.builder output with LocaleController.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(LocaleController oldWidget) =>
      oldWidget.current != current;
}
