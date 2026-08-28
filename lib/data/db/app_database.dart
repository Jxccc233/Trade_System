import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Instruments,
  Trades,
  DailyReviews,
  PriceEntries,
  DailySnapshots,
  Tags,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  /// 测试用：传入内存库
  AppDatabase.test(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() => LazyDatabase(() async {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(p.join(dir.path, 'fupan.sqlite'));
        return NativeDatabase.createInBackground(file);
      });
}
