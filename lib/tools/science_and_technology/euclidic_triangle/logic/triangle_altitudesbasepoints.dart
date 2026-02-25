part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

List<XYPoint> triangleAltitudesBasePointsXY(XYPoint a, XYPoint b, XYPoint c){
  List<XYPoint> result = [];

  result.add(foot(a, b, c));
  result.add(foot(b, a, c));
  result.add(foot(c, a, b));

  return result;
}

XYPoint foot(XYPoint P, XYPoint U, XYPoint V) {
  final dx = V.x - U.x;
  final dy = V.y - U.y;
  final den = dx * dx + dy * dy;
  if (den == 0) { // U equals V
    return U;
  }
  final t = ((P.x - U.x) * dx + (P.y - U.y) * dy) / den;
  return XYPoint(x: U.x + t * dx, y: U.y + t * dy); }

