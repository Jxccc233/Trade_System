import 'package:flutter/material.dart';

/// 宽屏阈值：Mate X7 展开态 / 平板（折叠态按窄屏处理）
const double kWideBreakpoint = 640;

bool isWide(BuildContext context) =>
    MediaQuery.of(context).size.width >= kWideBreakpoint;

/// 宽屏时约束内容最大宽度并居中（表单/详情类页面用）
class CenteredConstrainedBox extends StatelessWidget {
  const CenteredConstrainedBox({super.key, required this.child, this.maxWidth = 640});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (!isWide(context)) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
