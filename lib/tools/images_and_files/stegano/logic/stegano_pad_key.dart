part of 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';

String _steganoPadKey(String key) {
  if (key.length > 32) {
    throw Exception('cryption_key_length_greater_than_32');
  }
  return key.padRight(32, '\x00');
}
