import 'package:flutter/material.dart';
import 'cache_image.dart';

/// 带圆角的容器，支持点击水波纹、阴影、外边距
class RoundWidget extends StatelessWidget {
  const RoundWidget({
    super.key,
    this.radius = 8.0,
    this.child,
    this.color,
    this.margin,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.onTap,
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
    final theme = Theme.of(context);
    final bgColor = color ?? theme.cardColor;

    return Card(
      margin: margin,
      elevation: elevation,
      clipBehavior: Clip.antiAlias, // 确保水波纹和内容都被切割
      color: bgColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: InkWell(
        // 🌟 核心：将 InkWell 放在 Card 内部，水波纹才会渲染在背景色之上
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// 圆角图片封装
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
      radius: radius,
      borderRadius: borderRadius,
    );
  }
}

/// 圆形图片封装 (常用于头像)
class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    required this.path,
    required this.size,
    this.fit = BoxFit.cover,
    this.errorIcon,
  });

  final String? path;
  final double size;
  final BoxFit fit;
  final IconData? errorIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CacheImage(
      path: path,
      width: size,
      height: size,
      fit: fit,
      isCircle: true,
      // 针对头像设计的错误占位
      errorWidget: Container(
        color: theme.colorScheme.surfaceVariant,
        child: Icon(
          errorIcon ?? Icons.person,
          color: theme.colorScheme.primary,
          size: size * 0.6,
        ),
      ),
    );
  }
}