import 'package:flutter/services.dart';

class AppInputFormatters {
  static final alphanumeric = FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'));
  static final denyChinese = FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'));
  static final digitsOnly = FilteringTextInputFormatter.digitsOnly;
  static final email = FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z.@]'));
}