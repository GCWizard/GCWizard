import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/velocity.dart';

enum WINDCHILL_HEATSTRESS_CONDITION {
  DARK_BLUE,
  BLUE,
  LIGHT_BLUE,
  WHITE,
}

final Map<WINDCHILL_HEATSTRESS_CONDITION, double> WINDCHILL_HEAT_STRESS = {
  WINDCHILL_HEATSTRESS_CONDITION.DARK_BLUE: -49.0,
  WINDCHILL_HEATSTRESS_CONDITION.BLUE: -27.0,
  WINDCHILL_HEATSTRESS_CONDITION.LIGHT_BLUE: -18.0,
  WINDCHILL_HEATSTRESS_CONDITION.WHITE: 9.0,
};

double calcWindchill(double tempInCelsius, double vInMS) {
  // https://www.weather.gov/epz/wxcalc_windchill
  return 13.12 + 0.6215 * tempInCelsius + (0.3965 * tempInCelsius - 11.37) * pow(VELOCITY_KMH.fromMS(vInMS), 0.16);
}
