import 'package:flutter/material.dart';

import '../view_utils.dart';

extension BuildContextExtension on BuildContext {
  // --- 导航 ---

  // --- 主题与颜色 ---
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// 快速判断是否为深色模式
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // --- 屏幕尺寸与 Padding ---
  /// 使用 maybeOf 以提高在 Overlay 等特殊上下文下的鲁棒性
  MediaQueryData? get _mediaQuery => MediaQuery.maybeOf(this);

  double get screenWidth => _mediaQuery?.size.width ?? 0;
  double get screenHeight => _mediaQuery?.size.height ?? 0;
  double get topPadding => _mediaQuery?.padding.top ?? 0;
  double get bottomPadding => _mediaQuery?.padding.bottom ?? 0;
  double get keyboardHeight => _mediaQuery?.viewInsets.bottom ?? 0;

  ({Offset offset, Size size}) get widgetInfo {
    final renderBox = findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return (offset: Offset.zero, size: Size.zero);
    }
    return (
    offset: renderBox.localToGlobal(Offset.zero),
    size: renderBox.size
    );
  }
  // --- 常用操作 ---
  /// 快速显示 SnackBar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// 快速收起键盘
  void unfocus() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }


  /// 获取 OverlayState，避免直接使用 ! 导致崩溃
  OverlayState? get overlay => Overlay.maybeOf(this);


  /// 快速获取屏幕尺寸（代替 Screens 类部分功能）
  Size get screenSize => MediaQuery.sizeOf(this);
}


extension StateExtension on State {
  /// 安全的更新状态。
  /// 仅在组件仍挂载在树中时执行 setState。
  /// 全能型安全更新：
  /// 1. 检查是否挂载 (mounted) -> 防止 dispose 报错
  /// 2. 检查是否在构建中 (schedulerPhase) -> 防止 build 期间 setState 报错
  void safeSetState(VoidCallback fn) {
    // ignore: invalid_use_of_protected_member
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}