import 'dart:async';
import 'package:flutter/material.dart';

/// 倒计时组件
class CountDownTime extends StatefulWidget {
  const CountDownTime({
    super.key,
    required this.seconds,
    this.preStr = '',
    this.onDone,
    this.style,
  });

  /// 倒计时总秒数
  final int seconds;

  /// 前缀字符串
  final String preStr;

  /// 样式
  final TextStyle? style;

  /// 倒计时结束回调
  final VoidCallback? onDone;

  @override
  State<CountDownTime> createState() => _CountDownTimeState();
}

class _CountDownTimeState extends State<CountDownTime> {
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  void _initTimer() {
    // 创建流：每秒发出一个值
    _timerStream = Stream.periodic(const Duration(seconds: 1), (i) => i)
        .take(widget.seconds + 1); // +1 是为了包含 0
  }

  @override
  void didUpdateWidget(CountDownTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果秒数发生变化，重新初始化定时器
    if (oldWidget.seconds != widget.seconds) {
      _initTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (context, snapshot) {
        // 当流完成时（倒计时结束）
        if (snapshot.connectionState == ConnectionState.done) {
          // 使用 addPostFrameCallback 确保在当前帧绘制完成后触发回调，避免 build 冲突
          if (widget.onDone != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onDone?.call();
            });
          }
          return const SizedBox.shrink(); // 结束后隐藏或返回空
        }

        // 计算剩余秒数
        final int currentEvent = snapshot.data ?? 0;
        final int remaining = widget.seconds - currentEvent;

        // 如果没有数据（还没开始），显示初始值
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return Text('${widget.preStr}${_formatTime(widget.seconds)}', style: widget.style);
        }

        return Text(
          '${widget.preStr}${_formatTime(remaining)}',
          style: widget.style,
        );
      },
    );
  }

  /// 格式化时间逻辑（建议使用之前 Utils 里的逻辑，这里提供一个简洁版）
  String _formatTime(int totalSeconds) {
    if (totalSeconds <= 0) return "00:00";
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}