import 'package:flutter/widgets.dart';

class BottomChildAdapter extends StatelessWidget {
  final Widget child;
  const BottomChildAdapter({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(left: false,right: false,top: false,bottom: true,child: child,);
  }
}
