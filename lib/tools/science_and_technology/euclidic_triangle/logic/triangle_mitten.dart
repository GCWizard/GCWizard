part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleMittenPointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Mittenpunkt
  // https://mathworld.wolfram.com/Mittenpunkt.html

  final sides = Triangle(a, b, c).sides;

  return XYPoint.fromBarycentric(
    Triangle(a, b, c),
    sides.a * (sides.b + sides.c - sides.a),
    sides.b * (sides.a + sides.c - sides.b),
    sides.c * (sides.a + sides.b - sides.c),
  );
}