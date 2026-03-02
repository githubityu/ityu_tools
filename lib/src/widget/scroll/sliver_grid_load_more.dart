import 'package:flutter/material.dart';

import 'load_more_wrapper.dart';

///SliverGridLoadMore(
///   onRefresh: _onRefresh,
///   onLoadMore: _onLoadMore,
///   hasMore: _hasMore,
///   itemCount: _dataList.length,
///   // 像普通 GridView 一样配置
///   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2,
///     mainAxisSpacing: 10,
///     crossAxisSpacing: 10,
///   ),
///   padding: const EdgeInsets.all(10),
///   // 可选：添加一个吸顶的 AppBar
///   headerSlivers: [
///     const SliverAppBar(title: Text("Shop List"), pinned: true),
///   ],
///   itemBuilder: (context, index) {
///     return Card(child: Center(child: Text("Product $index")));
///   },
/// )
///

class SliverGridLoadMore extends StatelessWidget {
  const SliverGridLoadMore({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = false,
    this.padding = EdgeInsets.zero,
    this.headerSlivers, // 支持外部传入额外的 Header (比如 SliverAppBar)
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final RefreshCallback? onRefresh;
  final LoadMoreCallback? onLoadMore;
  final bool hasMore;
  final EdgeInsetsGeometry padding;
  final List<Widget>? headerSlivers;

  @override
  Widget build(BuildContext context) {
    // 1. 组合所有的 Sliver
    List<Widget> slivers = [];

    // 添加外部传入的 Header (如 SliverAppBar)
    if (headerSlivers != null) {
      slivers.addAll(headerSlivers!);
    }

    // 添加 Grid 内容
    slivers.add(
      SliverPadding(
        padding: padding,
        sliver: SliverGrid(
          gridDelegate: gridDelegate,
          delegate: SliverChildBuilderDelegate(
            itemBuilder,
            childCount: itemCount,
          ),
        ),
      ),
    );

    // 添加 Footer (关键点：使用 SliverToBoxAdapter)
    slivers.add(
      SliverToBoxAdapter(
        child: _buildFooter(),
      ),
    );

    // 2. 包装滚动监听
    Widget current = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
          if (hasMore && onLoadMore != null) {
            onLoadMore!();
          }
        }
        return false;
      },
      child: CustomScrollView(
        // 必须设置，否则内容少时无法下拉刷新
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: slivers,
      ),
    );

    // 3. 包装下拉刷新
    if (onRefresh != null) {
      current = RefreshIndicator(
        onRefresh: onRefresh!,
        child: current,
      );
    }

    return current;
  }

  Widget _buildFooter() {
    if (!hasMore && itemCount > 0) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("—— No more data ——", style: TextStyle(color: Colors.grey))),
      );
    }
    if (hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 10),
              Text("Loading...", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}