import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/breakpoints.dart';
import '../core/widgets/pnl_calendar.dart';
import 'review_edit_page.dart';

/// 复盘：月历 + 点击进入当日复盘
class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  DateTime _month = DateTime.now();

  void _shiftMonth(int delta) {
    setState(() {
      final m = DateTime(_month.year, _month.month + delta);
      final now = DateTime.now();
      // 不能翻到未来月份之后
      if (m.isBefore(DateTime(now.year, now.month + 1))) {
        _month = m;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = ref.watch(positionBookProvider);
    final reviewsAsync = ref.watch(reviewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('复盘')),
      body: CenteredConstrainedBox(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _shiftMonth(-1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${_month.year}年${_month.month}月',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _shiftMonth(1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    PnlCalendar(
                      month: _month,
                      pnlByDay: book?.realizedPnlByDay ?? const {},
                      reviewedDates: reviewsAsync.valueOrNull?.keys.toSet() ??
                          const <String>{},
                      onTapDay: (day) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ReviewEditPage(date: day),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _MonthSummary(book: book, month: _month),
            const SizedBox(height: 8),
            const _Legend(),
          ],
        ),
      ),
    );
  }
}

class _MonthSummary extends ConsumerWidget {
  const _MonthSummary({required this.book, required this.month});

  final dynamic book;
  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final monthPnl = _monthRealized();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('本月已实现盈亏',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(
                    monthPnl == 0 ? '—' : (monthPnl > 0 ? '+' : '') + monthPnl.toStringAsFixed(2),
                    style: theme.textTheme.headlineSmall?.copyWith(
                        color: monthPnl == 0
                            ? AppColors.flat
                            : AppColors.ofPnl(monthPnl)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('本年累计',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(
                    (book?.totalRealizedPnl as double? ?? 0).toStringAsFixed(2),
                    style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.ofPnl(
                            book?.totalRealizedPnl as double? ?? 0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _monthRealized() {
    final prefix =
        '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';
    double sum = 0;
    (book?.realizedPnlByDay as Map<String, double>? ?? {}).forEach((k, v) {
      if (k.startsWith(prefix)) sum += v;
    });
    return sum;
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(AppColors.up, '盈'),
        const SizedBox(width: 4),
        Text('盈利日', style: theme.textTheme.bodySmall),
        const SizedBox(width: 16),
        _dot(AppColors.down, '亏'),
        const SizedBox(width: 4),
        Text('亏损日', style: theme.textTheme.bodySmall),
        const SizedBox(width: 16),
        Icon(Icons.check_circle, size: 14, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text('已复盘', style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _dot(Color color, String label) => Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: TextStyle(fontSize: 10, color: color)),
      );
}
