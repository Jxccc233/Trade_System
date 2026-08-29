import 'position_book.dart';

/// 核心统计（由已了结轮次推导）
class TradeStats {
  const TradeStats({
    required this.totalRealizedPnl,
    required this.totalFee,
    required this.tradeCount,
    required this.roundCount,
    required this.winCount,
    required this.winRate,
    required this.avgWin,
    required this.avgLoss,
    required this.profitFactor,
  });

  final double totalRealizedPnl;
  final double totalFee;
  final int tradeCount;

  /// 已了结轮数
  final int roundCount;

  /// 盈利轮数
  final int winCount;

  /// 胜率（无了结轮时为 null）
  final double? winRate;

  /// 平均盈利（无盈利轮时为 null）
  final double? avgWin;

  /// 平均亏损（无亏损轮时为 null）
  final double? avgLoss;

  /// 盈亏比 = 平均盈利 / |平均亏损|（任一缺失时为 null）
  final double? profitFactor;
}

TradeStats computeStats({
  required PositionBook book,
  required int tradeCount,
}) {
  final rounds = book.closedRounds;
  final wins = rounds.where((r) => r.realizedPnl > 0).toList();
  final losses = rounds.where((r) => r.realizedPnl < 0).toList();
  final winRate =
      rounds.isEmpty ? null : wins.length / rounds.length;
  final avgWin = wins.isEmpty
      ? null
      : wins.fold<double>(0, (s, r) => s + r.realizedPnl) / wins.length;
  final avgLossAbs = losses.isEmpty
      ? null
      : losses.fold<double>(0, (s, r) => s + r.realizedPnl.abs()) /
          losses.length;
  final profitFactor =
      (avgWin != null && avgLossAbs != null && avgLossAbs > 0)
          ? avgWin / avgLossAbs
          : null;

  return TradeStats(
    totalRealizedPnl: book.totalRealizedPnl,
    totalFee: book.totalFee,
    tradeCount: tradeCount,
    roundCount: rounds.length,
    winCount: wins.length,
    winRate: winRate,
    avgWin: avgWin,
    avgLoss: losses.isEmpty ? null : -avgLossAbs!,
    profitFactor: profitFactor,
  );
}

/// 逐日累计已实现盈亏（净值曲线数据源）
/// [realizedPnlByDay] → 按日期升序的累计序列
List<({String date, double cum})> cumulativePnlByDay(
    Map<String, double> realizedPnlByDay) {
  final dates = realizedPnlByDay.keys.toList()..sort();
  var cum = 0.0;
  return [
    for (final d in dates)
      () {
        cum += realizedPnlByDay[d]!;
        return (date: d, cum: cum);
      }(),
  ];
}
