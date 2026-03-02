import 'package:flutter/services.dart';

/// 校验器抽象基类
abstract class StringValidator {
  bool isValid(String value);
}

/// 1. 正则校验器 (优化：预编译正则)
class RegexValidator implements StringValidator {
  final RegExp _regExp;

  RegexValidator(String pattern) : _regExp = RegExp(pattern);

  @override
  bool isValid(String value) {
    // 使用 hasMatch 配合全匹配逻辑，比 allMatches 性能更好
    return _regExp.hasMatch(value);
  }
}

/// 2. 组合校验器 (新增：支持同时校验多个逻辑)
class CompositeValidator implements StringValidator {
  final List<StringValidator> validators;
  CompositeValidator(this.validators);

  @override
  bool isValid(String value) {
    return validators.every((v) => v.isValid(value));
  }
}

/// 3. 输入限制格式化器 (优化：拦截非法输入)
class RestrictionInputFormatter implements TextInputFormatter {
  final StringValidator validator;

  RestrictionInputFormatter(this.validator);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 如果新输入的不合法，则回退到旧值，从而实现“无法输入非法字符”的效果
    if (!validator.isValid(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}

// --- 常用校验器实现 ---

/// 必填校验
class RequiredValidator implements StringValidator {
  @override
  bool isValid(String value) => value.isNotEmpty;
}

/// 最小长度校验
class MinLengthValidator implements StringValidator {
  final int minLength;
  MinLengthValidator(this.minLength);

  @override
  bool isValid(String value) => value.length >= minLength;
}

/// 邮箱输入过程校验：不允许空格
class EmailEditingValidator extends RegexValidator {
  EmailEditingValidator() : super(r'^\S*$');
}

/// 邮箱提交校验：标准格式
class EmailSubmitValidator extends RegexValidator {
  EmailSubmitValidator() : super(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
}

/// 数字输入限制：仅允许数字
class DigitsLimitValidator extends RegexValidator {
  DigitsLimitValidator() : super(r'^\d*$');
}