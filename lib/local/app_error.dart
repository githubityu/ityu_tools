import 'dart:io';

import 'package:dio/dio.dart';


const HTTP_NOT_VERIFIED = '100002';

enum ErrorType {
  ErrorType_App(-1),
  ErrorType_Socket(-2),
  ErrorType_Dio(-3),
  ErrorType_Other(-4);

  final int errType;

  const ErrorType(this.errType);
}

class AppError implements Exception {
  AppError(this.message, this.errorCode);

  factory AppError.e(Object exception) {
    if (exception is DioException) {
      final error = exception.error;
      if (error is AppError) {
        return AppError('${error.message}', ErrorType.ErrorType_App.errType);
      } else if (error is SocketException) {
        return AppError('Network Error', ErrorType.ErrorType_Socket.errType);
      } else {
        return AppError(
            exception.type
                .toString()
                .replaceAll('DioError ', '')
                .replaceAll('DioErrorType.', ''),
            ErrorType.ErrorType_Dio.errType);
      }
    }
    return AppError('$exception', ErrorType.ErrorType_Other.errType);
  }

  final String? message;
  final int? errorCode;

  @override
  String toString() {
    return 'AppError{message: $message, errorCode: $errorCode}';
  }
}
