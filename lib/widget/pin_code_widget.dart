import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ityu_tools/exports.dart';

class PinCodeWidget extends StatefulWidget {
  final List<String> keys;
  final GlobalKey<FormState> formKey;
  final InputDecoration? inputDecoration;
  final bool isPwd;

  const PinCodeWidget({Key? key,
    required this.keys,
    required this.formKey,
    this.inputDecoration, this.isPwd = false})
      : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  @override
  Widget build(BuildContext context) {
    final f = FocusNode();
    return RawKeyboardListener(
      focusNode: f,
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            FocusManager.instance.primaryFocus?.previousFocus();
          }
        }
      },
      child: Form(
        key: widget.formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              widget.keys.length,
                  (index) =>
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      obscureText: widget.isPwd,
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
                        }
                      },
                      onSaved: (newValue) {
                        widget.keys[index] = newValue ?? '';
                      },
                      keyboardType: TextInputType.number,
                      decoration: widget.inputDecoration,
                    ),
                  )),
        ),
      ),
    );
  }
}
