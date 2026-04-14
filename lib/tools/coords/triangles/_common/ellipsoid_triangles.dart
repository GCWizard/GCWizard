import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';

bool isValidEllipsoidTriangle(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  if (a.latitude.isNaN || a.longitude.isNaN
    || b.latitude.isNaN || b.longitude.isNaN
    || c.latitude.isNaN || c.longitude.isNaN
  ) {
    return false;
  }

  if (a.latitude.isInfinite || a.longitude.isInfinite
      || b.latitude.isInfinite || b.longitude.isInfinite
      || c.latitude.isInfinite || c.longitude.isInfinite
  ) {
    return false;
  }

  if (equalsLatLng(a, b) || equalsLatLng(a, c) || equalsLatLng(b, c)) {
    return false;
  }

  if (
    (a.latitude.abs() == 90 && b.latitude.abs() == 90 && a.latitude.sign == b.latitude.sign)
    || (b.latitude.abs() == 90 && c.latitude.abs() == 90 && b.latitude.sign == c.latitude.sign)
    || (c.latitude.abs() == 90 && a.latitude.abs() == 90 && c.latitude.sign == a.latitude.sign)
  ) {
    return false;
  }

  var dists = [triangle.distanceAB, triangle.distanceAC, triangle.distanceBC];
  dists.sort();

  if ((dists[2] - dists[0] - dists[1]).abs() < 1e-3) {
    return false;
  }

  if (_ellipsoidTriangleAreaWithValidInput(triangle, ellipsoid) < 0.001) {
    return false;
  }

  return true;
}

bool isClockwiseOrderedEllipsoidTriangle(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var area = polygonAreaEdges(
    triangle.a,
    [triangle.distanceAB, triangle.distanceBC, triangle.distanceAC],
    [triangle.bearingAB, triangle.bearingBC, triangle.bearingCA],
    ellipsoid
  );
  return area < 0;
}

ELlipsoidTriangle orderEllipsoidTrianglePointsClockwise(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (triangle.isClockwise) {
    return triangle;
  } else {
    return ELlipsoidTriangle(triangle.a, triangle.c, triangle.b, ellipsoid);
  }
}

TriangleInteriorAngles ellipsoidTriangleAngles(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(triangle, ellipsoid)) {
    return TriangleInteriorAngles(alpha: 0.0, beta: 0.0, gamma: 0.0);
  }

  var _a = triangle.a;
  var _b = triangle.b;
  var _c = triangle.c;

  var aAngle = (distanceBearing(_a, _c, ellipsoid).bearingAToB - distanceBearing(_a, _b, ellipsoid).bearingAToB).abs();
  var bAngle = (distanceBearing(_b, _c, ellipsoid).bearingAToB - distanceBearing(_b, _a, ellipsoid).bearingAToB).abs();
  var cAngle = (distanceBearing(_c, _a, ellipsoid).bearingAToB - distanceBearing(_c, _b, ellipsoid).bearingAToB).abs();

  return TriangleInteriorAngles(
    alpha: aAngle > 180 ? 360 - aAngle : aAngle,
    beta: bAngle > 180 ? 360 - bAngle : bAngle,
    gamma: cAngle > 180 ? 360 - cAngle : cAngle,
  );
}

double ellipsoidTriangleCircumference(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(triangle, ellipsoid)) {
    return 0.0;
  }

  return triangle.distanceAB + triangle.distanceAC + triangle.distanceBC;
}

double _ellipsoidTriangleAreaWithValidInput(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  return polygonAreaEdges(
      triangle.a,
      [triangle.distanceAB, triangle.distanceBC, triangle.distanceAC],
      [triangle.bearingAB, triangle.bearingBC, triangle.bearingCA],
      ellipsoid
  ).abs();
}

double ellipsoidTriangleArea(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(triangle, ellipsoid)) {
    return 0.0;
  }

  return _ellipsoidTriangleAreaWithValidInput(triangle, ellipsoid);
}


bool triangleIsMeridianCircle(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var isHalf = polygonAreaIsHalfEllipsoid(
    triangle.a,
    [triangle.distanceAB, triangle.distanceBC, triangle.distanceAC],
    [triangle.bearingAB, triangle.bearingBC, triangle.bearingCA],
    ellipsoid
  );

  if (!isHalf) return false;

  return (triangle.a.latitude != 0) || (triangle.b.latitude != 0) || (triangle.c.latitude != 0);
}

bool triangleIsEquatorCircle(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var isHalf = polygonAreaIsHalfEllipsoid(
      triangle.a,
      [triangle.distanceAB, triangle.distanceBC, triangle.distanceAC],
      [triangle.bearingAB, triangle.bearingBC, triangle.bearingCA],
      ellipsoid
  );

  if (!isHalf) return false;

  return (triangle.a.latitude == 0) && (triangle.b.latitude == 0) && (triangle.c.latitude == 0);
}