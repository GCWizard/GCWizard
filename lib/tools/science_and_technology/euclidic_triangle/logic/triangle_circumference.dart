part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

double triangleCircumferenceXY(XYPoint a, XYPoint b, XYPoint c) {
  TriangleSides sides = triangleSidesXY(a, b, c);
  return sides.a + sides.b + sides.c;
}

double triangleCircumferenceMap(LatLng a, LatLng b, LatLng c) {
  TriangleSides sides = triangleSidesMap(a, b, c)!;
  return sides.a + sides.b + sides.c;
}
