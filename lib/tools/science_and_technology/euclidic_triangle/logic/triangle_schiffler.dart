part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleSchifflerPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  double sa = t.sides.a;
  double sb = t.sides.b;
  double sc = t.sides.c;

  final bary = _schifflerBarycentricFromSides(sa, sb, sc);

  return XYPoint.fromBarycentric(t, bary.a, bary.b, bary.c);
}


BarycentricPoint _schifflerBarycentricFromSides(
  double a, // |BC|
  double b, // |CA|
  double c, // |AB|
) {
  final s = 0.5 * (a + b + c);

  final alpha = a * (s - a) / (b + c);
  final beta  = b * (s - b) / (c + a);
  final gamma = c * (s - c) / (a + b);

  return BarycentricPoint(a: alpha, b: beta, c: gamma);
}


