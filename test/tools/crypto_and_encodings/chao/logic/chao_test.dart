import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/chao/logic/chao.dart';

void main() {

  group("Chao.encryptChao:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},
      {'input' : 'Hallo', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'expectedOutput' : 'SAQSR'},
      {'input' : 'WELLDONEISBETTERTHANWELLSAID', 'keyPlain' : 'PTLNBQDEOYSFAVZKGJRIHWXUMC', 'keyChiffre': 'HXUCZVAMDSLKPEFJRIGTWOBNYQ', 'expectedOutput' : 'OAHQHCNYNXTSZJRRHJBYHQKSOUJY'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyPlain: ${elem['keyPlain']}, keyChiffre: ${elem['keyChiffre']}', () {
        var _actual = encryptChao(elem['input'] as String, elem['keyPlain'] as String, elem['keyChiffre'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Chao.decryptChao:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : ''},
      {'expectedOutput' : 'HALLO', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'input' : 'SAQSR'},
      {'expectedOutput' : 'WELLDONEISBETTERTHANWELLSAID', 'keyPlain' : 'PTLNBQDEOYSFAVZKGJRIHWXUMC', 'keyChiffre': 'HXUCZVAMDSLKPEFJRIGTWOBNYQ', 'input' : 'OAHQHCNYNXTSZJRRHJBYHQKSOUJY'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyPlain: ${elem['keyPlain']}, keyChiffre: ${elem['keyChiffre']}', () {
        var _actual = decryptChao(elem['input'] as String, elem['keyPlain'] as String, elem['keyChiffre'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}