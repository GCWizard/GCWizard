import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';

void main() {
  group("Morse.encodeMorse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... --- ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... -.-. | -.. . ..-.'},
      {'input' : [String.fromCharCode(197).toLowerCase(), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'expectedOutput' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Morse.decodeMorse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SOS', 'input' : '... --- ...'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. | -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. / -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.-AB58-...    -.-. |bbbb-..@. ..-.'},
      {'expectedOutput' : [String.fromCharCode(192), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'input' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMorse(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}