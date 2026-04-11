import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

double _distanceToGeodesic(LatLng point, LatLng lineStart, LatLng lineEnd, Ellipsoid ellipsoid) {
  var project = orthogonalProjectionTwoPoints(point, lineStart, lineEnd, ellipsoid);
  return distanceBearing(point, project, ellipsoid).distance;
}

const double _TARGET_PRECISION = 1e-10;
const int _MAX_ITERATIONS = 5000;

/// Hauptfunktion
Circle? calculateEllipsoidTriangleIncircle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return null;
  }

  LatLng _a = utils.normalizeLatLon(a.latitude, a.longitude);
  LatLng _b = utils.normalizeLatLon(b.latitude, b.longitude);
  LatLng _c = utils.normalizeLatLon(c.latitude, c.longitude);

  double dAB = distanceBearing(_a, _b, ellipsoid).distance;
  double dBC = distanceBearing(_b, _c, ellipsoid).distance;
  double dCA = distanceBearing(_c, _a, ellipsoid).distance;

  LatLng initialGuess = _guessStartpointByIntersectBisectors(_a, _b, _c, ellipsoid)!.center;

  return _optimizeIncenter(initialGuess, _a, _b, _c, dAB, dBC, dCA, ellipsoid);
}

/// Optimiert den Punkt auf dem Ellipsoid durch Minimierung der Abstands-Varianz
Circle _optimizeIncenter(LatLng startPoint, LatLng a, LatLng b, LatLng c, double dAB, double dBC, double dCA, Ellipsoid ellipsoid) {
  LatLng currentPoint = startPoint;

  // DYNAMISCHER START-STEP: Max. 25% der längsten Seite, gedeckelt auf 100km.
  // Das verhindert das Verschwenden von Iterationen bei kleinen Dreiecken.
  double maxSide = max(dAB, max(dBC, dCA));
  double stepSize = min(100000.0, maxSide / 4.0);
  if (stepSize < 1.0) stepSize = 1.0; // Absolutes Minimum für den Start

  double currentCost = _costFunction(currentPoint, a, b, c, ellipsoid);
  List<double> searchAzimuths = [0, 45, 90, 135, 180, 225, 270, 315];
  int iterations = 0;

  while (stepSize > _TARGET_PRECISION && iterations < _MAX_ITERATIONS) {
    bool foundBetter = false;

    for (double az in searchAzimuths) {
      LatLng testPoint = projection(currentPoint, az, stepSize, ellipsoid);
      double testCost = _costFunction(testPoint, a, b, c, ellipsoid);

      if (testCost < currentCost) {
        currentPoint = testPoint;
        currentCost = testCost;
        foundBetter = true;

        // MOMENTUM (Beschleuniger): Wenn die Richtung gut ist, geh direkt noch einen Schritt!
        // Das rettet uns bei extrem flachen/langen Dreiecken massiv Iterationen.
        LatLng accelPoint = projection(currentPoint, az, stepSize, ellipsoid);
        double accelCost = _costFunction(accelPoint, a, b, c, ellipsoid);
        if (accelCost < currentCost) {
          currentPoint = accelPoint;
          currentCost = accelCost;
        }
        break; // Azimut-Schleife abbrechen, vom neuen Punkt weiterarbeiten
      }
    }

    if (!foundBetter) {
      // Suchraster verfeinern
      stepSize /= 2.0;
    }
    iterations++;
  }

  var projectA = orthogonalProjectionTwoPoints(currentPoint, b, c, ellipsoid);
  var projectB = orthogonalProjectionTwoPoints(currentPoint, a, c, ellipsoid);
  var projectC = orthogonalProjectionTwoPoints(currentPoint, a, b, ellipsoid);

  var radius = (distanceBearing(currentPoint, projectA, ellipsoid).distance
    + distanceBearing(currentPoint, projectB, ellipsoid).distance
    + distanceBearing(currentPoint, projectC, ellipsoid).distance) / 3;

  return Circle(currentPoint, radius);
}

/// Die Kostenfunktion: Minimiert die Varianz (Unterschiede) der drei Lote
double _costFunction(LatLng p, LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  double d1 = _distanceToGeodesic(p, a, b, ellipsoid);
  double d2 = _distanceToGeodesic(p, b, c, ellipsoid);
  double d3 = _distanceToGeodesic(p, c, a, ellipsoid);

  double mean = (d1 + d2 + d3) / 3.0;

  // Summe der quadratischen Abweichungen (Varianz)
  return pow(d1 - mean, 2) + pow(d2 - mean, 2) + pow(d3 - mean, 2).toDouble();
}

Circle? _guessStartpointByIntersectBisectors(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var clockwiseOrdered = orderEllipsoidTrianglePointsClockwise(a, b, c, ellipsoid);
  var _a = clockwiseOrdered[0];
  var _b = clockwiseOrdered[1];
  var _c = clockwiseOrdered[2];

  var distBearAB = distanceBearing(_a, _b, ellipsoid);
  var distBearAC = distanceBearing(_a, _c, ellipsoid);
  var distBearBC = distanceBearing(_b, _c, ellipsoid);

  var bearingAB = distBearAB.bearingAToB;
  var bearingAC = distBearAC.bearingAToB;
  var bearingBA = distBearAB.bearingBToA;
  var bearingBC = distBearBC.bearingAToB;
  var bearingCA = distBearAC.bearingBToA;
  var bearingCB = distBearBC.bearingBToA;

  var distance = max(distBearAB.distance, max(distBearAC.distance, distBearBC.distance));

  var segmentA = segmentBearings(_a, bearingAB, bearingAC, distance, 2, ellipsoid);
  var segmentB = segmentBearings(_b, bearingBC, bearingBA, distance, 2, ellipsoid);
  var segmentC = segmentBearings(_c, bearingCA, bearingCB, distance, 2, ellipsoid);

  var segmentedBearingA = utils.normalizeBearing(bearingAB + segmentA.segmentAngle);
  var segmentedBearingB = utils.normalizeBearing(bearingBC + segmentB.segmentAngle);
  var segmentedBearingC = utils.normalizeBearing(bearingCA + segmentC.segmentAngle);

  var intersection1 = intersectBearings(_a, segmentedBearingA, _b, segmentedBearingB, ellipsoid);
  var intersection2 = intersectBearings(_a, segmentedBearingA, _c, segmentedBearingC, ellipsoid);
  var intersection3 = intersectBearings(_b, segmentedBearingB, _c, segmentedBearingC, ellipsoid);

  var projPToAB1 = orthogonalProjectionTwoPoints(intersection1, a, b, Ellipsoid.WGS84);
  var projPToBC1 = orthogonalProjectionTwoPoints(intersection1, b, c, Ellipsoid.WGS84);
  var projPToAC1 = orthogonalProjectionTwoPoints(intersection1, a, c, Ellipsoid.WGS84);
  var distAB1 = distanceBearing(intersection1, projPToAB1, Ellipsoid.WGS84).distance;
  var distBC1 = distanceBearing(intersection1, projPToBC1, Ellipsoid.WGS84).distance;
  var distAC1 = distanceBearing(intersection1, projPToAC1, Ellipsoid.WGS84).distance;

  var dists1 = [distAB1, distBC1, distAC1];
  dists1.sort();
  var diff1 = dists1[2] - dists1[0];

  var projPToAB2 = orthogonalProjectionTwoPoints(intersection2, a, b, Ellipsoid.WGS84);
  var projPToBC2 = orthogonalProjectionTwoPoints(intersection2, b, c, Ellipsoid.WGS84);
  var projPToAC2 = orthogonalProjectionTwoPoints(intersection2, a, c, Ellipsoid.WGS84);
  var distAB2 = distanceBearing(intersection2, projPToAB2, Ellipsoid.WGS84).distance;
  var distBC2 = distanceBearing(intersection2, projPToBC2, Ellipsoid.WGS84).distance;
  var distAC2 = distanceBearing(intersection2, projPToAC2, Ellipsoid.WGS84).distance;

  var dists2 = [distAB2, distBC2, distAC2];
  dists2.sort();
  var diff2 = dists2[2] - dists2[0];

  var projPToAB3 = orthogonalProjectionTwoPoints(intersection3, a, b, Ellipsoid.WGS84);
  var projPToBC3 = orthogonalProjectionTwoPoints(intersection3, b, c, Ellipsoid.WGS84);
  var projPToAC3 = orthogonalProjectionTwoPoints(intersection3, a, c, Ellipsoid.WGS84);
  var distAB3 = distanceBearing(intersection3, projPToAB3, Ellipsoid.WGS84).distance;
  var distBC3 = distanceBearing(intersection3, projPToBC3, Ellipsoid.WGS84).distance;
  var distAC3 = distanceBearing(intersection3, projPToAC3, Ellipsoid.WGS84).distance;

  var dists3 = [distAB3, distBC3, distAC3];
  dists3.sort();
  var diff3 = dists3[2] - dists3[0];

  var radius1 = (dists1[0] + dists1[1] + dists1[2]) / 3;
  var radius2 = (dists2[0] + dists2[1] + dists2[2]) / 3;
  var radius3 = (dists3[0] + dists3[1] + dists3[2]) / 3;

  if (diff1 <= diff2) {
    if (diff1 <= diff3) {
      return Circle(intersection1, radius1);
    } else {
      return Circle(intersection3, radius3);
    }
  } else {
    if (diff2 <= diff3) {
      return Circle(intersection2, radius2);
    } else {
      return Circle(intersection3, radius3);
    }
  }
}