import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  const CacheManager._();

  /// 获取缓存目录
  static Future<Directory> get _cacheDir => getTemporaryDirectory();

  /// 清除缓存
  /// 优化：使用异步流处理，并添加错误处理，防止单个文件被占用导致整个操作崩溃
  static Future<void> clear() async {
    try {
      final Directory dir = await _cacheDir;
      if (!await dir.exists()) return;

      // 使用 list 而不是 listSync，避免阻塞 UI
      await for (final FileSystemEntity entity in dir.list(recursive: false)) {
        try {
          await entity.delete(recursive: true);
        } catch (e) {
          // 打印错误，通常是因为文件正在被占用
          print('Failed to delete ${entity.path}: $e');
        }
      }
    } catch (e) {
      print('Clear cache error: $e');
    }
  }

  /// 计算缓存大小
  /// 优化：使用异步递归遍历，只计算文件大小
  static Future<int> cacheSize() async {
    try {
      final Directory dir = await _cacheDir;
      if (!await dir.exists()) return 0;

      int totalSize = 0;
      // 递归遍历所有实体
      await for (final FileSystemEntity entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      print('Get cache size error: $e');
      return 0;
    }
  }

  /// 格式化缓存大小
  /// 优化：使用更优雅的数学公式处理单位转换
  static Future<String> formatCacheSize() async {
    final int size = await cacheSize();
    if (size <= 0) return '0 B';

    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
    // 计算以 1024 为底的对数，确定单位索引
    int digit = (log(size) / log(1024)).floor();
    // 确保索引不越界
    digit = min(digit, units.length - 1);

    final double res = size / pow(1024, digit);
    return '${res.toStringAsFixed(2)} ${units[digit]}';
  }
}