import 'package:flutter/material.dart';

/// 一个通用的 Sliver 吸顶代理
class SliverStickyDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  /// 如果 child 是 PreferredSizeWidget (如 TabBar)，高度会自动获取
  SliverStickyDelegate({
    required this.child,
    double? height,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
  }) : height = height ?? (child is PreferredSizeWidget ? (child).preferredSize.height : 0.0) {
    assert(this.height > 0, "必须提供高度或使用 PreferredSizeWidget");
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 使用 Material 包装可以更好地处理背景色和阴影
    return Material(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: padding,
        child: SizedBox.expand(child: child),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverStickyDelegate oldDelegate) {
    // 只有当核心属性变化时才触发重绘，提升性能
    return oldDelegate.child != child ||
        oldDelegate.height != height ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.padding != padding;
  }
}