part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

List<XYPoint> triangleAltitudesBasePointsXY(XYPoint a, XYPoint b, XYPoint c,){
  List<XYPoint> result = [];
  XYPoint? h = triangleOrthocenterXY(a, b, c);

  result.add(intersectVectors(
      XYLine(P1: b, P2: _vectorDiv(_vectorAB(b, c), _vectorLength(_vectorAB(b, c)))),
      XYLine(P1: a, P2: _vectorDiv(_vectorAB(a, h), _vectorLength(_vectorAB(a, h))))));
  result.add(intersectVectors(
      XYLine(P1: a, P2: _vectorDiv(_vectorAB(a, c), _vectorLength(_vectorAB(a, c)))),
      XYLine(P1: b, P2: _vectorDiv(_vectorAB(b, h), _vectorLength(_vectorAB(b, h))))));
  result.add(intersectVectors(
      XYLine(P1: a, P2: _vectorDiv(_vectorAB(a, b), _vectorLength(_vectorAB(a, b)))),
      XYLine(P1: c, P2: _vectorDiv(_vectorAB(c, h), _vectorLength(_vectorAB(c, h))))));

  return result;

  // alternative
  // List<XYPoint> result2 = [];
  // result2.add(foot(a, b, c));
  // result2.add(foot(b, a, c));
  // result2.add(foot(c, a, b));
  // return result;
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

