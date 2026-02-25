import 'package:flutter/material.dart';

/// 当键盘弹出时自动隐藏子组件
class AutoHideByKeyboard extends StatelessWidget {
  final Widget child;

  /// 动画持续时间
  final Duration duration;

  const AutoHideByKeyboard({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    // 1. 获取键盘底部高度 (viewInsets.bottom)
    // 使用 viewInsetsOf 是 Flutter 3.10+ 的性能优化写法
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    // 2. 判断键盘是否开启
    final bool isKeyboardVisible = keyboardHeight > 0;

    // 3. 使用动画切换状态，比直接用 Visibility 体验更好
    return AnimatedOpacity(
      duration: duration,
      opacity: isKeyboardVisible ? 0.0 : 1.0,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: duration,
        // 如果隐藏了，让它不占用任何空间
        height: isKeyboardVisible ? 0 : null,
        child: IgnorePointer(
          ignoring: isKeyboardVisible,
          child: child,
        ),
      ),
    );
  }
}