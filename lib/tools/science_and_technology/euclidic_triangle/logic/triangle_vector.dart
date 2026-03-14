part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';



/// LatLng → 3D-Einheitsvektor
Vec3 latLngToVec3(LatLng p) {
  final lat = p.latitude * pi / 180;
  final lng = p.longitude * pi / 180;

  return Vec3(
    cos(lat) * cos(lng),
    cos(lat) * sin(lng),
    sin(lat)
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