import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/triangles/orthocenter/logic/orthocenter.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

XYPoint _gergonnePlanar(XYPoint a, XYPoint b, XYPoint c) {
  // a = |BC|, b = |CA|, c = |AB|
  final sides = triangleSidesXY(a, b, c);
  final as = sides.a;
  final bs = sides.b;
  final cs = sides.c;

  final s = (as + bs + cs) / 2.0;

  final wa = 1.0 / (s - as);
  final wb = 1.0 / (s - bs);
  final wc = 1.0 / (s - cs);

  final wSum = wa + wb + wc;

  final x = (wa * a.x + wb * b.x + wc * c.x) / wSum;
  final y = (wa * a.y + wb * b.y + wc * c.y) / wSum;

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

  final a2 = gnom.forward(lat0, lon0, latA, lonA);
  final b2 = gnom.forward(lat0, lon0, latB, lonB);
  final c2 = gnom.forward(lat0, lon0, latC, lonC);

  final g2 = _gergonnePlanar(
      XYPoint(x: a2.x, y: a2.y),
      XYPoint(x: b2.x, y: b2.y),
      XYPoint(x: c2.x, y: c2.y));

  final gll = gnom.reverse(lat0, lon0, g2.x, g2.y);

  final lonNorm = ((gll.y + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;
  return LatLng(gll.x, lonNorm);
}

LatLng calculateEllipsoidTriangleGergonnePoint(LatLng a, LatLng b, LatLng c){
  return _gergonneOnEllipsoid(
      geod: GeodesicWgs84(
        defaultEllipsoid.a,
          defaultEllipsoid.f,
          defaultEllipsoid.b
      ),
      latA: a.latitude, lonA: a.longitude,
      latB: b.latitude, lonB: b.longitude,
      latC: c.latitude, lonC: c.longitude,
  );
}