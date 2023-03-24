import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';

void main() {
  group("Morse.encodeMorse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... --- ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... -.-. | -.. . ..-.'},
      {'input' : [String.fromCharCode(197).toLowerCase(), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'expectedOutput' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.decodeMorse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SOS', 'input' : '... --- ...'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. | -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. / -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.-AB58-...    -.-. |bbbb-..@. ..-.'},
      {'expectedOutput' : [String.fromCharCode(192), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'input' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMorse(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}