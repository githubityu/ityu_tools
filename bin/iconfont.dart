import 'dart:io';
import 'package:path/path.dart' as p;

/// IconFont 自动生成工具
/// 运行方式: dart run ityu_tools:iconfont
class Config {
  static const String cssPath = 'assets/font/iconfont.css';
  static const String outputPath = 'lib/src/ui/iconfont.dart';
}

void main() async {
  final current = Directory.current;
  final cssFile = File(p.join(current.path, Config.cssPath));

  if (!await cssFile.exists()) {
    print('❌ 错误: 未找到 CSS 文件 -> ${Config.cssPath}');
    print('请确保 assets/font/ 目录下存在 iconfont.css');
    return;
  }

  print('开始解析: ${Config.cssPath}...');
  final cssContent = await cssFile.readAsString();

  final namesReg = RegExp(r'(?<=\.).+(?=:before)', multiLine: true);
  final valuesReg = RegExp(r'(?<=\\)e[0-9a-zA-Z]{3}(?=";)', multiLine: true);

  final names = namesReg.allMatches(cssContent).toList();
  final values = valuesReg.allMatches(cssContent).toList();

  if (names.isEmpty) {
    print('❌ 错误: 未能从 CSS 中解析出任何图标名称');
    return;
  }

  if (names.length != values.length) {
    print('⚠️ 警告: 图标名称与编码数量不匹配 (${names.length} vs ${values.length})');
  }

  var buffer = StringBuffer();
  buffer.writeln("// Generated code - do not modify by hand");
  buffer.writeln("import 'package:flutter/widgets.dart';");
  buffer.writeln("");
  buffer.writeln("class IconFont {");
  buffer.writeln("  static const String _family = 'iconfont';");
  buffer.writeln("  IconFont._();");

  final count = names.length < values.length ? names.length : values.length;
  for (var i = 0; i < count; i++) {
    final name = names[i].group(0)!.replaceAll('-', '_');
    final value = values[i].group(0);
    buffer.writeln("  static const IconData $name = IconData(0x$value, fontFamily: _family);");
  }

  buffer.writeln("}");

  final outputFile = File(p.join(current.path, Config.outputPath));
  if (!await outputFile.parent.exists()) {
    await outputFile.parent.create(recursive: true);
  }
  await outputFile.writeAsString(buffer.toString());

  print('✅ 成功: 已生成 ${Config.outputPath} (共计 $count 个图标)');
}
