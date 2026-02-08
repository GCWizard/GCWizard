part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

double triangleCircumferenceXY(XYPoint A, XYPoint B, XYPoint C,){
  Sides sides = triangleSidesXY(A, B, C);
  return sides.a + sides.b + sides.c;
}


double triangleCircumferenceMap(LatLng A, LatLng B, LatLng C,){
  Sides sides = triangleSidesMap(A, B, C)!;
  return sides.a + sides.b + sides.c;
}
