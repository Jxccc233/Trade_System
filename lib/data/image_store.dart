import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 截图存储：相册选图 → 复制进应用目录（不引用相册路径，防原图被清理后失效）
/// 数据库存相对路径（images 字段），展示时经 [ImagePathResolver] 解析绝对路径。
class ImageStore {
  static const dirName = 'images';

  Future<Directory> _dir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, dirName));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// 相册多选，返回新增的相对路径列表（用户取消返回空）
  Future<List<String>> pickAndSave() async {
    final files = await ImagePicker().pickMultiImage(
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (files.isEmpty) return const [];
    final dir = await _dir();
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final saved = <String>[];
    for (var i = 0; i < files.length; i++) {
      final name = '${stamp}_$i.jpg';
      await File(files[i].path).copy(p.join(dir.path, name));
      saved.add('$dirName/$name');
    }
    return saved;
  }

  Future<void> deleteAll(List<String> relPaths) async {
    final root = await getApplicationDocumentsDirectory();
    for (final rel in relPaths) {
      final f = File(p.join(root.path, rel));
      if (f.existsSync()) {
        try {
          f.deleteSync();
        } catch (_) {}
      }
    }
  }
}

/// 同步路径解析（main 里 init 一次，UI 构建时用）
class ImagePathResolver {
  ImagePathResolver._(this._root);
  static ImagePathResolver? _instance;

  static Future<void> init() async {
    final root = await getApplicationDocumentsDirectory();
    _instance = ImagePathResolver._(root.path);
  }

  final String _root;

  static File resolve(String rel) {
    final inst = _instance;
    if (inst == null) {
      throw StateError('ImagePathResolver 未初始化');
    }
    return File(p.join(inst._root, rel));
  }
}
