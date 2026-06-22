import 'dart:math' as math;

import '../chat/chat_message.dart';
import '../media/chat_media_service.dart';

int effectiveFlameSecondsForMessage({
  required bool flameEnabled,
  required int flameSecond,
  required ChatMessage message,
}) {
  if (!flameEnabled) return 0;
  if (flameSecond <= 0) return 0;
  var seconds = flameSecond;
  if (message.kind == ChatMediaKind.voice) {
    final voiceDuration = message.attachment?.durationSeconds ?? 0;
    if (voiceDuration > 0) {
      // +1s slack so the destroy fire doesn't race the player's onComplete
      // callback at the exact second boundary.
      seconds = math.max(flameSecond, voiceDuration + 1);
    }
  }
  return seconds;
}

int flameExpiresAtMsForMessage({
  required bool flameEnabled,
  required int flameSecond,
  required ChatMessage message,
}) {
  final seconds = effectiveFlameSecondsForMessage(
    flameEnabled: flameEnabled,
    flameSecond: flameSecond,
    message: message,
  );
  if (seconds <= 0) return 0;
  if (message.timestamp <= 0) return 0;
  return message.timestamp * 1000 + seconds * 1000;
}

int flameRemainingMsForTimer({
  required bool flameEnabled,
  required int flameSecond,
  required ChatMessage message,
  required int nowMs,
}) {
  final seconds = effectiveFlameSecondsForMessage(
    flameEnabled: flameEnabled,
    flameSecond: flameSecond,
    message: message,
  );
  if (seconds <= 0) return 0;
  final deadlineMs = message.timestamp > 0
      ? message.timestamp * 1000 + seconds * 1000
      : nowMs + seconds * 1000;
  return math.max(0, deadlineMs - nowMs);
}
