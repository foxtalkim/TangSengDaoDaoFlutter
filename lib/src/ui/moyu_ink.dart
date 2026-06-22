import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../settings/bubble_color_controller.dart';
import '../settings/bubble_color_store.dart';
import 'moyu_theme.dart';

/// Ink Edition design tokens for the Moyu shell.
/// Brand color flips from violet to ink-black; red is reserved for unread
/// badges only; shadows are neutral cool gray instead of violet-tinted.
class MoyuInk {
  const MoyuInk._();

  // ============ COLORS ============
  static const primary1 = Color(0xFF1A1A1F);
  static const primary2 = Color(0xFF2A2A2F);
  static const bg = Color(0xFFFFFFFF);
  static const bgSoft = Color(0xFFF6F6F7);
  static const text1 = Color(0xFF1A1A1F);
  static const text2 = Color(0xFF6B6B73);
  static const text3 = Color(0xFF9B9BA3);
  static const line = Color(0xFFECECEE);
  static const red = Color(0xFFFF3B30);
  static const blue = Color(0xFF3478F6);
  static const orange = Color(0xFFF0883A);
  static const green = Color(0xFF34C759);

  // ============ GRADIENT ============
  /// Light ink 渐变 (兼容旧调用方). 自己气泡 / 头像 fallback 等用. 深色
  /// 模式下气泡专用 → bubbleSendGradientOf(context). 头像 fallback 还是
  /// 用这个静态值 (avatar gradient 跟主题无关).
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary1, primary2],
  );

  /// 自己气泡渐变 — 用户在外观 → 聊天颜色 swatch 选的预设
  /// (ink/purple/green/blue/orange/pink), 配合 light/dark brightness 算
  /// gradient 两端色. ink 是 A 方案颠倒明暗 (light 黑灰 / dark 浅灰), 其他
  /// 颜色是单色 (bg1==bg2 gradient 退化纯色).
  ///
  /// 调用方: `BoxDecoration(gradient: MoyuInk.bubbleSendGradientOf(ctx))`.
  /// 配套字色: `MoyuInk.bubbleSendForegroundOf(ctx)` (不要再用 MoyuColors.of
  /// .bubbleSendForeground, 那个跟着 primary 反相, 不跟 swatch 颜色变).
  static LinearGradient bubbleSendGradientOf(BuildContext context) {
    final colors = BubbleColorStore.colorsFor(
      BubbleColorController.of(context).current,
      Theme.of(context).brightness,
    );
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [colors.bg1, colors.bg2],
    );
  }

  /// 自己气泡前景色 (字 / icon / waveform / progress). 跟 bg swatch 联动
  /// 反相对比保证可读. light 模式下彩色 bg → 白字; dark 模式下彩色 bg
  /// (浅一档) → 黑字. ink 模式跟 light/dark 颠倒明暗一致.
  static Color bubbleSendForegroundOf(BuildContext context) {
    return BubbleColorStore.colorsFor(
      BubbleColorController.of(context).current,
      Theme.of(context).brightness,
    ).foreground;
  }

  // ============ RADIUS ============
  static const radiusCard = 16.0;
  static const radiusButton = 12.0;
  static const radiusInput = 20.0;

  // ============ SHADOWS ============
  static const shadowCard = <BoxShadow>[
    BoxShadow(color: Color(0x0D0F1116), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x140F1116),
      blurRadius: 24,
      spreadRadius: -8,
      offset: Offset(0, 8),
    ),
  ];

  static const shadowCardLg = <BoxShadow>[
    BoxShadow(color: Color(0x0F0F1116), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x1F0F1116),
      blurRadius: 40,
      spreadRadius: -12,
      offset: Offset(0, 16),
    ),
  ];

  static const shadowButton = <BoxShadow>[
    BoxShadow(color: Color(0x1A0F1116), blurRadius: 1, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x521A1A1F),
      blurRadius: 16,
      spreadRadius: -4,
      offset: Offset(0, 6),
    ),
  ];

  static const shadowPhone = <BoxShadow>[
    BoxShadow(color: Color(0x1F0F1116), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(
      color: Color(0x330F1116),
      blurRadius: 48,
      spreadRadius: -12,
      offset: Offset(0, 24),
    ),
  ];

  // ============ GLASS (frosted) ============
  // Light glass — 半透白底, blur 后跟 light page bg 融合.
  static const glass = Color(0xB8FFFFFF); // 0.72
  static const glassStrong = Color(0xD1FFFFFF); // 0.82
  static const glassSoft = Color(0x9EFFFFFF); // 0.62
  static const glassHairline = Color(0x140F1116); // 0.08 black
  // Dark glass — 半透深底 (跟 MoyuColors._dark.background 0x0F0F12 对齐),
  // blur 后跟 dark page bg 融合. 配合 dark scaffold 让 header / tab bar
  // 不显光斑.
  static const glassDark = Color(0xB80F0F12);
  static const glassStrongDark = Color(0xD10F0F12);
  static const glassSoftDark = Color(0x9E0F0F12);
  static const glassHairlineDark = Color(0x33FFFFFF); // 0.2 white
  static const glassBlurSigma = 24.0;

  /// 根据当前 Theme.brightness 返回 glass tint. MoyuGlass / MoyuTabBar
  /// 等用这个让顶/底栏跟随主题. 调用方有 BuildContext 时用这个,
  /// 否则保留静态 MoyuInk.glass (light 兜底).
  static Color glassOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? glassDark : glass;

  static Color glassHairlineOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? glassHairlineDark
      : glassHairline;
}

/// 24-icon moyu icon set, line vs fill state.
enum MoyuIconName {
  back,
  bell,
  bookmark,
  camera,
  close,
  comment,
  contacts,
  discover,
  emoji,
  eye,
  like,
  lock,
  me,
  message,
  more,
  plus,
  qr,
  right,
  search,
  send,
  settings,
  share,
  star,
  voice,
}

extension MoyuIconNameAssetPath on MoyuIconName {
  String get assetBase => switch (this) {
    MoyuIconName.back => 'back',
    MoyuIconName.bell => 'bell',
    MoyuIconName.bookmark => 'bookmark',
    MoyuIconName.camera => 'camera',
    MoyuIconName.close => 'close',
    MoyuIconName.comment => 'comment',
    MoyuIconName.contacts => 'contacts',
    MoyuIconName.discover => 'discover',
    MoyuIconName.emoji => 'emoji',
    MoyuIconName.eye => 'eye',
    MoyuIconName.like => 'like',
    MoyuIconName.lock => 'lock',
    MoyuIconName.me => 'me',
    MoyuIconName.message => 'message',
    MoyuIconName.more => 'more',
    MoyuIconName.plus => 'plus',
    MoyuIconName.qr => 'qr',
    MoyuIconName.right => 'right',
    MoyuIconName.search => 'search',
    MoyuIconName.send => 'send',
    MoyuIconName.settings => 'settings',
    MoyuIconName.share => 'share',
    MoyuIconName.star => 'star',
    MoyuIconName.voice => 'voice',
  };
}

/// Renders one of the 24 Moyu icons as an SVG.
class MoyuIcon extends StatelessWidget {
  const MoyuIcon(
    this.name, {
    super.key,
    this.filled = false,
    this.size = 24,
    this.color,
    this.semanticsLabel,
  });

  final MoyuIconName name;
  final bool filled;
  final double size;
  final Color? color;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final state = filled ? 'fill' : 'line';
    final tint =
        color ?? DefaultTextStyle.of(context).style.color ?? MoyuInk.text1;
    final asset = 'assets/icons/moyu/ic-${name.assetBase}-$state.svg';
    final isDiscoverFill = filled && name == MoyuIconName.discover;
    final palette = MoyuColors.of(context);
    final iconTint =
        isDiscoverFill && Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFFFFFFF)
        : tint;
    // Line variants use only `currentColor` strokes, so srcIn safely tints
    // the whole glyph. Fill variants embed explicit `#fff` cutouts (e.g.
    // the compass needle on ic-discover-fill). Recoloring with srcIn would
    // collapse them into a flat silhouette, so fills use currentColor; the
    // discover fill additionally maps its white compass to the current
    // surface color, making it read as a cutout in light and dark themes.
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: filled ? null : ColorFilter.mode(iconTint, BlendMode.srcIn),
      theme: filled ? SvgTheme(currentColor: iconTint) : null,
      colorMapper: isDiscoverFill
          ? _MoyuDiscoverFillColorMapper(palette.background)
          : null,
      semanticsLabel: semanticsLabel,
    );
  }
}

class _MoyuDiscoverFillColorMapper extends ColorMapper {
  const _MoyuDiscoverFillColorMapper(this.cutoutColor);

  final Color cutoutColor;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (elementName == 'path' &&
        attributeName == 'fill' &&
        color == const Color(0xFFFFFFFF)) {
      return cutoutColor;
    }
    return color;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MoyuDiscoverFillColorMapper && other.cutoutColor == cutoutColor;

  @override
  int get hashCode => cutoutColor.hashCode;
}

/// Frosted-glass surface — translucent fill + 24-sigma backdrop blur +
/// 0.5px hairline border. Used for status bars, navigation panels, banners.
class MoyuGlass extends StatelessWidget {
  const MoyuGlass({
    super.key,
    required this.child,
    this.tint,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(MoyuInk.radiusCard),
    ),
    this.padding,
    this.showHairline = true,
  });

  final Widget child;

  /// 自定义 tint, null 时按 Theme.brightness 自动选 glass / glassDark.
  /// 调用方一般留 null, 让 widget 自动跟随主题 — 顶部 nav / tab bar /
  /// banner 等深色下自动变深玻璃.
  final Color? tint;
  final BorderRadius borderRadius;
  final EdgeInsets? padding;
  final bool showHairline;

  @override
  Widget build(BuildContext context) {
    final effectiveTint = tint ?? MoyuInk.glassOf(context);
    final hairlineColor = MoyuInk.glassHairlineOf(context);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: MoyuInk.glassBlurSigma,
          sigmaY: MoyuInk.glassBlurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveTint,
            borderRadius: borderRadius,
            border: showHairline
                ? Border.all(color: hairlineColor, width: 0.5)
                : null,
          ),
          child: padding == null
              ? child
              : Padding(padding: padding!, child: child),
        ),
      ),
    );
  }
}

/// Ink-edition shadow tokens, exposed as [BoxShadow] lists for use in
/// `BoxDecoration` and `ShapeDecoration`.
class MoyuInkShadows {
  const MoyuInkShadows._();

  static const card = MoyuInk.shadowCard;
  static const cardLarge = MoyuInk.shadowCardLg;
  static const button = MoyuInk.shadowButton;
  static const phone = MoyuInk.shadowPhone;
}
