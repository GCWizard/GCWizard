part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleOrthocenterXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/H%C3%B6henschnittpunkt
  final sides = triangleSidesXY(a, b, c);

  return XYPoint.fromBarycentric(
    Triangle(a, b, c),
    1 / (sides.b * sides.b + sides.c * sides.c - sides.a * sides.a),
    1 / (sides.c * sides.c + sides.a * sides.a - sides.b * sides.b),
    1 / (sides.a * sides.a + sides.b * sides.b - sides.c * sides.c)
  );
}



/// Sphärisch genäherter Orthocenter eines Dreiecks aus LatLng
LatLng triangleOrthocenterMap(LatLng a, LatLng b, LatLng c) {

  XYPoint _orthocenterXY(XYPoint A, XYPoint B, XYPoint C) {
    final dxBC = C.x - B.x;
    final dyBC = C.y - B.y;
    final dxAC = C.x - A.x;
    final dyAC = C.y - A.y;

    final mBC = dyBC / dxBC;
    final mAC = dyAC / dxAC;

    final mHa = -1 / mBC;
    final mHb = -1 / mAC;

    final a1 = mHa;
    final b1 = -1.0;
    final c1 = A.y - mHa * A.x;

    final a2 = mHb;
    final b2 = -1.0;
    final c2 = B.y - mHb * B.x;

    final det = a1 * b2 - a2 * b1;

    final x = (b1 * c2 - b2 * c1) / det;
    final y = (c1 * a2 - c2 * a1) / det;

    return XYPoint(x: x, y: y);
  }

  // Reference: Centroid of a-b-c
  final origin = LatLng(
    (a.latitude + b.latitude + c.latitude) / 3.0,
    (a.longitude + b.longitude + c.longitude) / 3.0,
  );

  final aXY = _toXY(a, origin);
  final bXY = _toXY(b, origin);
  final cXY = _toXY(c, origin);

  final hXY = _orthocenterXY(aXY, bXY, cXY);
  return _toLatLng(hXY, origin);
}
