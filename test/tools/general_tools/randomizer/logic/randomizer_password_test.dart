import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer_password.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';

void main() {
  group("RandomizerPassword.bitEntropy:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : 0.0},
      {'input' : '012', 'expectedOutput' : 9.965784284662089},
      {'input' : 'A', 'expectedOutput' : 4.700439718141093},
      {'input' : 'ABC', 'expectedOutput' : 14.101319154423278},
      {'input' : 'AbC', 'expectedOutput' : 17.10131915442328},
      {'input' : 'Ab1', 'expectedOutput' : 17.862588931160627},
      {'input' : 'A 1', 'expectedOutput' : 19.70956682499284},
      {'input' : 'a1', 'expectedOutput' : 10.339850002884624},
      {'input' : 'à1', 'expectedOutput' : 13.428491035332245},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = bitEntropy(elem['input'] as String);
        expect(doubleEquals(_actual, elem['expectedOutput'] as double), true);
      });
    }
  });
}