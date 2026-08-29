import 'package:drift/drift.dart';

import 'db/app_database.dart';

/// 每日复盘仓库
class ReviewRepository {
  ReviewRepository(this.db);

  final AppDatabase db;

  /// 保存/覆盖某日复盘，并写入当日资产快照
  Future<void> saveReview({
    required DateTime date,
    String? marketNote,
    String? didRight,
    String? didWrong,
    String? plan,
    int? mood,
    Map<String, bool>? checklist,
    required double marketValue,
    required double realizedPnlCum,
  }) async {
    final key = _dateKey(date);
    final now = DateTime.now();
    await db.transaction(() async {
      final existing = await (db.select(db.dailyReviews)
            ..where((t) => t.date.equals(key)))
          .getSingleOrNull();
      final values = DailyReviewsCompanion.insert(
        date: key,
        marketNote: Value(marketNote),
        didRight: Value(didRight),
        didWrong: Value(didWrong),
        plan: Value(plan),
        mood: Value(mood),
        checklist: Value(_encodeChecklist(checklist)),
        updatedAt: now,
      );
      if (existing == null) {
        await db.into(db.dailyReviews).insert(values);
      } else {
        await (db.update(db.dailyReviews)
              ..where((t) => t.date.equals(key)))
            .write(values);
      }
      // 每日快照（同日覆盖）
      await db.into(db.dailySnapshots).insertOnConflictUpdate(
            DailySnapshotsCompanion.insert(
              date: key,
              marketValue: Value(marketValue),
              realizedPnlCum: Value(realizedPnlCum),
              createdAt: Value(now),
            ),
          );
    });
  }

  /// 全部复盘：dateKey → 复盘
  Stream<Map<String, DailyReview>> watchReviews() {
    return db.select(db.dailyReviews).watch().map((rows) => {
          for (final r in rows) r.date: r,
        });
  }

  Stream<Map<String, DailySnapshot>> watchSnapshots() {
    return db.select(db.dailySnapshots).watch().map((rows) => {
          for (final s in rows) s.date: s,
        });
  }
}

String _dateKey(DateTime dt) =>
    '${dt.year.toString().padLeft(4, '0')}-'
    '${dt.month.toString().padLeft(2, '0')}-'
    '${dt.day.toString().padLeft(2, '0')}';

String _encodeChecklist(Map<String, bool>? checklist) {
  if (checklist == null) return '{}';
  final parts = checklist.entries.map((e) => '"${e.key}":${e.value ? 'true' : 'false'}');
  return '{${parts.join(',')}}';
}

/// 纪律清单默认条目（M2 固定模板，自定义 P2）
const kDefaultChecklist = <String>[
  '按计划执行',
  '未追涨杀跌',
  '仓位未超限',
  '执行了止损',
  '没有频繁交易',
];
