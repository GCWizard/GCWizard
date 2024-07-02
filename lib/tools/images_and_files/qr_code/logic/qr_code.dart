import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/drawable_image_data.dart';
import 'package:qr/qr.dart' as qr;
import 'package:r_scan/r_scan.dart' as scan;

const defaultErrorCorrectLevel = qr.QrErrorCorrectLevel.L;
const inputTooLongException = 'InputTooLongException';

/// Parse to code string with Uint8list
Future<String?> scanBytes(Uint8List? bytes) async {
  if (bytes == null) return null;
  try {
    var codes = await scan.RScan.scanImageMemory(bytes);
    return Future.value(codes.message);
  } catch (e) {}
  return null;
}

Map<int, String> errorCorrectLevel() {
  return Map.fromEntries(
      qr.QrErrorCorrectLevel.levels.map((level) => MapEntry(level, qr.QrErrorCorrectLevel.getName(level))));
}

/// Generating Bar Code
DrawableImageData? generateBarCode(String code,
    {int moduleSize = 5, int border = 10, int errorCorrectLevel = defaultErrorCorrectLevel, int version = 0}) {
  if (code == '') return null;

  if (!qr.QrErrorCorrectLevel.levels.contains(errorCorrectLevel)) {
    errorCorrectLevel = qr.QrErrorCorrectLevel.L;
  }

  if (version < 0 || version > 40) {
    version = 0;
  }

  qr.QrCode qrCode;

  if (version == 0) {
    qrCode = qr.QrCode.fromData(
      data: code,
      errorCorrectLevel: errorCorrectLevel,
    );
  } else {
    qrCode = qr.QrCode(version, errorCorrectLevel);
    qrCode.addData(code);
  }

  moduleSize = max(1, moduleSize);
  var _colorMap = {'0': COLOR_QR_BACKGROUND.value, '1': colorMap.values.elementAt(1)};

  try {
    var qrImage = _createQrCode(qrCode);
    if (qrImage == null) return null;
    return DrawableImageData(qrImage, _colorMap, bounds: border, pointSize: moduleSize.toDouble());
  } on qr.InputTooLongException catch (e) {
    return DrawableImageData([inputTooLongException, e.providedInput.toString() + ' > ' + e.inputLimit.toString()], {});
  } catch (e) {}
  return null;
}

List<String>? _createQrCode(qr.QrCode qrCode) {
  var qrImage = qr.QrImage(qrCode);
  var lines = <String>[];

  for (int y = 0; y < qrCode.moduleCount; y++) {
    var line = '';
    for (int x = 0; x < qrCode.moduleCount; x++) {
      line += (qrImage.isDark(y, x)) ? '1' : '0';
    }
    lines.add(line);
  }

  return lines;
}
