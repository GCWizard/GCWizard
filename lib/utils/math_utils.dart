import 'dart:math';

double degreesToRadian(double degrees) {
  return degrees * pi / 180.0;
}

double radianToDegrees(double radian) {
  return radian / pi * 180.0;
}

num modulo(num value, num modulator) {
  if (modulator <= 0.0) throw Exception("modulator must be positive");

  while (value < 0.0) {
    value += modulator;
  }

  return value % modulator;
}

num modulo360(num value) {
  return modulo(value, 360.0);
}

num round(double number, {int precision = 0}) {
  if (precision <= 0) return number.round();

  var exp = pow(10, precision);
  return (number * exp).round() / exp;
}

int gcd(int a, int b) {
  int h;
  if (a == 0) return b.abs();
  if (b == 0) return a.abs();

  do {
    h = a % b;
    a = b;
    b = h;
  } while (b != 0);

  return a.abs();
}

int lcm(int a, int b) {
  if (gcd(a, b) == 00) return 0;

  int result = (a * b).abs() ~/ gcd(a, b);

  if ((a < 0) || (b < 0)) {
    return -result;
  }
  return result;
}