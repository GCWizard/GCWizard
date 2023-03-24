import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/logic/windchill.dart';

void main() {
  group("Windchill.calculate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'temperature' : -10.0, 'windspeed' : 5.0, 'isMetric' : true, 'expectedOutput' : -12.933963619176676},
      {'temperature' : -10.0, 'windspeed' : 5.0, 'isMetric' : false, 'expectedOutput' : -22.255535954192787},
      {'temperature' : 5.0, 'windspeed' : 5.0, 'isMetric' : true, 'expectedOutput' : 4.082845877077206},
      {'temperature' : 5.0, 'windspeed' : 5.0, 'isMetric' : false, 'expectedOutput' : -4.637153710438598},
      {'temperature' : 5.0, 'windspeed' : 10.0, 'isMetric' : true, 'expectedOutput' : 2.658434152122606},
      {'temperature' : 41.0, 'windspeed' : 6.22, 'isMetric' : false, 'expectedOutput' : 36.80887834850828},
    ];

    for (var elem in _inputsToExpected) {
      test('temperature: ${elem['temperature']}, windspeed: ${elem['windspeed']}, isMetric: ${elem['isMetric']}', () {
        double? _actual;
        if (elem['isMetric'] as bool) {
          _actual = calcWindchillMetric(elem['temperature'] as double, elem['windspeed'] as double);
        } else {
          _actual = calcWindchillImperial(elem['temperature'] as double, elem['windspeed'] as double);
        }

        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
