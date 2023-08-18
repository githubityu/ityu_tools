import 'package:flutter/material.dart';

typedef LoadMoreCallback = Future<void> Function();
/// 封装下拉刷新与加载更多
class LoadMoreChild extends StatefulWidget {
  const LoadMoreChild({
    Key? key,
    required this.child,
    this.loadMore,
    this.hasMore = false,
  }) : super(key: key);
  final LoadMoreCallback? loadMore;
  final bool hasMore;
  final Widget child;

  @override
  State<LoadMoreChild> createState() => _LoadMoreChildState();
}

class _LoadMoreChildState extends State<LoadMoreChild> {
  bool isLoading = false;

  Future<void> loadMoreFunc() async {
    if (widget.loadMore == null) {
      return;
    }
    if (isLoading) {
      return;
    }
    if (!widget.hasMore) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await widget.loadMore?.call();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification note) {
        /// 确保是垂直方向滚动，且滑动至底部
        final metrics = note.metrics;
        if (metrics.pixels == metrics.maxScrollExtent &&
            metrics.axis == Axis.vertical &&
            metrics.atEdge) {
          loadMoreFunc();
        }
        return false;
      },
      child: Builder(
        builder: (context) {
          final list = [
            Expanded(child: widget.child),
            Visibility(
              visible: isLoading,
              child: const FooterListWidget(),
            ),
          ];
          return Column(
            children: list,
          );
        },
      ),
    );
  }
}

class FooterListWidget extends StatelessWidget {
  const FooterListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
          SizedBox(width: 10),
          Text('loading')
        ],
      ),
    );
  }
}

