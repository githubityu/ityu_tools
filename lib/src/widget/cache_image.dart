import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 统一的图片缓存与加载组件
class CacheImage extends StatelessWidget {
  const CacheImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
    this.borderRadius,
    this.radius,
    this.isCircle = false,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final Widget? placeholder;
  final bool isCircle;
  final double? radius;
  final BorderRadius? borderRadius;

  /// 内存缓存优化：设置此值可以减少大图占用的内存
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    // 🌟 1. 处理路径为空或本地资源的情况
    if (path == null || path!.isEmpty) {
      return _buildErrorPlaceholder();
    }

    if (path!.startsWith('assets/')) {
      return Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(radius ?? 0)),
        ),
        child: Image.asset(path!, fit: fit),
      );
    }

    // 🌟 2. 内存优化逻辑：如果是圆型（通常是头像），默认强制限制缓存大小防止 OOM
    final int? effectiveMemWidth = memCacheWidth ?? (isCircle && width != null ? (width! * 2).toInt() : null);

    return CachedNetworkImage(
      imageUrl: path!,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: effectiveMemWidth,
      memCacheHeight: memCacheHeight,

      // 使用 imageBuilder 实现高性能圆角渲染
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : (borderRadius ?? (radius != null ? BorderRadius.circular(radius!) : null)),
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),

      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorPlaceholder(),

      placeholderFadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : (borderRadius ?? (radius != null ? BorderRadius.circular(radius!) : null)),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : (borderRadius ?? (radius != null ? BorderRadius.circular(radius!) : null)),
      ),
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 20),
    );
  }
}