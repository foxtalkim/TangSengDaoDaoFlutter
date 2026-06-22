import 'dart:developer' as developer;
import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import 'moyu_ink.dart';
import 'moyu_directionality.dart';
import 'moyu_theme.dart';
import 'models/contact_models.dart';

export 'moyu_directionality.dart';

class MoyuGradientText extends StatelessWidget {
  const MoyuGradientText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          MoyuColors.of(context).primary,
          MoyuColors.of(context).primarySoft,
        ],
      ).createShader(bounds),
      child: Text(text, style: style),
    );
  }
}

class MoyuBrandMark extends StatelessWidget {
  const MoyuBrandMark({super.key, this.size = 54});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MoyuColors.of(context).primary,
            MoyuColors.of(context).primarySoft,
          ],
        ),
        boxShadow: MoyuShadows.button,
      ),
      alignment: Alignment.center,
      child: Text(
        '墨',
        style: TextStyle(
          color: MoyuColors.of(context).background,
          fontSize: size * 0.46,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MoyuPageHeader extends StatelessWidget {
  const MoyuPageHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.onTitleDoubleTap,
  });

  final String title;
  final List<Widget> actions;
  final VoidCallback? onTitleDoubleTap;

  static const double _paddingTop = 8;
  static const double _paddingBottom = 12;

  /// Header 内容总高。body 列表的 top inset 必须引用这个值，避免 header
  /// padding 改了但列表仍用旧魔法数导致首行压进顶部玻璃。
  static const double contentHeight = _paddingTop + _rowHeight + _paddingBottom;

  /// 锁死的 Row 高度。让 4 个 tab 标题 Y 位置完全一致，不受 actions
  /// 是否存在影响。值 = MoyuRoundIconButton (FButton.icon md = 40) +
  /// 上下小内边距，确保 action icon 完整显示且标题 vertical center。
  static const double _rowHeight = 44;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, _paddingTop, 16, _paddingBottom),
      child: SizedBox(
        height: _rowHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onDoubleTap: onTitleDoubleTap,
                behavior: HitTestBehavior.translucent,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.42,
                      color: MoyuColors.of(context).textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}

class MoyuRoundIconButton extends StatelessWidget {
  const MoyuRoundIconButton({
    super.key,
    this.icon,
    this.moyuIcon,
    this.filled = false,
    required this.tooltip,
    this.onPressed,
  }) : assert(
         icon != null || moyuIcon != null,
         'Provide either icon or moyuIcon',
       );

  final IconData? icon;
  final MoyuIconName? moyuIcon;
  final bool filled;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final glyph = moyuIcon != null
        ? MoyuIcon(
            moyuIcon!,
            filled: filled,
            size: 22,
            color: MoyuColors.of(context).textPrimary,
          )
        : Icon(icon, size: 22, color: MoyuColors.of(context).textPrimary);
    return FTooltip(
      tipBuilder: (_, _) => Text(tooltip),
      child: FButton.icon(
        variant: FButtonVariant.ghost,
        size: FButtonSizeVariant.md,
        onPress: onPressed,
        child: glyph,
      ),
    );
  }
}

/// 顶栏右上 "完成 / 保存 / 发送" 用的纯文字按钮。
/// DESIGN.md §6：禁止把 `FButton.filled` 黑块塞在 56pt nav 里。
/// 这个 widget 是唯一允许的 nav trailing 纯文字交互。
/// - 字 15pt w500 letterSpacing -0.08，颜色 primary（黑），danger=true 时 red
/// - **无 bg / 无 border / 无 radius**，就是纯文字按钮
/// - 点击区 ≥ 44x44（a11y），但视觉只是文字
/// - pressed: opacity 0.55
/// - disabled (onPressed==null): opacity 0.35，不响应点击
class MoyuTextButton extends StatelessWidget {
  const MoyuTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// 仅"放弃 / 删除 / 退出"等危险动作 = true，文字 red。常规 完成/保存
  /// 用 false。
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final color = danger
        ? MoyuColors.of(context).red
        : MoyuColors.of(context).primary;
    final text = Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.08,
        color: color.withValues(alpha: enabled ? 1.0 : 0.35),
      ),
    );
    if (!enabled) {
      // 不响应点击；保留 tap area 让布局稳定
      return Container(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: text,
      );
    }
    return FTappable(
      onPress: onPressed,
      behavior: HitTestBehavior.opaque,
      builder: (context, states, child) {
        final pressed = states.contains(FTappableVariant.pressed);
        return Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Opacity(opacity: pressed ? 0.55 : 1.0, child: child),
        );
      },
      child: text,
    );
  }
}

/// 页面底部主 CTA 按钮 — '发送' / '添加到通讯录' / '发消息' / '登录' 等。
/// DESIGN.md §6：所有 page-bottom 主 CTA 一律走这个 widget。规格：
/// - 高度 48
/// - 圆角 [MoyuRadii.button] = 12
/// - 背景 [MoyuColors.of(context).primary]（黑 #1A1A1F），pressed [MoyuColors.of(context).primarySoft]
/// - 文字 15pt w600 letterSpacing -0.08 白色
/// - full-width（外部 wrap Padding(horizontal: 16) 给左右 margin）
/// - disabled (onPressed == null 或 loading == true) opacity 0.35
/// - 可选 prefix icon（如 messageCircle）—— 默认 size 18 白色
class MoyuPrimaryButton extends StatelessWidget {
  const MoyuPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingLabel,
    this.prefixIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  /// loading=true 时显示的替代文字（如 '发送中…'）。null 则继续显示
  /// label 但按钮不响应点击。
  final String? loadingLabel;

  /// 可选前置 icon（FIcons.xxx），文字左侧。
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = !loading && onPressed != null;
    final displayLabel = loading && loadingLabel != null
        ? loadingLabel!
        : label;
    // primary button 字 / icon 用 bubbleSendForeground (primary 反相色):
    // light primary 黑 → 白; dark primary 浅 → 黑. background 字段 dark=#0F0F12
    // 比 bubbleSendForeground dark=#1A1A1F 更深, 在浅底按钮上对比度略低,
    // 用 bubbleSendForeground 更准.
    final fg = MoyuColors.of(context).bubbleSendForeground;
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: 18, color: fg),
          const SizedBox(width: 6),
        ],
        Text(
          displayLabel,
          style: TextStyle(
            color: fg,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.08,
          ),
        ),
      ],
    );
    return FTappable(
      onPress: enabled ? onPressed : null,
      behavior: HitTestBehavior.opaque,
      builder: (context, states, child) {
        final pressed = states.contains(FTappableVariant.pressed);
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: pressed && enabled
                ? MoyuColors.of(context).primarySoft
                : MoyuColors.of(
                    context,
                  ).primary.withValues(alpha: enabled ? 1.0 : 0.35),
            borderRadius: BorderRadius.circular(MoyuRadii.button),
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: content,
    );
  }
}

/// 页面底部次级 CTA 按钮 — 登录页的“注册”等。
/// 规格跟主按钮同高同圆角，但白底 + hairline border + primary 文本，
/// 用来承接非主路径动作，避免 ghost 文案按钮在底部显得轻飘。
class MoyuSecondaryButton extends StatelessWidget {
  const MoyuSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.prefixIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final colors = MoyuColors.of(context);
    final fg = colors.primary.withValues(alpha: enabled ? 1.0 : 0.35);
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: 18, color: fg),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.08,
          ),
        ),
      ],
    );
    return FTappable(
      onPress: onPressed,
      behavior: HitTestBehavior.opaque,
      builder: (context, states, child) {
        final pressed = states.contains(FTappableVariant.pressed);
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: pressed && enabled
                ? colors.backgroundSoft
                : colors.background,
            border: Border.all(
              color: colors.line.withValues(alpha: enabled ? 1.0 : 0.45),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MoyuRadii.button),
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: content,
    );
  }
}

/// 页面底部危险 CTA 按钮 — '退出群聊' / '解散群聊' / '注销账号' 等。
/// DESIGN.md §6：page-bottom 危险按钮 = ghost (white bg) + 1px red border
/// + red 文字 15 w600 letterSpacing -0.08。**不**整个按钮染红 (那样太凶)。
/// - 高度 48
/// - 圆角 [MoyuRadii.button] = 12
/// - 白底，1pt [MoyuColors.of(context).red] border
/// - 文字 15 w600 [MoyuColors.of(context).red]
/// - pressed: bg 切 [MoyuColors.of(context).red].withValues(alpha: 0.06)
/// - disabled (onPressed == null) opacity 0.35
class MoyuDangerButton extends StatelessWidget {
  const MoyuDangerButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final text = Text(
      label,
      style: TextStyle(
        color: MoyuColors.of(
          context,
        ).red.withValues(alpha: enabled ? 1.0 : 0.35),
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.08,
      ),
    );
    return FTappable(
      onPress: onPressed,
      behavior: HitTestBehavior.opaque,
      builder: (context, states, child) {
        final pressed = states.contains(FTappableVariant.pressed);
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: pressed && enabled
                ? MoyuColors.of(context).red.withValues(alpha: 0.06)
                : Colors.white,
            border: Border.all(
              color: MoyuColors.of(
                context,
              ).red.withValues(alpha: enabled ? 1.0 : 0.35),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(MoyuRadii.button),
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: text,
    );
  }
}

/// 二级页面统一 nav header — chevron-left + 居中标题 + trailing slot。
/// DESIGN.md §4.B：全 App 二级页面唯一允许的 header 内层组件。配合
/// `_DetailScaffold` 的 Stack+Positioned(top:0)+MoyuGlass 外壳形成
/// "通顶 + sticky" 视觉。
/// - 高度 56pt（不含状态栏；MoyuGlass+SafeArea 在外壳层处理状态栏 inset）
/// - 左：MoyuRoundIconButton chevronLeft，默认 Navigator.pop
/// - 中：标题 16pt w600 letterSpacing -0.16，居中
/// - 右：trailing slot；传 MoyuTextButton（完成/保存）或
///   MoyuRoundIconButton（单 icon）。空则空着。
class MoyuDetailHeader extends StatelessWidget {
  const MoyuDetailHeader({
    super.key,
    required this.title,
    this.trailing,
    this.showBack = true,
    this.onBack,
    this.onTitleDoubleTap,
  });

  final String title;
  final Widget? trailing;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onTitleDoubleTap;

  static const double height = 56;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // 居中标题：用 Center + Padding 给左右各让出 64pt 给 chevron/trailing，
          // 避免长标题盖住按钮
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64),
            // 占位，真正 title 在下面 Center 里画——这样它不会被 chevron 推偏
          ),
          Center(
            child: GestureDetector(
              onDoubleTap: onTitleDoubleTap,
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                    color: MoyuColors.of(context).textPrimary,
                  ),
                ),
              ),
            ),
          ),
          // 左：返回
          if (showBack)
            PositionedDirectional(
              start: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: MoyuRoundIconButton(
                  icon: moyuBackChevronIcon(context),
                  tooltip: AppLocalizations.of(context).actionBack,
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                ),
              ),
            ),
          // 右：trailing slot
          if (trailing != null)
            PositionedDirectional(
              end: 8,
              top: 0,
              bottom: 0,
              child: Center(child: trailing!),
            ),
        ],
      ),
    );
  }
}

class MoyuSegmented extends StatelessWidget {
  const MoyuSegmented({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onChanged,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: MoyuColors.of(context).backgroundSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: FTappable(
                  selected: i == selectedIndex,
                  onPress: onChanged == null ? null : () => onChanged!(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // selected segment "浮"于 backgroundSoft 容器之上:
                      // light = 白色; dark = #2A2A2F (比 backgroundSoft
                      // #1A1A1F 浅一档, 跟 iOS segmented control dark
                      // selected ~ #38383A 同模式).
                      color: i == selectedIndex
                          ? (Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2A2A2F)
                                : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: i == selectedIndex
                          ? const [
                              BoxShadow(
                                color: Color(0x0F000000),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      items[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: i == selectedIndex
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: i == selectedIndex
                            ? MoyuColors.of(context).textPrimary
                            : MoyuColors.of(context).textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// MoyuSearchBar 已删除（DESIGN.md §6.5）：tab 列表顶部不再 inline 假
// 搜索条，搜索入口只走 header 右上 MoyuRoundIconButton。

class MoyuReadOnlyField extends StatelessWidget {
  const MoyuReadOnlyField({
    super.key,
    required this.text,
    this.prefix,
    this.suffix,
  });

  final String text;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return FTextField(
      style: FTextFieldStyleDelta.delta(
        color: FVariants.all(MoyuColors.of(context).backgroundSoft),
      ),
      hint: text,
      readOnly: true,
      canRequestFocus: false,
      showCursor: false,
      prefixBuilder: prefix == null
          ? null
          : (context, style, variants) =>
                FTextField.prefixIconBuilder(context, style, variants, prefix!),
      suffixBuilder: suffix == null
          ? null
          : (context, style, variants) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: IconTheme(
                data: style.iconStyle.resolve(variants),
                child: suffix!,
              ),
            ),
    );
  }
}

class MoyuOtpCodeField extends StatefulWidget {
  const MoyuOtpCodeField({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  State<MoyuOtpCodeField> createState() => _MoyuOtpCodeFieldState();
}

class _MoyuOtpCodeFieldState extends State<MoyuOtpCodeField> {
  late final FocusNode _focusNode;

  int get length => widget.length;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleTextChanged);
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant MoyuOtpCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChanged);
      widget.controller.addListener(_handleTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) {
      setState(() {});
    }
    final code = widget.controller.text;
    if (code.length == length) {
      widget.onCompleted?.call(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    final code = widget.controller.text;
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            for (var i = 0; i < length; i++) ...[
              Expanded(
                child: FTappable(
                  onPress: () => _focusNode.requestFocus(),
                  builder: (context, states, child) {
                    final active = _focusNode.hasFocus && i == code.length;
                    final filled = i < code.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: filled
                            ? colors.background
                            : colors.backgroundSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: active || filled
                              ? colors.primary
                              : colors.line,
                          width: active ? 1.8 : 1,
                        ),
                      ),
                      child: Text(
                        filled ? code[i] : '',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (i != length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: Opacity(
              opacity: 0.01,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(length),
                ],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 1),
                cursorColor: Colors.transparent,
                showCursor: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AvatarResolver {
  const AvatarResolver._();

  static String user({
    required AppConfig? config,
    required String uid,
    String imageUrl = '',
  }) {
    final resolved = normalize(config, imageUrl);
    if (resolved.isNotEmpty) return resolved;
    final path = userPath(uid);
    if (path.isEmpty || config == null) return '';
    return config.showUrl(path);
  }

  static String group({
    required AppConfig? config,
    required String groupNo,
    String imageUrl = '',
  }) {
    final resolved = normalize(config, imageUrl);
    if (resolved.isNotEmpty) return resolved;
    final path = groupPath(groupNo);
    if (path.isEmpty || config == null) return '';
    return config.showUrl(path);
  }

  static String userPath(String uid) {
    final id = uid.trim();
    return id.isEmpty ? '' : 'users/$id/avatar';
  }

  static String groupPath(String groupNo) {
    final no = groupNo.trim();
    return no.isEmpty ? '' : 'groups/$no/avatar';
  }

  static String contact(UiContact contact, {AppConfig? config}) {
    return user(config: config, uid: contact.uid, imageUrl: contact.avatarPath);
  }

  static String normalize(AppConfig? config, String value) {
    final raw = value.trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return config == null ? raw : config.showUrl(raw);
  }
}

class MoyuResolvedAvatar extends StatelessWidget {
  const MoyuResolvedAvatar.raw({
    super.key,
    required this.label,
    this.size = 48,
    this.colors = const [MoyuColors.primary, MoyuColors.primarySoft],
    this.online = false,
    this.imageUrl = '',
  });

  factory MoyuResolvedAvatar.user({
    Key? key,
    required AppConfig? config,
    required String uid,
    required String name,
    double size = 48,
    List<Color> colors = const [MoyuColors.primary, MoyuColors.primarySoft],
    bool online = false,
    String imageUrl = '',
  }) {
    return MoyuResolvedAvatar.raw(
      key: key,
      label: name,
      size: size,
      colors: colors,
      online: online,
      imageUrl: AvatarResolver.user(
        config: config,
        uid: uid,
        imageUrl: imageUrl,
      ),
    );
  }

  factory MoyuResolvedAvatar.group({
    Key? key,
    required AppConfig? config,
    required String groupNo,
    required String name,
    double size = 48,
    List<Color> colors = const [MoyuColors.primary, MoyuColors.primarySoft],
    bool online = false,
    String imageUrl = '',
  }) {
    return MoyuResolvedAvatar.raw(
      key: key,
      label: name,
      size: size,
      colors: colors,
      online: online,
      imageUrl: AvatarResolver.group(
        config: config,
        groupNo: groupNo,
        imageUrl: imageUrl,
      ),
    );
  }

  factory MoyuResolvedAvatar.contact({
    Key? key,
    required UiContact contact,
    AppConfig? config,
    double size = 48,
  }) {
    return MoyuResolvedAvatar.raw(
      key: key,
      label: contact.avatarLabel,
      size: size,
      colors: contact.colors,
      online: contact.online,
      imageUrl: AvatarResolver.contact(contact, config: config),
    );
  }

  final String label;
  final double size;
  final List<Color> colors;
  final bool online;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return MoyuAvatar(
      label: label.trim().isEmpty ? '·' : label,
      size: size,
      colors: colors,
      online: online,
      imageUrl: imageUrl,
    );
  }
}

class MoyuAvatar extends StatefulWidget {
  const MoyuAvatar({
    super.key,
    required this.label,
    this.size = 48,
    this.colors = const [MoyuColors.primary, MoyuColors.primarySoft],
    this.online = false,
    this.presenceColor,
    this.imageUrl,
  });

  final String label;
  final double size;
  final List<Color> colors;
  final bool online;
  final Color? presenceColor;
  final String? imageUrl;

  @override
  State<MoyuAvatar> createState() => _MoyuAvatarState();
}

class _MoyuAvatarState extends State<MoyuAvatar> {
  // iOS 真机偶发首请求失败 (dart:io HttpClient stale connection / DNS slow)
  // 对齐 iOS 原版 SDWebImage retry-once 行为: 失败一次 evict cache + 重建
  // widget 触发一次重试. 第二次还失败才显默认头像 PNG.
  int _retry = 0;

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final imageUrl = widget.imageUrl;
    final dotSize = (size * 0.25).clamp(10.0, 14.0);
    final presenceColor = widget.presenceColor;
    final hasRemote = imageUrl != null && imageUrl.trim().isNotEmpty;
    // 方角圆角对齐微信头像观感: cornerRadius ≈ size * 0.18 (size 48 →
    // ~8.6pt, size 32 → ~5.7pt, size 60 → ~10.8pt — 在微信/飞书的
    // 12-18% range 内, 视觉上不像 ClipOval 那么圆, 又比直角软).
    final radius = BorderRadius.circular(size * 0.18);
    // iOS 原版 placeholder/error 都用 Common/Index/DefaultAvatar PNG (灰
    // 色剪影). Flutter 端用 assets/avatar.png 同款 — 偶发网络失败用户看到
    // 的是默认头像而不是色块, 体感跟 iOS 一致.
    final defaultAvatar = Image.asset(
      'assets/avatar.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
    final fallback = ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: size, height: size, child: defaultAvatar),
    );
    final base = hasRemote
        ? ClipRRect(
            borderRadius: radius,
            child: SizedBox(
              width: size,
              height: size,
              child: CachedNetworkImage(
                // retry 计数变 → key 变 → widget 重建 → 重发请求
                key: ValueKey('$imageUrl#$_retry'),
                imageUrl: imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (_, _) => defaultAvatar,
                errorWidget: (_, url, error) {
                  final host = Uri.tryParse(url)?.host ?? '?';
                  // 走 dart:developer.log → iOS os_log → idevicesyslog 在 release
                  // 模式也能抓到. debugPrint 在 release 被 strip 看不见.
                  developer.log(
                    '[avatar] FAIL host=$host retry=$_retry '
                    'errorType=${error.runtimeType} error=$error url=$url',
                    name: 'foxtalk.avatar',
                  );
                  if (_retry < 1) {
                    // 失败一次 → evict + 重建触发一次重试
                    Future.microtask(() async {
                      await CachedNetworkImage.evictFromCache(url);
                      if (mounted) setState(() => _retry++);
                    });
                  }
                  return defaultAvatar;
                },
              ),
            ),
          )
        : fallback;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          base,
          if (presenceColor != null || widget.online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: presenceColor ?? MoyuColors.of(context).green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 10 avatar gradient presets keyed by `index % 10`, mirroring the
/// `.av-1`...`.av-10` classes in the Ink Edition mockup.
class MoyuAvatarGradients {
  const MoyuAvatarGradients._();

  static const List<List<Color>> palette = [
    [Color(0xFFFFB199), Color(0xFFFF6E7F)],
    [Color(0xFF1A1A1F), Color(0xFF2A2A2F)],
    [Color(0xFF4FACFE), Color(0xFF00C2FE)],
    [Color(0xFFFAD961), Color(0xFFF76B1C)],
    [Color(0xFF43E97B), Color(0xFF38C7BC)],
    [Color(0xFFFA709A), Color(0xFFFEC768)],
    [Color(0xFFA18CD1), Color(0xFFC9A6F0)],
    [Color(0xFF5B7AEA), Color(0xFF8A50C7)],
    [Color(0xFFF093FB), Color(0xFFE55C7A)],
    [Color(0xFFFFC8A2), Color(0xFFE58273)],
  ];

  static List<Color> at(int index) => palette[index.abs() % palette.length];
}

/// Inherited hint planted at the top of `_DetailScaffold` so any
/// `MoyuSection` / `MoyuDivider` rendered inside a detail sub-page
/// automatically switches to iOS-grouped-list flat style (full-bleed
/// white + 12px gray gap between blocks + 16-indent hairline divider).
/// Tab pages (Messages / Contacts / Discover / Me) sit outside the
/// `_DetailScaffold` tree so they keep the legacy card chrome.
class MoyuSettingsFlat extends InheritedWidget {
  const MoyuSettingsFlat({super.key, required super.child});

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MoyuSettingsFlat>() != null;

  @override
  bool updateShouldNotify(MoyuSettingsFlat oldWidget) => false;
}

class MoyuSection extends StatelessWidget {
  const MoyuSection({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (MoyuSettingsFlat.of(context)) {
      // iOS UITableViewStyleGrouped: 12px gray gap above + full-bleed
      // white panel below. Stacks naturally when multiple sections sit
      // back-to-back inside a `_DetailScaffold`.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 12, color: MoyuColors.of(context).backgroundSoft),
          Container(
            // light = #FFFFFF, dark = #0F0F12 (跟 page bg 一致, 让 row
            // 内文字 dynamic textPrimary 在深底上可读).
            color: MoyuColors.of(context).background,
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: FCard.raw(
        child: Padding(
          padding: padding,
          child: Column(children: children),
        ),
      ),
    );
  }
}

class MoyuDivider extends StatelessWidget {
  const MoyuDivider({super.key, this.indent = 68, this.background});

  final double indent;

  /// Optional background painted behind the divider. Used by the
  /// conversation list to fill the indent gap between two adjacent
  /// pinned tiles with the pinned highlight color — otherwise the
  /// 0.5px hairline divider area shows the ListView's white through
  /// the indent and reads as a "white line at the avatar position"
  /// breaking the pinned block visually.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    // In flat mode the divider sits inside a full-bleed white panel
    // and should align with the row gutter (16) instead of the legacy
    // 68 icon-row indent.
    final effectiveIndent = MoyuSettingsFlat.of(context) ? 16.0 : indent;
    final divider = FDivider(
      style: FDividerStyle(
        color: MoyuColors.of(context).line,
        padding: EdgeInsetsDirectional.only(start: effectiveIndent),
        width: 0.5,
      ),
    );
    if (background == null) {
      return divider;
    }
    return ColoredBox(color: background!, child: divider);
  }
}

/// WeChat-style function/preference row used by Phone 3 / Phone 5:
/// 56px tall, 38px gradient icon block (10px radius), 15.5px name,
/// optional red round badge + 14px chevron.
class MoyuFunctionRow extends StatelessWidget {
  const MoyuFunctionRow({
    super.key,
    required this.title,
    this.icon,
    this.iconBuilder,
    this.iconColors = const [MoyuColors.primary, MoyuColors.primarySoft],
    this.subtitle,
    this.badge = 0,
    this.trailing,
    this.onTap,
    this.identifier,
  }) : assert(
         icon != null || iconBuilder != null,
         'Provide either icon or iconBuilder',
       );

  final String title;
  final IconData? icon;
  final WidgetBuilder? iconBuilder;
  final List<Color> iconColors;
  final String? subtitle;
  final int badge;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? identifier;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: identifier,
      child: FTappable(
        onPress: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: MoyuColors.of(context).background,
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: iconColors,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: iconBuilder != null
                    ? iconBuilder!(context)
                    : Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.08,
                        color: MoyuColors.of(context).textPrimary,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: MoyuColors.of(context).textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[trailing!, SizedBox(width: 8)],
              if (badge > 0) ...[
                MoyuUnreadBadge(count: badge),
                SizedBox(width: 8),
              ],
              Icon(
                moyuForwardChevronIcon(context),
                color: MoyuColors.of(context).textTertiary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section group container for stacking [MoyuFunctionRow]s with hairlines
/// between them, matching the .wx-group pattern: white card, top margin
/// to separate from the previous group, hairlines indented to the icon edge.
class MoyuRowGroup extends StatelessWidget {
  const MoyuRowGroup({
    super.key,
    required this.children,
    this.topGap = 10,
    this.indent = 68,
  });

  final List<Widget> children;
  final double topGap;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
        rows.add(MoyuDivider(indent: indent));
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: topGap),
      child: ColoredBox(
        color: MoyuColors.of(context).background,
        child: Column(children: rows),
      ),
    );
  }
}

/// Section letter strip used by the contacts page A-Z list.
/// Light background tint, 12/500 tabular text, 0.04em letter-spacing.
class MoyuSectionLetter extends StatelessWidget {
  const MoyuSectionLetter({super.key, required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      // light = #F7F8FA 浅灰, dark = backgroundSoft #1A1A1F. 比 page bg 浅
      // 一档作 letter section header 视觉分组.
      color: MoyuColors.of(context).backgroundSoft,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 12,
          color: MoyuColors.of(context).textTertiary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.48,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// Bottom navigation aligned to the Ink Edition mockup — floating glass dock,
/// 26px icons toggling line/fill, 10px label, ink-black active state.
class MoyuTabBarItemSpec {
  const MoyuTabBarItemSpec({
    required this.icon,
    required this.label,
    this.identifier,
    this.badge = 0,
    this.onDoubleTap,
  });

  final MoyuIconName icon;
  final String label;
  final String? identifier;

  /// 红点未读数, >0 时在 icon 右上显示. 0 不显示. 对齐 iOS
  /// WKConversationListVC.refreshBadge → tabBarItem.badgeValue (排除 mute).
  final int badge;

  /// 双击当前 tab 触发的回调. 对齐 iOS UITabBarController 默认 scrollsToTop
  /// 行为 + 微信/Telegram 同款交互: 在已选中的 tab 上双击 → 列表 animateTo(0).
  /// home_shell 持 GlobalKey<_*PageState> 调对应 page 的 scrollToTop().
  /// 未提供 → 双击 noop, 不影响单击切 tab.
  final VoidCallback? onDoubleTap;
}

enum MoyuTabBarStyle { classic, glassDock }

class MoyuTabBar extends StatefulWidget {
  const MoyuTabBar({
    super.key,
    required this.items,
    required this.index,
    this.style = MoyuTabBarStyle.glassDock,
    this.accentColor,
    this.onChange,
    this.onSearch,
  });

  final List<MoyuTabBarItemSpec> items;
  final int index;
  final MoyuTabBarStyle style;
  final Color? accentColor;
  final ValueChanged<int>? onChange;
  final VoidCallback? onSearch;

  /// Height reserved above the device safe-bottom inset. Tab pages use the
  /// same value for bottom padding, so the overlay never covers the last row.
  static const double reservedHeight = 72;
  static const double _surfaceHeight = 56;

  @override
  State<MoyuTabBar> createState() => _MoyuTabBarState();
}

class _MoyuTabBarState extends State<MoyuTabBar> {
  static const _doubleTapInterval = Duration(milliseconds: 320);

  int? _lastTapIndex;
  DateTime? _lastTapAt;

  void _handleTap(int index) {
    final now = DateTime.now();
    final lastTapAt = _lastTapAt;
    final isSecondTapOnCurrentTab =
        index == widget.index &&
        _lastTapIndex == index &&
        lastTapAt != null &&
        now.difference(lastTapAt) <= _doubleTapInterval;

    _lastTapIndex = index;
    _lastTapAt = now;

    widget.onChange?.call(index);

    if (isSecondTapOnCurrentTab) {
      widget.items[index].onDoubleTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == MoyuTabBarStyle.classic) {
      return _buildClassic(context);
    }
    return _buildGlassDock(context);
  }

  Widget _buildClassic(BuildContext context) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          key: const ValueKey('moyu.classic.tabbar.frame'),
          padding: EdgeInsets.fromLTRB(
            0,
            8,
            0,
            safeBottom == 0 ? 8 : safeBottom,
          ),
          decoration: BoxDecoration(
            color: MoyuColors.of(context).background.withValues(alpha: 0.78),
            border: Border(
              top: BorderSide(color: MoyuColors.of(context).line, width: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.items.length; i++)
                Expanded(
                  child: FTappable(
                    onPress: widget.onChange == null
                        ? null
                        : () => _handleTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Semantics(
                      identifier: widget.items[i].identifier,
                      selected: i == widget.index,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                MoyuIcon(
                                  widget.items[i].icon,
                                  filled: i == widget.index,
                                  size: 26,
                                  color: i == widget.index
                                      ? widget.accentColor ??
                                            MoyuColors.of(context).primary
                                      : MoyuColors.of(context).textTertiary,
                                ),
                                if (widget.items[i].badge > 0)
                                  Positioned(
                                    top: -4,
                                    right: -10,
                                    child: MoyuUnreadBadge(
                                      count: widget.items[i].badge,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.items[i].label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: i == widget.index
                                    ? widget.accentColor ??
                                          MoyuColors.of(context).primary
                                    : MoyuColors.of(context).textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDock(BuildContext context) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      key: const ValueKey('moyu.glass.tabbar.frame'),
      height: MoyuTabBar.reservedHeight + safeBottom,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, safeBottom + 8),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 364),
                  child: _GlassDockSurface(
                    isDark: isDark,
                    child: _GlassDockTabs(
                      index: widget.index,
                      items: widget.items,
                      accentColor: widget.accentColor,
                      onTap: _handleTap,
                      enabled: widget.onChange != null,
                    ),
                  ),
                ),
              ),
              if (widget.onSearch != null) ...[
                const SizedBox(width: 10),
                _GlassDockSearchButton(
                  isDark: isDark,
                  accentColor: widget.accentColor,
                  onSearch: widget.onSearch!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassDockSurface extends StatelessWidget {
  const _GlassDockSurface({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MoyuTabBar._surfaceHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: _glassDockShadow(isDark),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 38, sigmaY: 38),
            child: Container(
              key: const ValueKey('moyu.glass.tabbar.surface'),
              decoration: _glassDockDecoration(isDark),
              child: Stack(
                children: [
                  Positioned.fill(child: _GlassDockHighlight(isDark: isDark)),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassDockTabs extends StatelessWidget {
  const _GlassDockTabs({
    required this.index,
    required this.items,
    this.accentColor,
    required this.onTap,
    required this.enabled,
  });

  final int index;
  final List<MoyuTabBarItemSpec> items;
  final Color? accentColor;
  final ValueChanged<int> onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemCount = items.length;
        final slotWidth = constraints.maxWidth / itemCount;
        const pillInset = 3.0;
        final pillWidth = slotWidth < 92 ? slotWidth - (pillInset * 2) : 90.0;
        final pillLeft = (slotWidth * index) + ((slotWidth - pillWidth) / 2);
        final activeBg =
            accentColor?.withValues(alpha: isDark ? 0.30 : 0.20) ??
            (isDark
                ? Colors.white.withValues(alpha: 0.26)
                : const Color(0xFFB7C0C7));
        return Stack(
          children: [
            AnimatedPositioned(
              key: const ValueKey('moyu.glass.tabbar.selection'),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: pillLeft,
              top: pillInset,
              width: pillWidth,
              height: MoyuTabBar._surfaceHeight - (pillInset * 2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: activeBg,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.12 : 0.06,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: FTappable(
                      onPress: enabled ? () => onTap(i) : null,
                      behavior: HitTestBehavior.opaque,
                      child: Semantics(
                        identifier: items[i].identifier,
                        selected: i == index,
                        child: _MoyuDockTabBarItem(
                          item: items[i],
                          selected: i == index,
                          activeColor: accentColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GlassDockSearchButton extends StatelessWidget {
  const _GlassDockSearchButton({
    required this.isDark,
    this.accentColor,
    required this.onSearch,
  });

  final bool isDark;
  final Color? accentColor;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    return SizedBox(
      width: MoyuTabBar._surfaceHeight,
      height: MoyuTabBar._surfaceHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: _glassDockShadow(isDark),
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 38, sigmaY: 38),
            child: DecoratedBox(
              decoration: _glassDockCircleDecoration(isDark),
              child: GestureDetector(
                key: const ValueKey('moyu.glass.tabbar.search'),
                onTap: onSearch,
                behavior: HitTestBehavior.opaque,
                child: Semantics(
                  identifier: 'moyu.tab.search',
                  button: true,
                  child: Center(
                    child: MoyuIcon(
                      MoyuIconName.search,
                      size: 23,
                      color: accentColor ?? colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassDockHighlight extends StatelessWidget {
  const _GlassDockHighlight({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: isDark ? 0.06 : 0.46),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.50],
        ),
      ),
    );
  }
}

BoxDecoration _glassDockCircleDecoration(bool isDark) {
  return BoxDecoration(
    gradient: _glassDockGradient(isDark),
    shape: BoxShape.circle,
    border: Border.all(
      color: (isDark ? Colors.white : Colors.black).withValues(
        alpha: isDark ? 0.18 : 0.11,
      ),
      width: 0.8,
    ),
  );
}

BoxDecoration _glassDockDecoration(bool isDark) {
  return BoxDecoration(
    gradient: _glassDockGradient(isDark),
    borderRadius: BorderRadius.circular(28),
    border: Border.all(
      color: (isDark ? Colors.white : Colors.black).withValues(
        alpha: isDark ? 0.18 : 0.11,
      ),
      width: 0.8,
    ),
  );
}

LinearGradient _glassDockGradient(bool isDark) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      (isDark ? const Color(0xFF202026) : Colors.white).withValues(
        alpha: isDark ? 0.72 : 0.88,
      ),
      (isDark ? const Color(0xFF18181D) : Colors.white).withValues(
        alpha: isDark ? 0.60 : 0.78,
      ),
      (isDark ? const Color(0xFF232329) : Colors.white).withValues(
        alpha: isDark ? 0.68 : 0.84,
      ),
    ],
    stops: const [0.0, 0.58, 1.0],
  );
}

List<BoxShadow> _glassDockShadow(bool isDark) {
  return [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.42 : 0.22),
      blurRadius: 34,
      spreadRadius: -6,
      offset: const Offset(0, 14),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.12),
      blurRadius: 12,
      spreadRadius: -3,
      offset: const Offset(0, 4),
    ),
  ];
}

class _MoyuDockTabBarItem extends StatelessWidget {
  const _MoyuDockTabBarItem({
    required this.item,
    required this.selected,
    this.activeColor,
  });

  static const double height = 52;

  final MoyuTabBarItemSpec item;
  final bool selected;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    final resolvedActiveColor = activeColor ?? colors.primary;
    final idleColor = colors.textTertiary;
    return Center(
      child: SizedBox(
        width: 82,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 25,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  MoyuIcon(
                    item.icon,
                    filled: selected,
                    size: 23,
                    color: selected ? resolvedActiveColor : idleColor,
                  ),
                  if (item.badge > 0)
                    Positioned(
                      top: -9,
                      right: -14,
                      child: MoyuUnreadBadge(count: item.badge),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                height: 1.0,
                fontWeight: FontWeight.w600,
                color: selected ? resolvedActiveColor : idleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom action sheet — mirrors native iOS `WKActionSheetView2`:
/// optional title, list of buttons (one destructive max), tap to call back
/// then dismiss. Use [MoyuActionSheet.show] for an imperative call.
class MoyuActionSheetItem {
  const MoyuActionSheetItem({
    required this.title,
    required this.onSelected,
    this.destructive = false,
  });

  final String title;
  final VoidCallback onSelected;
  final bool destructive;
}

class MoyuActionSheetChoiceItem<T> {
  const MoyuActionSheetChoiceItem({
    required this.title,
    required this.value,
    this.destructive = false,
  });

  final String title;
  final T value;
  final bool destructive;
}

class MoyuActionSheet {
  const MoyuActionSheet._();

  static Future<void> show(
    BuildContext context, {
    String? title,
    required List<MoyuActionSheetItem> items,
    String cancelLabel = '',
    bool showCancel = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    final selected = await showChoice<int>(
      context,
      title: title,
      items: [
        for (var i = 0; i < items.length; i++)
          MoyuActionSheetChoiceItem<int>(
            title: items[i].title,
            value: i,
            destructive: items[i].destructive,
          ),
      ],
      cancelLabel: cancelLabel.isEmpty
          ? AppLocalizations.of(context).actionCancel
          : cancelLabel,
      showCancel: showCancel,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
    if (selected == null) return;
    items[selected].onSelected();
  }

  static Future<T?> showChoice<T>(
    BuildContext context, {
    String? title,
    required List<MoyuActionSheetChoiceItem<T>> items,
    String cancelLabel = '',
    bool showCancel = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: MoyuColors.of(context).background,
      barrierColor: const Color(0x66000000),
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            // #1 fix: 限制最高 70% 屏高 (不顶到状态栏) + item 列表包进可滚动区,
            // 否则语言这类 ~20 项的 choice sheet 会撑满到顶且无法滑动。
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null && title.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: MoyuColors.of(context).textTertiary,
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: MoyuColors.of(context).line,
                  ),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          _MoyuActionSheetRow(
                            title: items[i].title,
                            destructive: items[i].destructive,
                            onTap: () =>
                                Navigator.of(sheetContext).pop(items[i].value),
                          ),
                          if (i != items.length - 1)
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: MoyuColors.of(context).line,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (showCancel) ...[
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: MoyuColors.of(context).line,
                  ),
                  _MoyuActionSheetRow(
                    title: cancelLabel.isEmpty
                        ? AppLocalizations.of(context).actionCancel
                        : cancelLabel,
                    onTap: () => Navigator.of(sheetContext).pop(),
                    muted: true,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MoyuActionSheetRow extends StatelessWidget {
  const _MoyuActionSheetRow({
    required this.title,
    required this.onTap,
    this.destructive = false,
    this.muted = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool destructive;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? MoyuColors.of(context).red
        : muted
        ? MoyuColors.of(context).textSecondary
        : MoyuColors.of(context).textPrimary;
    return FTappable(
      behavior: HitTestBehavior.opaque,
      onPress: onTap,
      child: SizedBox(
        height: 56,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty state placeholder — centered icon + title + optional subtitle and
/// CTA. Native iOS uses an icon-and-text combo for empty contacts/empty
/// favorites/etc.; this widget standardizes the look.
class MoyuEmptyState extends StatelessWidget {
  const MoyuEmptyState({
    super.key,
    required this.title,
    this.subtitle = '',
    this.icon,
    this.action,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 56, color: MoyuColors.of(context).textTertiary),
              SizedBox(height: 16),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: MoyuColors.of(context).textSecondary,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: MoyuColors.of(context).textTertiary,
                ),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// Lightweight floating toast — mirrors native iOS `WKHud` short flash.
/// Auto-dismisses after [duration]. Stacks on the same overlay.
class MoyuToast {
  const MoyuToast._();

  static OverlayEntry? _current;

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _current?.remove();
    final entry = OverlayEntry(
      builder: (_) => _MoyuToastWidget(message: message),
    );
    Overlay.of(context).insert(entry);
    _current = entry;
    Future.delayed(duration, () {
      if (_current == entry) {
        entry.remove();
        _current = null;
      }
    });
  }
}

class _MoyuToastWidget extends StatelessWidget {
  const _MoyuToastWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: viewInsets + 96),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // Toast bg 两边都固定深色半透 (跟 iOS / Material SnackBar 标准
              // overlay 模式一致), 不随主题翻转. 字色配套固定 white — 之前
              // 用了 dynamic background → dark 模式下 background=#0F0F12 深色
              // 跟 bg 同色 → 看不见.
              color: const Color(0xCC1A1A1F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Builds the rich-text preview span shown in the conversation list.
/// Mirrors native iOS `WKConversationListCell.getLastContent`:
/// 1. If [chatPasswordEnabled] → masked dots only
/// 2. Compose: `${reminder}${draft || senderPrefix}${content}`
/// 3. `[草稿]` and reminder text rendered in orange
/// 4. Group chats prefix with `name: content` (half-width colon + space)
///    when the message has a known sender that isn't the current user
class MoyuConvPreviewBuilder {
  const MoyuConvPreviewBuilder._();

  static const _orange = MoyuColors.orange;
  static const _defaultDraftLabel = '[Draft]';
  static const _maskedText = '* * * * * *';

  static InlineSpan build({
    required String content,
    String draft = '',
    String reminderText = '',
    String senderName = '',
    String draftLabel = _defaultDraftLabel,
    bool isGroup = false,
    bool isOwnMessage = false,
    bool chatPasswordEnabled = false,
  }) {
    if (chatPasswordEnabled) {
      return const TextSpan(text: _maskedText);
    }

    final spans = <InlineSpan>[];
    final hasDraft = draft.isNotEmpty;
    final orangePrefix = StringBuffer()
      ..write(reminderText)
      ..write(hasDraft ? draftLabel : '');
    if (orangePrefix.isNotEmpty) {
      spans.add(
        TextSpan(
          text: orangePrefix.toString(),
          style: const TextStyle(color: _orange, fontWeight: FontWeight.w500),
        ),
      );
    }

    final body = hasDraft ? draft : content;
    final showSenderPrefix =
        isGroup && !hasDraft && !isOwnMessage && senderName.isNotEmpty;
    if (showSenderPrefix) {
      spans.add(TextSpan(text: '$senderName: '));
    }
    spans.add(TextSpan(text: body));
    return TextSpan(children: spans);
  }
}

/// Red round unread count badge — the only place red is allowed in
/// Ink Edition. 18px tall, 9px radius, 11/600 white tabular numerals.
class MoyuUnreadBadge extends StatelessWidget {
  const MoyuUnreadBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 18),
      height: 18,
      padding: EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MoyuColors.of(context).red,
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: MoyuColors.of(context).background,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// Smaller unread marker for muted conversations. Native IM lists keep the
/// "has unread" affordance but suppress the count when notifications are off.
class MoyuUnreadDot extends StatelessWidget {
  const MoyuUnreadDot({super.key, this.size = 7});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: MoyuColors.of(context).red,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Conversation row exactly matching the Ink Edition `.conv-item` style:
/// 72px height, 12px gap, 48px circular avatar, 16/500 name with -0.005em
/// tracking, 11/regular tabular time, 13/regular preview with ellipsis,
/// red round unread badge.
/// 消息发送状态 — 自己发的最后一条消息显示在 cell 时间左侧.
/// 对齐 iOS WKConversationListCell.updateStatus 4 个分支.
enum MoyuConvSendStatus {
  /// 不显示 (别人发的 / 没有消息)
  none,

  /// 等待发送 (SDK WAITSEND/UPLOADING) — 时钟图标 灰色
  sending,

  /// 已送达未读 (SUCCESS && readedCount==0) — 单勾 蓝色
  sent,

  /// 已读 (SUCCESS && readedCount>0) — 双勾 蓝色
  read,

  /// 发送失败 (FAIL) — 红色 ! 圈 (跟之前的 failed dot 视觉一致)
  failed,
}

class MoyuConvRow extends StatelessWidget {
  const MoyuConvRow({
    super.key,
    required this.name,
    required this.preview,
    required this.timeLabel,
    required this.avatarLabel,
    this.gradientColors,
    this.gradientIndex,
    this.avatarUrl,
    this.unread = 0,
    this.online = false,
    this.muted = false,
    this.pinned = false,
    @Deprecated('Use sendStatus = MoyuConvSendStatus.failed instead')
    this.failed = false,
    this.sendStatus = MoyuConvSendStatus.none,
    this.channelCategory = '',
    this.isAIBot = false,
    this.msgAutoDeleteSeconds = 0,
    this.onTap,
    this.onLongPress,
    this.identifier,
  });

  final String name;
  final InlineSpan preview;
  final String timeLabel;
  final String avatarLabel;
  final List<Color>? gradientColors;
  final int? gradientIndex;
  final String? avatarUrl;
  final int unread;
  final bool online;
  final bool muted;
  final bool pinned;

  /// [DEPRECATED] Last outgoing message failed to send. 旧 API,
  /// 新代码应该走 sendStatus = failed. 如果 failed=true 但 sendStatus=none
  /// 也按 failed 渲染 (向后兼容).
  final bool failed;

  /// 自己发的最后一条消息状态 (4 种 icon: sending/sent/read/failed)
  /// + none 不显示. 对齐 iOS WKConversationListCell.updateStatus.
  final MoyuConvSendStatus sendStatus;

  /// 官方账号 category — 'service' (服务号) / 'visitor' (访客号) / ''.
  /// 非空时 name 右侧渲染对应 tag chip. iOS WKOfficialTag.
  final String channelCategory;

  /// AI bot: channel.robot=1 且 category 为空时, name 右侧渲染 AI chip.
  final bool isAIBot;

  /// 自动删除 TTL (秒). >0 时头像右下角显示 "1d/2w/3m" 小标.
  /// 对齐 iOS WKAutoDeleteView (channel.extra.msg_auto_delete).
  final int msgAutoDeleteSeconds;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? identifier;

  @override
  Widget build(BuildContext context) {
    final tagCategory = channelCategory.isNotEmpty
        ? channelCategory
        : (isAIBot ? 'ai' : '');
    return Semantics(
      identifier: identifier,
      container: true,
      child: FTappable(
        onPress: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // 置顶行底色 — light 模式 #EEEEEE 浅灰, dark 模式用 backgroundSoft
          // (#1A1A1F) 比 page bg 浅一档作"置顶高亮"差异.
          color: pinned ? MoyuColors.of(context).backgroundSoft : null,
          child: Row(
            children: [
              // 头像 + 右下角自动删除小标 (msg_auto_delete > 0 时)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  MoyuAvatar(
                    label: avatarLabel,
                    colors:
                        gradientColors ??
                        MoyuAvatarGradients.at(gradientIndex ?? 0),
                    online: online,
                    imageUrl: avatarUrl,
                  ),
                  if (msgAutoDeleteSeconds > 0)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: _AutoDeleteBadge(seconds: msgAutoDeleteSeconds),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        // 外层 Expanded 撑到 pin/time 边界, 内层 Row 让
                        // name+badge 紧贴 (badge 跟着 name 末尾 +4, 短名字
                        // 时不会飘到 Expanded box 右边). 对齐 iOS
                        // WKConversationListCell:639-642 "officialTag.lim_left
                        // = titleLbl.lim_right+4". 不能直接把 Flexible 放在
                        // 顶层 Row, 因为 Spacer/SizedBox 在 baseline Row 里
                        // 会破坏 baseline 算 → 时间垂直漂移.
                        Expanded(
                          // 内层 Row 用 center 对齐 — badge 跟 Text 中心居中
                          // (iOS WKConversationListCell:640 同款: officialTag.
                          // top = titleLbl.top + (titleLbl.h/2 - officialTag.
                          // h/2)). 外层 Row 保留 baseline 让 time 跟 name 文
                          // 字基线对齐.
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    // 对齐微信会话列表标题视觉: 17pt + w500
                                    // 半粗, 跟 13pt w400 灰副文本形成明显主
                                    // 从对比. 偏离 DESIGN.md §2 "list row
                                    // 15.5/w400 统一" 是按用户要求 — 消息
                                    // 列表标题是高频扫读区, 字号字重突出
                                    // 比扁平更实用. 通讯录/发现 row 仍走
                                    // 15.5/w400 (不用 MoyuConvRow, 不受
                                    // 影响).
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.08,
                                    color: MoyuColors.of(context).textPrimary,
                                  ),
                                ),
                              ),
                              if (tagCategory.isNotEmpty) ...[
                                const SizedBox(width: 4),
                                MoyuOfficialTag(category: tagCategory),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        if (pinned) ...[
                          Transform.rotate(
                            angle: 0.785398, // 45° — small pin tilt
                            child: Icon(
                              Icons.push_pin,
                              size: 11,
                              color: MoyuColors.of(context).textTertiary,
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                        Text(
                          timeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: MoyuColors.of(context).textTertiary,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(
                            preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: MoyuColors.of(context).textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 4 种发送状态 icon (对齐 iOS WKConversationListCell.updateStatus).
                        // sendStatus.none 不渲染, 其他 4 种渲染 12-14pt icon
                        // 在 preview 右侧 / unread badge 左侧.
                        if (sendStatus == MoyuConvSendStatus.failed ||
                            (sendStatus == MoyuConvSendStatus.none && failed))
                          _ConvStatusIcon.failed()
                        else if (sendStatus == MoyuConvSendStatus.sending)
                          _ConvStatusIcon.sending()
                        else if (sendStatus == MoyuConvSendStatus.read)
                          _ConvStatusIcon.read()
                        else if (sendStatus == MoyuConvSendStatus.sent)
                          _ConvStatusIcon.sent(),
                        if (sendStatus != MoyuConvSendStatus.none ||
                            failed) ...[
                          if (unread > 0 || muted) SizedBox(width: 6),
                        ],
                        if (muted && unread == 0)
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 14,
                            color: MoyuColors.of(context).textTertiary,
                          )
                        else if (muted && unread > 0)
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 14,
                                color: MoyuColors.of(context).textTertiary,
                              ),
                              const SizedBox(width: 6),
                              MoyuUnreadDot(),
                            ],
                          )
                        else if (unread > 0)
                          MoyuUnreadBadge(count: unread),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 会话 cell 内的 4 种消息发送状态 icon. 对齐 iOS:
///   - sending: 时钟 (灰 tipColor)
///   - sent: 单勾 (蓝 themeColor)
///   - read: 双勾 (蓝 themeColor)
///   - failed: 红圈 ! (红色)
class _ConvStatusIcon extends StatelessWidget {
  const _ConvStatusIcon._({
    required this.icon,
    required this.color,
    this.isFailedBadge = false,
  });

  /// iOS ConversationList/Index/TimeWait 灰色小钟
  factory _ConvStatusIcon.sending() => const _ConvStatusIcon._(
    icon: FIcons.clock,
    color: MoyuColors.textTertiary,
  );

  /// iOS Checkmark 蓝色单勾
  factory _ConvStatusIcon.sent() =>
      const _ConvStatusIcon._(icon: FIcons.check, color: MoyuColors.primary);

  /// iOS DoubleCheckmark 蓝色双勾
  factory _ConvStatusIcon.read() => const _ConvStatusIcon._(
    icon: FIcons.checkCheck,
    color: MoyuColors.primary,
  );

  /// iOS SendError 红色 ! 圆 (跟之前 failed dot 视觉一致)
  factory _ConvStatusIcon.failed() => const _ConvStatusIcon._(
    icon: FIcons.circleAlert,
    color: MoyuColors.red,
    isFailedBadge: true,
  );

  final IconData icon;
  final Color color;
  final bool isFailedBadge;

  Color _resolvedColor(BuildContext context) {
    if (color == MoyuColors.primary) return MoyuColors.of(context).primary;
    if (color == MoyuColors.textTertiary) {
      return MoyuColors.of(context).textTertiary;
    }
    if (color == MoyuColors.red) return MoyuColors.of(context).red;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    if (isFailedBadge) {
      // 红圈 ! 用 18×18 填色 badge, 跟旧 failed dot 视觉保持一致
      return Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '!',
          style: TextStyle(
            color: MoyuColors.of(context).background,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      );
    }
    return Icon(icon, size: 14, color: _resolvedColor(context));
  }
}

/// 官方账号 tag — service: verified 蓝勋章 (assets/icons/official-badge.png,
/// Twitter style 齿状勋章 + 白对勾), visitor: 浅椭圆 "访客" 文字.
/// 之前 service 分支用 chatim 自造的 18×18 蓝圆 + 白 "服" 字, iOS 原版用
/// `WuKongBase/Assets/.../Official.imageset` 盾牌 "官" 字 + 蓝对勾. 都是
/// 国风 "服务号" 视觉. 现在统一换成 Twitter/Instagram verified badge 同款
/// (齿状勋章 + 白对勾), 视觉更现代 / 跨文化, **不再对齐 iOS 原版**.
/// (visitor 仍用文字 chip — 访客号语义跟 verified 不一样, 灰椭圆 + "访客"
/// 文字更直观.)
class MoyuOfficialTag extends StatelessWidget {
  const MoyuOfficialTag({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    // 'service' = server 返回的 channelCategory (公众/订阅号), 'system' = 客户端
    // 写死的内置账号 (fileHelper 等, server 没 user 表行返不出 category). 视觉
    // 上都用同一枚 verified 蓝勋章.
    if (category == 'service' || category == 'system') {
      return Image.asset(
        'assets/icons/official-badge.png',
        width: 18,
        height: 18,
        fit: BoxFit.contain,
      );
    }
    if (category == 'visitor') {
      return Container(
        height: 18,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).backgroundSoft,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          AppLocalizations.of(context).visitorBadge,
          style: TextStyle(
            color: MoyuColors.of(context).textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      );
    }
    // 'ai' = 用户通过 BotFather 创建的 AI bot (user.robot=1 + category != 'system').
    // 紫色 chip 区分于蓝色"系统"勋章; 文字 "AI" 比图标更直观, 用户能立刻知道
    // 这个聊天对象是 AI agent 而不是真人.
    if (category == 'ai') {
      return Container(
        height: 18,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6E5BF6), Color(0xFFA94BF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'AI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0.4,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

/// 自动删除 TTL 小标 — 头像右下角 16×16 圆角 6, 显示 1d/2w/3m/1y.
/// 对齐 iOS WKAutoDeleteView 跟 WKConversationListCell.refreshAutoDeleteIfNeed.
class _AutoDeleteBadge extends StatelessWidget {
  const _AutoDeleteBadge({required this.seconds});

  final int seconds;

  String _format(int s) {
    if (s < 60 * 60 * 24) return ''; // < 1 day 不显示
    final day = s ~/ (60 * 60 * 24);
    final week = day ~/ 7;
    final month = day ~/ 30;
    final year = month ~/ 12;
    if (year > 0) return '${year}y';
    if (month > 0) return '${month}m';
    if (week > 0) return '${week}w';
    return '${day}d';
  }

  @override
  Widget build(BuildContext context) {
    final label = _format(seconds);
    if (label.isEmpty) return SizedBox.shrink();
    return Container(
      height: 16,
      padding: EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFF8E8E93),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: MoyuColors.of(context).background,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      ),
    );
  }
}
