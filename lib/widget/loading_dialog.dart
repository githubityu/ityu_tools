import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';



class LoadingUtils {
  const LoadingUtils._();

  /// 显示加载中
  static void show([String? msg]) {
    SmartDialog.showLoading(msg: msg ?? 'Loading...');
  }

  /// 隐藏加载中
  static void dismiss() {
    // 指定 status 为 loading，避免误关其他 Dialog
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  /// 包装一个 Future 任务，自动处理加载状态
  static Future<T?> run<T>(
      Future<T> Function() task, {
        String? msg,
        void Function(dynamic error)? onError,
      }) async {
    show(msg);
    try {
      return await task();
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
      rethrow; // 继续抛出异常，让调用者感知
    } finally {
      dismiss();
    }
  }
}

mixin LoadingMixin {
  /// 在 ViewModel 中直接使用：await runLoading(() => api.getData());
  Future<T?> runLoading<T>(
      Future<T> Function() task, {
        String? msg,
        void Function(dynamic error)? onError,
      }) {
    return LoadingUtils.run<T>(task, msg: msg, onError: onError);
  }
}