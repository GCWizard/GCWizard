// https://de.wikipedia.org/wiki/Polarkoordinaten

import 'dart:math';

import 'package:intl/intl.dart';

Map<String, String> CartesianToPolar(String currentA, String currentB) {
  if (currentA.isEmpty || currentB.isEmpty) return {'': ''};
  currentA = currentA.replaceAll(',', '.');
  currentB = currentB.replaceAll(',', '.');

  Map<String, String> result = <String, String>{};
  double a = 0.0;
  double b = 0.0;

  if (double.tryParse(currentA) != null) {
    a = double.parse(currentA);
  } else {
    return {'': ''};
  }
  if (double.tryParse(currentB) != null) {
    b = double.parse(currentB);
  } else {
    return {'': ''};
  }

  double r = sqrt(a * a + b * b);
  double phi = 0.0;
  if (a == 0 && b == 0) {
    phi = 0.0;
  } else if (a > 0 && b >= 0) {
    phi = atan(b / a);
  } else if (a > 0 && b < 0) {
    phi = atan(b / a) + 2 * pi;
  } else if (a < 0) {
    phi = atan(b / a) + pi;
  } else if (a == 0 && b > 0) {
    phi = pi / 2;
  } else {
    phi = 3 * pi / 2;
  }

  phi = phi * 180 / pi;

  result['complex_numbers_hint_radius'] = NumberFormat('0.0' + '#' * 7).format(r);
  result['complex_numbers_hint_angle'] = NumberFormat('0.0' + '#' * 7).format(phi);
  return result;
}

Map<String, String> PolarToCartesian(String currentRadius, String currentAngle) {
  if (currentRadius.isEmpty || currentAngle.isEmpty) return {'': ''};
  currentRadius = currentRadius.replaceAll(',', '.');
  currentAngle = currentAngle.replaceAll(',', '.');

  Map<String, String> result = <String, String>{};
  double a = 0.0;
  double r = 0.0;

  if (double.tryParse(currentAngle) != null) {
    a = double.parse(currentAngle);
  } else {
    return {'': ''};
  }
  if (double.tryParse(currentRadius) != null) {
    r = double.parse(currentRadius);
  } else {
    return {'': ''};
  }

  result['complex_numbers_hint_a'] = NumberFormat('0.0' + '#' * 6).format(r * cos(a * pi / 180));
  result['complex_numbers_hint_b'] = NumberFormat('0.0' + '#' * 6).format(r * sin(a * pi / 180));
  return result;
}
