import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  Brightness get brightness => theme.brightness;

  ButtonThemeData get buttonTheme => ButtonTheme.of(this);

  IconThemeData get iconTheme => IconTheme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get bottomViewInsets => mediaQuery.viewInsets.bottom;

  ColorScheme get colorScheme => theme.colorScheme;

  Color get surfaceColor => colorScheme.surface;
}

extension StateExtension on State {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
