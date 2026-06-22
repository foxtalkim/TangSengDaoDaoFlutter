import '../chat/chat_message.dart';
import '../l10n/app_localizations.dart';

/// Walk backwards from [index], skipping non-rendered messages.
/// Returns the index of the previous visible message, or -1 when none exists.
int previousVisibleMessageIndex(List<ChatMessage> messages, int index) {
  var cursor = index - 1;
  while (cursor >= 0 && _isHiddenTimelineMessage(messages[cursor])) {
    cursor--;
  }
  return cursor;
}

/// Walk forwards from [index], skipping non-rendered messages.
/// Returns [messages.length] when no later visible message exists.
int nextVisibleMessageIndex(List<ChatMessage> messages, int index) {
  var cursor = index + 1;
  while (cursor < messages.length &&
      _isHiddenTimelineMessage(messages[cursor])) {
    cursor++;
  }
  return cursor;
}

bool _isHiddenTimelineMessage(ChatMessage message) {
  return message.isHiddenRtcSignalingFrame || message.isEmptyInboundTextMessage;
}

/// True when both indices point to non-mine, non-system messages from the same
/// sender on the same calendar day and within the same five-minute visual
/// streak window.
bool isSameLeftMessageStreak(
  List<ChatMessage> messages,
  int aIndex,
  int bIndex,
) {
  if (aIndex < 0 || aIndex >= messages.length) return false;
  if (bIndex < 0 || bIndex >= messages.length) return false;
  final a = messages[aIndex];
  final b = messages[bIndex];
  if (a.isMine || b.isMine) return false;
  if (_breaksLeftMessageStreak(a) || _breaksLeftMessageStreak(b)) {
    return false;
  }
  if (a.fromUid.isEmpty || a.fromUid != b.fromUid) return false;
  if (a.timestamp > 0 && b.timestamp > 0) {
    final aDate = DateTime.fromMillisecondsSinceEpoch(a.timestamp * 1000);
    final bDate = DateTime.fromMillisecondsSinceEpoch(b.timestamp * 1000);
    if (aDate.year != bDate.year ||
        aDate.month != bDate.month ||
        aDate.day != bDate.day) {
      return false;
    }
    if ((a.timestamp - b.timestamp).abs() >= 300) {
      return false;
    }
  }
  return true;
}

bool _breaksLeftMessageStreak(ChatMessage message) =>
    message.isSystemMessage ||
    message.isCallMessage ||
    message.isGroupInviteApproval ||
    _isHiddenTimelineMessage(message);

bool shouldInsertChatDateStamp(int? previousTimestamp, int currentTimestamp) {
  if (currentTimestamp <= 0) return false;
  if (previousTimestamp == null) return true;
  if (currentTimestamp - previousTimestamp >= 300) return true;
  final previousDate = DateTime.fromMillisecondsSinceEpoch(
    previousTimestamp * 1000,
  );
  final currentDate = DateTime.fromMillisecondsSinceEpoch(
    currentTimestamp * 1000,
  );
  return previousDate.year != currentDate.year ||
      previousDate.month != currentDate.month ||
      previousDate.day != currentDate.day;
}

/// Formats a unix-seconds timestamp into the row-divider stamp shown between
/// message bubbles. Matches native zh-CN branches from `WKDateTipCell`.
String formatChatDateStamp(AppLocalizations t, int timestamp, {DateTime? now}) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  final effectiveNow = now ?? DateTime.now();
  final today = DateTime(
    effectiveNow.year,
    effectiveNow.month,
    effectiveNow.day,
  );
  final messageDay = DateTime(date.year, date.month, date.day);
  final dayDiff = today.difference(messageDay).inDays;
  final hh = date.hour.toString().padLeft(2, '0');
  final mm = date.minute.toString().padLeft(2, '0');
  final time = '$hh:$mm';
  if (dayDiff == 0) return t.dateTodayTime(time);
  if (dayDiff == 1) return t.dateYesterdayTime(time);
  if (dayDiff > 1 && dayDiff < 7) {
    return t.dateWeekdayTime(time, _chatWeekdayName(t, date.weekday));
  }
  if (date.year == effectiveNow.year) {
    return t.dateMonthDayTime(date.day, date.month, time);
  }
  return t.dateYearMonthDayTime(date.day, date.month, time, date.year);
}

/// Formats a unix-seconds timestamp into a bare 24-hour `HH:mm` clock
/// label rendered in each bubble's bottom meta-row (Telegram-style).
/// Pure digits — no i18n needed. Returns an empty string for
/// optimistic local messages without a server timestamp (== 0) so the
/// meta-row can hide the clock until the real time arrives.
String formatChatClock(int timestamp) {
  if (timestamp <= 0) return '';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  final hh = date.hour.toString().padLeft(2, '0');
  final mm = date.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

String _chatWeekdayName(AppLocalizations t, int weekday) {
  return switch (weekday) {
    DateTime.monday => t.weekdayMonday,
    DateTime.tuesday => t.weekdayTuesday,
    DateTime.wednesday => t.weekdayWednesday,
    DateTime.thursday => t.weekdayThursday,
    DateTime.friday => t.weekdayFriday,
    DateTime.saturday => t.weekdaySaturday,
    _ => t.weekdaySunday,
  };
}
