import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

class ELlipsoidTriangle {
  late LatLng a;
  late LatLng b;
  late LatLng c;

  late double distanceAB;
  late double distanceAC;
  late double distanceBC;

  late double bearingAB;
  late double bearingBA;
  late double bearingBC;
  late double bearingCB;
  late double bearingAC;
  late double bearingCA;

  late bool isValid;
  late bool isClockwise;

  late Ellipsoid ellipsoid;

  ELlipsoidTriangle(LatLng a, LatLng b, LatLng c, this.ellipsoid) {
    try {
      this.a = utils.normalizeLatLon(a.latitude, a.longitude);
      this.b = utils.normalizeLatLon(b.latitude, b.longitude);
      this.c = utils.normalizeLatLon(c.latitude, c.longitude);

      var distBearAB = distanceBearing(this.a, this.b, ellipsoid);
      var distBearAC = distanceBearing(this.a, this.c, ellipsoid);
      var distBearBC = distanceBearing(this.b, this.c, ellipsoid);

      distanceAB = distBearAB.distance;
      distanceAC = distBearAC.distance;
      distanceBC = distBearBC.distance;

      bearingAB = distBearAB.bearingAToB;
      bearingBA = distBearAB.bearingBToA;
      if (utils.isAntipode(this.a, this.b)) {
        if (this.c.latitude >= 0) {
          bearingAB = bearingBA = 0.0;
        } else {
          bearingAB = bearingBA = 180.0;
        }
      }

      bearingBC = distBearBC.bearingAToB;
      bearingCB = distBearBC.bearingBToA;
      if (utils.isAntipode(this.b, this.c)) {
        if (this.a.latitude >= 0) {
          bearingBC = bearingCB = 0.0;
        } else {
          bearingBC = bearingCB = 180.0;
        }
      }

      bearingAC = distBearAC.bearingAToB;
      bearingCA = distBearAC.bearingBToA;
      if (utils.isAntipode(this.a, this.c)) {
        if (this.b.latitude >= 0) {
          bearingAC = bearingCA = 0.0;
        } else {
          bearingAC = bearingCA = 180.0;
        }
      }

      isClockwise = isClockwiseOrderedEllipsoidTriangle(this, ellipsoid);
      isValid = isValidEllipsoidTriangle(this, ellipsoid);
    } catch (e) {
      isValid = false;
    }
  }

  ELlipsoidTriangle getClockwised() {
    return orderEllipsoidTrianglePointsClockwise(this, ellipsoid);
  }

  @override
  String toString() {
    return 'A: ' + a.latitude.toString() + ", " + a.longitude.toString() + ' | '
        'B: ' + b.latitude.toString() + ", " + b.longitude.toString() + ' | '
        'C: ' + c.latitude.toString() + ", " + c.longitude.toString();
  }
}