import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';

String encryptChickenLanguage(String input) {
  if (input.isEmpty) return '';

  return substitution(
          input,
          [
            'a',
            'e',
            'i',
            'o',
            'u',
            '\u00E4' /* ä */,
            '\u00F6' /* ö */,
            '\u00FC' /* ü */,
            'au',
            'ei',
            'ie',
            'eu',
            '\u00E4u' /* äu */
          ].asMap().map((index, character) => MapEntry(character, character + 'h' + character + 'def' + character)),
          caseSensitive: false)
      .toLowerCase();
}

String decryptChickenLanguage(String input) {
  if (input.isEmpty) return '';

  var regex = RegExp(r'([aeiouäöü]|ei|ie|au|äu|eu)h\1def\1');

  return input.toLowerCase().replaceAllMapped(regex, (match) => '${match[1]}');
}
