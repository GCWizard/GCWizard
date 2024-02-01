import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/logic/heat_index.dart';

void main() {
  group("heat.calculate:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'temperature' : 56.0, 'humidity' : 30.0, 'expectedOutput' : '87.287'},
      {'temperature' : 0.0, 'humidity' : 0.0, 'expectedOutput' : '-8.785'},
    ];

    for (var elem in _inputsToExpected) {
      test('temperature: ${elem['temperature']}, humidity: ${elem['humidity']}', () {
        var _actual = calculateHeatIndex(elem['temperature'] as double, elem['humidity'] as double);
        expect(_actual.toStringAsFixed(3), elem['expectedOutput']);
      });
    }
  });
}
