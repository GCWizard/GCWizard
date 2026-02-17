part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

class Triangle{
  final XYPoint a;
  final XYPoint b;
  final XYPoint c;

  const Triangle(this.a, this.b, this.c);

}

class TriLinearPoint{
  final double x;
  final double y;
  final double z;

  TriLinearPoint({this.x = 0.0, this.y = 0.0, this.z = 0.0});
}


class PolarPoint{
  final double r;
  final double phi;

  PolarPoint({this.r = 0.0, this.phi = 0.0});

  XYPoint toXYZPoint() {
    // https://mathepedia.de/Kugelkoordinaten.html
    return XYPoint(
      x: r * cos(phi),
      y: r * sin(phi),
    );
  }
}


class XYPoint{
  final double x;
  final double y;

  XYPoint({this.x = 0.0, this.y = 0.0});

  XYPoint operator +(XYPoint other) => XYPoint(x: x + other.x, y: y + other.y);
  XYPoint operator /(double s) => XYPoint(x: x / s, y: y / s);
  XYPoint operator -(XYPoint other) => XYPoint(x: x - other.x, y: y - other.y);
  XYPoint operator *(double s) => XYPoint(x: x * s, y: y * s);

  XYPoint scale(double t) => XYPoint(x: x * t, y: y * t);
  double norm() => sqrt(x * x + y * y);

  double get r => sqrt(x * x + y * y);

  bool equals(XYPoint other) => x == other.x && y == other.y;

  XYPoint normalized() {
    final n = norm();
    return XYPoint(x: x / n, y: y / n);
  }

  XYPoint fromBary(Triangle T, double alpha, double beta, double gamma) {
    final s = alpha + beta + gamma;
    return XYPoint(
      x: (alpha * T.a.x + beta * T.a.x + gamma * T.c.x) / s,
      y: (alpha * T.a.y + beta * T.b.y + gamma * T.c.y) / s,
    );
  }

  XYPoint fromTriLinear(Triangle t, TriLinearPoint p, ) {
    // https://mathworld.wolfram.com/TrilinearCoordinates.html

    Sides s = triangleSidesXY(t.a, t.b, t.c);

    XYPoint av = _vectorNormalize(_vectorAB(t.b, t.c));
    double a1 = av.x;
    double a2 = av.y;

    XYPoint cv = _vectorNormalize(_vectorAB(t.a, t.b));
    double c1= cv.x;
    double c2 = cv.y;

    double apx = p.x;
    double cpz = p.z;
    double k = 2 * triangleAreaXY(t.a, t.b, t.c) / (p.x * s.a + p.y * s.b + p.z * s.c);
    double lc = (k * apx - cpz * k * (a1 * c1 + a2 * c2) + a2 * (t.a.x - t.c.x) + a1 * (t.c.y - t.a.y)) / (a1 * c2 - a2 * c1);

    return XYPoint(
        x: t.a.x + lc * c1 - k * p.z * c2,
        y: t.a.y + lc * c2 + k * p.z * c1
    );
  }

  PolarPoint toPolarPoint(){
    // https://mathepedia.de/Kugelkoordinaten.html
    return PolarPoint(
      r: sqrt(x* x + y * y),
      phi: (y >= 0) ? acos(x / sqrt(x * x + y * y)) : 2 * pi - acos(x / sqrt(x * x + y * y)),
    );
  }

  XYPoint fromLatLon(LatLng coords){
    return XYPoint(x: coords.latitude, y: coords.longitude);
  }

  LatLng toLatLon(){
    return LatLng(x, y);
  }

}

/// LatLng → lokale XY-Koordinaten (Meter) relativ zu origin
XYPoint _toXY(LatLng p, LatLng origin) {
  const double R = 6371000.0;
  final dLat = (p.latitude - origin.latitude) * pi / 180;
  final dLng = (p.longitude - origin.longitude) * pi / 180;

  final x = dLng * R * cos(origin.latitude * pi / 180);
  final y = dLat * R;
  return XYPoint(x: x, y: y);
}

/// XY → LatLng zurück
LatLng _toLatLng(XYPoint p, LatLng origin) {
  const double R = 6371000.0;
  final lat = origin.latitude + (p.y / R) * 180 / pi;
  final lng = origin.longitude + (p.x / (R * cos(origin.latitude * pi / 180))) * 180 / pi;
  return LatLng(lat, lng);
}



class Sides{
  final double a;
  final double b;
  final double c;

  Sides({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class Angles{
  final double alpha;
  final double beta;
  final double gamma;

  Angles({this.alpha = 0.0, this.beta = 0.0, this.gamma = 0.0});
}

class XYLine{
  double m;
  double a;
  final XYPoint P1;
  final XYPoint P2;

  XYLine({this.m = 0, this.a = 0, required this.P1, required this.P2}){
    m = (P2.y - P1.y) / (P2.x - P1.x);
    a = (P1.y * P2.x - P2.y * P1.x) / (P2.x - P1.x);
  }
}



class XYCircle{
  final double x;
  final double y;
  final double r;

  XYCircle({this.x = 0.0, this.y = 0.0, this.r = 0.0});
}



class Vec3 {
  final double x, y, z;
  const Vec3(this.x, this.y, this.z);

  Vec3 operator +(Vec3 o) => Vec3(x + o.x, y + o.y, z + o.z);

  Vec3 operator -(Vec3 o) => Vec3(x - o.x, y - o.y, z - o.z);

  Vec3 operator *(double s) => Vec3(x * s, y * s, z * s);

  double dot(Vec3 o) => x * o.x + y * o.y + z * o.z;

  double norm() => sqrt(x * x + y * y + z * z);

  Vec3 cross(Vec3 o) => Vec3(
    y * o.z - z * o.y,
    z * o.x - x * o.z,
    x * o.y - y * o.x,
  );

  Vec3 normalized() {
    final n = norm();
    return Vec3(x / n, y / n, z / n);
  }
}