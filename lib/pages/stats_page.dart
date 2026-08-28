import 'package:flutter/material.dart';

import '../core/widgets/placeholder_panel.dart';

/// 统计：核心指标与图表（M2 接入真实数据）
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('统计')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PlaceholderPanel(
            title: '核心指标',
            description: '累计已实现盈亏、胜率、盈亏比、交易笔数、手续费合计。',
            milestone: 'M2',
          ),
          PlaceholderPanel(
            title: '图表',
            description: '资产净值曲线、按策略标签归因、月度报表。',
            milestone: 'M2 / M4+',
          ),
        ],
      ),
    );
  }
}
