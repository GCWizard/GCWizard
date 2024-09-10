import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/slash_and_pipe/logic/slash_and_pipe.dart';

void main() {
  group("SlashAndPipe.encryptSlashAndPipe:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': null, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': <String, String>{}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/'}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/', '\\': '\\'}, 'expectedOutput' : ''},

      {'input' : 'A', 'expectedOutput' : '|'},
      {'input' : 'N', 'expectedOutput' : '|/|'},
      {'input' : 'Z', 'expectedOutput' : '||||'},

      {'input' : 'ANZ', 'expectedOutput' : '| |/| ||||'},
      {'input' : 'A N Z', 'expectedOutput' : '| |/| ||||'},
      {'input' : ' A N Z ', 'expectedOutput' : '| |/| ||||'},

      {'input' : '123456789', 'expectedOutput' : ''},

      {'input' : 'anz', 'expectedOutput' : '| |/| ||||'},
      {'input' : '1A  n §%/ z ', 'expectedOutput' : '| |/| ||||'},
      {'input' : '| |/| ||||', 'expectedOutput' : ''},

      {'input' : 'ANZ', 'replaceCharacters': {'/': '0', '\\': '1', '|': '3'}, 'expectedOutput' : '3 303 3333'},
      {'input' : 'ANZ', 'replaceCharacters': {'/': '\\', '\\': '/', '|': '-'}, 'expectedOutput' : '- -\\- ----'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}', () {
        var _actual = encryptSlashAndPipe(elem['input'] as String, SLASHANDPIPE_TYPES.COMMON, elem['replaceCharacters'] as Map<String, String>?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("SlashAndPipe.decryptSlashAndPipe:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': null, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': <String, String>{}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/'}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {'/': '/', '\\': '\\'}, 'expectedOutput' : ''},

      {'input' : '|', 'expectedOutput' : 'A'},
      {'input' : '|/|', 'expectedOutput' : 'N'},
      {'input' : '||||','expectedOutput' : 'Z'},

      {'input' : '| |/| ||||', 'expectedOutput' : 'ANZ'},
      {'input' : '|  |/|  ||||', 'expectedOutput' : 'ANZ'},
      {'input' : '  |  |/|     ||||  ', 'expectedOutput' : 'ANZ'},

      {'input' : '///// \\\\\\\\\\ /\\/\\/\\/\\', 'expectedOutput' : ''},

      {'input' : '2 202 2222', 'replaceCharacters': {'/': '0', '\\': '1', '|': '2'}, 'expectedOutput' : 'ANZ'},
      {'input' : '2 212 2222', 'replaceCharacters': {'/': '1', '\\': '0', '|': '2'}, 'expectedOutput' : 'ANZ'},

      {'input' : '| |-| ||||', 'replaceCharacters': {'/': '-'}, 'expectedOutput' : 'ANZ'},
      {'input' : '[ [][ [[[[', 'replaceCharacters': {'/': ']', '|': '['}, 'expectedOutput' : 'ANZ'},

      // https://www.geocaching.com/geocache/GCA5MD9
      {'input' : '|/ \\ // ||/    |/| \\ // ||\\    \\ // / |//    |||| \\ \\/ ||/|    /| / ||/    // |/|', 'expectedOutput' : 'DPUH NPUF UIO ZPR TIH UN'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}', () {
        var _actual = decryptSlashAndPipe(elem['input'] as String, SLASHANDPIPE_TYPES.COMMON, elem['replaceCharacters'] as Map<String, String>?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}