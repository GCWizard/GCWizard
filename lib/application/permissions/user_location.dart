import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkLocationPermission(Location location) async {
  var _permissionStatus = await Permission.location.status;

  if (_permissionStatus.isPermanentlyDenied) return false;

  if (!_permissionStatus.isGranted) {
    await Permission.location.request();

    if (!await Permission.location.isGranted) return false;
  }

  var _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return false;
    }
  }

  return true;
}
