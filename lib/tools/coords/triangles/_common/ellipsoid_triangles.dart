import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_three_points/logic/center_three_points.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_two_points/logic/center_two_points.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

class SpecialPointsOfEllipsoidTriangle {
  List<LatLng> points = [];
  late LatLng centerpoint;
  late double accuracy;

  SpecialPointsOfEllipsoidTriangle(this.points, Ellipsoid ellipsoid) {
    switch (points.length) {
      case 0:
        centerpoint = LatLng(double.nan, double.nan);
        accuracy = double.nan;
        break;
      case 1:
        centerpoint = points.first;
        accuracy = 0.0;
        break;
      case 2:
        var center = centerPointTwoPoints(points[0], points[1], ellipsoid);
        centerpoint = center.centerPoint;
        accuracy = center.distance;
        break;
      default:
        var center = centerPointThreePoints(points[0], points[1], points[2], ellipsoid);
        centerpoint = center.centerPoint;
        accuracy = center.distance;
        break;
    }
  }
}

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

bool isPointRightOfSideAB(LatLng point, LatLng startA, LatLng endB, bool isCNorth, Ellipsoid ellipsoid) {
  double azLine;
  if (utils.isAntipode(startA, endB)) {
    azLine = isCNorth ? 0.0 : 180.0;
  } else {
    azLine = distanceBearing(startA, endB, ellipsoid).bearingAToB;
  }

  double azPoint = distanceBearing(startA, point, ellipsoid).bearingAToB;

  double diff = (azPoint - azLine) % 360;
  if (diff > 180) diff -= 360;
  if (diff < -180) diff += 360;

  return diff > 0;
}