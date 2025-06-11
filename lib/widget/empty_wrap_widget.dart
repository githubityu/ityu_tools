import 'package:flutter/material.dart';

typedef ChildBuilder = Widget Function();

//普通的
class EmptyWrapWidget extends StatelessWidget {
  const EmptyWrapWidget(
      {required this.builder,
        super.key,
        this.emptyWidget,
        this.isEmpty = false});

  final Widget? emptyWidget;
  final ChildBuilder builder;
  final bool? isEmpty;

  @override
  Widget build(BuildContext context) {
    return isEmpty == true
        ? (emptyWidget ?? const SizedBox.shrink())
        : builder();
  }
}
