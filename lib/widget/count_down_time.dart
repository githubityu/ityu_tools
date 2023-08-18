import 'dart:async';

import 'package:ityu_tools/util/extension/async_snapshot.dart';
import 'package:ityu_tools/util/utils.dart';
import 'package:flutter/material.dart';


/// create at 2022/1/4 15:24
/// by githubityu
/// describe：

class CountDownTime extends StatelessWidget {

  const CountDownTime(this.times, {super.key, this.preStr = '', this.callback, this.textStyle});
  final int times;
  final String? preStr;
  final TextStyle? textStyle;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: '$preStr${Utils.constructTime((times - 1) * 1000)}',
        stream: Stream.periodic(const Duration(seconds: 1), (int i) => i)
            .take(times)
            .map((event) =>
                '$preStr${Utils.constructTime((times - event - 1) * 1000)}'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.isDone) {
            if (callback != null) {
              return const Text('');
            }
          }
          if (snapshot.hasData) {
            return Text(snapshot.data ?? '', style: textStyle);
          }
          return Text('---', style: textStyle);
        });
  }
}
