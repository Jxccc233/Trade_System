import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../domain/position_book.dart' show dateKey;

/// 月历：每格显示当日盈亏（红涨绿跌着色）与是否已复盘（角标）
class PnlCalendar extends StatelessWidget {
  const PnlCalendar({
    super.key,
    required this.month,
    required this.pnlByDay,
    required this.reviewedDates,
    required this.onTapDay,
  });

  /// 当月任意一天
  final DateTime month;
  final Map<String, double> pnlByDay;
  final Set<String> reviewedDates;
  final void Function(DateTime day) onTapDay;

  static const _weekLabels = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final first = DateTime(month.year, month.month, 1);
    // 周一为一周起点
    final leading = (first.weekday - 1) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final today = DateTime.now();
    final todayKey = dateKey(today);

    return Column(
      children: [
        // 表头
        Row(
          children: [
            for (final w in _weekLabels)
              Expanded(
                child: Center(
                  child: Text(w,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.9,
          ),
          itemCount: leading + daysInMonth,
          itemBuilder: (context, index) {
            if (index < leading) return const SizedBox.shrink();
            final day = index - leading + 1;
            final date = DateTime(month.year, month.month, day);
            final key = dateKey(date);
            final pnl = pnlByDay[key];
            final reviewed = reviewedDates.contains(key);
            final isFuture = date.isAfter(DateTime(
                today.year, today.month, today.day));
            final isToday = key == todayKey;

            return InkWell(
              onTap: isFuture ? null : () => onTapDay(date),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: isToday
                      ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                      : null,
                  color: pnl == null
                      ? null
                      : AppColors.ofPnl(pnl).withValues(alpha: 0.14),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$day',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isToday ? FontWeight.bold : null,
                          color: isFuture
                              ? theme.colorScheme.outline
                              : null,
                        )),
                    if (pnl != null)
                      Text(
                        (pnl > 0 ? '+' : '') + pnl.toStringAsFixed(0),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.ofPnl(pnl),
                        ),
                      )
                    else if (reviewed)
                      Icon(Icons.check_circle,
                          size: 14, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
