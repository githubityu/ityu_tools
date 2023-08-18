
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ityu_tools/exports.dart';

class PinCodeWidget extends StatefulWidget {
  final List<String> keys;
  final GlobalKey<FormState> formKey;
  final InputDecoration? inputDecoration;

  const PinCodeWidget({Key? key, required this.keys, required this.formKey,this.inputDecoration})
      : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            widget.keys.length,
            (index) => SizedBox(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isNullOrEmpty) {
                        return '';
                      }
                    },
                    showCursor: false,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    onChanged: (data) {
                      if (data.isNotNullOrEmpty) {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      } else {
                        FocusManager.instance.primaryFocus?.previousFocus();
                      }
                    },
                    onSaved: (newValue) {
                      'onSaved1=$newValue'.log();
                      widget.keys[index] = newValue ?? '';
                    },
                    keyboardType: TextInputType.number,
                    decoration: widget.inputDecoration,
                  ),
                )),
      ),
    );
  }
}
