import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  Timer? _timer;

  /// 延迟执行某个函数
  /// [duration] 建议直接传入 Duration 对象，更加灵活
  void run(VoidCallback action, {Duration duration = const Duration(seconds: 2)}) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// 检查当前是否有任务正在等待执行
  bool get isActive => _timer?.isActive ?? false;

  /// 取消当前等待的任务
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}


class CountDownTimer {
  StreamSubscription<int>? _subscription;

  /// 开启一个计时器
  /// [ticks] 总次数
  /// [onTick] 每次间隔的回调，参数为当前剩余次数或已过去次数
  /// [onDone] 完成后的回调
  /// [reverse] 是否开启倒计时模式（默认开启，适合验证码场景）
  void start({
    int ticks = 60,
    Duration interval = const Duration(seconds: 1),
    required void Function(int current) onTick,
    VoidCallback? onDone,
    bool reverse = true,
  }) {
    cancel(); // 开启前先取消旧的

    // Stream.periodic 每隔一段时间产生一个从 0 开始的递增索引
    _subscription = Stream.periodic(interval, (i) => i)
        .take(ticks) // 限制次数
        .listen(
          (i) {
        final value = reverse ? (ticks - i - 1) : i;
        onTick(value);
      },
      onDone: onDone,
      cancelOnError: true,
    );
  }

  /// 取消计时器
  void cancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// 检查是否正在运行
  bool get isRunning => _subscription != null;
}