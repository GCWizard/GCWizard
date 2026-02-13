part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

double triangleAreaXY(XYPoint a, XYPoint b, XYPoint c,){
  // https://de.wikipedia.org/wiki/Dreiecksfl%C3%A4che
  Sides sides = triangleSidesXY(a, b, c);
  double s = (sides.a + sides.b + sides.c) / 2;

  return sqrt(s * (s - sides.a) * (s - sides.b) * (s - sides.c));
}


