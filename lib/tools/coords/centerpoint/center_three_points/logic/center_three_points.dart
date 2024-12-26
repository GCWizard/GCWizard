import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/antipodes/logic/antipodes.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint_distance.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

// ported from http://web.archive.org/web/20240909104633/https://gis.stackexchange.com/revisions/63083/4 by @Kirk Kuykendall and @cffk (Charles Karney)

CenterPointDistance centerPointThreePoints(LatLng coord1, LatLng coord2, LatLng coord3, Ellipsoid ellipsoid) {

  int maxIterations = 15;
  var aeCenter = const LatLng(0, 90);
  var maxDiff = MAX_DOUBLE;
  for (int i = 0; i < maxIterations; i++) {
    var c = _findCircleCenter(_project(coord1, aeCenter, ellipsoid), _project(coord2, aeCenter, ellipsoid), _project(coord3, aeCenter, ellipsoid), ellipsoid);
    aeCenter = azimuthalEquidistantReverse(aeCenter, Point(c[0], c[1]), ellipsoid);
    var distA = distanceBearing(aeCenter, coord1, ellipsoid).distance;
    var distB = distanceBearing(aeCenter, coord2, ellipsoid).distance;
    var distC = distanceBearing(aeCenter, coord3, ellipsoid).distance;
    var diffAB = (distA - distB).abs();
    var diffBC = (distB - distC).abs();
    var diffAC = (distA - distC).abs();
    maxDiff = max(max(diffAB, diffBC), diffAC);

    if (maxDiff < 0.000001) {
      var earthRadius = ellipsoid.b;
      if (distA > earthRadius * pi / 2.0) {
        aeCenter = antipodes(aeCenter);
      } else {
        return CenterPointDistance(aeCenter, distA);
      }
    }
  }

  return CenterPointDistance(aeCenter, maxDiff);
}

List<double> _findCircleCenter(List<double> a, List<double> b, List<double> c, Ellipsoid ellipsoid) {
  // from http://blog.csharphelper.com/2011/11/08/draw-a-circle-through-three-points-in-c.aspx
  // Get the perpendicular bisector of (x1, y1) and (x2, y2).
  var x1 = (b[0] + a[0]) / 2;
  var y1 = (b[1] + a[1]) / 2;
  var dy1 = b[0] - a[0];
  var dx1 = -(b[1] - a[1]);

  // Get the perpendicular bisector of (x2, y2) and (x3, y3).
  var x2 = (c[0] + b[0]) / 2;
  var y2 = (c[1] + b[1]) / 2;
  var dy2 = c[0] - b[0];
  var dx2 = -(c[1] - b[1]);

  // See where the lines intersect.
  var cx = (y1 * dx1 * dx2 + x2 * dx1 * dy2 - x1 * dy1 * dx2 - y2 * dx1 * dx2)
      / (dx1 * dy2 - dy1 * dx2);
  var cy = (cx - x1) * dy1 / dx1 + y1;

  // make sure the intersection point falls
  // within the projection.
  var earthRadius = ellipsoid.b;

  // distance is from center of projection
  var dist = sqrt((cx * cx) + (cy * cy));
  double factor = 1.0;
  if (dist > earthRadius * pi) {
    // apply a factor so we don't fall off the edge
    // of the projection
    factor = earthRadius / dist;
  }
  var outPoint = [cx * factor, cy* factor];
  return outPoint;
}

List<double> _project(LatLng pnt, LatLng center, Ellipsoid ellipsoid) {
  var projected = azimuthalEquidistantForward(center, pnt, ellipsoid);
  return [projected.x, projected.y];
}
