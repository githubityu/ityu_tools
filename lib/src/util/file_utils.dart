import 'dart:math';
import 'package:path/path.dart' as p; // 建议使用官方 path 包

class FileUtils {
  const FileUtils._();

  /// 生成固定长度的随机字符串
  /// 优化：使用 StringBuffer 或 List.generate 提高性能，避免字符串频繁拼接
  static String getRandomString(int length) {
    const alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
            (_) => alphabet.codeUnitAt(random.nextInt(alphabet.length)),
      ),
    );
  }

  /// 根据文件路径获取文件名
  /// 优化：使用 path 包，自动处理 / 和 \，并处理无路径情况
  static String getFileName(String filePath) {
    if (filePath.isEmpty) return '';
    return p.basename(filePath);
  }

  /// 获取文件后缀名（不带点，如 'jpg'）
  /// 优化：使用 path 包处理，更鲁棒
  static String getFileExtension(String path) {
    if (path.isEmpty) return '';
    // p.extension 返回的是 ".jpg"，我们去掉前面的点
    final ext = p.extension(path);
    return ext.isNotEmpty ? ext.substring(1).toLowerCase() : '';
  }

  /// 生成一个随机的文件名（常用于拍照存储）
  /// 格式：prefix_随机数.ext
  static String generateRandomFileName(String originalPath, {String prefix = 'file'}) {
    final ext = p.extension(originalPath);
    final randomStr = getRandomString(8);
    return '${prefix}_$randomStr$ext';
  }
}