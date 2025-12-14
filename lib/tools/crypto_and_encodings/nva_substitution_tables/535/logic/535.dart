import 'package:gc_wizard/utils/collection_utils.dart';
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
};
final Map<String, String> _535ToAZ = switchMapKeyValue(_AZTo535);

const Map<String, String> _NumbersTo535 = {
  ':': '85',
  '.': '87',
  ',': '88',
  '-': '89',
  '/': '86',
  '(': '84',
  ')': '84',
};
final Map<String, String> _535ToNumbers = switchMapKeyValue(_NumbersTo535);

const _NUMBERS_FOLLOW = '9';
const _LETTERS_FOLLOW = '9';
const _FILLING = '87';

String _encode535(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input
      .split('')
      .where((char) => _AZTo535[char] != null || _NumbersTo535[char] != null)
      .join();

  var isLetterMode = true;
  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    String? code;

    if (isLetterMode && i + 1 < input.length) {
      code = _AZTo535[input.substring(i, i + 2)];
      if (code != null) {
        out.add(code);
        i += 2;
        continue;
      }
    }

    var character = input[i++];

    if (isLetterMode) {
      var code = _AZTo535[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _NumbersTo535[character];
        if (code != null) {
          out.add(_NUMBERS_FOLLOW);
          out.add(code);
          isLetterMode = false;
        }
      }
    } else {
      var code = _NumbersTo535[character];
      if (code != null) {
        out.add(code);
      } else {
        code = _AZTo535[character];
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

String encrypt535(String input, String? keyOneTimePad) {
  if (input.isEmpty) return '';

  var output = _encode535(input);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = _addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String? _checkCode(String code, bool isLetterMode) {
  return isLetterMode ? _535ToAZ[code] : _535ToNumbers[code];
}

String _decode535(String input) {
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

String decrypt535(String input, String? keyOneTimePad) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = _subtractOneTimePad(input, keyOneTimePad);
  }

  return _decode535(input);
}
