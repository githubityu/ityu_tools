import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MyIFrame extends StatefulWidget {
  final String url;
  final Function(double, dynamic)? heightFunc;

  const MyIFrame(this.url, {Key? key, this.heightFunc}) : super(key: key);

  @override
  State<MyIFrame> createState() => _MyIFrameState();
}

class _MyIFrameState extends State<MyIFrame> {
  final element = IFrameElement();

  @override
  void initState() {
    super.initState();
    element.src = widget.url;
    element.style.border = "0px solid red";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'my-iframe-view${widget.url}',
      (int viewId) => element,
    );
  }

  @override
  void didUpdateWidget(covariant MyIFrame oldWidget) {
    element.src = widget.url;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 300,
      maxHeight: 500,
      child: HtmlElementView(
        viewType: 'my-iframe-view${widget.url}',
      ),
    );
  }
}
