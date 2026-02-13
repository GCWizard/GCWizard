part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Sides triangleMediansXY(XYPoint a, XYPoint b, XYPoint c,){
  Sides sides = triangleSidesXY(a, b, c);

  return Sides(
    a: sqrt(2  * (sides.b * sides.b + sides.c * sides.c) - sides.a * sides.a) / 2,
    b: sqrt(2  * (sides.a * sides.a + sides.c * sides.c) - sides.b * sides.b) / 2,
    c: sqrt(2  * (sides.b * sides.b + sides.a * sides.a) - sides.c * sides.c) / 2,
  );
}
