import 'package:flutter/material.dart';

/// 通用的图标/组件切换动画
class AnimatedWidgetSwitcher extends StatelessWidget {
  const AnimatedWidgetSwitcher({
    super.key,
    required this.showFirst,
    required this.firstChild,
    required this.secondChild,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.switchInCurve = Curves.easeIn,
    this.switchOutCurve = Curves.easeOut,
  });

  final bool showFirst;
  final Widget firstChild;
  final Widget secondChild;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      // 默认提供一个缩放 + 渐变的过渡效果，比 CrossFade 更生动
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      // 注意：AnimatedSwitcher 识别子组件是否改变是根据 Key
      child: SizedBox(
        key: ValueKey<bool>(showFirst),
        child: showFirst ? firstChild : secondChild,
      ),
    );
  }
}

/// 包装了点击事件的动画图标按钮
class AnimatedIconButton extends StatelessWidget {
  const AnimatedIconButton({
    super.key,
    required this.showFirst,
    required this.firstIcon,
    required this.secondIcon,
    required this.onPressed,
    this.size,
    this.padding = const EdgeInsets.all(8),
    this.color,
    this.tooltip,
  });

  final bool showFirst;
  final Widget firstIcon;
  final Widget secondIcon;
  final VoidCallback? onPressed;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: size,
      padding: padding,
      color: color,
      tooltip: tooltip,
      // 这里的约束可以让图标在切换时保持中心对齐
      constraints: const BoxConstraints(),
      icon: AnimatedWidgetSwitcher(
        showFirst: showFirst,
        firstChild: firstIcon,
        secondChild: secondIcon,
      ),
    );
  }
}