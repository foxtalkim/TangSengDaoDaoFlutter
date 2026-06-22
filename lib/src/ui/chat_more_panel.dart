import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../chat/chat_tool_action.dart';
import 'chat_tool_tile.dart';
import 'moyu_theme.dart';

class ChatMorePanel extends StatefulWidget {
  const ChatMorePanel({
    super.key,
    required this.actions,
    required this.onAction,
  });

  final List<ChatToolAction> actions;
  final ValueChanged<ChatToolAction> onAction;

  @override
  State<ChatMorePanel> createState() => ChatMorePanelState();
}

class ChatMorePanelState extends State<ChatMorePanel> {
  // Native iOS uses 4 columns × 2 rows = 8 tiles per page (see
  // `WKMorePanel.m:39-51` — `lineItemCount=4`, paged horizontal scroll).
  static const int _columnsPerPage = 4;
  static const int _rowsPerPage = 2;
  static const int _tilesPerPage = _columnsPerPage * _rowsPerPage;

  // Tile cell height: 60pt icon box + 8pt gap + ~18pt label + buffer.
  static const double _tileHeight = 96;

  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actions;
    if (actions.length <= _tilesPerPage) {
      // 强制 4 列布局，避免窄屏固定宽度 tile 自动换成 3 列。
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const cols = _columnsPerPage;
              const spacing = 12.0;
              const runSpacing = 18.0;
              final cellW =
                  (constraints.maxWidth - (cols - 1) * spacing) / cols;
              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: [
                  for (final action in actions)
                    SizedBox(
                      width: cellW,
                      height: _tileHeight,
                      child: ChatToolTile(
                        action: action,
                        onTap: () => widget.onAction(action),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );
    }

    final pageCount = (actions.length / _tilesPerPage).ceil();
    final clampedIndex = _pageIndex.clamp(0, pageCount - 1).toInt();
    if (_pageIndex >= pageCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(clampedIndex);
        }
        if (_pageIndex != clampedIndex) {
          setState(() => _pageIndex = clampedIndex);
        }
      });
    }
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _tileHeight * _rowsPerPage,
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                onPageChanged: (i) {
                  if (i == _pageIndex) return;
                  setState(() => _pageIndex = i);
                },
                itemBuilder: (context, pageIdx) {
                  final start = pageIdx * _tilesPerPage;
                  final end = math.min(start + _tilesPerPage, actions.length);
                  final pageActions = actions.sublist(start, end);
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: pageActions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _columnsPerPage,
                          mainAxisExtent: _tileHeight,
                        ),
                    itemBuilder: (context, idx) {
                      final action = pageActions[idx];
                      return ChatToolTile(
                        action: action,
                        onTap: () => widget.onAction(action),
                      );
                    },
                  );
                },
              ),
            ),
            if (pageCount > 1) ...[
              const SizedBox(height: 8),
              _MorePanelPageIndicator(count: pageCount, active: clampedIndex),
            ],
          ],
        ),
      ),
    );
  }
}

class _MorePanelPageIndicator extends StatelessWidget {
  const _MorePanelPageIndicator({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: i == active ? 16 : 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: i == active
                  ? MoyuColors.of(context).primary
                  : MoyuColors.of(context).textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}
