import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlexibleSpaceBarBackground extends StatefulWidget {
  final Function(double) setHeight;
  final Widget child;

  const FlexibleSpaceBarBackground(
      {super.key, required this.setHeight, required this.child});

  @override
  State<FlexibleSpaceBarBackground> createState() =>
      _FlexibleSpaceBarBackgroundState();
}

class _FlexibleSpaceBarBackgroundState
    extends State<FlexibleSpaceBarBackground> {
  final heightKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final heightRO = heightKey.currentContext?.findRenderObject();
      if (heightRO != null && heightRO is RenderBox) {
        widget.setHeight(heightRO.size.height);
        print('heightRO.size.height=${heightRO.size.height}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: heightKey,
          child: widget.child,
        ),
        const Spacer()
      ],
    );
  }
}
