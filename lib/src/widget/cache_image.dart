import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 统一的图片缓存组件
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

  /// 内存缓存优化：设置此值可以减少大图占用的内存（建议设为 UI 宽度的 2~3 倍像素）
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return _buildErrorPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: path!,
      width: width,
      height: height,
      fit: fit,
      // 内存优化属性
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,

      // 构建样式
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

      // 占位图
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),

      // 错误图
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorPlaceholder(),

      // 淡入动画
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 500),
    );
  }

  /// 默认占位图（灰色块）
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

  /// 默认错误占位
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