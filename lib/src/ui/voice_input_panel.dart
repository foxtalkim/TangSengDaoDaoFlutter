import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

class VoiceInputPanel extends StatefulWidget {
  const VoiceInputPanel({
    super.key,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
    this.amplitudes,
  });

  final Future<void> Function() onStart;
  final Future<void> Function() onStop;
  final Future<void> Function() onCancel;

  /// Builder returning the live amplitude stream once recording has
  /// started. Null when the host doesn't expose one (legacy callers /
  /// fake services); panel falls back to a static idle waveform.
  final Stream<double>? Function({Duration interval})? amplitudes;

  @override
  State<VoiceInputPanel> createState() => VoiceInputPanelState();
}

class VoiceInputPanelState extends State<VoiceInputPanel> {
  Timer? _timer;
  bool _recording = false;
  int _seconds = 0;
  StreamSubscription<double>? _ampSub;
  // Sliding window of the most recent normalized amplitudes 0..1.
  // Length = bar count rendered (newest on the right).
  final List<double> _ampWindow = List.filled(20, 0.05);

  /// True while the user has dragged the finger above the cancel
  /// threshold during a hold-recording. Releasing in this state
  /// cancels instead of sending. Mirrors native iOS slide-to-cancel.
  bool _pendingCancel = false;

  /// Vertical drag distance from the touch-down point. Negative when
  /// dragged upward.
  double _dragDy = 0;

  /// Drag-up threshold above which a release cancels the recording.
  /// Native iOS `WKVoiceMessageInputView` and Android use **50pt**
  /// (per voice-recording-panel.md §4.3 / §5 P1 spec). Earlier value
  /// of -60 was off-by-10 vs native; locking parity here so the
  /// haptic-cancel feel matches the iPhone WeChat-style record HUD.
  static const double _cancelThreshold = -50;

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_ampSub?.cancel());
    super.dispose();
  }

  void _startAmplitudeListener() {
    _ampSub?.cancel();
    final stream = widget.amplitudes?.call(
      interval: const Duration(milliseconds: 80),
    );
    if (stream == null) return;
    _ampSub = stream.listen((v) {
      if (!mounted || !_recording) return;
      setState(() {
        _ampWindow
          ..removeAt(0)
          ..add(v.clamp(0.05, 1.0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_recording)
            SizedBox(
              height: 28,
              child: CustomPaint(
                size: const Size(double.infinity, 28),
                painter: _VoiceLiveWaveformPainter(
                  amplitudes: _ampWindow,
                  cancelMode: _pendingCancel,
                ),
              ),
            ),
          if (_recording) const SizedBox(height: 12),
          // Press-and-hold mic button. Hold to record, slide upward past
          // 50pt to enter cancel state (matches native iOS / Android),
          // release to send (or cancel). Mirrors WeChat / native iOS
          // WKVoiceMessageInputView flow.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPressStart: (_) => unawaited(_start()),
            onLongPressMoveUpdate: (details) {
              final dy = details.offsetFromOrigin.dy;
              final shouldCancel = dy < _cancelThreshold;
              if (dy != _dragDy || shouldCancel != _pendingCancel) {
                setState(() {
                  _dragDy = dy;
                  _pendingCancel = shouldCancel;
                });
              }
            },
            onLongPressEnd: (_) => unawaited(_finish()),
            onLongPressCancel: () => unawaited(_finish()),
            child: Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _pendingCancel
                    ? const LinearGradient(
                        colors: [Color(0xFFFF5C5C), Color(0xFFB8112B)],
                      )
                    : MoyuInk.bubbleSendGradientOf(context),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 18,
                    spreadRadius: -4,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _pendingCancel ? Icons.delete_outline : Icons.mic,
                color: MoyuColors.of(context).background,
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            !_recording
                ? t.chatVoiceHoldToRecord
                : _pendingCancel
                ? t.chatVoiceReleaseToCancel(_formatDuration(_seconds))
                : t.chatVoiceRecordingSlideCancel(_formatDuration(_seconds)),
            style: TextStyle(
              color: _pendingCancel
                  ? MoyuColors.of(context).red
                  : MoyuColors.of(context).textTertiary,
              fontSize: 12,
              fontWeight: _pendingCancel ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _start() async {
    if (_recording) return;
    try {
      await widget.onStart();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _recording = true;
      _seconds = 0;
      _dragDy = 0;
      _pendingCancel = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds += 1);
    });
    _startAmplitudeListener();
  }

  /// Called on long-press end / cancel. Routes to send or cancel
  /// depending on whether the finger was above the cancel threshold.
  Future<void> _finish() async {
    if (!_recording) return;
    final cancel = _pendingCancel;
    _timer?.cancel();
    try {
      if (cancel) {
        await widget.onCancel();
      } else {
        await widget.onStop();
      }
    } catch (_) {
      // Ignore — UI will still flip back to idle below.
    }
    unawaited(_ampSub?.cancel());
    _ampSub = null;
    if (!mounted) return;
    setState(() {
      _recording = false;
      _seconds = 0;
      _dragDy = 0;
      _pendingCancel = false;
      // reset to idle bars
      for (var i = 0; i < _ampWindow.length; i++) {
        _ampWindow[i] = 0.05;
      }
    });
  }

  static String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}

/// Vertical-bars waveform that scrolls right→left with each new
/// amplitude sample. Newest sample is the right-most bar; bars extend
/// symmetrically up + down from a baseline. Cancel mode tints red.
/// Distinct from the static voice-bubble waveform painter used for
/// playback progress.
class _VoiceLiveWaveformPainter extends CustomPainter {
  const _VoiceLiveWaveformPainter({
    required this.amplitudes,
    required this.cancelMode,
  });

  final List<double> amplitudes;
  final bool cancelMode;

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;
    final paint = Paint()
      ..color = cancelMode ? const Color(0xFFFF5C5C) : const Color(0xFF2E7BFF)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final spacing = size.width / amplitudes.length;
    final centerY = size.height / 2;
    for (var i = 0; i < amplitudes.length; i++) {
      final h = (size.height * 0.9) * amplitudes[i];
      final x = spacing * (i + 0.5);
      canvas.drawLine(
        Offset(x, centerY - h / 2),
        Offset(x, centerY + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VoiceLiveWaveformPainter old) =>
      old.amplitudes != amplitudes || old.cancelMode != cancelMode;
}
