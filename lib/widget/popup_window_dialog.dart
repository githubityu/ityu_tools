import 'package:flutter/material.dart';
import 'package:ityu_tools/exports.dart';

///
/// use
///     final result = await showDialog(
///               context: context,
///                builder: (_) => PopupWindowDialog(
///                      targetContext: context,
///                      vn: vn,
///                      child: InkWell(
///                        child: Text("===="),
///                        onTap: () {
///                          vn.value = 1;
///                        },
///                      ),
///                    ),
///                barrierColor: Colors.transparent);
///
///
///

class PopupWindowDialog extends StatefulWidget {
  final BuildContext targetContext;
  final Widget child;
  final ValueNotifier vn;
  final Duration duration;

  const PopupWindowDialog({super.key,
    required this.targetContext,
    required this.child,
    Duration? duration,
    required this.vn})
      : duration = duration ?? const Duration(milliseconds: 300);

  @override
  State<PopupWindowDialog> createState() => _PopupWindowDialogState();
}

class _PopupWindowDialogState extends State<PopupWindowDialog> {
  double slideY = -1;
  late double top;

  @override
  void initState() {
    super.initState();
    top = Utils
        .getOffsetAndSize(widget.targetContext)
        .offset
        .dy;
    Future.delayed(Duration.zero).then((value) {
      safeSetState(() {
        slideY = 0;
      });
    });
    widget.vn.addListener(() {
      close();
    });
  }

  void close() {
    safeSetState(() {
      slideY = -1;
    });
    Future.delayed(widget.duration)
        .then((value) {
      if (mounted) {
        Navigator.of(context).pop(widget.vn.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: top,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black54.withOpacity(0.1),
              ),
            )),
        GestureDetector(
          onTap: () {
            close();
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: top),
          child: ClipRect(
            child: AnimatedSlide(
              offset: Offset(0, slideY),
              duration: widget.duration,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
