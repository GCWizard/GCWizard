import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/velocity.dart';

double? calcWindchillMetricMS(double tempInCelsius, double vInMS) {
  return calcWindchillMetric(tempInCelsius, VELOCITY_KMH.fromMS(vInMS));
}

double calcWindchillMetric(double tempInCelsius, double vInKMH) {
  return 13.12 + 0.6215 * tempInCelsius + (0.3965 * tempInCelsius - 11.37) * pow(vInKMH, 0.16);
}

double calcWindchillImperial(double tempInFahrenheit, double vInMPH) {
  return 35.74 +
      0.6215 * tempInFahrenheit -
      (35.75 * pow(vInMPH, 0.16)) +
      0.4275 * tempInFahrenheit * pow(vInMPH, 0.16);
}