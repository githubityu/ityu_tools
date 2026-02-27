import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:ityu_tools/util/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceUtils {
  /// 修复原代码中的同步读取 Bug
  static Future<MultipartFile> getMultipartFile(String path) async {
    // 务必使用 fromFile (异步)，不要用 fromBytesSync (同步)
    return await MultipartFile.fromFile(path);
  }

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      UiUtils.showToast("Cannot open $url");
    }
  }


  /// 复制文本
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    UiUtils.showToast("Copied to clipboard");
  }
  static String getClashList(String base64String) {
    final decodedString = parseBase64(base64String);
    final list = decodedString.split("\n");
    final clashList = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].trim().length > 8) {
        clashList.add(vmessToClash(list[i].trim()));
      }
    }
    return json.encode(clashList);
  }

  static String parseBase64(String base64String) {
    var bytes = base64.decode(base64String);
    return utf8.decode(bytes);
  }

  static Map<String, dynamic> vmessToClash(String vmessURL) {
    final decodedString = parseBase64(vmessURL.substring(8));
    var jsonMap = json.decode(decodedString);
// 提取字段
    var name = jsonMap['ps'];
    var server = jsonMap['add'];
    var port = jsonMap['port'];
    var uuid = jsonMap['id'];
    var alterId = jsonMap['aid'];
    var cipher = jsonMap['type'];
    var network = jsonMap['net'];
    var wsPath = jsonMap['path'];
    var wsHeaders = jsonMap['host'];

// 构建 Clash 节点信息
    var clashNode = {
      'name': name,
      'type': 'vmess',
      'server': server,
      'port': port,
      'uuid': uuid,
      'alterId': alterId,
      'cipher': cipher,
      'network': network,
    };

    if (network == 'ws') {
      clashNode['network'] = 'ws';
      clashNode['ws-path'] = wsPath;
      clashNode['ws-headers'] = {'Host': wsHeaders};
    }

// 输出 Clash 节点信息
    return clashNode;
  }

}