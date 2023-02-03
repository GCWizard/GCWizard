import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';

void main() {
  group("Substitution.substitution:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'substitution': null, 'caseSensitive': true, 'expectedOutput' : ''},
      {'input' : '', 'substitution': null, 'caseSensitive': true, 'expectedOutput' : ''},
      {'input' : null, 'substitution': Map<String, String>(), 'caseSensitive': true, 'expectedOutput' : ''},
      {'input' : 'ABC', 'substitution': Map<String, String>(), 'caseSensitive': true, 'expectedOutput' : 'ABC'},
      {'input' : 'Abc123', 'substitution': Map<String, String>(), 'caseSensitive': true, 'expectedOutput' : 'Abc123'},
      {'input' : 'ABC', 'substitution': {'': '1'}, 'caseSensitive': true, 'expectedOutput' : 'ABC'},

      {'input' : 'ABCDEF', 'substitution': {'A': '1', 'B':'2', 'F': '6'}, 'caseSensitive': true, 'expectedOutput' : '12CDE6'},
      {'input' : 'ABCDEF', 'substitution': {'A': '1', 'b':'2', 'f': '6'}, 'caseSensitive': true, 'expectedOutput' : '1BCDEF'},
      {'input' : 'abCDEF', 'substitution': {'A': '1', 'b':'2', 'f': '6'}, 'caseSensitive': true, 'expectedOutput' : 'a2CDEF'},
      {'input' : 'ABCDEF', 'substitution': {'A': '1', 'b':'2', 'f': '6'}, 'caseSensitive': false, 'expectedOutput' : '12CDE6'},
      {'input' : 'abCDEF', 'substitution': {'A': '1', 'b':'2', 'f': '6'}, 'caseSensitive': false, 'expectedOutput' : '12CDE6'},

      {'input' : 'ABBBA', 'substitution': {'BB': '1'}, 'caseSensitive': true, 'expectedOutput' : 'A1BA'},
      {'input' : 'ABCD', 'substitution': {'A': '1', 'BC': '2', 'BCD': '3'}, 'caseSensitive': true, 'expectedOutput' : '13'},
      {'input' : 'ABAB', 'substitution': {'A': 'B', 'B': 'A'}, 'caseSensitive': true, 'expectedOutput' : 'BABA'},
      {'input' : 'ABAB', 'substitution': {'A': 'B', 'B': 'C', 'C': 'A'}, 'caseSensitive': true, 'expectedOutput' : 'BCBC'},

      {'input' : 'CADBEFAGB', 'substitution': {'A': 'B', 'B': 'A'}, 'caseSensitive': true, 'expectedOutput' : 'CBDAEFBGA'},
      {'input' : 'CADBEFAGB', 'substitution': {'A': 'B', 'B': 'C', 'C': 'A'}, 'caseSensitive': true, 'expectedOutput' : 'ABDCEFBGC'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, substitution: ${elem['substitution']}, caseSensitive: ${elem['caseSensitive']}', () {


        var _actual = substitution(elem['input'], elem['substitution'], caseSensitive: elem['caseSensitive']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}