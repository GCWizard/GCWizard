import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/logic/tools/coords/intervals/coordinate_cell.dart';
import 'package:gc_wizard/logic/tools/coords/intervals/interval_calculator.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart' as utils;
import 'package:latlong2/latlong.dart';

class ResectionJobData {
  final LatLng coord1;
  final double angle12;
  final LatLng coord2;
  final double angle23;
  final LatLng coord3;
  final Ellipsoid ells;

  ResectionJobData(
      {this.coord1,
      this.angle12 = 0.0,
      this.coord2,
      this.angle23 = 0.0,
      this.coord3,
      this.ells});
}

class _ResectionCalculator extends IntervalCalculator {
  _ResectionCalculator(Map<String, dynamic> parameters, Ellipsoid ells) : super(parameters, ells);

  // If there is one interval [350, 400] and one [10, 50], they need to be
  // adjusted against each other to be comparable. So either the first is going to
  // be [-10, 40] or the other one [370, 410].
  Interval _adjustInterval(Interval reference, toAdjust) {
    Interval adjusted = Interval(a: toAdjust.a, b: toAdjust.b);

    while (reference.a < adjusted.b) {
      adjusted = Interval(a: adjusted.a - 360.0, b: adjusted.b - 360.0);
    }

    while (adjusted.b < reference.a) {
      adjusted = Interval(a: adjusted.a + 360.0, b: adjusted.b + 360.0);
    }

    return adjusted;
  }

  // Checks, if two intervals overlap
  bool _overlap(Interval a, b) {
    Interval i = _adjustInterval(a, b);

    if (a.a >= i.a && a.b <= i.b) return true;

    if (a.a <= i.a && a.b >= i.a) return true;

    if (a.b >= i.a && a.b <= i.b) return true;

    if (a.a >= i.a && a.a <= i.b) return true;

    return false;
  }

  @override
  bool checkCell(CoordinateCell cell, Map<String, dynamic> parameters) {
    Interval bearingFrom1 = cell.bearingTo(parameters['coord1']);
    Interval bearingFrom2 = cell.bearingTo(parameters['coord2']);
    Interval bearingFrom3 = cell.bearingTo(parameters['coord3']);

    // If at least two out of three points are in the current cell, then it is possible to find a bearing
    // to the third point in any case.
    Interval i360 = Interval(a: 0.0, b: 360.0);
    if ((i360.equals(bearingFrom1) && i360.equals(bearingFrom2)) ||
        (i360.equals(bearingFrom2) && i360.equals(bearingFrom3)) ||
        (i360.equals(bearingFrom1) && i360.equals(bearingFrom3))) return true;

    var angle12 = parameters['angle12'];
    var angle23 = parameters['angle23'];

    //Shift bearing interval according to the angle between -> check if overlaps ...
    var extended12 = _adjustInterval(bearingFrom2, Interval(a: bearingFrom1.a + angle12, b: bearingFrom1.b + angle12));
    var extended23 = _adjustInterval(bearingFrom3, Interval(a: bearingFrom2.a + angle23, b: bearingFrom2.b + angle23));
    var extended13 = _adjustInterval(
        bearingFrom3, Interval(a: bearingFrom1.a + angle12 + angle23, b: bearingFrom1.b + angle12 + angle23));
    if (_overlap(extended12, bearingFrom2) &&
        _overlap(extended23, bearingFrom3) &&
        _overlap(extended13, bearingFrom3)) {
      return true;
    }

    //... repeat with other direction if not worked.
    var extended32 = _adjustInterval(bearingFrom2, Interval(a: bearingFrom3.a + angle23, b: bearingFrom3.b + angle23));
    var extended21 = _adjustInterval(bearingFrom1, Interval(a: bearingFrom2.a + angle12, b: bearingFrom2.b + angle12));
    var extended31 = _adjustInterval(
        bearingFrom1, Interval(a: bearingFrom3.a + angle12 + angle23, b: bearingFrom3.b + angle12 + angle23));
    if (_overlap(extended32, bearingFrom2) &&
        _overlap(extended21, bearingFrom1) &&
        _overlap(extended31, bearingFrom1)) {
      return true;
    }

    return false;
  }
}

Future<List<LatLng>> resectionAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = resection(jobData.parameters.coord1, jobData.parameters.angle12, jobData.parameters.coord2,
      jobData.parameters.angle23, jobData.parameters.coord3, jobData.parameters.ells);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

List<LatLng> resection(LatLng coord1, double angle12, LatLng coord2, double angle23, LatLng coord3, Ellipsoid ells) {
  var minDistance = 1e-7;

  angle12 = utils.normalizeBearing(angle12);
  angle23 = utils.normalizeBearing(angle23);

  if (utils.coordEquals(coord1, coord2, tolerance: minDistance) ||
      utils.coordEquals(coord1, coord3, tolerance: minDistance) ||
      utils.coordEquals(coord2, coord3, tolerance: minDistance)) return [];

  return _ResectionCalculator(
          {'coord1': coord1, 'angle12': angle12, 'coord2': coord2, 'angle23': angle23, 'coord3': coord3}, ells)
      .check();
}
