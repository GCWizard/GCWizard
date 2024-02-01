import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkStoragePermission() async {
  if (Platform.isAndroid) {
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt >= 33) {
      // due to new Android permissions, the file access permissions should be controlled by the Android File Picker
      return true;
    }
  }

  var _permissionStatus = await Permission.storage.status;

  if (_permissionStatus.isPermanentlyDenied) return false;

  if (!_permissionStatus.isGranted) {
    await Permission.storage.request();

    if (!await Permission.storage.isGranted) return false;
  }

  return true;
}
