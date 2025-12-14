import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _AZToZebra = {
  ' ': '86', 'A': '0', 'E': '1', 'I': '2', 'N': '3',
  'AU': '41', 'B': '42', 'BE': '43', 'C': '44', 'CH': '45',
  'D': '46', 'DE': '47', 'DER': '48', 'ER': '49', 'F': '50',
  'G': '51', 'GE': '52', 'H': '53', 'J': '54', 'K': '55', 'L': '56', 'M': '57',
  'O': '58', 'P': '60', 'Q': '61', 'R': '62', 'RE': '63', 'S': '64',
  'SCH': '65', 'SE': '66', 'ST': '67', 'SU': '68', 'T': '69',
  'TE': '70', 'U': '71', 'UNG': '73', 'V': '74', 'W': '76', 'X': '77',
  'Y': '78',
  'Z': '79',
  '.': '80',
  ':': '81',
  ',': '82',
  '-': '83',
  '/': '84',
  '(': '85',
  ')': '87',
  '"': '88',
  '\u00C4': '40', // Ä
  '\u00D6': '59', // Ö
  '\u00DC': '72', // Ü
};
final Map<String, String> _ZebraToAZ = switchMapKeyValue(_AZToZebra);

const Map<String, String> _NumbersToZebra = {
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
final Map<String, String> _ZebraToNumbers = switchMapKeyValue(_NumbersToZebra);

const _LETTERS_NUMBER_SWITCH = '89';
const _FILLING = '86';

String _encodeZebra(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input
      .split('')
      .where(
          (char) => _AZToZebra[char] != null || _NumbersToZebra[char] != null)
      .join();

  var isLetterMode = true;
  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    String? code;

    if (isLetterMode && i + 1 < input.length) {
      code = _AZToZebra[input.substring(i, i + 2)];
      if (code != null) {
        out.add(code);
        i += 2;
        continue;
      }
    }

    var character = input[i++];

    if (isLetterMode) {
      var code = _AZToZebra[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _NumbersToZebra[character];
        if (code != null) {
          out.add(_LETTERS_NUMBER_SWITCH);
          out.add(code);
          isLetterMode = false;
        }
      }
    } else {
      var code = _NumbersToZebra[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _AZToZebra[character];
        if (code != null) {
          out.add(_LETTERS_NUMBER_SWITCH);
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

String encryptZebra(String input, String? keyOneTimePad) {
  if (input.isEmpty) return '';

  var output = _encodeZebra(input);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = _addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String? _checkCode(String code, bool isLetterMode) {
  return isLetterMode ? _ZebraToAZ[code] : _ZebraToNumbers[code];
}

String _decodeZebra(String input) {
  if (input.isEmpty) return '';

  var isLetterMode = true;
  String out = '';

  int i = 0;
  String code = '';
  while (i < input.length) {
    String? character;

    if (i + 2 < input.length && !isLetterMode) {
      code = input.substring(i, i + 2);
      if (code == _LETTERS_NUMBER_SWITCH) {
        isLetterMode = !isLetterMode;
        i += 2;
        continue;
      }
      code = input.substring(i, i + 3);
      character = _checkCode(code, isLetterMode);
      i += 3;
      if (character != null) {
        out += character;
        //i += 3;
        continue;
      }
    }

    if (i + 1 < input.length) {
      code = input.substring(i, i + 2);

      if (code == _LETTERS_NUMBER_SWITCH) {
        isLetterMode = !isLetterMode;
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

    character = _checkCode(input[i], isLetterMode);
    if (character != null) {
      out += character;
    }
    i++;
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

String decryptZebra(String input, String? keyOneTimePad) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = _subtractOneTimePad(input, keyOneTimePad);
  }

  return _decodeZebra(input);
}
