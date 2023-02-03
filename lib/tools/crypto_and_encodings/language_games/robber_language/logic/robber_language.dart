import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';

String encryptRobberLanguage(String input) {
  if (input == null || input.length == 0) return '';

  return substitution(
          input,
          ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']
              .asMap()
              .map((index, character) => MapEntry(character, character + 'o' + character)),
          caseSensitive: false)
      .toLowerCase();
}

String decryptRobberLanguage(String input) {
  if (input == null || input.length == 0) return '';

  var regex = RegExp(r'([bcdfghjklmnpqrstvwxyz])o\1');

  return input.toLowerCase().replaceAllMapped(regex, (match) => '${match[1]}');
}
