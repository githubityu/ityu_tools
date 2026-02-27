import 'package:flutter/material.dart';

/// 统一样式的加载按钮
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false, // 也支持外部控制加载状态
    this.width,
    this.height = 48.0,
    this.style,
    this.isFullWidth = false,
    this.useFilledButton = true, // 默认使用 M3 的 FilledButton
  });

  final Future<void> Function()? onPressed;
  final String text;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final bool isFullWidth;
  final bool useFilledButton;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _internalLoading = false;

  bool get _effectiveLoading => _internalLoading || widget.isLoading;

  @override
  Widget build(BuildContext context) {
    // 决定按钮类型
    final Widget child = _buildContent();

    // 构建基础按钮
    final button = widget.useFilledButton
        ? FilledButton(
      style: widget.style,
      onPressed: _onPressed,
      child: child,
    )
        : ElevatedButton(
      style: widget.style,
      onPressed: _onPressed,
      child: child,
    );

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : widget.width,
      height: widget.height,
      child: button,
    );
  }

  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _effectiveLoading
          ? const SizedBox(
        key: ValueKey('loading'),
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white, // 建议使用 Theme.of(context).colorScheme.onPrimary
        ),
      )
          : Row(
        key: const ValueKey('content'),
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: 8),
          ],
          Text(widget.text),
        ],
      ),
    );
  }

  void _onPressed() async {
    if (_effectiveLoading || widget.onPressed == null) return;

    setState(() => _internalLoading = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _internalLoading = false);
      }
    }
  }
}