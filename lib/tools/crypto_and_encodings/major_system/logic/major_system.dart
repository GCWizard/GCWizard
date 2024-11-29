import 'package:diacritic/diacritic.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _translation = {
  's': '0', 'z': '0', 't': '1', 'd': '1', 'n': '2', 'm': '3',
  'r': '4', 'l': '5', 'j': '6', 'g': '7', 'k': '7', 'c': '7',
  'f': '8', 'v': '8', 'w': '8', 'ph': 'f', 'b': '9', 'p': '9'
};

const Map<String, String> _specialTranslations = {
  'sch': 'j', 'ch': 'j', 'ck': 'k', 'ph': 'f'
};

final _nonLetterChars = RegExp(r'[^a-zA-Z]+');
final _splitLetters = RegExp('[aeiouqxy]+');

String decryptMajorSystem (String text, {bool nounMode = false}) {
  if (text.isEmpty) return '';

  final cleanedText = preparedMajorText(text, nounMode: nounMode);
  StringBuffer decoded = StringBuffer();

  var wordList = cleanedText.split(' ');
  for (var word in wordList) {
    final consonantGroup = _splitToConsonantGroups(word);
    decoded.write(consonantGroup.map(_translateGroup).join());
    decoded.write(' ');
  }
  return decoded.toString().trim();
}

String preparedMajorText(String text, {bool nounMode = false}) {
  final normalizedText = removeDiacritics(text);
  final words = normalizedText.split(_nonLetterChars).where((word) => word.isNotEmpty);

  if (nounMode) {
    return words.where((word) => isUpperCase(word[0])).join(' ').toLowerCase();
  }
  return words.join(' ').toLowerCase();
}

// returns a list of consonant groups like [d, r, m, nd, g, ht, m, s, chs]
List<String> _splitToConsonantGroups(String text) {
  return text
      .split(' ')
      .expand((word) => word.split(_splitLetters))
      .where((group) => group.isNotEmpty)
      .toList();
}

String _translateGroup(String group) {
  group = _replaceDoubleLetters(group);
  _specialTranslations.forEach((pattern, replacement) {
    group = group.replaceAll(pattern, replacement);
  });

  return group.split('').map((char) => _translation[char] ?? '').join();
}

String _replaceDoubleLetters(String input) {
  return input.replaceAllMapped(RegExp(r'(.)\1+'), (match) => match.group(1)!);
}