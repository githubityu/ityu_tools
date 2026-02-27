import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';



class LoadingUtils {
  const LoadingUtils._();

  static void show([String? msg]) => SmartDialog.showLoading(msg: msg ?? 'Loading...');
  static void dismiss() => SmartDialog.dismiss(status: SmartStatus.loading, force: true);

  /// 包装一个 Future 任务，只负责 Loading 的开启和关闭
  static Future<T?> run<T>(Future<T> Function() task, {String? msg}) async {
    show(msg);
    try {
      return await task();
    } catch (e) {
      // 💡 这里的职责很简单：只要出错了，我就把球踢给调用者
      rethrow;
    } finally {
      // 💡 无论成败，确保 Loading 关掉
      dismiss();
    }
  }
}

mixin LoadingMixin {
  /// 在 ViewModel 中直接使用：await runLoading(() => api.getData());
  Future<T?> runLoading<T>(
      Future<T> Function() task, {
        String? msg
      }) {
    return LoadingUtils.run<T>(task, msg: msg);
  }
}