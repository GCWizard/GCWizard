part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

class TriLinearPoint{
  final double a;
  final double b;
  final double c;

  TriLinearPoint({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class BarycentricPoint{
  final double a;
  final double b;
  final double c;

  BarycentricPoint({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class PolarPoint{
  final double r;
  final double phi;

  PolarPoint({this.r = 0.0, this.phi = 0.0});

  XYPoint toXYPoint() {
    // https://mathepedia.de/Kugelkoordinaten.html
    return XYPoint(
      x: r * cos(phi),
      y: r * sin(phi),
    );
  }

  void fromXYPoint() {
    // https://mathepedia.de/Kugelkoordinaten.html
    r: 0;
    phi: 0;
  }
}

double _distanceToLine(XYPoint p, XYPoint a, XYPoint b) {
  final A = a.y - b.y;
  final B = b.x - a.x;
  final C = a.x * b.y - b.x * a.y;

  return (A * p.x + B * p.y + C) / sqrt(A * A + B * B);
}

double _sideLength(XYPoint a, XYPoint b) {
  final dx = a.x - b.x;
  final dy = a.y - b.y;
  return sqrt(dx * dx + dy * dy);
}


class XYPoint{
  double x;
  double y;

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

  BarycentricPoint toBarycentric(Triangle t, XYPoint p) {
    final tri = XYPoint().toTriLinear(Triangle(t.A, t.B, t.C), p);
    final a = _sideLength(t.B, t.C);
    final b = _sideLength(t.C, t.A);
    final c = _sideLength(t.A, t.B);
    final u = a * tri.b;
    final v = b * tri.b;
    final w = c * tri.c;
    return BarycentricPoint(a: u, b: v, c: w);
  }

  static XYPoint fromBarycentric(Triangle t, double a, double b, double c) {
    final s = a + b + c;
    double x = (a * t.A.x + b * t.A.x + c * t.C.x) / s;
    double y = (a * t.A.y + b * t.B.y + c * t.C.y) / s;
    return XYPoint(x: x, y: y);
  }

  TriLinearPoint toTriLinear(Triangle t, XYPoint p) {
    final alpha = _distanceToLine(p, t.B, t.C); // Abstand zu BC
    final beta = _distanceToLine(p, t.C, t.A); // Abstand zu CA
    final gamma = _distanceToLine(p, t.A, t.B); // Abstand zu AB
    return TriLinearPoint(a: alpha, b: beta, c: gamma);
  }

  static XYPoint fromTriLinear(Triangle t, TriLinearPoint p, ) {
    // https://mathworld.wolfram.com/TrilinearCoordinates.html

    Sides s = triangleSidesXY(t.A, t.B, t.C);

    XYPoint av = _vectorNormalize(_vectorAB(t.B, t.C));
    double a1 = av.x;
    double a2 = av.y;

    XYPoint cv = _vectorNormalize(_vectorAB(t.A, t.B));
    double c1= cv.x;
    double c2 = cv.y;

    double apx = p.a;
    double cpz = p.c;
    double k = 2 * triangleAreaXY(t.A, t.B, t.C) / (p.a * s.a + p.b * s.b + p.c * s.c);
    double lc = (k * apx - cpz * k * (a1 * c1 + a2 * c2) + a2 * (t.A.x - t.C.x) + a1 * (t.C.y - t.A.y)) / (a1 * c2 - a2 * c1);


    double x = t.A.x + lc * c1 - k * p.c * c2;
    double y = t.A.y + lc * c2 + k * p.c * c1;

    return XYPoint(x: x, y: y);
  }

  static XYPoint fromPolarPoint(double r, double phi){
    return XYPoint(x: r * cos(phi), y: r * sin(phi));
  }

  PolarPoint toPolarPoint(){
    // https://mathepedia.de/Kugelkoordinaten.html
    return PolarPoint(
      r: sqrt(x* x + y * y),
      phi: (y >= 0) ? acos(x / sqrt(x * x + y * y)) : 2 * pi - acos(x / sqrt(x * x + y * y)),
    );
  }

  /// LatLng → lokale XY-Koordinaten (Meter) relativ zu origin
  static XYPoint fromLatLng(LatLng p, LatLng origin) {
    const double R = 6371000.0;
    final dLat = (p.latitude - origin.latitude) * pi / 180;
    final dLng = (p.longitude - origin.longitude) * pi / 180;

    double x = dLng * R * cos(origin.latitude * pi / 180);
    double y = dLat * R;

    return XYPoint(x: x, y: y);
  }

  /// XY → LatLng zurück
  LatLng toLatLng(XYPoint p, LatLng origin) {
    const double R = 6371000.0;
    final lat = origin.latitude + (p.y / R) * 180 / pi;
    final lng = origin.longitude + (p.x / (R * cos(origin.latitude * pi / 180))) * 180 / pi;
    return LatLng(lat, lng);
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

