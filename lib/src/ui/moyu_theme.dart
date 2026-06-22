import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Moyu Ink Edition palette — black is the brand color, single accent.
/// Red is reserved exclusively for unread badges; no other accent.
/// 双 API:
/// 1. **静态 const** (`MoyuColors.background` 等): 编译期常量, 跟 light theme
///    对齐, 用于 `const TextStyle / const BoxDecoration` 等 const 上下文.
///    向后兼容旧代码, 但不响应深色模式 — 切 dark 仍显 light 值.
/// 2. **动态实例** (`MoyuColors.of(context).background` 等): 根据
///    `Theme.of(context).brightness` 返回 `_light` / `_dark` 实例的对应字段.
///    动态语义色 (background / textPrimary / line 等) 在切 dark 时变深;
///    强调色 (red / blue / orange / green) 保持鲜艳, 不随主题变.
class MoyuColors {
  const MoyuColors._();

  // ─── 静态 const API (向后兼容 / const 上下文) ───
  static const primary = Color(0xFF1A1A1F);
  static const primarySoft = Color(0xFF2A2A2F);
  static const background = Color(0xFFFFFFFF);
  static const backgroundSoft = Color(0xFFF6F6F7);
  static const textPrimary = Color(0xFF1A1A1F);
  static const textSecondary = Color(0xFF6B6B73);
  static const textTertiary = Color(0xFF9B9BA3);
  static const line = Color(0xFFECECEE);
  static const red = Color(0xFFFF3B30);
  static const blue = Color(0xFF3478F6);
  static const orange = Color(0xFFF0883A);
  static const green = Color(0xFF34C759);

  // ─── 动态实例 API (.of(context).xxx) ───

  /// 根据当前主题返回 light / dark 实例. 自动跟随 MaterialApp.themeMode +
  /// FTheme.brightness — 用户切深色模式时此 getter 立刻返回 _dark 实例,
  /// 调用方 build 内会拿到深色对应字段.
  static MoyuColorsData of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _dark : _light;
  }

  /// Light theme 配色 — 跟静态 const 字段 1:1 对应, 切 light 看起来跟旧代码
  /// 完全一致.
  static const MoyuColorsData _light = MoyuColorsData(
    primary: Color(0xFF1A1A1F),
    primarySoft: Color(0xFF2A2A2F),
    background: Color(0xFFFFFFFF),
    backgroundSoft: Color(0xFFF6F6F7),
    textPrimary: Color(0xFF1A1A1F),
    textSecondary: Color(0xFF6B6B73),
    textTertiary: Color(0xFF9B9BA3),
    line: Color(0xFFECECEE),
    red: Color(0xFFFF3B30),
    blue: Color(0xFF3478F6),
    orange: Color(0xFFF0883A),
    green: Color(0xFF34C759),
    // light 气泡 — ink 黑 gradient + 白字, 跟 MoyuInk.bubbleSendGradientOf(context) 旧值完全一致.
    bubbleSendBg1: Color(0xFF1A1A1F),
    bubbleSendBg2: Color(0xFF2A2A2F),
    bubbleSendForeground: Color(0xFFFFFFFF),
    // light 对方气泡 — 纯白 #FFFFFF, 跟 chat bg backgroundSoft #F6F6F7 浅灰
    // 形成"白气泡浮于灰背景"层级 (跟微信 light 风一致). 之前误写
    // #F6F6F7 跟 chat bg 同色融合, 对方气泡边界消失.
    bubbleReceiveBg: Color(0xFFFFFFFF),
    bubbleReceiveForeground: Color(0xFF1A1A1F),
  );

  /// Dark theme 配色 —
  /// - background 深近黑 #0F0F12, backgroundSoft 浅一档 #1A1A1F (跟 light
  ///   的 primary 同色, 视觉对齐 ink edition)
  /// - text 主次三态反相: 主文字 #E6E6EB / 次 #A1A1AA / 灰 #71717A
  /// - line 暗灰 #2A2A2F (对比度足够区分行)
  /// - primary 反相到浅色 #E6E6EB (按钮 / 头像默认色), primarySoft #2A2A2F
  /// - red/blue/orange/green 略调亮 (深底上需要更鲜艳才能凸显)
  /// - 气泡 A 方案 (颠倒明暗): 自己气泡浅灰 gradient + 黑字, 跟 light 下
  ///   黑底白字"颠倒". #D4D4D8 → #C8C8CE 比纯白收一档不刺眼, 仍跳出
  ///   page bg #0F0F12 当焦点. 对方气泡用 backgroundSoft + textPrimary,
  ///   不在这单独字段.
  static const MoyuColorsData _dark = MoyuColorsData(
    primary: Color(0xFFE6E6EB),
    primarySoft: Color(0xFF2A2A2F),
    background: Color(0xFF0F0F12),
    backgroundSoft: Color(0xFF1A1A1F),
    textPrimary: Color(0xFFE6E6EB),
    textSecondary: Color(0xFFA1A1AA),
    textTertiary: Color(0xFF71717A),
    line: Color(0xFF2A2A2F),
    red: Color(0xFFFF453A),
    blue: Color(0xFF409CFF),
    orange: Color(0xFFFFA64C),
    green: Color(0xFF30D158),
    bubbleSendBg1: Color(0xFFE4E4E8),
    bubbleSendBg2: Color(0xFFD8D8DC),
    bubbleSendForeground: Color(0xFF1A1A1F),
    // dark 对方气泡 — 比 chat bg backgroundSoft #1A1A1F 浅 2 档, 形成
    // 明显的"气泡浮于 chat bg 之上"层级. 之前 #2A2A2F 跟 chat bg 视觉差
    // 不够 (用户反馈"跟背景一模一样"). #3A3A3F 比 chat bg 浅 ~33 单位,
    // 跟微信 dark 对方气泡视觉相近.
    bubbleReceiveBg: Color(0xFF3A3A3F),
    bubbleReceiveForeground: Color(0xFFE6E6EB),
  );
}

/// 颜色实例数据类 — `MoyuColors.of(context)` 返回它, 让 build 函数读
/// 当前主题对应的 12 色板. 字段名跟 MoyuColors 静态 const 1:1 对应,
/// 调用方语法只多一层 `.of(context)`.
/// 气泡专用三色 (bubbleSendBg1 / bubbleSendBg2 / bubbleSendForeground):
/// 自己消息气泡的渐变 + 字色, 独立暴露因为深色模式需要"颠倒明暗" —
/// light 下 ink 黑 gradient + 白字, dark 下浅灰 gradient + 黑字
/// (深色 page bg 上亮色块跳出, 保持"自己气泡是焦点"的视觉层级).
/// 对方气泡的 bg + 字色 直接复用 backgroundSoft + textPrimary, 不再
/// 单独字段, light/dark 都按 surface tone 走.
class MoyuColorsData {
  const MoyuColorsData({
    required this.primary,
    required this.primarySoft,
    required this.background,
    required this.backgroundSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.line,
    required this.red,
    required this.blue,
    required this.orange,
    required this.green,
    required this.bubbleSendBg1,
    required this.bubbleSendBg2,
    required this.bubbleSendForeground,
    required this.bubbleReceiveBg,
    required this.bubbleReceiveForeground,
  });

  final Color primary;
  final Color primarySoft;
  final Color background;
  final Color backgroundSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color line;
  final Color red;
  final Color blue;
  final Color orange;
  final Color green;

  /// 自己气泡渐变起始色 (左上).
  final Color bubbleSendBg1;

  /// 自己气泡渐变结束色 (右下).
  final Color bubbleSendBg2;

  /// 自己气泡内文字 / icon / waveform 前景色.
  final Color bubbleSendForeground;

  /// 对方气泡底色. light = #F6F6F7 跟 backgroundSoft 一致, dark = #2A2A2F
  /// 浅一档 (跟微信深色对方气泡 ~ #2C2C2E 同款). 独立字段是为了让对方气泡
  /// 可以跟 backgroundSoft / pinned row / settings card 分开调.
  final Color bubbleReceiveBg;

  /// 对方气泡内文字色, 一般跟 textPrimary 同步.
  final Color bubbleReceiveForeground;
}

class MoyuRadii {
  const MoyuRadii._();

  static const card = 16.0;
  static const button = 12.0;
  static const input = 20.0;
  static const avatar = 18.0;
}

/// Dual-layer shadow tokens — contact + ambient — neutral cool gray
/// to preserve the ink discipline (no violet tint).
class MoyuShadows {
  const MoyuShadows._();

  static const card = [
    BoxShadow(color: Color(0x0D0F1116), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x140F1116),
      blurRadius: 24,
      spreadRadius: -8,
      offset: Offset(0, 8),
    ),
  ];

  static const button = [
    BoxShadow(color: Color(0x1A0F1116), blurRadius: 1, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x521A1A1F),
      blurRadius: 16,
      spreadRadius: -4,
      offset: Offset(0, 6),
    ),
  ];
}

class MoyuTheme {
  const MoyuTheme._();

  /// 全 app 系统字体 — 跳出 forui 默认 Inter (x-height 过满, 中文显挤,
  /// emoji 相对 latin 字符显小, 跟微信 / Telegram / iOS native 视觉差距大).
  /// 上一版用 'PingFang SC' 没生效, 怀疑 Flutter on iOS 对苹方 family name
  /// 解析问题 fallback 回 default. 改用 '.SF UI Text' (iOS 系统 UI 字体的
  /// internal name, Flutter 官方文档明确支持), 中文走系统 PingFang 自动
  /// fallback chain, emoji 走 Apple Color Emoji 自动 fallback.
  /// Android 上 '.SF UI Text' 找不到 → Flutter 自动 fallback 到 Roboto +
  /// Noto Sans CJK, 跟 iOS 视觉接近.
  static FTypography _systemTypography() =>
      FTypography(fontFamily: '.SF UI Text');

  /// Light FThemeData — 主品牌 ink-edition, MoyuColors hardcode 跟它对齐.
  static FThemeData forui() {
    final colors = FThemes.zinc.light.touch.colors.copyWith(
      primary: MoyuColors.primary,
      primaryForeground: Colors.white,
      secondary: MoyuColors.backgroundSoft,
      secondaryForeground: MoyuColors.textPrimary,
      muted: MoyuColors.backgroundSoft,
      mutedForeground: MoyuColors.textTertiary,
      foreground: MoyuColors.textPrimary,
      background: MoyuColors.background,
      card: MoyuColors.background,
      border: MoyuColors.line,
      error: MoyuColors.red,
      errorForeground: Colors.white,
    );

    return FThemeData(
      colors: colors,
      typography: _systemTypography(),
      tappableStyle: FTappableStyle(motion: FTappableMotion.none),
      touch: true,
      debugLabel: 'Moyu Ink Light Touch',
    );
  }

  /// Dark FThemeData — 基础设施只覆盖 FTheme / Material 内置颜色, MoyuColors
  /// 的 608 处 hardcode 还需要后续重构成 .of(context) 才会真正变深, 这里
  /// 仅打通 MaterialApp.themeMode / status bar / forui FCard 等 forui 自己
  /// 渲染的部分.
  static FThemeData foruiDark() {
    final colors = FThemes.zinc.dark.touch.colors.copyWith(
      primary: const Color(0xFFE6E6EB),
      primaryForeground: const Color(0xFF1A1A1F),
      error: MoyuColors.red,
      errorForeground: Colors.white,
    );

    return FThemeData(
      colors: colors,
      typography: _systemTypography(),
      tappableStyle: FTappableStyle(motion: FTappableMotion.none),
      touch: true,
      debugLabel: 'Moyu Ink Dark Touch',
    );
  }
}
