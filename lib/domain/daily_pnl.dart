import 'position_book.dart' show TradeRecord, dateKey;

/// 每个标的的逐日价格（dateKey 升序）
typedef PriceHistory = Map<int, List<({String date, double price})>>;

class DailyPnlResult {
  const DailyPnlResult({
    required this.totalPnl,
    required this.realized,
    required this.holdingChange,
    required this.marketValueToday,
    required this.marketValueYesterday,
    required this.isApproximate,
  });

  /// 当日总盈亏 = (今日市值 + 当日卖出净得) − (昨日市值 + 当日买入总花)
  final double totalPnl;

  /// 恒等分解：当日已实现盈亏
  final double realized;

  /// 恒等分解：当日持仓的浮动变化（total − realized）
  final double holdingChange;

  final double marketValueToday;
  final double marketValueYesterday;

  /// 有持仓标的今日未填价（沿用旧价估算）
  final bool isApproximate;
}

/// 当日总盈亏（现金中性口径，§5.11）。纯函数，便于单测。
/// 昨日收盘持仓 = 目标日首笔交易前的持仓状态；今日收盘持仓 = 目标日末状态。
class DailyPnlComputer {
  const DailyPnlComputer();

  DailyPnlResult compute({
    required List<TradeRecord> trades,
    required PriceHistory prices,
    required DateTime day,
  }) {
    final dayKey = dateKey(day);
    final sorted = [...trades]..sort((a, b) => a.tradedAt.compareTo(b.tradedAt));

    final qty = <int, double>{};
    final avg = <int, double>{};
    final qtyAtYesterdayClose = <int, double>{};
    final qtyAtTodayClose = <int, double>{};
    var sellNet = 0.0; // 当日卖出净得
    var buySpend = 0.0; // 当日买入总花
    var realizedToday = 0.0;

    for (final t in sorted) {
      final k = dateKey(t.tradedAt);
      if (k.compareTo(dayKey) > 0) break; // 只处理到目标日
      final isToday = k == dayKey;

      if (t.isBuy) {
        final newQty = (qty[t.instrumentId] ?? 0) + t.quantity;
        avg[t.instrumentId] =
            ((qty[t.instrumentId] ?? 0) * (avg[t.instrumentId] ?? 0) +
                    t.quantity * t.price +
                    t.fee) /
                newQty;
        qty[t.instrumentId] = newQty;
        if (isToday) buySpend += t.quantity * t.price + t.fee;
      } else {
        final pnl =
            t.quantity * (t.price - (avg[t.instrumentId] ?? 0)) - t.fee;
        qty[t.instrumentId] = (qty[t.instrumentId] ?? 0) - t.quantity;
        if (isToday) {
          sellNet += t.quantity * t.price - t.fee;
          realizedToday += pnl;
        }
      }

      if (isToday) {
        qtyAtTodayClose
          ..clear()
          ..addAll(qty);
      } else {
        // 持续刷新"目标日前最后一个收盘"的持仓
        qtyAtYesterdayClose
          ..clear()
          ..addAll(qty);
      }
    }
    if (qtyAtTodayClose.isEmpty && qtyAtYesterdayClose.isNotEmpty) {
      // 目标日无交易：今收 = 昨收
      qtyAtTodayClose.addAll(qtyAtYesterdayClose);
    }

    var mvToday = 0.0;
    var mvYesterday = 0.0;
    var approximate = false;

    final instruments = <int>{...qtyAtTodayClose.keys, ...qtyAtYesterdayClose.keys};
    for (final id in instruments) {
      final hist = prices[id] ?? const [];
      final pToday = _priceAsOf(hist, dayKey);
      var pYesterday = _priceAsOf(hist, _prevDayKey(dayKey));
      // 精确口径：今日有持仓但没填今日价 → 沿用旧价估算，标注"约"
      if ((qtyAtTodayClose[id] ?? 0) > 0 && !hist.any((e) => e.date == dayKey)) {
        approximate = true;
      }
      if (pToday == 0) approximate = true;
      // 昨日无价但今日有价（如昨天没填价）：市值对比退化为按今日价，浮动变化只算数量差
      if (pYesterday == 0 && pToday != 0) pYesterday = pToday;

      mvToday += (qtyAtTodayClose[id] ?? 0) * pToday;
      mvYesterday += (qtyAtYesterdayClose[id] ?? 0) * pYesterday;
    }

    final total = (mvToday + sellNet) - (mvYesterday + buySpend);
    return DailyPnlResult(
      totalPnl: total,
      realized: realizedToday,
      holdingChange: total - realizedToday,
      marketValueToday: mvToday,
      marketValueYesterday: mvYesterday,
      isApproximate: approximate,
    );
  }

  /// onOrBefore 当日或之前最近一次价格；无则 0
  static double _priceAsOf(
      List<({String date, double price})> hist, String onOrBefore) {
    double latest = 0;
    for (final e in hist) {
      if (e.date.compareTo(onOrBefore) <= 0) {
        latest = e.price;
      } else {
        break;
      }
    }
    return latest;
  }

  static String _prevDayKey(String dayKey) =>
      dateKey(DateTime.parse(dayKey).subtract(const Duration(days: 1)));
}
