import 'package:gc_wizard/utils/collection_utils.dart';
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
final Map<String, String> _JupiterToNumbers = switchMapKeyValue(_NumbersToJupiter);

const _NUMBERS_FOLLOW = '89';
const _LETTERS_FOLLOW = '6';
const _FILLING = '90';

String _encodeJupiter(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input
      .split('')
      .where((char) => _AZToJupiter[char] != null || _NumbersToJupiter[char] != null)
      .join();

  var isLetterMode = true;
  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    String? code;

    if (isLetterMode && i + 1 < input.length) {
      code = _AZToJupiter[input.substring(i, i + 2)];
      if (code != null) {
        out.add(code);
        i += 2;
        continue;
      }
    }

    var character = input[i++];

    if (isLetterMode) {
      var code = _AZToJupiter[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _NumbersToJupiter[character];
        if (code != null) {
          out.add(_NUMBERS_FOLLOW);
          out.add(code);
          isLetterMode = false;
        }
      }
    } else {
      var code = _NumbersToJupiter[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _AZToJupiter[character];
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

String encryptJupiter(String input, String? keyOneTimePad) {
  if (input.isEmpty) return '';

  var output = _encodeJupiter(input);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = _addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String? _checkCode(String code, bool isLetterMode) {
  return isLetterMode ? _JupiterToAZ[code] : _JupiterToNumbers[code];
}

String _decodeJupiter(String input) {
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

String decryptJupiter(String input, String? keyOneTimePad) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = _subtractOneTimePad(input, keyOneTimePad);
  }

  return _decodeJupiter(input);
}
