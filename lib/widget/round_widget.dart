import 'package:flutter/material.dart';

import 'cache_image.dart';

class RoundWidget extends StatelessWidget {
  const RoundWidget({
    Key? key,
    this.radius = 8,
    this.child,
    this.color,
    this.margin,
    this.elevation = 0,
  }) : super(key: key);
  final double radius;
  final Widget? child;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      color: color ?? Colors.white,
      surfaceTintColor: color ?? Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }
}

class RoundImage extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final String path;

  const RoundImage({
    Key? key,
    this.borderRadius,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CacheImage(
        errorWidget: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        placeholder: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        path: path,
        borderRadius: borderRadius ?? BorderRadius.circular(5));
  }
}

class CircleImage extends StatelessWidget {
  final double radius;
  final String? path;

  const CircleImage({
    Key? key,
    required this.radius,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CacheImage(
          placeholder: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.3),
            radius: radius,
          ),
          errorWidget: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.3),
            radius: radius,
          ),
          path: path,
          isCircle: true),
    );
  }
}
