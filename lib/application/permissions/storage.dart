import 'package:permission_handler/permission_handler.dart';

Future<bool> checkStoragePermission() async {
  var _permissionStatus = await Permission.storage.status;

  if (_permissionStatus.isPermanentlyDenied) return false;

  if (!_permissionStatus.isGranted) {
    await Permission.storage.request();

    if (!await Permission.storage.isGranted) return false;
  }

  return true;
}