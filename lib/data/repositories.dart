import 'package:drift/drift.dart';

import '../domain/position_book.dart';
import 'db/app_database.dart';
import 'db/tables.dart';
import 'image_store.dart';

/// images 字段的编解码（JSON 字符串数组）
String encodeImages(List<String> images) =>
    '[${images.map((e) => '"$e"').join(',')}]';

List<String> decodeImages(String raw) {
  if (raw.length <= 2) return const [];
  return raw
      .substring(1, raw.length - 1)
      .split('","')
      .map((s) => s.replaceAll('"', ''))
      .where((s) => s.isNotEmpty)
      .toList();
}

/// 交易流水 + 标的仓库
class TradeRepository {
  TradeRepository(this.db);

  final AppDatabase db;

  /// 按代码+市场查找标的，不存在则创建（使用中自动积累标的库）
  Future<Instrument> findOrCreateInstrument({
    required String code,
    required String name,
    required String market,
    String type = InstrumentType.stock,
  }) async {
    final existing = await (db.select(db.instruments)
          ..where((t) => t.code.equals(code) & t.market.equals(market)))
        .getSingleOrNull();
    if (existing != null) {
      if (existing.name != name) {
        await (db.update(db.instruments)
              ..where((t) => t.id.equals(existing.id)))
            .write(InstrumentsCompanion(name: Value(name)));
        return existing.copyWith(name: name);
      }
      return existing;
    }
    final id = await db.into(db.instruments).insert(
          InstrumentsCompanion.insert(
            code: code,
            name: name,
            market: market,
            type: Value(type),
          ),
        );
    return Instrument(
      id: id,
      code: code,
      name: name,
      market: market,
      type: type,
      isFavorite: false,
      createdAt: DateTime.now(),
    );
  }

  /// 期望的标的（用于卖出校验）：code+market 精确匹配
  Future<Instrument?> findInstrument(String code, String market) {
    return (db.select(db.instruments)
          ..where((t) => t.code.equals(code) & t.market.equals(market)))
        .getSingleOrNull();
  }

  Future<int> addTrade({
    required int instrumentId,
    required DateTime tradedAt,
    required String side,
    required double price,
    required double quantity,
    double fee = 0,
    String? reason,
    String? emotion,
    List<String> images = const [],
  }) {
    return db.into(db.trades).insert(TradesCompanion.insert(
          instrumentId: instrumentId,
          tradedAt: tradedAt,
          side: side,
          price: price,
          quantity: quantity,
          fee: Value(fee),
          reason: Value(reason),
          emotion: Value(emotion),
          images: Value(encodeImages(images)),
          updatedAt: DateTime.now(),
        ));
  }

  /// 删除交易并清理其截图文件
  Future<void> deleteTrade(int id) async {
    final row = await (db.select(db.trades)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row != null) {
      await ImageStore().deleteAll(decodeImages(row.images));
    }
    await (db.delete(db.trades)..where((t) => t.id.equals(id))).go();
  }

  /// 交易流水（带标的信息），按时间倒序
  Stream<List<TradeWithInstrument>> watchTrades() {
    final query = db.select(db.trades).join([
      innerJoin(db.instruments,
          db.instruments.id.equalsExp(db.trades.instrumentId)),
    ]);
    query.orderBy([
      OrderingTerm.desc(db.trades.tradedAt),
      OrderingTerm.desc(db.trades.id),
    ]);
    return query.watch().map((rows) => rows
        .map((r) => TradeWithInstrument(
              r.readTable(db.trades),
              r.readTable(db.instruments),
            ))
        .toList());
  }

  Stream<List<Instrument>> watchInstruments() {
    return (db.select(db.instruments)
          ..orderBy([
            (t) => OrderingTerm.desc(t.isFavorite),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }
}

class TradeWithInstrument {
  const TradeWithInstrument(this.trade, this.instrument);

  final Trade trade;
  final Instrument instrument;
}

/// 手动价格仓库
class PriceRepository {
  PriceRepository(this.db);

  final AppDatabase db;

  /// 写当日价格（同日覆盖）
  Future<void> setTodayPrice(int instrumentId, double price) {
    final today = dateKey(DateTime.now());
    return db.into(db.priceEntries).insertOnConflictUpdate(
          PriceEntriesCompanion.insert(
            instrumentId: instrumentId,
            date: today,
            price: price,
          ),
        );
  }

  /// 每个标的的最新价（按日期取最近）
  Stream<Map<int, double>> watchLatestPrices() {
    return (db.select(db.priceEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) {
      final map = <int, double>{};
      for (final r in rows) {
        map.putIfAbsent(r.instrumentId, () => r.price);
      }
      return map;
    });
  }
}
