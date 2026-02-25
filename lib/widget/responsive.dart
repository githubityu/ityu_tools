import 'package:flutter/material.dart';

/// 屏幕尺寸断点常量 (可根据项目需求调整)
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.useScreenSize = false,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  /// true: 基于窗口大小 (MediaQuery)
  /// false: 基于父容器大小 (LayoutBuilder)
  final bool useScreenSize;

  // --- 静态判断方法 (优化为通用逻辑) ---

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < Breakpoints.mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.mobile &&
          MediaQuery.sizeOf(context).width < Breakpoints.tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

  @override
  Widget build(BuildContext context) {
    if (useScreenSize) {
      final double width = MediaQuery.sizeOf(context).width;
      return _pickWidget(width);
    } else {
      return LayoutBuilder(
        builder: (context, constraints) => _pickWidget(constraints.maxWidth),
      );
    }
  }

  /// 使用 Dart 3 的模式匹配选择 Widget
  Widget _pickWidget(double width) {
    return switch (width) {
      < Breakpoints.mobile => mobile,
      >= Breakpoints.mobile && < Breakpoints.tablet => tablet ?? mobile,
      _ => desktop,
    };
  }
}

/// 增加 BuildContext 扩展，调用更方便
/// context.isMobile ? buildVertical() : buildHorizontal();
/// fontSize: context.responsive(14.0, tablet: 18.0, desktop: 24.0)
extension ResponsiveExt on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);

  /// 快速获取响应式值 (例如：context.responsive(10, tablet: 20, desktop: 30))
  T responsive<T>(T mobile, {T? tablet, T? desktop}) {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= Breakpoints.tablet && desktop != null) return desktop;
    if (width >= Breakpoints.mobile && tablet != null) return tablet;
    return mobile;
  }
}