part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

class TriLinearPoint{
  final double x;
  final double y;
  final double z;

  TriLinearPoint({this.x = 0.0, this.y = 0.0, this.z = 0.0});
}

XYPoint triLinearToXYPoint(TriLinearPoint p, XYPoint a, XYPoint b, XYPoint c) {
  // https://mathworld.wolfram.com/TrilinearCoordinates.html

  Sides s = triangleSidesXY(a, b, c);

  XYPoint av = _vectorNormalize(_vectorAB(b, c));
  double a1 = av.x;
  double a2 = av.y;

  XYPoint cv = _vectorNormalize(_vectorAB(a, b));
  double c1= cv.x;
  double c2 = cv.y;

  double apx = p.x;
  double cpz = p.z;
  double k = 2 * triangleAreaXY(a, b, c) / (p.x * s.a + p.y * s.b + p.z * s.c);
  double lc = (k * apx - cpz * k * (a1 * c1 + a2 * c2) + a2 * (a.x - c.x) + a1 * (c.y - a.y)) / (a1 * c2 - a2 * c1);

  return XYPoint(
      x: a.x + lc * c1 - k * p.z * c2,
      y: a.y + lc * c2 + k * p.z * c1
  );
}

