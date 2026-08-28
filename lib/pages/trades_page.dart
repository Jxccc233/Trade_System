import 'package:flutter/material.dart';

import '../core/widgets/placeholder_panel.dart';

/// 交易流水：按交易日分组倒序，支持筛选（M1 接入真实数据）
class TradesPage extends StatelessWidget {
  const TradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('交易')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PlaceholderPanel(
            title: '交易流水',
            description: '按日分组展示买卖记录，可按标的、方向、标签、日期筛选。',
            milestone: 'M1',
          ),
        ],
      ),
    );
  }
}
