import 'dart:io';
import 'package:flutter/foundation.dart';

class Device {
  const Device._();

  /// 是否为 Web 环境
  static const bool isWeb = kIsWeb;

  /// 是否为移动端 (Android 或 iOS)
  static bool get isMobile => !isWeb && (Platform.isAndroid || Platform.isIOS);

  /// 是否为桌面端 (Windows, macOS, Linux)
  static bool get isDesktop => !isWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// 具体的平台判断，增加了对 Web 的保护
  static bool get isAndroid => !isWeb && Platform.isAndroid;
  static bool get isIOS => !isWeb && Platform.isIOS;
  static bool get isMacOS => !isWeb && Platform.isMacOS;
  static bool get isWindows => !isWeb && Platform.isWindows;
  static bool get isLinux => !isWeb && Platform.isLinux;
  static bool get isFuchsia => !isWeb && Platform.isFuchsia;

  /// 获取当前运行平台的名称 (调试用)
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }
}