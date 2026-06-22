import 'package:flutter/material.dart';

import 'moyu_theme.dart';

/// Bottom-of-list typing bubble. Mirrors native iOS `WKTypingMessageCell`
/// which appends after the last real message while a peer is typing.
class TypingBottomBubble extends StatelessWidget {
  const TypingBottomBubble({
    super.key,
    required this.label,
    this.reserveAvatarSlot = false,
  });

  final String label;

  /// Group chats reserve a 32pt avatar slot on the left so the typing bubble
  /// lines up under peer message bubbles.
  final bool reserveAvatarSlot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 0, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (reserveAvatarSlot) const SizedBox(width: 32),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: MoyuColors.of(context).background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F0F1116),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: MoyuColors.of(context).textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const TypingDots(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 3),
              Opacity(
                opacity: _phaseOpacity((_controller.value + i * 0.33) % 1.0),
                child: const _Dot(),
              ),
            ],
          ],
        );
      },
    );
  }

  double _phaseOpacity(double t) {
    final tri = t < 0.5 ? t * 2 : (1 - t) * 2;
    return 0.3 + 0.7 * tri;
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: MoyuColors.of(context).textTertiary,
        shape: BoxShape.circle,
      ),
    );
  }
}
