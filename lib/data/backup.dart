import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'db/app_database.dart';

/// 备份与导出
/// - CSV：交易流水（人可读，Excel 可开）
/// - 完整备份：直接拷贝 SQLite 数据库文件（含复盘/快照/标签/设置全部数据）
class BackupService {
  BackupService(this.db);

  final AppDatabase db;

  Future<Directory> _backupDir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'backups'));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// 导出交易流水 CSV，返回文件
  Future<File> exportTradesCsv() async {
    final rows = await (db.select(db.trades).join([
      innerJoin(db.instruments,
          db.instruments.id.equalsExp(db.trades.instrumentId)),
    ])
          ..orderBy([OrderingTerm.desc(db.trades.tradedAt)]))
        .get();

    final buf = StringBuffer('\uFEFF'); // BOM：Excel 识别 UTF-8
    buf.writeln('成交时间,市场,代码,名称,方向,价格,数量,手续费,金额,情绪,理由');
    final fmt = DateFormat('yyyy-MM-dd HH:mm');
    for (final r in rows) {
      final t = r.readTable(db.trades);
      final i = r.readTable(db.instruments);
      final amount = t.price * t.quantity;
      buf.writeln([
        fmt.format(t.tradedAt),
        i.market,
        i.code,
        i.name,
        t.side == 'BUY' ? '买入' : '卖出',
        t.price.toStringAsFixed(3),
        t.quantity.toStringAsFixed(3),
        t.fee.toStringAsFixed(2),
        amount.toStringAsFixed(2),
        t.emotion ?? '',
        (t.reason ?? '').replaceAll('\n', ' '),
      ].map((c) => '"${c.replaceAll('"', '""')}"').join(','));
    }
    final dir = await _backupDir();
    final file = File(p.join(
        dir.path, '交易流水-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.csv'));
    return file.writeAsString(buf.toString(), flush: true);
  }

  /// 完整备份（拷贝 SQLite 文件）。调用前应确保数据库已落盘。
  Future<File> backupDatabase({required void Function() closeDb}) async {
    final dir = await _backupDir();
    final stamp = DateFormat('yyyyMMdd-HHmm').format(DateTime.now());
    final dest = File(p.join(dir.path, '复盘手记备份-$stamp.sqlite'));
    closeDb();
    final root = await getApplicationDocumentsDirectory();
    final src = File(p.join(root.path, 'fupan.sqlite'));
    return src.copySync(dest.path);
  }

  /// 列出全部备份（新→旧）
  Future<List<File>> listBackups() async {
    final dir = await _backupDir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.sqlite'))
        .toList()
      ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files;
  }

  /// 从备份恢复（覆盖当前库）。返回后需要重建数据库连接（重启应用最稳）。
  Future<void> restore(File backup, {required void Function() closeDb}) async {
    closeDb();
    final root = await getApplicationDocumentsDirectory();
    final dest = File(p.join(root.path, 'fupan.sqlite'));
    // 当前库先留一份 .pre-restore 以防万一
    if (dest.existsSync()) {
      dest.copySync('${dest.path}.pre-restore');
    }
    backup.copySync(dest.path);
  }

  /// 删除旧备份，只保留最近 [keep] 份
  Future<void> pruneBackups({int keep = 10}) async {
    final all = await listBackups();
    for (final f in all.skip(keep)) {
      f.deleteSync();
    }
  }

  /// 自动每日备份（§5.6 v0.3）：今日尚无自动备份时整库留档一份，保留最近 10 份。
  /// 在应用启动、数据库文件已落盘且无连接打开时调用。
  Future<void> autoDailyBackupIfDue() async {
    final dir = await _backupDir();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final marker = File(p.join(dir.path, 'auto-$today.sqlite'));
    if (marker.existsSync()) return;
    final root = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(root.path, 'fupan.sqlite'));
    if (!dbFile.existsSync()) return; // 首次启动无库
    dbFile.copySync(marker.path);
    await pruneBackups(keep: 10);
  }
}
