import 'package:intl/intl.dart';
import 'package:ityu_tools/exports.dart';


class TimeFormats {
  static const String yyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
  static const String yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
  static const String yyyyMMdd = 'yyyy-MM-dd';
  static const String mmdd = 'MM-dd';
  static const String hhmm = 'HH:mm';
  static const String mmddhhmm2 = 'MM.dd HH:mm';
  static const String eeeMMd = 'EEE, MMM d - h:mm a';
  static const String defaultPattern = 'yyyy.MM.dd';
}

extension DateTimeExt on DateTime {
  /// 通用格式化
  String format([String pattern = TimeFormats.defaultPattern]) {
    return DateFormat(pattern).format(this);
  }


  /// 快捷格式化 yyyy-MM-dd
  String get toDateString => format(TimeFormats.yyyyMMdd);

  /// 快捷获取秒级时间戳 (int 类型更符合逻辑)
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  /// 获取最大值
  DateTime max(DateTime? other) {
    if (other == null) return this;
    return isAfter(other) ? this : other;
  }
  // 💡 优化 1：利用 Dart 原生特性获取当月天数（绝对不会出现闰年算错的问题）
  // 原理：下个月的第 0 天，就是这个月的最后一天。
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  // 💡 优化 2：统一收口到 addDays，且改为 getter 属性更符合 Dart 规范
  DateTime get nextDay => addDays(1);

  // 💡 优化 3：增加 isUtc 判断！这是极其关键的防坑点。
  // 将时间清零至 00:00:00，网赚App“每日零点重置任务”全靠它。
  DateTime get dateOnly => isUtc
      ? DateTime.utc(year, month, day)
      : DateTime(year, month, day);

  // 兼容老代码的方法调用
  DateTime removeTime() => dateOnly;

  // 💡 优化 4：日期比较最稳妥的方法是直接对比 dateOnly，
  // 避免 "10:00 isAfter 15:00" 这种由时分秒引起的临界点 Bug。
  bool isSameDayOrAfter(DateTime other) => !dateOnly.isBefore(other.dateOnly);

  bool isSameDayOrBefore(DateTime other) => !dateOnly.isAfter(other.dateOnly);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  // 💡 优化 5：安全增减天数，完美避开夏令时(DST) Bug，并保持 UTC 属性不丢失
  DateTime addDays(int daysToAdd) {
    return isUtc
        ? DateTime.utc(
        year, month, day + daysToAdd,
        hour, minute, second, millisecond, microsecond)
        : DateTime(
        year, month, day + daysToAdd,
        hour, minute, second, millisecond, microsecond);
  }

  /// 获取最小值
  DateTime min(DateTime? other) {
    if (other == null) return this;
    return isBefore(other) ? this : other;
  }

  /// 判断是否是今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 获取这一天的开始时间 (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// 原逻辑重现：获取去掉秒级精度后的时间戳（如果业务确实需要舍弃秒）
  int get minutePrecisionEpoch {
    return DateTime(year, month, day, hour, minute).secondsSinceEpoch;
  }


  /// 格式化为 hh:mm:ss
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inDays > 0
        ? "${duration.inDays}:$hours:$minutes:$seconds"
        : "$hours:$minutes:$seconds";
  }



}

extension StringTimeExtension on String? {
  /// 将字符串解析为 DateTime
  /// [pattern] 必须与字符串格式匹配
  DateTime parse({String pattern = TimeFormats.yyyyMMddHHmm}) {
    if (this == null || this!.isEmpty) return DateTime.now();
    try {
      return DateFormat(pattern).parse(this!);
    } catch (e) {
      'DateTime Parse Error: $e'.logD();
      return DateTime.now();
    }
  }

  /// 处理时间戳字符串转 DateTime
  /// [isMilliseconds] 是否为毫秒级（Java 风格为 13 位，Unix 风格为 10 位）
  DateTime toDateTime({bool isMilliseconds = false}) {
    if (this == null || this!.isEmpty) return DateTime.now();

    final n = int.tryParse(this!);
    if (n == null) return DateTime.now();

    if (isMilliseconds) {
      return DateTime.fromMillisecondsSinceEpoch(n);
    } else {
      // 如果是 10 位秒级时间戳
      return DateTime.fromMillisecondsSinceEpoch(n * 1000);
    }
  }

  /// 智能解析：如果是数字则按时间戳解析，如果是字符串则按格式解析
  DateTime smartParse({String pattern = TimeFormats.yyyyMMddHHmm}) {
    if (this == null || this!.isEmpty) return DateTime.now();
    if (RegExp(r'^\d+$').hasMatch(this!)) {
      // 自动识别秒还是毫秒
      return toDateTime(isMilliseconds: this!.length == 13);
    }
    return parse(pattern: pattern);
  }
  int getSecondsUntil({String? pattern}) {
    // 1. 空值检查 (替代原来的 isBlank)
    if (this == null || this!.isEmpty) return 0;

    try {
      final DateTime targetDate;
      if (pattern == null) {
        // 原生解析方式，支持 2023-04-05T15:12:12 或 20230405151212（需符合特定标准）
        targetDate = DateTime.parse(this!);
      } else {
        // 使用 intl 包按指定格式解析
        targetDate = DateFormat(pattern).parse(this!);
      }

      // 2. 计算差值
      final duration = targetDate.difference(DateTime.now());

      // 如果目标时间已过期，返回 0 比较安全
      return duration.inSeconds > 0 ? duration.inSeconds : 0;
    } catch (e) {
      // 解析失败打印日志并返回 0，防止崩溃
      print('getSecondsUntil Error: $e');
      return 0;
    }
  }
}