import 'package:flutter_test/flutter_test.dart';

import 'package:fupan_shouji/app.dart';

void main() {
  testWidgets('底部五个 Tab 均渲染且可切换', (tester) async {
    await tester.pumpWidget(const FupanApp());

    // IndexedStack 会同时挂载五个页面，导航栏标签应全部存在
    expect(find.text('今日'), findsWidgets);
    expect(find.text('交易'), findsWidgets);
    expect(find.text('持仓'), findsWidgets);
    expect(find.text('复盘'), findsWidgets);
    expect(find.text('统计'), findsWidgets);

    // 切到统计页
    await tester.tap(find.text('统计').last);
    await tester.pumpAndSettle();
    expect(find.text('核心指标'), findsOneWidget);
  });
}
