// 时间格式化工具，对齐 iOS WuKongBase `WKTimeTool`。
//
// 来源：repo/TangSengDaoDaoiOS/Modules/WuKongBase/.../WKTimeTool.m:104-194

import '../l10n/app_localizations.dart';

/// 仿微信的人性化时间字串（朋友圈 / 通知列表用）。对齐 iOS
/// `WKTimeTool.getTimeStringAutoShort2:mustIncludeTime:`。
/// 输入：服务端原始字符串 `yyyy-MM-dd HH:mm:ss`（朋友圈 `moment.created_at`）
/// 或 iso 8601；解析不出来时原样返回。
/// 返回（`mustIncludeTime = true` 时）:
///   - 当天 60 秒内       → `刚刚`
///   - 当天其他           → `今天 HH:mm`
///   - 昨天               → `昨天 HH:mm`
///   - 前天               → `前天 HH:mm`
///   - 当年近 7 天        → `星期X HH:mm`
///   - 当年其他           → `yyyy/M/d HH:mm`
///   - 跨年               → `yyyy/M/d HH:mm`
String formatMomentTime(
  AppLocalizations t,
  String raw, {
  bool mustIncludeTime = true,
}) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  // 服务端用空格分隔 "yyyy-MM-dd HH:mm:ss"，DateTime.parse 也接受 'T'。
  final dt = DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
  if (dt == null) return trimmed;

  final now = DateTime.now();
  final hhmm =
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  // 跨年 → yyyy/M/d HH:mm
  if (dt.year != now.year) {
    return mustIncludeTime
        ? t.dateYearMonthDayTime(dt.day, dt.month, hhmm, dt.year)
        : t.dateYearMonthDay(dt.day, dt.month, dt.year);
  }

  // 当年 — 用日期比较（不是时间戳差值），跟 iOS 一致避免跨日 boundary bug
  final today = DateTime(now.year, now.month, now.day);
  final src = DateTime(dt.year, dt.month, dt.day);
  final diffDays = today.difference(src).inDays;

  // 当天
  if (diffDays == 0) {
    final deltaSec = now.difference(dt).inSeconds;
    if (deltaSec < 60) return t.dateJustNow;
    return mustIncludeTime ? t.dateTodayTime(hhmm) : t.dateToday;
  }

  // 昨天 / 前天
  if (diffDays == 1) {
    return mustIncludeTime ? t.dateYesterdayTime(hhmm) : t.dateYesterday;
  }
  if (diffDays == 2) {
    return mustIncludeTime
        ? t.dateDayBeforeYesterdayTime(hhmm)
        : t.dateDayBeforeYesterday;
  }

  // 近 7 天 → 星期X
  // iOS 用 `deltaHour <= 7*24` (=168 小时)，相当于 dt 距今 ≤ 7 天。
  // 用 inDays 比较 ≤ 7 即可。
  if (diffDays <= 7) {
    return mustIncludeTime
        ? t.dateWeekdayTime(hhmm, _weekdayName(t, dt.weekday))
        : _weekdayName(t, dt.weekday);
  }

  // 当年其他 → yyyy/M/d HH:mm (跟跨年一致格式)
  return mustIncludeTime
      ? t.dateMonthDayTime(dt.day, dt.month, hhmm)
      : t.dateMonthDay(dt.day, dt.month);
}

String _weekdayName(AppLocalizations t, int weekday) {
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
