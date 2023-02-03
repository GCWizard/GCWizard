import 'package:gc_wizard/utils/string_utils.dart';

class Rotator {
  static const defaultAlphabetAlpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const defaultAlphabetDigits = '0123456789';

  String alphabet;

  Rotator({String alphabet = defaultAlphabetAlpha}) {
    this.alphabet = alphabet == null ? '' : alphabet;
  }

  String rotate(String input, int key, {bool removeUnknownCharacters = false, ignoreCase = true}) {
    if (input == null) input = '';

    if (key == null) key = 0;

    if (removeUnknownCharacters == null) removeUnknownCharacters = false;

    if (ignoreCase == null) ignoreCase = false;

    if (ignoreCase) {
      return _rotateIgnoreCase(input, key, removeUnknownCharacters);
    }

    var alphabetLength = alphabet.length;

    return input.split('').map((char) {
      var index = alphabet.indexOf(char);

      if (index >= 0) {
        var newIndex = (index + key) % alphabetLength;
        return alphabet[newIndex];
      }

      return removeUnknownCharacters ? '' : char;
    }).join();
  }

  String _rotateIgnoreCase(String input, int key, bool removeUnknownChars) {
    alphabet = alphabet.toUpperCase();
    var alphabetLength = alphabet.length;

    return input.split('').map((char) {
      var index = alphabet.indexOf(char.toUpperCase());

      if (index >= 0) {
        var newIndex = (index + key) % alphabetLength;
        return isUpperCase(char) ? alphabet[newIndex] : alphabet[newIndex].toLowerCase();
      }

      return removeUnknownChars ? '' : char;
    }).join();
  }

  String rot13(String input) {
    this.alphabet = defaultAlphabetAlpha;
    return rotate(input, 13);
  }

  String rot5(String input) {
    this.alphabet = defaultAlphabetDigits;
    return rotate(input, 5);
  }

  String rot18(String input) {
    return input.split('').map((char) {
      if (defaultAlphabetAlpha.contains(char.toUpperCase())) {
        return rot13(char);
      } else if (defaultAlphabetDigits.contains(char)) {
        return rot5(char);
      } else
        return char;
    }).join();
  }

  String rot47(String input) {
    this.alphabet = '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
    return rotate(input, 47, removeUnknownCharacters: false, ignoreCase: false);
  }
}
