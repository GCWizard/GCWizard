part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

bool triangleIsEquilateral(double a, double b, double c, {double eps = 1e-6}) {
  return (a - b).abs() < eps && (b - c).abs() < eps && (c - a).abs() < eps;
}

// ------------------------------------------------------------
// GLEICHSCHENKLIG
// ------------------------------------------------------------
bool triangleIsIsosceles(double a, double b, double c, {double eps = 1e-6}) {
  return (a - b).abs() < eps ||
      (b - c).abs() < eps ||
      (c - a).abs() < eps;
}

// ------------------------------------------------------------
// RECHTWINKLIG
// ------------------------------------------------------------
bool triangleIsRight(double a, double b, double c, {double eps = 1e-6}) {
  final a2 = a * a;
  final b2 = b * b;
  final c2 = c * c;

  return (a2 + b2 - c2).abs() < eps ||
      (b2 + c2 - a2).abs() < eps ||
      (c2 + a2 - b2).abs() < eps;
}

// ------------------------------------------------------------
// SPITZWINKLIG
// ------------------------------------------------------------
bool triangleIsAcute(double a, double b, double c, {double eps = 1e-6}) {
  final a2 = a * a;
  final b2 = b * b;
  final c2 = c * c;

  return a2 + b2 > c2 + eps &&
      b2 + c2 > a2 + eps &&
      c2 + a2 > b2 + eps;
}

// ------------------------------------------------------------
// STUMPFWINKLIG
// ------------------------------------------------------------
bool triangleIsObtuse(double a, double b, double c, {double eps = 1e-6}) {
  final a2 = a * a;
  final b2 = b * b;
  final c2 = c * c;

  return a2 + b2 < c2 - eps ||
      b2 + c2 < a2 - eps ||
      c2 + a2 < b2 - eps;
}

String triangleDescription(double a, double b, double c, {double eps = 1e-6}) {
  if (triangleIsEquilateral(a, b, c)) {
    return 'triangle_kind_equilateral';
  } else if (triangleIsIsosceles(a, b, c)) {
    return 'triangle_kind_isosceles';
  } else if (triangleIsAcute(a, b, c)) {
    return 'triangle_kind_acute';
  } else if (triangleIsObtuse(a, b, c)) {
    return 'triangle_kind_obtuse';
  } else if (triangleIsRight(a, b, c)) {
    return 'triangle_kind_right';
  } else{
    return 'triangle_kind_common';
  }
}