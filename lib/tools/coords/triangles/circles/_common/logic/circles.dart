import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/antipodes/logic/antipodes.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

part 'package:gc_wizard/tools/coords/triangles/circles/incircle/logic/incircle.dart';
part 'package:gc_wizard/tools/coords/triangles/circles/excircles/logic/excircles.dart';

enum _CircleType {INCIRCLE, EXCIRCLE_A, EXCIRCLE_B, EXCIRCLE_C}

double _distanceToGeodesic(LatLng point, LatLng lineStart, double bearing, Ellipsoid ellipsoid) {
  var project = orthogonalProjectionBearing(point, lineStart, bearing, ellipsoid);
  return distanceBearing(point, project, ellipsoid).distance;
}

const double _TARGET_PRECISION = 1e-10;
const int _MAX_ITERATIONS = 5000;

/// Optimiert den Punkt auf dem Ellipsoid durch Minimierung der Abstands-Varianz
Circle _optimizeCircle(LatLng startPoint, ELlipsoidTriangle triangle, _CircleType type, Ellipsoid ellipsoid) {
  print(startPoint.latitude.toString() + ', ' + startPoint.longitude.toString());

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
  double stepSize = min(100000.0, maxSide / 4.0);
  if (stepSize < 1.0) stepSize = 1.0; // Absolutes Minimum für den Start

  double currentCost = _costFunction(currentPoint, triangle, type, ellipsoid);
  List<double> searchAzimuths = [0, 45, 90, 135, 180, 225, 270, 315];
  int iterations = 0;

  while (stepSize > _TARGET_PRECISION && iterations < _MAX_ITERATIONS) {
    // print('$iterations: ' + currentPoint.latitude.toString() + ', ' + currentPoint.longitude.toString() + ', $currentCost');
    bool foundBetter = false;

    for (double az in searchAzimuths) {
      LatLng testPoint = projection(currentPoint, az, stepSize, ellipsoid);
      double testCost = _costFunction(testPoint, triangle, type, ellipsoid);

      if (testCost < currentCost) {
        currentPoint = testPoint;
        currentCost = testCost;
        foundBetter = true;

        // MOMENTUM (Beschleuniger): Wenn die Richtung gut ist, geh direkt noch einen Schritt!
        // Das rettet uns bei extrem flachen/langen Dreiecken massiv Iterationen.
        LatLng accelPoint = projection(currentPoint, az, stepSize, ellipsoid);
        double accelCost = _costFunction(accelPoint, triangle, type, ellipsoid);
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

  print(iterations);

  var projectA = orthogonalProjectionBearing(currentPoint, b, triangle.bearingBC, ellipsoid);
  var projectB = orthogonalProjectionBearing(currentPoint, c, triangle.bearingCA, ellipsoid);
  var projectC = orthogonalProjectionBearing(currentPoint, a, triangle.bearingAB, ellipsoid);

  var radius = (distanceBearing(currentPoint, projectA, ellipsoid).distance
      + distanceBearing(currentPoint, projectB, ellipsoid).distance
      + distanceBearing(currentPoint, projectC, ellipsoid).distance) / 3;

  return Circle(currentPoint, radius);
}

/// Die Kostenfunktion: Minimiert die Varianz (Unterschiede) der drei Lote
double _costFunction(LatLng p, ELlipsoidTriangle triangle, _CircleType type, Ellipsoid ellipsoid) {
  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  // 1. Topologische Prüfung: Auf welcher Seite der Linien liegen wir?
  // Wir nutzen die Vorzeichen der Azimut-Differenz (isRightOf)
  bool sideAB = _isRightOf(p, a, b, c.latitude >= 0, ellipsoid); // Liegt P rechts von AB?
  bool sideBC = _isRightOf(p, b, c, a.latitude >= 0, ellipsoid); // Liegt P rechts von BC?
  bool sideCA = _isRightOf(p, c, a, b.latitude >= 0, ellipsoid); // Liegt P rechts von CA?

  // Referenzwerte: Wo liegen die Ecken selbst?
  bool cVsAB = _isRightOf(c, a, b, c.latitude >= 0, ellipsoid);
  bool aVsBC = _isRightOf(a, b, c, a.latitude >= 0, ellipsoid);
  bool bVsCA = _isRightOf(b, c, a, b.latitude >= 0, ellipsoid);

  bool isValidRegion = false;

  // print('$type, $sideAB = $cVsAB,  $sideBC = $aVsBC, $sideCA = $bVsCA');

  switch (type) {
    case _CircleType.INCIRCLE:
    // Alle Seiten müssen mit der Innenseite übereinstimmen
      isValidRegion = (sideAB && sideBC && sideCA) || (!sideAB && !sideBC && !sideCA);
      break;
    case _CircleType.EXCIRCLE_A:
    // Gegenüber von A: Seite BC muss "falsch" sein, andere "richtig"
      isValidRegion = (sideBC != aVsBC) && (sideAB == cVsAB) && (sideCA == bVsCA);
      isValidRegion |= (sideCA != bVsCA) && (sideAB == cVsAB) && (sideBC == aVsBC);
      isValidRegion |= (sideAB != cVsAB) && (sideBC == aVsBC) && (sideCA == bVsCA);
      break;
    case _CircleType.EXCIRCLE_B:
    // Gegenüber von B: Seite AC muss "falsch" sein, andere "richtig"
      isValidRegion = (sideCA != bVsCA) && (sideAB == cVsAB) && (sideBC == aVsBC);
      break;
    case _CircleType.EXCIRCLE_C:
    // Gegenüber von C: Seite AB muss "falsch" sein, andere "richtig"
      isValidRegion = (sideAB != cVsAB) && (sideBC == aVsBC) && (sideCA == bVsCA);
      break;
  }

  if (!isValidRegion) {
    return double.maxFinite; // Die "Mauer"
  }

  double d1 = _distanceToGeodesic(p, triangle.a, triangle.bearingAB, ellipsoid);
  double d2 = _distanceToGeodesic(p, triangle.b, triangle.bearingBC, ellipsoid);
  double d3 = _distanceToGeodesic(p, triangle.c, triangle.bearingCA, ellipsoid);

  double mean = (d1 + d2 + d3) / 3.0;

  // Summe der quadratischen Abweichungen (Varianz)
  return pow(d1 - mean, 2) + pow(d2 - mean, 2) + pow(d3 - mean, 2).toDouble();
}

bool _isRightOf(LatLng point, LatLng start, LatLng end, bool isNorth, Ellipsoid ellipsoid) {
  // 1. Azimut von Start nach Ende
  double azLine;
  if (utils.isAntipode(start, end)) {
    azLine = isNorth ? 0.0 : 180.0;
  } else {
    azLine = distanceBearing(start, end, ellipsoid).bearingAToB;
  }
  // 2. Azimut von Start nach P
  double azPoint = distanceBearing(start, point, ellipsoid).bearingAToB;

  // Winkeldifferenz berechnen (-180 bis +180)
  double diff = (azPoint - azLine) % 360;
  if (diff > 180) diff -= 360;
  if (diff < -180) diff += 360;

  return diff > 0; // Positiv bedeutet rechts (im Uhrzeigersinn abweichend)
}