import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/_common/logic/common.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _AZTo535 = {
  'A': '0', 'E': '1', 'I': '2', 'N': '3', 'R': '4', 'S': '5',
  'B': '60', 'C': '61', 'D': '62', 'F': '63',
  'G': '64', 'H': '65', 'J': '66', 'K': '67', 'L': '68', 'M': '69',
  'O': '70', 'P': '71', 'Q': '72', 'T': '73',
  'U': '74', 'V': '75', 'W': '76', 'X': '77', 'Y': '78',
  'Z': '79',
  '\u00C4': '80', // Ä
  '\u00D6': '81', // Ö
  '\u00DC': '82', // Ü
  '\u00DF': '83', // ß
  ':': '85',
  '.': '87',
  ',': '88',
  '-': '89',
  '/': '86',
  '(': '84',
  ')': '84',
};
final Map<String, String> _535ToAZ = switchMapKeyValue(_AZTo535);

const _CODE_FOLLOW = '9';
const _FILLING = '87';

String _encode535(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input.split('').where((char) => _AZTo535[char] != null).join();

  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    String? code = codebook(input, i, TITANZToCode);
    if (code != null) {
      out.add(_CODE_FOLLOW);
      out.add(TITANZToCode[code]!);
      i += code.length;
    } else {
      out.add(_AZTo535[input[i]]!);
      i++;
    }
  }

  var output = out.join();

  //fill to dividable by 5
  if (output.length % 5 != 0) {
    output += _FILLING;
  }
  while (output.length % 5 != 0) {
    output += _FILLING;
  }

  return output;
}

String encrypt535(String input, String? keyOneTimePad) {
  if (input.isEmpty) return '';

  var output = _encode535(input);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String _decode535(String input) {
  if (input.isEmpty) return '';

  String out = '';

  int i = 0;
  while (i < input.length) {
    String? character;
    var code = input.substring(i, i + 1);
    if (code == _CODE_FOLLOW) {
      if (i + 4 < input.length) {
        code = input.substring(i + 1, i + 4);
        character = CodeToTITANZ[code];
        out += character ?? UNKNOWN_ELEMENT;
        i += 4;
        continue;
      } else {
        out += UNKNOWN_ELEMENT;
        i++;
        continue;
      }
    } else {
      if (i + 1 < input.length) {
        code = input.substring(i, i + 2);

        character = _535ToAZ[code];
        if (character != null) {
          out += character;
          i += 2;
          continue;
        } else {
          code = input.substring(i, i + 1);
          character = _535ToAZ[code];
          if (character != null) {
            out += character;
            i += 1;
            continue;
          }
        }
      }
    }
  }

  return out.trim();
}

String decrypt535(String input, String? keyOneTimePad) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = subtractOneTimePad(input, keyOneTimePad);
  }

  return _decode535(input);
}
