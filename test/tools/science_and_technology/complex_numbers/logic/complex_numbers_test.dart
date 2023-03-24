import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/complex_numbers/logic/complex_numbers.dart';

void main() {
  group("ComplexNumbers.CartesianToPolar:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'a' : '', 'b' : '', 'expectedOutput' : ['']},
      {'a' : '0.0', 'b' : '0.0', 'expectedOutput' : ['0.0', '0.0']},
      {'a' : '1,91372648', 'b' : '0.0', 'expectedOutput' : ['1.91372648', '0.0']},
      {'a' : '0.0', 'b' : '2,4914364', 'expectedOutput' : ['2.4914364', '90.0']},
      {'a' : '1,91372648', 'b' : '2,4914364', 'expectedOutput' : ['3.14159265', '52.47135']},
      {'a' : '3,05909465', 'b' : '0,71522325', 'expectedOutput' : ['3.14159265', '13.15950005']},
    ];

    for (var elem in _inputsToExpected) {
      test('a: ${elem['a']}, b: ${elem['b']}', () {
        var _actual = CartesianToPolar(elem['a'] as String, elem['b'] as String);
        var coordinate = _actual.values;
        for (int i = 0; i < coordinate.length; i++) {
          expect(coordinate.elementAt(i), (elem['expectedOutput'] as List<String>)[i]);
        }
      });
    }
  });

  group("ComplexNumbers.PolarToCartesian:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'r' : '', 'a' : '', 'expectedOutput' : ['']},
      {'r' : '0.0', 'a' : '0.0', 'expectedOutput' : ['0.0', '0.0']},
      {'r' : '3,14159265', 'a' : '0.0', 'expectedOutput' : ['3.1415927', '0.0']},
      {'r' : '0.0', 'a' : '52.47135', 'expectedOutput' : ['0.0', '0.0']},
      {'r' : '3,14159265', 'a' : '52.47135', 'expectedOutput' : ['1.9137265', '2.4914364']},
      {'r' : '3,14159265', 'a' : '13.1595001', 'expectedOutput' : ['3.0590946', '0.7152233']},
    ];

    for (var elem in _inputsToExpected) {
      test('r: ${elem['r']}, a: ${elem['a']}', () {
        var _actual = PolarToCartesian(elem['r'] as String, elem['a'] as String);
        var coordinate = _actual.values;
        for (int i = 0; i < coordinate.length; i++) {
          expect(coordinate.elementAt(i), (elem['expectedOutput'] as List<String>)[i]);
        }
      });
    }
  });
}
