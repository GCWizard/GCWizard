part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleFermatTorricelliPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  return XYPoint.fromBarycentric(t, t.sides.a * t.sides.a,
      t.sides.b * t.sides.b, t.sides.c * t.sides.c);
}
