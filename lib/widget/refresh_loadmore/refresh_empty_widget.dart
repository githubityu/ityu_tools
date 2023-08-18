import 'package:flutter/material.dart';

//普通的
class RefreshEmptyWidget extends StatelessWidget {
  const RefreshEmptyWidget(
      {required this.child,
      Key? key,
      this.onRefresh,
      this.emptyWidget,
      this.isEmpty = false})
      : super(key: key);
  final Widget child;
  final Widget? emptyWidget;
  final RefreshCallback? onRefresh;

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
    if (onRefresh != null) {
      current = RefreshIndicator(onRefresh: onRefresh!, child: current);
    }
    return current;
  }
}
