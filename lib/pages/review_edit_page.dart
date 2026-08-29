import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/breakpoints.dart';
import '../core/utils/dates.dart';
import '../data/review_repository.dart';
import '../domain/position_book.dart' show dateKey;

/// 每日复盘表单：大盘简评 / 做对 / 做错 / 明日计划 / 心态 / 纪律清单
class ReviewEditPage extends ConsumerStatefulWidget {
  const ReviewEditPage({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<ReviewEditPage> createState() => _ReviewEditPageState();
}

class _ReviewEditPageState extends ConsumerState<ReviewEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _marketNote = TextEditingController();
  final _didRight = TextEditingController();
  final _didWrong = TextEditingController();
  final _plan = TextEditingController();
  int? _mood;
  late Map<String, bool> _checklist;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _checklist = {for (final k in kDefaultChecklist) k: false};
    // 已有复盘则载入
    final existing =
        ref.read(reviewsProvider).valueOrNull?[dateKey(widget.date)];
    if (existing != null) {
      _marketNote.text = existing.marketNote ?? '';
      _didRight.text = existing.didRight ?? '';
      _didWrong.text = existing.didWrong ?? '';
      _plan.text = existing.plan ?? '';
      _mood = existing.mood;
      _checklist = _decodeChecklist(existing.checklist);
    }
  }

  static Map<String, bool> _decodeChecklist(String raw) {
    // 简单解析 {"k":true,...}
    final map = <String, bool>{for (final k in kDefaultChecklist) k: false};
    final body = raw.trim();
    if (body.length > 2) {
      for (var pair in body.substring(1, body.length - 1).split(',')) {
        final kv = pair.split(':');
        if (kv.length == 2) {
          map[kv[0].replaceAll('"', '').trim()] = kv[1].trim() == 'true';
        }
      }
    }
    return map;
  }

  @override
  void dispose() {
    _marketNote.dispose();
    _didRight.dispose();
    _didWrong.dispose();
    _plan.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final book = ref.read(positionBookProvider);
    final holdings = book?.holdings.values ?? const [];
    final marketValue = holdings.fold<double>(
        0, (s, h) => s + (h.lastPrice == null ? 0 : h.quantity * h.lastPrice!));

    setState(() => _saving = true);
    try {
      await ref.read(reviewRepositoryProvider).saveReview(
            date: widget.date,
            marketNote:
                _marketNote.text.trim().isEmpty ? null : _marketNote.text.trim(),
            didRight:
                _didRight.text.trim().isEmpty ? null : _didRight.text.trim(),
            didWrong:
                _didWrong.text.trim().isEmpty ? null : _didWrong.text.trim(),
            plan: _plan.text.trim().isEmpty ? null : _plan.text.trim(),
            mood: _mood,
            checklist: _checklist,
            marketValue: marketValue,
            realizedPnlCum: book?.totalRealizedPnl ?? 0,
          );
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trades = (ref.watch(tradesProvider).valueOrNull ?? const [])
        .where((t) => dateKey(t.trade.tradedAt) == dateKey(widget.date))
        .toList();
    final reviewed =
        ref.watch(reviewsProvider).valueOrNull?[dateKey(widget.date)] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('复盘 · ${shortDate(widget.date)}'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: CenteredConstrainedBox(
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving
                  ? '保存中…'
                  : (reviewed ? '更新复盘' : '保存复盘')),
            ),
          ),
        ),
      ),
      body: CenteredConstrainedBox(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 当日操作回顾（自动带出）
              _SectionTitle('当日交易（${trades.length} 笔）'),
              if (trades.isEmpty)
                Text('当天没有交易记录',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant))
              else
                for (final t in trades)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      t.trade.side == 'BUY' ? '买' : '卖',
                      style: theme.textTheme.titleSmall?.copyWith(
                          color: t.trade.side == 'BUY'
                              ? AppColors.up
                              : AppColors.down),
                    ),
                    title: Text(
                        '${t.instrument.name} ${t.trade.quantity.toStringAsFixed(t.trade.quantity % 1 == 0 ? 0 : 2)}股 × ${t.trade.price.toStringAsFixed(2)}'),
                    subtitle: t.trade.reason != null
                        ? Text(t.trade.reason!,
                            maxLines: 1, overflow: TextOverflow.ellipsis)
                        : null,
                  ),
              const Divider(height: 24),

              const _SectionTitle('大盘简评'),
              TextFormField(
                controller: _marketNote,
                maxLines: 2,
                decoration: const InputDecoration(hintText: '一句话：指数/情绪/赚钱效应…'),
              ),
              const SizedBox(height: 12),

              const _SectionTitle('做对了什么'),
              TextFormField(
                controller: _didRight,
                maxLines: 2,
                decoration: const InputDecoration(hintText: '值得固化的操作'),
              ),
              const SizedBox(height: 12),

              const _SectionTitle('做错了什么'),
              TextFormField(
                controller: _didWrong,
                maxLines: 2,
                decoration: const InputDecoration(hintText: '下次避免'),
              ),
              const SizedBox(height: 12),

              const _SectionTitle('明日计划'),
              TextFormField(
                controller: _plan,
                maxLines: 2,
                decoration: const InputDecoration(hintText: '仓位/标的/预案'),
              ),
              const SizedBox(height: 12),

              const _SectionTitle('心态自评'),
              Row(
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () => setState(() => _mood = i),
                      icon: Icon(
                        i <= (_mood ?? 0)
                            ? Icons.sentiment_satisfied
                            : Icons.sentiment_neutral_outlined,
                        color: i <= (_mood ?? 0) ? AppColors.up : null,
                      ),
                      tooltip: '$i',
                    ),
                ],
              ),
              const SizedBox(height: 12),

              const _SectionTitle('纪律清单'),
              for (final k in _checklist.keys.toList())
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(k),
                  value: _checklist[k],
                  onChanged: (v) => setState(() => _checklist[k] = v ?? false),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
