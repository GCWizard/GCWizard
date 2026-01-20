import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/data_type_utils/num_type_utils.dart';

void main() {
  group("NumTypeUtils.sign:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'value': 1.0, 'expectedOutput': 1},
      {'value': 1, 'expectedOutput': 1},
      {'value': 0.0, 'expectedOutput': 1},
      {'value': -0, 'expectedOutput': 1},
      {'value': -0.1, 'expectedOutput': -1},
      {'value': -1, 'expectedOutput': -1},
    ];

    for (var elem in _inputsToExpected) {
      test(
          'value: ${elem['value']}', () {
        var _actual = sign(elem['value'] as num);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}