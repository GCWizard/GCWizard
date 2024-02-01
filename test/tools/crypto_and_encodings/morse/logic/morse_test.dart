import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';

void main() {

  group("Morse.encodeMorse.MORSE_ITU:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... --- ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... -.-. | -.. . ..-.'},
      {'input' : [String.fromCharCode(197).toLowerCase(), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'expectedOutput' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, MORSE_CODE.MORSE_ITU);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.encodeMorse.GERKE:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... .-... ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... -.-. | -.. . ..-.'},
      {'input' : 'Ä Ö Ü CH', 'expectedOutput' : '.-.- | ---. | ..-- | -.-. ....'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, MORSE_CODE.GERKE);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.encodeMorse.AMERICAN:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... . . ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... .. . | -.. . .-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, MORSE_CODE.MORSE1844);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.encodeMorse.STEINHEIL:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '..-- ... ..--'},
      {'input' : 'ABc deF', 'expectedOutput' : '.-. .--. ..- | -. . .--'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, MORSE_CODE.STEINHEIL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.decodeMorse.MORSE_ITU:", () {
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
        var _actual = decodeMorse(elem['input'] as String, MORSE_CODE.MORSE_ITU);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.decodeMorse.GERKE:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SOS', 'input' : '... .-... ...'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. | -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. / -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.-AB58-...    -.-. |bbbb-..@. ..-.'},
      {'expectedOutput' : 'Ä Ö Ü CH', 'input' : '.-.- | ---. | ..-- | ----'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMorse(elem['input'] as String, MORSE_CODE.GERKE);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.decodeMorse.AMERICAN:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SEES', 'input' : '... . . ...'},
      {'expectedOutput' : 'AB DEQ', 'input' : '.- -... -.-. | -.. . ..-.'},
      {'expectedOutput' : 'AB DEQ', 'input' : '.- -... -.-. / -.. . ..-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMorse(elem['input'] as String, MORSE_CODE.MORSE1844);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.decodeMorse.STEINHEIL:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SEES', 'input' : '..-- . . ..--'},
      {'expectedOutput' : 'T5W LE7', 'input' : '.- -... -.-. | -.. . ..-.'},
      {'expectedOutput' : 'T5W LE7', 'input' : '.- -... -.-. / -.. . ..-.'},
      {'expectedOutput' : 'T5W LE7', 'input' : '.-AB58-...    -.-. |bbbb-..@. ..-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMorse(elem['input'] as String, MORSE_CODE.STEINHEIL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}