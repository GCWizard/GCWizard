import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<String, String> _AZToTomTom = {
  'A': '/',
  'B': '//',
  'C': '///',
  'D': '////',
  'E': '/\\',
  'F': '//\\',
  'G': '///\\',
  'H': '/\\\\',
  'I': '/\\\\\\',
  'J': '\\/',
  'K': '\\\\/',
  'L': '\\\\\\/',
  'M': '\\//',
  'N': '\\///',
  'O': '/\\/',
  'P': '//\\/',
  'Q': '/\\\\/',
  'R': '/\\//',
  'S': '\\/\\',
  'T': '\\\\/\\',
  'U': '\\//\\',
  'V': '\\/\\\\',
  'W': '//\\\\',
  'X': '\\\\//',
  'Y': '\\/\\/',
  'Z': '/\\/\\'
};

String encryptTomTom(String input, Map<String, String>? replaceCharacters) {
  if (input.isEmpty) return '';

  var tomtom = normalizeUmlauts(input)
      .toUpperCase()
      .split('')
      .where((character) => _AZToTomTom[character] != null)
      .map((character) => substitution(character, _AZToTomTom))
      .join(' ');

  if (replaceCharacters != null) tomtom = substitution(tomtom, replaceCharacters);

  return tomtom;
}

String decryptTomTom(String input, Map<String, String>? replaceCharacters) {
  if (input.isEmpty) return '';

  if (replaceCharacters != null) input = substitution(input, switchMapKeyValue(replaceCharacters));

  final tomTomToAZ = switchMapKeyValue(_AZToTomTom);

  return input
      .split(RegExp(r'[^/\\]'))
      .where((character) => tomTomToAZ[character] != null)
      .map((pattern) => tomTomToAZ[pattern])
      .join();
}
