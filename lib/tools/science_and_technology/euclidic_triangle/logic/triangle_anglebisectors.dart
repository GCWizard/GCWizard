part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Sides triangleAngleBiSectorsXY(XYPoint A, XYPoint B, XYPoint C,){
  Angles angles = triangleAnglesXY(A, B, C)!;
  Sides sides = triangleSidesXY(A, B, C);

  return Sides(
    a: 2 * sides.b * sides.c * cos(angles.alpha * pi / 180 / 2 ) / (sides.b + sides.c),
    b: 2 * sides.a * sides.c * cos(angles.beta * pi / 180 / 2 ) / (sides.a + sides.c),
    c: 2 * sides.a * sides.b * cos(angles.gamma * pi / 180 / 2) / (sides.b + sides.a),
  );
}

