import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'moyu_ink.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

class DetailScaffold extends StatefulWidget {
  const DetailScaffold({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
    this.onRefresh,
    this.bottomSticky,
    this.bottomStickyHeight = 76,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  /// Optional pull-to-refresh handler. When non-null the body is wrapped in a
  /// [RefreshIndicator].
  final Future<void> Function()? onRefresh;

  /// 可选底部 sticky slot (DESIGN.md §6 中 page-bottom 主 CTA)。
  final Widget? bottomSticky;
  final double bottomStickyHeight;

  @override
  State<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<DetailScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final bottomInset = media.padding.bottom;
    final headerHeight = topInset + MoyuDetailHeader.height;
    final stickyTotal = widget.bottomSticky == null
        ? 0.0
        : widget.bottomStickyHeight + bottomInset;

    Widget list = ListView(
      controller: _scrollController,
      padding: EdgeInsets.only(top: headerHeight, bottom: 24 + stickyTotal),
      children: widget.children,
    );
    if (widget.onRefresh != null) {
      list = RefreshIndicator(onRefresh: widget.onRefresh!, child: list);
    }

    return FScaffold(
      childPad: false,
      child: MoyuSettingsFlat(
        child: ColoredBox(
          color: MoyuColors.of(context).backgroundSoft,
          child: Stack(
            children: [
              Positioned.fill(child: list),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MoyuGlass(
                  borderRadius: BorderRadius.zero,
                  showHairline: false,
                  child: SafeArea(
                    bottom: false,
                    child: MoyuDetailHeader(
                      title: widget.title,
                      trailing: widget.trailing,
                      onTitleDoubleTap: _scrollToTop,
                    ),
                  ),
                ),
              ),
              if (widget.bottomSticky != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MoyuGlass(
                    borderRadius: BorderRadius.zero,
                    showHairline: false,
                    child: SafeArea(top: false, child: widget.bottomSticky!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
