import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 深色模式偏好持久化, 对齐 iOS WKDarkModeVC 三态:
///   system — 跟随系统 brightness (UITraitCollection.userInterfaceStyle)
///   light  — 强制 light (普通模式)
///   dark   — 强制 dark
/// canonical key 与设置页 _CommonSettingsPage 的 darkModeOrder 1:1 对应,
/// 跟 LocaleStore / FontScaleStore 同模式. 存的是字符串 key, 不存 enum
/// 序号 → 字段重命名不会破坏存档.
class ThemeModeStore {
  const ThemeModeStore._();

  static const String _key = 'chatim_app_theme_mode';

  static const String systemPreference = 'system';
  static const String lightPreference = 'light';
  static const String darkPreference = 'dark';

  static const Set<String> _knownKeys = {
    systemPreference,
    lightPreference,
    darkPreference,
  };

  static Future<String> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == null || value.isEmpty || !_knownKeys.contains(value)) {
      return systemPreference;
    }
    return value;
  }

  static Future<void> savePreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value.isEmpty || value == systemPreference) {
      await prefs.remove(_key);
      return;
    }
    if (!_knownKeys.contains(value)) return;
    await prefs.setString(_key, value);
  }

  /// canonical key → Flutter ThemeMode, 直接喂给 MaterialApp.themeMode.
  static ThemeMode toThemeMode(String preference) {
    switch (preference) {
      case lightPreference:
        return ThemeMode.light;
      case darkPreference:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
