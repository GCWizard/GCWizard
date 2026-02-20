part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleIsoDynamic1PointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  return XYPoint.fromBarycentric(t, t.sides.b + t.sides.c - t.sides.a,
      t.sides.c + t.sides.a - t.sides.b, t.sides.a + t.sides.b - t.sides.c);
}

XYPoint triangleIsoDynamic2PointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  return XYPoint.fromBarycentric(
      t,
      1 / (t.sides.b + t.sides.c - t.sides.a),
      1 / (t.sides.c + t.sides.a - t.sides.b),
      1 / (t.sides.a + t.sides.b - t.sides.c));
}
