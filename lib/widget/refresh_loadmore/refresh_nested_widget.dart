import 'package:flutter/material.dart';

///带有NestedScrollView下来刷新没有加载更多，需要配合loadMore使用
class RefreshNestedWidget extends StatelessWidget {
  const RefreshNestedWidget(
      {required this.child,
      super.key,
      required this.headerSliver,
      this.controller,
      this.onRefresh});
  final NestedScrollViewHeaderSliversBuilder headerSliver;
  final Widget child;
  final RefreshCallback? onRefresh;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    current = NestedScrollView(
      controller: controller,
      headerSliverBuilder: headerSliver,
      body: child,
    );
    if (onRefresh != null) {
      current = RefreshIndicator(
        onRefresh: onRefresh!,
        child: current,
        notificationPredicate: (ScrollNotification notification) {
          if (notification.metrics.minScrollExtent == 0) {
            return true;
          } else {
            return false;
          }
        },
      );
    }
    return current;
  }
}
