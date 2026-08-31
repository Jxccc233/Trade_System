import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/dates.dart';
import '../core/widgets/image_viewer.dart';
import '../data/db/tables.dart';
import '../data/image_store.dart';
import '../data/repositories.dart';
import '../domain/position_book.dart' show dateKey;
import 'trade_entry_page.dart';

/// 交易流水：按交易日分组倒序
class TradesPage extends ConsumerWidget {
  const TradesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(tradesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('交易')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const TradeEntryPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
      body: tradesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('读取失败：$e')),
        data: (trades) {
          if (trades.isEmpty) {
            return const _EmptyView();
          }
          final groups = _groupByDay(trades);
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final g = groups[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Text(
                      groupTitle(g.day, DateTime.now()),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  for (final t in g.items) _TradeTile(item: t),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _DayGroup {
  _DayGroup(this.day, this.items);
  final DateTime day;
  final List<TradeWithInstrument> items;
}

List<_DayGroup> _groupByDay(List<TradeWithInstrument> trades) {
  final map = <String, _DayGroup>{};
  for (final t in trades) {
    final key = dateKey(t.trade.tradedAt);
    map.putIfAbsent(
      key,
      () => _DayGroup(DateTime(t.trade.tradedAt.year, t.trade.tradedAt.month,
          t.trade.tradedAt.day), []),
    ).items.add(t);
  }
  return map.values.toList();
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 56, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text('还没有交易记录', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text('点右下角「记一笔」开始',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _TradeTile extends ConsumerWidget {
  const _TradeTile({required this.item});

  final TradeWithInstrument item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = item.trade;
    final i = item.instrument;
    final isBuy = t.side == TradeSide.buy;
    final theme = Theme.of(context);
    final images = decodeImages(t.images);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: images.isEmpty
            ? null
            : () => showImageViewer(
                  context,
                  [for (final r in images) ImagePathResolver.resolve(r)],
                ),
        onLongPress: () => _confirmDelete(context, ref, t.id, i.name),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (isBuy ? AppColors.up : AppColors.down)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isBuy ? '买' : '卖',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isBuy ? AppColors.up : AppColors.down,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${i.name}（${i.code}）',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        Text(
                          '${t.quantity.toStringAsFixed(t.quantity % 1 == 0 ? 0 : 2)}股 × ${t.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('${hhmm(t.tradedAt)}'
                            '${t.fee > 0 ? ' · 费 ${t.fee.toStringAsFixed(2)}' : ''}'
                            '${t.emotion != null ? ' · ${t.emotion}' : ''}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                        if (images.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.image_outlined,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text('${images.length}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              )),
                        ],
                        if (t.reason != null && t.reason!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.reason!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id, String name) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除这笔交易？'),
        content: Text('删除 $name 的这条记录会影响持仓成本与统计数据。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () {
              ref.read(tradeRepositoryProvider).deleteTrade(id);
              Navigator.pop(ctx);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
