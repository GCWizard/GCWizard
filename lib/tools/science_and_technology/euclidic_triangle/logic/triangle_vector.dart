part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

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

/// LatLng → 3D-Einheitsvektor
Vec3 latLngToVec3(LatLng p) {
  final lat = p.latitude * pi / 180;
  final lng = p.longitude * pi / 180;

  return Vec3(
    cos(lat) * cos(lng),
    cos(lat) * sin(lng),
    sin(lat),
  );
}


/// 3D-Einheitsvektor → LatLng
LatLng vec3ToLatLng(Vec3 v) {
  final lat = atan2(v.z, sqrt(v.x * v.x + v.y * v.y)) * 180 / pi;
  final lng = atan2(v.y, v.x) * 180 / pi;
  return LatLng(lat, lng);
}


extension Vec3Scale on Vec3 {
  Vec3 operator *(double s) => Vec3(x * s, y * s, z * s);
}
