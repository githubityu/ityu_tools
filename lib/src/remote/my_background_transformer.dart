import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 优化后的 JSON 转换器
/// 基于 Dio 5.x 的 DefaultTransformer
class MyBackgroundTransformer extends DefaultTransformer {
  MyBackgroundTransformer() : super(jsonDecodeCallback: _decodeJson);

  /// JSON 解析逻辑
  static FutureOr<dynamic> _decodeJson(String text) {
    // 阈值设置：小于 50KB 的数据直接在主 Isolate 解析，避免 Isolate 通信开销
    // 这里的 50 * 1024 是字节数
    if (text.length < 50 * 1024) {
      return _parseJson(text);
    }

    // 大于 50KB 使用 Isolate.run (Flutter 3.7+ 推荐) 或 compute
    // Isolate.run 比 compute 更轻量
    return compute(_parseJson, text);
  }

  /// 实际解析方法
  /// 如果需要统一处理数字转字符串等逻辑，可以在这里配置 reviver
  static dynamic _parseJson(String text) {
    return jsonDecode(text, reviver: (key, value) {
      // 在这里可以保留你之前的转换逻辑，如果不需要则保持默认
      // if (value is int || value is double) return '$value';
      return value;
    });
  }
}

/*
使用方法：
final dio = Dio();
dio.transformer = MyBackgroundTransformer();
*/