import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
    this.useScreenSize = false, // 新增参数，默认使用屏幕尺寸
    super.key,
  });
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  final bool useScreenSize;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 800 &&
        MediaQuery.sizeOf(context).width <= 1200;
  }

  @override
  Widget build(BuildContext context) {
    if (useScreenSize) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      if (screenWidth > 1200) {
        return largeScreen;
      } else if (screenWidth <= 1200 && screenWidth >= 800) {
        return mediumScreen ?? largeScreen;
      } else {
        return smallScreen ?? largeScreen;
      }
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return largeScreen;
          } else if (constraints.maxWidth <= 1200 &&
              constraints.maxWidth >= 800) {
            return mediumScreen ?? largeScreen;
          } else {
            return smallScreen ?? largeScreen;
          }
        },
      );
    }
  }
}
