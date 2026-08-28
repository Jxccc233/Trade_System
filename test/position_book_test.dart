import 'package:flutter_test/flutter_test.dart';

import 'package:fupan_shouji/domain/position_book.dart';

void main() {
  const computer = PositionBookComputer();

  TradeRecord tr(
    int instrumentId,
    DateTime at,
    String side,
    double price,
    double qty, {
    double fee = 0,
  }) =>
      TradeRecord(
        instrumentId: instrumentId,
        tradedAt: at,
        side: side,
        price: price,
        quantity: qty,
        fee: fee,
      );

  final d1 = DateTime(2026, 8, 20, 10, 0);
  final d2 = DateTime(2026, 8, 21, 14, 30);
  final d3 = DateTime(2026, 8, 22, 9, 40);

  test('空账本', () {
    final book = computer.compute(trades: const []);
    expect(book.holdings, isEmpty);
    expect(book.closedRounds, isEmpty);
    expect(book.totalRealizedPnl, 0);
  });

  test('持有中：摊薄成本含费，浮动盈亏按现价', () {
    final book = computer.compute(
      trades: [
        tr(1, d1, 'BUY', 10, 100),
        tr(1, d2, 'BUY', 12, 100, fee: 4),
      ],
      lastPrices: {1: 11.0},
    );
    final h = book.holdings[1]!;
    expect(h.quantity, 200);
    // (100*10 + 100*12 + 4) / 200 = 11.02
    expect(h.avgCost, closeTo(11.02, 1e-9));
    expect(h.floatingPnl, closeTo(200 * (11 - 11.02), 1e-9));
    expect(h.realizedPnl, 0);
  });

  test('清仓后归档已了结轮次，盈亏=卖出净额-买入总投入', () {
    final book = computer.compute(trades: [
      tr(1, d1, 'BUY', 10, 100, fee: 5),   // 投入 1005
      tr(1, d3, 'SELL', 11, 100, fee: 3),  // 净得 1097
    ]);
    expect(book.holdings, isEmpty);
    expect(book.closedRounds, hasLength(1));
    final r = book.closedRounds.first;
    expect(r.realizedPnl, closeTo(1097 - 1005, 1e-9));
    expect(r.totalBuyAmount, closeTo(1005, 1e-9));
    expect(r.totalSellAmount, closeTo(1097, 1e-9));
    expect(r.holdingDays, 2);
    expect(r.openedAt, d1);
    expect(r.closedAt, d3);
    expect(book.totalRealizedPnl, closeTo(92, 1e-9));
  });

  test('两轮交易：清仓后再建仓互不干扰', () {
    final book = computer.compute(trades: [
      tr(1, d1, 'BUY', 10, 100),
      tr(1, d2, 'SELL', 12, 100),   // 第一轮 +200
      tr(1, d3, 'BUY', 20, 50),     // 第二轮建仓
    ]);
    expect(book.closedRounds, hasLength(1));
    expect(book.closedRounds.first.realizedPnl, closeTo(200, 1e-9));
    final h = book.holdings[1]!;
    expect(h.quantity, 50);
    expect(h.avgCost, 20);
    // 已实现盈亏累计保留
    expect(h.realizedPnl, closeTo(200, 1e-9));
    expect(book.totalRealizedPnl, closeTo(200, 1e-9));
  });

  test('逐日已实现盈亏与多标的分组', () {
    final book = computer.compute(trades: [
      tr(1, d1, 'BUY', 10, 100),
      tr(2, d1, 'BUY', 20, 100),
      tr(1, d2, 'SELL', 12, 100, fee: 2),  // +198
      tr(2, d3, 'SELL', 18, 100),          // -200
    ]);
    expect(book.realizedPnlByDay[dateKey(d2)], closeTo(198, 1e-9));
    expect(book.realizedPnlByDay[dateKey(d3)], closeTo(-200, 1e-9));
    expect(book.totalRealizedPnl, closeTo(-2, 1e-9));
    expect(book.closedRounds, hasLength(2));
  });

  test('乱序输入自动按时间排序', () {
    final book = computer.compute(trades: [
      tr(1, d3, 'SELL', 12, 100),
      tr(1, d1, 'BUY', 10, 100),
    ]);
    expect(book.closedRounds, hasLength(1));
    expect(book.closedRounds.first.realizedPnl, closeTo(200, 1e-9));
  });

  test('卖出超过持仓抛 StateError', () {
    expect(
      () => computer.compute(trades: [
        tr(1, d1, 'BUY', 10, 100),
        tr(1, d2, 'SELL', 12, 200),
      ]),
      throwsStateError,
    );
  });

  test('手续费合计', () {
    final book = computer.compute(trades: [
      tr(1, d1, 'BUY', 10, 100, fee: 5),
      tr(1, d2, 'SELL', 11, 100, fee: 3),
    ]);
    expect(book.totalFee, 8);
  });
}
