import 'dart:math';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class IntersectBearingJobData {
  final LatLng coord1;
  final double az13;
  final LatLng coord2;
  final double az23;
  final Ellipsoid ells;
  final bool crossbearing;

  IntersectBearingJobData(
      {required this.coord1,
      this.az13 = 0.0,
      required this.coord2,
      this.az23 = 0.0,
      required this.ells,
      this.crossbearing = false});
}

Future<LatLng?> intersectBearingsAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! IntersectBearingJobData) {
    throw Exception('Unexpected Intersect data');
  }

  var data = jobData!.parameters as IntersectBearingJobData;
  var output = intersectBearings(data.coord1, data.az13, data.coord2, data.az23, data.ells, data.crossbearing);

  jobData.sendAsyncPort?.send(output);

  return output;
}

// Using "evolutional algorithms": Take state, add some random value.
// If result is better, repeat with new value until a certain tolance value is reached.
// Because of its random factor it is not necessarily given that an intersection point is found
// although there is always such a point between to geodetics (e.g. at the back side of the sphere)

LatLng? intersectBearings(LatLng coord1, double az13, LatLng coord2, double az23, Ellipsoid ells, bool crossbearing) {
  az13 = normalizeBearing(az13);
  az23 = normalizeBearing(az23);

  var _centerCalc = centerPointTwoPoints(coord1, coord2, ells);
  LatLng calculatedPoint = _centerCalc.centerPoint;
  double dist = _centerCalc.distance;

  var distBear1 = distanceBearing(coord1, calculatedPoint, ells);
  var distBear2 = distanceBearing(coord2, calculatedPoint, ells);

  double bear1, bear2;

  if (!crossbearing) {
    bear1 = distBear1.bearingAToB;
    bear2 = distBear2.bearingAToB;
  } else {
    bear1 = distBear1.bearingBToA;
    bear2 = distBear2.bearingBToA;
  }

  double d = (bear1 - az13) * (bear1 - az13) + (bear2 - az23) * (bear2 - az23);

  int c = 0;
  int br = 0;
  bool broke = false;

  while (d > practical_epsilon) {
    if (br > 50) {
      //adjusted these values empirical
      broke = true;
      break;
    }

    c++;
    if (c > 500) {
      br++;
      dist = 100;
      c = 0;
    }

    double bearing = Random().nextDouble() * 360.0;
    LatLng projectedPoint = projection(calculatedPoint, bearing, dist, ells);

    var distBear1 = distanceBearing(coord1, projectedPoint, ells);
    var distBear2 = distanceBearing(coord2, projectedPoint, ells);

    double bear1, bear2;

    if (!crossbearing) {
      bear1 = distBear1.bearingAToB;
      bear2 = distBear2.bearingAToB;
    } else {
      bear1 = distBear1.bearingBToA;
      bear2 = distBear2.bearingBToA;
    }

    double newD = (bear1 - az13) * (bear1 - az13) + (bear2 - az23) * (bear2 - az23);

    if (newD < d) {
      calculatedPoint = projectedPoint;

      dist *= 1.5; //adjusted these values empirical
      d = newD;
    } else if (newD > d) {
      dist /= 1.2;
    }
  }

  if (broke) return null;

  return calculatedPoint;
}

class IntersectFourPointsJobData {
  final LatLng coord11;
  final LatLng coord12;
  final LatLng coord21;
  final LatLng coord22;
  final Ellipsoid ells;

  IntersectFourPointsJobData(
      {required this.coord11, required this.coord12, required this.coord21, required this.coord22, required this.ells});
}

Future<LatLng?> intersectFourPointsAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! IntersectFourPointsJobData) {
    throw Exception('Unexpected Intersect data');
  }

  var data = jobData!.parameters as IntersectFourPointsJobData;
  var output = intersectFourPoints(data.coord11, data.coord12, data.coord21, data.coord22, data.ells);

  jobData.sendAsyncPort?.send(output);

  return output;
}

LatLng? intersectFourPoints(LatLng coord11, LatLng coord12, LatLng coord21, LatLng coord22, Ellipsoid ells) {
  var bearing1 = distanceBearing(coord11, coord12, ells).bearingAToB;
  var bearing2 = distanceBearing(coord21, coord22, ells).bearingAToB;

  return intersectBearings(coord11, bearing1, coord21, bearing2, ells, false);
}
