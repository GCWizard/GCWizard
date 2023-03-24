import 'dart:io' as io;

import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/images_and_files/exif_reader/resources/';

List<io.FileSystemEntity> readSamples() {
  io.Directory dir = io.Directory(testDirPath);
  Set<String> allowedExtensions = {'.jpg', '.tiff'};
  var files = dir.listSync(recursive: true).where((file) => (allowedExtensions.contains(getFileExtension(file.path))));
  return files.toList();
}

List<FileSample> readSampleTest1() {
  String _path = path.join(testDirPath, 'test1.jpg');
  io.File _file = io.File(_path);
  return [FileSample(_file, 37.885, -122.6225)];
}

List<FileSample> readSampleTest2() {
  String _path = path.join(testDirPath, 'test2.jpg');
  io.File _file = io.File(_path);
  return [FileSample(_file, 0, 0)];
}

class FileSample {
  io.File file;
  double expectedLatitude;
  double expectedLongitude;

  FileSample(this.file, this.expectedLatitude, this.expectedLongitude);
}
