import 'package:flutter/material.dart';

/// 自定义 TabBar 指示器
/// 支持固定宽度 [width] 和圆角 [borderRadius]
class CustomTabIndicator extends Decoration {
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;

  /// 指示器的固定宽度。如果为 null，则跟随 Tab 宽度
  final double? width;

  /// 指示器的圆角
  final BorderRadius? borderRadius;

  const CustomTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width,
    this.borderRadius,
  });

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CustomTabIndicator) {
      return CustomTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
        width: t < 0.5 ? a.width : width,
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is CustomTabIndicator) {
      return CustomTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
        width: t < 0.5 ? width : b.width,
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomUnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    // 如果设置了固定宽度
    if (width != null) {
      final double center = (indicator.left + indicator.right) / 2;
      return Rect.fromLTWH(
        center - width! / 2,
        indicator.bottom - borderSide.width,
        width!,
        borderSide.width,
      );
    }

    // 默认宽度
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }
}

class _CustomUnderlinePainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomUnderlinePainter(this.decoration, super.onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & (configuration.size ?? Size.zero);
    final TextDirection textDirection = configuration.textDirection ?? TextDirection.ltr;

    final Rect indicator = decoration._indicatorRectFor(rect, textDirection);
    final Paint paint = decoration.borderSide.toPaint();

    if (decoration.borderRadius != null && decoration.borderRadius != BorderRadius.zero) {
      // 使用 RRect 绘制圆角矩形，比 drawLine 更灵活
      canvas.drawRRect(
        decoration.borderRadius!.toRRect(indicator),
        paint,
      );
    } else {
      // 绘制普通矩形
      canvas.drawRect(indicator, paint);
    }
  }
}