import 'dart:math';

double calculateDewPoint(
  double t, // temperature in °C
  double rh, // relative humidity in %
) {
  // https://energie-m.de/tools/taupunkt.html
  // https://myscope.net/taupunkttemperatur/
  // https://web.archive.org/web/20240920213646/https://myscope.net/taupunkttemperatur/
  double log10(double x) {
    return log(x) / log(10);
  }

  var mw = 18.016; // Molekulargewicht des Wasserdampfes (kg/kmol)
  var gk = 8214.3; // universelle Gaskonstante (J/(kmol*K))
  var t0 = 273.15; // Absolute Temperatur von 0 °C (Kelvin)
  var tk = t + t0; // Temperatur in Kelvin

  double a = 0;
  double b = 0;

  if (t >= 0) {
    a = 7.5;
    b = 237.3;
  } else if (t < 0) {
    a = 7.6;
    b = 240.7;
  }

  // Sättigungsdampfdruck (hPa)
  double sdd = 6.1078 * pow(10, (a * t) / (b + t));

  // Dampfdruck (hPa)
  double dd = sdd * (rh / 100);

  // Wasserdampfdichte bzw. absolute Feuchte (g/m3)
  // ignore: unused_local_variable
  double af = pow(10, 5) * mw / gk * dd / tk;

  // v-Parameter
  double v = log10(dd / 6.1078);

  return (b * v) / (a - v);
}


