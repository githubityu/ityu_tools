import 'dart:io';

import 'package:dio/dio.dart';

enum AppErrorType {
  network,  // 网络连接问题
  business, // 后端返回的业务错误 (code != 0)
  auth,     // 登录失效 (401 或 code: -5)
  cancel,   // 手动取消
  unknown   // 其他
}

class AppError implements Exception {
  final String message;
  final int code;
  final AppErrorType type;

  AppError({required this.message, required this.code, required this.type});

  /// 💡 唯一入口：将任何错误对象转换为统一的 AppError
  factory AppError.from(Object e) {
    if (e is AppError) return e;

    if (e is DioException) {
      if (e.error is AppError) return e.error as AppError;
      return _handleDioException(e);
    }

    if (e is SocketException) return AppError(message: "网络连接不可用", code: -3, type: AppErrorType.network);

    return AppError(message: e.toString(), code: -6, type: AppErrorType.unknown);
  }

  static AppError _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(message: "网络请求超时", code: -4, type: AppErrorType.network);

      case DioExceptionType.cancel:
        return AppError(message: "请求已取消", code: -5, type: AppErrorType.cancel);

      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 500;
        return AppError(
          message: _mapHttpStatusToMessage(status),
          code: status,
          type: (status == 401) ? AppErrorType.auth : AppErrorType.network,
        );

      default:
        return AppError(message: "网络异常，请稍后重试", code: -2, type: AppErrorType.network);
    }
  }

  static String _mapHttpStatusToMessage(int status) {
    if (status >= 500) return "服务器开小差了 ($status)";
    if (status == 401) return "登录已过期，请重新登录";
    if (status == 403) return "没有访问权限";
    if (status == 404) return "接口不存在";
    return "网络响应异常 ($status)";
  }

  @override
  String toString() => message;
}