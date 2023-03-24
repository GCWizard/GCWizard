import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/beaufort/logic/beaufort.dart';

void main() {
  group("Beaufort.meterPerSecondToBeaufort:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'velocity' : -1.0, 'expectedOutput' : null},
      {'velocity' : 60.1, 'expectedOutput' : 17},

      {'velocity' : 0.0, 'expectedOutput' : 0},
      {'velocity' : 0.24, 'expectedOutput' : 0},
      {'velocity' : 0.25, 'expectedOutput' : 1},
      {'velocity' : 1.54, 'expectedOutput' : 1},
      {'velocity' : 1.55, 'expectedOutput' : 2},
      {'velocity' : 3.34, 'expectedOutput' : 2},
      {'velocity' : 3.35, 'expectedOutput' : 3},
      {'velocity' : 32.64, 'expectedOutput' : 11},
      {'velocity' : 32.65, 'expectedOutput' : 12},
      {'velocity' : 36.94, 'expectedOutput' : 12},
      {'velocity' : 36.95, 'expectedOutput' : 13},
      {'velocity' : 56.04, 'expectedOutput' : 16},
      {'velocity' : 56.05, 'expectedOutput' : 17},
    ];

    for (var elem in _inputsToExpected) {
      test('velocity: ${elem['velocity']}', () {
        var _actual = meterPerSecondToBeaufort(elem['velocity'] as double);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Beaufort.beaufortToMeterPerSecond:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'beaufort' : -1, 'expectedOutput' : null},
      {'beaufort' : 20, 'expectedOutput' : [56.1, double.infinity]},

      {'beaufort' : 0, 'expectedOutput' : [0.0, 0.2]},
      {'beaufort' : 1, 'expectedOutput' : [0.3, 1.5]},
      {'beaufort' : 2, 'expectedOutput' : [1.6, 3.3]},
      {'beaufort' : 11, 'expectedOutput' : [28.5, 32.6]},
      {'beaufort' : 12, 'expectedOutput' : [32.7, 36.9]},
      {'beaufort' : 13, 'expectedOutput' : [37.0, 41.4]},
      {'beaufort' : 16, 'expectedOutput' : [51.1, 56.0]},
      {'beaufort' : 17, 'expectedOutput' : [56.1, double.infinity]},
    ];

    for (var elem in _inputsToExpected) {
      test('beaufort: ${elem['beaufort']}', () {
        var _actual = beaufortToMeterPerSecond(elem['beaufort'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}