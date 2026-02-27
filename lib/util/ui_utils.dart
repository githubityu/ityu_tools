import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../widget/top_alert_bar.dart';

class UiUtils {
  static void showToast(String content) {
    SmartDialog.showToast(content, alignment: Alignment.center);
  }

  static void showSnackBar(BuildContext context, String message, {Color? bgColor}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 获取组件位置和大小 (使用 Dart 3 Records)
  static ({Offset offset, Size size}) getWidgetInfo(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return (offset: box.localToGlobal(Offset.zero), size: box.size);
  }
  static void showTopNotify(String message, {Color? color, IconData? icon}) {
    SmartDialog.show(
      // 1. 设置对齐方式为顶部中心
      alignment: Alignment.topCenter,

      // 2. 设置动画类型：非中间位置会自动识别为位移动画 (Top -> Down)
      animationType: SmartAnimationType.centerFade_otherSlide,

      // 3. 允许点击穿透，这样弹出通知时不影响用户操作下方的 UI
      usePenetrate: true,

      // 4. 设置显示时长
      displayTime: const Duration(seconds: 2),

      builder: (_) => TopAlertBar(
        msg: message,
        backgroundColor: color ?? Colors.green,
        icon: icon ?? Icons.check_circle_outline,
      ),
    );
  }
}