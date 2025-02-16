import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart' as local;
import 'package:image/image.dart';

part 'package:gc_wizard/tools/images_and_files/stegano/logic/requests/stegano_base_request.dart';
part 'package:gc_wizard/tools/images_and_files/stegano/logic/requests/stegano_decode_request.dart';
part 'package:gc_wizard/tools/images_and_files/stegano/logic/requests/stegano_encode_request.dart';
part 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano_decoder.dart';
part 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano_encoder.dart';
part 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano_pad_key.dart';

const int MAX_LENGTH = 5000;

Future<Uint8List?> encodeStegano(local.GCWFile file, String message, String key, String? filename) async {
  Uint8List data = file.bytes;
  // the key is use to encrypt your message with AES256 algorithm
  var request = _SteganoEncodeRequest(data, message, key: key, filename: filename);
  var response = await _encodeSteganoMessageIntoImageAsync(request);
  return response;
}

Future<String?> decodeStegano(local.GCWFile file, String key) async {
  Uint8List data = file.bytes;
  // the key is use to decrypt your encrypted message with AES256 algorithm
  _SteganoDecodeRequest request = _SteganoDecodeRequest(data, key: key);
  var response = await _decodeSteganoMessageFromImageAsync(request);
  if (response != null && response.length > MAX_LENGTH) {
    throw Exception('abnormal_length_nothing_to_decode');
  }
  return response;
}
