import 'package:flutter/material.dart';

import '../core/widgets/placeholder_panel.dart';

/// 持仓：由交易流水自动计算摊薄成本与浮盈（M1 接入真实数据）
class PositionsPage extends StatelessWidget {
  const PositionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('持仓')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PlaceholderPanel(
            title: '当前持仓',
            description: '数量、摊薄成本（含手续费）、手动填价后的浮动盈亏与仓位占比。',
            milestone: 'M1',
          ),
          PlaceholderPanel(
            title: '已了结交易',
            description: '清仓后自动归档：完整买卖配对、持仓天数、单笔盈亏与当时的理由。',
            milestone: 'M1',
          ),
        ],
      ),
    );
  }
}
