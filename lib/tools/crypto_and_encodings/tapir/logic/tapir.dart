import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _AZToTapir = {
  ' ': '83', '\n': '80', 'A': '0', 'E': '1', 'I': '2', 'N': '3', 'R': '4', 'B': '50', 'BE': '51', 'C': '52', 'CH': '53',
  'D': '54', 'DE': '55', 'F': '56',
  'G': '57', 'GE': '58', 'H': '59', 'J': '60', 'K': '61', 'L': '62', 'M': '63', 'O': '64', 'P': '67', 'Q': '68',
  'S': '69', 'T': '70',
  'TE': '71', 'U': '72', 'UN': '73', 'V': '74', 'W': '76', 'X': '77', 'Y': '78', 'Z': '79',
  '\u00C4': '66', // Ä
  '\u00D6': '88', // Ö
  '\u00DC': '99', // Ü
  '\u00DF': '65', // ß
};
final Map<String, String> _TapirToAZ = switchMapKeyValue(_AZToTapir);

const Map<String, String> _NumbersToTapir = {
  ' ': '83',
  '\n': '80',
  '.': '89',
  ':': '90',
  ',': '91',
  '-': '92',
  '/': '93',
  '(': '94',
  ')': '95',
  '+': '96',
  '=': '97',
  '"': '98',
  '0': '00',
  '1': '11',
  '2': '22',
  '3': '33',
  '4': '44',
  '5': '55',
  '6': '66',
  '7': '77',
  '8': '88',
  '9': '99'
};
final Map<String, String> _TapirToNumbers = switchMapKeyValue(_NumbersToTapir);

const _NUMBERS_FOLLOW = '82';
const _LETTERS_FOLLOW = '81';
const _FILLING = '83';

String _encodeTapir(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input.split('').where((char) => _AZToTapir[char] != null || _NumbersToTapir[char] != null).join();

  var isLetterMode = true;
  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    String? code;

    if (isLetterMode && i + 1 < input.length) {
      code = _AZToTapir[input.substring(i, i + 2)];
      if (code != null) {
        out.add(code);
        i += 2;
        continue;
      }
    }

    var character = input[i++];

    if (isLetterMode) {
      var code = _AZToTapir[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _NumbersToTapir[character];
        if (code != null) {
          out.add(_NUMBERS_FOLLOW);
          out.add(code);
          isLetterMode = false;
        }
      }
    } else {
      var code = _NumbersToTapir[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _AZToTapir[character];
        if (code != null) {
          out.add(_LETTERS_FOLLOW);
          out.add(code);
          isLetterMode = true;
        }
      }
    }
  }

  var output = out.join();

  //fill to dividable by 5
  var isFirstFillingLetter = true;
  while (output.length % 5 != 0) {
    output += _FILLING[isFirstFillingLetter ? 0 : 1];
    isFirstFillingLetter = !isFirstFillingLetter;
  }

  return output;
}

String _addOneTimePad(String input, String keyOneTimePad) {
  keyOneTimePad = keyOneTimePad.replaceAll(RegExp(r'\D'), '');
  if (keyOneTimePad.isEmpty) return input;

  var out = '';
  for (int i = 0; i < input.length; i++) {
    if (i >= keyOneTimePad.length) {
      out += input[i];
      continue;
    }

    int a = int.tryParse(input[i]) ?? 0;
    int b = int.tryParse(keyOneTimePad[i]) ?? 0;

    out += ((a + b) % 10).toString();
  }

  return out;
}

String encryptTapir(String input, String? keyOneTimePad) {
  if (input.isEmpty) return '';

  var output = _encodeTapir(input);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = _addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String? _checkCode(String code, bool isLetterMode) {
  return isLetterMode ? _TapirToAZ[code] : _TapirToNumbers[code];
}

String _decodeTapir(String input) {
  if (input.isEmpty) return '';

  var isLetterMode = true;
  String out = '';

  int i = 0;
  while (i < input.length) {
    String? character;

    if (i + 1 < input.length) {
      var code = input.substring(i, i + 2);

      if (code == _LETTERS_FOLLOW) {
        isLetterMode = true;
        i += 2;
        continue;
      }

      if (code == _NUMBERS_FOLLOW) {
        isLetterMode = false;
        i += 2;
        continue;
      }

      character = _checkCode(code, isLetterMode);
      if (character != null) {
        out += character;
        i += 2;
        continue;
      }
    }

    character = _checkCode(input[i++], isLetterMode);
    if (character != null) out += character;
  }

  return out.trim();
}

String _subtractOneTimePad(String input, String keyOneTimePad) {
  keyOneTimePad = keyOneTimePad.replaceAll(RegExp(r'\D'), '');
  if (keyOneTimePad.isEmpty) return input;

  var out = '';
  for (int i = 0; i < input.length; i++) {
    if (i >= keyOneTimePad.length) {
      out += input[i];
      continue;
    }

    int a = int.tryParse(input[i]) ?? 0;
    int b = int.tryParse(keyOneTimePad[i]) ?? 0;

    out += ((a - b) % 10).toString();
  }

  return out;
}

String decryptTapir(String input, String? keyOneTimePad) {

  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = _subtractOneTimePad(input, keyOneTimePad);
  }

  return _decodeTapir(input);
}
