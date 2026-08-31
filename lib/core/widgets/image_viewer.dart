import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/image_store.dart';

/// 全屏截图查看器：双指缩放 + 左右翻页，点背景关闭
Future<void> showImageViewer(
  BuildContext context,
  List<File> images, {
  int initialIndex = 0,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (context, _, __) => _ImageViewer(
        images: images,
        initialIndex: initialIndex,
      ),
    ),
  );
}

class _ImageViewer extends StatefulWidget {
  const _ImageViewer({required this.images, required this.initialIndex});

  final List<File> images;
  final int initialIndex;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index) => InteractiveViewer(
            maxScale: 6,
            minScale: 0.8,
            child: Center(
              child: Image.file(
                widget.images[index],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white38,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 缩略图（点击进查看器）
class ScreenshotThumb extends StatelessWidget {
  const ScreenshotThumb({
    super.key,
    required this.relPath,
    required this.allRelPaths,
    this.size = 64,
  });

  final String relPath;
  final List<String> allRelPaths;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showImageViewer(
        context,
        [for (final r in allRelPaths) ImagePathResolver.resolve(r)],
        initialIndex: allRelPaths.indexOf(relPath),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: size,
          height: size,
          child: Image.file(
            ImagePathResolver.resolve(relPath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
