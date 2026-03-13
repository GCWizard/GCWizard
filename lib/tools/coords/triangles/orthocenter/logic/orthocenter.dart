import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:latlong2/latlong.dart';

class GeodesicWgs84 {
  final double _a;
  final double _f;
  final double _b;

  GeodesicWgs84(this._a, this._f, this._b);

  double _degToRad(double d) => d * pi / 180.0;
  double _radToDeg(double r) => r * 180.0 / pi;

  double _normLon(double lonDeg) =>
      ((lonDeg + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;

  GeodesicInverseResult inverse(
      double lat1Deg, double lon1Deg,
      double lat2Deg, double lon2Deg) {

    final lat1 = _degToRad(lat1Deg);
    final lat2 = _degToRad(lat2Deg);
    final lon1 = _degToRad(lon1Deg);
    final lon2 = _degToRad(lon2Deg);

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

      if (sinSigma == 0) {
        return GeodesicInverseResult(0.0, double.nan, double.nan);
      }

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
    final A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    final B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));


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

    final sinLambda = sin(lambda);
    final cosLambda = cos(lambda);

    final alpha1 = atan2(
        cosU2 * sinLambda,
        cosU1 * sinU2 - sinU1 * cosU2 * cosLambda);

    final alpha2 = atan2(
        cosU1 * sinLambda,
        -sinU1 * cosU2 + cosU1 * sinU2 * cosLambda);

    final azi1Deg = _normLon(_radToDeg(alpha1));
    final azi2Deg = _normLon(_radToDeg(alpha2));

    return GeodesicInverseResult(s, azi1Deg, azi2Deg);
  }

  GeodesicDirectResult direct(
      double lat1Deg, double lon1Deg,
      double azi1Deg, double s12) {

    final alpha1 = _degToRad(azi1Deg);
    final sinAlpha1 = sin(alpha1);
    final cosAlpha1 = cos(alpha1);

    final lat1 = _degToRad(lat1Deg);
    final lon1 = _degToRad(lon1Deg);

    final U1 = atan((1 - _f) * tan(lat1));
    final sinU1 = sin(U1);
    final cosU1 = cos(U1);

    final sinAlpha = cosU1 * sinAlpha1;
    final cosSqAlpha = 1 - sinAlpha * sinAlpha;

    final uSq = cosSqAlpha * (_a * _a - _b * _b) / (_b * _b);

    final A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    final B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

    final sigma1 = atan2(tan(U1), cosAlpha1);

    double sigma = s12 / (_b * A);
    double sigmaPrev;

    double cos2SigmaM = 0;
    double sinSigma = 0;
    double cosSigma = 0;

    for (int i = 0; i < 50; i++) {
      sigmaPrev = sigma;

      cos2SigmaM = cos(2 * sigma1 + sigma);
      sinSigma = sin(sigma);
      cosSigma = cos(sigma);

      final deltaSigma = B *
          sinSigma *
          (cos2SigmaM +
              B / 4 *
                  (cosSigma * (-1 + 2 * pow(cos2SigmaM, 2)) -
                      B / 6 *
                          cos2SigmaM *
                          (-3 + 4 * sinSigma * sinSigma) *
                          (-3 + 4 * pow(cos2SigmaM, 2))));

      sigma = s12 / (_b * A) + deltaSigma;

      if ((sigma - sigmaPrev).abs() < 1e-12) break;
    }

    final tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
    final lat2 = atan2(
        sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
        (1 - _f) * sqrt(sinAlpha * sinAlpha + tmp * tmp));

    final lambda = atan2(
        sinSigma * sinAlpha1,
        cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);

    final C = _f / 16 * cosSqAlpha * (4 + _f * (4 - 3 * cosSqAlpha));

    final L = lambda -
        (1 - C) * _f * sinAlpha *
            (sigma +
                C * sinSigma *
                    (cos2SigmaM +
                        C * cosSigma *
                            (-1 + 2 * pow(cos2SigmaM, 2))));

    final lon2 = lon1 + L;

    final alpha2 = atan2(sinAlpha, -tmp);


    final lat2Deg = _radToDeg(lat2);
    final lon2Deg = _normLon(_radToDeg(lon2));
    final azi2Deg = _normLon(_radToDeg(alpha2));

    return GeodesicDirectResult(lat2Deg, lon2Deg, azi2Deg);
  }
}

class GeodesicInverseResult {
  final double s12;
  final double azi1;
  final double azi2;
  GeodesicInverseResult(this.s12, this.azi1, this.azi2);
}

class GeodesicDirectResult {
  final double lat2;
  final double lon2;
  final double azi2;
  GeodesicDirectResult(this.lat2, this.lon2, this.azi2);
}

class GnomonicWgs84 {
  final GeodesicWgs84 geod;
  final double R; // effektiver Radius für Winkel s/R

  GnomonicWgs84(this.geod, {double? radius})
      : R = radius ?? geod._a; // minimal: große Halbachse

  Point<double> forward(
      double lat0, double lon0,
      double lat, double lon) {

    final inv = geod.inverse(lat0, lon0, lat, lon);
    final s = inv.s12;
    final azi = inv.azi1 * pi / 180.0;

    final chi = s / R; // "Zentralwinkel"
    final t = tan(chi);

    final x = t * sin(azi);
    final y = t * cos(azi);

    return Point(x, y);
  }

  /// inverse gnomonisch: (x,y) -> (lat,lon) relativ zu (lat0,lon0)
  Point<double> reverse(
      double lat0, double lon0,
      double x, double y) {

    final rho = sqrt(x * x + y * y);
    if (rho == 0) {
      return Point(lat0, lon0);
    }

    final chi = atan(rho);
    final s = R * chi;
    final azi = atan2(x, y) * 180.0 / pi;

    final dir = geod.direct(lat0, lon0, azi, s);
    return Point(dir.lat2, dir.lon2);
  }
}

class OrthocenterResult {
  final double latDeg;
  final double lonDeg;
  OrthocenterResult(this.latDeg, this.lonDeg);
}

Point<double> _orthocenterPlanar(
    double xA, double yA,
    double xB, double yB,
    double xC, double yC) {

  final vxBC = xC - xB;
  final vyBC = yC - yB;
  final vxAC = xC - xA;
  final vyAC = yC - yA;

  final nBCx = -vyBC;
  final nBCy =  vxBC;
  final nACx = -vyAC;
  final nACy =  vxAC;

  final ax = xA, ay = yA;
  final bx = xB, by = yB;

  final m11 = nBCx;
  final m12 = -nACx;
  final m21 = nBCy;
  final m22 = -nACy;

  final rhs1 = bx - ax;
  final rhs2 = by - ay;

  final det = m11 * m22 - m12 * m21;
  if (det.abs() < 1e-15) {
    final xG = (xA + xB + xC) / 3.0;
    final yG = (yA + yB + yC) / 3.0;
    return Point(xG, yG);
  }

  final t = (rhs1 * m22 - rhs2 * m12) / det;
  final xH = ax + t * nBCx;
  final yH = ay + t * nBCy;

  return Point(xH, yH);
}

OrthocenterResult orthocenterOnEllipsoid({
  required GeodesicWgs84 geod,
  required double latA,
  required double lonA,
  required double latB,
  required double lonB,
  required double latC,
  required double lonC,
}) {
  final lat0 = (latA + latB + latC) / 3.0;
  final lon0 = (lonA + lonB + lonC) / 3.0;

  final gnom = GnomonicWgs84(geod);

  final A = gnom.forward(lat0, lon0, latA, lonA);
  final B = gnom.forward(lat0, lon0, latB, lonB);
  final C = gnom.forward(lat0, lon0, latC, lonC);

  final Hxy = _orthocenterPlanar(A.x, A.y, B.x, B.y, C.x, C.y);

  final Hll = gnom.reverse(lat0, lon0, Hxy.x, Hxy.y);

  final lonH = ((Hll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;

  return OrthocenterResult(Hll.x, lonH);
}

LatLng calculateEllipsoidTriangleOrthocenter(LatLng A, LatLng B, LatLng C) {
  var result = orthocenterOnEllipsoid(
      geod: GeodesicWgs84(defaultEllipsoid.a, defaultEllipsoid.f, defaultEllipsoid.b),
      latA: A.latitude, lonA: A.longitude,
      latB: B.latitude, lonB: B.longitude,
      latC: C.latitude, lonC: C.longitude);
  return LatLng(result.latDeg, result.lonDeg);
}