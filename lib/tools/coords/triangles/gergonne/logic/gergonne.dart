import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/triangles/orthocenter/logic/orthocenter.dart';
import 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

XYPoint _gergonnePlanar(XYPoint A, XYPoint B, XYPoint C) {
  // a = |BC|, b = |CA|, c = |AB|
  final sides = triangleSidesXY(A, B, C);
  final a = sides.a;
  final b = sides.b;
  final c = sides.c;

  final s = (a + b + c) / 2.0;

  final wa = 1.0 / (s - a);
  final wb = 1.0 / (s - b);
  final wc = 1.0 / (s - c);

  final wSum = wa + wb + wc;

  final x = (wa * A.x + wb * B.x + wc * C.x) / wSum;
  final y = (wa * A.y + wb * B.y + wc * C.y) / wSum;

  return XYPoint(x: x, y: y);
}

LatLng _gergonneOnEllipsoid({
  required GeodesicWgs84 geod,
  required double latA,
  required double lonA,
  required double latB,
  required double lonB,
  required double latC,
  required double lonC,
}) {
  // Referenzpunkt für gnomonisch: z.B. Schwerpunkt
  final lat0 = (latA + latB + latC) / 3.0;
  final lon0 = (lonA + lonB + lonC) / 3.0;

  final gnom = GnomonicWgs84(geod);

  final A2 = gnom.forward(lat0, lon0, latA, lonA);
  final B2 = gnom.forward(lat0, lon0, latB, lonB);
  final C2 = gnom.forward(lat0, lon0, latC, lonC);

  final G2 = _gergonnePlanar(
      XYPoint(x: A2.x, y: A2.y),
      XYPoint(x: B2.x, y: B2.y),
      XYPoint(x: C2.x, y: C2.y));

  final Gll = gnom.reverse(lat0, lon0, G2.x, G2.y);

  final lonNorm = ((Gll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  return LatLng(Gll.x, lonNorm);
}

LatLng calculateEllipsoidTriangleGergonnePoint(LatLng A, LatLng B, LatLng C){
  return _gergonneOnEllipsoid(
      geod: GeodesicWgs84(
        defaultEllipsoid.a,
          defaultEllipsoid.f,
          defaultEllipsoid.b
      ),
      latA: A.latitude, lonA: A.longitude,
      latB: B.latitude, lonB: B.longitude,
      latC: C.latitude, lonC: C.longitude,

  );
}