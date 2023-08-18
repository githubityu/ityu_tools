import 'package:flutter/material.dart';

class StickyChildDelegate extends SliverPersistentHeaderDelegate {

  StickyChildDelegate({required this.child, this.padding = EdgeInsets.zero,this.color});
  final PreferredSizeWidget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
