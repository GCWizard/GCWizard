// https://de.wikipedia.org/wiki/Upside_Down_Text
// https://en.wikipedia.org/wiki/Transformation_of_text#Upside-down_text

import 'package:gc_wizard/utils/collection_utils.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/upsidedown/logic/upsidedown_data.dart';

String decodeUpsideDownText(String input) {
  String result = '';
  input = input.replaceAll('ſ̣', 'j').split('').reversed.join('');

  for (int i = 0; i < input.length; i++) {
    if (_DECODE_FLIP_ROTATE[input[i]].toString() != 'null') {
      result += _DECODE_FLIP_ROTATE[input[i]].toString();
    } else {
      result += input[i];
    }
  }

  return result;
}

String encodeUpsideDownText(String input) {
  String result = '';
  input = input.split('').reversed.join('');

  for (int i = 0; i < input.length; i++) {
    if (_ENCODE_FLIP_ROTATE[input[i]] != null) {
      result += _ENCODE_FLIP_ROTATE[input[i]]!;
    } else {
      result += input[i];
    }
  }

  return result;
}
