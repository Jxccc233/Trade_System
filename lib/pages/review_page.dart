import 'package:flutter/material.dart';

import '../core/widgets/placeholder_panel.dart';

/// 复盘：日历视图 + 每日复盘表单（M2 接入真实数据）
class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('复盘')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PlaceholderPanel(
            title: '复盘日历',
            description: '每格标注当日盈亏（红涨绿跌）与是否已复盘，点击进入当天。',
            milestone: 'M2',
          ),
          PlaceholderPanel(
            title: '复盘表单',
            description: '大盘简评、做对了什么 / 做错了什么、明日计划、心态自评、纪律清单。',
            milestone: 'M2',
          ),
        ],
      ),
    );
  }
}
