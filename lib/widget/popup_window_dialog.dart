import 'package:flutter/material.dart';
import 'package:ityu_tools/exports.dart';

///
/// use
///     final result = await showDialog(
///               context: context,
///                builder: (_) => PopupWindowDialog(
///                      targetContext: context,
///                      vn: vn,
///                      child: InkWell(
///                        child: Text("===="),
///                        onTap: () {
///                          vn.value = 1;
///                        },
///                      ),
///                    ),
///                barrierColor: Colors.transparent);
///
///
///

import 'package:flutter/material.dart';
import 'package:ityu_tools/exports.dart';

/// 弹出窗组件，通常显示在点击目标的下方 建议使用下面
/// SmartDialog.showAttach(
///   targetContext: context, // 点击的那个按钮的 context
///   alignment: Alignment.bottomCenter, // 吸附在下方
///   animationType: SmartAnimationType.centerFade_otherSlide,
///   builder: (_) => Container(color: Colors.white, child: Text("内容")),
/// );
class PopupWindowDialog extends StatefulWidget {
  final BuildContext targetContext;
  final Widget child;
  final ValueNotifier vn;
  final Duration duration;
  final Curve curve;

  const PopupWindowDialog({
    super.key,
    required this.targetContext,
    required this.child,
    required this.vn,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<PopupWindowDialog> createState() => _PopupWindowDialogState();
}

class _PopupWindowDialogState extends State<PopupWindowDialog> {
  // 初始位移在上方完全隐藏
  double _offsetY = -1.0;
  late double _top;

  @override
  void initState() {
    super.initState();

    // 计算目标组件在屏幕上的位置
    final info = widget.targetContext.widgetInfo;
    _top = info.offset.dy + info.size.height; // 弹出在目标组件下方

    // 监听外部控制信号
    widget.vn.addListener(_handleVnChange);

    // 入场动画：下一帧开始触发
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _offsetY = 0.0);
      }
    });
  }

  @override
  void dispose() {
    // 关键：移除监听器防止内存泄漏
    widget.vn.removeListener(_handleVnChange);
    super.dispose();
  }

  void _handleVnChange() {
    if (mounted) _close();
  }

  /// 执行关闭动画并退出
  void _close() async {
    if (!mounted) return;

    setState(() => _offsetY = -1.0);

    // 等待动画结束后 pop
    await Future.delayed(widget.duration);

    if (mounted) {
      Navigator.of(context).pop(widget.vn.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 1. 全屏透明遮罩，点击即关闭
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _close,
            child: const SizedBox.expand(),
          ),

          // 2. 目标组件下方的半透明背景（可选）
          Positioned(
            top: _top,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),

          // 3. 动画内容区
          Positioned(
            top: _top,
            left: 0,
            right: 0,
            child: ClipRect( // 确保内容滑动时不会超出顶部界限
              child: AnimatedSlide(
                offset: Offset(0, _offsetY),
                duration: widget.duration,
                curve: widget.curve,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}