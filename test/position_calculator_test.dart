import 'package:flutter_test/flutter_test.dart';

import 'package:fupan_shouji/domain/position_calculator.dart';

void main() {
  const calc = PositionCalculator();
  const empty = PositionState();

  group('买入摊薄成本', () {
    test('首次买入，手续费计入成本', () {
      final s = calc.buy(empty, quantity: 100, price: 10, fee: 5);
      expect(s.quantity, 100);
      expect(s.avgCost, closeTo(10.05, 1e-9));
      expect(s.realizedPnl, 0);
    });

    test('加仓后按数量加权摊薄', () {
      final s1 = calc.buy(empty, quantity: 100, price: 10);
      final s2 = calc.buy(s1, quantity: 100, price: 20, fee: 10);
      expect(s2.quantity, 200);
      // (100*10 + 100*20 + 10) / 200 = 15.05
      expect(s2.avgCost, closeTo(15.05, 1e-9));
    });
  });

  group('卖出结转盈亏', () {
    test('部分卖出：均价不变，盈亏 = 数量×差价−手续费', () {
      final s1 = calc.buy(empty, quantity: 200, price: 15); // 均价 15
      final s2 = calc.sell(s1, quantity: 50, price: 20, fee: 5);
      expect(s2.quantity, 150);
      expect(s2.avgCost, 15);
      // 50*(20-15) - 5 = 245
      expect(s2.realizedPnl, closeTo(245, 1e-9));
    });

    test('亏损卖出记为负值', () {
      final s1 = calc.buy(empty, quantity: 100, price: 20);
      final s2 = calc.sell(s1, quantity: 100, price: 18, fee: 10);
      expect(s2.realizedPnl, closeTo(-210, 1e-9));
    });

    test('清仓后数量归零、均价归零，重新买入重新起算', () {
      final s1 = calc.buy(empty, quantity: 100, price: 10);
      final s2 = calc.sell(s1, quantity: 100, price: 12);
      expect(s2.quantity, 0);
      expect(s2.avgCost, 0);
      expect(s2.isEmpty, isTrue);

      final s3 = calc.buy(s2, quantity: 50, price: 30, fee: 5);
      expect(s3.avgCost, closeTo(30.1, 1e-9));
      // 已实现盈亏跨轮保留累计
      expect(s3.realizedPnl, closeTo(200, 1e-9));
    });
  });

  group('多笔序列', () {
    test('买卖混合后累计已实现盈亏正确', () {
      var s = empty;
      s = calc.buy(s, quantity: 1000, price: 10, fee: 5);   // 均价 10.005
      s = calc.buy(s, quantity: 1000, price: 11, fee: 5);   // 均价 10.505
      s = calc.sell(s, quantity: 500, price: 12, fee: 5);   // +500*1.495-5 = 742.5
      s = calc.sell(s, quantity: 1500, price: 10, fee: 5);  // +1500*(10-10.505)-5 = -762.5
      expect(s.quantity, 0);
      expect(s.realizedPnl, closeTo(742.5 - 762.5, 1e-9));
    });

    test('apply 按方向分发', () {
      final s1 = calc.apply(empty, side: 'BUY', quantity: 100, price: 10);
      final s2 = calc.apply(s1, side: 'SELL', quantity: 100, price: 11, fee: 2);
      expect(s2.realizedPnl, closeTo(98, 1e-9));
    });
  });

  group('参数校验', () {
    test('卖出超过持仓抛 StateError', () {
      final s = calc.buy(empty, quantity: 100, price: 10);
      expect(
        () => calc.sell(s, quantity: 200, price: 12),
        throwsStateError,
      );
    });

    test('数量小于等于 0 抛 ArgumentError', () {
      expect(() => calc.buy(empty, quantity: 0, price: 10), throwsArgumentError);
      expect(() => calc.buy(empty, quantity: -5, price: 10), throwsArgumentError);
      final s = calc.buy(empty, quantity: 100, price: 10);
      expect(() => calc.sell(s, quantity: 0, price: 12), throwsArgumentError);
    });
  });
}
