import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screens {
  const Screens._();

  /// 获取主视图 (FlutterView)
  /// 在多窗口环境下，建议通过 View.of(context) 获取
  static ui.FlutterView get _view => ui.PlatformDispatcher.instance.implicitView!;

  /// 获取最新的 MediaQueryData
  static MediaQueryData get mediaQuery => MediaQueryData.fromView(_view);

  /// 屏幕像素密度
  static double get scale => _view.devicePixelRatio;

  /// 屏幕宽度 (逻辑像素)
  static double get width => mediaQuery.size.width;

  /// 屏幕宽度 (物理像素)
  static int get widthPixels => (width * scale).toInt();

  /// 屏幕高度 (逻辑像素)
  static double get height => mediaQuery.size.height;

  /// 屏幕高度 (物理像素)
  static int get heightPixels => (height * scale).toInt();

  /// 宽高比
  static double get aspectRatio => width / height;

  /// 获取 TextScaler (替代旧版的 textScaleFactor)
  static TextScaler get textScaler => mediaQuery.textScaler;

  /// 获取当前的文本缩放比例 (兼容旧逻辑，但推荐直接用 textScaler)
  static double get textScaleFactor => textScaler.scale(1.0);

  /// 修正由于系统字体缩放导致的字体大小变化
  /// 如果你想让字体不随系统设置变大，可以使用此方法
  static double fixedFontSize(double fontSize) => fontSize / textScaleFactor;

  /// 导航栏高度 (状态栏 + AppBar 标准高度)
  static double get navigationBarHeight => topSafeHeight + kToolbarHeight;

  /// 状态栏高度 (顶部安全距离)
  static double get topSafeHeight => mediaQuery.padding.top;

  /// 底部安全距离 (如 iPhone 的 Home Indicator)
  static double get bottomSafeHeight => mediaQuery.padding.bottom;

  /// 去除顶部和底部安全区域后的内容高度
  static double get safeHeight => height - topSafeHeight - bottomSafeHeight;

  /// 更新系统状态栏样式
  static void updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}