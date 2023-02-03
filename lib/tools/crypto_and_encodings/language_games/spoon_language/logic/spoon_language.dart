import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';

String encryptSpoonLanguage(String input) {
  if (input == null || input.length == 0) return '';

  return substitution(
          input,
          [
            'a',
            'e',
            'i',
            'o',
            'u',
            String.fromCharCode(228) /* ä */,
            String.fromCharCode(246) /* ö */,
            String.fromCharCode(252) /* ü */,
            'au',
            'ei',
            'ie',
            'eu',
            '${String.fromCharCode(228)}u' /* äu */
          ].asMap().map((index, character) => MapEntry(character, character + 'lew' + character)),
          caseSensitive: false)
      .toLowerCase();
}

String decryptSpoonLanguage(String input) {
  if (input == null || input.length == 0) return '';

  var regex = RegExp(r'([aeiouäöü]|ei|ie|au|äu|eu)lew\1');

  return input.toLowerCase().replaceAllMapped(regex, (match) => '${match[1]}');
}
