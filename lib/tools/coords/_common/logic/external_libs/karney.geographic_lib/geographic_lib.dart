// imports
import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/periodic_table.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;
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
// Note (MAL 01/2025): Due to limitation mentioned in SSA [3] as well as with polar points, this is currently not quite perfect
//     Therefore should not used stand-alone atm which is the reason, that is currently combined with the old
//     evolutional approach
LatLng reverseAzimuthalProjection(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  var betaDeg = bearing;
  if (betaDeg > 180) {
    betaDeg = 360 - betaDeg;
  }

  // implementing [5]
  var deg = pi / 180;
  var s12 = distance;
  var azi2 = (bearing + 180) * deg;
  var bet1 = atan((1 - ellipsoid.f) * tan(coord.latitudeInRad));
  var sig12 = (s12 / ellipsoid.a);
  // % Solve the SSA problem following Wikipedia [3]
  var omg12 = asin(sin(sig12) * sin(azi2) / cos(bet1));
  var azi1 = 2 * acot(cot((omg12 + azi2) / 2.0) * sin((pi / 2.0 - bet1 + sig12) / 2.0) / sin((pi / 2.0 - bet1 - sig12) / 2));

  // % Solve the trig problem on the auxiliary sphere to give sig12
  double _lat2 = double.nan, _lon2 = double.nan;
  var delta = double.nan;
  int cnt = 0;
  do {
    var azi0 = asin(sin(azi1) * cos(bet1));
    // Two possible signs for bet2 -- try both
    var _bet2 = acos(sin(azi0) / sin(azi2));
    var _dazi1 = double.nan;
    for (int i in [-1, 1]) {
      var bet2 = _bet2 * i;
      var sig1 = atan2(sin(bet1), cos(azi1) * cos(bet1)) / deg;
      var sig2 = atan2(sin(bet2), cos(azi2) * cos(bet2)) / deg;
      sig12 = sig2 - sig1;

      // Solve the direct problem to give s12x
      var directData = geodeticDirect(coord, azi1 / deg, utils.normalizeLon(sig12), ellipsoid, true);
      var lat2 = directData.lat2;
      var s12x = directData.s12;
      var m12 = directData.m12;
      bet2 = atan((1 - ellipsoid.f) * tan(lat2 * deg));
      var w2 = sqrt(1 - ellipsoid.e2 * cos(bet2) * cos(bet2));
      // % The correction to azi1, see Eq (79) of [4]
      var dazi1 = -(s12x - s12) /
          (m12 * tan(azi2) -
          ellipsoid.a * w2 / (tan(azi1) * tan(bet2) * cos(azi2)));

      if (_dazi1.isNaN || dazi1.abs() < _dazi1.abs()) {
        _dazi1 = dazi1;
        _lat2 = directData.lat2;
        _lon2 = directData.lon2;
      }
    }

    azi1 = azi1 + _dazi1;
    delta = _dazi1;

  } while (++cnt <= 10 && delta.abs() > 1e-10);

  return LatLng(_lat2, _lon2);
}
