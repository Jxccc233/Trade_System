import 'dart:math';

/// 持仓状态：数量、摊薄成本（含手续费）、累计已实现盈亏
class PositionState {
  const PositionState({
    this.quantity = 0,
    this.avgCost = 0,
    this.realizedPnl = 0,
  });

  final double quantity;
  final double avgCost;
  final double realizedPnl;

  bool get isEmpty => quantity <= 0;

  PositionState copyWith({double? quantity, double? avgCost, double? realizedPnl}) {
    return PositionState(
      quantity: quantity ?? this.quantity,
      avgCost: avgCost ?? this.avgCost,
      realizedPnl: realizedPnl ?? this.realizedPnl,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PositionState &&
      other.quantity == quantity &&
      other.avgCost == avgCost &&
      other.realizedPnl == realizedPnl;

  @override
  int get hashCode => Object.hash(quantity, avgCost, realizedPnl);

  @override
  String toString() =>
      'PositionState(qty: $quantity, avg: $avgCost, realized: $realizedPnl)';
}

/// 移动加权平均成本法：
/// - 买入：手续费计入成本，摊薄均价
/// - 卖出：结转已实现盈亏 = 数量 × (卖价 − 均价) − 手续费，均价不变
/// - A 股只做多，卖出数量超过持仓视为数据错误
class PositionCalculator {
  const PositionCalculator();

  PositionState buy(
    PositionState s, {
    required double quantity,
    required double price,
    double fee = 0,
  }) {
    if (quantity <= 0) throw ArgumentError('买入数量必须大于 0');
    if (price < 0) throw ArgumentError('价格不能为负');
    final newQty = s.quantity + quantity;
    final totalCost = s.quantity * s.avgCost + quantity * price + fee;
    return s.copyWith(quantity: newQty, avgCost: totalCost / newQty);
  }

  PositionState sell(
    PositionState s, {
    required double quantity,
    required double price,
    double fee = 0,
  }) {
    if (quantity <= 0) throw ArgumentError('卖出数量必须大于 0');
    if (price < 0) throw ArgumentError('价格不能为负');
    if (quantity > s.quantity + _epsilon) {
      throw StateError('卖出数量($quantity)超过当前持仓(${s.quantity})');
    }
    final pnl = quantity * (price - s.avgCost) - fee;
    final newQty = max(0.0, s.quantity - quantity);
    return s.copyWith(
      quantity: newQty,
      realizedPnl: s.realizedPnl + pnl,
      avgCost: newQty <= 0 ? 0 : s.avgCost,
    );
  }

  PositionState apply(
    PositionState s, {
    required String side,
    required double quantity,
    required double price,
    double fee = 0,
  }) {
    return side == 'BUY'
        ? buy(s, quantity: quantity, price: price, fee: fee)
        : sell(s, quantity: quantity, price: price, fee: fee);
  }

  /// 数量比较的浮点容差（股数最小 0.001）
  static const double _epsilon = 1e-6;
}
