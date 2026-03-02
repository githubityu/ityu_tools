import 'package:flutter/foundation.dart';

/// 正则表达式常量定义
class RegexConstants {
  const RegexConstants._();

  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String digits = r'^\d+$';
  static const String hasDigits = r'\d';
  static const String letters = r'^[a-zA-Z]+$';
  static const String hasLetters = r'[a-zA-Z]';
  static const String hasLowercase = r'[a-z]';
  static const String hasUppercase = r'[A-Z]';
  static const String chinese = r'^[\u4e00-\u9fa5]+$';
  static const String hasChinese = r'[\u4e00-\u9fa5]';
  static const String alphanumeric = r'^[a-zA-Z0-9]+$';
  static const String chineseAlphanumeric = r'^[a-zA-Z0-9\u4e00-\u9fa5]+$';

  // 手机号（简单校验 1 开头 11 位）
  static const String mobile = r'^1\d{10}$';
}

/// 预编译正则对象，提高性能
class RegexPool {
  RegexPool._();

  static final RegExp email = RegExp(RegexConstants.email);
  static final RegExp digits = RegExp(RegexConstants.digits);
  static final RegExp hasDigits = RegExp(RegexConstants.hasDigits);
  static final RegExp letters = RegExp(RegexConstants.letters);
  static final RegExp hasLetters = RegExp(RegexConstants.hasLetters);
  static final RegExp hasLowercase = RegExp(RegexConstants.hasLowercase);
  static final RegExp hasUppercase = RegExp(RegexConstants.hasUppercase);
  static final RegExp chinese = RegExp(RegexConstants.chinese);
  static final RegExp hasChinese = RegExp(RegexConstants.hasChinese);
  static final RegExp alphanumeric = RegExp(RegexConstants.alphanumeric);
  static final RegExp chineseAlphanumeric = RegExp(RegexConstants.chineseAlphanumeric);
  static final RegExp mobile = RegExp(RegexConstants.mobile);
}

/// 字符串正则扩展 - 推荐用法： "123".isDigits
extension StringRegexExt on String? {

  bool _match(RegExp reg) => this == null ? false : reg.hasMatch(this!);

  /// 是否是邮箱
  bool get isEmail => _match(RegexPool.email);

  /// 是否纯数字
  bool get isDigits => _match(RegexPool.digits);

  /// 是否包含数字
  bool get hasDigits => _match(RegexPool.hasDigits);

  /// 是否纯字母
  bool get isLetters => _match(RegexPool.letters);

  /// 是否包含字母
  bool get hasLetters => _match(RegexPool.hasLetters);

  /// 是否包含大写字母
  bool get hasUppercase => _match(RegexPool.hasUppercase);

  /// 是否包含小写字母
  bool get hasLowercase => _match(RegexPool.hasLowercase);

  /// 是否纯中文
  bool get isChinese => _match(RegexPool.chinese);

  /// 是否包含中文
  bool get containsChinese => _match(RegexPool.hasChinese);

  /// 是否仅包含字母和数字
  bool get isAlphanumeric => _match(RegexPool.alphanumeric);

  /// 是否仅包含中文字母和数字
  bool get isChineseAlphanumeric => _match(RegexPool.chineseAlphanumeric);

  /// 是否为 11 位手机号
  bool get isMobile => _match(RegexPool.mobile);

  /// 自定义正则校验
  bool matches(String source) => this == null ? false : RegExp(source).hasMatch(this!);
}