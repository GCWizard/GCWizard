part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint? triangleSchifflerPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  double sa = t.sides.a * t.sides.a;
  double sb = t.sides.b * t.sides.b;
  double sc = t.sides.c * t.sides.c;

  final bary = _schifflerBarycentricFromSides(sa, sb, sc);

  if (bary == null) {
    return null;
  }
  return XYPoint.fromBarycentric(t, bary.a, bary.b, bary.c);
}


BarycentricPoint? _schifflerBarycentricFromSides(
  double a, // |BC|
  double b, // |CA|
  double c, // |AB|
) {
  final denomA = b + c;
  final denomB = c + a;
  final denomC = a + b;

  if (denomA == 0 || denomB == 0 || denomC == 0) {
    return null;
  }

  final alpha = a * (b + c - a) / denomA;
  final beta = b * (c + a - b) / denomB;
  final gamma = c * (a + b - c) / denomC;

  return BarycentricPoint(a: alpha, b: beta, c: gamma);
}

