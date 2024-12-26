import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:latlong2/latlong.dart';

const defaultLambertType = CoordinateFormatKey.LAMBERT93;
const lambertKey = 'coords_lambert';
final _defaultCoordinate = LambertCoordinate(0, 0, defaultLambertType);

final LambertFormatDefinition = CoordinateFormatWithSubtypesDefinition(
    CoordinateFormatKey.LAMBERT,
    lambertKey,
    lambertKey,
    [
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93, 'coords_lambert_93', 'coords_lambert_93',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT2008, 'coords_lambert_2008', 'coords_lambert_2008',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.ETRS89LCC, 'coords_lambert_etrs89lcc', 'coords_lambert_etrs89lcc',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT72, 'coords_lambert_72', 'coords_lambert_72',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC42, 'coords_lambert_93_cc42', 'coords_lambert_93_cc42',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC43, 'coords_lambert_93_cc43', 'coords_lambert_93_cc43',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC44, 'coords_lambert_93_cc44', 'coords_lambert_93_cc44',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC45, 'coords_lambert_93_cc45', 'coords_lambert_93_cc45',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC46, 'coords_lambert_93_cc46', 'coords_lambert_93_cc46',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC47, 'coords_lambert_93_cc47', 'coords_lambert_93_cc47',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC48, 'coords_lambert_93_cc48', 'coords_lambert_93_cc48',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC49, 'coords_lambert_93_cc49', 'coords_lambert_93_cc49',
          LambertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.LAMBERT93_CC50, 'coords_lambert_93_cc50', 'coords_lambert_93_cc50',
          LambertCoordinate.parse, _defaultCoordinate)
    ],
    LambertCoordinate.parse,
    _defaultCoordinate);

class LambertCoordinate extends BaseCoordinateWithSubtypes {
  late CoordinateFormat _format;
  @override
  CoordinateFormat get format => _format;
  double easting;
  double northing;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid Lambert subtype given.';

  LambertCoordinate(this.easting, this.northing, CoordinateFormatKey subtypeKey) {
    if (subtypeKey != defaultLambertType && !isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.LAMBERT, subtypeKey);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return _lambertToLatLon(this, ells);
  }

  static LambertCoordinate fromLatLon(LatLng coord, CoordinateFormatKey subtype, Ellipsoid ells) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _latLonToLambert(coord, subtype, ells);
  }

  static LambertCoordinate? parse(String input, {CoordinateFormatKey subtype = defaultLambertType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _parseLambert(input, subtype: subtype);
  }

  @override
  CoordinateFormatKey get defaultSubtype => defaultLambertType;

  @override
  String toString([int? precision]) {
    return 'X: $easting\nY: $northing';
  }
}

class _LambertDefinition {
  final double centralMeridian; // lon0 λ0
  final double latitudeOfOrigin; // lat0 φ0
  final double standardParallel1; // stdlat1 φ1
  final double standardParallel2; // stdlat2 φ2
  // final double scaleFactor; // k0
  final double falseEasting; // x0
  final double falseNorthing; // y1

  const _LambertDefinition(
      {required this.centralMeridian,
      required this.latitudeOfOrigin,
      required this.standardParallel1,
      required this.standardParallel2,
      // this.scaleFactor,
      required this.falseEasting,
      required this.falseNorthing});
}

//https://www.spatialreference.org/ref/epsg/<epsg number>/html/

const Map<CoordinateFormatKey, _LambertDefinition> _LambertDefinitions = {
  //EPSG 2154, LAMB93, RGF93, Reseau Geodesique Francais 1993
  CoordinateFormatKey.LAMBERT93: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 46.5,
      standardParallel1: 49.0,
      standardParallel2: 44.0,
      falseEasting: 700000.0,
      falseNorthing: 6600000.0),
  //EPSG 3812, Belgian Lambert 2008
  CoordinateFormatKey.LAMBERT2008: _LambertDefinition(
      centralMeridian: 4.359215833333335,
      latitudeOfOrigin: 50.79781500000001,
      standardParallel1: 49.833333333333336,
      standardParallel2: 51.16666666666667,
      falseEasting: 649328.0,
      falseNorthing: 665262.0),
  //EPSG 31370
  CoordinateFormatKey.LAMBERT72: _LambertDefinition(
      centralMeridian: 4.367486666666666,
      latitudeOfOrigin: 90.0,
      standardParallel1: 51.16666723333333,
      standardParallel2: 49.8333339,
      falseEasting: 150000.013,
      falseNorthing: 5400088.438),
  //EPSG 3034
  CoordinateFormatKey.ETRS89LCC: _LambertDefinition(
      centralMeridian: 10.0,
      latitudeOfOrigin: 52.0,
      standardParallel1: 35.0,
      standardParallel2: 65.0,
      falseEasting: 4000000.0,
      falseNorthing: 2800000.0),
  //EPSG 3942, RGF93
  CoordinateFormatKey.LAMBERT93_CC42: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 42.0,
      standardParallel1: 41.25,
      standardParallel2: 42.75,
      falseEasting: 1700000.0,
      falseNorthing: 1200000.0),
  //EPSG 3943, RGF93
  CoordinateFormatKey.LAMBERT93_CC43: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 43.0,
      standardParallel1: 42.25,
      standardParallel2: 43.75,
      falseEasting: 1700000.0,
      falseNorthing: 2200000.0),
  //EPSG 3944, RGF93
  CoordinateFormatKey.LAMBERT93_CC44: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 44.0,
      standardParallel1: 43.25,
      standardParallel2: 44.75,
      falseEasting: 1700000.0,
      falseNorthing: 3200000.0),
  //EPSG 3945, RGF93
  CoordinateFormatKey.LAMBERT93_CC45: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 45.0,
      standardParallel1: 44.25,
      standardParallel2: 45.75,
      falseEasting: 1700000.0,
      falseNorthing: 4200000.0),
  //EPSG 3946, RGF93
  CoordinateFormatKey.LAMBERT93_CC46: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 46.0,
      standardParallel1: 45.25,
      standardParallel2: 46.75,
      falseEasting: 1700000.0,
      falseNorthing: 5200000.0),
  //EPSG 3947, RGF93
  CoordinateFormatKey.LAMBERT93_CC47: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 47.0,
      standardParallel1: 46.25,
      standardParallel2: 47.75,
      falseEasting: 1700000.0,
      falseNorthing: 6200000.0),
  //EPSG 3948, RGF93
  CoordinateFormatKey.LAMBERT93_CC48: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 48.0,
      standardParallel1: 47.25,
      standardParallel2: 48.75,
      falseEasting: 1700000.0,
      falseNorthing: 7200000.0),
  //EPSG 3949, RGF93
  CoordinateFormatKey.LAMBERT93_CC49: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 49.0,
      standardParallel1: 48.25,
      standardParallel2: 49.75,
      falseEasting: 1700000.0,
      falseNorthing: 8200000.0),
  //EPSG 3950, RGF93
  CoordinateFormatKey.LAMBERT93_CC50: _LambertDefinition(
      centralMeridian: 3.0,
      latitudeOfOrigin: 50.0,
      standardParallel1: 49.25,
      standardParallel2: 50.75,
      falseEasting: 1700000.0,
      falseNorthing: 9200000.0),
};

// https://sourceforge.net/p/geographiclib/discussion/1026621/thread/87c3cb91af/
// https://sourceforge.net/p/geographiclib/code/ci/release/tree/examples/example-LambertConformalConic.cpp#l36

LambertCoordinate _latLonToLambert(LatLng latLon, CoordinateFormatKey subtype, Ellipsoid ellipsoid) {
  if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtype)) {
    subtype = defaultLambertType;
  }

  _LambertDefinition specificLambert = _LambertDefinitions[subtype] ?? _LambertDefinitions[defaultLambertType]!;

  LambertConformalConic lambertCC = _lambertConformalConic(specificLambert, ellipsoid);
  GeographicLibLambert transformation = _transformLambertFalseXY(specificLambert, lambertCC);

  var x0 = transformation.x - specificLambert.falseEasting;
  var y0 = transformation.y - specificLambert.falseNorthing;

  GeographicLibLambert lambert = lambertCC.forward(specificLambert.centralMeridian, latLon.latitude, latLon.longitude);

  return LambertCoordinate(lambert.x - x0, lambert.y - y0, subtype);
}

LatLng _lambertToLatLon(LambertCoordinate lambert, Ellipsoid ellipsoid) {
  _LambertDefinition specificLambert = _LambertDefinitions[lambert.format.subtype]!;

  LambertConformalConic lambertCC = _lambertConformalConic(specificLambert, ellipsoid);
  GeographicLibLambert transformation = _transformLambertFalseXY(specificLambert, lambertCC);

  var x0 = transformation.x - specificLambert.falseEasting;
  var y0 = transformation.y - specificLambert.falseNorthing;

  var x = lambert.easting + x0;
  var y = lambert.northing + y0;

  GeographicLibLambertLatLon latLon = lambertCC.Reverse(specificLambert.centralMeridian, x, y);

  return LatLng(latLon.lat, latLon.lon);
}

GeographicLibLambert _transformLambertFalseXY(_LambertDefinition specificLambert, LambertConformalConic lambertCC) {
  GeographicLibLambert transformation = lambertCC.forward(
      specificLambert.centralMeridian, specificLambert.latitudeOfOrigin, specificLambert.centralMeridian);
  return transformation;
}

LambertConformalConic _lambertConformalConic(_LambertDefinition specificLambert, Ellipsoid ellipsoid) {
  var lambertCC = LambertConformalConic(
      ellipsoid.a,
      ellipsoid.f,
      specificLambert.standardParallel1,
      specificLambert.standardParallel2,
      // k1 "always" 1 if two different standard parallels given
      1.0);

  return lambertCC;
}

LambertCoordinate? _parseLambert(String input, {CoordinateFormatKey subtype = defaultLambertType}) {
  RegExp regExp = RegExp(r'^\s*([\-\d.]+)(\s*,\s*|\s+)([\-\d.]+)\s*$');
  var matches = regExp.allMatches(input);
  String? _eastingString = '';
  String? _northingString = '';

  if (matches.isNotEmpty) {
    var match = matches.elementAt(0);
    _eastingString = match.group(1);
    _northingString = match.group(3);
  }
  if (matches.isEmpty) {
    regExp = RegExp(r'^\s*([Xx]):?\s*([\-\d.]+)(\s*,?\s*)([Yy]):?\s*([\-\d.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.isNotEmpty) {
      var match = matches.elementAt(0);
      _eastingString = match.group(2);
      _northingString = match.group(5);
    }
  }

  if (matches.isEmpty) return null;
  if (_eastingString == null || _northingString == null) {
    return null;
  }

  var _easting = double.tryParse(_eastingString);
  if (_easting == null) return null;

  var _northing = double.tryParse(_northingString);
  if (_northing == null) return null;

  return LambertCoordinate(_easting, _northing, subtype);
}
