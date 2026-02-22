part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYCircle triangleInCircleXY(XYPoint a, XYPoint b, XYPoint c,){
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  Sides sides = triangleSidesXY(a, b, c);
  double s = (sides.a + sides.b + sides.c) / 2;
  final iS = XYPoint.fromBarycentric(
  Triangle(a, b, c),
  sides.a,
  sides.b,
  sides.c
  );
  return XYCircle(
    x: iS.x,
    y: iS.y,
    r: sqrt((s - sides.a) * (s -sides.b) * (s - sides.c) / s),
  );
}