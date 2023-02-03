// https://myscope.net/hitzeindex-gefuehle-temperatur/

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

double calculateSummerSimmerIndex(double temperature, double humidity, Temperature temperatureUnit) {
  double summerSimmerIndex = 0;

  if (temperatureUnit == TEMPERATURE_CELSIUS) {
    temperature = temperature * 1.8 + 32;
    summerSimmerIndex = ((1.98 * (temperature - (0.55 - 0.0055 * humidity) * (temperature - 58)) - 56.83) - 32) * 5 / 9;
  } else {
    summerSimmerIndex = 1.98 * (temperature - (0.55 - 0.0055 * humidity) * (temperature - 58)) - 56.83;
  }

  return summerSimmerIndex;
}
