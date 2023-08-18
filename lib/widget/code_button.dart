import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ityu_tools/util/extension/build_context_ext.dart';

/// create at 2022/1/4 15:24
/// by githubityu
/// describe：
///

class CodeButton extends StatefulWidget {
  CodeButton(this.getVCode,
      {this.isStart = false, this.isTransparent = false, Key? key})
      : super(key: key);
  final Future<bool?> Function()? getVCode;
  final bool isStart;
  final bool isTransparent;

  @override
  State<CodeButton> createState() => _CodeButtonState();
}

class _CodeButtonState extends State<CodeButton> {
  /// 倒计时秒数
  final int _second = 30;
  StreamSubscription? _subscription;

  int clickable = -1;
  int currentSecond = 30;

  String buildGetCodeText() {
    if (clickable == -1) {
      return 'Send';
    } else if (clickable == 1) {
      return 'Resend';
    } else {
      return '（$currentSecond s）';
    }
  }

  _getVCode({bool isGo = true}) async {
    final bool? isSuccess = isGo ? (await widget.getVCode!()) : true;
    if (true == isSuccess) {
      currentSecond = _second;
      clickable = 0;
      _subscription = Stream.periodic(const Duration(seconds: 1), (int i) => i)
          .take(_second)
          .listen((int i) {
            setState(() {
              currentSecond = _second - i - 1;
              clickable = currentSecond < 1 ? 1 : 0;
            });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isStart) {
      _getVCode(isGo: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: context.theme.primaryColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledBackgroundColor: Colors.grey[300],
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white),
        onPressed:
        (clickable == -1 || clickable == 1) ? _getVCode : null,
        child: Text(buildGetCodeText()));
  }
}
