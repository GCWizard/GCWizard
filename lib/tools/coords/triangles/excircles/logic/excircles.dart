import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/triangles/orthocenter/logic/orthocenter.dart';
import 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';



class Excircle2 {
  final XYPoint center;
  final double radius;
  const Excircle2(this.center, this.radius);
}

class Excircles2 {
  final Excircle2 oppositeA;
  final Excircle2 oppositeB;
  final Excircle2 oppositeC;
  const Excircles2(this.oppositeA, this.oppositeB, this.oppositeC);
}

Excircles2 excirclesPlanar(XYPoint A, XYPoint B, XYPoint C) {
  // a = |BC|, b = |CA|, c = |AB|
  final sides = triangleSidesXY(A, B, C);
  final a = sides.a;
  final b = sides.b;
  final c = sides.c;

  final s = (a + b + c) / 2.0;
  final area = triangleAreaXY(A, B, C);

  final rA = area / (s - a);
  final rB = area / (s - b);
  final rC = area / (s - c);

  final denomA = (b + c - a);
  final denomB = (a + c - b);
  final denomC = (a + b - c);

  final IA = XYPoint(
    x: (-a * A.x + b * B.x + c * C.x) / denomA,
    y: (-a * A.y + b * B.y + c * C.y) / denomA,
  );

  final IB = XYPoint(
    x: (a * A.x - b * B.x + c * C.x) / denomB,
    y: (a * A.y - b * B.y + c * C.y) / denomB,
  );

  final IC = XYPoint(
    x: (a * A.x + b * B.x - c * C.x) / denomC,
    y: (a * A.y + b * B.y - c * C.y) / denomC,
  );

  return Excircles2(
    Excircle2(IA, rA),
    Excircle2(IB, rB),
    Excircle2(IC, rC),
  );
}

class EllipticExcircle {
  final double latDeg;
  final double lonDeg;
  final double radiusMeters; // geodätischer Radius (s.u.)
  const EllipticExcircle(this.latDeg, this.lonDeg, this.radiusMeters);
}

class EllipticExcircles {
  final EllipticExcircle oppositeA;
  final EllipticExcircle oppositeB;
  final EllipticExcircle oppositeC;
  const EllipticExcircles(this.oppositeA, this.oppositeB, this.oppositeC);
}

double _distancePointToGeodesicSegment(
    GeodesicWgs84 geod,
    double latP, double lonP,
    double lat1, double lon1,
    double lat2, double lon2,
    ) {
  final inv12 = geod.inverse(lat1, lon1, lat2, lon2);
  final s12 = inv12.s12;
  final azi12 = inv12.azi1;

  // Ternäre Suche auf t in [0,1]
  double tL = 0.0, tR = 1.0;
  for (int i = 0; i < 40; i++) {
    final t1 = (2 * tL + tR) / 3;
    final t2 = (tL + 2 * tR) / 3;

    final p1 = geod.direct(lat1, lon1, azi12, s12 * t1);
    final p2 = geod.direct(lat1, lon1, azi12, s12 * t2);

    final d1 = geod.inverse(latP, lonP, p1.lat2, p1.lon2).s12;
    final d2 = geod.inverse(latP, lonP, p2.lat2, p2.lon2).s12;

    if (d1 < d2) {
      tR = t2;
    } else {
      tL = t1;
    }
  }

  final tBest = (tL + tR) / 2;
  final pBest = geod.direct(lat1, lon1, azi12, s12 * tBest);
  final dBest = geod.inverse(latP, lonP, pBest.lat2, pBest.lon2).s12;
  return dBest;
}


EllipticExcircles excirclesEllipsoid({
  required GeodesicWgs84 geod,
  required double latA,
  required double lonA,
  required double latB,
  required double lonB,
  required double latC,
  required double lonC,
}) {
  // Referenzpunkt für gnomonisch: Schwerpunkt
  final lat0 = (latA + latB + latC) / 3.0;
  final lon0 = (lonA + lonB + lonC) / 3.0;

  final gnom = GnomonicWgs84(geod);

  final A2 = gnom.forward(lat0, lon0, latA, lonA);
  final B2 = gnom.forward(lat0, lon0, latB, lonB);
  final C2 = gnom.forward(lat0, lon0, latC, lonC);

  final planar = excirclesPlanar(XYPoint(x: A2.x, y: A2.y), XYPoint(x: B2.x, y: B2.y), XYPoint(x: C2.x, y: C2.y));

  // Exzentrum gegenüber A (Seite BC)
  final IA_ll = gnom.reverse(lat0, lon0, planar.oppositeA.center.x, planar.oppositeA.center.y);
  final latIA = IA_ll.x;
  final lonIA = ((IA_ll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  final rA = _distancePointToGeodesicSegment(
    geod, latIA, lonIA, latB, lonB, latC, lonC,
  );

  // Exzentrum gegenüber B (Seite CA)
  final IB_ll = gnom.reverse(lat0, lon0, planar.oppositeB.center.x, planar.oppositeB.center.y);
  final latIB = IB_ll.x;
  final lonIB = ((IB_ll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  final rB = _distancePointToGeodesicSegment(
    geod, latIB, lonIB, latC, lonC, latA, lonA,
  );

  // Exzentrum gegenüber C (Seite AB)
  final IC_ll = gnom.reverse(lat0, lon0, planar.oppositeC.center.x, planar.oppositeC.center.y);
  final latIC = IC_ll.x;
  final lonIC = ((IC_ll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  final rC = _distancePointToGeodesicSegment(
    geod, latIC, lonIC, latA, lonA, latB, lonB,
  );

  return EllipticExcircles(
    EllipticExcircle(latIA, lonIA, rA),
    EllipticExcircle(latIB, lonIB, rB),
    EllipticExcircle(latIC, lonIC, rC),
  );
}

List<Circle> calculateEllipsoidTriangleExCircles(LatLng A, LatLng B, LatLng C){
  final result = excirclesEllipsoid(
      geod: GeodesicWgs84(defaultEllipsoid.a, defaultEllipsoid.f, defaultEllipsoid.b),
      latA: A.latitude, lonA: A.longitude,
      latB: B.latitude, lonB: B.longitude,
      latC: C.latitude, lonC: C.longitude);
  return [
    Circle(LatLng(result.oppositeA.latDeg, result.oppositeA.lonDeg), result.oppositeA.radiusMeters),
    Circle(LatLng(result.oppositeB.latDeg, result.oppositeB.lonDeg), result.oppositeB.radiusMeters),
    Circle(LatLng(result.oppositeC.latDeg, result.oppositeC.lonDeg), result.oppositeC.radiusMeters),
  ];
}
