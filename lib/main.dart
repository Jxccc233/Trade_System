import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/backup.dart';
import 'data/db/app_database.dart';
import 'data/db/seed.dart';
import 'data/image_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 截图路径同步解析器（UI 构建时用）
  await ImagePathResolver.init();
  // debug 版空库时插入演示数据（见 seed.dart，release 不执行）
  final boot = AppDatabase();
  await seedDemoDataIfEmpty(boot);
  await boot.close();
  // 自动每日备份（§5.6）：今日首次启动整库留档
  await BackupService(boot).autoDailyBackupIfDue();

  runApp(const ProviderScope(child: FupanApp()));
}
