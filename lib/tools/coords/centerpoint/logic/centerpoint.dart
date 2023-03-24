import 'dart:math';

import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';

class CenterPointJobData {
  final LatLng coord1;
  final LatLng coord2;
  final LatLng coord3;
  final Ellipsoid ellipsoid;

  CenterPointJobData({required this.coord1, required this.coord2, required this.coord3, required this.ellipsoid});
}

class CenterPointDistance {
  final LatLng centerPoint;
  final double distance;

  CenterPointDistance(this.centerPoint, this.distance);
}

CenterPointDistance centerPointTwoPoints(LatLng coord1, LatLng coord2, Ellipsoid ells) {
  var segments = segmentLine(coord1, coord2, 2, ells);

  return CenterPointDistance(segments.points.first, segments.segmentLength);
}

// TODO Mike Please check Map and dynamic for Async calculation
Future<List<CenterPointDistance>?> centerPointThreePointsAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData is! CenterPointJobData) return null;

  var data = jobData!.parameters as CenterPointJobData;
  var output = centerPointThreePoints(data.coord1, data.coord2, data.coord3, data.ellipsoid);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<CenterPointDistance> centerPointThreePoints(LatLng coord1, LatLng coord2, LatLng coord3, Ellipsoid ells) {
  if (coord1 == coord2) {
    return [centerPointTwoPoints(coord1, coord3, ells)];
  }

  if (coord1 == coord3) {
    return [centerPointTwoPoints(coord1, coord2, ells)];
  }

  if (coord2 == coord3) {
    return [centerPointTwoPoints(coord1, coord2, ells)];
  }

  var _result = [_calculateCenterPointThreePoints(coord1, coord2, coord3, ells)];

  // Commented out (S-Man42, 01/2021): Created some problems in a few cases. Don't know why, but hangs here
  //find a possible second point
  // var _maxRuns = 100;
  // while (_maxRuns > 0) {
  //   var _temp = _calculateCenterPointThreePoints(coord1, coord2, coord3, ells);
  //   double _dist1 = _temp['distance'];
  //   double _dist2 = _result[0]['distance'];
  //
  //   if ((_dist1 - _dist2).abs() > 1) {
  //     _result.add(_temp);
  //     break;
  //   }
  //
  //   _maxRuns--;
  // }

  _result.sort((a, b) {
    return a.distance.compareTo(b.distance);
  });

  return _result;
}

// Using "evolutional algorithms": Take state, add some random value.
// If result is better, repeat with new value until a certain tolance value is reached.
// Because of its random factor it is not necessarily given that an intersection point is found
// although there is always such a point between to geodetics (e.g. at the back side of the sphere)

CenterPointDistance _calculateCenterPointThreePoints(LatLng coord1, LatLng coord2, LatLng coord3, Ellipsoid ells) {
  double lat = (coord1.latitude + coord2.latitude + coord3.latitude) / 3.0;
  double lon = (coord1.longitude + coord2.longitude + coord3.longitude) / 3.0;
  var calculatedPoint = LatLng(lat, lon);

  double dist1 = distanceBearing(calculatedPoint, coord1, ells).distance;
  double dist2 = distanceBearing(calculatedPoint, coord2, ells).distance;
  double dist3 = distanceBearing(calculatedPoint, coord3, ells).distance;

  double dist = max(dist1, max(dist2, dist3));
  double originalDist = dist;

  double d = _checkDist(dist1, dist2, dist3);
  double distSum = dist1 + dist2 + dist3;

  int c = 0;

  while (d > practical_epsilon) {
    c++;
    if (c > 1000) {
      dist = originalDist;
      c = 0;
      calculatedPoint = LatLng(lat, lon);
    }

    double bearing = Random().nextDouble() * 360.0;
    LatLng projectedPoint = projection(calculatedPoint, bearing, dist, ells);

    dist1 = distanceBearing(projectedPoint, coord1, ells).distance;
    dist2 = distanceBearing(projectedPoint, coord2, ells).distance;
    dist3 = distanceBearing(projectedPoint, coord3, ells).distance;

    double newD = _checkDist(dist1, dist2, dist3);
    double newDistSum = dist1 + dist2 + dist3;

    if (newD < d && newDistSum < distSum + 1000000) {
      calculatedPoint = projectedPoint;

      dist *= 1.5; //adjusted these values empirical
      d = newD;
      distSum = newDistSum;
    } else if (newD > d || newDistSum > distSum + 1000000) {
      dist /= 1.2;
    }
  }

  return CenterPointDistance(calculatedPoint, dist1);
}

double _checkDist(double dist1, double dist2, double dist3) {
  return (dist1 - dist2) * (dist1 - dist2) + (dist1 - dist3) * (dist1 - dist3) + (dist2 - dist3) * (dist2 - dist3);
}
