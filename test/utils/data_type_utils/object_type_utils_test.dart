import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

void main() {
  group("ObjectTypeUtils.toDoubleOrNull:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : null},

      {'input' : 1, 'expectedOutput' : 1.0},
      {'input' : 1.0, 'expectedOutput' : 1.0},
      {'input' : 1.5, 'expectedOutput' : 1.5},

      {'input' : 'A', 'expectedOutput' : null},
      {'input' : true, 'expectedOutput' : null},
      {'input' : false, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = toDoubleOrNull(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ObjectTypeUtils.toIntOrNull:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : null},

      {'input' : 1, 'expectedOutput' : 1},
      {'input' : 1.0, 'expectedOutput' : 1},
      {'input' : 1.5, 'expectedOutput' : null},

      {'input' : 'A', 'expectedOutput' : null},
      {'input' : true, 'expectedOutput' : null},
      {'input' : false, 'expectedOutput' : null},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = toIntOrNull(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ObjectTypeUtils.toBoolOrNull:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : null},

      {'input' : true, 'expectedOutput' : true},
      {'input' : false, 'expectedOutput' : false},

      {'input' : 1, 'expectedOutput' : null},
      {'input' : 1.0, 'expectedOutput' : null},
      {'input' : 1.5, 'expectedOutput' : null},
      {'input' : 'A', 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = toBoolOrNull(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ObjectTypeUtils.toStringOrNull:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'test', 'expectedOutput' : 'test'},
      {'input' : 1, 'expectedOutput' : null},
      {'input' : 1.0, 'expectedOutput' : null},

      {'input' : true, 'expectedOutput' : null},
      {'input' : false, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = toStringOrNull(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ObjectTypeUtils.toStringListOrNull:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : <Object?>[], 'expectedOutput' : <String>[]},
      {'input' : <Object?>[null], 'expectedOutput' : <String>['']},

      {'input' : <Object?>['test', 'test1'], 'expectedOutput' : ['test', 'test1']},
      {'input' : <Object?>['test', null], 'expectedOutput' : ['test', '']},

      {'input' : <Object?>['test', 1], 'expectedOutput' : ['test', '']},
      {'input' : <Object?>[true, false], 'expectedOutput' : ['', '']},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = toStringListOrNull(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ObjectTypeUtils.toStringListWithNullableContentOrNull:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : <Object?>[], 'expectedOutput' : <String?>[]},
      {'input' : <Object?>[null], 'expectedOutput' : <String?>[null]},

      {'input' : <Object?>['test', 'test1'], 'expectedOutput' : ['test', 'test1']},
      {'input' : <Object?>['test', null], 'expectedOutput' : ['test', null]},

      {'input' : <Object?>['test', 1], 'expectedOutput' : ['test', null]},
      {'input' : <Object?>[true, false], 'expectedOutput' : [null, null]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = toStringListWithNullableContentOrNull(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}