import 'package:flutter/material.dart';

import 'emoji_bundle.dart';
import 'moyu_theme.dart';

class ComposerTextEditingController extends TextEditingController {
  static const double _composerTextFontSize = 15;
  static const double _composerEmojiFontSize = 20;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final baseStyle = (style ?? DefaultTextStyle.of(context).style).copyWith(
      fontSize: _composerTextFontSize,
      height: 1.2,
    );
    final composing = value.composing;
    if (text.isEmpty) {
      return TextSpan(style: baseStyle, text: '');
    }

    final spans = <InlineSpan>[];
    var offset = 0;
    for (final cluster in text.characters) {
      final start = offset;
      final end = start + cluster.length;
      offset = end;

      var clusterStyle = _isComposerEmojiCluster(cluster)
          ? baseStyle.copyWith(
              fontSize: _composerEmojiFontSize,
              fontFamily: 'Apple Color Emoji',
              fontFamilyFallback: const [
                'Noto Color Emoji',
                'Segoe UI Emoji',
                'EmojiOne Color',
                'Twemoji Mozilla',
              ],
            )
          : baseStyle;
      if (_intersectsComposing(start, end, composing, withComposing)) {
        clusterStyle = clusterStyle.copyWith(
          decoration: TextDecoration.underline,
        );
      }
      spans.add(TextSpan(text: cluster, style: clusterStyle));
    }
    return TextSpan(style: baseStyle, children: spans);
  }

  static bool _intersectsComposing(
    int start,
    int end,
    TextRange composing,
    bool withComposing,
  ) {
    return withComposing &&
        composing.isValid &&
        !composing.isCollapsed &&
        start < composing.end &&
        end > composing.start;
  }

  static bool _isComposerEmojiCluster(String cluster) {
    final bundle = EmojiBundle.instanceOrNull;
    if (bundle != null && bundle.lookupByTag(cluster) != null) {
      return true;
    }

    var hasEmojiBase = false;
    var hasEmojiJoiner = false;
    for (final codePoint in cluster.runes) {
      if (_isEmojiCodePoint(codePoint)) {
        hasEmojiBase = true;
      }
      if (codePoint == 0x200D || codePoint == 0xFE0F || codePoint == 0x20E3) {
        hasEmojiJoiner = true;
      }
    }
    return hasEmojiBase || hasEmojiJoiner;
  }

  static bool _isEmojiCodePoint(int codePoint) {
    return (codePoint >= 0x1F000 && codePoint <= 0x1FAFF) ||
        (codePoint >= 0x2600 && codePoint <= 0x27BF) ||
        (codePoint >= 0x2B00 && codePoint <= 0x2BFF) ||
        codePoint == 0x00A9 ||
        codePoint == 0x00AE ||
        codePoint == 0x3030 ||
        codePoint == 0x303D ||
        codePoint == 0x3297 ||
        codePoint == 0x3299;
  }
}

/// 36×36 transparent icon button used inside the chat composer (mic / emoji /
/// plus / more). No background, no ripple — only icon + tap target. 36 命中
/// 区 跟 send pill (36 高) 视觉统一, icon 周围 6pt padding 让 icon 间距
/// 不会过于拉开 (旧版 44×44 让 icon 周围 10pt padding, smile→send 视觉
/// 间距 ~28pt, user 反馈"看着很大"). Row.crossAxis.center 仍跟 FTextField
/// (44 高) 中心轴对齐.
class ComposerIcon extends StatelessWidget {
  const ComposerIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  /// 可选 tint, 默认 textSecondary. flame icon 传 red 表 cue 当前 flame 启用.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 24,
            color: color ?? MoyuColors.of(context).textSecondary,
          ),
        ),
      ),
    );
  }
}
