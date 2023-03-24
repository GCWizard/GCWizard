import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';

String encryptSpoonLanguage(String input) {
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
          ].asMap().map((index, character) => MapEntry(character, character + 'lew' + character)),
          caseSensitive: false)
      .toLowerCase();
}

String decryptSpoonLanguage(String input) {
  if (input.isEmpty) return '';

  var regex = RegExp(r'([aeiouäöü]|ei|ie|au|äu|eu)lew\1');

  return input.toLowerCase().replaceAllMapped(regex, (match) => '${match[1]}');
}
