import '../../domain/position_book.dart' show dateKey;

const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

/// '08-28 周五'
String shortDate(DateTime dt) =>
    '${dt.month.toString().padLeft(2, '0')}-'
    '${dt.day.toString().padLeft(2, '0')} 周${_weekdays[dt.weekday - 1]}';

/// 分组标题：今天 / 昨天 / 08-26 周三
String groupTitle(DateTime dt, DateTime now) {
  final key = dateKey(dt);
  if (key == dateKey(now)) return '今天';
  if (key == dateKey(now.subtract(const Duration(days: 1)))) return '昨天';
  return shortDate(dt);
}

/// '14:35'
String hhmm(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

/// 日期显示用（表单默认值）：'2026-08-28 14:35'
String dateTimeLabel(DateTime dt) => '${dateKey(dt)} ${hhmm(dt)}';
