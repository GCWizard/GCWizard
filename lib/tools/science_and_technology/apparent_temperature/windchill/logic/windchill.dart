import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/velocity.dart';

double calcWindchillMetricMS(double tempInCelsius, double vInMS) {
  if (vInMS == null) return null;

  return calcWindchillMetric(tempInCelsius, VELOCITY_KMH.fromMS(vInMS));
}

double calcWindchillMetric(double tempInCelsius, double vInKMH) {
  if (tempInCelsius == null || vInKMH == null) return null;

  return 13.12 + 0.6215 * tempInCelsius + (0.3965 * tempInCelsius - 11.37) * pow(vInKMH, 0.16);
}

double calcWindchillImperial(double tempInFahrenheit, double vInMPH) {
  if (tempInFahrenheit == null || vInMPH == null) return null;

  return 35.74 +
      0.6215 * tempInFahrenheit -
      (35.75 * pow(vInMPH, 0.16)) +
      0.4275 * tempInFahrenheit * pow(vInMPH, 0.16);
}
