import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/variable_string_expander.dart';

void main() {

  group("VariableStringExpander.run:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': 'N 51.[1][1+1] E [0][0^1].[4]23', 'variables': {'A': '1', 'B': '0', 'C': '12'}},
          {'text': 'N 51.[1][1+1] E [0][0^1].[4]23', 'variables': {'A': '1', 'B': '0', 'C': '34'}},
          {'text': 'N 51.[1][1+1] E [1][1^1].[4]23', 'variables': {'A': '1', 'B': '1', 'C': '12'}},
          {'text': 'N 51.[1][1+1] E [1][1^1].[4]23', 'variables': {'A': '1', 'B': '1', 'C': '34'}},
          {'text': 'N 51.[1][1+1] E [2][2^1].[4]23', 'variables': {'A': '1', 'B': '2', 'C': '12'}},
          {'text': 'N 51.[1][1+1] E [2][2^1].[4]23', 'variables': {'A': '1', 'B': '2', 'C': '34'}},
          {'text': 'N 51.[1][1+1] E [4][4^1].[4]23', 'variables': {'A': '1', 'B': '4', 'C': '12'}},
          {'text': 'N 51.[1][1+1] E [4][4^1].[4]23', 'variables': {'A': '1', 'B': '4', 'C': '34'}},

          {'text': 'N 51.[2][2+1] E [0][0^2].[4]23', 'variables': {'A': '2', 'B': '0', 'C': '12'}},
          {'text': 'N 51.[2][2+1] E [0][0^2].[4]23', 'variables': {'A': '2', 'B': '0', 'C': '34'}},
          {'text': 'N 51.[2][2+1] E [1][1^2].[4]23', 'variables': {'A': '2', 'B': '1', 'C': '12'}},
          {'text': 'N 51.[2][2+1] E [1][1^2].[4]23', 'variables': {'A': '2', 'B': '1', 'C': '34'}},
          {'text': 'N 51.[2][2+1] E [2][2^2].[4]23', 'variables': {'A': '2', 'B': '2', 'C': '12'}},
          {'text': 'N 51.[2][2+1] E [2][2^2].[4]23', 'variables': {'A': '2', 'B': '2', 'C': '34'}},
          {'text': 'N 51.[2][2+1] E [4][4^2].[4]23', 'variables': {'A': '2', 'B': '4', 'C': '12'}},
          {'text': 'N 51.[2][2+1] E [4][4^2].[4]23', 'variables': {'A': '2', 'B': '4', 'C': '34'}},

          {'text': 'N 51.[3][3+1] E [0][0^3].[4]23', 'variables': {'A': '3', 'B': '0', 'C': '12'}},
          {'text': 'N 51.[3][3+1] E [0][0^3].[4]23', 'variables': {'A': '3', 'B': '0', 'C': '34'}},
          {'text': 'N 51.[3][3+1] E [1][1^3].[4]23', 'variables': {'A': '3', 'B': '1', 'C': '12'}},
          {'text': 'N 51.[3][3+1] E [1][1^3].[4]23', 'variables': {'A': '3', 'B': '1', 'C': '34'}},
          {'text': 'N 51.[3][3+1] E [2][2^3].[4]23', 'variables': {'A': '3', 'B': '2', 'C': '12'}},
          {'text': 'N 51.[3][3+1] E [2][2^3].[4]23', 'variables': {'A': '3', 'B': '2', 'C': '34'}},
          {'text': 'N 51.[3][3+1] E [4][4^3].[4]23', 'variables': {'A': '3', 'B': '4', 'C': '12'}},
          {'text': 'N 51.[3][3+1] E [4][4^3].[4]23', 'variables': {'A': '3', 'B': '4', 'C': '34'}},
        ]
      },
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.BREAK_ON_FIRST_FOUND,
        'expectedOutput': [
          {'text': 'N 51.[1][1+1] E [0][0^1].[4]23', 'variables': {'A': '1', 'B': '0', 'C': '12'}},
        ]
      },
      {'input': 'A', 'substitutions': {'A': '1'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '1', 'variables': {'A': '1'}},
        ]
      },
      {'input': 'A', 'substitutions': {'A': '1-3'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '1', 'variables': {'A': '1'}},
          {'text': '2', 'variables': {'A': '2'}},
          {'text': '3', 'variables': {'A': '3'}},
        ]
      },
      {'input': 'AA', 'substitutions': {'A': '1-3'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '11', 'variables': {'A': '1'}},
          {'text': '22', 'variables': {'A': '2'}},
          {'text': '33', 'variables': {'A': '3'}},
        ]
      },
      {'input': 'AB', 'substitutions': {'A': '1-3', 'B': '4,6'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '14', 'variables': {'A': '1', 'B': '4'}},
          {'text': '16', 'variables': {'A': '1', 'B': '6'}},
          {'text': '24', 'variables': {'A': '2', 'B': '4'}},
          {'text': '26', 'variables': {'A': '2', 'B': '6'}},
          {'text': '34', 'variables': {'A': '3', 'B': '4'}},
          {'text': '36', 'variables': {'A': '3', 'B': '6'}}
        ]
      },
      {'input': 'N49 32.[n] E010 59.[e]', 'substitutions': {'n':'3-5', 'e': '7'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': 'N49 32.[3] E010 59.[7]', 'variables': {'N': '3', 'E': '7'}},
          {'text': 'N49 32.[4] E010 59.[7]', 'variables': {'N': '4', 'E': '7'}},
          {'text': 'N49 32.[5] E010 59.[7]', 'variables': {'N': '5', 'E': '7'}},
        ]
      }
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(elem['input'], elem['substitutions'], onAfterExpandedText: elem['onAfterExpandedText'], breakCondition: elem['breakCondition']).run();
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("VariableStringExpander.runError:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': 'A', 'substitutions': {'A': '1-Z', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [{'text': 'A', 'variables': {}}]
      },
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(elem['input'], elem['substitutions'], onAfterExpandedText: elem['onAfterExpandedText'], breakCondition: elem['breakCondition']).run();
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("VariableStringExpander.runUnorderedNotUnique:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': 'AA', 'substitutions': {'A': '3-1'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '33', 'variables': {'A': '3'}},
          {'text': '22', 'variables': {'A': '2'}},
          {'text': '11', 'variables': {'A': '1'}},
        ]
      },
      {'input': 'A', 'substitutions': {'A': '  5    - 1#   2, 10    -12,   23, 30-40  #5,50-  47   ,100'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '5', 'variables': {'A': '5'}},
          {'text': '3', 'variables': {'A': '3'}},
          {'text': '1', 'variables': {'A': '1'}},
          {'text': '10', 'variables': {'A': '10'}},
          {'text': '11', 'variables': {'A': '11'}},
          {'text': '12', 'variables': {'A': '12'}},
          {'text': '23', 'variables': {'A': '23'}},
          {'text': '30', 'variables': {'A': '30'}},
          {'text': '35', 'variables': {'A': '35'}},
          {'text': '40', 'variables': {'A': '40'}},
          {'text': '50', 'variables': {'A': '50'}},
          {'text': '49', 'variables': {'A': '49'}},
          {'text': '48', 'variables': {'A': '48'}},
          {'text': '47', 'variables': {'A': '47'}},
          {'text': '100', 'variables': {'A': '100'}},
        ]
      },
      {'input': 'AA', 'substitutions': {'A': '1,2,1,1,2'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '11', 'variables': {'A': '1'}},
          {'text': '22', 'variables': {'A': '2'}},
          {'text': '11', 'variables': {'A': '1'}},
          {'text': '11', 'variables': {'A': '1'}},
          {'text': '22', 'variables': {'A': '2'}},
        ]
      },
      {'input': 'AA', 'substitutions': {'A': '3-1,2-4'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [
          {'text': '33', 'variables': {'A': '3'}},
          {'text': '22', 'variables': {'A': '2'}},
          {'text': '11', 'variables': {'A': '1'}},
          {'text': '22', 'variables': {'A': '2'}},
          {'text': '33', 'variables': {'A': '3'}},
          {'text': '44', 'variables': {'A': '4'}},
        ]
      },
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(elem['input'], elem['substitutions'], onAfterExpandedText: elem['onAfterExpandedText'], breakCondition: elem['breakCondition'], orderAndUnique: false).run();
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("VariableStringExpander.runOnlyPrecheckWithSpaces:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1- 3', 'B': '4 -0#  2,  1', 'C': '12  ,34,  10'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [{'count' : 36}]
      }
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(elem['input'], elem['substitutions'], onAfterExpandedText: elem['onAfterExpandedText'], breakCondition: elem['breakCondition']).run(onlyPrecheck: true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("VariableStringExpander.runOnlyPrecheck:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': 'N 51.[A][A+1] E [B][B^A].[4]23', 'substitutions': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'onAfterExpandedText' : (e) => e, 'breakCondition' : VariableStringExpanderBreakCondition.RUN_ALL,
        'expectedOutput': [{'count' : 24}]
      }
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, substitutions: ${elem['substitutions']}', () {
        var _actual = VariableStringExpander(elem['input'], elem['substitutions'], onAfterExpandedText: elem['onAfterExpandedText'], breakCondition: elem['breakCondition']).run(onlyPrecheck: true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}