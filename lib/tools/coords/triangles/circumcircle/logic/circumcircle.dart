import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';

/// Ellipsoid
final double _a = defaultEllipsoid.a; // Äquatorradius
final double _f = defaultEllipsoid.f; // Abplattung
final double _b = defaultEllipsoid.b; // Polradius

/// ------------------------------------------------------------
///  Inverses geodesic according to Karney (simplified)
///  calculates  Distance s (m)
/// ------------------------------------------------------------
double _geodesicDistance(
    double lat1Deg, double lon1Deg,
    double lat2Deg, double lon2Deg) {

  final lat1 = degToRadian(lat1Deg);
  final lat2 = degToRadian(lat2Deg);
  final lon1 = degToRadian(lon1Deg);
  final lon2 = degToRadian(lon2Deg);

  final L = lon2 - lon1;
  final U1 = atan((1 - _f) * tan(lat1));
  final U2 = atan((1 - _f) * tan(lat2));

  final sinU1 = sin(U1), cosU1 = cos(U1);
  final sinU2 = sin(U2), cosU2 = cos(U2);

  double lambda = L;
  double lambdaPrev;
  const maxIter = 50;

  double sinSigma = 0, cosSigma = 0, sigma = 0;
  double sinAlpha = 0, cosSqAlpha = 0;
  double cos2SigmaM = 0;

  for (int i = 0; i < maxIter; i++) {
    lambdaPrev = lambda;

    final sinLambda = sin(lambda);
    final cosLambda = cos(lambda);

    sinSigma = sqrt(pow(cosU2 * sinLambda, 2) +
        pow(cosU1 * sinU2 - sinU1 * cosU2 * cosLambda, 2));

    if (sinSigma == 0) return 0; // identisch

    cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
    sigma = atan2(sinSigma, cosSigma);

    sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
    cosSqAlpha = 1 - sinAlpha * sinAlpha;

    cos2SigmaM = (cosSqAlpha == 0)
        ? 0
        : cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

    final C = _f / 16 * cosSqAlpha * (4 + _f * (4 - 3 * cosSqAlpha));

    lambda = L +
        (1 - C) * _f * sinAlpha *
            (sigma +
                C * sinSigma *
                    (cos2SigmaM +
                        C * cosSigma *
                            (-1 + 2 * pow(cos2SigmaM, 2))));

    if ((lambda - lambdaPrev).abs() < 1e-12) break;
  }

  final uSq = cosSqAlpha * (_a * _a - _b * _b) / (_b * _b);
  final A = 1 +
      uSq / 16384 *
          (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  final B = uSq / 1024 *
      (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

  final deltaSigma = B *
      sinSigma *
      (cos2SigmaM +
          B / 4 *
              (cosSigma * (-1 + 2 * pow(cos2SigmaM, 2)) -
                  B / 6 *
                      cos2SigmaM *
                      (-3 + 4 * sinSigma * sinSigma) *
                      (-3 + 4 * pow(cos2SigmaM, 2))));

  final s = _b * A * (sigma - deltaSigma);
  return s;
}

Circle _circumcenterOnEllipsoid({
  required double latA,
  required double lonA,
  required double latB,
  required double lonB,
  required double latC,
  required double lonC,
}) {
  // Startwert: sphärischer Schwerpunkt
  double lat = (latA + latB + latC) / 3.0;
  double lon = (lonA + lonB + lonC) / 3.0;

  double F1(double la, double lo) =>
      _geodesicDistance(la, lo, latA, lonA) -
          _geodesicDistance(la, lo, latB, lonB);

  double F2(double la, double lo) =>
      _geodesicDistance(la, lo, latA, lonA) -
          _geodesicDistance(la, lo, latC, lonC);

  const d = 1e-7; // Grad
  const tolF = 1e-6;
  const tolX = 1e-12;

  for (int iter = 0; iter < 20; iter++) {
    final f1 = F1(lat, lon);
    final f2 = F2(lat, lon);

    if (f1.abs() < tolF && f2.abs() < tolF) break;

    // numerische Ableitungen
    final df1dLat = (F1(lat + d, lon) - F1(lat - d, lon)) / (2 * d);
    final df1dLon = (F1(lat, lon + d) - F1(lat, lon - d)) / (2 * d);
    final df2dLat = (F2(lat + d, lon) - F2(lat - d, lon)) / (2 * d);
    final df2dLon = (F2(lat, lon + d) - F2(lat, lon - d)) / (2 * d);

    final det = df1dLat * df2dLon - df1dLon * df2dLat;
    if (det.abs() < 1e-18) break;

    final dLat = (-f1 * df2dLon + f2 * df1dLon) / det;
    final dLon = (-df1dLat * f2 + df2dLat * f1) / det;

    lat += dLat;
    lon += dLon;

    if (dLat.abs() < tolX && dLon.abs() < tolX) break;
  }

  final radius = _geodesicDistance(lat, lon, latA, lonA);

  // Längengrad normalisieren
  lon = ((lon + 180) % 360 + 360) % 360 - 180;

  return Circle(LatLng(lat, lon), radius);
}

Circle calculateEllipsoidTriangleCircumCircle(LatLng a, LatLng b, LatLng c) {
  return _circumcenterOnEllipsoid(
      latA: a.latitude, lonA: a.longitude,
      latB: b.latitude, lonB: b.longitude,
      latC: c.latitude, lonC: c.longitude);
}
