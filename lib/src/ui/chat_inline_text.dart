import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emoji_bundle.dart';
import 'moyu_theme.dart';

/// Single-entry RegExp cache for the inline-markdown parser. Keyed by
/// the *identity* of the sorted candidate list passed in; callers
/// (`_ChatScreenState._mentionCandidates`) memoize that list so the
/// same `List<String>` reference comes back across bubble rebuilds,
/// turning what used to be a per-bubble regex compile into a single
/// compile per candidate-set change. The empty-candidates pattern is
/// cached separately because it's compiled from a constant source.
List<String>? _mentionPatternCacheKey;
RegExp? _mentionPatternCacheValue;
RegExp? _mentionPatternEmptyCache;

/// PUA sentinel 字符 — 必须跟 `wukong_im_service.dart` 内 `_kPua*` 同步.
/// 这是 WKRichTextContent.decodeJson 用来包 underline / color / font-size
/// 这 3 类 markdown 无标准的富文本 entity 的不可见标记符. 用户输入不会
/// 触发 (PUA U+E000-U+F8FF 范围, 跨字体保留用途).
const String _kPuaUnderlineOpen = '\u{E001}';
const String _kPuaUnderlineClose = '\u{E002}';
const String _kPuaColorOpen = '\u{E003}';
const String _kPuaColorClose = '\u{E004}';
const String _kPuaFontOpen = '\u{E005}';
const String _kPuaFontMid = '\u{E006}';
const String _kPuaFontClose = '\u{E007}';

/// Compile the full inline-markdown + mention regex for a given (already
/// sorted longest-first) candidate list. Pulled out so the parser can
/// memoize compilations and so the alternation logic lives in one place.
/// When `sortedCandidates` is non-empty the @mention branch becomes a
/// two-tier alternation:
///   1. Each candidate (longest-first) followed by a two-part lookahead
///      that forbids the candidate from being a prefix of a longer
///      identifier:
///        * `(?![一-龥\w])` — no name char immediately after.
///        * `(?![.\-][一-龥\w])` — no `.`/`-` followed by a name char.
///      Both pass for whitespace, sentence punctuation, end-of-string,
///      brackets, etc., so `@John Doe.` still captures the candidate
///      cleanly while `@john.doe` falls through to (2).
///   2. Generic `[一-龥\w.\-]+` fallback that captures unknown
///      identifiers (including dotted/hyphenated ones) as a single
///      tappable span. Lookbehind `(?<![\w.])` blocks email locals.
RegExp _buildInlinePattern(List<String> sortedCandidates) {
  final mentionAlt = sortedCandidates.isEmpty
      ? r'(?<![\w.])@[一-龥\w.\-]+'
      : '(?<![\\w.])@(?:(?:${sortedCandidates.map(escapeRegexLiteral).join("|")})(?![一-龥\\w])(?![.\\-][一-龥\\w])|[一-龥\\w.\\-]+)';
  return RegExp(
    // **bold**
    r'(\*\*([^\*]+)\*\*)'
    // *italic*
    r'|(\*([^\*\s][^\*]*)\*)'
    // `code`
    r'|(`([^`]+)`)'
    // [label](url) — negative lookbehind 排除前缀 `!`, 让 image `![alt](url)`
    // 不被 link 抢吃成 `[alt](url)` (link 在 alternation 顺序上靠前, 不加
    // lookbehind 会优先匹配掉 image 内容部分).
    r'|((?<!!)\[([^\]]+)\]\(([^)]+)\))'
    // bare URL — conservative
    r'|(https?://[^\s<>【】（）]+)'
    // @mention — see doc above. Group 11 = full match including `@`.
    '|($mentionAlt)'
    // group 12 — email. 对齐 iOS NSDataDetector(Address), tap → mailto:
    r'|([A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(?:\.[A-Za-z0-9\-]+)+)'
    // group 13 — phone: 中国手机 1[3-9]\d{9} (最高频 chat 场景) 或国际
    // +前缀 7-15 位. 对齐 iOS NSDataDetector(PhoneNumber). negative
    // lookbehind 避免匹配 URL/email 里的数字段.
    r'|(?<![\w@.])(\+\d{1,3}[\s\-]?\d{7,14}|1[3-9]\d{9})(?![\w@])'
    // group 14/15 — strikethrough `~~text~~` (markdown 标准, 对齐 GitHub /
    // WhatsApp / WuKongRichText WKStrikethroughRichTextStyle).
    r'|(~~([^~]+)~~)'
    // group 16/17/18 — inline image `![w*h](url)` 或 `![alt](url)`.
    // 用于渲染 WKRichTextContent 的 WKImageRichTextStyle 远程图. alt
    // 文本可承载 `width*height` 尺寸提示, 解析失败时 fallback 长边 250pt
    // (对齐 iOS WKRemoteImageAttachment displaySize cap).
    r'|(!\[([^\]]*)\]\(([^)]+)\))'
    // group 19/20 — underline (WKUnderlineRichTextStyle). PUA sentinel 包裹,
    // 用户文本不会触发. 渲染 TextDecoration.underline (对齐 iOS).
    '|($_kPuaUnderlineOpen([^$_kPuaUnderlineClose]+)$_kPuaUnderlineClose)'
    // group 21/22/23 — color (WKColorRichTextStyle). 格式:
    // `_kPuaColorOpen` + 6位 hex + text + `_kPuaColorClose`. hex 标准化
    // 在 WKRichTextContent._normalizeHex.
    '|($_kPuaColorOpen([0-9A-Fa-f]{6})([^$_kPuaColorClose]+)$_kPuaColorClose)'
    // group 24/25/26 — font-size (WKFontRichTextStyle). 格式:
    // `_kPuaFontOpen` + 1-3位 digit + `_kPuaFontMid` + text + `_kPuaFontClose`.
    '|($_kPuaFontOpen(\\d{1,3})$_kPuaFontMid([^$_kPuaFontClose]+)$_kPuaFontClose)',
  );
}

/// Escape a string so it can be embedded as a literal inside a Dart
/// `RegExp` source. `RegExp.escape` exists in newer Dart SDKs; we ship
/// our own to keep the parser stable across minor SDK bumps and to
/// document the exact metacharacter set we care about.
String escapeRegexLiteral(String input) {
  // Metachars per ECMAScript regex spec used by Dart's RegExp engine.
  // `-` is included for safety inside char classes, though we don't
  // use the result inside one here.
  const metachars = r'\^$.|?*+()[]{}-';
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    if (metachars.contains(ch)) {
      buffer.write(r'\');
    }
    buffer.write(ch);
  }
  return buffer.toString();
}

/// Lightweight inline-only Markdown parser for chat bubbles. Supports the
/// four patterns native iOS WKRichTextCell honors: `**bold**`, `*italic*`,
/// `` `code` ``, `[label](url)`. Plus bare http(s) URL auto-linking
/// (conservative — requires explicit scheme, mirrors native iOS
/// `WKMentionService` `NSDataDetector(URL)`). Anything else stays plain
/// text. Avoids pulling in flutter_markdown (which adds 600KB and brings
/// block-level rendering we don't need).
/// Spec: text-message.md §6 P0 "URL auto-link regex: conservative".
List<InlineSpan> parseMarkdownInline(
  String text, {
  required bool isMine,
  void Function(String name)? mentionTap,
  List<String> mentionCandidates = const [],
}) {
  if (text.isEmpty) return const [];
  // Emoji 切割 (在 markdown 解析前): 用 EmojiBundle (启动时 load) 扫 text
  // 找所有 Unicode emoji, 把 emoji 替换为 WidgetSpan(Image.asset(bundle
  // PNG)), 其余文本递归走 markdown/mention/url parse. EmojiBundle 未加载
  // 时跳过 (Unicode 走系统字体 fallback). 对齐 iOS WKEmoticonService.parse
  // (WuKongBase/.../Services/WKEmoticonService.m:80 emojiReg) + Android
  // MoonUtil.identifyFaceExpression: 三端都把消息文本里的 emoji 字符
  // 替换成 bundle PNG 渲染, 不依赖系统 Apple Color Emoji 字体, 跨端
  // 视觉统一. iOS WKEmotion.faceName = Unicode emoji 字符, 跨端协议
  // 字段, 接收端按字面 lookup bundle 图.
  final emojiBundle = EmojiBundle.instanceOrNull;
  if (emojiBundle != null && emojiBundle.tagToEntry.isNotEmpty) {
    final emojiMatches = emojiBundle.emojiPattern.allMatches(text).toList();
    if (emojiMatches.isNotEmpty) {
      final spans = <InlineSpan>[];
      var cursor = 0;
      for (final m in emojiMatches) {
        if (m.start > cursor) {
          spans.addAll(
            parseMarkdownInline(
              text.substring(cursor, m.start),
              isMine: isMine,
              mentionTap: mentionTap,
              mentionCandidates: mentionCandidates,
            ),
          );
        }
        final entry = emojiBundle.lookupByTag(m.group(0)!);
        if (entry != null) {
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Image.asset(entry.assetPath, width: 18, height: 18),
            ),
          );
        }
        cursor = m.end;
      }
      if (cursor < text.length) {
        spans.addAll(
          parseMarkdownInline(
            text.substring(cursor),
            isMine: isMine,
            mentionTap: mentionTap,
            mentionCandidates: mentionCandidates,
          ),
        );
      }
      return spans;
    }
  }
  // Pattern cache. Identity-keyed off the candidates list — chat
  // screens memoize that list so the same reference is reused across
  // bubble rebuilds, making this an O(1) lookup. On cache miss we
  // build the alternation and stash it for the next call.
  final RegExp pattern;
  if (mentionCandidates.isEmpty) {
    pattern = _mentionPatternEmptyCache ??= _buildInlinePattern(const []);
  } else if (identical(_mentionPatternCacheKey, mentionCandidates) &&
      _mentionPatternCacheValue != null) {
    pattern = _mentionPatternCacheValue!;
  } else {
    pattern = _buildInlinePattern(mentionCandidates);
    _mentionPatternCacheKey = mentionCandidates;
    _mentionPatternCacheValue = pattern;
  }
  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final match in pattern.allMatches(text)) {
    if (match.start > cursor) {
      spans.add(TextSpan(text: text.substring(cursor, match.start)));
    }
    if (match.group(1) != null) {
      spans.add(
        TextSpan(
          text: match.group(2),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
    } else if (match.group(3) != null) {
      spans.add(
        TextSpan(
          text: match.group(4),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    } else if (match.group(5) != null) {
      spans.add(
        TextSpan(
          text: match.group(6),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            background: Paint()
              ..color = (isMine ? Colors.white : MoyuColors.textPrimary)
                  .withValues(alpha: 0.08),
          ),
        ),
      );
    } else if (match.group(7) != null) {
      final label = match.group(8) ?? '';
      final url = match.group(9) ?? '';
      spans.add(
        TextSpan(
          text: label,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: MoyuColors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => unawaited(_openExternalUrl(url)),
        ),
      );
    } else if (match.group(10) != null) {
      // Bare http(s) URL. Two trailing-trim passes:
      //   1) Strip ALL trailing punctuation (",.;:!?"), so common
      //      cases like "see https://x.com..." or "see https://x.com!"
      //      don't bleed into the tap target.
      //   2) Strip unbalanced trailing `)` so wrapped sentences like
      //      "(https://example.com)" don't include the closing paren.
      //      Wikipedia-style "https://en.wikipedia.org/wiki/Foo_(bar)"
      //      keeps both parens intact because the count is balanced.
      // Trimmed chars are re-emitted as plain text below so the visible
      // message is unchanged.
      var url = match.group(10) ?? '';
      var trailingTrim = 0;
      // Trim ASCII + Chinese full-width sentence marks. Real Chinese
      // chat usually ends a URL with 。 or ， or ！ or ？ etc. and the
      // matcher would otherwise pull those into the tap target,
      // breaking DNS resolution.
      const trailingPunct = ',.;:!?。，；：！？、…';
      while (url.isNotEmpty && trailingPunct.contains(url[url.length - 1])) {
        url = url.substring(0, url.length - 1);
        trailingTrim++;
      }
      while (url.isNotEmpty && url.endsWith(')')) {
        final opens = url.split('(').length - 1;
        final closes = url.split(')').length - 1;
        if (closes <= opens) break;
        url = url.substring(0, url.length - 1);
        trailingTrim++;
      }
      spans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: MoyuColors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => unawaited(_openExternalUrl(url)),
        ),
      );
      // Re-emit the trimmed punctuation as plain text so it stays visible.
      if (trailingTrim > 0) {
        final originalEnd = match.end;
        final trimmedTail = match
            .group(10)!
            .substring(match.group(10)!.length - trailingTrim);
        spans.add(TextSpan(text: trimmedTail));
        // Bump cursor as if we'd consumed everything (we did, just split it).
        cursor = originalEnd;
        continue;
      }
    } else if (match.group(11) != null) {
      // @mention — themed-color span. Native iOS `WKMentionService` walks
      // `WKTextContent.mention.uids[]` to render tappable spans; the
      // pub.dev SDK we use doesn't decode that field, so we fall back to
      // regex detection. Tap handler is wired by callers via `mentionTap`
      // to resolve the @-name back to a profile.
      final mentionText = match.group(11) ?? '';
      final mentionName = mentionText.startsWith('@')
          ? mentionText.substring(1)
          : mentionText;
      spans.add(
        TextSpan(
          text: mentionText,
          style: const TextStyle(decoration: TextDecoration.underline),
          recognizer: mentionTap == null
              ? null
              : (TapGestureRecognizer()..onTap = () => mentionTap(mentionName)),
        ),
      );
    } else if (match.group(12) != null) {
      // email — 蓝色下划线, tap → mailto: URL. 对齐 iOS NSDataDetector(Address).
      final email = match.group(12) ?? '';
      spans.add(
        TextSpan(
          text: email,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: MoyuColors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => unawaited(_openExternalUrl('mailto:$email')),
        ),
      );
    } else if (match.group(13) != null) {
      // phone — 蓝色下划线, tap → tel: URL. 对齐 iOS NSDataDetector(PhoneNumber).
      // 中国手机或国际 +前缀格式. iOS 会弹"呼叫/复制/取消" sheet, 这里 tel:
      // schema 让 OS 决定 (Android 弹拨号盘, iOS 弹同款 sheet).
      final phone = match.group(13) ?? '';
      // 国际格式去空格/连字符后给 tel:
      final telUrl = 'tel:${phone.replaceAll(RegExp(r'[\s\-]'), '')}';
      spans.add(
        TextSpan(
          text: phone,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: MoyuColors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => unawaited(_openExternalUrl(telUrl)),
        ),
      );
    } else if (match.group(14) != null) {
      // ~~strikethrough~~ — markdown 标准 + WKRichText WKStrikethroughRichTextStyle
      // 兼容. 跟 italic / bold 同款风格 (inline text style).
      spans.add(
        TextSpan(
          text: match.group(15),
          style: const TextStyle(decoration: TextDecoration.lineThrough),
        ),
      );
    } else if (match.group(19) != null) {
      // PUA underline (WKUnderlineRichTextStyle). 普通文本不会触发,
      // 仅 WKRichTextContent.decodeJson 注入. 渲染 TextDecoration.underline.
      spans.add(
        TextSpan(
          text: match.group(20),
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
      );
    } else if (match.group(21) != null) {
      // PUA color (WKColorRichTextStyle). hex 6 位大写已由 decoder 标准化,
      // parse 成 0xFFRRGGBB (前缀 FF = 满 alpha, markdown 渲染不带半透明).
      final hex = match.group(22) ?? '000000';
      final rgb = int.tryParse(hex, radix: 16) ?? 0;
      final color = Color(0xFF000000 | rgb);
      spans.add(
        TextSpan(
          text: match.group(23),
          style: TextStyle(color: color),
        ),
      );
    } else if (match.group(24) != null) {
      // PUA font-size (WKFontRichTextStyle). size 已 clamp [8, 80] 在 decoder.
      final sizeStr = match.group(25) ?? '14';
      final size = double.tryParse(sizeStr) ?? 14.0;
      spans.add(
        TextSpan(
          text: match.group(26),
          style: TextStyle(fontSize: size),
        ),
      );
    } else if (match.group(16) != null) {
      // ![w*h](url) 或 ![alt](url) — inline image. 用 WidgetSpan +
      // CachedNetworkImage 渲染. alt 文本如果是 "WxH" / "W*H" 格式,
      // 解析为原始尺寸, 按长边 250pt cap (对齐 iOS WKRemoteImageAttachment
      // displaySize). 解析失败时默认 80pt 方图占位.
      final alt = match.group(17) ?? '';
      final imgUrl = match.group(18) ?? '';
      final size = _parseAltSize(alt);
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => unawaited(_openExternalUrl(imgUrl)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (context, url) => Container(
                  width: size.width,
                  height: size.height,
                  color: const Color(0x14000000),
                ),
                errorWidget: (context, url, error) => Container(
                  width: size.width,
                  height: size.height,
                  color: const Color(0x14000000),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 20,
                    color: Color(0x66000000),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    cursor = match.end;
  }
  if (cursor < text.length) {
    spans.add(TextSpan(text: text.substring(cursor)));
  }
  return spans;
}

Future<void> _openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}

/// Parse `![alt](url)` alt 文本拿 (width, height). 支持格式:
///   - `100x200` / `100X200` / `100*200` — width x height
///   - 其他 (任意 alt text) → 默认 80×80 方图占位
/// 解析出原始尺寸后按 长边 250pt cap (对齐 iOS WKRichTextCell 内
/// `WKRemoteImageAttachment` displaySize, 见 WKRichTextCell.m:506
/// `lim_sizeWithImageOriginSize:maxLength:250`).
Size _parseAltSize(String alt) {
  const cap = 250.0;
  const fallback = Size(80, 80);
  if (alt.isEmpty) return fallback;
  final m = RegExp(r'^(\d+)\s*[xX*]\s*(\d+)$').firstMatch(alt.trim());
  if (m == null) return fallback;
  final w = double.tryParse(m.group(1) ?? '') ?? 0;
  final h = double.tryParse(m.group(2) ?? '') ?? 0;
  if (w <= 0 || h <= 0) return fallback;
  // 长边 cap 250 + 保持宽高比
  if (w >= h) {
    final scaled = w > cap ? cap : w;
    return Size(scaled, scaled * h / w);
  }
  final scaled = h > cap ? cap : h;
  return Size(scaled * w / h, scaled);
}
