import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/rhumb_line/logic/rhumb_line.dart';
import 'package:latlong2/latlong.dart';



// ellipsoid Parameter defaultEllipsoid
final double a = defaultEllipsoid.a;  // große Halbachse
final double f = defaultEllipsoid.f;  // Abplattung
final double b = defaultEllipsoid.b;  // kleine Halbachse
// WGS‑84 Parameter
// const double a = 6378137.0;
// const double f = 1 / 298.257223563;
// const double b = a * (1 - f);


// ------------------------------------------------------------
// Hilfsfunktionen
// ------------------------------------------------------------

/// Karney: Inversgeodäsie + Flächenanteil S12
/// Rückgabe: { "azi1":..., "azi2":..., "s12":..., "S12":... }
Map<String, double> inverseGeodesic(LatLng p1, LatLng p2) {
  final lat1 = degToRadian(p1.latitude);
  final lat2 = degToRadian(p2.latitude);
  final lon1 = degToRadian(p1.longitude);
  final lon2 = degToRadian(p2.longitude);

  final L = lon2 - lon1;
  final U1 = atan((1 - f) * tan(lat1));
  final U2 = atan((1 - f) * tan(lat2));

  final sinU1 = sin(U1), cosU1 = cos(U1);
  final sinU2 = sin(U2), cosU2 = cos(U2);

  double lambda = L;
  double lambdaPrev = 0.0;
  double sinSigma = 0.0;
  double cosSigma = 0.0;
  double sigma  = 0.0;
  double sinAlpha = 0.0;
  double cosSqAlpha = 0.0;
  double cos2SigmaM = 0.0;
  double C = 0.0;

  // Iteration (Vincenty)
  for (int i = 0; i < 100; i++) {
    lambdaPrev = lambda;

    final sinLambda = sin(lambda);
    final cosLambda = cos(lambda);

    sinSigma = sqrt(pow(cosU2 * sinLambda, 2) +
        pow(cosU1 * sinU2 - sinU1 * cosU2 * cosLambda, 2));

    if (sinSigma == 0) {
      return {"azi1": 0, "azi2": 0, "s12": 0, "S12": 0};
    }

    cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
    sigma = atan2(sinSigma, cosSigma);

    sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
    cosSqAlpha = 1 - sinAlpha * sinAlpha;

    cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

    C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));

    lambda = L +
        (1 - C) *
            f *
            sinAlpha *
            (sigma +
                C *
                    sinSigma *
                    (cos2SigmaM +
                        C * cosSigma * (-1 + 2 * pow(cos2SigmaM, 2))));

    if ((lambda - lambdaPrev).abs() < 1e-12) break;
  }

  final uSq = cosSqAlpha * (a * a - b * b) / (b * b);
  final A = 1 +
      uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  final B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

  final deltaSigma = B *
      sinSigma *
      (cos2SigmaM +
          B /
              4 *
              (cosSigma * (-1 + 2 * pow(cos2SigmaM, 2)) -
                  B /
                      6 *
                      cos2SigmaM *
                      (-3 + 4 * sinSigma * sinSigma) *
                      (-3 + 4 * pow(cos2SigmaM, 2))));

  final s12 = b * A * (sigma - deltaSigma);

  // Flächenanteil S12 (Karney)
  final S12 = f * sinAlpha * (sigma + deltaSigma);

  // Azimute
  final azi1 = atan2(cosU2 * sin(lambda),
      cosU1 * sinU2 - sinU1 * cosU2 * cos(lambda));

  final azi2 = atan2(cosU1 * sin(lambda),
      -sinU1 * cosU2 + cosU1 * sinU2 * cos(lambda));

  return {
    "azi1": azi1,
    "azi2": azi2,
    "s12": s12,
    "S12": S12,
  };
}

// ------------------------------------------------------------
// Dreiecksfläche auf dem Ellipsoid
// ------------------------------------------------------------
double sphericalTriangleAreaApprox(LatLng A, LatLng B, LatLng C) {
  const R = 6371008.8; // mittlerer Erdradius in m

  final angles = ellipsoidTriangleAngles(A, B, C); // aus der letzten Antwort
  final alpha = angles["alpha"]!;
  final beta  = angles["beta"]!;
  final gamma = angles["gamma"]!;

  final E = alpha + beta + gamma - pi; // sphärischer Exzess
  return R * R * E; // m²
}

double ellipsoidTriangleArea(LatLng A, LatLng B, LatLng C) {
  final AB = inverseGeodesic(A, B);
  final BC = inverseGeodesic(B, C);
  final CA = inverseGeodesic(C, A);

  final S = AB["S12"]! + BC["S12"]! + CA["S12"]!;

  return S.abs(); // Fläche in m²
}


double _angleDiff(double a1, double a2) {
  var d = a1 - a2;
  while (d <= -pi) {
    d += 2 * pi;
  }
  while (d > pi) {
    d -= 2 * pi;
  }
  return d.abs();
}

/// Winkel eines Dreiecks auf dem Ellipsoid (Radiant)
Map<String, double> ellipsoidTriangleAngles(LatLng A, LatLng B, LatLng C) {
  final AB = inverseGeodesic(A, B, );
  final AC = inverseGeodesic(A, C, );
  final BA = inverseGeodesic(B, A, );
  final BC = inverseGeodesic(B, C, );
  final CA = inverseGeodesic(C, A, );
  final CB = inverseGeodesic(C, B, );

  final alpha = _angleDiff(AB["azi1"]!, AC["azi1"]!); // Winkel bei A
  final beta  = _angleDiff(BC["azi1"]!, BA["azi1"]!); // Winkel bei B
  final gamma = _angleDiff(CA["azi1"]!, CB["azi1"]!); // Winkel bei C


  return {
    "alpha": radianToDeg(alpha),
    "beta": radianToDeg(beta),
    "gamma": radianToDeg(gamma),
  };
}


Map<String, double> ellipsoidTriangleSides(LatLng A, LatLng B, LatLng C) {
  return {
    "a": distanceBearing(B, C, defaultEllipsoid).distance,
    "b": distanceBearing(A, C, defaultEllipsoid).distance,
    "c": distanceBearing(A, B, defaultEllipsoid).distance,
  };
}
