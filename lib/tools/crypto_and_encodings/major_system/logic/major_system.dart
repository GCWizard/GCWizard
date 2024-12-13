import 'package:diacritic/diacritic.dart';
import 'package:gc_wizard/utils/string_utils.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system_data.dart';

enum MSCountries { DE, EN, FR, PL }

String localizationName(MSCountries country) {
  switch (country) {
    case MSCountries.DE: return "common_language_german";
    case MSCountries.EN: return "common_country_english";
    case MSCountries.FR: return "common_country_french";
    case MSCountries.PL: return "common_country_polish";
  }
}

Map<String, String> _trans(MSCountries country) {
  switch (country) {
    case MSCountries.DE: return _translationDE;
    case MSCountries.EN: return _translationEN;
    case MSCountries.FR: return _translationFR;
    case MSCountries.PL: return _translationPL;
  }
}

Map<String, String> _specialTrans(MSCountries country) {
  switch (country) {
    case MSCountries.DE: return _specialTranslationsDE;
    case MSCountries.EN: return _specialTranslationsEN;
    case MSCountries.FR: return _specialTranslationsFR;
    case MSCountries.PL: return _specialTranslationsPL;
  }
}

RegExp _splits(MSCountries country) {
  late String splitletters;
  switch (country) {
    case MSCountries.DE: splitletters = _splitLettersDE; break;
    case MSCountries.EN: splitletters = _splitLettersEN; break;
    case MSCountries.FR: splitletters = _splitLettersFR; break;
    case MSCountries.PL: splitletters = _splitLettersPL; break;
  }
  return RegExp('[$splitletters]+');
}

final _nonLetterChars = RegExp(r'[^a-zA-Z]+');

MSCountries currentCountry = MSCountries.DE;
var _translations = _trans(currentCountry);
var _specialTranslations = _specialTrans(currentCountry);
var _splitletters = _splits(currentCountry);

String decryptMajorSystem(String text, {bool nounMode = false}) {
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
  final words =
      normalizedText.split(_nonLetterChars).where((word) => word.isNotEmpty);

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
