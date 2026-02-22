part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleNagelPointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Nagel-Punkt

  Sides sides = triangleSidesXY(a, b, c);

  return XYPoint.fromBarycentric(
      Triangle(a, b, c),
    sides.b + sides.c - sides.a,
    sides.a + sides.c - sides.b,
    sides.a + sides.b - sides.c,
  );
}