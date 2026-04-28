part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

TriangleSides triangleAngleBiSectorsXY(XYPoint a, XYPoint b, XYPoint c) {
  TriangleInteriorAngles angles = triangleAnglesXY(a, b, c);
  TriangleSides sides = triangleSidesXY(a, b, c);

  return TriangleSides(
    a: 2 * sides.b * sides.c * cos(angles.alpha * pi / 180 / 2 ) / (sides.b + sides.c),
    b: 2 * sides.a * sides.c * cos(angles.beta * pi / 180 / 2 ) / (sides.a + sides.c),
    c: 2 * sides.a * sides.b * cos(angles.gamma * pi / 180 / 2) / (sides.b + sides.a),
  );
}