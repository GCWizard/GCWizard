import 'dart:async';

import 'package:file_picker/file_picker.dart' as filePicker;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:gc_wizard/widgets/utils/file_utils.dart';
import 'package:gc_wizard/widgets/utils/gcw_file.dart' as local;

// Not supported by file picker plugin
const UNSUPPORTED_FILEPICKERPLUGIN_TYPES = [FileType.GPX, FileType.GCW];
final SUPPORTED_IMAGE_TYPES = fileTypesByFileClass(FileClass.IMAGE);

/// Open File Picker dialog
///
/// Returns null if nothing was selected.
///
/// * [allowedFileTypes] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['jpg', 'jpeg']`
Future<local.GCWFile> openFileExplorer({List<FileType> allowedFileTypes}) async {
  try {
    if (_hasUnsupportedTypes(allowedFileTypes)) allowedFileTypes = null;

    var files = (await filePicker.FilePicker.platform.pickFiles(
            type: allowedFileTypes == null ? filePicker.FileType.any : filePicker.FileType.custom,
            allowMultiple: false,
            allowedExtensions:
                allowedFileTypes == null ? null : allowedFileTypes.map((type) => fileExtension(type)).toList()))
        ?.files;

    if (allowedFileTypes == null) files = _filterFiles(files, allowedFileTypes);

    if (files == null || files.length == 0) return null;

    var bytes = await _getFileData(files.first);
    var path = kIsWeb ? null : files.first.path;

    return local.GCWFile(path: path, name: files.first.name, bytes: bytes);
  } on PlatformException catch (e) {
    print("Unsupported operation " + e.toString());
  }
  return null;
}

Future<Uint8List> _getFileData(filePicker.PlatformFile file) async {
  return kIsWeb ? Future.value(file.bytes) : readByteDataFromFile(file.path);
}

List<filePicker.PlatformFile> _filterFiles(List<filePicker.PlatformFile> files, List<FileType> allowedFileTypes) {
  if (files == null || allowedFileTypes == null) return files;

  var allowedExtensions = fileExtensions(allowedFileTypes);

  return files.where((element) => allowedExtensions.contains(element.extension)).toList();
}

bool _hasUnsupportedTypes(List<FileType> allowedExtensions) {
  if (allowedExtensions == null) return false;
  if (kIsWeb) return false;

  for (int i = 0; i < allowedExtensions.length; i++) {
    if (UNSUPPORTED_FILEPICKERPLUGIN_TYPES.contains(allowedExtensions[i])) return true;
  }
  return false;
}
