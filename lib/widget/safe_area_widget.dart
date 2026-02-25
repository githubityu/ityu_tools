import 'package:flutter/material.dart';

/// 底部安全区适配器
class BottomSafeWrapper extends StatelessWidget {
  const BottomSafeWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    this.isSliver = false,
  });

  final Widget child;

  /// 底部填充区域的背景色
  final Color? backgroundColor;

  /// 是否作为 Sliver 使用
  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    // 获取底部安全区高度
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;

    if (isSliver) {
      return SliverToBoxAdapter(child: _buildContent(bottomPadding));
    }
    return _buildContent(bottomPadding);
  }

  Widget _buildContent(double bottomPadding) {
    return Container(
      // 如果没有背景色，则使用透明
      color: backgroundColor ?? Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: child,
      ),
    );
  }
}

/// 增加 Context 扩展，让代码更简洁
extension BottomSafeExt on Widget {
  /// 快速适配底部安全区
  Widget toSafeBottom({Color? backgroundColor}) => BottomSafeWrapper(
    backgroundColor: backgroundColor,
    child: this,
  );
}