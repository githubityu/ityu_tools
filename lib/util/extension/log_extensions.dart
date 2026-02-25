import 'dart:developer' as dev;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AppLog {
  AppLog._();

  /// 单例 Logger，避免重复创建实例造成的开销
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,       // 堆栈跟踪的深度
      errorMethodCount: 8,  // 错误时的深度
      lineLength: 120,      // 每行长度
      colors: true,         // 彩色输出
      printEmojis: true,    // 打印表情
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,      // 打印时间
    ),
    // 仅在开发模式下输出
    filter: DevelopmentFilter(),
  );

  static void d(dynamic message) => _logger.d(message);
  static void i(dynamic message) => _logger.i(message);
  static void w(dynamic message) => _logger.w(message);
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 使用 dart:developer 的 log，适合长字符串打印（不会被系统截断）
  static void raw(String message) {
    if (kDebugMode) {
      dev.log(message, name: 'APP_RAW');
    }
  }
}

extension ObjectExt on Object? {
  /// 调试日志
  void logD() => AppLog.d(this);

  /// 信息日志
  void logI() => AppLog.i(this);

  /// 错误日志
  void logE([dynamic error, StackTrace? stackTrace]) {
    AppLog.e(this?.toString() ?? 'Null Object', error, stackTrace);
  }
}

class ErrorHandler {
  ErrorHandler._();

  static void init() {
    // 1. 捕获 Flutter 框架抛出的错误 (渲染、生命周期等)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLog.e('Flutter Error', details.exception, details.stack);
    };

    // 2. 捕获异步错误 (未处理的 Future 异常等)
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLog.e('Platform Error', error, stack);
      // 返回 true 表示已处理错误
      return true;
    };

    // 3. 自定义组件崩溃时的 UI 展示
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                kDebugMode ? details.exception.toString() : 'Please restart the app',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    };
  }
}