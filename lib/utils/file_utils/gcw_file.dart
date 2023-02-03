import 'dart:typed_data';

import 'package:gc_wizard/utils/file_utils/file_utils.dart' as utils;

class GCWFile {
  GCWFile({this.path, this.name, this.bytes, this.children}) {
    if (this.children == null) this.children = [];
  }

  /// The absolute path for a cached copy of this file. It can be used to create a
  /// file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  final String path;

  /// File name including its extension.
  final String name;

  /// Option to save extracted files if file is archive
  List<GCWFile> children;

  /// Byte data for this file. Particurlarly useful if you want to manipulate its data
  /// or easily upload to somewhere else.
  final Uint8List bytes;

  utils.FileType get fileType => utils.getFileType(bytes);

  /// File extension for this file.
  String get extension => (name == null) ? null : name.split('.').last;

  utils.FileClass get fileClass => utils.fileClass(fileType);

  @override
  String toString() {
    return {'path: $path; name: $name; bytes: ${bytes?.length}; children: $children'}.toString();
  }
}
