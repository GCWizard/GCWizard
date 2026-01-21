part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYCircle triangleInCircleXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  XYPoint S = intersectVectors(
      XYLine(P1: A, P2: _vectorAdd(_vectorDiv(_vectorAB(A, B), _vectorLength(_vectorAB(A, B))), _vectorDiv(_vectorAB(A, C), _vectorLength(_vectorAB(A, C))))),
      XYLine(P1: B, P2: _vectorAdd(_vectorDiv(_vectorAB(B, A), _vectorLength(_vectorAB(B, A))), _vectorDiv(_vectorAB(B, C), _vectorLength(_vectorAB(B, C)))))
  );

  Sides sides = triangleSidesXY(A, B, C);
  double s = (sides.a + sides.b + sides.c) / 2;

  return XYCircle(
    x: S.x,
    y: S.y,
    // ri = sqrt((s - a)·(s - b)·(s - c)/s) mit s = u/2
    r: sqrt((s - sides.a) * (s -sides.b) * (s - sides.c) / s),
  );
}


/// Winkel (Seitenlänge) zwischen zwei Einheitsvektoren in Radiant
double _sideAngle(Vec3 u, Vec3 v) {
  final d = u.dot(v).clamp(-1.0, 1.0);
  return acos(d);
}


/// Sphärischer Inkreismittelpunkt eines Dreiecks ABC
XYCircle triangleInCircleMap(LatLng A, LatLng B, LatLng C) {
  const R = 6371000.0;

  final aVec = latLngToVec3(A);
  final bVec = latLngToVec3(B);
  final cVec = latLngToVec3(C);

  // Seitenlängen (Winkel) gegenüber den Eckpunkten
  final a = _sideAngle(bVec, cVec);
  final b = _sideAngle(aVec, cVec);
  final c = _sideAngle(aVec, bVec);

  // Incenter als gewichtete Summe der Eckvektoren
  final incenterVec = (aVec * a + bVec * b + cVec * c).normalized();
  final center = vec3ToLatLng(incenterVec);

  // Normale einer Seite, z.B. BC
  final n = bVec.cross(cVec).normalized();

  // Winkelabstand Incenter → Seite
  final r = asin((incenterVec.dot(n)).abs()); // in Radiant

  final radius = R * r; // Meter

  return XYCircle(
      x: vec3ToLatLng(incenterVec).latitude,
      y: vec3ToLatLng(incenterVec).longitude,
      r: radius,
  );
}