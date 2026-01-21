part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYCircle triangleCircumCircleXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Umkreis

  Sides sides = triangleSidesXY(A, B, C);
  Angles angles = triangleAnglesXY(A, B, C)!;

  XYPoint SB =  _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), sides.b / 2));
  XYPoint SA =  _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorAB(B, C)), sides.a / 2));

  XYPoint S = intersectVectors(
      XYLine(P1: SA, P2: _vectorNorm(_vectorAB(B, C))),
      XYLine(P1: SB, P2: _vectorNorm(_vectorAB(A, C)))
  );
  return XYCircle(
    x: S.x,
    y: S.y,
    r: sides.a / (2 * sin(angles.alpha * pi /180)),
  );
}

/// Großkreis-Distanz (in Metern)
double greatCircleDistance(LatLng a, LatLng b) {
  const R = 6371000.0;
  final lat1 = a.latitude * pi / 180;
  final lat2 = b.latitude * pi / 180;
  final dLat = lat2 - lat1;
  final dLng = (b.longitude - a.longitude) * pi / 180;

  final h = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);

  return 2 * R * asin(sqrt(h));
}

/// Sphärischer Umkreis eines Dreiecks
XYCircle triangleCircumCircleMap(LatLng A, LatLng B, LatLng C) {

  double angle(Vec3 a, Vec3 b) { final d = a.dot(b).clamp(-1.0, 1.0); return acos(d); }

  final a = latLngToVec3(A);
  final b = latLngToVec3(B);
  final c = latLngToVec3(C);

  // sphärische Winkel
  final alpha = sphericalAngle(a, b, c);
  final beta = sphericalAngle(b, a, c);
  final gamma = sphericalAngle(c, a, b);

  // baryzentrische Gewichte
  final wa = sin(2 * alpha);
  final wb = sin(2 * beta);
  final wc = sin(2 * gamma);

  // Mittelpunkt
  final centerVec = (a * wa + b * wb + c * wc).normalized();
  var center = vec3ToLatLng(centerVec);

  // Radius = Distanz zu einem Eckpunkt
  final radius = greatCircleDistance(center, A);

  return XYCircle(
    y: center.longitude,
    x: center.latitude,
    r: radius,
  );
}
