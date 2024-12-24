// imports
import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

// parts
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/aux_angle.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/aux_latitude.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/azimuthal_equidistant.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/d_aux_latitude.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/ellipsoid.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/elliptic_function.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geo_math.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geodesic.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geodesic_data.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geodesic_line.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/geodesic_mask.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/intersect.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/lambert_conformal_conic.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/math.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/pair.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/rhumb.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib/transverse_mercator.dart';

GeodesicData geodeticInverse(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  return _Geodesic(ellipsoid.a, ellipsoid.f).inverse(coords1.latitude, coords1.longitude, coords2.latitude, coords2.longitude);
}

GeodesicData geodeticDirect(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid, [bool arcmode = false]) {
  return _Geodesic(ellipsoid.a, ellipsoid.f).direct(coord.latitude, coord.longitude, bearing, arcmode, distance);
}

LatLng intersectGeodesics(LatLng coord1, double azimuth1, LatLng coord2, double azimuth2, Ellipsoid ellipsoid) {
  var intersect = _Intersect(ellipsoid.a, ellipsoid.f);
  var distances = intersect.closest(coord1.latitude, coord1.longitude, azimuth1, coord2.latitude, coord2.longitude, azimuth2);

  var geodesic = _Geodesic(ellipsoid.a, ellipsoid.f);
  var projected1 = geodesic.direct(coord1.latitude, coord1.longitude, azimuth1, false, distances.first);
  var projected2 = geodesic.direct(coord2.latitude, coord2.longitude, azimuth2, false, distances.second);

  return LatLng((projected1.lat2 + projected2.lat2) / 2, (projected1.lon2 + projected2.lon2) / 2);
}

LatLng azimuthalEquidistantReverse(LatLng projectionCenter, Point<double> point, Ellipsoid ellipsoid) {
  var aeReturn = _AzimuthalEquidistant.reverse(projectionCenter.latitude, projectionCenter.longitude, point.x, point.y, ellipsoid);
  return LatLng(aeReturn.yOrLat, aeReturn.xOrLon);
}

Point<double> azimuthalEquidistantForward(LatLng projectionCenter, LatLng coord, Ellipsoid ellipsoid) {
  var aeReturn = _AzimuthalEquidistant.forward(projectionCenter.latitude, projectionCenter.longitude, coord.latitude, coord.longitude, ellipsoid);
  return Point(aeReturn.xOrLon, aeReturn.yOrLat);
}

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class Rhumb {
  late final _Rhumb rhumb;

  Rhumb(double a, double f) {
    rhumb = _Rhumb(a, f, true);
  }

  RhumbInverseReturn inverse(double lat1, double lon1, double lat2, double lon2) {
    return rhumb._Inverse(lat1, lon1, lat2, lon2);
  }

  RhumbDirectReturn direct(double lat1, double lon1, double azi12, double s12) {
    return rhumb._Direct(lat1, lon1, azi12, s12);
  }
}

// [1] Karney sketch retro-azimuthal projection: https://gis.stackexchange.com/questions/131628/direct-geodesic-with-point-2-azimuth/131695#131695
// [2] Karney explanation: https://gis.stackexchange.com/questions/487848/algorithm-for-retro-azimuthal-projection?noredirect=1#comment795761_487848
// [3] Spherical solution: https://en.wikipedia.org/wiki/Solution_of_triangles#Two_sides_and_non-included_angle_given_(spherical_SSA)
// [4] Theoretical basis/Newton equation; Karney (2011): http://arxiv.org/abs/1102.1215
// [5] Karney Matlab code: https://gis.stackexchange.com/a/488090/160294
List<LatLng> reverseAzimuthalProjection(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  bearing = normalizeBearing(bearing);

  if (bearing == 0 || bearing == 180) {
    var direct = geodeticDirect(coord, bearing - 180, distance, ellipsoid);
    return [LatLng(direct.lat2, direct.lon2)];
  }

  var betaDeg = bearing;
  if (betaDeg > 180) {
    betaDeg = 360 - betaDeg;
  }

  // Step 1: Initial value, solve for sphere ([3])
  // var northPole = const LatLng(90, 0);
  // var beta = degToRadian(betaDeg);
  // var b = distanceBearing(northPole, coord, ellipsoid).distance;
  // var c = distance;
  //
  // //acc. to [1], a solution exists if b > arcsin(sin(c) * sin(beta))
  // if (b <= asin(sin(c) * sin(beta))) {
  //   return [];
  // }

  // implementing [5]
  var deg = pi / 180;
  var s12 = distance;
  var azi2 = bearing * deg;
  var bet1 = atan((1 - ellipsoid.f) * tan(coord.latitudeInRad));
  var sig12 = (s12 / ellipsoid.a);
  // % Solve the SSA problem following Wikipedia [3]
  // var omg12 = asin(sin(sig12) * sin(azi2) / cos(bet1));
  var omg12 = asin(sin(sig12) * sin(azi2) / sin(bet1));
  // var azi1 = 2 * acot(cot((omg12 + azi2) / 2.0) * sin((pi / 2.0 - bet1 + sig12) / 2.0) / sin((pi / 2.0 - bet1 - sig12) / 2));
  var azi1 = 2 * acot(tan((azi2 - omg12) / 2.0) * sin((bet1 + sig12) / 2.0) / sin((bet1 - sig12) / 2));

  // var gamma = asin((sin(c) * sin(beta))/sin(b));
  // var alpha = 2 * 1 / tan(tan(0.5 * (beta - gamma) * (sin(0.5 * (b + c)) / sin(0.5 * (b - c)))));

  // end step 1

  // Step 2: Newton's method, [4] with [1] and [2]
  //
  // psi^(i + 1) = psi^(i) - (theta^(i) - theta) * D)
  // psi = alpha_1
  // theta = s_12

  // % Solve the trig problem on the auxiliary sphere to give sig12
  double _lat2 = 0.0, _lon2 = 0.0;
  for (int i = 0; i < 10; i++) {
    var azi0 = asin(sin(azi1) * cos(bet1));
    var bet2 = acos(sin(azi0) / sin(azi2));
    var sig1 = atan2(sin(bet1), cos(azi1) * cos(bet1)) / deg;
    var sig2 = atan2(sin(bet2), cos(azi2) * cos(bet2)) / deg;
    sig12 = sig2 - sig1;

    // Solve the direct problem to give s12x
    var directData = geodeticDirect(coord, sig12, azi1 / deg, ellipsoid, true);
    var lat2 = directData.lat2;
    var s12x = directData.a12;
    var m12 = directData.m12;
    bet2 = atan((1 - ellipsoid.f) * tan(lat2 * deg));
    var w2 = sqrt(1 - ellipsoid.e2 * cos(bet2) * cos(bet2));
    // % The correction to azi1, see Eq (79) of [4]
    var dazi1 = -(s12x - s12) / (m12 * tan(azi2) - ellipsoid.a * w2 / (tan(azi1) * tan(bet2) * cos(azi2)));
    azi1 = azi1 + dazi1;

    directData = geodeticDirect(coord, 12, azi1 / deg, ellipsoid);
    _lat2 = directData.lat2;
    _lon2 = directData.lon2;
  }
  // end step 2

  return [LatLng(_lat2, _lon2)];
}

void main() {
  var dest = LatLng(52.0, 13.0);
  var bearingToDest = 123.0;
  var dist = 100000.0;
  var ells = Ellipsoid.WGS84;

  print(reverseAzimuthalProjection(dest, bearingToDest, dist, ells));
}

