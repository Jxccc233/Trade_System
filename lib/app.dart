import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'shell/app_shell.dart';

class FupanApp extends StatelessWidget {
  const FupanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '复盘手记',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const AppShell(),
    );
  }
}
