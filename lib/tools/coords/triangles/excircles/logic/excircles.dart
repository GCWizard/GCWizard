import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/triangles/orthocenter/logic/orthocenter.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';


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


List<Circle> _excirclesEllipsoid({
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

  final planar = triangleExCirclesXY(XYPoint(x: A2.x, y: A2.y), XYPoint(x: B2.x, y: B2.y), XYPoint(x: C2.x, y: C2.y));

  // Exzentrum gegenüber A (Seite BC)
  final IA_ll = gnom.reverse(lat0, lon0, planar[0].x, planar[0].y);
  final latIA = IA_ll.x;
  final lonIA = ((IA_ll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  final rA = _distancePointToGeodesicSegment(
    geod, latIA, lonIA, latB, lonB, latC, lonC,
  );

  // Exzentrum gegenüber B (Seite CA)
  final IB_ll = gnom.reverse(lat0, lon0, planar[1].x, planar[1].y);
  final latIB = IB_ll.x;
  final lonIB = ((IB_ll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  final rB = _distancePointToGeodesicSegment(
    geod, latIB, lonIB, latC, lonC, latA, lonA,
  );

  // Exzentrum gegenüber C (Seite AB)
  final IC_ll = gnom.reverse(lat0, lon0, planar[2].x, planar[2].y);
  final latIC = IC_ll.x;
  final lonIC = ((IC_ll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  final rC = _distancePointToGeodesicSegment(
    geod, latIC, lonIC, latA, lonA, latB, lonB,
  );

  return [
    Circle(LatLng(latIA, lonIA), rA),
    Circle(LatLng(latIB, lonIB), rB),
    Circle(LatLng(latIC, lonIC), rC),
  ];
}

List<Circle> calculateEllipsoidTriangleExCircles(LatLng A, LatLng B, LatLng C){
  final result = _excirclesEllipsoid(
      geod: GeodesicWgs84(defaultEllipsoid.a, defaultEllipsoid.f, defaultEllipsoid.b),
      latA: A.latitude, lonA: A.longitude,
      latB: B.latitude, lonB: B.longitude,
      latC: C.latitude, lonC: C.longitude);
  return result;
}


LatLng _footOnGeodesicSegment(
    GeodesicWgs84 geod,
    double latE, double lonE,   // Exzentrum
    double lat1, double lon1,   // Seitenendpunkt 1
    double lat2, double lon2,   // Seitenendpunkt 2
    ) {
  final inv12 = geod.inverse(lat1, lon1, lat2, lon2);
  final s12 = inv12.s12;
  final azi12 = inv12.azi1;

  double tL = 0.0, tR = 1.0;
  for (int i = 0; i < 40; i++) {
    final t1 = (2 * tL + tR) / 3.0;
    final t2 = (tL + 2 * tR) / 3.0;

    final p1 = geod.direct(lat1, lon1, azi12, s12 * t1);
    final p2 = geod.direct(lat1, lon1, azi12, s12 * t2);

    final d1 = geod.inverse(latE, lonE, p1.lat2, p1.lon2).s12;
    final d2 = geod.inverse(latE, lonE, p2.lat2, p2.lon2).s12;

    if (d1 < d2) {
      tR = t2;
    } else {
      tL = t1;
    }
  }

  final tBest = (tL + tR) / 2.0;
  final pBest = geod.direct(lat1, lon1, azi12, s12 * tBest);
  final lonNorm = ((pBest.lon2 + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  return LatLng(pBest.lat2, lonNorm);
}

List<LatLng> _excircleTouchPointsEllipsoid({
  required GeodesicWgs84 geod,
  required List<Circle> exc,
  required double latA,
  required double lonA,
  required double latB,
  required double lonB,
  required double latC,
  required double lonC,
}) {
  // Ankreis gegenüber A → Seite BC
  final EA = exc[0];
  final HA = _footOnGeodesicSegment(
    geod,
    EA.center.latitude, EA.center.longitude,
    latB, lonB,
    latC, lonC,
  );

  // Ankreis gegenüber B → Seite CA
  final EB = exc[1];
  final HB = _footOnGeodesicSegment(
    geod,
    EB.center.latitude, EB.center.longitude,
    latC, lonC,
    latA, lonA,
  );

  // Ankreis gegenüber C → Seite AB
  final EC = exc[2];
  final HC = _footOnGeodesicSegment(
    geod,
    EC.center.latitude, EC.center.longitude,
    latA, lonA,
    latB, lonB,
  );

  return [HA, HB, HC];
}

List<LatLng> calculateEllipsoidTriangleExCirclesTouchPoints(LatLng A, LatLng B, LatLng C){
  return _excircleTouchPointsEllipsoid(
    geod: GeodesicWgs84(defaultEllipsoid.a, defaultEllipsoid.f, defaultEllipsoid.b),
    exc: calculateEllipsoidTriangleExCircles(A, B, C),
    latA: A.latitude, lonA: A.longitude,
    latB: B.latitude, lonB: B.longitude,
    latC: C.latitude, lonC: C.longitude,
  );
}