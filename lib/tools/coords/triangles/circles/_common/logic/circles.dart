import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

part 'package:gc_wizard/tools/coords/triangles/circles/incircle/logic/incircle.dart';
part 'package:gc_wizard/tools/coords/triangles/circles/excircles/logic/excircles.dart';

enum _CircleType {INCIRCLE, EXCIRCLE}

class EllipsoidTriangleCircle{
  Circle circle;
  List<LatLng> touchpoints;

  EllipsoidTriangleCircle(this.circle, this.touchpoints);
}

double _distanceToGeodesic(LatLng point, LatLng lineStart, double bearing, Ellipsoid ellipsoid) {
  var project = orthogonalProjectionBearing(point, lineStart, bearing, ellipsoid);
  return distanceBearing(point, project, ellipsoid).distance;
}

const double _TARGET_PRECISION = 1e-10;
const int _MAX_ITERATIONS = 1000;

/// Optimiert den Punkt auf dem Ellipsoid durch Minimierung der Abstands-Varianz
EllipsoidTriangleCircle _optimizeCircle(LatLng startPoint, ELlipsoidTriangle triangle, _CircleType type, Ellipsoid ellipsoid) {
  LatLng currentPoint = startPoint;

  var dAB = triangle.distanceAB;
  var dBC = triangle.distanceBC;
  var dCA = triangle.distanceAC;

  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  // DYNAMISCHER START-STEP: Max. 25% der längsten Seite, gedeckelt auf 100km.
  // Das verhindert das Verschwenden von Iterationen bei kleinen Dreiecken.
  double maxSide = max(dAB, max(dBC, dCA));
  double stepSize = min(100 * 1000, maxSide / 4.0);
  if (stepSize < 1.0) stepSize = 1.0; // Absolutes Minimum für den Start

  double currentCost = _costFunction(currentPoint, triangle, type, ellipsoid);


  List<double> searchAzimuths = [];
  double i = 0;
  final _step = 45;
  while (i < 360) {
    searchAzimuths.add(i);
    i += _step;
  }

  int iterations = 0;
  var countInc = 0;
  while (stepSize > _TARGET_PRECISION && iterations < _MAX_ITERATIONS) {
    bool foundBetter = false;

    for (double az in searchAzimuths) {
      LatLng testPoint = projection(currentPoint, az, stepSize, ellipsoid);
      double testCost = _costFunction(testPoint, triangle, type, ellipsoid);

      if (testCost < currentCost) {
        currentPoint = testPoint;
        currentCost = testCost;
        foundBetter = true;

        // MOMENTUM (Beschleuniger): Wenn die Richtung gut ist, geh noch einen Schritt!
        // Gut für extrem flache/lange Dreiecke
        LatLng accelPoint = projection(currentPoint, az, stepSize, ellipsoid);
        double accelCost = _costFunction(accelPoint, triangle, type, ellipsoid);
        if (accelCost < currentCost) {
          currentPoint = accelPoint;
          currentCost = accelCost;
        }
      }
    }

    if (!foundBetter || countInc >= 3) {
      // Suchraster verfeinern
      stepSize /= 2.0;
      countInc = 0;
    }

    iterations++;
  }

  var projectA = orthogonalProjectionBearing(currentPoint, b, triangle.bearingBC, ellipsoid);
  var projectB = orthogonalProjectionBearing(currentPoint, c, triangle.bearingCA, ellipsoid);
  var projectC = orthogonalProjectionBearing(currentPoint, a, triangle.bearingAB, ellipsoid);

  var radius = (distanceBearing(currentPoint, projectA, ellipsoid).distance
      + distanceBearing(currentPoint, projectB, ellipsoid).distance
      + distanceBearing(currentPoint, projectC, ellipsoid).distance) / 3;

  return EllipsoidTriangleCircle(Circle(currentPoint, radius), [projectA, projectB, projectC]);
}

/// Die Kostenfunktion: Minimiert die Varianz (Unterschiede) der drei Lote
double _costFunction(LatLng p, ELlipsoidTriangle triangle, _CircleType type, Ellipsoid ellipsoid) {
  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  bool sideAB = isPointRightOfSideAB(p, a, b, c.latitude >= 0, ellipsoid); // Liegt P rechts von AB?
  bool sideBC = isPointRightOfSideAB(p, b, c, a.latitude >= 0, ellipsoid); // Liegt P rechts von BC?
  bool sideCA = isPointRightOfSideAB(p, c, a, b.latitude >= 0, ellipsoid); // Liegt P rechts von CA?

  bool isValidRegion = false;

  switch (type) {
    case _CircleType.INCIRCLE:
    // Alle Seiten müssen mit der Innenseite übereinstimmen
      isValidRegion = (sideAB && sideBC && sideCA) || (!sideAB && !sideBC && !sideCA);
      break;
    case _CircleType.EXCIRCLE:
      isValidRegion = true;
      break;
  }

  if (!isValidRegion) {
    return double.maxFinite;
  }

  double d1 = _distanceToGeodesic(p, triangle.a, triangle.bearingAB, ellipsoid);
  double d2 = _distanceToGeodesic(p, triangle.b, triangle.bearingBC, ellipsoid);
  double d3 = _distanceToGeodesic(p, triangle.c, triangle.bearingCA, ellipsoid);

  double mean = (d1 + d2 + d3) / 3.0;

  return pow(d1 - mean, 2) + pow(d2 - mean, 2) + pow(d3 - mean, 2).toDouble();
}