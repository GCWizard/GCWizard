import 'dart:math';

import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

// All these functions are completely... Really? I don't even know what they do...
// Refactoring could be a lot of fun...

bool _isApprox(double a, double b) {
  return ((a - b).abs() <= doubleTolerance * min(a.abs(), b.abs()));
}

double _signAzimuthDifference(double az1, double az2) {
  return _mod(az1 - az2 + pi, 2 * pi) - pi;
}

double _mod(double x, double y) {
  return x - y * (x / y).floor();
}

double _findLinearRoot(List<double> x, List<double> errArray) {
  double root;

  if ((errArray[0] - errArray[1]).abs() < practical_epsilon) {
    root = x[0];
  } else {
    root = -errArray[0] * (x[1] - x[0]) / (errArray[1] - errArray[0]) + x[0];
  }

  return root;
}

class _PerpInterceptValue {
  final LatLng coordinate;
  final double distance;
  final double bearing;

  _PerpInterceptValue(this.coordinate, {this.distance = 0.0, this.bearing = 0.0});
}

_PerpInterceptValue _perpintercept(LatLng pt1, double dCrs13, LatLng pt2, Ellipsoid ells) {
  var distBear = distanceBearing(pt1, pt2, ells);

  double dist12 = distBear.distance;
  double crs12 = distBear.bearingAToBInRadian;
  double crs13 = dCrs13;

  double dAngle = _signAzimuthDifference(crs13, crs12).abs();

  _PerpInterceptValue output = _PerpInterceptValue(pt1, distance: 0.0, bearing: 0.0);

  if (dist12 <= doubleTolerance) {
    return output;
  }

  double dA = dist12 / ells.sphereRad;
  double dist13 = ells.sphereRad * atan(tan(dA) * (cos(dAngle))).abs();

  var _threshold = 275000.0; //This mysterious number was found in the original source... whatever it does...
  if (dAngle > pi * 2) {
    LatLng newPoint = projectionRadian(pt1, crs13 + pi, dist13 + _threshold, ells);
    dist13 = _threshold;
    distBear = distanceBearing(newPoint, pt1, ells);

    crs13 = distBear.bearingAToBInRadian;
    pt1 = newPoint;
  } else if ((dist13).abs() < _threshold) {
    LatLng newPoint = projectionRadian(pt1, crs13 + pi, _threshold, ells);
    dist13 = dist13 + _threshold;
    distBear = distanceBearing(newPoint, pt1, ells);

    crs13 = distBear.bearingAToBInRadian;
    pt1 = newPoint;
  }

  LatLng pt3 = projectionRadian(pt1, crs13, dist13, ells);
  distBear = distanceBearing(pt3, pt1, ells);
  double crs31 = distBear.bearingAToBInRadian;

  distBear = distanceBearing(pt3, pt2, ells);
  double crs32 = distBear.bearingAToBInRadian;
  double dist23 = distBear.distance;

  dAngle = _signAzimuthDifference(crs31, crs32).abs();

  List<double> errarray = [dAngle - pi];
  List<double> distarray = [dist13, (dist13 + errarray[0] * dist23).abs()];

  pt3 = projectionRadian(pt1, crs13, distarray[1], ells);
  distBear = distanceBearing(pt3, pt1, ells);
  crs31 = distBear.bearingAToBInRadian;

  distBear = distanceBearing(pt3, pt2, ells);
  crs32 = distBear.bearingAToBInRadian;

  errarray.add(_signAzimuthDifference(crs31, crs32).abs() - pi / 2);

  int k = 0;
  double dError = 0;

  while (k == 0 || ((dError > doubleTolerance) && (k < 15))) {
    double oldDist13 = dist13;
    dist13 = _findLinearRoot(distarray, errarray);

    if (dist13.isNaN) dist13 = oldDist13;

    pt3 = projectionRadian(pt1, crs13, dist13, ells);

    distBear = distanceBearing(pt3, pt1, ells);
    crs31 = distBear.bearingAToBInRadian;

    distBear = distanceBearing(pt3, pt2, ells);
    crs32 = distBear.bearingAToBInRadian;
    dist23 = distBear.distance;

    distarray[0] = distarray[1];
    distarray[1] = dist13;
    errarray[0] = errarray[1];
    errarray[1] = _signAzimuthDifference(crs31, crs32).abs() - pi / 2;
    dError = (distarray[1] - distarray[0]).abs();
    k++;
  }

  output = _PerpInterceptValue(pt3, distance: dist23, bearing: crs32);
  return output;
}

List<LatLng> geodesicArcIntercept(
    LatLng startGeodetic, double bearingGeodetic, LatLng centerPoint, double radiusCircle, Ellipsoid ells) {
  LatLng pt1 = startGeodetic;
  LatLng ptC = centerPoint;
  var crs1 = bearingGeodetic;

  _PerpInterceptValue perp = _perpintercept(pt1, crs1, ptC, ells);

  LatLng perpPt = perp.coordinate;
  var distBear = distanceBearing(perpPt, ptC, ells);
  double perpDist = distBear.distance;

  if (perpDist > radiusCircle) {
    return [];
  }

  if ((perpDist - radiusCircle).abs() < doubleTolerance) {
    return [perpPt];
  }

  distBear = distanceBearing(perpPt, pt1, ells);
  double crs = distBear.bearingAToBInRadian;

  if (_isApprox(cos(perpDist / ells.sphereRad), 0.0)) {
    return [];
  }

  double dist = ells.sphereRad * acos(cos(radiusCircle / ells.sphereRad) / cos(perpDist / ells.sphereRad));
  var pt = projectionRadian(perpPt, crs, dist, ells);

  List<LatLng> output = [];

  int nIntersects = 2;
  for (int i = 0; i < nIntersects; i++) {
    int k = 10;
    distBear = distanceBearing(ptC, pt, ells);
    double radDist = distBear.distance;
    double rcrs = distBear.bearingBToAInRadian;

    double dErr = radiusCircle - radDist;

    var distarray = [dist];
    var errarray = [dErr];

    distBear = distanceBearing(pt, perpPt, ells);
    double bcrs = distBear.bearingAToBInRadian;

    distBear = distanceBearing(ptC, pt, ells);
    double dAngle = _signAzimuthDifference(distBear.bearingAToBInRadian, distBear.bearingBToAInRadian).abs();
    double B = (_signAzimuthDifference(bcrs, rcrs) + pi - dAngle).abs();
    double A = acos(sin(B) * cos(dErr.abs() / ells.sphereRad));
    double c;

    if (sin(A).abs() < doubleTolerance) {
      c = dErr;
    } else if (A.abs() < doubleTolerance) {
      c = dErr / cos(B);
    } else {
      c = ells.sphereRad * asin(sin(dErr / ells.sphereRad) / sin(A));
    }

    if (dErr > 0) {
      dist = dist + c;
    } else {
      dist = dist - c;
    }

    pt = projectionRadian(perpPt, crs, dist, ells);
    distBear = distanceBearing(ptC, pt, ells);
    radDist = distBear.distance;

    distarray.add(dist);
    errarray.add(radiusCircle - radDist);

    while (dErr.abs() > doubleTolerance && k <= 10) {
      dist = _findLinearRoot(distarray, errarray);
      pt = projectionRadian(perpPt, crs, dist, ells);
      distBear = distanceBearing(ptC, pt, ells);
      radDist = distBear.distance;
      distarray[0] = distarray[1];
      errarray[0] = errarray[1];
      distarray[1] = dist;
      errarray[1] = radiusCircle - radDist;
      k++;
    }

    output.add(pt);

    crs = crs + pi;
    pt = projectionRadian(perpPt, crs, dist, ells);
    distBear = distanceBearing(ptC, pt, ells);
    radDist = distBear.distance;
    errarray[0] = radiusCircle - radDist;
  }

  return output;
}
