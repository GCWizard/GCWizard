import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/permissions/storage.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:universal_html/html.dart' as html;

enum _SAVE_TYPE { STRING, BYTE_DATA }

Future<bool> saveByteDataToFile(BuildContext context, Uint8List data, String fileName) async {
  return _saveDataToFile(context, data, fileName, _SAVE_TYPE.BYTE_DATA);
}

Future<bool> saveStringToFile(BuildContext context, String data, String fileName) async {
  return _saveDataToFile(context, convertStringToBytes(data), fileName, _SAVE_TYPE.STRING);
}

Future<bool> _saveDataToFile(BuildContext context, Uint8List data, String fileName, _SAVE_TYPE saveType) async {
  if (kIsWeb) {
    var fileType = fileTypeByFilename(fileName);

    List<String>? _mimeTypes;
    switch (saveType) {
      case _SAVE_TYPE.STRING:
        _mimeTypes = mimeTypes(FileType.TXT);
        break;
      case _SAVE_TYPE.BYTE_DATA:
        if (fileType != null) {
          _mimeTypes = mimeTypes(fileType);
        }
    }

    String? mimeType;
    if (_mimeTypes != null && _mimeTypes.isNotEmpty) {
      mimeType = _mimeTypes.first;
    }

    var blob = html.Blob([data], mimeType);
    html.AnchorElement(
      href: html.Url.createObjectUrl(blob),
    )
      ..setAttribute("download", fileName)
      ..click();

    return true;
  } else {
    var storagePermission = await checkStoragePermission();
    if (!storagePermission) {
      showSnackBar(i18n(context, 'common_exportfile_nowritepermission'), context);
      return false;
    }

    fileName = _limitFileNameLength(fileName);
    final fileInfo = await FilePickerWritable().openFileForCreate(
      fileName: fileName,
      writer: (file) async {
        await file.writeAsBytes(data);
      },
    );
    if (fileInfo == null) {
      showSnackBar(i18n(context, 'common_exportfile_couldntwrite'), context);
      return false;
    }
  }

  return true;
}

String _limitFileNameLength(String fileName) {
  const int maxLength = 30;
  if (fileName.length <= maxLength) return fileName;
  var extension = getFileExtension(fileName);
  return getFileBaseNameWithoutExtension(fileName).substring(0, maxLength - extension.length) + extension;
}
