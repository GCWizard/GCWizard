import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_enums.dart';

Map<SubstitutionBreakerAlphabet, String> SubstitutionBreakerAlphabetItems(BuildContext context) {
  var breakerAlphabetItems = {
    SubstitutionBreakerAlphabet.ENGLISH: i18n(context, 'common_language_english'),
    SubstitutionBreakerAlphabet.GERMAN: i18n(context, 'common_language_german'),
    SubstitutionBreakerAlphabet.DUTCH: i18n(context, 'common_language_dutch'),
    SubstitutionBreakerAlphabet.SPANISH: i18n(context, 'common_language_spanish'),
    SubstitutionBreakerAlphabet.POLISH: i18n(context, 'common_language_polish'),
    SubstitutionBreakerAlphabet.GREEK: i18n(context, 'common_language_greek'),
    SubstitutionBreakerAlphabet.FRENCH: i18n(context, 'common_language_french'),
    SubstitutionBreakerAlphabet.RUSSIAN: i18n(context, 'common_language_russian'),
  };
  return breakerAlphabetItems;
}