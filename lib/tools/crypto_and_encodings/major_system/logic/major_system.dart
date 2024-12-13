import 'package:diacritic/diacritic.dart';
import 'package:gc_wizard/utils/string_utils.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system_data.dart';

enum MSCountry { DE, EN, FR, PL }

class MajorSystemClass {
  String text;
  bool nounMode;
  MSCountry currentCountry;

  MajorSystemClass({required this.text,
    this.nounMode = false,
    this.currentCountry = MSCountry.DE});

  Map<String, String> get _translations => _getTranslations(currentCountry);
  Map<String, String> get _specialTranslations => _getSpecialTranslations(currentCountry);
  RegExp get _splitPattern => _getSplitPattern(currentCountry);

  final _nonLetterChars = RegExp(r'[^a-zA-Z]+');

  static String localizationName(MSCountry country) {
    switch (country) {
      case MSCountry.DE:
        return "common_language_german";
      case MSCountry.EN:
        return "common_country_english";
      case MSCountry.FR:
        return "common_country_french";
      case MSCountry.PL:
        return "common_country_polish";
    }
  }

  String decrypt() {
    if (text.isEmpty) return '';

    final cleanedText = preparedText();
    StringBuffer decoded = StringBuffer();

    var wordList = cleanedText.split(' ');
    for (var word in wordList) {
      final consonantGroup = _splitToConsonantGroups(word);
      decoded.write(consonantGroup.map(_translateGroup).join());
      decoded.write(' ');
    }
    return decoded.toString().trim();
  }

  String preparedText() {
    final normalizedText = removeDiacritics(text);
    final words =
    normalizedText.split(_nonLetterChars).where((word) => word.isNotEmpty);

    if (nounMode) {
      return words.where((word) => isUpperCase(word[0]))
          .join(' ')
          .toLowerCase();
    }
    return words.join(' ').toLowerCase();
  }

// returns a list of consonant groups like [d, r, m, nd, g, ht, m, s, chs]
  List<String> _splitToConsonantGroups(String text) {
    return text
        .split(' ')
        .expand((word) => word.split(_splitPattern))
        .where((group) => group.isNotEmpty)
        .toList();
  }

  String _translateGroup(String group) {
    group = _replaceDoubleLetters(group);
    _specialTranslations.forEach((pattern, replacement) {
      group = group.replaceAll(pattern, replacement);
    });
    return group.split('').map((char) => _translations[char] ?? '').join();
  }

  String _replaceDoubleLetters(String input) {
    return input.replaceAllMapped(
        RegExp(r'(.)\1+'), (match) => match.group(1)!);
  }
}