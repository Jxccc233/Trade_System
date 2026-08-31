import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/utils/breakpoints.dart';

/// 批量填价：盘后一个界面填完全部持仓现价（§5.11 盘后三件事其一）
class BatchPricePage extends ConsumerStatefulWidget {
  const BatchPricePage({super.key});

  @override
  ConsumerState<BatchPricePage> createState() => _BatchPricePageState();
}

class _BatchPricePageState extends ConsumerState<BatchPricePage> {
  final _controllers = <int, TextEditingController>{};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);
    try {
      final repo = ref.read(priceRepositoryProvider);
      for (final entry in _controllers.entries) {
        final v = double.tryParse(entry.value.text.trim());
        if (v != null && v > 0) {
          await repo.setTodayPrice(entry.key, v);
        }
      }
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = ref.watch(positionBookProvider);
    final instruments = ref.watch(instrumentByIdProvider);
    final history = ref.watch(priceHistoryProvider).valueOrNull ?? const {};
    final holdings = (book?.holdings.values ?? const []).toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    return Scaffold(
      appBar: AppBar(title: const Text('批量填价')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: CenteredConstrainedBox(
            child: FilledButton(
              onPressed: _saving || holdings.isEmpty ? null : _saveAll,
              child: Text(_saving ? '保存中…' : '保存全部'),
            ),
          ),
        ),
      ),
      body: CenteredConstrainedBox(
        child: holdings.isEmpty
            ? Center(
                child: Text('当前没有持仓',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('填完今日现价，当日总盈亏即刻精确（未填的沿用旧价估算）',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  for (final h in holdings)
                    _PriceRow(
                      key: ValueKey(h.instrumentId),
                      name: _name(instruments, h.instrumentId),
                      quantity: h.quantity,
                      lastPrice: _lastPrice(history[h.instrumentId]),
                      controller: _controllers.putIfAbsent(
                          h.instrumentId, () => TextEditingController()),
                      onUseLast: (v) => _controllers[h.instrumentId]!.text =
                          v.toStringAsFixed(2),
                    ),
                ],
              ),
      ),
    );
  }

  String _name(Map<int, dynamic> instruments, int id) {
    final i = instruments[id];
    return i == null ? '$id' : '${i.name}（${i.code}）';
  }

  double? _lastPrice(List<({String date, double price})>? hist) {
    if (hist == null || hist.isEmpty) return null;
    // 今日已填过则视为"上次"
    return hist.last.price;
  }
}

class _PriceRow extends StatefulWidget {
  const _PriceRow({
    super.key,
    required this.name,
    required this.quantity,
    required this.lastPrice,
    required this.controller,
    required this.onUseLast,
  });

  final String name;
  final double quantity;
  final double? lastPrice;
  final TextEditingController controller;
  final void Function(double) onUseLast;

  @override
  State<_PriceRow> createState() => _PriceRowState();
}

class _PriceRowState extends State<_PriceRow> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.controller;
    final unfilled = controller.text.trim().isEmpty;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: unfilled ? theme.colorScheme.errorContainer.withValues(alpha: 0.25) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall),
                  Text('${widget.quantity.toStringAsFixed(widget.quantity % 1 == 0 ? 0 : 2)} 股',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '今日价',
                  suffixText: '元',
                  isDense: true,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            if (widget.lastPrice != null)
              TextButton(
                onPressed: () => widget.onUseLast(widget.lastPrice!),
                child: Text('上次 ${widget.lastPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }
}
