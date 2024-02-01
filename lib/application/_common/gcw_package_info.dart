import 'package:package_info_plus/package_info_plus.dart';

const _PACKAGE_INFO_UNKNOWN = 'unknown';

// Read PackageInfo once on app start. Treat information as singleton
class GCWPackageInfo {
  static GCWPackageInfo? _instance;

  String packageName = _PACKAGE_INFO_UNKNOWN;
  String appName = _PACKAGE_INFO_UNKNOWN;
  String version = _PACKAGE_INFO_UNKNOWN;
  String buildNumber = _PACKAGE_INFO_UNKNOWN;
  String buildSignature = _PACKAGE_INFO_UNKNOWN;
  String installerStore = _PACKAGE_INFO_UNKNOWN;

  static Future<void> init() async {
    if (_instance == null) {
      final _info = await PackageInfo.fromPlatform();
      _instance = GCWPackageInfo._(_info);
    }
  }

  static GCWPackageInfo getInstance() {
    assert(_instance != null);
    return _instance!;
  }

  GCWPackageInfo._(PackageInfo info) {
    packageName = info.packageName;
    appName = info.appName;
    version = info.version;
    buildNumber = info.buildNumber;
    buildSignature = info.buildSignature;
    installerStore = info.installerStore ?? _PACKAGE_INFO_UNKNOWN;
  }
}