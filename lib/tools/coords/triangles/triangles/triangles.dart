import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';


Angles calculateEllipsoidTriangleAngles(LatLng A, LatLng B, LatLng C) {
  var a = (distanceBearing(A, C, defaultEllipsoid).bearingAToB -
          distanceBearing(A, B, defaultEllipsoid).bearingAToB)
      .abs();
  var b = (distanceBearing(B, C, defaultEllipsoid).bearingAToB -
          distanceBearing(B, A, defaultEllipsoid).bearingAToB)
      .abs();
  var c = (distanceBearing(C, A, defaultEllipsoid).bearingAToB -
          distanceBearing(C, B, defaultEllipsoid).bearingAToB)
      .abs();
  return Angles(
    alpha: a > 180 ? 360 - a : a,
    beta: b > 180 ? 360 - b : b,
    gamma: c > 180 ? 360 - c : c,
  );
}

Sides calculateEllipsoidTriangleSides(LatLng A, LatLng B, LatLng C) {
  return Sides(
      a: distanceBearing(B, C, defaultEllipsoid).distance,
      b: distanceBearing(A, C, defaultEllipsoid).distance,
      c: distanceBearing(A, B, defaultEllipsoid).distance);
}

double calculateEllipsoidTriangleCircumference(LatLng A, LatLng B, LatLng C) {
  var sides = calculateEllipsoidTriangleSides(A, B, C);
  return sides.a + sides.b + sides.c;
}


// WGS‑84
final double _a = defaultEllipsoid.a;
final double _f = defaultEllipsoid.f;
final double _b = defaultEllipsoid.b;

/// Inversgeodäsie + Flächenanteil S12 (Karney-kompakt)
Map<String, double> inverseWithArea(LatLng p1, LatLng p2) {
  final phi1 = degToRadian(p1.latitude);
  final phi2 = degToRadian(p2.latitude);
  final L = degToRadian(p2.longitude - p1.longitude);

  final U1 = atan((1 - _f) * tan(phi1));
  final U2 = atan((1 - _f) * tan(phi2));

  final sinU1 = sin(U1), cosU1 = cos(U1);
  final sinU2 = sin(U2), cosU2 = cos(U2);

  double lambda = L;
  double lambdaPrev;

  double sinrho = 0, cosrho = 0, rho = 0;
  double sinalpha = 0, cos2alpha = 0, cos2rhom = 0;

  for (int i = 0; i < 100; i++) {
  lambdaPrev = lambda;

  final sinlambda = sin(lambda);
  final coslambda = cos(lambda);

  sinrho = sqrt(pow(cosU2 * sinlambda, 2) +
  pow(cosU1 * sinU2 - sinU1 * cosU2 * coslambda, 2));

  if (sinrho == 0) {
  return {"S12": 0};
  }

  cosrho = sinU1 * sinU2 + cosU1 * cosU2 * coslambda;
  rho = atan2(sinrho, cosrho);

  sinalpha = cosU1 * cosU2 * sinlambda / sinrho;
  cos2alpha = 1 - sinalpha * sinalpha;

  cos2rhom = cosrho - 2 * sinU1 * sinU2 / cos2alpha;

  final C = _f / 16 * cos2alpha * (4 + _f * (4 - 3 * cos2alpha));

  lambda = L +
  (1 - C) *
  _f *
  sinalpha *
  (rho +
  C *
  sinrho *
  (cos2rhom +
  C * cosrho * (-1 + 2 * pow(cos2rhom, 2))));

  if ((lambda - lambdaPrev).abs() < 1e-12) break;
  }

  final uSq = cos2alpha * (_a * _a - _b * _b) / (_b * _b);
  final A = 1 +
  uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  final B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

  final deltarho = B *
  sinrho *
  (cos2rhom +
  B / 4 *
  (cosrho * (-1 + 2 * pow(cos2rhom, 2)) -
  B / 6 *
  cos2rhom *
  (-3 + 4 * sinrho * sinrho) *
  (-3 + 4 * pow(cos2rhom, 2))));

  // Karney: Flächenanteil S12
  final S12 = _f * sinalpha * (rho + deltarho);

  return {"S12": S12};
}

/// Ellipsoidische Dreiecksfläche (exakt)
double ellipsoidTriangleArea(LatLng A, LatLng B, LatLng C) {
  final AB = inverseWithArea(A, B)["S12"]!;
  final BC = inverseWithArea(B, C)["S12"]!;
  final CA = inverseWithArea(C, A)["S12"]!;

  return (AB + BC + CA).abs() * (_a * _a); // Karney: Fläche = S * a²
}

