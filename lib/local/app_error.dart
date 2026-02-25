import 'dart:io';
import 'package:dio/dio.dart';

/// 业务常量建议放到专门的 Constants 类中
const String httpNotVerified = '100002';

/// 错误类型枚举
enum AppErrorType {
  app(-1, 'Business Error'),
  network(-2, 'Network Error'),
  socket(-3, 'Socket connection failed'),
  timeout(-4, 'Connection timeout'),
  cancel(-5, 'Request cancelled'),
  unknown(-6, 'Unknown error');

  final int code;
  final String defaultMessage;
  const AppErrorType(this.code, this.defaultMessage);
}

class AppError implements Exception {
  final String message;
  final int errorCode;
  final dynamic originalError;

  AppError({
    required this.message,
    required this.errorCode,
    this.originalError,
  });

  /// 核心工厂方法：将各种异常转换为统一的 AppError
  factory AppError.from(Object exception) {
    if (exception is AppError) return exception;

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is SocketException) {
      return AppError(
        message: AppErrorType.socket.defaultMessage,
        errorCode: AppErrorType.socket.code,
        originalError: exception,
      );
    }

    return AppError(
      message: exception.toString(),
      errorCode: AppErrorType.unknown.code,
      originalError: exception,
    );
  }

  /// 针对 Dio 异常的详细分类处理
  static AppError _handleDioException(DioException e) {
    // 如果 error 本身已经是 AppError (例如在拦截器中抛出的)，直接返回
    if (e.error is AppError) {
      return e.error as AppError;
    }

    // 根据 DioExceptionType 进行分类
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(
          message: 'Connection timed out',
          errorCode: AppErrorType.timeout.code,
          originalError: e,
        );

      case DioExceptionType.badResponse:
      // 这里的 e.response?.statusCode 包含 404, 500 等
        final statusCode = e.response?.statusCode ?? AppErrorType.app.code;
        final statusMsg = e.response?.statusMessage ?? 'Server Error';
        return AppError(
          message: 'Server Error ($statusCode): $statusMsg',
          errorCode: statusCode,
          originalError: e,
        );

      case DioExceptionType.cancel:
        return AppError(
          message: 'Request was cancelled',
          errorCode: AppErrorType.cancel.code,
          originalError: e,
        );

      case DioExceptionType.connectionError:
        return AppError(
          message: 'Network connection error',
          errorCode: AppErrorType.network.code,
          originalError: e,
        );

      default:
      // 检查是否包裹了 SocketException
        if (e.error is SocketException) {
          return AppError(
            message: 'No Internet Connection',
            errorCode: AppErrorType.socket.code,
            originalError: e.error,
          );
        }
        return AppError(
          message: 'Unexpected network error: ${e.type.name}',
          errorCode: AppErrorType.unknown.code,
          originalError: e,
        );
    }
  }

  @override
  String toString() => 'AppError(code: $errorCode, message: $message)';
}