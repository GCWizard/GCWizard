import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

final AZToTapir = {
  ' ': '83', '\n': '80', 'A': '0', 'E': '1', 'I': '2', 'N': '3', 'R': '4', 'B': '50', 'BE': '51', 'C': '52', 'CH': '53',
  'D': '54', 'DE': '55', 'F': '56',
  'G': '57', 'GE': '58', 'H': '59', 'J': '60', 'K': '61', 'L': '62', 'M': '63', 'O': '64', 'P': '67', 'Q': '68',
  'S': '69', 'T': '70',
  'TE': '71', 'U': '72', 'UN': '73', 'V': '74', 'W': '76', 'X': '77', 'Y': '78', 'Z': '79',
  String.fromCharCode(196): '66', // Ä
  String.fromCharCode(214): '88', // Ö
  String.fromCharCode(220): '99', // Ü
  String.fromCharCode(223): '65', // ß
};
final TapirToAZ = switchMapKeyValue(AZToTapir);

final NumbersToTapir = {
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
final TapirToNumbers = switchMapKeyValue(NumbersToTapir);

final _NUMBERS_FOLLOW = '82';
final _LETTERS_FOLLOW = '81';
final _FILLING = '83';

String _encodeTapir(String input) {
  //remove non-encodable chars
  input = input.toUpperCase();
  input = input.split('').where((char) => AZToTapir[char] != null || NumbersToTapir[char] != null).join();

  var isLetterMode = true;
  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    var code;

    if (isLetterMode && i + 1 < input.length) {
      code = AZToTapir[input.substring(i, i + 2)];
      if (code != null) {
        out.add(code);
        i += 2;
        continue;
      }
    }

    var character = input[i++];

    if (isLetterMode) {
      var code = AZToTapir[character];
      if (code != null) {
        out.add(code);
      } else {
        code = NumbersToTapir[character];
        if (code != null) {
          out.add(_NUMBERS_FOLLOW);
          out.add(code);
          isLetterMode = false;
        }
      }
    } else {
      var code = NumbersToTapir[character];
      if (code != null) {
        out.add(code);
      } else {
        code = AZToTapir[character];
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
  keyOneTimePad = keyOneTimePad.replaceAll(RegExp(r'[^0-9]'), '');
  if (keyOneTimePad.length == 0) return input;

  var out = '';
  for (int i = 0; i < input.length; i++) {
    if (i >= keyOneTimePad.length) {
      out += input[i];
      continue;
    }

    int a = int.tryParse(input[i]);
    int b = int.tryParse(keyOneTimePad[i]);

    out += ((a + b) % 10).toString();
  }

  return out;
}

String encryptTapir(String input, String keyOneTimePad) {
  if (input == null || input.length == 0) return '';

  var output = _encodeTapir(input);

  if (keyOneTimePad != null && keyOneTimePad.length > 0) {
    output = _addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String _checkCode(String code, bool isLetterMode) {
  return isLetterMode ? TapirToAZ[code] : TapirToNumbers[code];
}

String _decodeTapir(String input) {
  if (input == null || input.length == 0) return '';

  var isLetterMode = true;
  String out = '';

  int i = 0;
  while (i < input.length) {
    var character;

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
  keyOneTimePad = keyOneTimePad.replaceAll(RegExp(r'[^0-9]'), '');
  if (keyOneTimePad.length == 0) return input;

  var out = '';
  for (int i = 0; i < input.length; i++) {
    if (i >= keyOneTimePad.length) {
      out += input[i];
      continue;
    }

    int a = int.tryParse(input[i]);
    int b = int.tryParse(keyOneTimePad[i]);

    out += ((a - b) % 10).toString();
  }

  return out;
}

String decryptTapir(String input, String keyOneTimePad) {
  if (input == null) return '';

  input = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (input.length == 0) return '';

  if (keyOneTimePad != null && keyOneTimePad.length > 0) {
    input = _subtractOneTimePad(input, keyOneTimePad);
  }

  return _decodeTapir(input);
}
