import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'moyu_theme.dart';

/// Tiny corner badge showing the flame TTL on a self-destructing message.
/// When [expiresAtMs] is provided, ticks down once per second so each bubble
/// reflects its actual remaining lifetime.
class FlameBadge extends StatefulWidget {
  const FlameBadge({super.key, required this.seconds, this.expiresAtMs = 0});

  final int seconds;
  final int expiresAtMs;

  @override
  State<FlameBadge> createState() => _FlameBadgeState();
}

class _FlameBadgeState extends State<FlameBadge> {
  Timer? _ticker;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _maybeStartTicker();
  }

  @override
  void didUpdateWidget(covariant FlameBadge old) {
    super.didUpdateWidget(old);
    if (old.expiresAtMs != widget.expiresAtMs ||
        old.seconds != widget.seconds) {
      _remaining = _computeRemaining();
      _ticker?.cancel();
      _ticker = null;
      _maybeStartTicker();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  int _computeRemaining() {
    if (widget.expiresAtMs <= 0) return widget.seconds;
    final ms = widget.expiresAtMs - DateTime.now().millisecondsSinceEpoch;
    if (ms <= 0) return 0;
    // Round up so the badge stays visible through the final fractional second.
    return ((ms + 999) / 1000).floor();
  }

  void _maybeStartTicker() {
    if (widget.expiresAtMs <= 0) return;
    if (_remaining <= 0) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _computeRemaining();
      if (next == _remaining) return;
      setState(() => _remaining = next);
      if (next <= 0) {
        _ticker?.cancel();
        _ticker = null;
      }
    });
  }

  int get _totalSeconds {
    if (widget.expiresAtMs <= 0) {
      return widget.seconds > 0 ? widget.seconds : 1;
    }
    return widget.seconds > 0
        ? widget.seconds
        : (_remaining > 0 ? _remaining : 1);
  }

  double get _ringProgress {
    if (widget.expiresAtMs <= 0) return 1.0;
    final total = _totalSeconds;
    if (total <= 0) return 0.0;
    final p = _remaining / total;
    if (p < 0.0) return 0.0;
    if (p > 1.0) return 1.0;
    return p;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _FlameRingPainter(progress: _ringProgress),
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Color(0x80000000),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          FIcons.flame,
          size: 10,
          color: MoyuColors.of(context).background,
        ),
      ),
    );
  }
}

class _FlameRingPainter extends CustomPainter {
  const _FlameRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) + 1.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    final sweep = -2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FlameRingPainter old) =>
      old.progress != progress;
}
