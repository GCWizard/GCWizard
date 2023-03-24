// https://en.wikipedia.org/wiki/Wet-bulb_temperature
// https://de.wikipedia.org/wiki/K%C3%BChlgrenztemperatur
// https://uwz.at/de/a/feuchtkugeltemperatur-wie-viel-schwuele-halten-wir-aus#:~:text=Steigt%20die%20Feuchtkugeltemperatur%20auf%20%C3%BCber,den%20Menschen%20(siehe%20Studie).
// https://climate-preparedness.com/understanding-wet-bulb-temperature-and-why-it-is-so-dangerous/
// https://ksi.uconn.edu/prevention/wet-bulb-globe-temperature-monitoring/
// https://www.researchgate.net/profile/Thieres-Silva/publication/261706490_Estimating_Black_Globe_Temperature_Based_on_Meteorological_Data/links/00b7d535176fd08364000000/Estimating-Black-Globe-Temperature-Based-on-Meteorological-Data.pdf?origin=publication_detail
// https://www.weather.gov/media/tsa/pdf/WBGTpaper2.pdf
// https://www.omnicalculator.com/physics/wet-bulb
// https://calculator-online.net/wet-bulb-calculator/
// https://climatechip.org/excel-wbgt-calculator
// https://rechneronline.de/barometer/feuchttemperatur.php

import 'dart:math';

enum WBT_HEATSTRESS_CONDITION { BLACK, PURPLE, BLUE, LIGHT_BLUE, GREEN, ORANGE, RED, DARK_RED }

const Map<WBT_HEATSTRESS_CONDITION, double> WBT_HEAT_STRESS = {
  // https://sustainabilitymath.org/2020/06/01/what-is-our-wet-bulb-temperature-limit/
  // https://www.science.org/doi/10.1126/sciadv.aaw1838
  WBT_HEATSTRESS_CONDITION.PURPLE: 23.0,
  WBT_HEATSTRESS_CONDITION.BLUE: 25.0,
  WBT_HEATSTRESS_CONDITION.LIGHT_BLUE: 27.0,
  WBT_HEATSTRESS_CONDITION.GREEN: 29.0,
  WBT_HEATSTRESS_CONDITION.ORANGE: 31.0,
  WBT_HEATSTRESS_CONDITION.RED: 33.0,
  WBT_HEATSTRESS_CONDITION.DARK_RED: 35.0,
};

double calculateWetBulbTemperature(
  double temperature,
  double humidity,
) {
  // https://rechneronline.de/air/wet-bulb-temperature.php
  return temperature * atan(0.151977 * sqrt((humidity + 8.313659))) +
      atan(temperature + humidity) -
      atan(humidity - 1.676331) +
      0.00391838 * pow(humidity, 1.5) * atan(0.023101 * humidity) -
      4.686035;
}
