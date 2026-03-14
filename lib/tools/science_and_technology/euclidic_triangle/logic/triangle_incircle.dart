part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYCircle triangleInCircleXY(XYPoint a, XYPoint b, XYPoint c) {
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  Sides sides = triangleSidesXY(a, b, c);
  double s = (sides.a + sides.b + sides.c) / 2;
  final iS = XYPoint.fromBarycentric(
  Triangle(a, b, c),
  sides.a,
  sides.b,
  sides.c
  );
  return XYCircle(
    x: iS.x,
    y: iS.y,
    r: sqrt((s - sides.a) * (s -sides.b) * (s - sides.c) / s),
  );
}

List<XYPoint> triangleTouchPointsIncircleXY(XYPoint a, XYPoint b, XYPoint c){
  final I = triangleInCircleXY(a, b, c);

  // Ta auf BC
  final Ta = _footOfPerpendicular(XYPoint(x: I.x, y: I.y), b, c);

  // Tb auf CA
  final Tb = _footOfPerpendicular(XYPoint(x: I.x, y: I.y), c, a);

  // Tc auf AB
  final Tc = _footOfPerpendicular(XYPoint(x: I.x, y: I.y), a, b);

  return [Ta, Tb, Tc];
}


XYPoint _footOfPerpendicular(XYPoint p, XYPoint a, XYPoint b) {
  final ab = b - a;
  final ap = p - a;
  final denom = ab.dot(ab);
  if (denom == 0) return a; // degenerierte Seite
  final t = ap.dot(ab) / denom;
  final r = a + ab.scale(t);
  return XYPoint(x: r.x, y: r.y);
}