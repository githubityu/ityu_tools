import 'dart:async';
import 'package:flutter/material.dart';

/// 按钮状态
enum SendCodeStatus {
  idle,    // 初始状态
  loading, // 网络请求中
  counting, // 倒计时中
  retry    // 可重新发送
}

///SendCodeButton(
///   onSend: () async {
///     // 模拟接口调用
///     await Future.delayed(const Duration(seconds: 1));
///     return true;
///   },
///   builder: (context, status, seconds, sendAction) {
///     // 根据状态生成文字
///     String label = switch (status) {
///       SendCodeStatus.idle => "发送验证码",
///       SendCodeStatus.loading => "请求中...",
///       SendCodeStatus.counting => "重新发送($seconds s)",
///       SendCodeStatus.retry => "重新发送",
///     };
///
///     return TextButton(
///       onPressed: sendAction, // status 为 counting 或 loading 时，sendAction 为 null，按钮自动变灰
///       child: Text(label),
///     );
///   },
/// )

class SendCodeButton extends StatefulWidget {
  const SendCodeButton({
    super.key,
    required this.onSend,
    required this.builder,
    this.totalSeconds = 60,
    this.initialStart = false,
  });

  /// 发送验证码的回调，返回 true 开始倒计时
  final Future<bool> Function() onSend;

  /// 自定义 UI 构建器
  /// [status] 当前状态
  /// [remainingSeconds] 剩余秒数
  /// [sendAction] 触发发送的方法（会自动根据状态判断是否可点击）
  final Widget Function(
      BuildContext context,
      SendCodeStatus status,
      int remainingSeconds,
      VoidCallback? sendAction,
      ) builder;

  /// 倒计时总秒数
  final int totalSeconds;

  /// 是否初始化后立即开始（通常用于跳转到验证码页时）
  final bool initialStart;

  @override
  State<SendCodeButton> createState() => _SendCodeButtonState();
}

class _SendCodeButtonState extends State<SendCodeButton> {
  Timer? _timer;
  late int _remainingSeconds;
  SendCodeStatus _status = SendCodeStatus.idle;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.totalSeconds;
    if (widget.initialStart) {
      // 如果初始化开始，直接进入倒计时逻辑，不调用接口
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 核心发送逻辑
  Future<void> _handleAction() async {
    if (_status == SendCodeStatus.counting || _status == SendCodeStatus.loading) return;

    setState(() => _status = SendCodeStatus.loading);

    try {
      final isSuccess = await widget.onSend();
      if (isSuccess) {
        _startCountdown();
      } else {
        setState(() => _status = SendCodeStatus.idle);
      }
    } catch (e) {
      debugPrint("SendCodeButton Error: $e");
      if (mounted) setState(() => _status = SendCodeStatus.retry);
    }
  }

  /// 启动倒计时
  void _startCountdown() {
    _timer?.cancel();
    _remainingSeconds = widget.totalSeconds;
    setState(() => _status = SendCodeStatus.counting);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_remainingSeconds > 1) {
          _remainingSeconds--;
        } else {
          _status = SendCodeStatus.retry;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 只有在初始或重试状态下，才提供点击回调
    final VoidCallback? action = (_status == SendCodeStatus.idle || _status == SendCodeStatus.retry)
        ? _handleAction
        : null;

    return widget.builder(context, _status, _remainingSeconds, action);
  }
}