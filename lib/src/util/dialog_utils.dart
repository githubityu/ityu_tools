import 'dart:async';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LoadingUtils {
  const LoadingUtils._();

  // 🌟 优化 1：引用计数锁，防止并发请求时互相干扰
  static int _loadingCount = 0;

  static void show([String? msg]) {
    _loadingCount++;
    // 只有第一个请求发起时，才真正呼出 UI 弹窗
    if (_loadingCount == 1) {
      SmartDialog.showLoading(msg: msg ?? '加载中...');
    }
  }

  static void dismiss() {
    if (_loadingCount > 0) {
      _loadingCount--;
    }
    // 只有所有请求都结束时，才真正关闭 UI 弹窗
    if (_loadingCount == 0) {
      SmartDialog.dismiss(status: SmartStatus.loading); // 去掉 force: true
    }
  }

  /// 包装一个 Future 任务，处理 Loading 的开启和关闭
  static Future<T?> run<T>(Future<T> Function() task, {String? msg}) async {
    // 🌟 优化 2：解决“闪屏”问题。记录开始时间
    final startTime = DateTime.now();

    show(msg);
    try {
      return await task();
    } catch (e) {
      rethrow;
    } finally {
      // 🌟 计算耗时，如果接口太快（< 300ms），强制等够 300ms 再关闭
      // 保证 Loading 动画至少能流畅地转半圈，彻底消灭闪烁感
      final duration = DateTime.now().difference(startTime);
      if (duration.inMilliseconds < 300) {
        await Future.delayed(Duration(milliseconds: 300 - duration.inMilliseconds));
      }
      dismiss();
    }
  }

  /// 万一出现异常导致计数器死锁，提供一个终极重置方法（可以在路由跳转时调用）
  static void forceDismissAll() {
    _loadingCount = 0;
    SmartDialog.dismiss(status: SmartStatus.loading, force: true);
  }
}

// 💡 建议：在 Riverpod 架构下，Mixin 其实用得很少。
// 因为我们上一节已经写了 WidgetRefLoadingExt，大多数时候都在 UI 层直接调 ref.runLoadingTask
// 纯业务类里直接调 LoadingUtils.run 即可，这个 Mixin 可以选择性保留或删除。
mixin LoadingMixin {
  Future<T?> runLoading<T>(Future<T> Function() task, {String? msg}) {
    return LoadingUtils.run<T>(task, msg: msg);
  }
}