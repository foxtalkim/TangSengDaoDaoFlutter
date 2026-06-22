import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class VoicePlaybackState {
  const VoicePlaybackState({
    this.currentKey = '',
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final String currentKey;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  bool isCurrent(String key) => key.isNotEmpty && key == currentKey;

  double get progress {
    if (duration.inMilliseconds <= 0) return 0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  VoicePlaybackState copyWith({
    String? currentKey,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return VoicePlaybackState(
      currentKey: currentKey ?? this.currentKey,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

/// Process-wide single-instance voice player. Mirrors native iOS
/// `WKSDK.shared.mediaManager.playAudio` semantics: only one voice plays at
/// a time; tapping the same bubble toggles pause/resume; tapping a different
/// bubble stops the current and starts the new one. Widgets observe
/// [state] to rebuild their play icon and waveform progress mask.
class VoicePlayer {
  VoicePlayer._() {
    _player.onPlayerStateChanged.listen((s) {
      final isPlaying = s == PlayerState.playing;
      state.value = state.value.copyWith(isPlaying: isPlaying);
    });
    _player.onPositionChanged.listen((p) {
      state.value = state.value.copyWith(position: p);
    });
    _player.onDurationChanged.listen((d) {
      state.value = state.value.copyWith(duration: d);
    });
    _player.onPlayerComplete.listen((_) async {
      final finishedKey = state.value.currentKey;
      state.value = const VoicePlaybackState();
      // Auto-advance: native iOS WKVoiceMessageCell `iteraPlayVoice`
      // chains to the next unread voice message in the same channel
      // when the previous finishes. The chat passes us a callback that
      // resolves the next eligible (key, source) pair given the one
      // that just played.
      final owner = _autoAdvanceOwner;
      final resolver = _onCompleteResolveNext;
      if (resolver == null || finishedKey.isEmpty) return;
      final next = await resolver(finishedKey);
      if (next == null) return;
      if (!identical(owner, _autoAdvanceOwner)) return;
      state.value = VoicePlaybackState(currentKey: next.key, isPlaying: true);
      await _player.play(next.source);
    });
  }

  /// Optional hook the chat installs so the player can ask "given that
  /// `<key>` just finished, is there another unread voice message I
  /// should auto-play?". Returns null when the chain ends.
  Object? _autoAdvanceOwner;
  Future<({String key, Source source})?> Function(String finishedKey)?
  _onCompleteResolveNext;

  static final VoicePlayer instance = VoicePlayer._();

  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<VoicePlaybackState> state = ValueNotifier(
    const VoicePlaybackState(),
  );

  void setAutoAdvanceResolver({
    required Object owner,
    required Future<({String key, Source source})?> Function(String finishedKey)
    resolver,
  }) {
    _autoAdvanceOwner = owner;
    _onCompleteResolveNext = resolver;
  }

  bool clearAutoAdvanceResolver(Object owner) {
    if (!identical(_autoAdvanceOwner, owner)) return false;
    _autoAdvanceOwner = null;
    _onCompleteResolveNext = null;
    return true;
  }

  Future<void> playOrToggle({
    required String key,
    required Source source,
  }) async {
    final current = state.value;
    if (current.currentKey == key) {
      if (current.isPlaying) {
        await _player.pause();
      } else {
        await _player.resume();
      }
      return;
    }
    await _player.stop();
    state.value = VoicePlaybackState(currentKey: key, isPlaying: true);
    await _player.play(source);
  }

  Future<void> stop() async {
    await _player.stop();
    state.value = const VoicePlaybackState();
  }
}
