/// 持仓账本：由交易流水序列推导当前持仓、已了结轮次与逐日已实现盈亏。
/// 纯 Dart 计算，不依赖数据库，便于单测。
library;

import '../../data/db/tables.dart';

class TradeRecord {
  const TradeRecord({
    required this.instrumentId,
    required this.tradedAt,
    required this.side,
    required this.price,
    required this.quantity,
    this.fee = 0,
  });

  final int instrumentId;
  final DateTime tradedAt;
  final String side;
  final double price;
  final double quantity;
  final double fee;

  bool get isBuy => side == TradeSide.buy;
}

class Holding {
  const Holding({
    required this.instrumentId,
    required this.quantity,
    required this.avgCost,
    required this.realizedPnl,
    this.lastPrice,
  });

  final int instrumentId;

  /// 持仓数量（股/份）
  final double quantity;

  /// 摊薄成本（含手续费）
  final double avgCost;

  /// 本标的累计已实现盈亏
  final double realizedPnl;

  /// 最近一次手动填写的价格
  final double? lastPrice;

  double get marketValue => quantity * (lastPrice ?? 0);

  /// 浮动盈亏（未填价时为 null）
  double? get floatingPnl =>
      lastPrice == null ? null : quantity * (lastPrice! - avgCost);

  /// 浮动盈亏比例
  double? get floatingPct =>
      lastPrice == null || avgCost <= 0 ? null : (lastPrice! - avgCost) / avgCost;
}

/// 一轮完整的建仓→清仓交易
class ClosedRound {
  const ClosedRound({
    required this.instrumentId,
    required this.openedAt,
    required this.closedAt,
    required this.realizedPnl,
    required this.totalBuyAmount,
    required this.totalSellAmount,
    required this.maxQuantity,
  });

  final int instrumentId;
  final DateTime openedAt;
  final DateTime closedAt;
  final double realizedPnl;

  /// 买入总投入（含费）
  final double totalBuyAmount;

  /// 卖出总收入（扣费）
  final double totalSellAmount;

  final double maxQuantity;

  /// 按日历日计算的自然日持有天数
  int get holdingDays => DateTime(closedAt.year, closedAt.month, closedAt.day)
      .difference(DateTime(openedAt.year, openedAt.month, openedAt.day))
      .inDays;
}

class PositionBook {
  const PositionBook({
    required this.holdings,
    required this.closedRounds,
    required this.realizedPnlByDay,
    required this.totalRealizedPnl,
    required this.totalFee,
  });

  /// 当前持仓（数量 > 0）
  final Map<int, Holding> holdings;

  /// 已了结轮次，按清仓时间倒序由调用方排序
  final List<ClosedRound> closedRounds;

  /// 逐日已实现盈亏（dateKey yyyy-MM-dd → 盈亏）
  final Map<String, double> realizedPnlByDay;

  final double totalRealizedPnl;
  final double totalFee;
}

/// dateKey：本地时区 yyyy-MM-dd
String dateKey(DateTime dt) =>
    '${dt.year.toString().padLeft(4, '0')}-'
    '${dt.month.toString().padLeft(2, '0')}-'
    '${dt.day.toString().padLeft(2, '0')}';

class PositionBookComputer {
  const PositionBookComputer();

  /// 输入交易流水（任意顺序，内部按时间稳定排序）与最新价表，输出账本。
  /// 卖出超过持仓抛 [StateError]（数据库层写入前应校验）。
  PositionBook compute({
    required List<TradeRecord> trades,
    Map<int, double> lastPrices = const {},
  }) {
    final sorted = [...trades]..sort((a, b) {
        final c = a.tradedAt.compareTo(b.tradedAt);
        return c != 0 ? c : a.instrumentId.compareTo(b.instrumentId);
      });

    // instrumentId → 运行状态
    final qty = <int, double>{};
    final avg = <int, double>{};
    final realized = <int, double>{};
    // 轮次累计
    final roundBuy = <int, double>{};
    final roundSell = <int, double>{};
    final roundOpen = <int, DateTime>{};
    final roundMaxQty = <int, double>{};
    final closed = <ClosedRound>[];
    final byDay = <String, double>{};
    var totalFee = 0.0;

    for (final t in sorted) {
      totalFee += t.fee;
      final q = qty[t.instrumentId] ?? 0;
      final a = avg[t.instrumentId] ?? 0.0;

      if (t.isBuy) {
        final newQty = q + t.quantity;
        avg[t.instrumentId] =
            (q * a + t.quantity * t.price + t.fee) / newQty;
        qty[t.instrumentId] = newQty;
        roundBuy[t.instrumentId] =
            (roundBuy[t.instrumentId] ?? 0) + t.quantity * t.price + t.fee;
        roundOpen.putIfAbsent(t.instrumentId, () => t.tradedAt);
        roundMaxQty[t.instrumentId] =
            (roundMaxQty[t.instrumentId] ?? 0) > newQty
                ? roundMaxQty[t.instrumentId]!
                : newQty;
      } else {
        if (t.quantity > q + 1e-6) {
          throw StateError(
              '标的 ${t.instrumentId} 卖出 ${t.quantity} 超过持仓 $q');
        }
        final pnl = t.quantity * (t.price - a) - t.fee;
        realized[t.instrumentId] = (realized[t.instrumentId] ?? 0) + pnl;
        final key = dateKey(t.tradedAt);
        byDay[key] = (byDay[key] ?? 0) + pnl;
        roundSell[t.instrumentId] =
            (roundSell[t.instrumentId] ?? 0) + t.quantity * t.price - t.fee;
        final newQty = q - t.quantity;
        qty[t.instrumentId] = newQty;
        if (newQty <= 1e-6) {
          final buy = roundBuy[t.instrumentId] ?? 0;
          final sell = roundSell[t.instrumentId] ?? 0;
          closed.add(ClosedRound(
            instrumentId: t.instrumentId,
            openedAt: roundOpen[t.instrumentId] ?? t.tradedAt,
            closedAt: t.tradedAt,
            realizedPnl: sell - buy,
            totalBuyAmount: buy,
            totalSellAmount: sell,
            maxQuantity: roundMaxQty[t.instrumentId] ?? 0,
          ));
          roundBuy.remove(t.instrumentId);
          roundSell.remove(t.instrumentId);
          roundOpen.remove(t.instrumentId);
          roundMaxQty.remove(t.instrumentId);
          qty[t.instrumentId] = 0;
          avg[t.instrumentId] = 0;
        }
      }
    }

    final holdings = <int, Holding>{};
    qty.forEach((id, q) {
      if (q > 1e-6) {
        holdings[id] = Holding(
          instrumentId: id,
          quantity: q,
          avgCost: avg[id] ?? 0,
          realizedPnl: realized[id] ?? 0,
          lastPrice: lastPrices[id],
        );
      }
    });

    closed.sort((x, y) => y.closedAt.compareTo(x.closedAt));

    return PositionBook(
      holdings: holdings,
      closedRounds: closed,
      realizedPnlByDay: byDay,
      totalRealizedPnl:
          realized.values.fold(0.0, (s, v) => s + v),
      totalFee: totalFee,
    );
  }
}
