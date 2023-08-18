import 'package:hive_flutter/hive_flutter.dart';

class LocalDataUtil {
  const LocalDataUtil._();

  static late final Box _appBox;
  static late final Box _systemConfigBox;
  static late final Box _settingBox;

  static Box get appBox => _appBox;

  static Box get systemConfigBox => _systemConfigBox;

  static Box get settingBox => _settingBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox('app');
    _systemConfigBox = await Hive.openBox('systemConfig');
    _settingBox = await Hive.openBox('settingConfig');
  }
}
