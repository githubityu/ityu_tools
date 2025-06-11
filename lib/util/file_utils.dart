import 'dart:math';

class FileUtils{
  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  static String getFileNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(
        filePath.lastIndexOf("/") + 1, filePath.length);
  }

  /// 获取文件类型
  static String getFileType(String path) {
    print(path);
    List<String> array = path.split('.');
    return array[array.length - 1];
  }
}