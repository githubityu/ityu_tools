import 'package:flutter/material.dart';

/// 统筹处理 图标 + 文字 的布局组件
class TextIconX extends StatelessWidget {
  const TextIconX({
    super.key,
    required this.icon,
    this.text,
    this.textWidget,
    this.axis = Axis.horizontal,
    this.isPre = true,
    this.space = 8.0,
    this.isExpand = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.textStyle,
  });

  final Widget icon;
  final String? text;

  /// 如果想传复杂的 Text 组件（比如带 Span），可以使用这个
  final Widget? textWidget;

  final Axis axis;
  /// 图标是否在文字之前
  final bool isPre;
  final double space;
  final bool isExpand;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // 1. 构建文字组件
    Widget label = textWidget ?? Text(
      text ?? '',
      style: textStyle,
    );

    // 2. 如果需要扩展，包装一层 Expanded
    if (isExpand) {
      label = Expanded(child: label);
    }

    // 3. 确定排列顺序
    final List<Widget> children = isPre
        ? [icon, _buildSpace(), label]
        : [label, _buildSpace(), icon];

    return Flex(
      direction: axis,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  /// 快速构建间距
  Widget _buildSpace() {
    return axis == Axis.horizontal
        ? SizedBox(width: space)
        : SizedBox(height: space);
  }
}