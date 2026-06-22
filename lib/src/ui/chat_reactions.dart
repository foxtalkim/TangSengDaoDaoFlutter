import 'package:flutter/material.dart';

import 'moyu_theme.dart';

/// iOS-compatible reaction name -> display unicode emoji.
const Map<String, String> _kReactionNameToEmoji = <String, String>{
  'anger': '😠',
  'applaud': '👏',
  'bad': '👎',
  'brain': '🧠',
  'celebrate': '🎉',
  'depressed': '😔',
  'fire': '🔥',
  'haha': '😂',
  'happy': '😊',
  'like': '👍',
  'love': '❤️',
  'please': '🙏',
  'shit': '💩',
  'shy': '😳',
  'terrified': '😱',
  'think': '🤔',
  'vomit': '🤮',
};

/// Display unicode emoji for a reaction `name`. Falls back to the name itself
/// when no mapping exists, so new server-configured reactions still show.
String reactionDisplayEmoji(String name) => _kReactionNameToEmoji[name] ?? name;

/// Compact strip of reaction chips below a bubble. Each chip shows the emoji +
/// count; tapping toggles the user's own reaction.
class ReactionStrip extends StatelessWidget {
  const ReactionStrip({
    super.key,
    required this.reactions,
    required this.isMine,
    this.onTap,
  });

  final List<Map<String, Object>> reactions;
  final bool isMine;
  final void Function(String emoji)? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 1,
      heightFactor: 1,
      child: Wrap(
        spacing: 5,
        runSpacing: 4,
        alignment: isMine ? WrapAlignment.end : WrapAlignment.start,
        children: [
          for (final r in reactions)
            _ReactionChip(
              emoji: (r['emoji'] ?? '').toString(),
              count: (r['count'] is int) ? r['count'] as int : 0,
              mine: r['mine'] == true,
              onTap: onTap == null
                  ? null
                  : () => onTap!((r['emoji'] ?? '').toString()),
            ),
        ],
      ),
    );
  }
}

class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.emoji,
    required this.count,
    required this.mine,
    this.onTap,
  });

  final String emoji;
  final int count;
  final bool mine;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    final showCount = count > 1;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DecoratedBox(
        key: ValueKey('moyu.reaction.chip.$emoji'),
        decoration: BoxDecoration(
          color: colors.background.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: mine
                ? colors.primary.withValues(alpha: 0.55)
                : colors.line.withValues(alpha: 0.9),
            width: mine ? 0.9 : 0.6,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 9,
            right: showCount ? 10 : 9,
            top: 6,
            bottom: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reactionDisplayEmoji(emoji),
                style: const TextStyle(
                  inherit: false,
                  fontSize: 17,
                  height: 1,
                  color: Color(0xFF000000),
                  fontFamily: 'Apple Color Emoji',
                  fontFamilyFallback: [
                    'Noto Color Emoji',
                    'Segoe UI Emoji',
                    'EmojiOne Color',
                    'Twemoji Mozilla',
                  ],
                ),
              ),
              if (showCount) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    color: mine ? colors.primary : colors.textSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
