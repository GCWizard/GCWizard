import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_metadata.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:prefs/prefs.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';

const defaultLambertType = CoordinateFormatKey.LAMBERT93;
const defaultGaussKruegerType = CoordinateFormatKey.GAUSS_KRUEGER_GK1;
const defaultSlippyMapType = CoordinateFormatKey.SLIPPYMAP_10;

final defaultCoordinate = LatLng(0.0, 0.0);

CoordinateFormatKey? _getDefaultSubtypeForFormat(CoordinateFormatKey format) {
  switch (format) {
    case CoordinateFormatKey.GAUSS_KRUEGER:
      return defaultGaussKruegerType;
    case CoordinateFormatKey.LAMBERT:
      return defaultLambertType;
    case CoordinateFormatKey.SLIPPY_MAP:
      return defaultSlippyMapType;
    default: return null;
  }
}

BaseCoordinate get defaultBaseCoordinate {
  return buildCoordinate(defaultCoordinateFormat, defaultCoordinate, defaultEllipsoid);
}

const CoordinateFormatKey _fallbackDefaultCoordFormatKey = CoordinateFormatKey.DMM;

CoordinateFormat get defaultCoordinateFormat {
  var formatStr = Prefs.getString(PREFERENCE_COORD_DEFAULT_FORMAT);

  CoordinateFormatKey format;
  if(formatStr.isEmpty) {
    format = _fallbackDefaultCoordFormatKey;
  } else {
    var _format = coordinateFormatMetadataByPersistenceKey(formatStr);
    format = (_format == null) ? _fallbackDefaultCoordFormatKey : _format.type;
  }

  return CoordinateFormat(format, defaultCoordinateFormatSubtypeForFormat(format));
}

CoordinateFormatMetadata get _defaultCoordinateFormat {
  return coordinateFormatMetadataByKey(_fallbackDefaultCoordFormatKey);
}

String get defaultCoordinateFormatPersistenceKey {
  return _defaultCoordinateFormat.persistenceKey;
}

String? get defaultCoordinateFormatSubtypePersistenceKey {
  var defaultSubtype = defaultCoordinateFormat.subtype;
  if (defaultSubtype == null) {
    return null;
  }
  
  return coordinateFormatMetadataByKey(defaultSubtype).persistenceKey;
}

CoordinateFormatKey? defaultCoordinateFormatSubtypeForFormat(CoordinateFormatKey format) {
  if (!(isCoordinateFormatWithSubtype(format))) {
    return null;
  }

  CoordinateFormatKey subtype;

  var subtypeStr = Prefs.getString(PREFERENCE_COORD_DEFAULT_FORMAT_SUBTYPE);
  if (subtypeStr.isEmpty) {
    subtype = _getDefaultSubtypeForFormat(format)!;
  } else {

    var _subtype = coordinateFormatMetadataSubtypeByPersistenceKey(subtypeStr);
    subtype = (_subtype == null || !isSubtypeOfCoordinateFormat(format, _subtype.type))
      ? _getDefaultSubtypeForFormat(format)!
      : _subtype.type;
  }

  var persistenceKeyForSubtype = coordinateFormatMetadataByKey(subtype).persistenceKey;
  Prefs.setString(PREFERENCE_COORD_DEFAULT_FORMAT_SUBTYPE, persistenceKeyForSubtype);

  return subtype;
}

int defaultHemiphereLatitude() {
  return Prefs.getString(PREFERENCE_COORD_DEFAULT_HEMISPHERE_LATITUDE) == HemisphereLatitude.North.toString() ? 1 : -1;
}

int defaultHemiphereLongitude() {
  return Prefs.getString(PREFERENCE_COORD_DEFAULT_HEMISPHERE_LONGITUDE) == HemisphereLongitude.East.toString() ? 1 : -1;
}

Ellipsoid get defaultEllipsoid {
  var _WGS84Ells = getEllipsoidByName(ELLIPSOID_NAME_WGS84)!;

  String type = Prefs.getString(PREFERENCE_COORD_DEFAULT_ELLIPSOID_TYPE);
  if (type.isEmpty) {
    type = EllipsoidType.STANDARD.toString();
  }

  if (type == EllipsoidType.STANDARD.toString()) {
    var ells = getEllipsoidByName(Prefs.getString(PREFERENCE_COORD_DEFAULT_ELLIPSOID_NAME));
    if (ells == null) {
      return _WGS84Ells;
    }

    return ells;
  }

  else if (type == EllipsoidType.USER_DEFINED.toString()) {
    double a = Prefs.getDouble(PREFERENCE_COORD_DEFAULT_ELLIPSOID_A);
    if (a == 0) {
      a = _WGS84Ells.a;
    }

    double invf = Prefs.getDouble(PREFERENCE_COORD_DEFAULT_ELLIPSOID_INVF);
    if (invf == 0) {
      invf = _WGS84Ells.invf;
    }

    return Ellipsoid(null, a, invf, type: EllipsoidType.USER_DEFINED);
  }

  throw Exception('No Ellipsoid type found.');
}