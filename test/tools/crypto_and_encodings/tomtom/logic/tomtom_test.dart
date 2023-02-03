import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/tomtom/logic/tomtom.dart';

void main() {
  group("TomTom.encryptTomTom:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': null, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': <String, String>{}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/'}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/', '\\': '\\'}, 'expectedOutput' : ''},
  
      {'input' : 'A', 'expectedOutput' : '/'},
      {'input' : 'N', 'expectedOutput' : '\\///'},
      {'input' : 'Z', 'expectedOutput' : '/\\/\\'},

      {'input' : 'ANZ', 'expectedOutput' : '/ \\/// /\\/\\'},
      {'input' : 'A N Z', 'expectedOutput' : '/ \\/// /\\/\\'},
      {'input' : ' A N Z ', 'expectedOutput' : '/ \\/// /\\/\\'},

      {'input' : '123456789', 'expectedOutput' : ''},

      {'input' : 'anz', 'expectedOutput' : '/ \\/// /\\/\\'},
      {'input' : '1A  n §%/ z ', 'expectedOutput' : '/ \\/// /\\/\\'},
      {'input' : '/ \\/// /\\/\\', 'expectedOutput' : ''},

      {'input' : 'ANZ', 'replaceCharacters': {'/': '0', '\\': '1'}, 'expectedOutput' : '0 1000 0101'},
      {'input' : 'ANZ', 'replaceCharacters': {'/': '\\', '\\': '/'}, 'expectedOutput' : '\\ /\\\\\\ \\/\\/'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}', () {
        var _actual = encryptTomTom(elem['input'], elem['replaceCharacters']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("TomTom.decryptTomTom:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': null, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': <String, String>{}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/'}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/', '\\': '\\'}, 'expectedOutput' : ''},

      {'input' : '/', 'expectedOutput' : 'A'},
      {'input' : '\\///', 'expectedOutput' : 'N'},
      {'input' : '/\\/\\','expectedOutput' : 'Z'},

      {'input' : '/ \\/// /\\/\\', 'expectedOutput' : 'ANZ'},
      {'input' : '/  \\///  /\\/\\', 'expectedOutput' : 'ANZ'},
      {'input' : '  /   \\///   /\\/\\  ', 'expectedOutput' : 'ANZ'},

      {'input' : '///// \\\\\\\\\\ /\\/\\/\\/\\', 'expectedOutput' : ''},

      {'input' : '/ \\/// /\\/\\', 'replaceCharacters': {'/': '0', '\\': '1'}, 'expectedOutput' : 'ANZ'},
      {'input' : '/ \\/// /\\/\\', 'replaceCharacters': {'/': '\\', '\\': '/'}, 'expectedOutput' : 'IY'},

      {'input' : '0 1000 0101', 'replaceCharacters': {'/': '0', '\\': '1'}, 'expectedOutput' : 'ANZ'},
      {'input' : '1 0111 1010', 'replaceCharacters': {'/': '1', '\\': '0'}, 'expectedOutput' : 'ANZ'},

      {'input' : '- \\--- -\\-\\', 'replaceCharacters': {'/': '-'}, 'expectedOutput' : 'ANZ'},
      {'input' : '] []]] ][][', 'replaceCharacters': {'/': ']', '\\': '['}, 'expectedOutput' : 'ANZ'},

      {'input' : '/ \\/// /\\/\\', 'replaceCharacters': {'/': '', '\\': ''}, 'expectedOutput' : 'ANZ'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}', () {
        var _actual = decryptTomTom(elem['input'], elem['replaceCharacters']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}