part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Sides triangleAltitudesXY(XYPoint A, XYPoint B, XYPoint C,){
  double area = triangleAreaXY(A, B, C);
  Sides sides = triangleSidesXY(A, B, C);

  return Sides(
    a: 2 * area / sides.a,
    b: 2 * area / sides.b,
    c: 2 * area / sides.c,
  );
}
