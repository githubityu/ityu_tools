import 'package:flutter/material.dart';

/// 专门用于单列表 (ListView) 的分页加载组件
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(title: Text("Notice List")),
///     body: SliverListLoadMore(
///       itemCount: _items.length,
///       hasMore: _hasMore,
///       onRefresh: _onRefresh,
///       onLoadMore: _onLoadMore,
///       // 像 ListView.separated 一样加分割线
///       separatorBuilder: (context, index) => Divider(),
///       itemBuilder: (context, index) => ListTile(title: Text("Message $index")),
///     ),
///   );
/// }
class SliverListLoadMore extends StatelessWidget {
  const SliverListLoadMore({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = false,
    this.padding = EdgeInsets.zero,
    this.headerSlivers,
    this.controller,
    this.separatorBuilder, // 可选：支持分割线
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final RefreshCallback? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final EdgeInsetsGeometry padding;
  final List<Widget>? headerSlivers;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = [
      if (headerSlivers != null) ...headerSlivers!,
      SliverPadding(
        padding: padding,
        sliver: separatorBuilder != null
            ? SliverList.separated(
          itemBuilder: itemBuilder,
          separatorBuilder: separatorBuilder!,
          itemCount: itemCount,
        )
            : SliverList.builder(
          itemBuilder: itemBuilder,
          itemCount: itemCount,
        ),
      ),
      SliverToBoxAdapter(child: _buildFooter()),
    ];

    Widget current = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
          if (hasMore && onLoadMore != null) onLoadMore!();
        }
        return false;
      },
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: slivers,
      ),
    );

    if (onRefresh != null) {
      current = RefreshIndicator(onRefresh: onRefresh!, child: current);
    }
    return current;
  }

  Widget _buildFooter() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: hasMore
          ? const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 10),
          Text("Loading...", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      )
          : (itemCount > 0
          ? const Text("—— No more data ——", style: TextStyle(color: Colors.grey, fontSize: 13))
          : const SizedBox.shrink()),
    );
  }
}