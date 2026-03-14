part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

class TriLinearPoint {
  final double a;
  final double b;
  final double c;

  TriLinearPoint({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class BarycentricPoint {
  final double a;
  final double b;
  final double c;

  BarycentricPoint({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class PolarPoint {
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

  static PolarPoint fromXYPoint(XYPoint p) {
    // https://mathepedia.de/Kugelkoordinaten.html
    return PolarPoint(r: sqrt(p.x * p.x + p.y * p.y), phi: atan2(p.y, p.x));
  }
}

class XYPoint {
  double x;
  double y;

  XYPoint({this.x = 0.0, this.y = 0.0});

  XYPoint operator +(XYPoint other) => XYPoint(x: x + other.x, y: y + other.y);
  XYPoint operator /(double s) => XYPoint(x: x / s, y: y / s);
  XYPoint operator -(XYPoint other) => XYPoint(x: x - other.x, y: y - other.y);
  XYPoint operator *(double s) => XYPoint(x: x * s, y: y * s);

  XYPoint scale(double t) => XYPoint(x: x * t, y: y * t);
  double norm() => sqrt(x * x + y * y);
  double dot(XYPoint b) => x * b.x + y * b.y;

  double get r => sqrt(x * x + y * y);

  double distanceToLine(XYPoint a, XYPoint b) {
    final A = a.y - b.y;
    final B = b.x - a.x;
    final C = a.x * b.y - b.x * a.y;

    return (A * x + B * y + C) / sqrt(A * A + B * B);
  }

  double distanceToPoint(XYPoint b) {
    final dx = x - b.x;
    final dy = y - b.y;
    return sqrt(dx * dx + dy * dy);
  }

  bool equals(XYPoint other) => x == other.x && y == other.y;

  static XYPoint vector(XYPoint a, XYPoint b) => XYPoint(x: b.x - a.x, y: b.y - a.y);

  static bool vectorParallel(XYPoint a, XYPoint b) {
    a = _vectorNormalize(a);
    b = _vectorNormalize(b);
    return (a.x.abs() == b.x.abs() && a.y.abs() == b.y.abs());
  }

  XYPoint normalized() {
    final n = norm();
    return XYPoint(x: x / n, y: y / n);
  }

  BarycentricPoint toBarycentric(Triangle t, XYPoint p) {
    final tri = XYPoint().toTriLinear(Triangle(t.A, t.B, t.C), p);
    final a = t.B.distanceToPoint(t.C);
    final b = t.C.distanceToPoint(t.A);
    final c = t.A.distanceToPoint(t.B);

    final u = a * tri.b;
    final v = b * tri.b;
    final w = c * tri.c;
    return BarycentricPoint(a: u, b: v, c: w);
  }

  static XYPoint fromBarycentric(Triangle t, double a, double b, double c) {
    final s = a + b + c;
    double x = (a * t.A.x + b * t.B.x + c * t.C.x) / s;
    double y = (a * t.A.y + b * t.B.y + c * t.C.y) / s;
    return XYPoint(x: x, y: y);
  }

  TriLinearPoint toTriLinear(Triangle t, XYPoint p) {
    final alpha = p.distanceToLine(t.B, t.C); // Abstand zu BC
    final beta = p.distanceToLine(t.C, t.A); // Abstand zu CA
    final gamma = p.distanceToLine(t.A, t.B); // Abstand zu AB
    return TriLinearPoint(a: alpha, b: beta, c: gamma);
  }

  static XYPoint fromTriLinear(
    Triangle t,
    TriLinearPoint p,
  ) {
    // https://mathworld.wolfram.com/TrilinearCoordinates.html

    Sides s = triangleSidesXY(t.A, t.B, t.C);

    XYPoint av = _vectorNormalize(_vectorAB(t.B, t.C));
    double a1 = av.x;
    double a2 = av.y;

    XYPoint cv = _vectorNormalize(_vectorAB(t.A, t.B));
    double c1 = cv.x;
    double c2 = cv.y;

    double apx = p.a;
    double cpz = p.c;
    double k =
        2 * triangleAreaXY(t.A, t.B, t.C) / (p.a * s.a + p.b * s.b + p.c * s.c);
    double lc = (k * apx -
            cpz * k * (a1 * c1 + a2 * c2) +
            a2 * (t.A.x - t.C.x) +
            a1 * (t.C.y - t.A.y)) /
        (a1 * c2 - a2 * c1);

    double x = t.A.x + lc * c1 - k * p.c * c2;
    double y = t.A.y + lc * c2 + k * p.c * c1;

    return XYPoint(x: x, y: y);
  }

  static XYPoint fromPolarPoint(double r, double phi) {
    return XYPoint(x: r * cos(phi), y: r * sin(phi));
  }

  PolarPoint toPolarPoint() {
    // https://mathepedia.de/Kugelkoordinaten.html
    return PolarPoint(
      r: sqrt(x * x + y * y),
      phi: (y >= 0)
          ? acos(x / sqrt(x * x + y * y))
          : 2 * pi - acos(x / sqrt(x * x + y * y)),
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
    final lng = origin.longitude +
        (p.x / (R * cos(origin.latitude * pi / 180))) * 180 / pi;
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
  final lng = origin.longitude +
      (p.x / (R * cos(origin.latitude * pi / 180))) * 180 / pi;
  return LatLng(lat, lng);
}

class Sides {
  final double a;
  final double b;
  final double c;

  Sides({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class Angles {
  final double alpha;
  final double beta;
  final double gamma;

  Angles({this.alpha = 0.0, this.beta = 0.0, this.gamma = 0.0});
}

class XYLine {
  double m;
  double a;
  final XYPoint P1;
  final XYPoint P2;

  XYLine({this.m = 0, this.a = 0, required this.P1, required this.P2}) {
    m = (P2.y - P1.y) / (P2.x - P1.x);
    a = (P1.y * P2.x - P2.y * P1.x) / (P2.x - P1.x);
  }

  XYPoint? intersectLine(XYLine other) {
    Vec2? p = Vec2.lineIntersection(
        Vec2(P1.x, P1.y), Vec2(P2.x, P2.y),
        Vec2(other.P1.x, other.P1.y), Vec2(other.P2.x, other.P2.y));
    if (p == null) {
      return null;
    }
    return XYPoint(x: p.x, y: p.y);
  }

  bool containsPoint(XYPoint p, {double eps = 1e-9}) {
    final dx1 = P2.x - P1.x;
    final dy1 = P2.y - P1.y;
    final dx2 = p.x - P1.x;
    final dy2 = p.y - P1.y;

    final cross = dx1 * dy2 - dy1 * dx2;

    return cross.abs() < eps;
  }
}

class XYCircle {
  final double x;
  final double y;
  final double r;

  XYCircle({this.x = 0.0, this.y = 0.0, this.r = 0.0});

  bool containsPoint(XYPoint p) {
    final dx = p.x - x;
    final dy = p.y - y;
    final distanceSquared = dx * dx + dy * dy;
    return distanceSquared <= r * r;
  }

  bool onCircumference(XYPoint p, {double eps = 1e-9}) {
    final dx = p.x - x;
    final dy = p.y - y;
    final distanceSquared = dx * dx + dy * dy;
    return (distanceSquared - r * r).abs() < eps;
  }

  List<XYPoint> intersectLine(XYLine other) {
    /// Schnittpunkte zwischen einer Geraden (P1–P2) und einem Kreis.
    /// Rückgabe:
    /// - 0 Punkte → leere Liste
    /// - 1 Punkt  → Tangente
    /// - 2 Punkte → zwei Schnittpunkte

    final dx = other.P2.x - other.P1.x;
    final dy = other.P2.y - other.P1.y;

    // Verschiebung in Koordinaten des Kreises
    final fx = other.P1.x - x;
    final fy = other.P1.y - y;

    // Quadratische Gleichung: a*t² + b*t + c = 0
    final a = dx * dx + dy * dy;
    final b = 2 * (fx * dx + fy * dy);
    final c = fx * fx + fy * fy - r * r;

    final discriminant = b * b - 4 * a * c;

    // Keine Schnittpunkte
    if (discriminant < 0) {
      return [];
    }

    // Ein Schnittpunkt (Tangente)
    if (discriminant == 0) {
      final t = -b / (2 * a);
      return [XYPoint(x: other.P1.x + t * dx, y: other.P1.y + t * dy)];
    }

    // Zwei Schnittpunkte
    final sqrtD = sqrt(discriminant);
    final t1 = (-b + sqrtD) / (2 * a);
    final t2 = (-b - sqrtD) / (2 * a);

    final pA = XYPoint(x: other.P1.x + t1 * dx, y: other.P1.y + t1 * dy);
    final pB = XYPoint(x: other.P1.x + t2 * dx, y: other.P1.y + t2 * dy);

    return [pA, pB];
  }

  List<XYPoint>? intersectCircle(XYCircle other) {
    /// Berechnet die Schnittpunkte zweier Kreise.
    /// Rückgabe:
    /// - 0 Punkte → leere Liste
    /// - 1 Punkt  → Liste mit einem Punkt (Tangente)
    /// - 2 Punkte → Liste mit zwei Punkten
    /// - Identische Kreise → null (unendlich viele Schnittpunkte)

    final dx = other.x - x;
    final dy = other.y - y;
    final d = sqrt(dx * dx + dy * dy);

    // Identische Kreise → unendlich viele Schnittpunkte
    if (d == 0 && r == other.r) {
      return null;
    }

    // Keine Schnittpunkte (zu weit auseinander oder ein Kreis im anderen)
    if (d > r + other.r || d < (r - other.r).abs()) {
      return <XYPoint>[];
    }

    // Abstand von Mittelpunkt 0 zur Schnittpunktlinie
    final a = (r * r - other.r * other.r + d * d) / (2 * d);

    // Höhe der Schnittpunkte über der Verbindungslinie
    final h2 = r * r - a * a;
    final h = h2 < 0 ? 0 : sqrt(h2); // numerische Stabilität

    // Punkt P2 auf der Verbindungslinie
    final xm = x + a * dx / d;
    final ym = y + a * dy / d;

    // Tangentialfall → ein Schnittpunkt
    if (h == 0) {
      return [XYPoint(x: xm, y: ym)];
    }

    // Zwei Schnittpunkte
    final rx = -dy * (h / d);
    final ry = dx * (h / d);

    final p1 = XYPoint(x: xm + rx, y: ym + ry);
    final p2 = XYPoint(x: xm - rx, y: ym - ry);

    return [p1, p2];
  }
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

class Vec2 {
  final double x, y;
  const Vec2(this.x, this.y);

  Vec2 operator +(Vec2 o) => Vec2(x + o.x, y + o.y);
  Vec2 operator -(Vec2 o) => Vec2(x - o.x, y - o.y);
  Vec2 operator *(double s) => Vec2(x * s, y * s);
  Vec2 scale(double s) => Vec2(x * s, y * s);

  double dot(Vec2 o) => x * o.x + y * o.y;

  double norm() => sqrt(x * x + y * y);

  double cross(Vec2 o) => x * o.y - y * o.x;

  Vec2 normalized() {
    final n = norm();
    return Vec2(x / n, y / n);
  }

  /// Schnittpunkt zweier Geraden L1(P1,P2) und L2(P3,P4)
  /// Rückgabe:
  /// - Vec2 → eindeutiger Schnittpunkt
  /// - null → parallel oder kollinear (kein eindeutiger Schnittpunkt)
  static Vec2? lineIntersection(Vec2 p1, Vec2 p2, Vec2 p3, Vec2 p4) {
    final r = p2 - p1;
    final s = p4 - p3;

    final denom = r.cross(s);

    // Parallel oder kollinear → kein eindeutiger Schnittpunkt
    if (denom.abs() < 1e-12) {
      return null;
    }

    final t = (p3 - p1).cross(s) / denom;

    return p1 + r.scale(t);
  }
}
