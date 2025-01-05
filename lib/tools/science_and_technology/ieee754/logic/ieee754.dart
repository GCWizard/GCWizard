import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

String encodeIEEE754(double number, bool bitLength32) {
  var byteData = ByteData(8);
  if (bitLength32) {
    byteData.setFloat32(0, number);
  } else {
    byteData.setFloat64(0, number);
  }
  var bytes = byteData.buffer.asUint8List();
  String result = bytes.map((b) => b.toRadixString(2).padLeft(8, '0')).join();

  if (bitLength32) {
    result = result.substring(0, 32);
  }

  return result;
}

double decodeIEEE754(String binary) {
  num result;

  switch (binary.length) {
    case 16:
      result = _decode(binary, 5, 10);
      break;
    case 32:
      result = _decode(binary, 8, 23);
      break;
    case 64:
      result = _decode(binary, 11, 52);
      break;
    case 128:
      result = _decode(binary, 15, 112);
      break;
    default:
      result = 0.0;
  }
  return result.toDouble();
}

num _decode(String binary, int eBits, int mBits) {
  num result = 0.0;
  int s = binary[0] == '1' ? -1 : 1;
  num b = pow(2, eBits - 1) - 1;
  num e = int.parse(convertBase(binary.substring(1, eBits + 1), 2, 10)) - b;
  num m = int.parse(convertBase(binary.substring(eBits), 2, 10)) / pow(2, mBits);
  if (m < 1) m = m + 1;

  result = s * pow(2, e) * m;

  return result;
}
