import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/science_and_technology/apparent_temperature/wet_bulb_temperature.dart';

void main() {
  group("wet_bulb_temperature.calculate.WBT:", () {
    // https://rechneronline.de/air/wet-bulb-temperature.php
    List<Map<String, dynamic>> _inputsToExpected = [
      {'temperature' : 20.0, 'humidity' : 0.0, 'expectedOutput' : '6.13'},
      {'temperature' : 38.0, 'humidity' : 0.0, 'expectedOutput' : '13.59'},
      {'temperature' : 42.0, 'humidity' : 0.0, 'expectedOutput' : '15.24'},
      {'temperature' : 46.0, 'humidity' : 0.0, 'expectedOutput' : '16.89'},
      {'temperature' : 50.0, 'humidity' : 0.0, 'expectedOutput' : '18.55'},

      {'temperature' : 20.0, 'humidity' : 10.0, 'expectedOutput' : '6.96'},
      {'temperature' : 38.0, 'humidity' : 10.0, 'expectedOutput' : '17.35'},
      {'temperature' : 42.0, 'humidity' : 10.0, 'expectedOutput' : '19.66'},
      {'temperature' : 46.0, 'humidity' : 10.0, 'expectedOutput' : '21.97'},
      {'temperature' : 50.0, 'humidity' : 10.0, 'expectedOutput' : '24.28'},

      {'temperature' : 20.0, 'humidity' : 50.0, 'expectedOutput' : '13.70'},
      {'temperature' : 38.0, 'humidity' : 50.0, 'expectedOutput' : '29.17'},
      {'temperature' : 42.0, 'humidity' : 50.0, 'expectedOutput' : '32.61'},
      {'temperature' : 46.0, 'humidity' : 50.0, 'expectedOutput' : '36.05'},
      {'temperature' : 50.0, 'humidity' : 50.0, 'expectedOutput' : '39.49'},
    ];

    _inputsToExpected.forEach((elem) {
      test('temperature: ${elem['temperature']}, humidity: ${elem['humidity']}, temperatureUnit: ${elem['temperatureUnit'].symbol}', () {
        var _actual = calculateWetBulbTemperature(elem['temperature'], elem['humidity'], );
        expect(_actual.toStringAsFixed(2), elem['expectedOutput']);
      });
    });
  });
}
