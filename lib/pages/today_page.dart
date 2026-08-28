import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/format.dart';
import '../core/widgets/placeholder_panel.dart';

/// 今日仪表盘：当日盈亏、持仓概览、待办提醒（M2 接入真实数据）
class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '今日盈亏',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    signedMoney(0),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.flat,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '持仓市值 — · 浮动盈亏 —',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const PlaceholderPanel(
            title: '今日交易',
            description: '当天买卖流水与买卖理由，随记随看。',
            milestone: 'M1',
          ),
          const PlaceholderPanel(
            title: '待办提醒',
            description: '收盘后提醒写复盘，未复盘的日期在日历上一目了然。',
            milestone: 'M2',
          ),
        ],
      ),
    );
  }
}
