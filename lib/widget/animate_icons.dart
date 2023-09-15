import 'package:flutter/material.dart';

class AnimateIcons extends StatelessWidget {
  const AnimateIcons(
      {Key? key,
      required this.isShowFirst,
      required this.first,
      required this.second})
      : super(key: key);
  final bool isShowFirst;
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    //video_enlarge
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      crossFadeState:
          isShowFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
    );
  }
}

class OnTapAnimateIcons extends StatelessWidget {
  const OnTapAnimateIcons(
      {Key? key,
      required this.isShowFirst,
      required this.first,
      required this.second,
      this.onPressed})
      : super(key: key);
  final bool isShowFirst;
  final Widget first;
  final Widget second;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 25,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: AnimateIcons(
          isShowFirst: isShowFirst,
          first: first,
          second: second,
        ),
      ),
    );
  }
}
