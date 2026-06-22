import 'package:shared_preferences/shared_preferences.dart';

/// 聊天气泡圆角偏好持久化, 跟 FontScaleStore / ThemeModeStore 同模式.
/// Slider 4-24pt, 默认 18 (chatim 原 hardcode 值, 切默认值 = 视觉不变).
class BubbleRadiusStore {
  const BubbleRadiusStore._();

  static const String _key = 'chatim_app_bubble_radius';

  /// 圆角范围, 跟 _BubbleRadiusPage Slider min/max 一致.
  static const double minRadius = 4;
  static const double maxRadius = 24;

  /// 默认主圆角值 — 跟 _Bubble 原 hardcode `Radius.circular(18)` 一致.
  /// 用户没显式设置时 (新装 / 重启首启) 走这个, 视觉跟之前完全一致.
  static const double defaultRadius = 18;

  static Future<double> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble(_key);
    if (value == null) return defaultRadius;
    return value.clamp(minRadius, maxRadius);
  }

  static Future<void> savePreference(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final clamped = value.clamp(minRadius, maxRadius);
    if (clamped == defaultRadius) {
      await prefs.remove(_key);
      return;
    }
    await prefs.setDouble(_key, clamped);
  }

  /// 气泡尾巴一侧 (isMine bottomRight / !isMine bottomLeft) 的小圆角.
  /// 公式: max(R - 12, 4) — R=18 → 6 (跟原 hardcode 一致); R=24 → 12;
  /// R=4 → 4 (无尾, 几乎方角). 让 tail 跟主圆角联动避免大圆角时 tail
  /// 仍然小成视觉不协调.
  static double tailRadiusFor(double mainRadius) {
    final v = mainRadius - 12;
    return v < 4 ? 4 : v;
  }
}
