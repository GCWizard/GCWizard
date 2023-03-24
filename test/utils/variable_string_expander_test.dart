import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/variable_string_expander.dart';

void main() {

  group("VariableStringExpander.run:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [0][0^1].[4]23', variables: {'A': '1', 'B': '0', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [0][0^1].[4]23', variables: {'A': '1', 'B': '0', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [1][1^1].[4]23', variables: {'A': '1', 'B': '1', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [1][1^1].[4]23', variables: {'A': '1', 'B': '1', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [2][2^1].[4]23', variables: {'A': '1', 'B': '2', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [2][2^1].[4]23', variables: {'A': '1', 'B': '2', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [4][4^1].[4]23', variables: {'A': '1', 'B': '4', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [4][4^1].[4]23', variables: {'A': '1', 'B': '4', 'C': '34'}),

          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [0][0^2].[4]23', variables: {'A': '2', 'B': '0', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [0][0^2].[4]23', variables: {'A': '2', 'B': '0', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [1][1^2].[4]23', variables: {'A': '2', 'B': '1', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [1][1^2].[4]23', variables: {'A': '2', 'B': '1', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [2][2^2].[4]23', variables: {'A': '2', 'B': '2', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [2][2^2].[4]23', variables: {'A': '2', 'B': '2', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [4][4^2].[4]23', variables: {'A': '2', 'B': '4', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[2][2+1] E [4][4^2].[4]23', variables: {'A': '2', 'B': '4', 'C': '34'}),

          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [0][0^3].[4]23', variables: {'A': '3', 'B': '0', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [0][0^3].[4]23', variables: {'A': '3', 'B': '0', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [1][1^3].[4]23', variables: {'A': '3', 'B': '1', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [1][1^3].[4]23', variables: {'A': '3', 'B': '1', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [2][2^3].[4]23', variables: {'A': '3', 'B': '2', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [2][2^3].[4]23', variables: {'A': '3', 'B': '2', 'C': '34'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [4][4^3].[4]23', variables: {'A': '3', 'B': '4', 'C': '12'}),
          VariableStringExpanderValue(text: 'N 51.[3][3+1] E [4][4^3].[4]23', variables: {'A': '3', 'B': '4', 'C': '34'}),
        ]
      },
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.BREAK_ON_FIRST_FOUND,
        'expectedOutput': [
          VariableStringExpanderValue(text: 'N 51.[1][1+1] E [0][0^1].[4]23', variables: {'A': '1', 'B': '0', 'C': '12'}),
        ]
      },
      {'input': 'A', 'substitutions': {'A': '1'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '1', variables: {'A': '1'}),
        ]
      },
      {'input': 'A', 'substitutions': {'A': '1-3'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '1', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '2', variables: {'A': '2'}),
          VariableStringExpanderValue(text: '3', variables: {'A': '3'}),
        ]
      },
      {'input': 'AA', 'substitutions': {'A': '1-3'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '11', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '22', variables: {'A': '2'}),
          VariableStringExpanderValue(text: '33', variables: {'A': '3'}),
        ]
      },
      {'input': 'AB', 'substitutions': {'A': '1-3', 'B': '4,6'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '14', variables: {'A': '1', 'B': '4'}),
          VariableStringExpanderValue(text: '16', variables: {'A': '1', 'B': '6'}),
          VariableStringExpanderValue(text: '24', variables: {'A': '2', 'B': '4'}),
          VariableStringExpanderValue(text: '26', variables: {'A': '2', 'B': '6'}),
          VariableStringExpanderValue(text: '34', variables: {'A': '3', 'B': '4'}),
          VariableStringExpanderValue(text: '36', variables: {'A': '3', 'B': '6'})
        ]
      },
      {'input': 'N49 32.[n] E010 59.[e]', 'substitutions': {'n':'3-5', 'e': '7'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: 'N49 32.[3] E010 59.[7]', variables: {'N': '3', 'E': '7'}),
          VariableStringExpanderValue(text: 'N49 32.[4] E010 59.[7]', variables: {'N': '4', 'E': '7'}),
          VariableStringExpanderValue(text: 'N49 32.[5] E010 59.[7]', variables: {'N': '5', 'E': '7'}),
        ]
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(
            elem['input'] as String,
            elem['substitutions'] as Map<String, String>?,
            onAfterExpandedText: elem['onAfterExpandedText'] as String? Function(String)?,
            breakCondition: elem['breakCondition'] as VariableStringExpanderBreakCondition)
            .run();
        var expected = elem['expectedOutput'] as List<VariableStringExpanderValue>;
        expect(_actual.length, expected.length);

        for (var i=0; i<_actual.length; i++) {
          expect(_actual[i].text, expected[i].text);
          expect(_actual[i].variables, expected[i].variables);
        }
      });
    }
  });

  group("VariableStringExpander.runError:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'A', 'substitutions': {'A': '1-Z', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [VariableStringExpanderValue(text: 'A', variables: null)]
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(
            elem['input'] as String,
            elem['substitutions'] as Map<String, String>?,
            onAfterExpandedText: elem['onAfterExpandedText'] as String? Function(String)?,
            breakCondition: elem['breakCondition'] as VariableStringExpanderBreakCondition)
            .run();

        var expected = elem['expectedOutput'] as List<VariableStringExpanderValue>;
        expect(_actual.length, expected.length);

        for (var i=0; i<_actual.length; i++) {
          expect(_actual[i].text, expected[i].text);
          expect(_actual[i].variables, expected[i].variables);
        }
      });
    }
  });

  group("VariableStringExpander.runUnorderedNotUnique:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'AA', 'substitutions': {'A': '3-1'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '33', variables: {'A': '3'}),
          VariableStringExpanderValue(text: '22', variables: {'A': '2'}),
          VariableStringExpanderValue(text: '11', variables: {'A': '1'}),
        ]
      },
      {'input': 'A', 'substitutions': {'A': '  5    - 1#   2, 10    -12,   23, 30-40  #5,50-  47   ,100'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '5', variables: {'A': '5'}),
          VariableStringExpanderValue(text: '3', variables: {'A': '3'}),
          VariableStringExpanderValue(text: '1', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '10', variables: {'A': '10'}),
          VariableStringExpanderValue(text: '11', variables: {'A': '11'}),
          VariableStringExpanderValue(text: '12', variables: {'A': '12'}),
          VariableStringExpanderValue(text: '23', variables: {'A': '23'}),
          VariableStringExpanderValue(text: '30', variables: {'A': '30'}),
          VariableStringExpanderValue(text: '35', variables: {'A': '35'}),
          VariableStringExpanderValue(text: '40', variables: {'A': '40'}),
          VariableStringExpanderValue(text: '50', variables: {'A': '50'}),
          VariableStringExpanderValue(text: '49', variables: {'A': '49'}),
          VariableStringExpanderValue(text: '48', variables: {'A': '48'}),
          VariableStringExpanderValue(text: '47', variables: {'A': '47'}),
          VariableStringExpanderValue(text: '100', variables: {'A': '100'}),
        ]
      },
      {'input': 'AA', 'substitutions': {'A': '1,2,1,1,2'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '11', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '22', variables: {'A': '2'}),
          VariableStringExpanderValue(text: '11', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '11', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '22', variables: {'A': '2'}),
        ]
      },
      {'input': 'AA', 'substitutions': {'A': '3-1,2-4'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          VariableStringExpanderValue(text: '33', variables: {'A': '3'}),
          VariableStringExpanderValue(text: '22', variables: {'A': '2'}),
          VariableStringExpanderValue(text: '11', variables: {'A': '1'}),
          VariableStringExpanderValue(text: '22', variables: {'A': '2'}),
          VariableStringExpanderValue(text: '33', variables: {'A': '3'}),
          VariableStringExpanderValue(text: '44', variables: {'A': '4'}),
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(
            elem['input'] as String,
            elem['substitutions'] as Map<String, String>?,
            onAfterExpandedText: elem['onAfterExpandedText'] as String? Function(String)?,
            breakCondition: elem['breakCondition'] as VariableStringExpanderBreakCondition,
            orderAndUnique: false).run();

        var expected = elem['expectedOutput'] as List<VariableStringExpanderValue>;
        expect(_actual.length, expected.length);

        for (var i=0; i<_actual.length; i++) {
          expect(_actual[i].text, expected[i].text);
          expect(_actual[i].variables, expected[i].variables);
        }
      });
    }
  });

  group("VariableStringExpander.runOnlyPrecheckWithSpaces:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1- 3', 'B': '4 -0#  2,  1', 'C': '12  ,34,  10'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [VariableStringExpanderValue(count : 36)]
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(
            elem['input'] as String,
            elem['substitutions'] as Map<String, String>?,
            onAfterExpandedText: elem['onAfterExpandedText'] as String? Function(String)?,
            breakCondition: elem['breakCondition'] as VariableStringExpanderBreakCondition)
            .run(onlyPrecheck: true);

        var expected = elem['expectedOutput'] as List<VariableStringExpanderValue>;
        expect(_actual.length, expected.length);

        for (var i=0; i<_actual.length; i++) {
          expect(_actual[i].count, expected[i].count);
        }
      });
    }
  });

  group("VariableStringExpander.runOnlyPrecheck:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (String e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [VariableStringExpanderValue(count : 24)]
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(
            elem['input'] as String,
            elem['substitutions'] as Map<String, String>?,
            onAfterExpandedText: elem['onAfterExpandedText'] as String? Function(String)?,
            breakCondition: elem['breakCondition'] as VariableStringExpanderBreakCondition)
            .run(onlyPrecheck: true);

        var expected = elem['expectedOutput'] as List<VariableStringExpanderValue>;
        expect(_actual.length, expected.length);

        for (var i=0; i<_actual.length; i++) {
          expect(_actual[i].count, expected[i].count);
         }
      });
    }
  });
}