import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/breakpoints.dart';
import '../core/utils/format.dart';
import '../domain/position_book.dart';
import '../domain/stats.dart';

/// 统计：核心指标 + 累计已实现盈亏曲线
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(positionBookProvider);
    final tradeCount = ref.watch(tradesProvider).valueOrNull?.length ?? 0;
    final stats =
        book == null ? null : computeStats(book: book, tradeCount: tradeCount);

    return Scaffold(
      appBar: AppBar(title: const Text('统计')),
      body: stats == null
          ? const Center(child: CircularProgressIndicator())
          : CenteredConstrainedBox(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _IndicatorGrid(stats: stats),
                  const SizedBox(height: 12),
                  if ((book!.realizedPnlByDay).isNotEmpty) ...[
                    _ChartCard(title: '累计已实现盈亏', book: book),
                    const SizedBox(height: 12),
                  ],
                  _RoundsCard(book: book),
                ],
              ),
            ),
    );
  }
}

class _IndicatorGrid extends StatelessWidget {
  const _IndicatorGrid({required this.stats});

  final TradeStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _big(theme, '累计已实现盈亏',
                      signedMoney(stats.totalRealizedPnl),
                      AppColors.ofPnl(stats.totalRealizedPnl)),
                ),
                Expanded(
                  child: _big(theme, '胜率',
                      stats.winRate == null ? '—' : pct(stats.winRate! * 100),
                      null),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                    child: _small(theme, '盈亏比',
                        stats.profitFactor?.toStringAsFixed(2) ?? '—')),
                Expanded(
                    child: _small(theme, '交易笔数', '${stats.tradeCount}')),
                Expanded(
                    child: _small(theme, '了结轮数', '${stats.roundCount}')),
                Expanded(
                    child: _small(
                        theme, '手续费', money(stats.totalFee))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _big(ThemeData theme, String label, String value, Color? color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _small(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.book});

  final String title;
  final PositionBook book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final series = cumulativePnlByDay(book.realizedPnlByDay);
    final spots = <FlSpot>[
      for (var i = 0; i < series.length; i++)
        FlSpot(i.toDouble(), series[i].cum),
    ];
    final last = series.last.cum;
    final color = AppColors.ofPnl(last);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval:
                        ((series.last.cum.abs() / 3).clamp(1, double.infinity)),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 56,
                        getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                            style: theme.textTheme.labelSmall),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (series.length / 4).clamp(1, double.infinity),
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= series.length) {
                            return const SizedBox.shrink();
                          }
                          // MM-dd
                          final d = series[i].date.substring(5);
                          return Text(d,
                              style: theme.textTheme.labelSmall);
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 2.5,
                      color: color,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                  lineTouchData: const LineTouchData(enabled: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundsCard extends ConsumerWidget {
  const _RoundsCard({required this.book});

  final PositionBook book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final instruments = ref.watch(instrumentByIdProvider);
    if (book.closedRounds.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('盈亏归因（按了结轮次）',
                style: theme.textTheme.titleSmall),
          ),
          for (final r in book.closedRounds.take(20))
            ListTile(
              dense: true,
              title: Text(_name(instruments, r.instrumentId)),
              subtitle: Text(
                  '胜率 ${r.realizedPnl > 0 ? "盈利" : "亏损"} · 持有${r.holdingDays}天',
                  style: theme.textTheme.bodySmall),
              trailing: Text(
                signedMoney(r.realizedPnl),
                style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.ofPnl(r.realizedPnl)),
              ),
            ),
        ],
      ),
    );
  }

  String _name(Map<int, dynamic> instruments, int id) {
    final i = instruments[id];
    return i == null ? '$id' : '${i.name}（${i.code}）';
  }
}
