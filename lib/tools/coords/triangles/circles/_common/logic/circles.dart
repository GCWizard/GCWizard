import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
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

enum _CircleType {INCIRCLE, CIRCUMCIRCLE, EXCIRCLE}

double _distanceToGeodesic(LatLng point, LatLng lineStart, double bearing, Ellipsoid ellipsoid) {
  var project = orthogonalProjectionBearing(point, lineStart, bearing, ellipsoid);
  return distanceBearing(point, project, ellipsoid).distance;
}

const double _TARGET_PRECISION = 1e-10;
const int _MAX_ITERATIONS = 5000;

/// Optimiert den Punkt auf dem Ellipsoid durch Minimierung der Abstands-Varianz
Circle _optimizeCircle(LatLng startPoint, ELlipsoidTriangle triangle, _CircleType type, Ellipsoid ellipsoid) {
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

  var projectA = orthogonalProjectionTwoPoints(currentPoint, b, c, ellipsoid);
  var projectB = orthogonalProjectionTwoPoints(currentPoint, a, c, ellipsoid);
  var projectC = orthogonalProjectionTwoPoints(currentPoint, a, b, ellipsoid);

  var radius = (distanceBearing(currentPoint, projectA, ellipsoid).distance
      + distanceBearing(currentPoint, projectB, ellipsoid).distance
      + distanceBearing(currentPoint, projectC, ellipsoid).distance) / 3;

  return Circle(currentPoint, radius);
}

/// Die Kostenfunktion: Minimiert die Varianz (Unterschiede) der drei Lote
double _costFunction(LatLng p, ELlipsoidTriangle triangle, _CircleType type, Ellipsoid ellipsoid) {
  // 1. Topologische Prüfung
  bool inside = _isPointInside(p, triangle, ellipsoid);

  // Wenn wir einen Inkreis suchen, der Punkt aber draußen ist -> Mauer!
  if (type == _CircleType.INCIRCLE && !inside) {
    return double.maxFinite; // Unendlich hohe Kosten
  }

  // Wenn wir einen Ankreis suchen, der Punkt aber drinnen ist -> Mauer!
  if (type == _CircleType.EXCIRCLE && inside) {
    return double.maxFinite;
  }

  double d1 = _distanceToGeodesic(p, triangle.a, triangle.bearingAB, ellipsoid);
  double d2 = _distanceToGeodesic(p, triangle.b, triangle.bearingBC, ellipsoid);
  double d3 = _distanceToGeodesic(p, triangle.c, triangle.bearingCA, ellipsoid);

  double mean = (d1 + d2 + d3) / 3.0;

  // Summe der quadratischen Abweichungen (Varianz)
  return pow(d1 - mean, 2) + pow(d2 - mean, 2) + pow(d3 - mean, 2).toDouble();
}

/// Prüft, ob Punkt P innerhalb des Dreiecks ABC liegt.
bool _isPointInside(LatLng p, ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  // Hilfsfunktion: Liegt P rechts von der gerichteten Linie Start->Ende?
  bool isRightOf(LatLng start, LatLng end, bool isNorth, LatLng point) {
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

  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  bool rightAB = isRightOf(a, b, c.latitude >= 0, p);
  bool rightBC = isRightOf(b, c, a.latitude >= 0, p);
  bool rightCA = isRightOf(c, a, b.latitude >= 0, p);

  bool leftAB = !rightAB;
  bool leftBC = !rightBC;
  bool leftCA = !rightCA;

  // P ist im Dreieck, wenn es bei allen Linien auf der gleichen Seite liegt.
  return (rightAB && rightBC && rightCA) || (leftAB && leftBC && leftCA);
}