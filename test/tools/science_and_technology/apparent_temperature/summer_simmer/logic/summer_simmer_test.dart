import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/logic/summer_simmer.dart';


void main() {
  group("SummerSimmer.calculate:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'temperature' : 0.0, 'humidity' : 0.0, 'expectedOutput' : '1.580'},
      {'temperature' : 45.0, 'humidity' : 55.0, 'expectedOutput' : '59.976'},
      {'temperature' : 56.0, 'humidity' : 30.0, 'expectedOutput' : '65.052'},
      {'temperature' : 18.0, 'humidity' : 75.0, 'expectedOutput' : '20.522'},
    ];

    for (var elem in _inputsToExpected) {
      test('temperature: ${elem['temperature']}, humidity: ${elem['humidity']}', () {
        var _actual = calculateSummerSimmerIndex(elem['temperature'] as double, elem['humidity'] as double, );
        expect(_actual.toStringAsFixed(3), elem['expectedOutput']);
      });
    }
  });
}
