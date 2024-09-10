import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/straddling_checkerboard/logic/straddling_checkerboard.dart';

void main() {

  group("encrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty Input
      {'input' : '', 'key': '', 'alphabetWord' : '', 'columnOrder' : '', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},
      {'input' : 'cache bei n 52 345 678 o 13 09 451', 'key': '', 'alphabetWord' : '', 'columnOrder' : '', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},

      {'input' : 'cache bei n 52 345 678 o 13 09 451', 'key': 'gc wizard ', 'alphabetWord' : '', 'columnOrder' : '0246813579', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '2324642974042897479799599297993994995979969979989749979919939799099997994995991'},
      {'input' : 'cache bei n 52 345 678 o 13 09 451', 'key': 'g c wizad ', 'alphabetWord' : '', 'columnOrder' : '0246813579', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '4542622992022199279998929994969899919395992999909499699799969890'},

      {'input' : 'no attack', 'key': 'SIOERATN  ', 'alphabetWord' : 'CXUDJPZBKQ', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '.WFL/GMYHV', 'expectedOutput' : '729856658088'},
      {'input' : 'Beispielklartext', 'key': 'MDELVAYO  ', 'alphabetWord' : '', 'columnOrder' : '0987654321', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '20825182125872375191781417'},
      {'input' : 'Beispielklartext', 'key': 'RTWXYZ ./ ', 'alphabetWord' : 'pausomvejk', 'columnOrder' : '6087549123', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '3691399796399131933190609170'},
      {'input' : 'Treffen morgen Zwanzig Uhr an Treffpunkt drei', 'key': 'D  EINSTAR', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '7931212352818199133528272485274132822149288528793121220225167280934'},
      {'input' : 'Treffen morgen Zwanzig Uhr an Treffpunkt drei', 'key': 'DEI NS TAR', 'alphabetWord' : '', 'columnOrder' : '8529406137', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '1759292546393977995463616434612996362947633463175929268624961638752'},
      {'input' : 'Treffen morgen 2000 Uhr an Treffpunkt 3', 'key': 'D   EINSTA', 'alphabetWord' : 'R', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '810413134639192010144639312929293923151039963981041313212361783932'},

      // https://en.wikipedia.org/wiki/Straddling_checkerboard
      {'input' : 'ATTACK AT DAWN', 'key': 'ET AON RIS', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BCDFGHJKLMPQUVWXYZ./', 'expectedOutput' : '31132127683168223645'},

      // check fillKey
      {'input' : 'test', 'key': 'roast', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : 'test', 'key': 'toastier', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : 'test', 'key': 'roastbcd', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '48034'},
      {'input' : 'test', 'key': 'roast', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : 'test', 'key': 'toastie', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : 'test', 'key': 'roastbc', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : '47134'},

      //{'input' : '', 'key': '', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, alphabetWord: ${elem['alphabetWord']}, columnOrder: ${elem['columnOrder']}, matrix4x10: ${elem['matrix4x10']}, mode: ${elem['mode']}, alphabet: ${elem['alphabet']}', () {
        StraddlingCheckerboardOutput _actual = encryptStraddlingCheckerboard(elem['input'] as String, elem['key'] as String, elem['alphabetWord'] as String, elem['columnOrder'] as String, elem['matrix4x10'] as bool, mode: elem['mode'] as PolybiosMode, alphabet: elem['alphabet'] as String);
        expect(_actual.output, elem['expectedOutput']);
      });
    }
  });

  group("decrypt", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : 'CACHE BEI N 52 345 678 O 13 09 451', 'key': 'gc wizard ', 'alphabetWord' : '', 'columnOrder' : '0246813579', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '2324642974042897479799599297993994995979969979989749979919939799099997994995991'},
      {'expectedOutput' : 'CACHE BEI N 52 345 678 O 13 09 451', 'key': 'g c wizad ', 'alphabetWord' : '', 'columnOrder' : '0246813579', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '4542622992022199279998929994969899919395992999909499699799969890'},

      {'expectedOutput' : 'NO ATTACK', 'key': 'SIOERATN  ', 'alphabetWord' : 'CXUDJPZBKQ', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '.WFL/GMYHV', 'input' : '729856658088'},
      {'expectedOutput' : 'BEISPIELKLARTEXT', 'key': 'MDELVAYO  ', 'alphabetWord' : '', 'columnOrder' : '0987654321', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '20825182125872375191781417'},
      {'expectedOutput' : 'BEISPIELKLARTEXT', 'key': 'RTWXYZ ./ ', 'alphabetWord' : 'pausomvejk', 'columnOrder' : '6087549123', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '3691399796399131933190609170'},
      {'expectedOutput' : 'TREFFEN MORGEN ZWANZIG UHR AN TREFFPUNKT DREI', 'key': 'D  EINSTAR', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '7931212352818199133528272485274132822149288528793121220225167280934'},
      {'expectedOutput' : 'TREFFEN MORGEN ZWANZIG UHR AN TREFFPUNKT DREI', 'key': 'DEI NS TAR', 'alphabetWord' : '', 'columnOrder' : '8529406137', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '1759292546393977995463616434612996362947633463175929268624961638752'},
      {'expectedOutput' : 'TREFFEN MORGEN 2000 UHR AN TREFFPUNKT 3', 'key': 'D   EINSTA', 'alphabetWord' : 'R', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'input' : '810413134639192010144639312929293923151039963981041313212361783932'},

      // https://en.wikipedia.org/wiki/Straddling_checkerboard
      {'expectedOutput' : 'ATTACK AT DAWN', 'key': 'ET AON RIS', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BCDFGHJKLMPQ/UVWXYZ.', 'input' : '31132127693169223655'},

      // check fillKey
      {'input' : '48034', 'key': 'roast', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : '48034', 'key': 'toastier', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : '48034', 'key': 'roastbcd', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : false, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'TEST'},
      {'input' : '47134', 'key': 'roast', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : '47134', 'key': 'toastie', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'straddlingcheckerboard_wrong_key_error'},
      {'input' : '47134', 'key': 'roastbc', 'alphabetWord' : '', 'columnOrder' : '0123456789', 'matrix4x10' : true, 'mode': PolybiosMode.AZ09, 'alphabet': '', 'expectedOutput' : 'TEST'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, alphabetWord: ${elem['alphabetWord']}, columnOrder: ${elem['columnOrder']}, matrix4x10: ${elem['matrix4x10']}, mode: ${elem['mode']}, alphabet: ${elem['alphabet']}', () {
        StraddlingCheckerboardOutput _actual = decryptStraddlingCheckerboard(elem['input'] as String, elem['key'] as String, elem['alphabetWord'] as String, elem['columnOrder'] as String, elem['matrix4x10'] as bool, mode: elem['mode'] as PolybiosMode, alphabet: elem['alphabet'] as String);
        expect(_actual.output, elem['expectedOutput']);
      });
    }
  });
}