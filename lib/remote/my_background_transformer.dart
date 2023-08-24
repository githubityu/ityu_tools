import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';



/// [MyBackgroundTransformer] will do the deserialization of JSON
/// in a background isolate if possible.
class MyBackgroundTransformer extends SyncTransformer {
  MyBackgroundTransformer() : super(jsonDecodeCallback: _decodeJson);
}

final _myJsonCodec = JsonCodec.withReviver((dynamic key, dynamic value) {
  // if (value is int || value is double) return '$value';
  return value;
});

_parseAndDecode(String response) {
  return _myJsonCodec.decode(response);
}

FutureOr<dynamic> _decodeJson(String text) {
  if (text.codeUnits.length < 50 * 1024) {
    return _parseAndDecode(text);
  }
  return compute(_parseAndDecode, text);
}
