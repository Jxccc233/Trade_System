import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/breakpoints.dart';
import '../core/utils/dates.dart';
import '../core/utils/format.dart';
import '../core/widgets/image_viewer.dart';
import '../data/db/app_database.dart';
import '../data/db/tables.dart';
import '../data/image_store.dart';
import '../data/repositories.dart';
import '../domain/fee.dart';

/// 预置情绪标签（M2 支持自定义）
const kEmotions = ['计划内', '临时起意', '冲动', 'FOMO', '止损', '止盈'];

/// 根据代码推断市场：6→沪，0/3→深，4/8/9→北，其余默认沪
String guessMarket(String code) {
  if (code.startsWith('6')) return Market.sh;
  if (code.startsWith('0') || code.startsWith('3')) return Market.sz;
  if (code.startsWith('4') || code.startsWith('8') || code.startsWith('9')) {
    return Market.bj;
  }
  return Market.sh;
}

/// 记一笔：30 秒完成一笔买卖记录。
/// 传 [editing] 为编辑模式；[editing] + [copy] 为复制模式（预填但另存一笔）。
class TradeEntryPage extends ConsumerStatefulWidget {
  const TradeEntryPage({super.key, this.editing, this.copy = false});

  final TradeWithInstrument? editing;
  final bool copy;

  @override
  ConsumerState<TradeEntryPage> createState() => _TradeEntryPageState();
}

class _TradeEntryPageState extends ConsumerState<TradeEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _feeController = TextEditingController();
  final _reasonController = TextEditingController();

  /// Autocomplete 自管代码输入框，这里只记录当前值
  String _code = '';
  String _side = TradeSide.buy;
  String _market = Market.sh;
  DateTime _tradedAt = DateTime.now();
  String? _emotion;
  bool _saving = false;
  final List<String> _images = [];

  bool get _isEditing => widget.editing != null && !widget.copy;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      final t = e.trade;
      _code = e.instrument.code;
      _nameController.text = e.instrument.name;
      _market = e.instrument.market;
      _side = t.side;
      _priceController.text = t.price.toString();
      _qtyController.text =
          t.quantity.toStringAsFixed(t.quantity % 1 == 0 ? 0 : 3);
      _feeController.text = t.fee.toStringAsFixed(2);
      _reasonController.text = t.reason ?? '';
      _emotion = t.emotion;
      _images.addAll(decodeImages(t.images));
      if (!widget.copy) _tradedAt = t.tradedAt;
    }
    _priceController.addListener(_autoFee);
    _qtyController.addListener(_autoFee);
    _loadRates();
  }

  FeeRates _rates = FeeRates.defaults;
  bool _feeTouched = false;

  Future<void> _loadRates() async {
    final repo = ref.read(tradeRepositoryProvider);
    final rates = FeeRates(
      commissionRate: await repo.getSettingDouble(
          SettingKeys.commissionRate, FeeRates.defaults.commissionRate),
      commissionMin: await repo.getSettingDouble(
          SettingKeys.commissionMin, FeeRates.defaults.commissionMin),
      stampRate: await repo.getSettingDouble(
          SettingKeys.stampRate, FeeRates.defaults.stampRate),
      transferRate: await repo.getSettingDouble(
          SettingKeys.transferRate, FeeRates.defaults.transferRate),
    );
    if (mounted) {
      setState(() => _rates = rates);
      _autoFee();
    }
  }

  /// 价格/数量变化时自动估费；手动改过费用则不动（点"估"可重估）
  void _autoFee() {
    if (_feeTouched) return;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final qty = double.tryParse(_qtyController.text.trim()) ?? 0;
    final fee = _rates.estimate(_side, price, qty);
    _feeController.text = fee > 0 ? fee.toStringAsFixed(2) : '';
  }

  void _stepQty(double delta) {
    final cur = double.tryParse(_qtyController.text.trim()) ?? 0;
    final next = cur + delta;
    _qtyController.text =
        next <= 0 ? '' : next.toStringAsFixed(next % 1 == 0 ? 0 : 3);
  }

  /// 卖出参考：持仓数量、摊薄成本、边填边算的预计盈亏
  Widget _sellReferenceCard(ThemeData theme) {
    final code = _code.trim();
    if (code.isEmpty) return const SizedBox.shrink();
    final ins = ref.read(instrumentsProvider).valueOrNull;
    final match = ins?.where((i) => i.code == code && i.market == _market);
    if (match == null || match.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text('无 $code 持仓（A股不支持做空）',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.error)),
      );
    }
    final holding =
        ref.read(positionBookProvider)?.holdings[match.first.id];
    if (holding == null || holding.quantity <= 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text('无 $code 持仓（A股不支持做空）',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.error)),
      );
    }
    final price = double.tryParse(_priceController.text.trim());
    final qty = double.tryParse(_qtyController.text.trim());
    final fee = double.tryParse(_feeController.text.trim()) ?? 0;
    final pnl = (price != null && qty != null)
        ? qty * (price - holding.avgCost) - fee
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('持仓 ${holding.quantity.toStringAsFixed(holding.quantity % 1 == 0 ? 0 : 2)} 股 · 成本 ${holding.avgCost.toStringAsFixed(3)}',
                      style: theme.textTheme.bodySmall),
                  if (pnl != null)
                    Text(
                      '预计盈亏 ${signedMoney(pnl)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.ofPnl(pnl)),
                    )
                  else
                    Text('填价格后显示预计盈亏',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _feeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickTradedAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _tradedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_tradedAt),
    );
    if (!mounted) return;
    if (time != null) {
      setState(() {
        _tradedAt =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final code = _code.trim();
    final market = _market;
    final qty = double.parse(_qtyController.text.trim());
    final repo = ref.read(tradeRepositoryProvider);

    // 卖出校验：A股只做多，卖出数量不能超过当前持仓（编辑模式跳过——
    // 改的就是这笔自身，严格校验会误伤；越界由账本引擎兜底）
    if (!_isEditing && _side == TradeSide.sell) {
      final book = ref.read(positionBookProvider);
      final instrument = await repo.findInstrument(code, market);
      if (!mounted) return;
      final holding =
          instrument == null ? null : book?.holdings[instrument.id];
      if (holding == null || qty > holding.quantity + 1e-6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(holding == null
              ? '没有 $code 的持仓，A股不支持做空'
              : '持仓只有 ${holding.quantity.toStringAsFixed(0)}，不能卖 $qty'),
        ));
        return;
      }
    }

    setState(() => _saving = true);
    try {
      final instrument = await repo.findOrCreateInstrument(
        code: code,
        name: _nameController.text.trim(),
        market: market,
      );
      final fields = (
        instrumentId: instrument.id,
        tradedAt: _tradedAt,
        side: _side,
        price: double.parse(_priceController.text.trim()),
        quantity: qty,
        fee: double.tryParse(_feeController.text.trim()) ?? 0,
        reason: _reasonController.text.trim().isEmpty
            ? null
            : _reasonController.text.trim(),
        emotion: _emotion,
        images: _images,
      );
      if (_isEditing) {
        await repo.updateTrade(widget.editing!.trade.id,
          instrumentId: fields.instrumentId,
          tradedAt: fields.tradedAt,
          side: fields.side,
          price: fields.price,
          quantity: fields.quantity,
          fee: fields.fee,
          reason: fields.reason,
          emotion: fields.emotion,
          images: fields.images,
        );
      } else {
        await repo.addTrade(
          instrumentId: fields.instrumentId,
          tradedAt: fields.tradedAt,
          side: fields.side,
          price: fields.price,
          quantity: fields.quantity,
          fee: fields.fee,
          reason: fields.reason,
          emotion: fields.emotion,
          images: fields.images,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final instruments =
        ref.watch(instrumentsProvider).valueOrNull ?? const <Instrument>[];

    return Scaffold(
      appBar: AppBar(
          title: Text(_isEditing
              ? '编辑交易'
              : (widget.copy ? '复制记一笔' : '记一笔'))),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: CenteredConstrainedBox(
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor:
                    _side == TradeSide.buy ? AppColors.up : AppColors.down,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _saving
                    ? '保存中…'
                    : (_isEditing
                        ? '保存修改'
                        : (_side == TradeSide.buy ? '记买入' : '记卖出')),
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: CenteredConstrainedBox(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('方向',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              SizedBox(
                height: 48,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: TradeSide.buy,
                        label: Text('买入'),
                        icon: Icon(Icons.north_east)),
                    ButtonSegment(
                        value: TradeSide.sell,
                        label: Text('卖出'),
                        icon: Icon(Icons.south_east)),
                  ],
                  selected: {_side},
                  onSelectionChanged: (s) {
                    setState(() => _side = s.first);
                    _autoFee();
                  },
                ),
              ),
              const SizedBox(height: 12),

              // 常用标的一键选择（收藏 + 最近使用置顶）
              if (instruments.isNotEmpty) ...[
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: instruments.take(10).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final ins = instruments[i];
                      final selected =
                          ins.code == _code.trim() && ins.market == _market;
                      return ChoiceChip(
                        label: Text(
                          ins.isFavorite ? '★ ${ins.name}' : ins.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() {
                          _code = ins.code;
                          _nameController.text = ins.name;
                          _market = ins.market;
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 标的：代码自动补全 + 名称
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Autocomplete<Instrument>(
                      optionsBuilder: (value) {
                        final raw = value.text.trim();
                        if (raw.isEmpty) return const [];
                        return instruments.where((i) =>
                            i.code.startsWith(raw) || i.name.contains(raw));
                      },
                      displayStringForOption: (i) => i.code,
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onFieldSubmitted: (_) => onFieldSubmitted(),
                          decoration: const InputDecoration(
                            labelText: '代码',
                            hintText: '600519 / 300750',
                            prefixIcon: Icon(Icons.tag),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? '请输入代码' : null,
                          onChanged: (v) {
                            _code = v;
                            final code = v.trim();
                            if (code.length == 6 &&
                                int.tryParse(code) != null) {
                              final hit = instruments
                                  .where((i) => i.code == code)
                                  .toList();
                              setState(() {
                                _market = guessMarket(code);
                                if (hit.isNotEmpty &&
                                    _nameController.text.isEmpty) {
                                  _nameController.text = hit.first.name;
                                }
                              });
                            }
                          },
                        );
                      },
                      onSelected: (i) => setState(() {
                        _code = i.code;
                        _nameController.text = i.name;
                        _market = i.market;
                      }),
                      optionsViewBuilder: (context, onSelected, options) =>
                          _InstrumentOptions(
                        options: options,
                        onSelected: onSelected,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: '名称'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '请输入名称' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: Market.sh, label: Text('沪')),
                  ButtonSegment(value: Market.sz, label: Text('深')),
                  ButtonSegment(value: Market.bj, label: Text('北')),
                ],
                selected: {_market},
                onSelectionChanged: (s) => setState(() => _market = s.first),
              ),
              const SizedBox(height: 12),

              // 卖出参考：显示该标的当前持仓与摊薄成本，边填边算预计盈亏
              if (_side == TradeSide.sell)
                _sellReferenceCard(Theme.of(context)),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '价格',
                        suffixText: '元',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final p = double.tryParse(v?.trim() ?? '');
                        return (p == null || p <= 0) ? '请输入有效价格' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: const InputDecoration(
                        labelText: '数量',
                        suffixText: '股/份',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final q = double.tryParse(v?.trim() ?? '');
                        return (q == null || q <= 0) ? '请输入有效数量' : null;
                      },
                    ),
                  ),
                ],
              ),
              // 数量快捷步进（Row 之外）
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final d in const [100.0, 500.0, 1000.0])
                    OutlinedButton(
                      onPressed: () => _stepQty(d),
                      style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact),
                      child: Text('+${d.toInt()}'),
                    ),
                  OutlinedButton(
                    onPressed: () => _stepQty(-100),
                    style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                    child: const Text('-100'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _feeController,
                decoration: InputDecoration(
                  labelText: '手续费（自动估算，可改）',
                  suffixText: '元',
                  suffixIcon: Tooltip(
                    message: '按设置费率重估',
                    child: IconButton(
                      icon: const Icon(Icons.calculate_outlined, size: 20),
                      onPressed: () {
                        setState(() => _feeTouched = false);
                        _autoFee();
                      },
                    ),
                  ),
                ),
                onChanged: (_) => _feeTouched = true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: _pickTradedAt,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '成交时间',
                    prefixIcon: Icon(Icons.schedule),
                  ),
                  child: Text(dateTimeLabel(_tradedAt)),
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in kEmotions)
                    FilterChip(
                      label: Text(e),
                      selected: _emotion == e,
                      onSelected: (sel) =>
                          setState(() => _emotion = sel ? e : null),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: '买卖理由（写了才叫复盘）',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                maxLength: 200,
              ),
              const SizedBox(height: 12),

              // 分时图/K线截图（同花顺截图后在此上传）
              Text('截图（分时图 / K线）', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final img in _images)
                    Stack(
                      children: [
                        ScreenshotThumb(relPath: img, allRelPaths: _images),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => _images.remove(img)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final saved = await ImageStore().pickAndSave();
                      if (saved.isNotEmpty) {
                        setState(() => _images.addAll(saved));
                      }
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Icon(Icons.add_photo_alternate_outlined,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Autocomplete 的候选下拉
class _InstrumentOptions extends StatelessWidget {
  const _InstrumentOptions({
    required this.options,
    required this.onSelected,
  });

  final Iterable<Instrument> options;
  final void Function(Instrument) onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240, maxWidth: 360),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 4),
            children: [
              for (final o in options)
                ListTile(
                  dense: true,
                  title: Text('${o.code}  ${o.name}'),
                  subtitle: Text(o.market),
                  onTap: () => onSelected(o),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
