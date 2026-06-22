import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 聊天颜色偏好持久化, 跟 BubbleRadiusStore 同模式. 用户在外观 → 聊天
/// 颜色挑一个 swatch, 6 预设 ink/紫/绿/蓝/橙/粉, ink 是默认 (跟 Moyu
/// ink edition 品牌一致). 选了其他颜色时自己气泡变纯色填充.
class BubbleColorStore {
  const BubbleColorStore._();

  static const String _key = 'chatim_app_bubble_color';

  /// canonical keys + 默认.
  static const String defaultPreference = 'ink';
  static const List<String> orderedKeys = [
    'ink',
    'purple',
    'green',
    'blue',
    'orange',
    'pink',
  ];

  /// 每个 key 对应的 light + dark 配色 (单色, 不再 gradient — bg1==bg2).
  /// foreground 跟 bg 反相对比保证可读.
  static const Map<String, _ColorSet> _light = {
    'ink': _ColorSet(Color(0xFF1A1A1F), Color(0xFF2A2A2F), Color(0xFFFFFFFF)),
    'purple': _ColorSet(
      Color(0xFF8E44AD),
      Color(0xFF8E44AD),
      Color(0xFFFFFFFF),
    ),
    'green': _ColorSet(Color(0xFF06C160), Color(0xFF06C160), Color(0xFFFFFFFF)),
    'blue': _ColorSet(Color(0xFF3478F6), Color(0xFF3478F6), Color(0xFFFFFFFF)),
    'orange': _ColorSet(
      Color(0xFFF0883A),
      Color(0xFFF0883A),
      Color(0xFFFFFFFF),
    ),
    'pink': _ColorSet(Color(0xFFFF6B9E), Color(0xFFFF6B9E), Color(0xFFFFFFFF)),
  };

  static const Map<String, _ColorSet> _dark = {
    // ink dark = 白到浅白灰 + 近黑字。对方气泡 dark 已经是深灰黑,
    // 自己气泡用干净白面拉开层级, 避免冷灰显脏.
    'ink': _ColorSet(Color(0xFFFFFFFF), Color(0xFFF7F7F8), Color(0xFF111114)),
    'purple': _ColorSet(
      Color(0xFFB57EDC),
      Color(0xFFB57EDC),
      Color(0xFF1A1A1F),
    ),
    'green': _ColorSet(Color(0xFF4CD964), Color(0xFF4CD964), Color(0xFF1A1A1F)),
    'blue': _ColorSet(Color(0xFF66B0FF), Color(0xFF66B0FF), Color(0xFF1A1A1F)),
    'orange': _ColorSet(
      Color(0xFFFFA64C),
      Color(0xFFFFA64C),
      Color(0xFF1A1A1F),
    ),
    'pink': _ColorSet(Color(0xFFFF9CC0), Color(0xFFFF9CC0), Color(0xFF1A1A1F)),
  };

  /// 返回当前 key + brightness 对应的 (bg1, bg2, foreground).
  /// 未知 key 走 defaultPreference 兜底, brightness 走 light 兜底.
  static BubbleColorSet colorsFor(String key, Brightness brightness) {
    final palette = brightness == Brightness.dark ? _dark : _light;
    final set = palette[key] ?? palette[defaultPreference]!;
    return BubbleColorSet(bg1: set.bg1, bg2: set.bg2, foreground: set.fg);
  }

  static Future<String> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == null || value.isEmpty || !orderedKeys.contains(value)) {
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
    if (!orderedKeys.contains(value)) return;
    await prefs.setString(_key, value);
  }
}

class _ColorSet {
  const _ColorSet(this.bg1, this.bg2, this.fg);
  final Color bg1;
  final Color bg2;
  final Color fg;
}

/// 外部使用的色板三元组.
class BubbleColorSet {
  const BubbleColorSet({
    required this.bg1,
    required this.bg2,
    required this.foreground,
  });

  final Color bg1;
  final Color bg2;
  final Color foreground;
}
