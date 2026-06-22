import 'package:flutter/services.dart' show rootBundle;

/// 单个 emoji 条目 (对应 emoji.plist 一行 dict).
/// 对齐 iOS `WKEmotion` (`WuKongBase/Classes/Sections/Conversation/Services/WKEmoticonService.h`):
/// - `tag`  = `WKEmotion.faceName` = Unicode emoji 字符 (跨端协议字段, 发送时
///   插到 textfield 的内容)
/// - `file` = `WKEmotion.faceImageName` = bundle 图片名 (不含 .png 后缀)
class EmojiEntry {
  const EmojiEntry({required this.tag, required this.file});

  /// Unicode emoji 字符, 如 "😀". 三端 (iOS/Android/Flutter) 协议层都用
  /// Unicode 互传, 接收端各自映射到本端 bundle 图片渲染.
  final String tag;

  /// 不带后缀的图片名, 如 "0_0". 完整 asset 路径 = `assetPath`.
  final String file;

  String get assetPath => 'assets/emoji/$file.png';
}

/// 启动时一次性加载 `assets/emoji/emoji.plist` + 暴露 entries 列表 (给 panel
/// grid 按顺序遍历) + tag → entry map (给接收端 text bubble inline 扫
/// Unicode emoji 字符做 O(1) lookup).
/// 对齐 iOS `WKEmoticonService` (`WuKongBase/.../Services/WKEmoticonService.m`)
/// 和 Android `EmojiManager` (`wkbase/.../emoji/EmojiManager.java`):
/// 两者启动时各自 parse plist/xml, 持有 (faceName→imageName) 映射, 接收
/// 消息时正则扫一次 Unicode emoji 把字符替换成 image. Flutter 这边走 dart
/// Map + `_parseMarkdownInline` 同一路径加 emoji 分支.
class EmojiBundle {
  EmojiBundle._({required this.entries})
    : tagToEntry = {for (final e in entries) e.tag: e};

  /// plist 原顺序的 entries. iOS 在 emoji panel grid 也是按这个顺序展示.
  final List<EmojiEntry> entries;

  /// Unicode 字符 → entry, 接收端解析用 O(1) lookup.
  final Map<String, EmojiEntry> tagToEntry;

  /// 接收端 text bubble inline 扫消息体用. emoji 字符均无 regex metachar,
  /// 直接 join '|' 不用 escape. 多 codepoint emoji (含 ZWJ / variation
  /// selector) 在 String literal 已是完整字符序列, RegExp 按字面匹配.
  /// 对齐 iOS WKEmoticonService.m:80 emojiReg + Android EmojiManager
  /// makePattern.
  late final RegExp emojiPattern = RegExp(tagToEntry.keys.join('|'));

  static EmojiBundle? _instance;

  /// 已加载的全局实例, panel / bubble 都拿这个. null 表示 load() 还没跑过.
  static EmojiBundle? get instanceOrNull => _instance;

  /// plist 结构稳定 (array > dict > data:array > dict { file, id, tag }),
  /// 不引 `xml` 第三方包, 用 RegExp 直接抓三字段 dict 块. 重复调返回
  /// 已缓存实例.
  static Future<EmojiBundle> load() async {
    final cached = _instance;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/emoji/emoji.plist');
    final dictRe = RegExp(
      r'<key>file</key>\s*<string>([^<]+)</string>\s*'
      r'<key>id</key>\s*<string>[^<]+</string>\s*'
      r'<key>tag</key>\s*<string>([^<]+)</string>',
      multiLine: true,
    );
    final entries = <EmojiEntry>[];
    for (final m in dictRe.allMatches(raw)) {
      entries.add(EmojiEntry(file: m.group(1)!, tag: m.group(2)!));
    }
    final bundle = EmojiBundle._(entries: entries);
    _instance = bundle;
    return bundle;
  }

  EmojiEntry? lookupByTag(String tag) => tagToEntry[tag];
}
