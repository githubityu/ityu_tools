import 'package:flutter/material.dart';

class ArrowRightIcon extends StatelessWidget {
  final Color color;
  final double size;

  const ArrowRightIcon({Color? color, double? size, super.key})
      : color = color ?? Colors.black,
        size = size ?? 15;

  @override
  Widget build(BuildContext context) {
    return  Icon(
      Icons.arrow_forward_ios_rounded,
      color: color,
      size: size,
    );
  }
}
