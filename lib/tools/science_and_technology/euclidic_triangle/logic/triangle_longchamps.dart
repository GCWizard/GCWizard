part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleLongchampsPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);

  final bary = _longchampsBarycentricFromAngles(t.angles.alpha, t.angles.beta, t.angles.gamma);

  return XYPoint.fromBarycentric(t, bary.a, bary.b, bary.c);
}

BarycentricPoint _longchampsBarycentricFromAngles(
    double a, // |BC|
    double b, // |CA|
    double c, // |AB|
) {
  a = degToRadian(a);
  b = degToRadian(b);
  c = degToRadian(c);

  final alpha = tan(b) + tan(c) - tan(a);
  final beta  = tan(c) + tan(a) - tan(b);
  final gamma = tan(a) + tan(b) - tan(c);

  return BarycentricPoint(a: alpha, b: beta, c: gamma);
 }