import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/ellipsoid_transform/logic/ellipsoid_transform.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:latlong2/latlong.dart';

const Map<int, CoordinateFormatKey> GAUSS_KRUEGER_CODE = {
  1: CoordinateFormatKey.GAUSS_KRUEGER_GK1,
  2: CoordinateFormatKey.GAUSS_KRUEGER_GK2,
  3: CoordinateFormatKey.GAUSS_KRUEGER_GK3,
  4: CoordinateFormatKey.GAUSS_KRUEGER_GK4,
  5: CoordinateFormatKey.GAUSS_KRUEGER_GK5,
};

const defaultGaussKruegerType = CoordinateFormatKey.GAUSS_KRUEGER_GK1;
const gausKruegerKey = 'coords_gausskrueger';
final _defaultCoordinate = GaussKruegerCoordinate(0, 0, defaultGaussKruegerType);

final GaussKruegerFormatDefinition = CoordinateFormatWithSubtypesDefinition(
    CoordinateFormatKey.GAUSS_KRUEGER,
    gausKruegerKey,
    gausKruegerKey,
    [
      CoordinateFormatDefinition(CoordinateFormatKey.GAUSS_KRUEGER_GK1, 'coords_gausskrueger_gk1',
          'coords_gausskrueger_gk1', GaussKruegerCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.GAUSS_KRUEGER_GK2, 'coords_gausskrueger_gk2',
          'coords_gausskrueger_gk2', GaussKruegerCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.GAUSS_KRUEGER_GK3, 'coords_gausskrueger_gk3',
          'coords_gausskrueger_gk3', GaussKruegerCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.GAUSS_KRUEGER_GK4, 'coords_gausskrueger_gk4',
          'coords_gausskrueger_gk4', GaussKruegerCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.GAUSS_KRUEGER_GK5, 'coords_gausskrueger_gk5',
          'coords_gausskrueger_gk5', GaussKruegerCoordinate.parse, _defaultCoordinate),
    ],
    GaussKruegerCoordinate.parse,
    _defaultCoordinate);

class GaussKruegerCoordinate extends BaseCoordinateWithSubtypes {
  late CoordinateFormat _format;
  @override
  CoordinateFormat get format => _format;
  double easting;
  double northing;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid GaussKrueger subtype given.';

  GaussKruegerCoordinate(this.easting, this.northing, CoordinateFormatKey subtypeKey) {
    if (subtypeKey != defaultGaussKruegerType &&
        !isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtypeKey);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return _gaussKruegerToLatLon(this, ells);
  }

  static GaussKruegerCoordinate fromLatLon(LatLng coord, CoordinateFormatKey subtype, Ellipsoid ells) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _latLonToGaussKrueger(coord, subtype, ells);
  }

  static GaussKruegerCoordinate? parse(String input, {CoordinateFormatKey subtype = defaultGaussKruegerType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _parseGaussKrueger(input, gaussKruegerCode: subtype);
  }

  @override
  CoordinateFormatKey get defaultSubtype => defaultGaussKruegerType;

  @override
  String toString([int? precision]) {
    return 'R: $easting\nH: $northing';
  }
}

GaussKruegerCoordinate _latLonToGaussKrueger(LatLng coord, CoordinateFormatKey subtype, Ellipsoid ells) {
  if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtype)) {
    subtype = defaultGaussKruegerType;
  }

  int x = -1;
  switch (ells.name) {
    case ELLIPSOID_NAME_AIRY1830:
      x = 6;
      break;
    case ELLIPSOID_NAME_AIRYMODIFIED:
      x = 7;
      break;
    case ELLIPSOID_NAME_BESSEL1841:
      x = 0;
      break;
    case ELLIPSOID_NAME_CLARKE1866:
      x = 9;
      break;
    case ELLIPSOID_NAME_HAYFORD1924:
      x = 8;
      break;
    case ELLIPSOID_NAME_KRASOVSKY1940:
      x = 2;
      break;
  }

  LatLng newCoord;
  if (x >= 0) {
    newCoord = ellipsoidTransformLatLng(coord, x, false, false);
  }

  int gkno = switchMapKeyValue(GAUSS_KRUEGER_CODE)[subtype]!;
  newCoord = ellipsoidTransformLatLng(coord, gkno - 1, true, true);

  Ellipsoid ellsBessel = getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841)!;
  double a = ellsBessel.a;
  double b = ellsBessel.b;
  double e2 = ellsBessel.e2;

  double L = newCoord.longitude;
  int L0 = 15;
  for (int i = 6; i <= 12; i = i + 3) {
    if ((L - i).abs() < 1.5) {
      L0 = i;
      break;
    }
  }

  double B = newCoord.latitudeInRad;
  double l = degToRadian(L - L0);
  double N = a / sqrt(1 - e2 * sin(B) * sin(B));
  double _n = sqrt(a * a / (b * b) * e2 * cos(B) * cos(B));
  double t = tan(B);

  double n = (a - b) / (a + b);
  double _a = (a + b) / 2.0 * (1.0 + 1.0 / 4.0 * n * n + 1.0 / 64.0 * pow(n, 4));
  double _b = -3.0 / 2.0 * n + 9.0 / 16.0 * n * n * n - 3.0 / 32.0 * pow(n, 5);
  double _c = 15.0 / 16.0 * n * n - 15.0 / 32.0 * pow(n, 4);
  double _d = -35.0 / 48.0 * n * n * n + 105.0 / 256.0 * pow(n, 5);
  double _e = 315.0 / 512.0 * pow(n, 4);

  double BL = _a * (B + _b * sin(2 * B) + _c * sin(4 * B) + _d * sin(6 * B) + _e * sin(8 * B));
  double p1 = t / 2.0 * N * cos(B) * cos(B) * l * l;
  double q1 = t / 24.0 * N * pow(cos(B), 4) * (5 - t * t + 9 * _n * _n + 4 * pow(_n, 4)) * pow(l, 4);

  double H = BL + p1 + q1;

  double p2 = N * cos(B) * l;
  double q2 = N / 6.0 * pow(cos(B), 3) * (1 - t * t + _n * _n) * l * l * l;

  double R = p2 + q2 + 500000 + L0 / 3.0 * 1000000;

  return GaussKruegerCoordinate(R, H, subtype);
}

LatLng _gaussKruegerToLatLon(GaussKruegerCoordinate gaussKrueger, Ellipsoid ells) {
  Ellipsoid ellsBessel = getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841)!;

  var R = gaussKrueger.easting;
  var H = gaussKrueger.northing;

  double a = ellsBessel.a;
  double b = ellsBessel.b;
  double e2 = ellsBessel.e2;

  double n = (a - b) / (a + b);
  double _a = (a + b) / 2.0 * (1 + 1.0 / 4.0 * n * n + 1.0 / 64.0 * pow(n, 4));
  double _b = 3.0 / 2.0 * n - 27.0 / 32.0 * n * n * n - 269.0 / 512.0 * pow(n, 5);
  double _c = 21.0 / 16.0 * n * n - 55.0 / 32.0 * pow(n, 4);
  double _d = 151.0 / 96.0 * n * n * n - 417.0 / 128.0 * pow(n, 5);
  double _e = 1097.0 / 512.0 * pow(n, 4);
  int y0 = (R / 1000000.0).floor();
  int L0 = (R / 1000000.0).floor() * 3;
  double Y = R - y0 * 1000000 - 500000;

  double B0 = H / _a;
  double BF = B0 + _b * sin(2 * B0) + _c * sin(4 * B0) + _d * sin(6 * B0) + _e * (8 * B0);

  double NF = a / sqrt(1 - e2 * sin(BF) * sin(BF));
  double _nF = sqrt(a * a / (b * b) * e2 * cos(BF) * cos(BF));
  double tF = tan(BF);

  double B1 = tF / 2.0 / (NF * NF) * (-1 - (_nF * _nF)) * Y * Y;
  double B2 = tF /
      24.0 /
      pow(NF, 4) *
      (5 + 3 * tF * tF + 6 * _nF * _nF - 6 * tF * tF * _nF * _nF - 4 * pow(_nF, 4) - 9 * tF * tF * pow(_nF, 4)) *
      pow(Y, 4);
  double B = radianToDeg(BF + B1 + B2);

  double L1 = 1.0 / NF / cos(BF) * Y;
  double L2 = 1.0 / 6.0 / pow(NF, 3) / cos(BF) * (-1 - 2 * tF * tF - _nF * _nF) * Y * Y * Y;
  double L = L0 + radianToDeg(L1 + L2);

  LatLng coord = LatLng(B, L);

  int x = -1;

  switch (ells.name) {
    case ELLIPSOID_NAME_AIRY1830:
      x = 6;
      break;
    case ELLIPSOID_NAME_AIRYMODIFIED:
      x = 7;
      break;
    case ELLIPSOID_NAME_BESSEL1841:
      x = 0;
      break;
    case ELLIPSOID_NAME_CLARKE1866:
      x = 9;
      break;
    case ELLIPSOID_NAME_HAYFORD1924:
      x = 8;
      break;
    case ELLIPSOID_NAME_KRASOVSKY1940:
      x = 2;
      break;
  }

  int gkno = switchMapKeyValue(GAUSS_KRUEGER_CODE)[gaussKrueger.format.subtype]!;
  coord = ellipsoidTransformLatLng(coord, gkno - 1, false, true);
  if (x >= 0) coord = ellipsoidTransformLatLng(coord, x, true, false);

  return coord;
}

GaussKruegerCoordinate? _parseGaussKrueger(String input,
    {CoordinateFormatKey gaussKruegerCode = defaultGaussKruegerType}) {
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
    regExp = RegExp(r'^\s*([RrXx]):?\s*([\-\d.]+)(\s*,?\s*)([HhYy]):?\s*([\-\d.]+)\s*$');
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

  return GaussKruegerCoordinate(_easting, _northing, gaussKruegerCode);
}
