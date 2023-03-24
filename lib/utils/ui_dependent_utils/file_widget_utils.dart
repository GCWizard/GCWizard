import 'dart:typed_data';

import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/permissions/storage.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:universal_html/html.dart' as html;

Future<bool> saveByteDataToFile(BuildContext context, Uint8List data, String fileName) async {
  if (kIsWeb) {
    var blob = html.Blob([data], 'image/png');
    html.AnchorElement(
      href: html.Url.createObjectUrl(blob),
    )
      ..setAttribute("download", fileName)
      ..click();

    return Future.value(true);
  } else {
    var storagePermission = await checkStoragePermission();
    if (!storagePermission) {
      showToast(i18n(context, 'common_exportfile_nowritepermission'));
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
      showToast(i18n(context, 'common_exportfile_couldntwrite'));
      return false;
    }
  }

  return true;
}

Future<bool> saveStringToFile(BuildContext context, String data, String fileName) async {
  if (kIsWeb) {
    var blob = html.Blob([data], 'text/plain', 'native');
    html.AnchorElement(
      href: html.Url.createObjectUrl(blob),
    )
      ..setAttribute("download", fileName)
      ..click();

    return true;
  } else {
    var storagePermission = await checkStoragePermission();
    if (!storagePermission) {
      showToast(i18n(context, 'common_exportfile_nowritepermission'));
      return false;
    }

    fileName = _limitFileNameLength(fileName);
    final fileInfo = await FilePickerWritable().openFileForCreate(
      fileName: fileName,
      writer: (file) async {
        await file.writeAsString(data);
      },
    );
    if (fileInfo == null) return false;
  }

  return true;
}

String _limitFileNameLength(String fileName) {
  const int maxLength = 30;
  if (fileName.length <= maxLength) return fileName;
  var extension = getFileExtension(fileName);
  return getFileBaseNameWithoutExtension(fileName).substring(0, maxLength - extension.length) + extension;
}