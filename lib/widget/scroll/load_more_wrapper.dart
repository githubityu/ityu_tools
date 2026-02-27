import 'package:flutter/material.dart';

/// 底部加载状态
enum LoadMoreStatus { loading, idle, noMore, fail }

typedef LoadMoreCallback = Future<void> Function();

class LoadMoreWrapper extends StatefulWidget {
  const LoadMoreWrapper({
    super.key,
    required this.child,
    this.onLoadMore,
    this.hasMore = false,
    this.showNoMoreTips = true,
  });

  final Widget child;
  final LoadMoreCallback? onLoadMore;
  final bool hasMore;
  final bool showNoMoreTips;

  @override
  State<LoadMoreWrapper> createState() => _LoadMoreWrapperState();
}

class _LoadMoreWrapperState extends State<LoadMoreWrapper> {
  bool _isLoading = false;

  Future<void> _handleLoadMore() async {
    if (_isLoading || !widget.hasMore || widget.onLoadMore == null) return;

    setState(() => _isLoading = true);
    await widget.onLoadMore!();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // 距离底部还有 100 像素时就开始加载，提升用户体验
        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
          _handleLoadMore();
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(child: widget.child),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    if (_isLoading) {
      return const _FooterWidget(status: LoadMoreStatus.loading);
    }
    if (!widget.hasMore && widget.showNoMoreTips) {
      return const _FooterWidget(status: LoadMoreStatus.noMore);
    }
    return const SizedBox.shrink();
  }
}

class _FooterWidget extends StatelessWidget {
  final LoadMoreStatus status;
  const _FooterWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: switch (status) {
        LoadMoreStatus.loading => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Loading...', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        LoadMoreStatus.noMore => const Text(
          '—— No more data ——',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}