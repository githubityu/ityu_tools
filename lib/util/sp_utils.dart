import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._();

  static late SharedPreferences _prefs;

  /// 初始化 SharedPreferences，建议在 main.dart 中调用：
  /// await SpUtil.init();
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- 基础类型读取 (同步) ---

  static String getString(String key, {String defValue = ''}) {
    return _prefs.getString(key) ?? defValue;
  }

  static int getInt(String key, {int defValue = 0}) {
    return _prefs.getInt(key) ?? defValue;
  }

  static bool getBool(String key, {bool defValue = false}) {
    return _prefs.getBool(key) ?? defValue;
  }

  static double getDouble(String key, {double defValue = 0.0}) {
    return _prefs.getDouble(key) ?? defValue;
  }

  static List<String> getStringList(String key, {List<String> defValue = const []}) {
    return _prefs.getStringList(key) ?? defValue;
  }

  // --- 基础类型存储 (异步) ---

  static Future<bool> putString(String key, String value) => _prefs.setString(key, value);

  static Future<bool> putInt(String key, int value) => _prefs.setInt(key, value);

  static Future<bool> putBool(String key, bool value) => _prefs.setBool(key, value);

  static Future<bool> putDouble(String key, double value) => _prefs.setDouble(key, value);

  static Future<bool> putStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  // --- 对象存储与读取 (JSON) ---

  /// 存储对象
  /// [value] 需要支持 jsonEncode (即拥有 toJson 方法或为基本 Map)
  static Future<bool> putObject(String key, Object value) {
    return _prefs.setString(key, json.encode(value));
  }

  /// 获取对象
  /// [decoder] 转换工厂，例如：(map) => User.fromJson(map)
  static T? getObj<T>(String key, T Function(Map<String, dynamic> v) decoder) {
    final String? jsonStr = _prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final Map<String, dynamic> map = json.decode(jsonStr);
      return decoder(map);
    } catch (e) {
      return null;
    }
  }

  /// 存储对象列表
  static Future<bool> putObjectList(String key, List<Object> list) {
    final List<String> dataList = list.map((v) => json.encode(v)).toList();
    return _prefs.setStringList(key, dataList);
  }

  /// 获取对象列表
  static List<T> getObjList<T>(String key, T Function(Map<String, dynamic> v) decoder, {List<T> defValue = const []}) {
    final List<String>? dataList = _prefs.getStringList(key);
    if (dataList == null) return defValue;
    try {
      return dataList.map((v) => decoder(json.decode(v))).toList();
    } catch (e) {
      return defValue;
    }
  }

  // --- 通用操作 ---

  /// 是否包含某个 key
  static bool containsKey(String key) => _prefs.containsKey(key);

  /// 移除某个配置
  static Future<bool> remove(String key) => _prefs.remove(key);

  /// 清空所有配置
  static Future<bool> clear() => _prefs.clear();

  /// 重新从磁盘加载（极少用到）
  static Future<void> reload() => _prefs.reload();
}