import 'package:shared_preferences/shared_preferences.dart';

/// 首页底部导航样式偏好. 默认 glassDock 对应新 Telegram/iOS 26 风格;
/// classic 保留改 Dock 前的全宽半透明底栏.
class TabBarStyleStore {
  const TabBarStyleStore._();

  static const String _key = 'chatim_app_tab_bar_style';
  static const String _dockFollowsChatColorKey =
      'chatim_app_dock_follows_chat_color';

  static const String glassDock = 'glass_dock';
  static const String classic = 'classic';

  static const List<String> orderedKeys = [glassDock, classic];

  static Future<String> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == null || value.isEmpty || !orderedKeys.contains(value)) {
      return glassDock;
    }
    return value;
  }

  static Future<void> savePreference(String value) async {
    if (!orderedKeys.contains(value)) return;
    final prefs = await SharedPreferences.getInstance();
    if (value == glassDock) {
      await prefs.remove(_key);
      return;
    }
    await prefs.setString(_key, value);
  }

  static Future<bool> loadDockFollowsChatColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dockFollowsChatColorKey) ?? false;
  }

  static Future<void> saveDockFollowsChatColor(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    if (!enabled) {
      await prefs.remove(_dockFollowsChatColorKey);
      return;
    }
    await prefs.setBool(_dockFollowsChatColorKey, true);
  }
}
