part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';


XYCircle triangleFeuerbachCircleXY(XYPoint a, XYPoint b, XYPoint c) {
  // https://de.wikipedia.org/wiki/Feuerbachkreis
  List<XYPoint> sidemidpoints = triangleSidesMidPointsXY(a, b, c);
  XYCircle F = triangleCircumscribedCircleXY(
    XYPoint(x: sidemidpoints[0].x, y: sidemidpoints[0].y),
    XYPoint(x: sidemidpoints[1].x, y: sidemidpoints[1].y),
    XYPoint(x: sidemidpoints[2].x, y: sidemidpoints[2].y),
  );
  return F;
}

List<XYPoint> triangleTouchpointsFeuerbachCircleXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);

  Vec2 Ia = Vec2(t.exCircles[0].x, t.exCircles[0].y);
  Vec2 Ib = Vec2(t.exCircles[1].x, t.exCircles[1].y);
  Vec2 Ic = Vec2(t.exCircles[2].x, t.exCircles[2].y);

  double ra = t.exCircles[0].r;
  double rb = t.exCircles[1].r;
  double rc = t.exCircles[2].r;

  Vec2 N = Vec2(t.feuerbachCircle.x, t.feuerbachCircle.y);
  double R9 = t.feuerbachCircle.r;

  final Fa = _feuerbachTouchPoint(Ia, ra, N, R9);
  final Fb = _feuerbachTouchPoint(Ib, rb, N, R9);
  final Fc = _feuerbachTouchPoint(Ic, rc, N, R9);

  return [XYPoint(x: Fa.x, y: Fa.y), XYPoint(x: Fb.x, y: Fb.y), XYPoint(x: Fc.x, y: Fc.y)];
}

Vec2 _feuerbachTouchPoint(Vec2 excenter, double exradius, Vec2 N, double R9) {
  final dir = N - excenter;
  final t = exradius / (exradius + R9);
  return excenter + dir.scale(t);
}

