import 'package:flutter/material.dart';

class AutoHideByKeyboard extends StatefulWidget {
  final Widget child;
  final BuildContext parentContext;

  const AutoHideByKeyboard(
      {Key? key, required this.child, required this.parentContext})
      : super(key: key);

  @override
  State<AutoHideByKeyboard> createState() => _AutoHideByKeyboardState();
}

class _AutoHideByKeyboardState extends State<AutoHideByKeyboard>
    with WidgetsBindingObserver {
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (context.mounted) {
      final isShowNew =
          MediaQuery.of(widget.parentContext).viewInsets.bottom > 0;
      if (isShow != isShowNew) {
        setState(() {
          isShow = isShowNew;
          // 'isShow2=$isShow'.log();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isShow,
      child: widget.child,
    );
  }
}
