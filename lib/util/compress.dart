import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';


class MtCompress {
  ///压缩图片
  static Future<File?> image(File file,
      {int minWidth = 720, int minHeight = 1080}) async {
    var f = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_temp.png',
      quality: 80,
      keepExif: true,
      format: CompressFormat.png,
      minHeight: minHeight,
      minWidth: minWidth,
    );
    if (f != null) {
      return File(f.path);
    }
  }
}
