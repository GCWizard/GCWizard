import 'dart:math';

double calculateDewpoint(double t, double rh) {
  // https://energie-m.de/tools/taupunkt.html
  // https://myscope.net/taupunkttemperatur/
  double log10(double x) {
    return log(x) / log(10);
  }

  double a = 7.5;
  double b = 237.3;
  double sdd = 6.1078 * pow(10, (a * t) / (b + t)); // Sättigungsdampfdruck (hPa)
  double dd = sdd * (rh / 100); // Dampfdruck (hPa)
  double v = log10(dd / 6.1078);
  return (b * v) / (a - v);
}
