import 'dart:async' show unawaited;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart'
    show ChatBackground, ChatSocialGateway;
import '../chat_navigation.dart';
import '../detail_scaffold.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';

class ChatBackgroundsPage extends StatefulWidget {
  const ChatBackgroundsPage({
    super.key,
    required this.config,
    required this.loginUid,
    this.scopeSuffix = '',
    this.selectedStatus,
    this.socialGateway,
  });

  final AppConfig config;
  final String loginUid;
  final String scopeSuffix;
  final String? selectedStatus;
  final ChatSocialGateway? socialGateway;

  @override
  State<ChatBackgroundsPage> createState() => _ChatBackgroundsPageState();
}

class _ChatBackgroundsPageState extends State<ChatBackgroundsPage> {
  final List<ChatBackground> _backgrounds = [];
  String _selectedUrl = '';
  bool _loading = true;
  String _status = '';

  @override
  void initState() {
    super.initState();
    unawaited(_loadBackgrounds());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.chatBackgroundTitle,
      children: [
        // 用 LayoutBuilder + Wrap 替代 GridView.builder(shrinkWrap)，绕开
        // Flutter nested ScrollView mainAxis viewport 多算空白的问题。
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              if (_loading)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(child: Text(t.chatBackgroundLoading)),
                )
              else if (_backgrounds.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(child: Text(t.chatBackgroundEmpty)),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    const columns = 3;
                    const spacing = 10.0;
                    final cellW =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                        columns;
                    final cellH = cellW / 0.66;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (
                          var index = 0;
                          index < _backgrounds.length;
                          index++
                        )
                          SizedBox(
                            width: cellW,
                            height: cellH,
                            child: _ChatBackgroundTile(
                              config: widget.config,
                              background: _backgrounds[index],
                              label: index == 0
                                  ? t.chatBackgroundDefault
                                  : t.chatBackgroundItem(index),
                              selected: _backgrounds[index].url == _selectedUrl,
                              onTap: () => pushPage(
                                context,
                                _ChatBackgroundPreviewPage(
                                  config: widget.config,
                                  background: _backgrounds[index],
                                  onSelected: () =>
                                      _saveBackground(_backgrounds[index]),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              if (_status.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MoyuColors.of(context).textTertiary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _loadBackgrounds() async {
    final preferences = await SharedPreferences.getInstance();
    final selected =
        preferences.getString(
          chatBackgroundUrlKey(widget.loginUid, widget.scopeSuffix),
        ) ??
        '';
    final backgrounds = await widget.socialGateway?.loadChatBackgrounds() ?? [];
    // 只保留能本地渲染的渐变背景 (is_svg=1 且 colors 有效, 跟 _ChatBackgroundPreview
    // 的渐变分支同条件)。真图项 (is_svg=0) 依赖 server OSS chatbg 资源, 当前 OSS
    // 缺图会显空白占位 → 过滤掉。OSS 补齐真图后, 去掉此 filter 即可恢复显示。
    final renderable = backgrounds.where((b) {
      final colors = b.lightColors.map(parseHexColor).whereType<Color>();
      return b.isSvg && colors.length >= 2;
    }).toList();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedUrl = selected;
      _backgrounds
        ..clear()
        ..add(const ChatBackground())
        ..addAll(renderable);
      _loading = false;
    });
  }

  Future<void> _saveBackground(ChatBackground background) async {
    final t = AppLocalizations.of(context);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      chatBackgroundUrlKey(widget.loginUid, widget.scopeSuffix),
      background.url,
    );
    await preferences.setBool(
      chatBackgroundIsSvgKey(widget.loginUid, widget.scopeSuffix),
      background.isSvg,
    );
    await preferences.setStringList(
      chatBackgroundLightColorsKey(widget.loginUid, widget.scopeSuffix),
      background.lightColors,
    );
    await preferences.setStringList(
      chatBackgroundDarkColorsKey(widget.loginUid, widget.scopeSuffix),
      background.darkColors,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedUrl = background.url;
      _status = widget.selectedStatus ?? t.chatBackgroundSelectedStatus;
    });
  }
}

class _ChatBackgroundPreviewPage extends StatelessWidget {
  const _ChatBackgroundPreviewPage({
    required this.config,
    required this.background,
    required this.onSelected,
  });

  final AppConfig config;
  final ChatBackground background;
  final Future<void> Function() onSelected;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.chatBackgroundPreviewTitle,
      children: [
        MoyuSection(
          padding: const EdgeInsets.all(16),
          children: [
            AspectRatio(
              aspectRatio: 0.68,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _ChatBackgroundPreview(
                  config: config,
                  background: background,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FButton(
                onPress: () async {
                  await onSelected();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(t.chatBackgroundSet),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChatBackgroundTile extends StatelessWidget {
  const _ChatBackgroundTile({
    required this.config,
    required this.background,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppConfig config;
  final ChatBackground background;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return FTappable(
      onPress: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ChatBackgroundPreview(
                    config: config,
                    background: background,
                  ),
                  if (selected)
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: MoyuColors.of(context).primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          t.chatBackgroundInUse,
                          style: TextStyle(
                            color: MoyuColors.of(context).bubbleSendForeground,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: MoyuColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBackgroundPreview extends StatelessWidget {
  const _ChatBackgroundPreview({
    required this.config,
    required this.background,
  });

  final AppConfig config;
  final ChatBackground background;

  @override
  Widget build(BuildContext context) {
    final colors = background.lightColors
        .map(parseHexColor)
        .whereType<Color>()
        .toList();
    if (background.url.isEmpty) {
      // 默认背景项: 纯色块 (跟随主题 light/dark backgroundSoft)。
      return ColoredBox(color: MoyuColors.of(context).backgroundSoft);
    }
    if (background.isSvg && colors.length >= 2) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: config.showUrl(
        background.cover.isEmpty ? background.url : background.cover,
      ),
      fit: BoxFit.cover,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      errorWidget: (_, _, _) =>
          ColoredBox(color: MoyuColors.of(context).backgroundSoft),
    );
  }
}

String chatBackgroundChannelScope(int channelType, String channelId) =>
    '_channel_${channelType}_$channelId';

String chatBackgroundUrlKey(String uid, [String scopeSuffix = '']) =>
    'chatim_chat_bg_url_$uid$scopeSuffix';

String chatBackgroundIsSvgKey(String uid, [String scopeSuffix = '']) =>
    'chatim_chat_bg_is_svg_$uid$scopeSuffix';

String chatBackgroundLightColorsKey(String uid, [String scopeSuffix = '']) =>
    'chatim_chat_bg_light_colors_$uid$scopeSuffix';

String chatBackgroundDarkColorsKey(String uid, [String scopeSuffix = '']) =>
    'chatim_chat_bg_dark_colors_$uid$scopeSuffix';

Color? parseHexColor(String value) {
  final normalized = value.trim().replaceFirst('#', '');
  if (normalized.length != 6 && normalized.length != 8) {
    return null;
  }
  final parsed = int.tryParse(normalized, radix: 16);
  if (parsed == null) {
    return null;
  }
  return Color(normalized.length == 6 ? 0xFF000000 | parsed : parsed);
}
