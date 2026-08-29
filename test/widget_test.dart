import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fupan_shouji/app.dart';
import 'package:fupan_shouji/core/di/providers.dart';

void main() {
  testWidgets('底部五个 Tab 均渲染且可切换', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // 组件测试不碰真实数据库：数据源给空数据
        overrides: [
          tradesProvider.overrideWith((ref) => Stream.value(const [])),
          instrumentsProvider.overrideWith((ref) => Stream.value(const [])),
          latestPricesProvider
              .overrideWith((ref) => Stream.value(const {})),
        ],
        child: const FupanApp(),
      ),
    );

    // IndexedStack 会同时挂载五个页面，导航栏标签应全部存在
    expect(find.text('今日'), findsWidgets);
    expect(find.text('交易'), findsWidgets);
    expect(find.text('持仓'), findsWidgets);
    expect(find.text('复盘'), findsWidgets);
    expect(find.text('统计'), findsWidgets);

    // 切到统计页
    await tester.tap(find.text('统计').last);
    await tester.pumpAndSettle();
    // 统计页已是真实数据视图
    expect(find.text('累计已实现盈亏'), findsOneWidget);
  });
}
