import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/combinatorics/combination/logic/combination.dart';

void main() {
  group("Combinatorics.Combinations.generateCombinations:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'avoidDuplicates': true, 'expectedOutput' : []},
      {'input' : '', 'avoidDuplicates': false, 'expectedOutput' : []},

      {'input' : '123', 'avoidDuplicates': true, 'expectedOutput' : ['1', '2', '3', '12', '13', '23', '123']},
      {'input' : 'AbC', 'avoidDuplicates': true, 'expectedOutput' : ['A', 'b', 'C', 'Ab', 'AC', 'bC', 'AbC']},
      {'input' : 'AbbC', 'avoidDuplicates': true, 'expectedOutput' : ['A', 'b', 'C', 'Ab', 'AC', 'bb', 'bC', 'Abb', 'AbC', 'bbC', 'AbbC']},
      {'input' : 'AbbC', 'avoidDuplicates': false, 'expectedOutput' : ['A', 'b', 'b', 'C', 'Ab', 'Ab', 'AC', 'bb', 'bC', 'bC', 'Abb', 'AbC', 'AbC', 'bbC', 'AbbC']},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, avoidDuplicates: ${elem['avoidDuplicates']}', () {
        var _actual = generateCombinations(elem['input'] as String, avoidDuplicates: elem['avoidDuplicates'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
