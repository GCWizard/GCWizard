import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/logic/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

void main() {
  group("heat.calculate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'temperature' : 56.0, 'humidity' : 30.0, 'temperatureUnit' : TEMPERATURE_CELSIUS, 'expectedOutput' : '87.287'},
      {'temperature' : 56.0, 'humidity' : 30.0, 'temperatureUnit' : TEMPERATURE_FAHRENHEIT, 'expectedOutput' : '81.263'},
      {'temperature' : 0.0, 'humidity' : 0.0, 'temperatureUnit' : TEMPERATURE_CELSIUS, 'expectedOutput' : '-8.785'},
      {'temperature' : 0.0, 'humidity' : 0.0, 'temperatureUnit' : TEMPERATURE_FAHRENHEIT, 'expectedOutput' : '-42.379'},
    ];

    for (var elem in _inputsToExpected) {
      test('temperature: ${elem['temperature']}, humidity: ${elem['humidity']}, temperatureUnit: ${(elem['temperatureUnit'] as Temperature).symbol}', () {
        var _actual = calculateHeatIndex(elem['temperature'] as double, elem['humidity'] as double, elem['temperatureUnit'] as Temperature);
        expect(_actual.toStringAsFixed(3), elem['expectedOutput']);
      });
    }
  });
}
