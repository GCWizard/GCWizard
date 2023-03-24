part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

int START_NUMBEROFOBJECTS = 7;
int START_OBJCETADRESS = 9;
int START_HEADER = 0;
int START_FILES = 0;

const LENGTH_BYTE = 1;
const LENGTH_SHORT = 2;
const LENGTH_USHORT = 2;
const LENGTH_INT = 4;
const LENGTH_LONG = 4;
const LENGTH_DOUBLE = 8;

WherigoStringOffset readString(Uint8List byteList, int offset) {
  // zero-terminated string - 0x00
  String result = '';
  while (byteList[offset] != 0) {
    result = result + String.fromCharCode(byteList[offset]);
    offset++;
  }
  return WherigoStringOffset(result, offset + 1);
}

double readDouble(Uint8List byteList, int offset) {
  // 8 Byte
  Uint8List bytes = Uint8List(8);
  bytes[7] = byteList[offset];
  bytes[6] = byteList[offset + 1];
  bytes[5] = byteList[offset + 2];
  bytes[4] = byteList[offset + 3];
  bytes[3] = byteList[offset + 4];
  bytes[2] = byteList[offset + 5];
  bytes[1] = byteList[offset + 6];
  bytes[0] = byteList[offset + 7];
  return ByteData.sublistView(bytes).getFloat64(0);
}

int readLong(Uint8List byteList, int offset) {
  // 8 Byte
  return (byteList[offset]) +
      byteList[offset + 1] * 256 +
      byteList[offset + 2] * 256 * 256 +
      byteList[offset + 3] * 256 * 256 * 256;
}

int readInt(Uint8List byteList, int offset) {
  // 4 Byte
  return (byteList[offset]) +
      byteList[offset + 1] * 256 +
      byteList[offset + 2] * 256 * 256 +
      byteList[offset + 3] * 256 * 256 * 256;
}

int readShort(Uint8List byteList, int offset) {
  // 2 Byte
  return byteList[offset] + 256 * byteList[offset + 1];
}

int readUShort(Uint8List byteList, int offset) {
  // 2 Byte Little Endian
  return byteList[offset] + 256 * byteList[offset + 1];
}

int readByte(Uint8List byteList, int offset) {
  // 1 Byte
  return byteList[offset];
}

bool isInvalidCartridge(Uint8List byteList) {

  if (byteList.isEmpty) return true;

  // @0000:                      ; Signature
  //        BYTE     0x02        ; Version Major 2
  //        BYTE     0x0a        ;         Minor 10 11
  //        BYTE     "CART"
  //        BYTE     0x00
  String Signature = '';
  Signature = Signature + byteList[0].toString(); // 2
  Signature = Signature + byteList[1].toString(); // 10 or 11
  Signature = Signature + String.fromCharCode(byteList[2]); // C
  Signature = Signature + String.fromCharCode(byteList[3]); // A
  Signature = Signature + String.fromCharCode(byteList[4]); // R
  Signature = Signature + String.fromCharCode(byteList[5]); // T
  if (Signature == '210CART' || Signature == '211CART') {
    return false;
  } else {
    return true;
  }
}
