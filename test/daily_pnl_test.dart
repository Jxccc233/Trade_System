import 'package:flutter_test/flutter_test.dart';

import 'package:fupan_shouji/domain/daily_pnl.dart';
import 'package:fupan_shouji/domain/position_book.dart';

void main() {
  const computer = DailyPnlComputer();

  TradeRecord tr(int id, DateTime at, String side, double price, double qty,
          {double fee = 0}) =>
      TradeRecord(
          instrumentId: id,
          tradedAt: at,
          side: side,
          price: price,
          quantity: qty,
          fee: fee);

  final d1 = DateTime(2026, 8, 28, 10, 0); // 昨天
  final d2 = DateTime(2026, 8, 29, 10, 0); // 今天
  final yesterday = DateTime(2026, 8, 28);
  final today = DateTime(2026, 8, 29);

  test('纯持有不交易：总盈亏 = 市值变化', () {
    final r = computer.compute(
      trades: [tr(1, d1, 'BUY', 10, 100)],
      prices: {
        1: [
          (date: '2026-08-28', price: 10.0),
          (date: '2026-08-29', price: 11.0),
        ]
      },
      day: today,
    );
    // 昨收 100×10=1000，今收 100×11=1100
    expect(r.totalPnl, closeTo(100, 1e-9));
    expect(r.realized, 0);
    expect(r.holdingChange, closeTo(100, 1e-9));
    expect(r.isApproximate, isFalse);
  });

  test('当日买入：成本即昨收等价，总盈亏 = 市值 − 花费（含费）', () {
    final r = computer.compute(
      trades: [tr(1, d2, 'BUY', 10, 100, fee: 5)],
      prices: {
        1: [(date: '2026-08-29', price: 10.5)]
      },
      day: today,
    );
    // 昨收 0，今收 100×10.5=1050，买花 1005 → 总 +45
    expect(r.totalPnl, closeTo(45, 1e-9));
  });

  test('当日清仓：总盈亏 = 卖净得 − 昨收市值 = 已实现', () {
    final r = computer.compute(
      trades: [
        tr(1, d1, 'BUY', 10, 100),
        tr(1, d2, 'SELL', 11, 100, fee: 2),
      ],
      prices: {
        1: [(date: '2026-08-28', price: 10.5)]
      },
      day: today,
    );
    // 昨收 100×10.5=1050；卖净得 1098；今收 0 → 总 +48
    // 已实现 = 100×(11−10)−2 = 98？注意均价含昨日买入无费=10 → 已实现98
    expect(r.totalPnl, closeTo(48, 1e-9));
    expect(r.realized, closeTo(98, 1e-9));
    // 恒等分解：浮动变化 = 48−98 = −50（昨收市值按10.5计，今日已无持仓）
    expect(r.holdingChange, closeTo(-50, 1e-9));
    expect(r.totalPnl, closeTo(r.realized + r.holdingChange, 1e-9));
  });

  test('当日无交易且未填价 → 沿用旧价估算并标注', () {
    final r = computer.compute(
      trades: [tr(1, d1, 'BUY', 10, 100)],
      prices: {
        1: [(date: '2026-08-28', price: 10.0)]
      },
      day: today,
    );
    // 今日无价 → 沿用昨日10，总盈亏 0，标记估算
    expect(r.isApproximate, isTrue);
    expect(r.totalPnl, closeTo(0, 1e-9));
  });

  test('空账本 → 全零', () {
    final r = computer.compute(trades: const [], prices: const {}, day: today);
    expect(r.totalPnl, 0);
    expect(r.isApproximate, isFalse);
  });

  test('乱序流水自动排序', () {
    final r = computer.compute(
      trades: [
        tr(1, d2, 'SELL', 11, 100),
        tr(1, d1, 'BUY', 10, 100),
      ],
      prices: {
        1: [(date: '2026-08-28', price: 10.0)]
      },
      day: today,
    );
    // 同"当日清仓"用例：昨收1000，卖净得1100 → +100
    expect(r.totalPnl, closeTo(100, 1e-9));
  });

  test('未来日期目标：只统计到该日', () {
    final r = computer.compute(
      trades: [tr(1, d1, 'BUY', 10, 100)],
      prices: {
        1: [(date: '2026-08-28', price: 10.0)]
      },
      day: yesterday,
    );
    // 目标日=昨天：昨收(前日)0持仓，今收1000，买花1000 → 0
    expect(r.totalPnl, closeTo(0, 1e-9));
  });
}
