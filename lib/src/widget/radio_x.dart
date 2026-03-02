import 'package:flutter/material.dart';

/// 这是一个极致精简的单选框包装
/// 它的唯一任务就是：把 Radio 缩小到 0.7，并去掉多余的点击占位
class RadioX<T> extends StatelessWidget {
  const RadioX({
    super.key,
    required this.value,
    this.scale = 0.7, // 核心增强：保持你最喜欢的 0.7
    this.activeColor,
    this.isAdaptive = true,
  });

  final T value;
  final double scale;
  final Color? activeColor;
  final bool isAdaptive;

  @override
  Widget build(BuildContext context) {
    // 1. 构建基础 Radio
    // 注意：groupValue 和 onChanged 都不传，
    // 因为它们会自动寻找祖先中的 RadioGroup 状态
    final Widget radio = isAdaptive
        ? Radio<T>.adaptive(
      value: value,
      activeColor: activeColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    )
        : Radio<T>(
      value: value,
      activeColor: activeColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    // 2. 缩放并返回
    return Transform.scale(
      scale: scale,
      child: radio,
    );
  }
}