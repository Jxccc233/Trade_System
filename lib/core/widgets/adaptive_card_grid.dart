import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';

/// 窄屏单列、宽屏（折叠展开/平板）双列的卡片流
class AdaptiveCardGrid extends StatelessWidget {
  const AdaptiveCardGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (!wide)
          ...children
        else
          for (var i = 0; i < children.length; i += 2)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: children[i]),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
      ],
    );
  }
}
