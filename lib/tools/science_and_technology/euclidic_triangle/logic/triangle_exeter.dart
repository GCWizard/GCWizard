part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleExeterPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  double sa = t.sides.a * t.sides.a;
  double sb = t.sides.b * t.sides.b;
  double sc = t.sides.c * t.sides.c;

  final bary = _exeterBarycentricFromSides(sa, sb, sc);

  return XYPoint.fromBarycentric(t, bary.a, bary.b, bary.c);
}

BarycentricPoint _exeterBarycentricFromSides(
  double a, // |BC|
  double b, // |CA|
  double c, // |AB|
) {
  final a2 = a * a, b2 = b * b, c2 = c * c;
  final a4 = a2 * a2, b4 = b2 * b2, c4 = c2 * c2;

  final alpha = a2 * (b4 + c4 - a4);
  final beta = b2 * (c4 + a4 - b4);
  final gamma = c2 * (a4 + b4 - c4);

  return BarycentricPoint(a: alpha, b: beta, c: gamma);
}
