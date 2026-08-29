import 'package:flutter/material.dart';

import '../core/utils/breakpoints.dart';
import '../pages/positions_page.dart';
import '../pages/review_page.dart';
import '../pages/stats_page.dart';
import '../pages/today_page.dart';
import '../pages/trades_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const List<Widget> _pages = [
    TodayPage(),
    TradesPage(),
    PositionsPage(),
    ReviewPage(),
    StatsPage(),
  ];

  static const _labels = ['今日', '交易', '持仓', '复盘', '统计'];
  static const _icons = [
    Icon(Icons.today_outlined),
    Icon(Icons.receipt_long_outlined),
    Icon(Icons.account_balance_wallet_outlined),
    Icon(Icons.event_note_outlined),
    Icon(Icons.insights_outlined),
  ];
  static const _selectedIcons = [
    Icon(Icons.today),
    Icon(Icons.receipt_long),
    Icon(Icons.account_balance_wallet),
    Icon(Icons.event_note),
    Icon(Icons.insights),
  ];

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(index: _index, children: _pages);

    // 宽屏（Mate X7 展开态 / 平板）：侧边 NavigationRail
    if (isWide(context)) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (var i = 0; i < _labels.length; i++)
                  NavigationRailDestination(
                    icon: _icons[i],
                    selectedIcon: _selectedIcons[i],
                    label: Text(_labels[i]),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    // 窄屏（折叠态 / 直板机）：底部 NavigationBar
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (var i = 0; i < _labels.length; i++)
            NavigationDestination(
              icon: _icons[i],
              selectedIcon: _selectedIcons[i],
              label: _labels[i],
            ),
        ],
      ),
    );
  }
}
