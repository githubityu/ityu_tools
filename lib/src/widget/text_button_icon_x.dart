import 'package:flutter/material.dart';

/// 统筹处理按钮内部的 [图标 + 间距 + 文字]
class ButtonContentX extends StatelessWidget {
  const ButtonContentX({
    super.key,
    required this.icon,
    this.label,
    this.direction = Axis.horizontal,
    this.isPre = true,
    this.gap = 8.0,
    this.mainAxisSize = MainAxisSize.min,
  });

  final Widget icon;
  final Widget? label;
  final Axis direction;
  final bool isPre;
  final double gap;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final Widget spacer = direction == Axis.horizontal
        ? SizedBox(width: gap)
        : SizedBox(height: gap);

    if (label == null) {
      return icon;
    }

    if (isPre) {
      children.addAll([icon, spacer, label!]);
    } else {
      children.addAll([label!, spacer, icon]);
    }

    return Flex(
      direction: direction,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}


class TextButtonX extends StatelessWidget {
  const TextButtonX({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.onLongPress,
    this.style,
    this.direction = Axis.horizontal,
    this.isPre = true,
    this.gap = 8.0,
    this.mainAxisSize = MainAxisSize.min,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final Widget icon;
  final Widget? label;
  final Axis direction;
  final bool isPre;
  final double gap;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    // 处理 M3 时代的文本缩放适配
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

    // 这里的 padding 计算逻辑可以根据业务需求简化
    final ButtonStyle defaultStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: 8 * textScaleFactor,
        vertical: 4 * textScaleFactor,
      ),
    );

    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: defaultStyle.merge(style),
      child: ButtonContentX(
        icon: icon,
        label: label,
        direction: direction,
        isPre: isPre,
        gap: gap,
        mainAxisSize: mainAxisSize,
      ),
    );
  }
}

/// 同理可快速实现 OutlinedButtonX
class OutlinedButtonX extends StatelessWidget {
  const OutlinedButtonX({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.onLongPress,
    this.style,
    this.direction = Axis.horizontal,
    this.isPre = true,
    this.gap = 8.0,
    this.mainAxisSize = MainAxisSize.min,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final Widget icon;
  final Widget? label;
  final Axis direction;
  final bool isPre;
  final double gap;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    // 适配 M3 的文本缩放
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

    // 设置 OutlinedButton 的默认间距（通常比 TextButton 略大一点）
    final ButtonStyle defaultStyle = OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * textScaleFactor,
        vertical: 8 * textScaleFactor,
      ),
    );

    return OutlinedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      // 合并用户传入的自定义样式
      style: defaultStyle.merge(style),
      child: ButtonContentX(
        icon: icon,
        label: label,
        direction: direction,
        isPre: isPre,
        gap: gap,
        mainAxisSize: mainAxisSize,
      ),
    );
  }
}