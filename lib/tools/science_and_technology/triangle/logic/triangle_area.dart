part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

double triangleAreaXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Dreiecksfl%C3%A4che
  Sides sides = triangleSidesXY(A, B, C);
  double s = (sides.a + sides.b + sides.c) / 2;

  return sqrt(s * (s - sides.a) * (s - sides.b) * (s - sides.c));
}