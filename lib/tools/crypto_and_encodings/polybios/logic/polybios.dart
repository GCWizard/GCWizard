import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/utils/alphabets.dart';

enum PolybiosMode { AZ09, ZA90, x90ZA, x09AZ, CUSTOM }

class PolybiosOutput {
  final String output;
  final String grid;

  PolybiosOutput(this.output, this.grid);
}

String _sanitizeAlphabet(String alphabet) {
  if (alphabet.isEmpty) return '';

  alphabet += alphabet_AZ.keys.join();
  alphabet += alphabet_09.keys.join();

  alphabet = alphabet.toUpperCase().replaceAll(' ', '');

  //remove doubles letters
  return alphabet.split('').toSet().join();
}

String? createPolybiosAlphabet(int gridDimension,
    {String? firstLetters = '',
    PolybiosMode mode = PolybiosMode.AZ09,
    String? fillAlphabet,
    AlphabetModificationMode? modificationMode = AlphabetModificationMode.J_TO_I}) {
  firstLetters ??= '';

  fillAlphabet ??= '';

  modificationMode ??= AlphabetModificationMode.J_TO_I;

  switch (gridDimension) {
    case 5:
      switch (mode) {
        case PolybiosMode.CUSTOM:
          fillAlphabet = fillAlphabet.toUpperCase() + alphabet_AZ.keys.join();
          break;
        case PolybiosMode.AZ09:
        case PolybiosMode.x09AZ:
          fillAlphabet = alphabet_AZ.keys.join();
          break;
        case PolybiosMode.ZA90:
        case PolybiosMode.x90ZA:
          fillAlphabet = alphabet_AZ.keys.toList().reversed.join();
          break;
        default:
          break;
      }

      switch (modificationMode) {
        case AlphabetModificationMode.J_TO_I:
          fillAlphabet = fillAlphabet.replaceAll('J', '');
          break;
        case AlphabetModificationMode.C_TO_K:
          fillAlphabet = fillAlphabet.replaceAll('C', '');
          break;
        case AlphabetModificationMode.W_TO_VV:
          fillAlphabet = fillAlphabet.replaceAll('W', '');
          break;
        case AlphabetModificationMode.REMOVE_Q:
          fillAlphabet = fillAlphabet.replaceAll('Q', '');
          break;
      }

      break;
    case 6:
      var alphabetAZ = alphabet_AZ.keys.toList();

      switch (mode) {
        case PolybiosMode.CUSTOM:
          alphabetAZ.addAll(alphabet_09.keys);
          fillAlphabet += alphabetAZ.join();
          break;
        // ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
        case PolybiosMode.AZ09:
          alphabetAZ.addAll(alphabet_09.keys);
          fillAlphabet = alphabetAZ.join();
          break;
        // ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210
        case PolybiosMode.ZA90:
          alphabetAZ = alphabetAZ.reversed.toList();
          alphabetAZ.addAll(alphabet_09.keys.toList().reversed);
          fillAlphabet = alphabetAZ.join();
          break;
        // 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
        case PolybiosMode.x09AZ:
          var alphabet = alphabet_09.keys.toList();
          alphabet.addAll(alphabetAZ);
          fillAlphabet = alphabet.join();
          break;
        // 9876543210ZYXWVUTSRQPONMLKJIHGFEDCBA
        case PolybiosMode.x90ZA:
          var alphabet = alphabet_09.keys.toList().reversed.toList();
          alphabet.addAll(alphabetAZ.reversed.toList());
          fillAlphabet = alphabet.join();
          break;
        default:
          break;
      }
      break;
    default:
      return null;
  }

  var alphabet = _sanitizeAlphabet(firstLetters + fillAlphabet);

  if (alphabet.length < gridDimension * gridDimension) return null; //TODO Exception

  return alphabet.substring(0, gridDimension * gridDimension);
}

// Returns for example
// {
//    'A' : [0, 0], 'B' : [0, 1], 'C' : [0, 2], 'D' : [0, 3], 'E' : [0, 4],
//    'F' : [1, 0], 'G' : [1, 1], 'H' : [1, 2], 'I' : [1, 3], 'K' : [1, 4],
//    'L' : [2, 0], 'M' : [2, 1], 'N' : [2, 2], 'O' : [2, 3], 'P' : [2, 4],
//    'Q' : [3, 0], 'R' : [3, 1], 'S' : [3, 2], 'T' : [3, 3], 'U' : [3, 4],
//    'V' : [4, 0], 'W' : [4, 1], 'X' : [4, 2], 'Y' : [4, 3], 'Z' : [4, 4],
// }

Map<String, List<int>> createPolybiosGrid(String input, int dimension) {
  var grid = <String, List<int>>{};

  input = input.substring(0, min(input.length, dimension * dimension));

  for (int i = 0; i < input.length; i++) {
    grid.putIfAbsent(input[i], () => [i ~/ dimension, i % dimension]);
  }

  return grid;
}

String polybiosGridCharacterByCoordinate(Map<String, List<int>> grid, int row, int column) {
  return grid.entries.firstWhere((entry) => entry.value[0] == row && entry.value[1] == column).key;
}

PolybiosOutput? encryptPolybios(String input, String key,
    {PolybiosMode mode = PolybiosMode.AZ09,
    String? fillAlphabet,
    String? firstLetters,
    AlphabetModificationMode? modificationMode = AlphabetModificationMode.J_TO_I}) {
  modificationMode ??= AlphabetModificationMode.J_TO_I;

  int dim = key.length;
  if (dim != 5 && dim != 6) return null; //TODO Exception

  var alphabet = createPolybiosAlphabet(dim,
      mode: mode, fillAlphabet: fillAlphabet, firstLetters: firstLetters, modificationMode: modificationMode);
  if (alphabet == null) return null; //TODO Exception

  key = key.toUpperCase();
  input = input.toUpperCase();

  if (dim == 5) {
    input = applyAlphabetModification(input, modificationMode);
  }

  Map<String, List<int>> grid = createPolybiosGrid(alphabet, dim);

  var output = input.split('').where((character) => alphabet.contains(character)).map((character) {
    var coords = grid[character];
    if (coords == null || coords.length < 2) return '';

    return '${key[coords[0]]}${key[coords[1]]}';
  }).join(' ');

  return PolybiosOutput(output, polybiosGridToString(grid, key));
}

PolybiosOutput? decryptPolybios(String input, String key,
    {PolybiosMode mode = PolybiosMode.AZ09,
    String? fillAlphabet,
    String? firstLetters,
    AlphabetModificationMode? modificationMode = AlphabetModificationMode.J_TO_I}) {
  modificationMode ??= AlphabetModificationMode.J_TO_I;

  int dim = key.length;
  if (dim != 5 && dim != 6) return null; //TODO Exception

  var alphabet = createPolybiosAlphabet(dim,
      mode: mode, fillAlphabet: fillAlphabet, firstLetters: firstLetters, modificationMode: modificationMode);
  if (alphabet == null) return null;

  key = key.toUpperCase();
  input = input.split('').map((character) => key.contains(character) ? character : '').join();

  if (input.length % 2 != 0) input = input.substring(0, input.length - 1);

  if (input.isEmpty) return null; //TODO: Exception

  var grid = createPolybiosGrid(alphabet, dim);

  String out = '';

  int i = 0;
  while (i < input.length - 1) {
    var x = key.indexOf(input[i]);
    var y = key.indexOf(input[i + 1]);

    out += polybiosGridCharacterByCoordinate(grid, x, y);
    i += 2;
  }

  return PolybiosOutput(out, polybiosGridToString(grid, key));
}

String polybiosGridToString(Map<String, List<int>> grid, String key) {
  var currentRow = -1;
  var output = '  | ' + key.split('').join(' ');
  output += '\n--+' + '-' * key.length * 2;

  for (var entry in grid.entries) {
    if (entry.value[0] > currentRow) {
      currentRow++;
      output += '\n' + key[currentRow] + ' |';
    }
    output += ' ' + entry.key;
  }

  return output;
}
