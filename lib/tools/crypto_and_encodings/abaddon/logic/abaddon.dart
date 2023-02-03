import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

final YEN = String.fromCharCode(165);
final MY = String.fromCharCode(181);
final THORN = String.fromCharCode(254);

final AZToAbaddon = {
  'A': '$YEN$YEN$MY',
  'B': '$YEN$THORN$YEN',
  'C': '$THORN$MY$MY',
  'D': '$MY$MY$THORN',
  'E': '$MY$YEN$MY',
  'F': '$MY$MY$YEN',
  'G': '$MY$THORN$THORN',
  'H': '$THORN$MY$YEN',
  'I': '$YEN$YEN$YEN',
  'J': '$MY$THORN$MY',
  'K': '$YEN$THORN$MY',
  'L': '$MY$YEN$YEN',
  'M': '$THORN$YEN$YEN',
  'N': '$YEN$YEN$THORN',
  'O': '$THORN$THORN$THORN',
  'P': '$THORN$THORN$YEN',
  'Q': '$YEN$THORN$THORN',
  'R': '$THORN$THORN$MY',
  'S': '$THORN$MY$THORN',
  'T': '$THORN$YEN$MY',
  'U': '$MY$MY$MY',
  'V': '$YEN$MY$YEN',
  'W': '$MY$THORN$YEN',
  'X': '$MY$YEN$THORN',
  'Y': '$YEN$MY$THORN',
  'Z': '$THORN$YEN$THORN',
  ' ': '$YEN$MY$MY'
};

encryptAbaddon(String input, Map<String, String> replaceCharacters) {
  if (input == null || input.length == 0) return '';

  var abaddon = normalizeUmlauts(input)
      .toUpperCase()
      .split('')
      .where((character) => AZToAbaddon[character] != null)
      .map((character) => substitution(character, AZToAbaddon))
      .join();

  if (replaceCharacters != null) abaddon = substitution(abaddon, replaceCharacters);

  return abaddon;
}

decryptAbaddon(String input, Map<String, String> replaceCharacters) {
  if (input == null || input.length == 0) return '';

  if (replaceCharacters != null) input = substitution(input, switchMapKeyValue(replaceCharacters));

  final abaddonToAZ = switchMapKeyValue(AZToAbaddon);
  input = input.replaceAll(RegExp(r'[^' + YEN + MY + THORN + ']'), '');

  return RegExp(r'[' + YEN + MY + THORN + ']{3,3}')
      .allMatches(input)
      .map((pattern) => input.substring(pattern.start, pattern.end))
      .where((pattern) => abaddonToAZ[pattern] != null)
      .map((pattern) => abaddonToAZ[pattern])
      .join();
}
