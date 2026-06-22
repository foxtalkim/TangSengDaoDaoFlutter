import 'package:shared_preferences/shared_preferences.dart';

/// 字号缩放偏好持久化, 对齐 LocaleStore 风格 (SharedPreferences key + 默认
/// 值兜底). 字号档位与设置页 `_CommonSettingsPage` 的 fontSizeOrder 1:1 对应,
/// 持久化的是 canonical key (`small` / `standard` / `large` / `extra_large`),
/// 不存浮点比例 → 用户翻译切换时显示不会漂移。
class FontScaleStore {
  const FontScaleStore._();

  static const String _key = 'chatim_app_font_scale';
  static const String defaultPreference = 'standard';

  /// canonical key → textScaler 倍数. 标准 1.0, 其他档相对放缩.
  /// 0.88 / 1.0 / 1.12 / 1.24 跟微信「小/标准/大/特大」实测相近.
  static const Map<String, double> scaleByKey = {
    'small': 0.88,
    'standard': 1.0,
    'large': 1.12,
    'extra_large': 1.24,
  };

  static double scaleFor(String preference) =>
      scaleByKey[preference] ?? scaleByKey[defaultPreference]!;

  static Future<String> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == null || value.isEmpty || !scaleByKey.containsKey(value)) {
      return defaultPreference;
    }
    return value;
  }

  static Future<void> savePreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value.isEmpty || value == defaultPreference) {
      await prefs.remove(_key);
      return;
    }
    if (!scaleByKey.containsKey(value)) return;
    await prefs.setString(_key, value);
  }
}
