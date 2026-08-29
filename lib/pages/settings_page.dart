import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../core/di/providers.dart';
import '../core/utils/breakpoints.dart';

/// 设置：数据导出/备份/恢复/关于
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  List<File> _backups = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final service = ref.read(backupServiceProvider);
    final files = await service.listBackups();
    if (mounted) setState(() => _backups = files);
  }

  Future<void> _run(Future<String> Function() task) async {
    setState(() => _busy = true);
    try {
      final msg = await task();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('失败：$e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: CenteredConstrainedBox(
        child: _busy
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('数据', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.table_view_outlined),
                          title: const Text('导出交易流水 CSV'),
                          subtitle: const Text('内容同时复制到剪贴板'),
                          onTap: () => _run(() async {
                            final f = await ref
                                .read(backupServiceProvider)
                                .exportTradesCsv();
                            await Clipboard.setData(
                                ClipboardData(text: await f.readAsString()));
                            return '已导出：${p.basename(f.path)}（剪贴板同步）';
                          }),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.backup_outlined),
                          title: const Text('完整备份'),
                          subtitle: const Text('拷贝数据库（含复盘/快照/全部数据）'),
                          onTap: () => _run(() async {
                            final f = await ref
                                  .read(backupServiceProvider)
                                  .backupDatabase(
                                      closeDb:
                                          ref.read(databaseProvider).close);
                              ref.invalidate(databaseProvider);
                            return '备份完成：${p.basename(f.path)}';
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('恢复（${_backups.length} 份备份）',
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Card(
                    child: _backups.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('还没有备份'),
                          )
                        : Column(
                            children: [
                              for (final b in _backups.take(10))
                                ListTile(
                                  dense: true,
                                  leading:
                                      const Icon(Icons.restore_outlined),
                                  title: Text(p.basename(b.path)),
                                  subtitle: Text(
                                      '${(b.lengthSync() / 1024).toStringAsFixed(0)} KB'),
                                  onTap: () => _confirmRestore(b),
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text('关于', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('复盘手记'),
                      subtitle: Text('v0.1.0 · 数据全部本地存储，不出设备'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _confirmRestore(File b) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('恢复这份备份？'),
        content: const Text(
            '当前数据将被覆盖（原库自动留作 .pre-restore），恢复后建议重启应用。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _run(() async {
                await ref.read(backupServiceProvider).restore(
                      b,
                      closeDb: ref.read(databaseProvider).close,
                    );
                ref.invalidate(databaseProvider);
                return '已恢复 ${p.basename(b.path)}，建议重启应用';
              });
            },
            child: const Text('恢复'),
          ),
        ],
      ),
    );
  }
}
