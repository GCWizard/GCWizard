part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

double triangleAreaXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Dreiecksfl%C3%A4che
  Sides sides = triangleSidesXY(A, B, C);
  double s = (sides.a + sides.b + sides.c) / 2;

  return sqrt(s * (s - sides.a) * (s - sides.b) * (s - sides.c));
}


/// Fläche eines sphärischen Dreiecks in m²
double triangleAreaMap(LatLng A, LatLng B, LatLng C) {
  const R = 6371000.0; // Erdradius in Metern

  final a = latLngToVec3(A);
  final b = latLngToVec3(B);
  final c = latLngToVec3(C);

  final angleA = sphericalAngle(a, b, c);
  final angleB = sphericalAngle(b, a, c);
  final angleC = sphericalAngle(c, a, b);

  final sphericalExcess = angleA + angleB + angleC - pi; // in Radiant
  return sphericalExcess * R * R;
}
