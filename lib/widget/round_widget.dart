import 'package:flutter/material.dart';

import 'cache_image.dart';

class RoundWidget extends StatelessWidget {
  const RoundWidget({
    super.key,
    this.radius = 8.0,
    this.child,
    this.color,
    this.margin,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.onTap, // 增加点击支持
  });

  final double radius;
  final Widget? child;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 自动适配主题颜色，如果未传 color，则使用主题的 cardColor
    final theme = Theme.of(context);
    final bgColor = color ?? theme.cardColor;

    Widget current = Card(
      margin: margin,
      elevation: elevation,
      clipBehavior: Clip.antiAlias, // 确保子组件不会超出圆角
      color: bgColor,
      // 在 Material 3 中，surfaceTintColor 会导致颜色偏移，这里设为透明或匹配背景
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    // 如果有点击事件，包装一层 InkWell
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: current,
      );
    }

    return current;
  }
}

class RoundImage extends StatelessWidget {
  const RoundImage({
    super.key,
    required this.path,
    this.radius = 8.0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String path;
  final double radius;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CacheImage(
      path: path,
      width: width,
      height: height,
      fit: fit,
      // 直接复用 CacheImage 已经做好的圆角逻辑
      radius: radius,
      borderRadius: borderRadius,
    );
  }
}

class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    required this.path,
    required this.size, // 使用 size 替代原来的 radius*2 更直观
    this.fit = BoxFit.cover,
  });

  final String? path;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CacheImage(
      path: path,
      width: size,
      height: size,
      fit: fit,
      isCircle: true,
      // 错误图显示默认占位图标
      errorWidget: Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.person,
          color: theme.colorScheme.primary,
          size: size * 0.6,
        ),
      ),
    );
  }
}