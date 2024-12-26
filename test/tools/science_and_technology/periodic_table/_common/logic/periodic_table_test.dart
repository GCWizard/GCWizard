import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/periodic_table.dart';
import 'package:gc_wizard/utils/constants.dart';

void main() {
  group("PeriodicTable.atomicNumbersToText:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'atomicNumbers' : <int>[], 'expectedOutput' : ''},

      {'atomicNumbers' : [1,2,3], 'expectedOutput' : 'HHeLi'},
      {'atomicNumbers' : [4,16,73], 'expectedOutput' : 'BeSTa'},
      {'atomicNumbers' : [4,16,-1], 'expectedOutput' : 'BeS'+ UNKNOWN_ELEMENT},
    ];

    for (var elem in _inputsToExpected) {
      test('atomicNumbers: ${elem['atomicNumbers']}', () {
        var _actual = atomicNumbersToText(elem['atomicNumbers'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("PeriodicTable.textToAtomicNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : <int>[], 'text' : ''},

      {'expectedOutput' : [1,2,3], 'text' : 'HHeLi'},
      {'expectedOutput' : [4,16,73], 'text' : 'BeSTa'},

      {'expectedOutput' : [32, 8, 20, 6, 2], 'text' : 'GeOCaCHe'},
      {'expectedOutput' : [null, null, 8, 20, 6, 2], 'text' : 'GEOCaCHe'},
      {'expectedOutput' : [32, 8, null], 'text' : 'GeOCache'},
      {'expectedOutput' : [32, 8, 20, 6, 2], 'text' : 'GeO CaCHe'},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = textToAtomicNumbers(elem['text'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}