import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/resistor/_common/logic/resistor.dart';

void main() {
  group("Resistor.resistor:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'colors' : <ResistorBandColor>[], 'expectedOutput' : const ResistorValue(null, 0.0)},
      {'colors' : [ResistorBandColor.RED], 'expectedOutput' :  const ResistorValue(null, 0.0)},
      {'colors' : [ResistorBandColor.RED, ResistorBandColor.RED], 'expectedOutput' :  const ResistorValue(null, 0.0)},
      {'colors' : [ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED], 'expectedOutput' : const ResistorValue(null, 0.0)},

      {'colors' : [ResistorBandColor.YELLOW, ResistorBandColor.VIOLET, ResistorBandColor.RED], 'expectedOutput' : const ResistorValue(4700.0, 0.2)},
      {'colors' : [ResistorBandColor.YELLOW, ResistorBandColor.VIOLET, ResistorBandColor.RED, ResistorBandColor.BROWN], 'expectedOutput' : const ResistorValue(4700.0, 0.01)},
      {'colors' : [ResistorBandColor.GREEN, ResistorBandColor.BROWN, ResistorBandColor.BROWN, ResistorBandColor.ORANGE, ResistorBandColor.BLUE], 'expectedOutput' : const ResistorValue(511000.0, 0.0025)},
      {'colors' : [ResistorBandColor.GREEN, ResistorBandColor.BROWN, ResistorBandColor.BROWN, ResistorBandColor.ORANGE, ResistorBandColor.BLUE, ResistorBandColor.ORANGE], 'expectedOutput' : const ResistorValue(511000.0, 0.0025, temperatureCoefficient: 15)},

      {'colors' : [ResistorBandColor.SILVER, ResistorBandColor.VIOLET, ResistorBandColor.RED], 'expectedOutput' : const ResistorValue(700.0, 0.2)},
      {'colors' : [ResistorBandColor.SILVER, ResistorBandColor.BLACK, ResistorBandColor.RED, ResistorBandColor.WHITE, ResistorBandColor.WHITE], 'expectedOutput' : const ResistorValue(2000000000.0, null)},
      {'colors' : [ResistorBandColor.BLACK, ResistorBandColor.BLACK, ResistorBandColor.ORANGE, ResistorBandColor.ORANGE], 'expectedOutput' : const ResistorValue(0.0, null)},
      {'colors' : [ResistorBandColor.WHITE, ResistorBandColor.BLACK, ResistorBandColor.ORANGE, ResistorBandColor.ORANGE], 'expectedOutput' : const ResistorValue(90000.0, null)},
      {'colors' : [ResistorBandColor.BLUE, ResistorBandColor.BLACK, ResistorBandColor.PINK], 'expectedOutput' : const ResistorValue(0.060, 0.2)},
      {'colors' : [ResistorBandColor.GREEN, ResistorBandColor.BLUE, ResistorBandColor.BLACK, ResistorBandColor.BLACK, ResistorBandColor.BROWN], 'expectedOutput' : const ResistorValue(560, 0.01)},
    ];

    for (var elem in _inputsToExpected) {
      test('colors: ${elem['colors']}', () {
        var _actual = getResistorValue(elem['colors'] as List<ResistorBandColor>);

        expect(_actual.value, (elem['expectedOutput'] as ResistorValue).value);
        expect(_actual.tolerance, (elem['expectedOutput'] as ResistorValue).tolerance);
        expect(_actual.temperatureCoefficient, (elem['expectedOutput'] as ResistorValue).temperatureCoefficient);
      });
    }
  });

  group("Resistor.eia96:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'code' : null, 'expectedOutput' : 0.0},

      {'code' : 1, 'expectedOutput' : 100.0},
      {'code' : 42, 'expectedOutput' : 267.0},
      {'code' : 96, 'expectedOutput' : 976.0},

      {'code' : 1, 'multiplicator': null, 'expectedOutput' : 100.0},
      {'code' : 42, 'multiplicator': 'Y', 'expectedOutput' : 2.67},
      {'code' : 96, 'multiplicator': 'F', 'expectedOutput' : 97600000.0},
    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, multiplicator: ${elem['multiplicator']}', () {
        if (elem['multiplicator'] == null) {
          var _actual = eia96(elem['code'] as int?);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = eia96(elem['code'] as int?, multiplicator: elem['multiplicator'] as String);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });
}