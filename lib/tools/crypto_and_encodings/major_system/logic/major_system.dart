import 'package:diacritic/diacritic.dart';

class MajorDecrypt {
  String text;
  bool nounMode;

  MajorDecrypt(this.text, {this.nounMode = false});

  final _noLetterChars = RegExp(r'[ !"#$%&()*+,-./:;<=>?@[\\\]^_`{|}~\s]+');

  Map<String, String> translation = {
    's': '0',
    'z': '0',
    't': '1',
    'd': '1',
    'n': '2',
    'm': '3',
    'r': '4',
    'l': '5',
    'j': '6',
    'g': '7',
    'k': '7',
    'c': '7',
    'f': '8',
    'v': '8',
    'w': '8',
    'ph': 'f',
    'b': '9',
    'p': '9'
  };

  Map<String, String> specialTranslations = {
    'sch': 'j',
    'ch': 'j',
    'ck': 'k',
    'ph': 'f'
  };

  String decodeToNumberString() {
    String decoded = "";

    for (var pattern in _groups()) {
      decoded += _translate(pattern, '');
    }
    return decoded;
  }

  // recursive translation function
  String _translate(String pattern, String collected) {
    if (pattern.isEmpty) return collected;

    var output = collected;
    var newPattern = pattern;

    // replace all direct doubles
    newPattern = _replaceDoubleLetters(newPattern);

    // replace all specialTranslations with the base character
    for (var transition in specialTranslations.keys) {
      if (newPattern.contains(transition)) {
        newPattern = newPattern.replaceAll(
            transition, specialTranslations[transition] as String);
      }
    }

    // tranlates first or only character
    if (newPattern.isNotEmpty) {
      var firstChar = newPattern[0];
      if (translation.containsKey(firstChar)) {
        output += translation[firstChar]!;
      }
      newPattern = newPattern.substring(1);
    }
    // recursion
    return _translate(newPattern, output);
  }

  // Remove all unnecessary chars like puctuation and diacritics and
  // returns a single string with spaces between single words
  String _cleanText() {
    if (text.isEmpty) return '';

    String _textWithoutDiacritics = removeDiacritics(text);

    var newText = _textWithoutDiacritics.split(_noLetterChars);
    List<String> validWords = [];

    // returns only capitalized words
    if (nounMode) {
      for (var word in newText) {
        if (word.isNotEmpty) {
          int firstCharCode = word.codeUnitAt(0); // unicode of first letter
          if (firstCharCode >= 65 && firstCharCode <= 90) {
            // capitalized word?
            validWords.add(word);
          }
        }
      }
      newText = validWords;
    }
    return newText.join(' ').toLowerCase();
  }

  // returns a list of consonant groups
  // like [d, r, m, nd, g, ht, m, s, chs]
  List<String> _groups() {
    var words = _cleanText().split(" ");
    List<String> groupList = [];
    for (var word in words) {
      var groups = word.split(RegExp('[aeiouqxy]+'));
      groupList.addAll(groups);
    }
    groupList.removeWhere((entry) => entry.isEmpty); // remove empty entries
    return groupList;
  }

  String _replaceDoubleLetters(String input) {
    RegExp regExp = RegExp(r'(.)\1+');
    return input.replaceAllMapped(regExp, (match) => match.group(1)!);
  }

  String toString() {
    return _cleanText();
  }
}
