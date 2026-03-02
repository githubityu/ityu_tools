import 'package:flutter/material.dart';


///  Widget buildList() {
///   return RefreshNestedWrapper(
///     onRefresh: _handleRefresh,
///     headerSliverBuilder: (context, innerBoxIsScrolled) => [
///       const SliverAppBar(title: Text("My Tools"), pinned: true),
///     ],
///     body: LoadMoreWrapper(
///       hasMore: _hasMore,
///       onLoadMore: _handleLoadMore,
///       child: ListView.builder(
///         // 关键：NestedScrollView 的 body 必须能够接收滑动通知
///         physics: const AlwaysScrollableScrollPhysics(),
///         itemCount: _items.length,
///         itemBuilder: (context, index) => ListTile(title: Text("Item ${index}")),
///       ),
///     ),
///   );
/// }
class RefreshNestedWrapper extends StatelessWidget {
  const RefreshNestedWrapper({
    super.key,
    required this.headerSliverBuilder,
    required this.body,
    this.onRefresh,
    this.controller,
  });

  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final Widget body;
  final RefreshCallback? onRefresh;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    // 必须确保内部的每一个列表都有 AlwaysScrollableScrollPhysics
    // 否则当内容不足一屏时，下拉刷新将无法触发
    Widget current = NestedScrollView(
      controller: controller,
      headerSliverBuilder: headerSliverBuilder,
      // 使用自动处理 Overlap 的逻辑，解决内部列表滑动不到顶的问题
      body: Builder(builder: (context) {
        return body;
      }),
    );

    if (onRefresh != null) {
      current = RefreshIndicator(
        onRefresh: onRefresh!,
        // 关键：解决 NestedScrollView 嵌套时的通知冒泡问题
        notificationPredicate: (notification) {
          return notification.depth == 0;
        },
        child: current,
      );
    }

    return current;
  }
}