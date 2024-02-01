import "package:flutter_test/flutter_test.dart";
import "package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/logic/windchill.dart";

void main() {
  group("Windchill.calculate:", () {
    // https://www.weather.gov/epz/wxcalc_windchill
    List<Map<String, Object?>> _inputsToExpected = [
      {'temperature' : -10.0, 'windspeed' : 5.0, 'expectedOutput' : -17.44659325560164},
      {'temperature' : -15.0, 'windspeed' : 5.0, 'expectedOutput' : -23.702253257507756},
      {'temperature' : -15.0, 'windspeed' : 10.0, 'expectedOutput' : -26.927620614773048},
    ];

    for (var elem in _inputsToExpected) {
      test('temperature: ${elem['temperature']}, windspeed: ${elem['windspeed']}', () {
        double? _actual;

          _actual = calcWindchill(elem['temperature'] as double, elem['windspeed'] as double);

        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
