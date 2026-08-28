import 'package:drift/drift.dart';

/// 交易方向
abstract final class TradeSide {
  static const String buy = 'BUY';
  static const String sell = 'SELL';
}

/// 市场（A股：沪 / 深 / 北）
abstract final class Market {
  static const String sh = 'SH';
  static const String sz = 'SZ';
  static const String bj = 'BJ';
}

/// 证券类型
abstract final class InstrumentType {
  static const String stock = 'STOCK';
  static const String etf = 'ETF';
  static const String other = 'OTHER';
}

/// 标的库：使用中自动积累，支持收藏与最近使用
class Instruments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 12)();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  TextColumn get market => text().withLength(min: 2, max: 4)();

  /// 见 [InstrumentType]
  TextColumn get type => text().withDefault(const Constant(InstrumentType.stock))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [{code, market}];
}

/// 交易流水：一切统计的唯一源头
class Trades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get instrumentId => integer().references(Instruments, #id)();

  /// 成交时间（盘后补记也允许）
  DateTimeColumn get tradedAt => dateTime()();

  /// 见 [TradeSide]
  TextColumn get side => text()();
  RealColumn get price => real()();
  RealColumn get quantity => real()();
  RealColumn get fee => real().withDefault(const Constant(0))();

  /// 买卖理由
  TextColumn get reason => text().nullable()();

  /// 情绪标记（冷静 / 冲动 / FOMO / 止损……）
  TextColumn get emotion => text().nullable()();

  /// JSON 数组：标签 id 列表
  TextColumn get tagIds => text().withDefault(const Constant('[]'))();

  /// JSON 数组：截图相对路径列表
  TextColumn get images => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime()();
}

/// 每日复盘：一天一条
class DailyReviews extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// yyyy-MM-dd，唯一
  TextColumn get date => text().withLength(min: 10, max: 10)();
  TextColumn get marketNote => text().nullable()();
  TextColumn get didRight => text().nullable()();
  TextColumn get didWrong => text().nullable()();
  TextColumn get plan => text().nullable()();

  /// 心态自评 1–5
  IntColumn get mood => integer().nullable()();

  /// JSON 对象：纪律清单 {条目: 是否做到}
  TextColumn get checklist => text().withDefault(const Constant('{}'))();
  TextColumn get images => text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [{date}];
}

/// 手动价格（收盘价/现价），用于浮动盈亏与市值
class PriceEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get instrumentId => integer().references(Instruments, #id)();

  /// yyyy-MM-dd
  TextColumn get date => text().withLength(min: 10, max: 10)();
  RealColumn get price => real()();

  @override
  List<Set<Column>> get uniqueKeys => [{instrumentId, date}];
}

/// 每日资产快照：复盘保存时自动生成，是净值曲线的数据源
class DailySnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().withLength(min: 10, max: 10)();

  /// 期初本金（允许后补，用于真实收益率）
  RealColumn get principal => real().nullable()();
  RealColumn get marketValue => real().withDefault(const Constant(0))();
  RealColumn get cash => real().nullable()();
  RealColumn get realizedPnlCum => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [{date}];
}

/// 标签：策略 / 板块 / 情绪
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 16)();

  /// STRATEGY / SECTOR / EMOTION
  TextColumn get type => text().withDefault(const Constant('STRATEGY'))();

  /// 0xAARRGGBB
  IntColumn get color => integer().withDefault(const Constant(0xFF3B82F6))();

  @override
  List<Set<Column>> get uniqueKeys => [{name, type}];
}

/// 键值设置：期初本金、提醒时间等
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
