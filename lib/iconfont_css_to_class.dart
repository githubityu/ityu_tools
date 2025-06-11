// 根据iconfont.css转换出lib/common/iconfont.dart文件

import 'dart:io';
import 'package:path/path.dart' as p;

String iconfontPath = 'assets/font/iconfont.css';
String iconfontDartPath = 'lib/iconfont.dart';

void css_to_class() async {
  // 读取文件内容为css
  Directory current = Directory.current;
  String absPath = p.join(current.path, iconfontPath);
  var file = File(absPath);
  var css;
  try{
    css = await file.readAsString();
  }catch(e){
    print('error: 不存在assets/fonts/iconfont.css文件');
    return;
  }

  // 解析文件内容获取names和values
  var namesReg = RegExp(
    r'(?<=\.).+(?=:before)',
    multiLine: true,
  );
  var valuesReg = RegExp(r'(?<=\\)e[0-9a-zA-Z]{3}(?=";)', multiLine: true);

  var names = namesReg.allMatches(css);
  var values = valuesReg.allMatches(css);

  //创建dart class
  String iconfontClass = "import 'package:flutter/widgets.dart';";
  iconfontClass += "\nclass IconFont{";
  iconfontClass += "\n\tstatic const String _family = 'iconfont';";
  iconfontClass += "\n\tIconFont._();";

  names.toList().asMap().forEach((key, value) {
    var _name = value.group(0)!.replaceAll('-', '_');
    var _value = values.elementAt(key).group(0);
    iconfontClass +=
    '\n\tstatic const IconData $_name = IconData(0x$_value, fontFamily: _family);';
  });
  iconfontClass += "\n}\n";

  // 将dart class写入文件

  try{
    var dartfile = File(p.join(current.path, iconfontDartPath));
    await dartfile.writeAsString(iconfontClass);
  }catch(e){
    print('error: 不存在lib/common目录');
  }

  print('Successfully: 已根据 assets/fonts/iconfont.css 创建出 lib/common/iconfont.dart');

}
