import 'package:flutter/material.dart';

//普通的
class EmptyWrapWidget extends StatelessWidget {
  const EmptyWrapWidget(
      {required this.child,
      Key? key,
      this.emptyWidget,
      this.isEmpty = false})
      : super(key: key);
  final Widget child;
  final Widget? emptyWidget;
  final bool? isEmpty;
  @override
  Widget build(BuildContext context) {
    Widget current = Stack(
      children: [
        child,
        Visibility(
          visible: isEmpty ?? false,
          child: emptyWidget ?? const SizedBox.shrink(),
        )
      ],
    );
    return current;
  }
}
