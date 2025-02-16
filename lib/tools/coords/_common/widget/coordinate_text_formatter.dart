import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

String formatCoordOutput(LatLng _coords, CoordinateFormat _outputFormat, [Ellipsoid? ellipsoid, bool defaultPrecision = true]) {
  int? precision;

  switch (_outputFormat.type) {
    case CoordinateFormatKey.DMM:
      precision = defaultPrecision ? 3 : Prefs.getInt(PREFERENCE_COORD_PRECISION_DMM_COPY);
      break;
    default:
      break;
  }

  return buildCoordinate(_outputFormat, _coords, ellipsoid).toString(precision);
}
