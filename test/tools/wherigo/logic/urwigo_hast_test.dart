import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/wherigo/logic/urwigo_tools.dart';
import 'package:gc_wizard/tools/wherigo/krevo/logic/ucommons.dart';

void main() {

  group("Wherigo.Urwigo_Hash_encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '',  'expectedOutput' : 0},

      {'input' : '29735', 'expectedOutput' : 0},
      {'input' : '29735', 'expectedOutput' : 0},

      {'input' : '220468', 'expectedOutput' : 7451},
      {'input' : '170505', 'expectedOutput' : 7451},

      {'input' : 'gcwizard', 'expectedOutput' : 2663},
      {'input' : 'GCWIZARD', 'expectedOutput' : 2663},
      {'input' : 'ivkp', 'expectedOutput' : 2663},
      {'input' : 'IVKP', 'expectedOutput' : 2663},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = RSHash((elem['input'] as String).toLowerCase());
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Wherigo.Urwigo_Hash_decode_alphabtic:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 0,  'expectedOutput' : 'bgqv'},
      //{'expectedOutput' : 'gcwizard', 'input' : 2663}, // not feasable - there are several outputs which produces 2663
      {'expectedOutput' : 'ivkp', 'input' : 2663},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = breakUrwigoHash(elem['input'] as int, HASH.ALPHABETICAL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Wherigo.Urwigo_Hash_decode_numeric:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 0,  'expectedOutput' : '29735'},
      //{'expectedOutput' : '220468', 'input' : 7451}, // not feasable - there are several outputs which produces 2663
      {'expectedOutput' : '170505', 'input' : 7451},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = breakUrwigoHash(elem['input'] as int, HASH.NUMERIC);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
