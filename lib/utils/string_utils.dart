import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:gc_wizard/utils/alphabets.dart';

int extractIntegerFromText(String text, {bool allowNegative = true}) {
  var digits = text.replaceAll(RegExp(r'[^\-0-9]'), '');

  bool signed = false;
  if (allowNegative) {
    signed = digits.startsWith('-');
  }
  digits = digits.replaceAll('-', '');

  if (digits.isEmpty) return 0;

  return int.parse(digits) * (signed ? -1 : 1);
}

String normalizeUmlauts(String input) {
  return input.split('').map((letter) {
    if (letter == '\u00DF') {
      //ß
      return 'ss';
    }
    if (letter == '\u1E9E') {
      //ẞ
      return 'SS';
    }

    var isLowerCase = letter == letter.toLowerCase();

    String out;
    switch (letter.toLowerCase().codeUnitAt(0)) {
      case 228: //ä
      case 230: //æ
        out = 'ae';
        break;
      case 246: //ö
        out = 'oe';
        break;
      case 252: //ü
        out = 'ue';
        break;
      default:
        out = letter;
    }

    return isLowerCase ? out : out.toUpperCase();
  }).join();
}

String removeAccents(String text) {
  String out = normalizeUmlauts(text);
  return removeDiacritics(out);
}

String removeNonLetters(String text) {
  return text.replaceAll(RegExp(r'[^A-Za-z]'), '');
}

String insertCharacter(String text, int index, String character) {
  if (index < 0) index = 0;

  if (index > text.length) index = text.length;

  return text.substring(0, index) + character + text.substring(index);
}

String insertSpaceEveryNthCharacter(String input, int n) {
  return insertEveryNthCharacter(input, n, ' ');
}

String insertEveryNthCharacter(String input, int n, String textToInsert) {
  if (n <= 0) return input;

  String out = '';
  int i = 0;
  while (i < input.length) {
    if (input.length - i <= n) {
      out += input.substring(i);
      break;
    }

    out += input.substring(i, min(i + n, input.length)) + textToInsert;
    i += n;
  }

  return out;
}

bool isUpperCase(String letter) {
  if (letter.isEmpty) return false;
  if (letter == 'ß') return false;
  if (letter == 'ẞ') return true; // Capital ß

  return (letter.toUpperCase() == letter);
}

String removeDuplicateCharacters(String input) {
  return input.split('').toSet().join();
}

bool hasDuplicateCharacters(String input) {
  return input != removeDuplicateCharacters(input);
}

int countCharacters(String input, String characters) {
  return input.replaceAll(RegExp('[^$characters]'), '').length;
}

bool allSameCharacters(String input) {
  if (input.isEmpty) return false;

  var firstCharacter = input[0];
  return input.replaceAll(firstCharacter, '').isEmpty;
}

bool isOnlyLetters(String input) {
  if (input.isEmpty) return false;

  return removeAccents(input).replaceAll(RegExp(r'[A-Za-z]'), '').isEmpty;
}

bool isOnlyNumerals(String input) {
  if (input.isEmpty) return false;

  return input.replaceAll(RegExp(r'\d'), '').isEmpty;
}

String removeControlCharacters(String input) {
  if (input.isEmpty) {
    return input;
  }

  var removedCodes = input.codeUnits.where((element) => element >= 32).toList();
  return String.fromCharCodes(removedCodes);
}

String normalizeCharacters(String input) {
  if (input.isEmpty) {
    return input;
  }

  const Map<String, String> _ALTERNATE_CHARACTERS = {
    // https://www.compart.com/de/unicode/category/Zs and Tab
    ' ': '\u0009\u000B\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2007\u2008\u2009\u200A\u202F\u205F\u3000',
    '"': '\u201e\u201f\u201d\u201c',
    '\'': '\u201b\u201a\u2019\u2018',
    '-': '\u2014\u2013\u02d7\u2212\u2012',
  };

  _ALTERNATE_CHARACTERS.forEach((key, value) {
    input = input.replaceAll(RegExp('[$value]'), key);
  });

  return input;
}

List<String> allCharacters() {
  var characters = <String>[];
  for (var alphabet in ALL_ALPHABETS) {
    characters.addAll(alphabet.alphabet.keys);
  }
  return characters.toSet().toList();
}

String enumName(String fullName) {
  return fullName.split('.').last;
}

String formatStringForDecimals({int integerPrecision = 2, int decimalPrecision = 6, int minDecimalPrecision = 3}) {
  var formatString = '0' * max(1, integerPrecision) + '.';
  if (decimalPrecision < 1) decimalPrecision = 1;
  if (minDecimalPrecision < 1) minDecimalPrecision = 1;

  if (decimalPrecision <= minDecimalPrecision) {
    formatString += '0' * decimalPrecision;
  } else {
    formatString += '0' * minDecimalPrecision + '#' * (decimalPrecision - minDecimalPrecision);
  }

  return formatString;
}

String trimCharactersLeft(String text, String characters) {
  if (characters.isEmpty || text.isEmpty) {
    return text;
  }

  var i = 0;

  while (text.length > i && text.substring(i).startsWith(characters)) {
    i += characters.length;
  }

  return text.substring(i);
}

String trimCharactersRight(String text, String characters) {
  if (characters.isEmpty || text.isEmpty) {
    return text;
  }

  while (text.length >= characters.length && text.endsWith(characters)) {
    text = text.substring(0, text.length - characters.length);
  }

  return text;
}
