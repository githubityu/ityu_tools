import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  final Axis direction;

  const DashLine({super.key, this.direction = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    final horizontal = direction == Axis.horizontal;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width =
        horizontal ? constraints.biggest.width : constraints.biggest.height;
        final itemNum = width / 13;
        return Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: direction,
          children: List.generate(
              itemNum.toInt(),
                  (index) => Padding(
                padding: EdgeInsets.only(
                    right: horizontal
                        ? index == itemNum.toInt() - 1
                        ? 0.0
                        : 8.0
                        : 0,
                    bottom: !horizontal
                        ? index == itemNum.toInt() - 1
                        ? 0.0
                        : 8.0
                        : 0),
                child: SizedBox(
                    width: horizontal ? 5 : 0,
                    height: horizontal ? 0 : 5,
                    child: horizontal ? const Divider() : const VerticalDivider()),
              )).toList(),
        );
      },
    );
  }
}
