import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morbit/logic/morbit.dart';

void main() {
  group("Morbit.morbitEncrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'expectedOutput': ''},

      {'input' : 'A', 'key': 'hamsterad', 'expectedOutput': '1'},
      {'input' : 'ABC', 'key': 'hamsterad', 'expectedOutput': '12568 8'},
      {'input' : 'Halle meine Entchen', 'key': 'hamsterad', 'expectedOutput': '55741 57866 24652 66726 48875 668'},
      {'input' : '.', 'key': 'hamsterad', 'expectedOutput': '111'},
      {'input' : 'Ab 0.', 'key': 'hamsterad', 'expectedOutput': '12562 99788 4'},

      {'input' : 'ABC', 'key': 'neuschwanstein', 'expectedOutput': '31587 7'},
      {'input' : 'ABC', 'key': 'a', 'expectedOutput': '28134 4'},
      {'input' : 'ABC', 'key': '', 'expectedOutput': '28134 4'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = morbitEncrypt(elem['input'] as String, elem['key'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morbit.morbitDecrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'expectedOutput': ''},

      {'expectedOutput' : 'A', 'key': 'hamsterad', 'input': '1'},
      {'expectedOutput' : 'ABC', 'key': 'hamsterad', 'input': '12568 8'},
      {'expectedOutput' : 'HALLE MEINE ENTCHEN', 'key': 'hamsterad', 'input': '55741 57866 24652 66726 48875 668'},
      {'expectedOutput' : '.', 'key': 'hamsterad', 'input': '111'},
      {'expectedOutput' : 'AB 0.', 'key': 'hamsterad', 'input': '12562 99788 4'},

      {'expectedOutput' : 'ABC', 'key': 'neuschwanstein', 'input': '31587 7'},
      {'expectedOutput' : 'ABC', 'key': 'a', 'input': '28134 4'},
      {'expectedOutput' : 'ABC', 'key': '', 'input': '28134 4'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = morbitDecrypt(elem['input'] as String, elem['key'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}