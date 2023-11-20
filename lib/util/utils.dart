import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ityu_tools/exports.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

final inputFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'))
];
final inputDenyZHFormatters = [
  FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))
];
final inputNumberFormatters = [FilteringTextInputFormatter.digitsOnly];
final inputEmailFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z.@]'))
];

class Utils {
  static void showToast(String content) {
    SmartDialog.showToast(content,
        alignment: Alignment.center, displayType: SmartToastType.last);
  }

  static List<Permission> permissionsForCamera = [
    Permission.camera,
    Platform.isAndroid ? Permission.storage : Permission.photos
  ];

  static void showErrorToast(String content, List<int> errCodes, int errCode) {
    if (!errCodes.contains(errCode)) {
      showToast(content);
    }
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  static bool isSameDay(DateTime key, DateTime other) {
    return key.year == other.year &&
        key.month == other.month &&
        key.day == other.day;
  }

  static void showCustomToast(String content,
      {backgroundColor = Colors.green, textColor = Colors.black}) {
    SmartDialog.showToast('',
        builder: (_) => CustomToast(content, bgColor: backgroundColor));
  }

  static void showInSnackBar(BuildContext context, Widget child,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: backgroundColor,
        content: child,
      ),
    );
  }

  static List<DateTime> getTimesByLong(
      String startTime, String endTime, int hours, int minutes,
      {bool is24Hours = true}) {
    var dt = intl.DateFormat.Hm().parse(startTime);
    var dt2 = intl.DateFormat.Hm().parse(endTime);
    if (!is24Hours) {
      dt = dt.add(const Duration(hours: 12));
      dt2 = dt2.add(const Duration(hours: 12));
    }
    final nums = (dt2.difference(dt).inMinutes - 60 * hours) ~/ minutes;
    List<DateTime> items = [];
    for (int i = 0; i <= nums; i++) {
      final newDt = dt.add(Duration(minutes: minutes * i));
      items.add(newDt);
    }
    return items;
  }

  static String getFileName(String? filePath) {
    return filePath.isNullOrEmpty ? "" : path.basename(filePath!);
  }

  static int getSafeLength(dynamic data) {
    return data == null ? 0 : data.length;
  }

  static bool getSafeBool(dynamic data) {
    return data ?? false;
  }

  static String getStringForDefault(dynamic data, {String defaultStr = ""}) {
    return data == null ? defaultStr : '$data';
  }

  static bool getSafeIsEmpty(dynamic data) {
    return (data == null ? 0 : data.length) == 0;
  }

  static double getTextWidth(String text, TextStyle textStyle) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: textStyle))
      ..layout(maxWidth: Screens.width);
    return textPainter.width;
  }

  static void copyText(String content) {
    Clipboard.setData(ClipboardData(text: content));
  }

  static void popExt(BuildContext context, Future future,
      [bool mounted = true]) async {
    await future;
    if (!mounted) return;
    Navigator.pop(context);
  }

  static Future<bool> requestPermissions(List<Permission> permissions,
      {bool isShowTips = true}) async {
    if (Device.isWeb) {
      return true;
    }
    final maps = await permissions.request();
    bool isGranted = maps.keys.every((element) {
      final isGranted = maps[element]?.isGranted ?? false;
      if (!isGranted) {
        '$element $isGranted'.log('权限');
      }
      return isGranted;
    });
    if (isGranted) {
      return true;
    } else {
      if (isShowTips) Utils.showToast('权限被拒绝');
      return false;
    }
  }

  static Widget adaptiveAction(
      {required BuildContext context,
      required VoidCallback onPressed,
      required Widget child}) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }

  static void showDeniedDialog(BuildContext context) {
    showAdaptiveDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: const Text("权限申请异常"),
            content: const Text('请在【应用信息】-【权限管理】中，开启全部所需权限，以正常使用惠'),
            actions: [
              adaptiveAction(
                context: context,
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              adaptiveAction(
                context: context,
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context, true);
                },
                child: const Text('去设置'),
              ),
            ],
          );
        });
  }

  /// date = '${date.substring(0, 8)}T${date.substring(8)}';
  ///"20230405151212"
  static int getSeconds(String? dt, {String? newPattern}) {
    if (isBlank(dt)) return 0;
    return (newPattern == null
            ? DateTime.parse(dt!)
            : intl.DateFormat(newPattern).parse(dt!))
        .difference(DateTime.now())
        .inSeconds;
  }

  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(int millis) {
    const number = 1000;
    int millisUntilFinished = millis;
    int day = 0;
    //获取天数
    if (millisUntilFinished > 60 * 60 * 24 * number) {
      day = millisUntilFinished ~/ (60 * 60 * 24 * number);
      millisUntilFinished -= day * (60 * 60 * 24 * number);
    }
    int hour = millisUntilFinished ~/ (60 * 60 * number);
    int minute =
        (millisUntilFinished - hour * 60 * 60 * number) ~/ (60 * number);
    int second = (millisUntilFinished -
            hour * 60 * 60 * number -
            minute * 60 * number) ~/
        number;
    if (second >= 60) {
      second %= 60;
      minute += second ~/ 60;
    }
    if (minute >= 60) {
      minute %= 60;
      hour += (minute ~/ 60);
    }
    String sd = formatTime(day);
    String sh = formatTime(hour);
    String sm = formatTime(minute);
    String ss = formatTime(second);
    //
    //天大于0
    if (day > 0) {
      return '$sd:$sh:$sm:$ss';
    } else {
      //天小于0
      //小时也为0
      if ('00' == sh) {
        if ('00' == sm) {
          return '00:00:$ss';
        } else {
          return '00:$sm:$ss';
        }
      } else {
        //小时不为0
        return '$sh:$sm:$ss';
      }
    }
  }

//数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? '0$timeNum' : timeNum.toString();
  }

  static String readTimestamp(int? timestamp) {
    if (timestamp == null) return '时间格式不正确';
    var now = DateTime.now();
    var format = intl.DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} 天前';
      } else {
        time = '${diff.inDays} 天前';
      }
    } else {
      if (diff.inDays == 7) {
        time = '${(diff.inDays / 7).floor()} 周前';
      } else {
        time = '${(diff.inDays / 7).floor()} 周前';
      }
    }

    return time;
  }

  static RequestOptions setStreamType2<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  static ({Offset offset, Size size}) getOffsetAndSize(
      BuildContext targetContext) {
    final renderBox = targetContext.findRenderObject() as RenderBox;
    return (offset: renderBox.localToGlobal(Offset.zero), size: renderBox.size);
  }

  static Future callUri(Uri uri, {String errMsg = 'not call phone'}) {
    return canLaunchUrl(uri).then((value) {
      if (value) {
        launchUrl(uri);
      } else {
        showToast(errMsg);
      }
    });
  }

  static void initWebViewPlatformInstance(){
    WebViewPlatform.instance = WebWebViewPlatform();
  }

}
