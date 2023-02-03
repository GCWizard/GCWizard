part of 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';

String _steganoPadKey(String key) {
  if (key.length > 32) {
    throw Exception('cryption_key_length_greater_than_32');
  }
  String paddedKey = key;
  int padCnt = 32 - key.length;
  for (int i = 0; i < padCnt; ++i) {
    paddedKey += '#';
  }
  return paddedKey;
}
