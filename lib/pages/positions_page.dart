import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/breakpoints.dart';
import '../core/utils/dates.dart';
import '../core/utils/format.dart';
import '../domain/position_book.dart';

/// 持仓：当前持仓（自动计算）+ 已了结交易档案
class PositionsPage extends ConsumerWidget {
  const PositionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(positionBookProvider);
    final instruments = ref.watch(instrumentByIdProvider);
    final tradesError = ref.watch(tradesProvider).hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('持仓')),
      body: tradesError
          ? _errorView(context)
          : bookAsync == null
              ? const Center(child: CircularProgressIndicator())
              : Builder(builder: (context) {
              final book = bookAsync;
              if (book.holdings.isEmpty && book.closedRounds.isEmpty) {
                return _empty(context);
              }
              final holdingCards = [
                for (final h in book.holdings.values.toList()
                  ..sort((a, b) => b.marketValue.compareTo(a.marketValue)))
                  _HoldingCard(holding: h, name: _nameOf(instruments, h.instrumentId)),
              ];
              final closedCards = [
                for (final r in book.closedRounds)
                  _ClosedTile(round: r, name: _nameOf(instruments, r.instrumentId)),
              ];
              return AdaptiveCardGrid(
                children: [
                  ...holdingCards,
                  if (closedCards.isNotEmpty) _sectionLabel(context, '已了结交易'),
                  ...closedCards,
                ],
              );
            }),
    );
  }

  String _nameOf(Map<int, dynamic> instruments, int id) {
    final i = instruments[id];
    return i == null ? '$id' : '${i.name}（${i.code}）';
  }

  Widget _errorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          const Text('数据读取失败，请重启应用重试'),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 56, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text('还没有持仓', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text('去「交易」页记一笔后自动生成',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  static Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

/// 窄屏单列、宽屏（折叠展开/平板）双列
class AdaptiveCardGrid extends StatelessWidget {
  const AdaptiveCardGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (!wide)
          ...children
        else
          for (var i = 0; i < children.length; i += 2)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: children[i]),
                const SizedBox(width: 12),
                Expanded(
                    child: i + 1 < children.length
                        ? children[i + 1]
                        : const SizedBox.shrink()),
              ],
            ),
      ],
    );
  }
}

class _HoldingCard extends ConsumerWidget {
  const _HoldingCard({required this.holding, required this.name});

  final Holding holding;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pnl = holding.floatingPnl;
    final pnlColor =
        pnl == null ? AppColors.flat : AppColors.ofPnl(pnl);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium),
                ),
                Text(
                  '${holding.quantity.toStringAsFixed(holding.quantity % 1 == 0 ? 0 : 2)}股',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _row(theme, '摊薄成本', '${money(holding.avgCost)}/股'),
            _row(theme, '现价',
                holding.lastPrice == null ? '未填' : '${money(holding.lastPrice!)}/股'),
            _row(theme, '浮动盈亏',
                pnl == null ? '填价后计算' : signedMoney(pnl),
                valueColor: pnlColor),
            if (holding.floatingPct != null)
              _row(theme, '浮动比例', signedPct(holding.floatingPct! * 100),
                  valueColor: pnlColor),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _editPrice(context, ref),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: Text(holding.lastPrice == null ? '填现价' : '更新现价'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: valueColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _editPrice(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
        text: holding.lastPrice?.toStringAsFixed(2) ?? '');
    final price = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('填写现价'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: '如 1680.50'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(controller.text.trim())),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (price != null && price > 0) {
      await ref
          .read(priceRepositoryProvider)
          .setTodayPrice(holding.instrumentId, price);
    }
  }
}

class _ClosedTile extends StatelessWidget {
  const _ClosedTile({required this.round, required this.name});

  final ClosedRound round;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.ofPnl(round.realizedPnl);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${shortDate(round.openedAt)} → ${shortDate(round.closedAt)}'
          ' · 持有${round.holdingDays}天'
          ' · 投入 ${money(round.totalBuyAmount)}',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(signedMoney(round.realizedPnl),
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.w600)),
            Text(
              round.totalBuyAmount > 0
                  ? signedPct(round.realizedPnl / round.totalBuyAmount * 100)
                  : '',
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
