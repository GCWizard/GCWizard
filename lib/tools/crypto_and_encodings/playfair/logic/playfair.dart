import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';

Map<String, List<int>> _createKeyGrid(String key, AlphabetModificationMode mode) {
  key = key.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  var characters = key.split('').toList();
  characters.addAll(alphabet_AZ.keys);
  key = characters
      .map((character) {
        switch (mode) {
          case AlphabetModificationMode.J_TO_I:
            if (character == 'J') return '';
            break;
          case AlphabetModificationMode.W_TO_VV:
            if (character == 'W') return '';
            break;
          case AlphabetModificationMode.C_TO_K:
            if (character == 'C') return '';
            break;
          default:
            return '';
        }

        return character;
      })
      .toSet()
      .join();

  return createPolybiosGrid(key, 5);
}

String _sanitizeInput(String input, AlphabetModificationMode mode) {
  input = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

  switch (mode) {
    case AlphabetModificationMode.J_TO_I:
      input = input.replaceAll('J', 'I');
      break;
    case AlphabetModificationMode.W_TO_VV:
      input = input.replaceAll('W', 'VV');
      break;
    case AlphabetModificationMode.C_TO_K:
      input = input.replaceAll('C', 'K');
      break;
    default:
      input = '';
  }

  return input;
}

String encryptPlayfair(String input, String key, {AlphabetModificationMode mode = AlphabetModificationMode.J_TO_I}) {
  var keyGrid = _createKeyGrid(key, mode);
  input = _sanitizeInput(input, mode);

  int i = 0;
  while (i < input.length - 1) {
    if (input[i] == input[i + 1]) {
      if (input[i] == 'X') {
        input = insertCharacter(input, i + 1, 'Q');
      } else {
        input = insertCharacter(input, i + 1, 'X');
      }
    }
    i += 2;
  }

  if (input.length % 2 == 1) {
    if (input.endsWith('X')) {
      input += 'Q';
    } else {
      input += 'X';
    }
  }

  var out = '';

  i = 0;
  while (i < input.length) {
    var coordsCharacter1 = keyGrid[input[i]];
    var coordsCharacter2 = keyGrid[input[i + 1]];

    if (coordsCharacter1 != null && coordsCharacter2 != null) {
      if (coordsCharacter1[0] == coordsCharacter2[0]) {
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter1[0], (coordsCharacter1[1] + 1) % 5);
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter2[0], (coordsCharacter2[1] + 1) % 5);
      } else if (coordsCharacter1[1] == coordsCharacter2[1]) {
        out += polybiosGridCharacterByCoordinate(keyGrid, (coordsCharacter1[0] + 1) % 5, coordsCharacter1[1]);
        out += polybiosGridCharacterByCoordinate(keyGrid, (coordsCharacter2[0] + 1) % 5, coordsCharacter2[1]);
      } else {
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter1[0], coordsCharacter2[1]);
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter2[0], coordsCharacter1[1]);
      }

      out += ' ';
    } else {
      out += UNKNOWN_ELEMENT;
    }

    i += 2;
  }

  return out.trim();
}

String decryptPlayfair(String input, String key, {AlphabetModificationMode mode = AlphabetModificationMode.J_TO_I}) {
  var keyGrid = _createKeyGrid(key, mode);
  input = _sanitizeInput(input, mode);

  int i = 0;

  if (input.length % 2 == 1) {
    if (input.endsWith('X')) {
      input += 'Q';
    } else {
      input += 'X';
    }
  }

  var out = '';

  i = 0;
  while (i < input.length) {
    var coordsCharacter1 = keyGrid[input[i]];
    var coordsCharacter2 = keyGrid[input[i + 1]];

    if (coordsCharacter1 != null && coordsCharacter2 != null) {
      if (coordsCharacter1[0] == coordsCharacter2[0]) {
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter1[0], (coordsCharacter1[1] - 1) % 5);
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter2[0], (coordsCharacter2[1] - 1) % 5);
      } else if (coordsCharacter1[1] == coordsCharacter2[1]) {
        out += polybiosGridCharacterByCoordinate(keyGrid, (coordsCharacter1[0] - 1) % 5, coordsCharacter1[1]);
        out += polybiosGridCharacterByCoordinate(keyGrid, (coordsCharacter2[0] - 1) % 5, coordsCharacter2[1]);
      } else {
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter1[0], coordsCharacter2[1]);
        out += polybiosGridCharacterByCoordinate(keyGrid, coordsCharacter2[0], coordsCharacter1[1]);
      }
    } else {
      out += UNKNOWN_ELEMENT;
    }
    i += 2;
  }

  return out;
}
