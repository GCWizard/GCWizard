import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart' as local;
import 'package:gc_wizard/tools/images_and_files/exif_reader/logic/exif_reader.dart';
import 'package:latlong2/latlong.dart';

runSamplesTest(FileSystemEntity file) async {
  Uint8List content = _getFileData(file.path);

  var tags = await readExifFromBytes(content);
  expect(tags.length, isNonZero);
}

runSamplesTestGps(
  FileSystemEntity file,
  double expectedLatitude,
  double expectedLongitude,
) async {
  //Uint8List content = _getFileData(file.path);

  local.GCWFile platformFile = local.GCWFile(path: file.path);
  // Uint8List content = await getFileData(platformFile);
  // var tags = await readExifFromBytes(content);

  var tags = await parseExif(platformFile);
  expect(tags.length, isNonZero);
  expect(tags, contains("GPS GPSLatitude"));
  var lat = tags["GPS GPSLatitude"];

  LatLng _point = completeGPSData(tags);
  expect(_point, isNotNull);
  expect(_point.latitude, equals(expectedLatitude));
  expect(_point.longitude, equals(expectedLongitude));
}

Uint8List _getFileData(String path) {
  File file = File(path);
  return file.readAsBytesSync();
}
