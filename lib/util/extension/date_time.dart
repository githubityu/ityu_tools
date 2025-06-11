import 'package:intl/intl.dart';

const MMDDHHMM = 'yyyy-MM-dd HH:mm';
const MMDDHHMMSS = 'yyyy-MM-dd HH:mm:ss';
const YYMMDD = 'yyyy-MM-dd';
const MMDD = 'MM-dd';
const HHMM = 'HH:mm';
const MMDDHHMM2 = 'MM.dd HH:mm';
const EEEMMD = 'EEE, MMM d - h:mm a';
const MMD = 'd MMM - h:mm a';
const HMMA = 'h:mm a';
const MMYYYY = 'MMM yyyy';
const DMMYYYY = 'd MMM yyyy';

extension DateTimeExt on DateTime {
  String format([String newPattern = 'yyyy.MM.dd']) {
    return DateFormat(newPattern).format(this);
  }

  String formatYYYYMMdd([String newPattern = YYMMDD]) {
    return DateFormat(newPattern).format(this);
  }
  DateTime max(DateTime? other) {
    if (other == null) {
      return this;
    }
    return isAfter(other) ? this : other;
  }
  DateTime min(DateTime? other) {
    if (other == null) {
      return this;
    }
    return isBefore(other) ? this : other;
  }

  ///e.format(MMDDHHMM).parse(newPattern: MMDDHHMM).secondsSinceEpoch
  String get secondsSinceEpoch =>
      (format(MMDDHHMM).parse(newPattern: MMDDHHMM).millisecondsSinceEpoch /
              1000)
          .toStringAsFixed(0);
}

/// String 空安全处理
extension StringTimeExtension on String? {
  // yyyyMMddHHmm
  // 202304050900
  DateTime parse({String newPattern = MMDDHHMM}) {
    try {
      return DateFormat(newPattern).parse(this!);
    } catch (e) {
      return DateTime.now();
    }
  }

  DateTime parseTime({bool isJava = false}) {
    final timeMill = isJava ? this : '${this}000';
    try {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timeMill!));
    } catch (e) {
      return DateTime.now();
    }
  }
}
