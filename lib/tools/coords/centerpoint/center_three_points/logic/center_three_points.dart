import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint_distance.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/ellipsoidtriangle_circles.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

CenterPointDistance centerPointThreePoints(LatLng coord1, LatLng coord2, LatLng coord3, Ellipsoid ellipsoid) {
  if (equalsLatLng(coord1, coord2) && equalsLatLng(coord1, coord3)) {
    return CenterPointDistance(coord1, 0.0);
  }

  if (equalsLatLng(coord1, coord2) || equalsLatLng(coord2, coord3)) {
    var segment = segmentLine(coord1, coord3, 2, ellipsoid);
    return CenterPointDistance(segment.points.first, segment.segmentLength);
  }

  if (equalsLatLng(coord1, coord3)) {
    var segment = segmentLine(coord1, coord2, 2, ellipsoid);
    return CenterPointDistance(segment.points.first, segment.segmentLength);
  }

  var start = _getSphericalStartPoint(coord1, coord2, coord3);
  var circle = optimizeEllipsoidTriangleCircle(start, EllipsoidTriangle(coord1, coord2, coord3, ellipsoid), EllipsoidTriangleCircleType.CIRCUMCIRCLE, ellipsoid);
  return CenterPointDistance(circle.circle.center, circle.circle.radius);
}

/// Calculates the mathematical circumcenter centerpoint on a sphere
LatLng _getSphericalStartPoint(LatLng p1, LatLng p2, LatLng p3) {
  Vector3 a = _toCartesian(p1);
  Vector3 b = _toCartesian(p2);
  Vector3 c = _toCartesian(p3);

  // normal vector on a plane through all three points
  Vector3 v1 = b - a;
  Vector3 v2 = c - a;
  Vector3 n = v1.cross(v2);

  // If point collinear (1/1, 2/2, 3/3), n is nearly zero.
  if (n.length < 1e-15) {
    // In diesem Fall nehmen wir einen Punkt 90° versetzt zur Linie
    n = a.cross(Vector3(0, 0, 1));
    if (n.length < 1e-15) n = a.cross(Vector3(0, 1, 0));
  }

  Vector3 centerV = n.normalized();

  // there a two points on sphere (v and -v).
  // choose the one which lies closer to center of gravity
  LatLng candidate1 = _toLatLng(centerV);
  LatLng candidate2 = _toLatLng(centerV * -1.0);

  LatLng centroid = LatLng(
      (p1.latitude + p2.latitude + p3.latitude) / 3.0,
      (p1.longitude + p2.longitude + p3.longitude) / 3.0
  );

  // check for right hemisphere
  double d1 = pow(candidate1.latitude - centroid.latitude, 2) + pow(candidate1.longitude - centroid.longitude, 2).toDouble();
  double d2 = pow(candidate2.latitude - centroid.latitude, 2) + pow(candidate2.longitude - centroid.longitude, 2).toDouble();

  return d1 < d2 ? candidate1 : candidate2;
}

Vector3 _toCartesian(LatLng loc) {
  double latRad = loc.latitude * pi / 180.0;
  double lonRad = loc.longitude * pi / 180.0;
  return Vector3(
      cos(latRad) * cos(lonRad),
      cos(latRad) * sin(lonRad),
      sin(latRad)
  );
}

LatLng _toLatLng(Vector3 v) {
  double lat = asin(v.z) * 180.0 / pi;
  double lon = atan2(v.y, v.x) * 180.0 / pi;
  return LatLng(lat, lon);
}