import 'package:flutter/material.dart';

/// 懒加载 IndexedStack
/// 只有在索引被激活时才初始化对应的 Widget
class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  });

  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final int index; // 修改为非可选 int，更符合逻辑
  final List<Widget> children;

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  /// 用于记录哪些页面已经被初始化
  late List<bool> _activatedList;

  @override
  void initState() {
    super.initState();
    // 初始化激活状态列表
    _activatedList = List<bool>.generate(
      widget.children.length,
          (i) => i == widget.index,
    );
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1. 处理子组件数量变化的情况 (关键优化)
    if (widget.children.length != _activatedList.length) {
      final newCount = widget.children.length;
      final oldCount = _activatedList.length;
      if (newCount > oldCount) {
        // 如果增加了 Tab，补全激活列表
        _activatedList.addAll(List.filled(newCount - oldCount, false));
      } else {
        // 如果减少了 Tab，截断列表
        _activatedList = _activatedList.sublist(0, newCount);
      }
    }

    // 2. 激活当前选中的索引
    _activateIndex(widget.index);
  }

  void _activateIndex(int index) {
    if (index >= 0 && index < _activatedList.length && !_activatedList[index]) {
      setState(() {
        _activatedList[index] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      index: widget.index,
      // 使用高效的映射逻辑
      children: [
        for (int i = 0; i < widget.children.length; i++)
          _activatedList[i] ? widget.children[i] : const SizedBox.shrink(),
      ],
    );
  }
}