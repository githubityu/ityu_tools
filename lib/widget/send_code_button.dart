
import 'dart:async';

import 'package:flutter/material.dart';

class SendCodeButton extends StatefulWidget {
  const SendCodeButton(
      this.getVCode, {
        this.isStart = false,
        super.key,
        required this.builder,
      });

  final Future<bool?> Function()? getVCode;
  final bool isStart;
  final Widget Function(String, VoidCallback?) builder;

  @override
  State<SendCodeButton> createState() => _SendCodeButtonState();
}

class _SendCodeButtonState extends State<SendCodeButton> {
  /// 倒计时总秒数
  static const int _totalSeconds = 60;

  /// 用于管理倒计时的 StreamSubscription
  StreamSubscription<int>? _countdownSubscription;

  /// 按钮状态，-1 表示初始状态，0 表示倒计时中，1 表示可重新发送
  int _buttonState = -1;

  /// 当前剩余倒计时秒数
  int _remainingSeconds = _totalSeconds;

  /// 根据按钮状态生成显示文本
  String _getButtonText() {
    switch (_buttonState) {
      case -1:
        return '发送';
      case 1:
        return '重新发送';
      default:
        return '（$_remainingSeconds s）';
    }
  }

  /// 获取验证码并启动倒计时
  Future<void> _fetchVerificationCode({bool shouldCallApi = true}) async {
    try {
      final bool? isSuccess = shouldCallApi ? await widget.getVCode?.call() : true;

      if (isSuccess == true) {
        _startCountdown();
      }
    } catch (error) {
      print('Error fetching verification code: $error');
    }
  }

  /// 启动倒计时
  void _startCountdown() {
    _remainingSeconds = _totalSeconds;
    _buttonState = 0;
    _countdownSubscription?.cancel();

    _countdownSubscription = Stream.periodic(
      const Duration(seconds: 1),
          (int count) => count,
    ).take(_totalSeconds).listen((int count) {
      setState(() {
        _remainingSeconds = _totalSeconds - count - 1;
        _buttonState = _remainingSeconds < 1 ? 1 : 0;
      });
    });
  }

  /// 按钮点击回调
  VoidCallback? get _onButtonPressed =>
      _buttonState == -1 || _buttonState == 1 ? _fetchVerificationCode : null;

  @override
  void initState() {
    super.initState();
    if (widget.isStart) {
      _fetchVerificationCode(shouldCallApi: false);
    }
  }

  @override
  void dispose() {
    _countdownSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_getButtonText(), _onButtonPressed);
  }
}
