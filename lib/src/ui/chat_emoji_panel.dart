import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../social/social_service.dart';
import 'emoji_bundle.dart';
import 'moyu_theme.dart';
import 'sticker_panel.dart';

class EmojiPanel extends StatefulWidget {
  const EmojiPanel({
    super.key,
    required this.onSelect,
    required this.config,
    required this.onSendSticker,
    this.onOpenStickerStore,
    this.socialGateway,
    this.onBackspace,
    this.onOpenCustomManager,
    this.onSendComposerText,
    this.userStickerPacks = const [],
    this.customStickers = const [],
    this.loadStickersForPack,
  });

  final ValueChanged<String> onSelect;
  final AppConfig config;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<ChatSticker> onSendSticker;
  final VoidCallback? onOpenStickerStore;

  /// Tapped from the in-grid backspace cell — chat-screen owns the
  /// composer and applies a grapheme-aware delete (handles surrogate
  /// pairs, ZWJ-joined family glyphs, skin-tone modifiers, regional-
  /// indicator flags). Mirrors native iOS WKEmojiPanel's ⌫ cell.
  final VoidCallback? onBackspace;

  /// 用户已添加的贴纸包. 顶部 tab 在 emoji 8 类之后插这些. 对齐 iOS
  /// WKStickerContentView.panelContentNewList.
  final List<ChatStickerPack> userStickerPacks;

  /// 用户自定义贴纸 (从 chat 长按图片"收藏到表情"). "⭐自定义" tab 显示.
  /// 对齐 iOS WKStickerCollectedContentView.
  final List<ChatSticker> customStickers;

  /// 切到某个 pack tab 时 lazy load stickers. chat-screen 负责缓存.
  /// 返回该 pack 的 stickers 列表. null 时 pack tab 不显示 grid.
  final Future<List<ChatSticker>> Function(String category)?
  loadStickersForPack;

  /// 自定义贴纸 grid 头一个 "+" cell tap 触发 — push _StickerManagerPage
  /// (mode: custom) 让用户从相册添加 / 整理 / 删除. 对齐 iOS
  /// WKStickerCollectedContentView.m:148-169 点 "+" → push
  /// WKStickerCollectionVC. null 时不显 "+" cell.
  final VoidCallback? onOpenCustomManager;

  /// emoji tab 右下 "发送" 按钮 tap — 把 composer 当前文本发出. 对齐 iOS
  /// WKTabPageView (m:104-113 sendBtn): 80×46 themeColor 红底白字, 仅 emoji
  /// tab 显示, 点击 → didSendOfTabPageView → WKEmojiPanel.m:287 →
  /// context inputTextToSend. null 时不显 send button.
  final VoidCallback? onSendComposerText;

  @override
  State<EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends State<EmojiPanel> {
  /// Active tab marker. 三种 prefix:
  ///   * `__emoji__` → 单一 emoji tab (对齐 iOS 原版: emoji 不分本地分类,
  ///      一个 tab 内 grid 平铺 + recent section. 之前 Flutter 自创的 4
  ///      个本地分类已删, 数据源改走 EmojiBundle plist).
  ///   * `pack:<category>` → 用户已添加的贴纸包
  ///   * `__custom__` → 用户自定义贴纸 (从 chat 长按图片收藏)
  String _activeCategory = _emojiTabKey;

  static const String _emojiTabKey = '__emoji__';
  static const String _customTabKey = '__custom__';

  bool get _isPackTab => _activeCategory.startsWith('pack:');
  bool get _isCustomTab => _activeCategory == _customTabKey;
  bool get _isEmojiTab => _activeCategory == _emojiTabKey;

  /// 启动时一次性 load 的 EmojiBundle (iOS 同款 152 个 emoji 的 plist +
  /// PNG). null 表示还没加载完, panel 第一次 build 会触发 load 并 setState.
  /// 跟 iOS WKEmoticonService.shared / Android EmojiManager.getInstance()
  /// 同模型 — 全局单例, 整个 app 期间共享.
  EmojiBundle? _emojiBundle = EmojiBundle.instanceOrNull;

  /// 当前 pack tab 的 stickers — async future, FutureBuilder 展示 loading.
  Future<List<ChatSticker>>? _packStickersFuture;

  /// 上次解析过的 pack category, 避免 setState 引起的 FutureBuilder rebuild
  /// 死循环 (didUpdateWidget 中也需要校对).
  String _packStickersFor = '';

  /// 最近使用的 emoji tag 列表 (Unicode 字符串), index 0 是最近 tap 过的.
  /// 持久化在 SharedPreferences key `_recentEmojiPrefsKey`, 最多 _recentLimit
  /// 个. 对齐 iOS WKEmoticonService.recentEmoji: (m:212-237):
  /// NSUserDefaults key "recentFaceArrays", 最多 7 个 (recentNum=7),
  /// insert at index 0 + dedupe + 超长 removeLastObject.
  List<String> _recentTags = const [];

  static const String _recentEmojiPrefsKey = 'emoji.recent.tags';
  static const int _recentLimit = 7;

  @override
  void initState() {
    super.initState();
    if (_emojiBundle == null) {
      // 第一次 panel 弹出时触发 load. 之后整个 app 共享同一实例,
      // 其他 panel / text bubble 拿 EmojiBundle.instanceOrNull 直接用.
      unawaited(
        EmojiBundle.load().then((bundle) {
          if (!mounted) return;
          setState(() => _emojiBundle = bundle);
        }),
      );
    }
    unawaited(_loadRecentTags());
  }

  Future<void> _loadRecentTags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tags = prefs.getStringList(_recentEmojiPrefsKey) ?? const [];
      if (!mounted) return;
      setState(() => _recentTags = tags);
    } catch (_) {
      // prefs read 失败不阻断 panel — recent section 留空即可.
    }
  }

  /// emoji cell tap 入口: 先写入 recent (iOS recentEmoji: 等价), 再调
  /// widget.onSelect (插入 textfield). recent 限 _recentLimit 个,
  /// dedupe 后 insert at index 0.
  void _handleEmojiTap(EmojiEntry emoji) {
    final tag = emoji.tag;
    widget.onSelect(tag);
    final next = [tag, ..._recentTags.where((t) => t != tag)];
    if (next.length > _recentLimit) {
      next.removeRange(_recentLimit, next.length);
    }
    if (_listEquals(next, _recentTags)) return;
    setState(() => _recentTags = next);
    unawaited(_persistRecentTags(next));
  }

  Future<void> _persistRecentTags(List<String> tags) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentEmojiPrefsKey, tags);
    } catch (_) {
      // 写入失败下次 _loadRecentTags 还会读旧值, 不影响本次 panel 内
      // setState 后的视觉刷新.
    }
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void didUpdateWidget(covariant EmojiPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 用户在商店添加/删除包后, chat-screen reload 给的 userStickerPacks
    // 变了. 当前激活的 pack tab 若没了, 退回 emoji 第一个 tab.
    if (_isPackTab) {
      final stillExists = widget.userStickerPacks.any(
        (p) => 'pack:${p.category}' == _activeCategory,
      );
      if (!stillExists) {
        _activeCategory = _emojiTabKey;
        _packStickersFuture = null;
        _packStickersFor = '';
      }
    }
  }

  /// 切到某个 pack tab 时调, 触发 lazy load.
  void _activatePackTab(String category) {
    setState(() {
      _activeCategory = 'pack:$category';
      // FutureBuilder rebuild 用新 future
      if (_packStickersFor != category) {
        _packStickersFor = category;
        _packStickersFuture =
            widget.loadStickersForPack?.call(category) ??
            Future.value(const []);
      }
    });
  }

  void _activateCustomTab() {
    setState(() {
      _activeCategory = _customTabKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // emoji grid 数据源: EmojiBundle.entries (152 个, plist 原顺序).
    // 没 load 完 (第一帧) 显示空 list, initState 触发 load 完后 setState
    // 刷新会 re-build 拿到完整列表. iOS recent section TODO 下一个 commit.
    final emojiEntries = _emojiBundle?.entries ?? const <EmojiEntry>[];
    // panel 几何对齐 iOS WKPanel (WKPanel.m:12 cornerRadiHeight 15, m:34-44
    // layoutPanel 高度由 context 给): 仅顶部 15pt 圆角, 无外阴影 / margin,
    // 高度经验值 280pt (iOS 250-280 跟键盘类似). 之前 232 + 14 全圆角 +
    // 阴影 + (8,12,8,0) margin 是 Flutter-only 装饰, 删. iOS 搜索栏原版无,
    // 跟着 panel chrome 重排一起去掉.
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: MoyuColors.of(context).background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          // 上区: grid (3 种 content 切换). 对齐 iOS WKTabPageView pageView
          // (m:61-85): 占据 panel 上区, 下区留 46pt 给 tabbar.
          Expanded(
            child: _isPackTab
                // 用户贴纸包 — FutureBuilder lazy load.
                ? FutureBuilder<List<ChatSticker>>(
                    future: _packStickersFuture,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      final stickers = snap.data ?? const [];
                      if (stickers.isEmpty) {
                        return Center(
                          child: Text(
                            t.emojiPackEmpty,
                            style: TextStyle(
                              color: MoyuColors.of(context).textTertiary,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }
                      return StickerGrid(
                        stickers: stickers,
                        config: widget.config,
                        onSendSticker: widget.onSendSticker,
                      );
                    },
                  )
                : _isCustomTab
                // 自定义贴纸 grid — 对齐 iOS WKStickerCollectedContentView
                // (m:79-90): 4 列, item+line 间距 5, contentInset (5,5,5,5).
                // grid 头一个 cell "+" 添加入口 (m:148-169 点 "+" 模型时
                // push WKStickerCollectionVC).
                ? StickerGrid(
                    stickers: widget.customStickers,
                    config: widget.config,
                    onSendSticker: widget.onSendSticker,
                    columns: 4,
                    spacing: 5,
                    padding: const EdgeInsets.all(5),
                    onAddCustomSticker: widget.onOpenCustomManager,
                  )
                // emoji grid — 对齐 iOS WKEmojiContentView (m:40-63 + 76):
                // FlowLayout 7 列 + 间距 10 (line + item) + contentInset 10.
                // 有 recent 时分 2 sections (最近使用 + 所有表情), 每 section
                // 30pt header (iOS WKEmojiCollectionTitleHeader 同款字号).
                : _buildEmojiSliverScroll(emojiEntries),
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: MoyuColors.of(context).line,
          ),
          // 下区 46pt: 左下 32×32 商店 icon (15pt left padding) + tab strip
          // horizontal scroll. 对齐 iOS WKEmojiPanel (m:168-174 stickerStoreBtn
          // lim_left=15 + tab 行高 46pt). iOS 还有 80pt 右侧 send button (emoji
          // tab 时显示), Flutter 不需要 (emoji 走 inputInsert 插 textfield,
          // 复用 composer 自带 send).
          SizedBox(
            height: 46,
            child: Row(
              children: [
                if (widget.onOpenStickerStore != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Semantics(
                      identifier: 'moyu.emoji.store',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onOpenStickerStore,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            FIcons.plus,
                            size: 20,
                            color: MoyuColors.of(context).textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    children: [
                      // emoji tab — iOS WKEmojiContentView.tabIcon
                      // (WKEmojiContentView.m:154-156 用 Conversation/Panel/
                      // IconFaceEmoji 本地图). Flutter 用 FIcons.smile 等价.
                      _EmojiCategoryTab(
                        active: _isEmojiTab,
                        onTap: () => setState(() {
                          _activeCategory = _emojiTabKey;
                        }),
                        child: Icon(
                          FIcons.smile,
                          size: 22,
                          color: MoyuColors.of(context).textPrimary,
                        ),
                      ),
                      // 自定义贴纸 tab — iOS WKStickerCollectedContentView
                      // (collection sort **3900**, WKStickerStoreModule.m:54-62)
                      // **始终注册**, 不管 collected stickers 是 0 个还是 N 个.
                      // tab 内 grid 头一个永远是 "+" cell, 用户从这里上传第一
                      // 张. iOS panel 顺序按 sort 降序: emoji(4000) > 收藏
                      // (3900) > 用户已添加的每个包(按 server sortNum), 所以
                      // ❤️ 排在 emoji **之后**, 在用户包之前. icon 用
                      // FIcons.heart 对齐 iOS Conversation/Panel/Collection
                      // 红心样.
                      _EmojiCategoryTab(
                        active: _isCustomTab,
                        onTap: _activateCustomTab,
                        child: Icon(
                          FIcons.heart,
                          size: 22,
                          color: MoyuColors.of(context).textPrimary,
                        ),
                      ),
                      // 用户已添加的贴纸包 tab — iOS WKStickerGIFContentView.
                      // customTabView (m:99-106) 用 lim_setImageWithURL 拉
                      // pack.cover 远程图. Flutter 用 Image.network + showUrl
                      // 处理相对/绝对路径.
                      for (final pack in widget.userStickerPacks)
                        _EmojiCategoryTab(
                          active: _activeCategory == 'pack:${pack.category}',
                          onTap: () => _activatePackTab(pack.category),
                          child: Builder(
                            builder: (context) {
                              final cover = pack.coverLimit.isNotEmpty
                                  ? pack.coverLimit
                                  : pack.cover;
                              return cover.isEmpty
                                  ? Icon(
                                      FIcons.image,
                                      size: 20,
                                      color: MoyuColors.of(
                                        context,
                                      ).textTertiary,
                                    )
                                  : StickerCover(
                                      config: widget.config,
                                      url: cover,
                                    );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                // iOS WKTabPageView sendBtn (m:104-113): 80×46 themeColor
                // 红底白字, 紧贴 tabbarScrollView 右侧, **仅 emoji tab (index
                // == 0)** 时显示, 切走时隐藏 (m:195-201). tap 触发
                // didSendOfTabPageView → context inputTextToSend.
                if (_isEmojiTab && widget.onSendComposerText != null)
                  Semantics(
                    identifier: 'moyu.emoji.send',
                    button: true,
                    label: t.actionSend,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onSendComposerText,
                      child: Container(
                        width: 80,
                        height: 46,
                        alignment: Alignment.center,
                        color: MoyuColors.of(context).red,
                        child: Text(
                          t.actionSend,
                          style: TextStyle(
                            color: MoyuColors.of(context).background,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// emoji panel scroll, 2 sections (最近使用 + 所有表情). 对齐 iOS
  /// WKEmojiContentView (m:40-63 + 76 + section header logic):
  /// - 列数 7 / 间距 10 / contentInset 10 (FlowLayout)
  /// - section 0: recentEmotions (≤ recentNum=7), header "最近使用"
  /// - section 1: 所有 emoji, header "所有表情"
  /// - 仅当 recent 非空时显 header (无 recent 时只 1 section + 无 header)
  /// - 7 列纯 emoji 无 ⌫ cell (iOS m:199-201 退格走输入框响应链
  ///   WKEmojiInputChangeTextRespond, Flutter 端 Unicode emoji 系统键盘
  ///   grapheme-aware 删).
  Widget _buildEmojiSliverScroll(List<EmojiEntry> emojis) {
    final t = AppLocalizations.of(context);
    final bundle = _emojiBundle;
    final recentEntries = (bundle == null || _recentTags.isEmpty)
        ? const <EmojiEntry>[]
        : _recentTags
              .map(bundle.lookupByTag)
              .whereType<EmojiEntry>()
              .toList(growable: false);
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
    );
    return CustomScrollView(
      slivers: [
        if (recentEntries.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _EmojiSectionHeader(title: t.emojiRecentSection),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid(
              gridDelegate: gridDelegate,
              delegate: SliverChildListDelegate.fixed([
                for (final e in recentEntries) _emojiCell(e),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: _EmojiSectionHeader(title: t.emojiAllSection),
          ),
        ],
        SliverPadding(
          padding: recentEntries.isEmpty
              ? const EdgeInsets.all(10)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          sliver: SliverGrid(
            gridDelegate: gridDelegate,
            delegate: SliverChildListDelegate.fixed([
              for (final e in emojis) _emojiCell(e),
            ]),
          ),
        ),
      ],
    );
  }

  /// emoji cell: 32×32 image 居中, 对齐 iOS WKEmojiCell (m:30 emojiImgView
  /// 固定 32×32 居中). 无长按预览 (iOS WKEmojiContentView 原版 emoji tab
  /// 无 long-press; 之前 Flutter 自创的 80pt 浮窗 magnify 已删). tap 调
  /// _handleEmojiTap 触发插字 + 写入 recent.
  Widget _emojiCell(EmojiEntry emoji) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleEmojiTap(emoji),
      child: Center(child: Image.asset(emoji.assetPath, width: 32, height: 32)),
    );
  }
}

/// emoji panel 内 "最近使用" / "所有表情" section header. 对齐 iOS
/// WKEmojiCollectionTitleHeader (m): 30pt 高, 内 titleLabel 字号 14
/// 左 10pt 居中. 无背景, 无 separator.
class _EmojiSectionHeader extends StatelessWidget {
  const _EmojiSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 10),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: MoyuColors.of(context).textSecondary,
        ),
      ),
    );
  }
}

/// 对齐 iOS WKEmojiPanel.newTaView (WKEmojiPanel.m:248-265):
/// 外框 37×37 cornerRadius 10, 内 icon 27×27 居中. 选中态背景
/// rgb(233,233,233) (WKTabPageView.m:64-69 light maskView 色). 调用方负责
/// 传 child (本地 icon 或服务端 pack cover image), tab 本身不区分.
class _EmojiCategoryTab extends StatelessWidget {
  const _EmojiCategoryTab({
    required this.child,
    required this.active,
    required this.onTap,
  });

  final Widget child;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 37,
        height: 37,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          // active tab 比 emoji panel bg backgroundSoft 浅一档形成 highlight.
          // light = #E9E9E9 (跟 line 接近), dark = #3A3A3F (比 backgroundSoft
          // #1A1A1F 浅 33 单位, 跟 + 面板 tile 同款). 之前 hardcode #E9E9E9
          // dark 下 emoji icon 浅色 + 浅底 = 白底白 icon 看不见.
          color: active
              ? (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3A3A3F)
                    : const Color(0xFFE9E9E9))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: SizedBox(width: 27, height: 27, child: child),
      ),
    );
  }
}
