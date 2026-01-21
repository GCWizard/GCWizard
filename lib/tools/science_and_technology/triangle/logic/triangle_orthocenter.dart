part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint triangleOrthocenterXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/H%C3%B6henschnittpunkt
  return intersectVectors(
    XYLine(P1: A, P2: _vectorNorm(_vectorAB(B, C))),
    XYLine(P1: B, P2: _vectorNorm(_vectorAB(A, C))),
  );
}


/// Orthocenter im ebenen Dreieck ABC in XY
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
  if (det.abs() < 1e-12) {
    throw Exception("Dreieck ist entartet – kein eindeutiger Höhenschnittpunkt.");
  }

  final x = (b1 * c2 - b2 * c1) / det;
  final y = (c1 * a2 - c2 * a1) / det;

  return XYPoint(x: x, y: y);
}

/// Sphärisch genäherter Orthocenter eines Dreiecks aus LatLng
LatLng triangleOrthocenterMap(LatLng A, LatLng B, LatLng C) {
  // Referenz: Schwerpunkt der drei Punkte
  final origin = LatLng(
    (A.latitude + B.latitude + C.latitude) / 3.0,
    (A.longitude + B.longitude + C.longitude) / 3.0,
  );

  final aXY = _toXY(A, origin);
  final bXY = _toXY(B, origin);
  final cXY = _toXY(C, origin);

  final hXY = _orthocenterXY(aXY, bXY, cXY);
  return _toLatLng(hXY, origin);
}
