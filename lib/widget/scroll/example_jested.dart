import 'package:flutter/material.dart';
import 'package:ityu_tools/widget/scroll/refresh_nested_wrapper.dart';

import 'load_more_wrapper.dart';
// 导入你之前封装的组件
// import 'package:your_package/widget/scroll/refresh_nested_wrapper.dart';
// import 'package:your_package/widget/scroll/load_more_wrapper.dart';

class TabBarNestedPage extends StatefulWidget {
  const TabBarNestedPage({super.key});

  @override
  State<TabBarNestedPage> createState() => _TabBarNestedPageState();
}

class _TabBarNestedPageState extends State<TabBarNestedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Product", "Review", "Detail"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  /// 模拟全局刷新逻辑
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint("Page Refreshed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshNestedWrapper(
        onRefresh: _handleRefresh,
        // 1. 构建头部 (SliverAppBar + TabBar)
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text("Store Detail"),
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://picsum.photos/400/200",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. 吸顶 TabBar (使用 SliverPersistentHeader 或直接作为 AppBar 的 bottom)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: _tabs.map((e) => Tab(text: e)).toList(),
              ),
            ),
          ),
        ],
        // 3. 构建 Body (TabBarView)
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabList("Product"),
            _buildTabList("Review"),
            _buildTabList("Detail"),
          ],
        ),
      ),
    );
  }

  /// 构建内部列表
  Widget _buildTabList(String key) {
    return LoadMoreWrapper(
      hasMore: true,
      onLoadMore: () async => await Future.delayed(const Duration(seconds: 1)),
      child: ListView.builder(
        // 【关键点】：NestedScrollView 的 body 内部列表必须能够冒泡滑动通知
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        itemCount: 20,
        itemBuilder: (context, index) => ListTile(
          title: Text("$key Item $index"),
          leading: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}

/// 辅助类：用于让 TabBar 在 Sliver 中吸顶
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 这里的 Container 背景色应与 TabBar 一致，防止滚动时透明
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}