import 'package:flutter/material.dart';

///
/// // 1. 普通水平虚线
/// const DashLine(),
///
/// // 2. 自定义颜色和间距的水平虚线
/// const DashLine(
///   color: Colors.blue,
///   dashWidth: 10,
///   dashSpace: 5,
///   thickness: 2,
/// ),
///
/// // 3. 垂直虚线
/// const SizedBox(
///   height: 100,
///   child: DashLine(direction: Axis.vertical),
/// ),
///
///

class DashLine extends StatelessWidget {
  /// 虚线的方向
  final Axis direction;

  /// 单个虚线的宽度（水平时为宽，垂直时为高）
  final double dashWidth;

  /// 虚线之间的间距
  final double dashSpace;

  /// 虚线的厚度
  final double thickness;

  /// 虚线的颜色
  final Color? color;

  const DashLine({
    super.key,
    this.direction = Axis.horizontal,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.thickness = 1.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 获取主题默认分割线颜色
    final Color lineColor = color ?? Theme.of(context).dividerColor;

    return CustomPaint(
      size: direction == Axis.horizontal
          ? Size(double.infinity, thickness)
          : Size(thickness, double.infinity),
      painter: _DashLinePainter(
        direction: direction,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        thickness: thickness,
        color: lineColor,
      ),
    );
  }
}

class _DashLinePainter extends CustomPainter {
  final Axis direction;
  final double dashWidth;
  final double dashSpace;
  final double thickness;
  final Color color;

  _DashLinePainter({
    required this.direction,
    required this.dashWidth,
    required this.dashSpace,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    if (direction == Axis.horizontal) {
      double startX = 0;
      final double y = size.height / 2;
      while (startX < size.width) {
        canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
        startX += dashWidth + dashSpace;
      }
    } else {
      double startY = 0;
      final double x = size.width / 2;
      while (startY < size.height) {
        canvas.drawLine(Offset(x, startY), Offset(x, startY + dashWidth), paint);
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.thickness != thickness;
  }
}