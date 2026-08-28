import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories.dart';
import '../../domain/position_book.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final tradeRepositoryProvider =
    Provider<TradeRepository>((ref) => TradeRepository(ref.watch(databaseProvider)));

final priceRepositoryProvider =
    Provider<PriceRepository>((ref) => PriceRepository(ref.watch(databaseProvider)));

/// 全部交易流水（带标的），时间倒序
final tradesProvider = StreamProvider<List<TradeWithInstrument>>(
    (ref) => ref.watch(tradeRepositoryProvider).watchTrades());

/// 标的库（自动补全用）
final instrumentsProvider = StreamProvider<List<Instrument>>(
    (ref) => ref.watch(tradeRepositoryProvider).watchInstruments());

/// 每个标的的最新手动价
final latestPricesProvider = StreamProvider<Map<int, double>>(
    (ref) => ref.watch(priceRepositoryProvider).watchLatestPrices());

const _computer = PositionBookComputer();

/// 持仓账本：当前持仓 / 已了结 / 逐日盈亏（由流水+价格即时推导）
final positionBookProvider = Provider<PositionBook?>((ref) {
  final trades = ref.watch(tradesProvider).valueOrNull;
  if (trades == null) return null;
  final prices = ref.watch(latestPricesProvider).valueOrNull ?? const {};
  return _computer.compute(
    trades: trades
        .map((t) => TradeRecord(
              instrumentId: t.instrument.id,
              tradedAt: t.trade.tradedAt,
              side: t.trade.side,
              price: t.trade.price,
              quantity: t.trade.quantity,
              fee: t.trade.fee,
            ))
        .toList(),
    lastPrices: prices,
  );
});

/// 标的速查表
final instrumentByIdProvider = Provider<Map<int, Instrument>>((ref) {
  final list = ref.watch(instrumentsProvider).valueOrNull ?? const [];
  return {for (final i in list) i.id: i};
});
