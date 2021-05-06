import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

Future<String> MainPath() async {
  var status = await Permission.storage.request();
  if (status != PermissionStatus.granted) {
    return null;
  }

  Directory _appDocDir;
  if (Platform.isAndroid)
    _appDocDir = await getExternalStorageDirectory();
  else
    _appDocDir = await getApplicationDocumentsDirectory();

  final Directory _appDocDirFolder = Directory('${_appDocDir.path}');

  var path;
  if (await _appDocDirFolder.exists()) {
    path = _appDocDirFolder.path;
  } else {
    final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
    path = _appDocDirNewFolder.path;
  }
  return path;
}

Future<Map<String, dynamic>> saveByteDataToFile(ByteData data, String fileName, {String subDirectory}) async {
  var filePath = '';
  File file;

  if (kIsWeb) {
    // var blob = new html.Blob([data], 'image/png');
    //
    // var anchorElement = html.AnchorElement(
    //   href: html.Url.createObjectUrl(blob),
    //   )..setAttribute("download", fileName)..click();
    //
    // filePath = 'Downloads/$fileName';
  } else {
    var path = await MainPath();
    if (path == null) return null;
    filePath = subDirectory == null ? '$path/$fileName' : '$path/$subDirectory/$fileName';
    file = File(filePath);

    if (!await file.exists()) file.create();

    await file.writeAsBytes(data.buffer.asUint8List());
  }
  return {'path': filePath, 'file': file};
}

Future<Map<String, dynamic>> saveStringToFile(String data, String fileName, {String subDirectory}) async {
  var filePath = '';
  File file;

  if (kIsWeb) {
    // var blob = html.Blob([data], 'text/plain', 'native');
    //
    // var anchorElement = html.AnchorElement(
    //   href: html.Url.createObjectUrl(blob),
    // )..setAttribute("download", fileName)..click();
    //
    // filePath = 'Downloads/$fileName';
  } else {
    var path = await MainPath();
    if (path == null) return null;
    filePath = subDirectory == null ? '$path/$fileName' : '$path/$subDirectory/$fileName';
    file = await File(filePath).create(recursive: true);

    if (!await file.exists()) file.create();

    await file.writeAsString(data);
  }
  return {'path': filePath, 'file': file};
}

shareFile(String path, String type) {
  ShareExtend.share(path, "file");
}

openFile(String path, String type) {
  Map<String, String> knowExtensions = {
    ".gpx": "application/gpx+xml",
    ".kml": "application/vnd.google-earth.kml+xml",
    ".kmz": "application/vnd.google-earth.kmz",
  };
  Map<String, String> knowUtiExtensions = {
    ".gpx": "com.topografix.gpx",
    ".kml": "com.google.earth.kml",
  };

  if (type != null) {
    type = type.toLowerCase();
    OpenFile.open(path,
        type: knowExtensions.containsKey(type) ? knowExtensions[type] : null,
        uti: knowUtiExtensions.containsKey(type) ? knowUtiExtensions[type] : null);
  } else
    OpenFile.open(path);
}

Future<Uint8List> readByteDataFromFile(String fileName) async {
  var fileIn = File(fileName);
  return fileIn.readAsBytes();
}

Future<String> readStringFromFile(String fileName) async {
  var fileIn = File(fileName);
  return fileIn.readAsString();
}
