import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/format.dart';
import '../data/db/tables.dart';
import '../data/repositories.dart';
import '../domain/position_book.dart' show dateKey, Holding;
import 'batch_price_page.dart';
import 'review_edit_page.dart';
import 'settings_page.dart';
import 'trade_entry_page.dart';

/// 今日仪表盘：当日总盈亏头条 + 盘后三件事 + 今日交易（§5.11）
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final daily = ref.watch(dailyPnlProvider);
    final book = ref.watch(positionBookProvider);
    final trades = ref.watch(tradesProvider).valueOrNull ?? [];

    final today = DateTime.now();
    final todayTrades = trades
        .where((t) => dateKey(t.trade.tradedAt) == dateKey(today))
        .toList();
    final holdings = book?.holdings.values.toList() ?? const <Holding>[];
    final totalMarketValue = holdings.fold<double>(
        0, (s, h) => s + (h.lastPrice == null ? 0 : h.quantity * h.lastPrice!));

    // 盘后三件事状态
    final history = ref.watch(priceHistoryProvider).valueOrNull ?? const {};
    final priceDone = holdings.isEmpty
        ? true
        : holdings.every((h) => (history[h.instrumentId] ?? const [])
            .any((e) => e.date == dateKey(today)));
    final reviewDone =
        ref.watch(reviewsProvider).valueOrNull?[dateKey(today)] != null;
    final seenDone = priceDone && (daily?.isApproximate == false);
    final showRoutine = today.hour >= 15 || priceDone || reviewDone;

    return Scaffold(
      appBar: AppBar(
        title: const Text('今日'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const SettingsPage())),
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const TradeEntryPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 头条：当日总盈亏
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('当日总盈亏',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Text(
                    daily == null
                        ? '—'
                        : '${daily.isApproximate ? '约 ' : ''}${signedMoney(daily.totalPnl)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: daily == null || daily.totalPnl == 0
                          ? AppColors.flat
                          : AppColors.ofPnl(daily.totalPnl),
                    ),
                  ),
                  if (daily != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '已实现 ${signedMoney(daily.realized)} · 持仓变动 ${signedMoney(daily.holdingChange)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    holdings.isEmpty
                        ? '暂无持仓'
                        : '持仓 ${holdings.length} 只 · 市值 ${money(totalMarketValue)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),

          // 盘后三件事（收盘后出现，§5.11）
          if (showRoutine) ...[
            _RoutineCard(
              priceDone: priceDone,
              seenDone: seenDone,
              reviewDone: reviewDone,
              onPrice: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const BatchPricePage())),
              onReview: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ReviewEditPage(date: DateTime.now()))),
            ),
          ],

          if (todayTrades.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text('今日交易（${todayTrades.length} 笔）',
                  style: theme.textTheme.titleSmall),
            ),
            for (final t in todayTrades) _TodayTradeTile(item: t),
          ] else
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.coffee_outlined,
                        color: theme.colorScheme.outline),
                    const SizedBox(width: 12),
                    Text('今天还没有交易',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.priceDone,
    required this.seenDone,
    required this.reviewDone,
    required this.onPrice,
    required this.onReview,
  });

  final bool priceDone;
  final bool seenDone;
  final bool reviewDone;
  final VoidCallback onPrice;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget item(IconData icon, String title, bool done, VoidCallback onTap,
        [String? doneText]) {
      return ListTile(
        dense: true,
        leading: Icon(
          done ? Icons.check_circle : icon,
          color: done ? AppColors.down : theme.colorScheme.primary,
        ),
        title: Text(title),
        trailing: done
            ? Text(doneText ?? '已完成',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant))
            : const Icon(Icons.chevron_right),
        onTap: done ? null : onTap,
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('盘后三件事', style: theme.textTheme.titleSmall),
          ),
          item(Icons.edit_note_outlined, '① 填价：批量更新持仓现价', priceDone,
              onPrice, '已填'),
          item(Icons.visibility_outlined, '② 看账：当日总盈亏', seenDone, onPrice),
          item(Icons.event_note_outlined, '③ 复盘：写下今天的心得', reviewDone,
              onReview),
        ],
      ),
    );
  }
}

class _TodayTradeTile extends StatelessWidget {
  const _TodayTradeTile({required this.item});

  final TradeWithInstrument item;

  @override
  Widget build(BuildContext context) {
    final t = item.trade;
    final isBuy = t.side == TradeSide.buy;
    final theme = Theme.of(context);
    final hh = t.tradedAt.hour.toString().padLeft(2, '0');
    final mm = t.tradedAt.minute.toString().padLeft(2, '0');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Text(isBuy ? '买' : '卖',
            style: theme.textTheme.titleMedium?.copyWith(
                color: isBuy ? AppColors.up : AppColors.down)),
        title: Text(item.instrument.name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
            '$hh:$mm · ${t.quantity.toStringAsFixed(t.quantity % 1 == 0 ? 0 : 2)}股 × ${t.price.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall),
        trailing: t.emotion == null
            ? null
            : Chip(
                label: Text(t.emotion!, style: theme.textTheme.labelSmall),
                visualDensity: VisualDensity.compact,
              ),
      ),
    );
  }
}
