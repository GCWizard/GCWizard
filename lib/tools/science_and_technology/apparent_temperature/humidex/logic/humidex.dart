// https://en.wikipedia.org/wiki/Humidex

import 'dart:math';

enum HUMIDEX_HEATSTRESS_CONDITION { LIGHT_BLUE, GREEN, YELLOW, ORANGE, RED }

final Map<HUMIDEX_HEATSTRESS_CONDITION, double> HUMIDEX_HEAT_STRESS = {
  // https://en.wikipedia.org/wiki/Humidex
  HUMIDEX_HEATSTRESS_CONDITION.GREEN: 16.0,
  HUMIDEX_HEATSTRESS_CONDITION.YELLOW: 30.0,
  HUMIDEX_HEATSTRESS_CONDITION.ORANGE: 40.0,
  HUMIDEX_HEATSTRESS_CONDITION.RED: 46.0,
};

double calculateHumidex(double temperature, double humidity) {
  // https://math.answers.com/Q/How_is_the_HUMIDEX_calculated
  double vapourpressure = (6.112 * pow(10, 7.5 * temperature / (237.7 + temperature)) * humidity / 100);
  double humidex = temperature +
      5 /
          9 *
          (vapourpressure -
              10); // where: e = vapour pressure(6.112 x 10^(7.5 x T/(237.7 + T)) * humidity/100) T= air temperature (degrees Celsius) H= humidity (%)
  return humidex;
  //return temperature + 0.5555 * (6.11 * pow(e, 5417.7530 * (1 / 273.16 - 1 / (273.15 + dewpointhumidity))) - 10);
}
