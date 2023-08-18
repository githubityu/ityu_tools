import 'dart:developer' as dev show log;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

extension ObjectExt on Object? {
  void log([dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Logger().e(toString(), error);
    }
  }

  void devLog() {
    dev.log(toString());
  }
}

class ErrorLogger {
  void logError([dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      Logger().e(toString(), error, stackTrace);
    }
  }

  void devLog() {
    dev.log(toString());
  }

  void registerErrorHandlers() {
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logError(details.exception, details.stack);
    };
    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logError(error, stack);
      return true;
    };
    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }
}
