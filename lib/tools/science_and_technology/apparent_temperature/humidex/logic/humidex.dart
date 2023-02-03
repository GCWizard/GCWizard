// https://en.wikipedia.org/wiki/Humidex

import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

double calculateHumidex(double temperature, double humidity, Temperature temperatureUnit, bool isHumidity) {
  double humidex = 0;

  if (temperatureUnit == TEMPERATURE_FAHRENHEIT) {
    temperature = (temperature - 32) * 5 / 9;
  }

  if (isHumidity) {
    humidex = temperature + 5 / 9 * (6.122 * pow(10, 7.5 * temperature / (237.7 + temperature)) * humidity / 100 - 10);
  } else {
    humidex = temperature + 5 / 9 * (6.122 * pow(e, 5417.7530 * (1 / 273.16 - 1 / (273.15 + humidity))) - 10);
  }

  return humidex;
}
