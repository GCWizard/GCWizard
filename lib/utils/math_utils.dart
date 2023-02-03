import 'dart:math';

/// Hyperbolic Sine.
double sinh(double angle) {
  return (exp(angle) - exp(-angle)) / 2;
}

double degreesToRadian(double degrees) {
  return degrees * pi / 180.0;
}

double radianToDegrees(double radian) {
  return radian / pi * 180.0;
}

num modulo(num value, num modulator) {
  if (modulator <= 0.0) throw Exception("modulator must be positive");

  while (value < 0.0) value += modulator;

  return value % modulator;
}

num modulo360(num value) {
  return modulo(value, 360.0);
}

dynamic round(double number, {int precision: 0}) {
  if (number == null) return null;

  if (precision == null || precision <= 0) return number.round();

  var exp = pow(10, precision);
  return (number * exp).round() / exp;
}