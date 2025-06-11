import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:ityu_tools/util/extension/build_context_ext.dart';
import 'package:ityu_tools/util/extension/log_extensions.dart';
import 'package:ityu_tools/util/extension/object_ext.dart';
import 'package:ityu_tools/widget/safe_area_widget.dart';

class DialogUtils {
  // static Future<List<XFile>?> showPicDialog(
  //     BuildContext context, ImagePicker picker,
  //     {bool isMul = false}) async {
  //   return await showCupertinoModalPopup<List<XFile>?>(
  //       context: context,
  //       builder: (context) {
  //         return Theme(
  //           data: context.theme.copyWith(
  //               colorScheme: const ColorScheme.dark(primary: Colors.white)),
  //           child: CupertinoActionSheet(
  //             cancelButton: CupertinoActionSheetAction(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Cancel'),
  //             ),
  //             actions: [
  //               CupertinoActionSheetAction(
  //                 onPressed: () async {
  //                   if (isMul) {
  //                     final List<XFile> file = await picker.pickMultiImage();
  //                     file.let((t) {
  //                       Navigator.pop(context, file);
  //                     });
  //                   } else {
  //                     final XFile? file =
  //                         await picker.pickImage(source: ImageSource.gallery);
  //                     file?.let((t) {
  //                       Navigator.pop(context, [t]);
  //                     });
  //                   }
  //                 },
  //                 child: const Text('Photo'),
  //               ),
  //               CupertinoActionSheetAction(
  //                 onPressed: () async {
  //                   final XFile? file =
  //                       await picker.pickImage(source: ImageSource.camera);
  //                   file?.let((t) {
  //                     Navigator.pop(context, [t]);
  //                   });
  //                 },
  //                 child: const Text('Camera'),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  static Future<bool?> showTipsDialog(
    BuildContext context, {
    String? content,
    Widget? contentWidget,
    String left = 'Cancel',
    String right = 'Confirm',
    bool singleBtn = false,
  }) async {
    return SmartDialog.show(builder: (BuildContext context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: contentWidget ??
            Text(
              content ?? '',
              style: const TextStyle(fontSize: 16),
            ),
        children: [
          Row(
            children: [
              if (!singleBtn)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(color: context.theme.primaryColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: SimpleDialogOption(
                          child: Text(
                            left,
                            style: TextStyle(color: context.theme.primaryColor),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () => SmartDialog.dismiss(result: false)),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: SimpleDialogOption(
                        child: Text(
                          right,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => SmartDialog.dismiss(result: true)),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
  static Future<bool?> showCommonDialog(
      BuildContext context, {
        required Widget child,
        bool isClose = false,
      }) async {
    return SmartDialog.show(
      clickMaskDismiss: isClose,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: child,
        );
      },
    );
  }

  static showBottomList(BuildContext context,
      {double height = 200,
      required List<String> datas,
      int initialItem = 0}) async {
    var selectItem = initialItem;
    return await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            constraints: BoxConstraints.loose(Size.fromHeight(height)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectItem == initialItem) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(
                              context, (selectItem, datas[selectItem]));
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: const Text(
                        '确定',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: initialItem),
                    itemExtent: 40,
                    onSelectedItemChanged: (int value) {
                      selectItem = value;
                    },
                    children: datas.map((e) => Center(child: Text(e))).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static showBottomDate(BuildContext context,
      {double height = 200,
      DateTime? initTime,
      DateTime? minDt,
      DateTime? maxDt,
      CupertinoDatePickerMode? mode}) async {
    DateTime? dt;
    return await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          "initTime=$initTime".log();
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            constraints: BoxConstraints.loose(Size.fromHeight(height)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, dt ?? initTime);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: mode ?? CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: initTime,
                    use24hFormat: true,
                    minimumDate: minDt,
                    maximumDate: maxDt,
                    onDateTimeChanged: (DateTime value) {
                      dt = value;
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  static showBottomWidget(BuildContext context, Widget child,
      {double height = 250, bool barrierDismissible = true, Color? color}) async {
    return await showCupertinoModalPopup(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return Container(
            decoration:  BoxDecoration(
                color: color ?? Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            constraints: BoxConstraints.loose(Size.fromHeight(height)),
            child: BottomChildAdapter(child: child),
          );
        });
  }


}
