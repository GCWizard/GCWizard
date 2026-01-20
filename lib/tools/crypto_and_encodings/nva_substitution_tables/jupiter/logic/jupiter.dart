import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/_common/logic/common.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _AZToJupiter = {
  'A': '0', 'E': '1', 'I': '2', 'N': '3', 'R': '4', 'S': '5',
  'B': '71', 'C': '72', 'D': '73', 'F': '74',
  'G': '75', 'H': '76', 'J': '77', 'K': '78', 'L': '79', 'M': '80',
  'O': '81', 'P': '83', 'Q': '84', 'T': '86',
  'U': '87', 'V': '95', 'W': '96', 'X': '97', 'Y': '98',
  'Z': '99',
  '\u00C4': '70', // Ä
  '\u00D6': '82', // Ö
  '\u00DC': '88', // Ü
  '\u00DF': '85', // ß
  '.': '90',
};
final Map<String, String> _JupiterToAZ = switchMapKeyValue(_AZToJupiter);

const Map<String, String> _NumbersToJupiter = {
  ':': '93',
  '.': '90',
  '-': '92',
  '+': '91',
  '(': '94',
  ')': '94',
  '0': '000',
  '1': '111',
  '2': '222',
  '3': '333',
  '4': '444',
  '5': '555',
  '6': '666',
  '7': '777',
  '8': '888',
  '9': '999'
};
final Map<String, String> _JupiterToNumbers =
    switchMapKeyValue(_NumbersToJupiter);

const _LETTERS_NUMBER_SWITCH = '89';
const _CODE_FOLLOW = '6';
const _FILLING = '90';

String _encodeJupiter(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input
      .split('')
      .where((char) =>
          _AZToJupiter[char] != null || _NumbersToJupiter[char] != null)
      .join();

  var isLetterMode = true;
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
      if (isLetterMode) {
        var character = _AZToJupiter[input[i]];
        if (character != null) {
          out.add(character);
          i++;
          continue;
        } else {
          character = _NumbersToJupiter[input[i]];
          if (character != null) {
            out.add(_LETTERS_NUMBER_SWITCH);
            out.add(character);
            isLetterMode = false;
            i++;
            continue;
          }
        }
      } else {
        var character = _NumbersToJupiter[input[i]];
        if (character != null) {
          out.add(character);
          i++;
          continue;
        } else {
          character = _AZToJupiter[input[i]];
          if (character != null) {
            out.add(_LETTERS_NUMBER_SWITCH);
            out.add(character);
            isLetterMode = true;
            i++;
            continue;
          }
        }
      }
    }
  }

  var output = out.join();

  //fill to dividable by 5
  if (output.length % 5 != 0 && !isLetterMode) {
    output += _LETTERS_NUMBER_SWITCH;
  }
  while (output.length % 5 != 0) {
    output += _FILLING;
  }

  return output;
}

String encryptJupiter(String input, String? keyOneTimePad) {
  if (input.isEmpty) return '';

  var output = _encodeJupiter(input);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String _decodeJupiter(String input) {
  if (input.isEmpty) return '';

  var isLetterMode = true;
  String out = '';

  int i = 0;
  while (i < input.length) {
    String? character;
    var code = input.substring(i, i + 1);
    if (code == _CODE_FOLLOW) {
      if (i + 4 < input.length) {
        code = input.substring(i + 1, i + 4);
        character = CodeToTITANZ[code];
        if (character != null) {
          out += character;
        } else {
          out += UNKNOWN_ELEMENT;
        }
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
        if (code == _LETTERS_NUMBER_SWITCH) {
          isLetterMode = !isLetterMode;
          i += 2;
          continue;
        } else {
          if (isLetterMode) {
            character = _JupiterToAZ[code];
            if (character != null) {
              out += character;
              i += 2;
              continue;
            } else {
              code = input.substring(i, i + 1);
              character = _JupiterToAZ[code];
              if (character != null) {
                out += character;
                i += 1;
                continue;
              }
            }
          } else {
            code = input.substring(i, i + 3);
            character = _JupiterToNumbers[code];
            if (character != null) {
              out += character;
              i += 3;
              continue;
            } else {
              out += UNKNOWN_ELEMENT;
              i += 2;
              continue;
            }
          }
        }
      } else {
        out += UNKNOWN_ELEMENT;
        i++;
        continue;
      }
    }
  }

  return out.trim();
}

String decryptJupiter(String input, String? keyOneTimePad) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = subtractOneTimePad(input, keyOneTimePad);
  }

  return _decodeJupiter(input);
}
