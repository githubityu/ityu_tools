import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLog {
  AppLog._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,       // 💡 必须设为 0！禁用自动抓取堆栈，否则它永远显示 AppLog.d
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    filter: DevelopmentFilter(),
  );

  /// 💡 手动解析堆栈，找到真正的调用者
  static String _getCallerInfo() {
    final stackTrace = StackTrace.current.toString().split('\n');
    String callerLine = "";

    for (int i = 0; i < stackTrace.length; i++) {
      final line = stackTrace[i];
      // 过滤掉封装类自身
      if (line.contains('log_extensions.dart') ||
          line.contains('AppLog') ||
          line.isEmpty) {
        continue;
      }
      // 匹配 package: 后的路径和行号
      final match = RegExp(r'package:[^ ]+').firstMatch(line);
      if (match != null) {
        callerLine = match.group(0) ?? "";
        // 处理可能存在的括号
        callerLine = callerLine.replaceAll(')', '');
        break;
      }
    }
    return callerLine.isNotEmpty ? '📍 $callerLine' : '';
  }

  static void d(dynamic message) {
    _logger.d('${_getCallerInfo()}\n$message');
  }

  static void i(dynamic message) {
    _logger.i('${_getCallerInfo()}\n$message');
  }

  static void w(dynamic message) {
    _logger.w('${_getCallerInfo()}\n$message');
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    // 错误日志可以保留堆栈
    _logger.e('${_getCallerInfo()}\n$message', error: error, stackTrace: stackTrace);
  }

  static void raw(String message) {
    if (kDebugMode) dev.log(message, name: 'APP_RAW');
  }
}

extension ObjectExt on Object? {
  /// 调试日志 - 自动带上类名
  void logD() {
    final tag = this == null ? 'Null' : '$runtimeType';
    AppLog.d('🏷️ [$tag] $this');
  }

  void logI() {
    final tag = this == null ? 'Null' : '$runtimeType';
    AppLog.i('🏷️ [$tag] $this');
  }

  void logE([dynamic error, StackTrace? stackTrace]) {
    final tag = this == null ? 'Null' : '$runtimeType';
    AppLog.e('🏷️ [$tag] $this', error, stackTrace);
  }
  void logW() {
    final tag = this == null ? 'Null' : '$runtimeType';
    AppLog.w('⚠️ [$tag] $this');
  }
}