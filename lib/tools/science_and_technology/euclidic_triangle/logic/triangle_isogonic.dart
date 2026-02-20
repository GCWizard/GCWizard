part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleIsogonicPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  return XYPoint.fromBarycentric(t, 1 / (t.sides.a * t.sides.a),
      1 / (t.sides.b * t.sides.b), 1 / (t.sides.c * t.sides.c));
}
