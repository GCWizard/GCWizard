part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

double triangleCircumferenceXY(XYPoint A, XYPoint B, XYPoint C,){
  Sides sides = triangleSidesXY(A, B, C);
  return sides.a + sides.b + sides.c;
}
