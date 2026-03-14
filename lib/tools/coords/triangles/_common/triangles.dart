import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

Angles calculateEllipsoidTriangleAngles(LatLng a, LatLng b, LatLng c) {
  var aAngle = (distanceBearing(a, c, defaultEllipsoid).bearingAToB -
          distanceBearing(a, b, defaultEllipsoid).bearingAToB)
      .abs();
  var bAngle = (distanceBearing(b, c, defaultEllipsoid).bearingAToB -
          distanceBearing(b, a, defaultEllipsoid).bearingAToB)
      .abs();
  var cAngle = (distanceBearing(c, a, defaultEllipsoid).bearingAToB -
          distanceBearing(c, b, defaultEllipsoid).bearingAToB)
      .abs();
  return Angles(
    alpha: aAngle > 180 ? 360 - aAngle : aAngle,
    beta: bAngle > 180 ? 360 - bAngle : bAngle,
    gamma: cAngle > 180 ? 360 - cAngle : cAngle,
  );
}

Sides calculateEllipsoidTriangleSides(LatLng a, LatLng b, LatLng c) {
  return Sides(
      a: distanceBearing(b, c, defaultEllipsoid).distance,
      b: distanceBearing(a, c, defaultEllipsoid).distance,
      c: distanceBearing(a, b, defaultEllipsoid).distance);
}

double calculateEllipsoidTriangleCircumference(LatLng a, LatLng b, LatLng c) {
  var sides = calculateEllipsoidTriangleSides(a, b, c);
  return sides.a + sides.b + sides.c;
}

// WGS‑84
final double _a = defaultEllipsoid.a;
final double _f = defaultEllipsoid.f;
final double _b = defaultEllipsoid.b;

double inverseWithArea(LatLng p1, LatLng p2) {
  /// Inverse geodesics + area S12 according to Karney - compact version
  final phi1 = degToRadian(p1.latitude);
  final phi2 = degToRadian(p2.latitude);
  final l = degToRadian(p2.longitude - p1.longitude);

  final u1 = atan((1 - _f) * tan(phi1));
  final u2 = atan((1 - _f) * tan(phi2));

  final sinU1 = sin(u1), cosU1 = cos(u1);
  final sinU2 = sin(u2), cosU2 = cos(u2);

  double lambda = l;
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
      return 0.0;
    }

    cosrho = sinU1 * sinU2 + cosU1 * cosU2 * coslambda;
    rho = atan2(sinrho, cosrho);

    sinalpha = cosU1 * cosU2 * sinlambda / sinrho;
    cos2alpha = 1 - sinalpha * sinalpha;

    cos2rhom = cosrho - 2 * sinU1 * sinU2 / cos2alpha;

    final c = _f / 16 * cos2alpha * (4 + _f * (4 - 3 * cos2alpha));

    lambda = l +
        (1 - c) *
            _f *
            sinalpha *
            (rho +
                c *
                    sinrho *
                    (cos2rhom + c * cosrho * (-1 + 2 * pow(cos2rhom, 2))));

    if ((lambda - lambdaPrev).abs() < 1e-12) break;
  }

  final uSq = cos2alpha * (_a * _a - _b * _b) / (_b * _b);

  final b = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

  final deltarho = b *
      sinrho *
      (cos2rhom +
          b /
              4 *
              (cosrho * (-1 + 2 * pow(cos2rhom, 2)) -
                  b /
                      6 *
                      cos2rhom *
                      (-3 + 4 * sinrho * sinrho) *
                      (-3 + 4 * pow(cos2rhom, 2))));

  // Karney: area S12
  final S12 = _f * sinalpha * (rho + deltarho);

  return S12;
}

double ellipsoidTriangleArea(LatLng a, LatLng b, LatLng c) {
  final ab = inverseWithArea(a, b);
  final bc = inverseWithArea(b, c);
  final ca = inverseWithArea(c, a);

  return (ab + bc + ca).abs() * (_a * _a); // Karney: Area = S * a²
}
