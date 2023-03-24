import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';

void main() {
  group("divisor", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 0, 'expectedOutput' : [0]},
      {'input' : 1, 'expectedOutput' : [1]},
      {'input' : 2, 'expectedOutput' : [1, 2]},
      {'input' : 10, 'expectedOutput' : [1, 2, 5, 10]},
      {'input' : 24, 'expectedOutput' : [1, 2, 3, 4, 6, 8, 12, 24]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = divisors(elem['input'] as int);
        expect(_actual, elem['expectedOutput']);
        var length = (elem['expectedOutput'] as List<int>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i], (elem['expectedOutput'] as List<int>)[i]);
        }
      });
    }
  });

}