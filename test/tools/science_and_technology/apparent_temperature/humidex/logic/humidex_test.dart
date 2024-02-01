import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/logic/humidex.dart';

void main() {
  group("humidex.calculate:", () {
    // https://www.physlink.com/Reference/Weather.cfm
    List<Map<String, dynamic>> _inputsToExpected = [
      {'temperature' : 0.0, 'humidity' : 0.0, 'expectedOutput' : '-5.556'},
      {'temperature' : 27.0, 'humidity' : 40.0, 'expectedOutput' : '29.351'},
      {'temperature' : 27.0, 'humidity' : 100.0,  'expectedOutput' : '41.211'},
      {'temperature' : 45.0, 'humidity' : 40.0,  'expectedOutput' : '60.668'},
      {'temperature' : 45.0, 'humidity' : 100.0, 'expectedOutput' : '92.503'},
      {'temperature' : 30.0, 'humidity' : 15.0, 'expectedOutput' : '27.972'},
      {'temperature' : 30.0, 'humidity' : 25.0, 'expectedOutput' : '30.324'},
    ];

    for (var elem in _inputsToExpected) {
      test('temperature: ${elem['temperature']}, humidity: ${elem['humidity']}', () {
        var _actual = calculateHumidex(elem['temperature'] as double, elem['humidity'] as double);
        expect(_actual.toStringAsFixed(3), elem['expectedOutput']);
      });
    }
  });
}
