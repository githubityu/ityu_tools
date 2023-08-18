class RegExpUtil {
  // 邮箱判断
  static bool isEmail(String input) {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (input.isEmpty) return false;
    return RegExp(regexEmail).hasMatch(input);
  }

  // 纯数字
  static const String DIGIT_REGEX = r'^\d+$';

  // 含有数字
  static const String CONTAIN_DIGIT_REGEX = ".*[0-9].*";

  // 纯字母
  static const String LETTER_REGEX = "[a-zA-Z]+";

  // 包含字母
  static const String SMALL_CONTAIN_LETTER_REGEX = ".*[a-z].*";

  // 包含字母
  static const String BIG_CONTAIN_LETTER_REGEX = ".*[A-Z].*";

  // 包含字母
  static const String CONTAIN_LETTER_REGEX = ".*[a-zA-Z].*";

  // 纯中文
  static const String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  // 仅仅包含字母和数字
  static const String LETTER_DIGIT_REGEX = "^[a-z0-9A-Z]+\$";
  static const String CHINESE_LETTER_REGEX = "([\u4e00-\u9fa5]+|[a-zA-Z]+)";
  static const String CHINESE_LETTER_DIGIT_REGEX =
      "^[a-z0-9A-Z\u4e00-\u9fa5]+\$";

  // 纯数字
  static bool isOnly(String input) {
    if (input.isEmpty) return false;
    return RegExp(DIGIT_REGEX).hasMatch(input);
  }

  // 含有数字
  static bool hasDigit(String input) {
    if (input.isEmpty) return false;
    return RegExp(CONTAIN_DIGIT_REGEX).hasMatch(input);
  }

  // 是否包含中文
  static bool isChinese(String input) {
    if (input.isEmpty) return false;
    return RegExp(CHINESE_REGEX).hasMatch(input);
  }
}
