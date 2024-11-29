part of 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system.dart';

enum MajorSystemCountry { DE, EN, FR, PL }

String languageName(MajorSystemCountry country) {
  switch (country) {
    case MajorSystemCountry.DE:
      return "common_language_german";
    case MajorSystemCountry.EN:
      return "common_country_english";
    case MajorSystemCountry.FR:
      return "common_country_french";
    case MajorSystemCountry.PL:
      return "common_country_polish";
  }
}

Map<String, String> _getTranslations(MajorSystemCountry country) {
  switch (country) {
    case MajorSystemCountry.DE: return _translationDE;
    case MajorSystemCountry.EN: return _translationEN;
    case MajorSystemCountry.FR: return _translationFR;
    case MajorSystemCountry.PL: return _translationPL;
  }
}

Map<String, String> _getSpecialTranslations(MajorSystemCountry country) {
  switch (country) {
    case MajorSystemCountry.DE: return _specialTranslationsDE;
    case MajorSystemCountry.EN: return _specialTranslationsEN;
    case MajorSystemCountry.FR: return _specialTranslationsFR;
    case MajorSystemCountry.PL: return _specialTranslationsPL;
  }
}

RegExp _getSplitPattern(MajorSystemCountry country) {
  late String splitletters;
  switch (country) {
    case MajorSystemCountry.DE: splitletters = _splitLettersDE; break;
    case MajorSystemCountry.EN: splitletters = _splitLettersEN; break;
    case MajorSystemCountry.FR: splitletters = _splitLettersFR; break;
    case MajorSystemCountry.PL: splitletters = _splitLettersPL; break;
  }
  return RegExp('[$splitletters]+');
}


const Map<String, String> _translationDE = {
  's': '0', 'z': '0', 't': '1', 'd': '1', 'n': '2', 'm': '3',
  'r': '4', 'l': '5', 'j': '6', 'g': '7', 'k': '7', 'c': '7',
  'f': '8', 'v': '8', 'w': '8', 'b': '9', 'p': '9'
};

const Map<String, String> _specialTranslationsDE = {
  'sch': 'j', 'ch': 'j', 'ck': 'k', 'ph': 'f'
};

const _splitLettersDE = 'aeiouqxy';

const Map<String, String> _translationEN = {
  's': '0', 'z': '0', 't': '1', 'd': '1', 'n': '2', 'm': '3',
  'r': '4', 'l': '5', 'j': '6', 'g': '7', 'k': '7', 'c': '7',
  'q': '7', 'f': '8', 'v': '8', 'w': '8', 'b': '9', 'p': '9'
};

const Map<String, String> _specialTranslationsEN = {
  'sh': 'j', 'ch': 'j', 'ck': 'k', 'ph': 'f', 'th': 't'
};

const _splitLettersEN = 'aeiouwhxy';

const Map<String, String> _translationFR = {
  's': '0', 'z': '0', 't': '1', 'd': '1', 'n': '2', 'm': '3',
  'r': '4', 'l': '5', 'j': '6', 'g': '7', 'k': '7', 'c': '7',
  'f': '8', 'v': '8', 'b': '9', 'p': '9'
};

const Map<String, String> _specialTranslationsFR = {
  'gn': 'n', 'ng': 'n', 'ch': 'j', 'sh': 'j', 'ph': 'f'
};

const _splitLettersFR = 'aeiouwhxy';

const Map<String, String> _translationPL = {
  's': '0', 'z': '0', 't': '1', 'd': '1', 'n': '2',
  'm': '3', 'r': '4', 'l': '5', 'j': '6', 'k': '7',
  'g': '7', 'f': '8', 'w': '8', 'b': '9', 'p': '9'
};

const Map<String, String> _specialTranslationsPL = {};

const _splitLettersPL = 'aeiouvhxy';

// Without knowing the pronunciation,
// it is not possible to implement this algorithmically
// for Spanish and Italian