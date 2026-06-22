import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../chat/chat_message.dart';
import '../im/wukong_im_service.dart';
import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

typedef PinnedMessageBubbleBuilder =
    Widget Function(
      BuildContext context,
      ChatMessage message,
      String timeLabel,
    );

/// 聊天页顶部 pin 消息 banner —— 对齐 iOS WKPinnedView。
/// 设计 (iOS WKPinnedView.m):
///   - 高 50pt 固定
///   - 左侧竖条，多条按比例显当前位置
///   - title: "置顶消息" + 多条时 "i/N"，13 w600
///   - 下方 content digest: 当前 pinned 消息 payload 文本，15 w400
class PinnedMessagesBanner extends StatefulWidget {
  const PinnedMessagesBanner({
    super.key,
    required this.messages,
    required this.onOpenList,
    required this.onClearAll,
    required this.onLocate,
  });

  final List<WukongPinnedMessageSnapshot> messages;
  final VoidCallback onOpenList;
  final VoidCallback onClearAll;
  final void Function(WukongPinnedMessageSnapshot message) onLocate;

  static const double height = 50;

  @override
  State<PinnedMessagesBanner> createState() => _PinnedMessagesBannerState();
}

class _PinnedMessagesBannerState extends State<PinnedMessagesBanner> {
  int _currentIndex = 0;

  @override
  void didUpdateWidget(PinnedMessagesBanner old) {
    super.didUpdateWidget(old);
    if (_currentIndex >= widget.messages.length) {
      _currentIndex = 0;
    }
  }

  void _onRowTap() {
    final messages = widget.messages;
    if (messages.isEmpty) return;
    if (messages.length > 1) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % messages.length;
      });
    }
    widget.onLocate(messages[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final messages = widget.messages;
    if (messages.isEmpty) return const SizedBox.shrink();
    final current = messages[_currentIndex.clamp(0, messages.length - 1)];
    final total = messages.length;
    final isMulti = total > 1;
    final title = isMulti
        ? t.pinnedMessageTitleWithIndex(_currentIndex + 1, total)
        : t.pinnedMessageTitle;
    final preview = current.text.isEmpty ? t.pinnedMessageOpen : current.text;

    return SizedBox(
      height: PinnedMessagesBanner.height,
      child: FTappable(
        onPress: _onRowTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
          child: Row(
            children: [
              _PinnedStripe(
                count: total,
                currentIndex: _currentIndex.clamp(0, total - 1),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: MoyuColors.of(context).textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.08,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: MoyuColors.of(context).textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              if (isMulti)
                MoyuRoundIconButton(
                  icon: FIcons.list,
                  tooltip: t.pinnedMessageViewAllTooltip,
                  onPressed: widget.onOpenList,
                )
              else
                MoyuRoundIconButton(
                  icon: FIcons.x,
                  tooltip: t.pinnedMessageUnpinTooltip,
                  onPressed: widget.onClearAll,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinnedStripe extends StatelessWidget {
  const _PinnedStripe({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  static const double _totalHeight = 28;
  static const double _gap = 2;
  static const double _width = 3;
  static const int _maxSegments = 5;

  @override
  Widget build(BuildContext context) {
    final primary = MoyuColors.of(context).primary;
    if (count <= 1 || count > _maxSegments) {
      return Container(
        width: _width,
        height: _totalHeight,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(_width / 2),
        ),
      );
    }
    final segmentH = (_totalHeight - _gap * (count - 1)) / count;
    return SizedBox(
      width: _width,
      height: _totalHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            Container(
              width: _width,
              height: segmentH,
              decoration: BoxDecoration(
                color: i == currentIndex
                    ? primary
                    : primary.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(_width / 2),
              ),
            ),
            if (i != count - 1) const SizedBox(height: _gap),
          ],
        ],
      ),
    );
  }
}

/// 置顶消息列表页 — 对齐 iOS WKPinnedMessageListVC 的 modal 简化布局。
class PinnedMessagesPage extends StatelessWidget {
  const PinnedMessagesPage({
    super.key,
    required this.messages,
    required this.onClearAll,
    required this.onLocate,
    required this.backgroundDecoration,
    required this.messageById,
    required this.messageBuilder,
  });

  final List<WukongPinnedMessageSnapshot> messages;
  final Future<void> Function() onClearAll;
  final void Function(WukongPinnedMessageSnapshot message) onLocate;
  final Decoration backgroundDecoration;
  final Map<String, ChatMessage> messageById;
  final PinnedMessageBubbleBuilder messageBuilder;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tiles = _buildList(context);
    return Scaffold(
      backgroundColor: MoyuColors.of(context).background,
      appBar: AppBar(
        backgroundColor: MoyuColors.of(context).background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: MoyuColors.of(context).primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            t.actionClose,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
        leadingWidth: 80,
        title: Text(
          t.pinnedMessageListCount(messages.length),
          style: TextStyle(
            color: MoyuColors.of(context).textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: backgroundDecoration,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: tiles,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              color: MoyuColors.of(context).background,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: FTappable(
                onPress: () async {
                  await onClearAll();
                  if (context.mounted) Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Text(
                    t.pinnedMessageClearAll,
                    style: TextStyle(
                      color: MoyuColors.of(context).red,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    final tiles = <Widget>[];
    String? lastDate;
    for (final pin in messages) {
      final dateLabel = pin.timestamp > 0
          ? _formatPinnedDate(pin.timestamp * 1000)
          : '';
      if (dateLabel.isNotEmpty && dateLabel != lastDate) {
        tiles.add(_PinnedDateChip(label: dateLabel));
        lastDate = dateLabel;
      }
      tiles.add(
        _PinnedMessageTile(
          snapshot: pin,
          message: messageById[pin.messageId],
          messageBuilder: messageBuilder,
          onJump: () {
            onLocate(pin);
            Navigator.of(context).pop();
          },
        ),
      );
    }
    return tiles;
  }

  static String _formatPinnedDate(int millis) {
    final ts = DateTime.fromMillisecondsSinceEpoch(millis);
    final y = ts.year.toString().padLeft(4, '0');
    final m = ts.month.toString().padLeft(2, '0');
    final d = ts.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

class _PinnedDateChip extends StatelessWidget {
  const _PinnedDateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: MoyuColors.of(context).textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PinnedMessageTile extends StatelessWidget {
  const _PinnedMessageTile({
    required this.snapshot,
    required this.message,
    required this.messageBuilder,
    required this.onJump,
  });

  final WukongPinnedMessageSnapshot snapshot;
  final ChatMessage? message;
  final PinnedMessageBubbleBuilder messageBuilder;
  final VoidCallback onJump;

  @override
  Widget build(BuildContext context) {
    final timeLabel = snapshot.timestamp > 0
        ? _formatHM(snapshot.timestamp * 1000)
        : '';
    final maxBubbleWidth = MediaQuery.sizeOf(context).width - 80;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 12, 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            child: IntrinsicWidth(child: _buildBody(context, timeLabel)),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FTappable(
              onPress: onJump,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: MoyuColors.of(context).primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  FIcons.arrowRight,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, String timeLabel) {
    final msg = message;
    if (msg == null) {
      return _buildTextFallback(context, timeLabel);
    }
    return messageBuilder(context, msg, timeLabel);
  }

  Widget _buildTextFallback(BuildContext context, String timeLabel) {
    final text = snapshot.text.isEmpty
        ? AppLocalizations.of(context).pinnedMessageFallback
        : snapshot.text;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: MoyuColors.of(context).background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 6,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              height: 1.35,
              color: MoyuColors.of(context).textPrimary,
            ),
          ),
          if (timeLabel.isNotEmpty) PinnedMetaRow(time: timeLabel),
        ],
      ),
    );
  }

  static String _formatHM(int millis) {
    final ts = DateTime.fromMillisecondsSinceEpoch(millis);
    final h = ts.hour.toString().padLeft(2, '0');
    final m = ts.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class PinnedMetaRow extends StatelessWidget {
  const PinnedMetaRow({super.key, required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(FIcons.pin, size: 10, color: MoyuColors.of(context).textSecondary),
        const SizedBox(width: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: MoyuColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}
