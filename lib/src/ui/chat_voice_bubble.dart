import 'package:flutter/material.dart';

import '../media/chat_media_service.dart';
import '../media/voice_player.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

Color outgoingVoiceWaveformColor(Color foreground) {
  final foregroundIsLight = foreground.computeLuminance() > 0.5;
  return foreground.withValues(alpha: foregroundIsLight ? 0.70 : 0.34);
}

Color outgoingVoicePlayBackgroundColor(Color foreground) {
  final foregroundIsLight = foreground.computeLuminance() > 0.5;
  return foreground.withValues(alpha: foregroundIsLight ? 0.16 : 0.08);
}

/// Voice-message bubble content: 28px play button + waveform with progress
/// mask + remaining-time label, sized 160-224 px wide based on voice length.
/// Mirrors native iOS `WKVoiceMessageCell`.
class VoiceBubbleContent extends StatelessWidget {
  const VoiceBubbleContent({
    super.key,
    required this.attachment,
    required this.isMine,
    required this.messageKey,
    this.unread = false,
  });

  final ChatMediaAttachment? attachment;
  final bool isMine;
  final String messageKey;

  /// True when this is a received voice message the user hasn't played yet.
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final seconds = attachment?.durationSeconds ?? 0;
    final width = (160.0 + (seconds.clamp(0, 60) / 60.0) * 64.0).clamp(
      160.0,
      224.0,
    );
    final fg = isMine
        ? MoyuInk.bubbleSendForegroundOf(context)
        : MoyuColors.of(context).textPrimary;
    final waveform = isMine
        ? outgoingVoiceWaveformColor(fg)
        : MoyuColors.of(context).textTertiary;
    final waveformActive = isMine
        ? MoyuInk.bubbleSendForegroundOf(context)
        : MoyuColors.of(context).textPrimary;

    return ValueListenableBuilder<VoicePlaybackState>(
      valueListenable: VoicePlayer.instance.state,
      builder: (context, state, child) {
        final isCurrent = state.isCurrent(messageKey);
        final isPlaying = isCurrent && state.isPlaying;
        final progress = isCurrent ? state.progress : 0.0;
        final remaining = _remainingSeconds(seconds, isCurrent, state);
        final bubble = SizedBox(
          width: width,
          height: 28,
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isMine
                      ? outgoingVoicePlayBackgroundColor(fg)
                      : MoyuColors.of(context).backgroundSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: fg,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomPaint(
                  painter: _VoiceWaveformPainter(
                    color: waveform,
                    activeColor: waveformActive,
                    progress: progress,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatVoiceDuration(remaining),
                style: TextStyle(
                  fontSize: 12,
                  color: fg.withValues(alpha: 0.85),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
        if (!unread) return bubble;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            bubble,
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: MoyuColors.of(context).red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }

  int _remainingSeconds(int seconds, bool isCurrent, VoicePlaybackState state) {
    if (!isCurrent) return seconds;
    final total = state.duration.inSeconds > 0
        ? state.duration.inSeconds
        : seconds;
    final remaining = total - state.position.inSeconds;
    if (remaining < 0) return 0;
    return remaining;
  }

  static String _formatVoiceDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _VoiceWaveformPainter extends CustomPainter {
  const _VoiceWaveformPainter({
    required this.color,
    this.activeColor,
    this.progress = 0.0,
  });

  final Color color;
  final Color? activeColor;
  final double progress;

  static const _heights = <double>[
    0.35,
    0.55,
    0.75,
    0.95,
    0.7,
    0.4,
    0.6,
    0.85,
    0.95,
    0.65,
    0.45,
    0.6,
    0.8,
    0.55,
    0.35,
    0.5,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final activePaint = Paint()
      ..color = activeColor ?? color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final clamped = progress.clamp(0.0, 1.0);
    final activeWidth = size.width * clamped;
    final gap = size.width / _heights.length;
    for (var i = 0; i < _heights.length; i++) {
      final h = _heights[i] * size.height;
      final x = gap * i + gap / 2;
      final cy = size.height / 2;
      final paint = x < activeWidth ? activePaint : basePaint;
      canvas.drawLine(Offset(x, cy - h / 2), Offset(x, cy + h / 2), paint);
    }
  }

  @override
  bool shouldRepaint(_VoiceWaveformPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.progress != progress;
}
