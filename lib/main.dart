import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/db/seed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debug 版空库时插入演示数据（见 seed.dart，release 不执行）
  final boot = AppDatabase();
  await seedDemoDataIfEmpty(boot);
  await boot.close();

  runApp(const ProviderScope(child: FupanApp()));
}
