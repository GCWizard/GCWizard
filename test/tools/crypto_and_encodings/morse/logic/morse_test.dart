import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';

void main() {

  group("Morse.encodeMorse.MORSE_ITU:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... --- ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... -.-. | -.. . ..-.'},
      {'input' : [String.fromCharCode(197).toLowerCase(), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'expectedOutput' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, type: MorseType.MORSE_ITU);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.encodeMorse.GERKE:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'T', 'expectedOutput' : '-'},
      {'input' : 'N', 'expectedOutput' : '-.'},
      {'input' : 'D', 'expectedOutput' : '-..'},
      {'input' : 'B', 'expectedOutput' : '-...'},
      {'input' : '9', 'expectedOutput' : '-..-'},
      {'input' : '8', 'expectedOutput' : '-...'},
      {'input' : 'K', 'expectedOutput' : '-.-'},
      {'input' : 'C', 'expectedOutput' : '-.-.'},
      {'input' : 'M', 'expectedOutput' : '--'},
      {'input' : 'G', 'expectedOutput' : '--.'},
      {'input' : '7', 'expectedOutput' : '--..'},
      {'input' : 'Q', 'expectedOutput' : '--.-'},
      {'input' : 'Y', 'expectedOutput' : '--...'},
      {'input' : '5', 'expectedOutput' : '---'},
      {'input' : 'Ö', 'expectedOutput' : '---.'},
      //{'input' : 'CH', 'expectedOutput' : '----'},
      {'input' : 'E', 'expectedOutput' : '.'},
      {'input' : 'A', 'expectedOutput' : '.-'},
      {'input' : 'W', 'expectedOutput' : '.--'},
      {'input' : 'J', 'expectedOutput' : '.---'},
      {'input' : '1', 'expectedOutput' : '.--.'},
      {'input' : 'Z', 'expectedOutput' : '.--..'},
      {'input' : 'R', 'expectedOutput' : '.-.'},
      {'input' : 'L', 'expectedOutput' : '.-..'},
      {'input' : 'O', 'expectedOutput' : '.-...'},
      {'input' : 'Ä', 'expectedOutput' : '.-.-'},
      {'input' : 'I', 'expectedOutput' : '..'},
      {'input' : 'U', 'expectedOutput' : '..-'},
      {'input' : 'Ü', 'expectedOutput' : '..--'},
      {'input' : 'F', 'expectedOutput' : '..-.'},
      {'input' : '2', 'expectedOutput' : '..-..'},
      {'input' : 'X', 'expectedOutput' : '..-...'},
      {'input' : 'S', 'expectedOutput' : '...'},
      {'input' : 'V', 'expectedOutput' : '...-'},
      {'input' : '3', 'expectedOutput' : '...-.'},
      {'input' : 'H', 'expectedOutput' : '....'},
      {'input' : '4', 'expectedOutput' : '....-'},
      {'input' : 'P', 'expectedOutput' : '.....'},
      {'input' : '6', 'expectedOutput' : '......'},

      {'input' : 'SOS', 'expectedOutput' : '... .-... ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... -.-. | -.. . ..-.'},
      {'input' : 'Ä Ö Ü CH', 'expectedOutput' : '.-.- | ---. | ..-- | -.-. ....'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, type: MorseType.GERKE);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.encodeMorse.AMERICAN:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '... . . ...'},
      {'input' : 'ABc deF', 'expectedOutput' : '.- -... .. . | -.. . .-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, type: MorseType.MORSE1844);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.encodeMorse.STEINHEIL:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'SOS', 'expectedOutput' : '..-- ... ..--'},
      {'input' : 'ABc deF', 'expectedOutput' : '.-. .--. ..- | -. . .--'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeMorse(elem['input'] as String, type: MorseType.STEINHEIL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Morse.decodeMorse.MORSE_ITU:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'SOS', 'input' : '... --- ...'},
      {'expectedOutput' : 'SOS', 'input' : ['...', '---', '...'].join(String.fromCharCode(8195))},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. | -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.- -... -.-. / -.. . ..-.'},
      {'expectedOutput' : 'ABC DEF', 'input' : '.-AB58-...    -.-. |bbbb-..@. ..-.'},
      {'expectedOutput' : [String.fromCharCode(192), String.fromCharCode(192), String.fromCharCode(196), String.fromCharCode(223), '.', '-', '_', '@'].join()
        , 'input' : '.--.- .--.- .-.- ...--.. .-.-.- -....- ..--.- .--.-.'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeMorse(elem['input'] as String, type: MorseType.MORSE_ITU);
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
        var _actual = decodeMorse(elem['input'] as String, type: MorseType.GERKE);
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
        var _actual = decodeMorse(elem['input'] as String, type: MorseType.MORSE1844);
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
        var _actual = decodeMorse(elem['input'] as String, type: MorseType.STEINHEIL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}