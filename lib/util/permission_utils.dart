import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static List<Permission> get cameraGroup => [
    Permission.camera,
    Platform.isAndroid ? Permission.storage : Permission.photos,
  ];

  static Future<bool> request(List<Permission> permissions) async {
    final statuses = await permissions.request();
    return statuses.values.every((s) => s.isGranted);
  }
}