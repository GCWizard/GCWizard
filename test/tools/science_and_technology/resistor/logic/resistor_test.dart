import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/resistor/_common/logic/resistor.dart';

void main() {
  group("Resistor.resistor:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'colors' : null, 'expectedOutput' : null},
      {'colors' : <ResistorBandColor>[], 'expectedOutput' : null},
      {'colors' : [ResistorBandColor.RED], 'expectedOutput' : null},
      {'colors' : [ResistorBandColor.RED, ResistorBandColor.RED], 'expectedOutput' : null},
      {'colors' : [ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED, ResistorBandColor.RED], 'expectedOutput' : null},

      {'colors' : [ResistorBandColor.YELLOW, ResistorBandColor.VIOLET, ResistorBandColor.RED], 'expectedOutput' : ResistorValue(4700.0, 0.2)},
      {'colors' : [ResistorBandColor.YELLOW, ResistorBandColor.VIOLET, ResistorBandColor.RED, ResistorBandColor.BROWN], 'expectedOutput' : ResistorValue(4700.0, 0.01)},
      {'colors' : [ResistorBandColor.GREEN, ResistorBandColor.BROWN, ResistorBandColor.BROWN, ResistorBandColor.ORANGE, ResistorBandColor.BLUE], 'expectedOutput' : ResistorValue(511000.0, 0.0025)},
      {'colors' : [ResistorBandColor.GREEN, ResistorBandColor.BROWN, ResistorBandColor.BROWN, ResistorBandColor.ORANGE, ResistorBandColor.BLUE, ResistorBandColor.ORANGE], 'expectedOutput' : ResistorValue(511000.0, 0.0025, temperatureCoefficient: 15)},

      {'colors' : [ResistorBandColor.SILVER, ResistorBandColor.VIOLET, ResistorBandColor.RED], 'expectedOutput' : ResistorValue(700.0, 0.2)},
      {'colors' : [ResistorBandColor.SILVER, ResistorBandColor.BLACK, ResistorBandColor.RED, ResistorBandColor.WHITE, ResistorBandColor.WHITE], 'expectedOutput' : ResistorValue(2000000000.0, null)},
      {'colors' : [ResistorBandColor.BLACK, ResistorBandColor.BLACK, ResistorBandColor.ORANGE, ResistorBandColor.ORANGE], 'expectedOutput' : ResistorValue(0.0, null)},
      {'colors' : [ResistorBandColor.WHITE, ResistorBandColor.BLACK, ResistorBandColor.ORANGE, ResistorBandColor.ORANGE], 'expectedOutput' : ResistorValue(90000.0, null)},
      {'colors' : [ResistorBandColor.BLUE, ResistorBandColor.BLACK, ResistorBandColor.PINK], 'expectedOutput' : ResistorValue(0.060, 0.2)},
      {'colors' : [ResistorBandColor.GREEN, ResistorBandColor.BLUE, ResistorBandColor.BLACK, ResistorBandColor.BLACK, ResistorBandColor.BROWN], 'expectedOutput' : ResistorValue(560, 0.01)},
    ];

    _inputsToExpected.forEach((elem) {
      test('colors: ${elem['colors']}', () {
        var _actual = getResistorValue(elem['colors']);

        if (elem['expectedOutput'] == null) {
          expect(_actual, null);
        } else {
          expect(_actual.value, elem['expectedOutput'].value);
          expect(_actual.tolerance, elem['expectedOutput'].tolerance);
          expect(_actual.temperatureCoefficient, elem['expectedOutput'].temperatureCoefficient);
        }
      });
    });
  });

  group("Resistor.eia96:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'code' : null, 'expectedOutput' : 0.0},

      {'code' : 1, 'expectedOutput' : 100.0},
      {'code' : 42, 'expectedOutput' : 267.0},
      {'code' : 96, 'expectedOutput' : 976.0},

      {'code' : 1, 'multiplicator': null, 'expectedOutput' : 100.0},
      {'code' : 42, 'multiplicator': 'Y', 'expectedOutput' : 2.67},
      {'code' : 96, 'multiplicator': 'F', 'expectedOutput' : 97600000.0},
    ];

    _inputsToExpected.forEach((elem) {
      test('code: ${elem['code']}, multiplicator: ${elem['multiplicator']}', () {
        var _actual = eia96(elem['code'], multiplicator: elem['multiplicator']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}