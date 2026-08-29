import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/adaptive_card_grid.dart';
import '../core/utils/format.dart';
import '../data/db/tables.dart';
import '../data/repositories.dart';
import '../domain/position_book.dart' show dateKey, Holding;
import '../core/utils/dates.dart';
import 'settings_page.dart';
import 'trade_entry_page.dart';

/// 今日仪表盘：当日已实现盈亏、持仓概览、今日交易
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final book = ref.watch(positionBookProvider);
    final trades = ref.watch(tradesProvider).valueOrNull ?? const [];

    final todayTrades = trades
        .where((t) => dateKey(t.trade.tradedAt) == dateKey(DateTime.now()))
        .toList();
    final todayPnl = book?.realizedPnlByDay[dateKey(DateTime.now())];
    final holdings = book?.holdings.values.toList() ?? const <Holding>[];
    final totalMarketValue = holdings.fold<double>(
        0, (s, h) => s + (h.lastPrice == null ? 0 : h.quantity * h.lastPrice!));
    final totalFloat = holdings.fold<double>(
        0, (s, h) => s + (h.floatingPnl ?? 0));
    final pricedCount =
        holdings.where((h) => h.lastPrice != null).length;

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
      body: AdaptiveCardGrid(
        children: [
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('今日已实现盈亏',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    Text(
                      todayPnl == null ? '—' : signedMoney(todayPnl),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color:
                            todayPnl == null ? AppColors.flat : AppColors.ofPnl(todayPnl),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      holdings.isEmpty
                          ? '暂无持仓'
                          : '持仓 ${holdings.length} 只 · 市值 ${money(totalMarketValue)}'
                              '${pricedCount < holdings.length ? '（$pricedCount/${holdings.length} 已填价）' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (holdings.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '浮动盈亏 ${signedMoney(totalFloat)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.ofPnl(totalFloat)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (todayTrades.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
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
            const SizedBox(height: 4),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.event_note_outlined,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('收盘后记得写复盘（M2 上线日历与复盘表单）',
                          style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
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
            '${hhmm(t.tradedAt)} · ${t.quantity.toStringAsFixed(t.quantity % 1 == 0 ? 0 : 2)}股 × ${t.price.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall),
        trailing: t.emotion == null
            ? null
            : Chip(
                label: Text(t.emotion!,
                    style: theme.textTheme.labelSmall),
                visualDensity: VisualDensity.compact,
              ),
      ),
    );
  }
}
