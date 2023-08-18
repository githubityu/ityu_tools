import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  const DashLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.biggest.width;
        final itemNum = width / 13;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              itemNum.toInt(),
              (index) => Padding(
                    padding: EdgeInsets.only(
                        right: index == itemNum.toInt() - 1 ? 0.0 : 8.0),
                    child: const SizedBox(width: 5, child: Divider()),
                  )).toList(),
        );
      },
    );
  }
}
