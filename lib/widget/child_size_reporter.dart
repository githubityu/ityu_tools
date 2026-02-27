import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


/// 尺寸汇报器：测量子组件高度并回调给父组件
/// double _appBarHeight = 200; // 默认高度
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: CustomScrollView(
///       slivers: [
///         SliverAppBar(
///           expandedHeight: _appBarHeight,
///           flexibleSpace: FlexibleSpaceBar(
///             background: ChildSizeReporter(
///               onHeightChanged: (h) => setState(() => _appBarHeight = h),
///               child: Column(
///                 children: [
///                   Text("Dynamic Content..."),
///                   Image.network("..."),
///                 ],
///               ),
///             ),
///           ),
///         ),
///       ],
///     ),
///   );
/// }
class ChildSizeReporter extends StatefulWidget {
  final Widget child;
  final Function(double height) onHeightChanged;

  const ChildSizeReporter({
    super.key,
    required this.child,
    required this.onHeightChanged,
  });

  @override
  State<ChildSizeReporter> createState() => _ChildSizeReporterState();
}

class _ChildSizeReporterState extends State<ChildSizeReporter> {
  final GlobalKey _heightKey = GlobalKey();
  double _lastHeight = 0;

  @override
  void initState() {
    super.initState();
    // 初始帧结束后测量
    _measure();
  }

  @override
  void didUpdateWidget(covariant ChildSizeReporter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 组件更新后重新测量（防止子组件内容变化但高度没报上去）
    _measure();
  }

  void _measure() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final context = _heightKey.currentContext;
      if (context == null) return;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final newHeight = renderBox.size.height;
        // 只有高度发生变化时才回调，避免重复触发父组件 setState
        if (_lastHeight != newHeight) {
          _lastHeight = newHeight;
          widget.onHeightChanged(newHeight);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 移除原有的 Column + Spacer，保持子组件原始布局，由外部决定如何放置
    return Container(
      key: _heightKey,
      child: widget.child,
    );
  }
}