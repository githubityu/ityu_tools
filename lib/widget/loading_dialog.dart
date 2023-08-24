import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LoadingStateViewModelDialog {
  Future<T?> whileLoading<T>(Future<T?> Function() future,
      {Function(dynamic)? onError}) {
    final future2 = Future.microtask(toLoading).then((_) => future());
    if (onError != null) {
      future2.catchError((err) {
        throw err;
      });
    }
    future2.whenComplete(toIdle);
    return future2;
  }

  void toLoading() {
    LoadingUtils.showLoading();
  }

  void toIdle() {
    LoadingUtils.dismiss();
  }
}

class LoadingUtils {
  static void showLoading() {
    SmartDialog.showLoading();
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }
}