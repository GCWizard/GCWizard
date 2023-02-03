import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/chao/logic/chao.dart';

void main() {

  group("Chao.encryptChao:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : '', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},
      {'input' : 'Hallo', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'expectedOutput' : 'SAQSR'},
      {'input' : 'WELLDONEISBETTERTHANWELLSAID', 'keyPlain' : 'PTLNBQDEOYSFAVZKGJRIHWXUMC', 'keyChiffre': 'HXUCZVAMDSLKPEFJRIGTWOBNYQ', 'expectedOutput' : 'OAHQHCNYNXTSZJRRHJBYHQKSOUJY'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, keyPlain: ${elem['keyPlain']}, keyChiffre: ${elem['keyChiffre']}', () {
        var _actual = encryptChao(elem['input'], elem['keyPlain'], elem['keyChiffre']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Chao.decryptChao:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput' : '', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : ''},
      {'expectedOutput' : 'HALLO', 'keyPlain' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'keyChiffre': 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'input' : 'SAQSR'},
      {'expectedOutput' : 'WELLDONEISBETTERTHANWELLSAID', 'keyPlain' : 'PTLNBQDEOYSFAVZKGJRIHWXUMC', 'keyChiffre': 'HXUCZVAMDSLKPEFJRIGTWOBNYQ', 'input' : 'OAHQHCNYNXTSZJRRHJBYHQKSOUJY'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, keyPlain: ${elem['keyPlain']}, keyChiffre: ${elem['keyChiffre']}', () {
        var _actual = decryptChao(elem['input'], elem['keyPlain'], elem['keyChiffre']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

}