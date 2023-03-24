// https://de.wikipedia.org/wiki/Hitzeindex
import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

var _heatParameterCelsius = {
  1: 8.784695 * (-1),
  2: 1.61139411,
  3: 2.338549,
  4: 0.14611605 * (-1),
  5: 1.2308094 * pow(10, -2) * (-1),
  6: 1.6424828 * pow(10, -2) * (-1),
  7: 2.211732 * pow(10, -3),
  8: 7.2546 * pow(10, -4),
  9: 3.582 * pow(10, -6) * (-1)
};

var _heatParameterFahrenheit = {
  1: 42.379 * (-1),
  2: 2.04901523,
  3: 10.1433127,
  4: 0.22475541 * (-1),
  5: 6.83783 * pow(10, -3) * (-1),
  6: 5.481717 * pow(10, -2) * (-1),
  7: 1.22874 * pow(10, -3),
  8: 8.5282 * pow(10, -4),
  9: 1.99 * pow(10, -6) * (-1),
};

double calculateHeatIndex(double temperature, double humidity, Temperature temperatureUnit) {
  Map<int, double> c;
  double heatIndex = 0;

  if (temperatureUnit == TEMPERATURE_CELSIUS) {
    c = _heatParameterCelsius;
  } else if (temperatureUnit == TEMPERATURE_FAHRENHEIT) {
    c = _heatParameterFahrenheit;
  } else {
    return double.nan;
  }

  heatIndex = c[1]! +
      c[2]! * temperature +
      c[3]! * humidity +
      c[4]! * temperature * humidity +
      c[5]! * temperature * temperature +
      c[6]! * humidity * humidity +
      c[7]! * temperature * temperature * humidity +
      c[8]! * temperature * humidity * humidity +
      c[9]! * temperature * temperature * humidity * humidity;

  return heatIndex;
}
