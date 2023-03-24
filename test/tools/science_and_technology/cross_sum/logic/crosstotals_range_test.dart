import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals_range.dart';

void main() {
  group("CrossSum.crossSumRange:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      {'rangeStart' : 0, 'rangeEnd' : 100, 'crossSumToFind' : 15, 'expectedOutput' : [69, 78, 87, 96]},
      {'rangeStart' : 0, 'rangeEnd' : -100, 'crossSumToFind' : -15, 'expectedOutput' : [-96, -87, -78, -69]},
      {'rangeStart' : -100, 'rangeEnd' : 100, 'crossSumToFind' : 15, 'expectedOutput' : [69, 78, 87, 96]},
      {'rangeStart' : 0, 'rangeEnd' : 100, 'crossSumToFind' : 50, 'expectedOutput' : []},
    ];

    for (var elem in _inputsToExpected) {
      test('rangeStart: ${elem['rangeStart']}, rangeEnd: ${elem['rangeEnd']}, crossSumToFind: ${elem['crossSumToFind']},', () {
        var _actual = crossSumRange(elem['rangeStart'] as int, elem['rangeEnd'] as int, elem['crossSumToFind'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CrossSum.crossSumRangeIterated:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      {'rangeStart' : 0, 'rangeEnd' : 100, 'crossSumToFind' : 1, 'type': CrossSumType.ITERATED, 'expectedOutput' : [1, 10, 19, 28, 37, 46, 55, 64, 73, 82, 91, 100]},
      {'rangeStart' : 0, 'rangeEnd' : -100, 'crossSumToFind' : -5, 'type': CrossSumType.ITERATED, 'expectedOutput' : [-95, -86, -77, -68, -59, -50, -41, -32, -23, -14, -5]},
      {'rangeStart' : -100, 'rangeEnd' : 100, 'crossSumToFind' : 5, 'type': CrossSumType.ITERATED, 'expectedOutput' : [5, 14, 23, 32, 41, 50, 59, 68, 77, 86, 95]},
      {'rangeStart' : 0, 'rangeEnd' : 100, 'crossSumToFind' : 10, 'type': CrossSumType.ITERATED, 'expectedOutput' : []},
    ];

    for (var elem in _inputsToExpected) {
      test('rangeStart: ${elem['rangeStart']}, rangeEnd: ${elem['rangeEnd']}, crossSumToFind: ${elem['crossSumToFind']}, type: ${elem['type']}', () {
        var _actual = crossSumRange(elem['rangeStart'] as int, elem['rangeEnd'] as int, elem['crossSumToFind'] as int, type: elem['type'] as CrossSumType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("CrossSum.crossSumRangeFrequencies:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      {'rangeStart' : 0, 'rangeEnd' : 100,'expectedOutput' : {0:1, 1:3, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:9,11:8, 12:7, 13: 6, 14:5, 15:4, 16:3, 17:2, 18:1}},
      {'rangeStart' : 0, 'rangeEnd' : -100, 'expectedOutput' : {-1: 3,-18: 1,-17: 2,-16: 3,-15: 4,-14: 5, -13: 6,-12: 7,-11: 8,-10: 9,-9: 10, -8: 9,-7: 8,-6: 7,-5: 6,-4: 5,-3: 4,-2: 3,0: 1}},
      {'rangeStart' : -100, 'rangeEnd' : 100, 'expectedOutput' : {-1: 3, -18: 1, -17: 2, -16: 3, -15: 4, -14: 5, -13: 6, -12: 7, -11: 8, -10: 9, -9: 10, -8: 9, -7: 8, -6: 7, -5: 6, -4: 5, -3: 4, -2: 3, 0: 1, 1: 3, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 8, 8: 9, 9: 10, 10: 9, 11: 8, 12: 7, 13: 6, 14: 5, 15: 4, 16: 3, 17: 2, 18: 1}},
      {'rangeStart' : 100, 'rangeEnd' : 0, 'expectedOutput' : {0:1, 1:3, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:9,11:8, 12:7, 13: 6, 14:5, 15:4, 16:3, 17:2, 18:1}},
    ];

    for (var elem in _inputsToExpected) {
      test('rangeStart: ${elem['rangeStart']}, rangeEnd: ${elem['rangeEnd']}', () {
        var _actual = crossSumRangeFrequencies(elem['rangeStart'] as int, elem['rangeEnd'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
