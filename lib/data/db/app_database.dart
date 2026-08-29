import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/open.dart' as sqlite3_open;

import 'tables.dart';

part 'app_database.g.dart';

/// 鸿蒙端：sqlite3_flutter_libs 尚无 ohos 适配（开发中），
/// OpenHarmony 系统自带 libsqlite3.so（NDK 公共库），直接动态加载。
/// 已知平台（Windows/Linux/macOS/iOS/Android）不受影响，走各自默认加载。
void _initSqliteForOhos() {
  final known = Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isIOS ||
      Platform.isAndroid ||
      Platform.isFuchsia;
  if (!known) {
    sqlite3_open.open
        .overrideForAll(() => DynamicLibrary.open('libsqlite3.so'));
  }
}

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
  AppDatabase.test(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() => LazyDatabase(() async {
        _initSqliteForOhos();
        final dir = await getApplicationDocumentsDirectory();
        final file = File(p.join(dir.path, 'fupan.sqlite'));
        return NativeDatabase.createInBackground(file);
      });
}
