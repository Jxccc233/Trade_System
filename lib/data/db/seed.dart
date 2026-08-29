import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'app_database.dart';
import 'tables.dart';

/// debug 版演示数据：空库时插入两笔交易（一笔持仓中 + 一笔当日已了结），
/// 便于在模拟器上直接看到流水/持仓/盈亏效果。release 构建不会执行。
Future<void> seedDemoDataIfEmpty(AppDatabase db) async {
  if (!kDebugMode) return;
  final existing = await (db.select(db.trades)..limit(1)).get();
  if (existing.isNotEmpty) return;

  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));

  Future<int> instrument(String code, String name, String market) async {
    return db.into(db.instruments).insert(InstrumentsCompanion.insert(
          code: code,
          name: name,
          market: market,
        ));
  }

  Future<void> trade(int iid, DateTime at, String side, double price,
      double qty, double fee, String reason, String emotion) async {
    await db.into(db.trades).insert(TradesCompanion.insert(
          instrumentId: iid,
          tradedAt: at,
          side: side,
          price: price,
          quantity: qty,
          fee: Value(fee),
          reason: Value(reason),
          emotion: Value(emotion),
          updatedAt: now,
        ));
  }

  // 持仓中：贵州茅台（现价高于成本 → 浮盈）
  final maotai = await instrument('600519', '贵州茅台', Market.sh);
  await trade(maotai, now.subtract(const Duration(hours: 3)), TradeSide.buy,
      1680, 100, 5, '演示数据：底部区域建仓', '计划内');
  await db.into(db.priceEntries).insert(PriceEntriesCompanion.insert(
        instrumentId: maotai,
        date: _dateKey(now),
        price: 1750,
      ));

  // 当日已了结：平安银行（昨买今卖 → 今日已实现盈亏）
  final pingan = await instrument('000001', '平安银行', Market.sz);
  await trade(pingan, yesterday, TradeSide.buy, 10, 1000, 3, '演示数据：试仓',
      '计划内');
  await trade(pingan, now.subtract(const Duration(hours: 1)), TradeSide.sell,
      10.8, 1000, 3, '演示数据：冲高止盈', '止盈');
}

String _dateKey(DateTime dt) =>
    '${dt.year.toString().padLeft(4, '0')}-'
    '${dt.month.toString().padLeft(2, '0')}-'
    '${dt.day.toString().padLeft(2, '0')}';
