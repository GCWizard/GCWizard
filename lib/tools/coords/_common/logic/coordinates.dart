import 'package:gc_wizard/tools/coords/_common/formats/mapcode/logic/mapcode.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgridplus/logic/swissgridplus.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart' as defaultCoord;
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dutchgrid/logic/dutchgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/gausskrueger/logic/gauss_krueger.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geo3x3/logic/geo3x3.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohash/logic/geohash.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohex/logic/geohex.dart';
import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/formats/maidenhead/logic/maidenhead.dart';
import 'package:gc_wizard/tools/coords/_common/formats/makaney/logic/makaney.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mercator/logic/mercator.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mgrs_utm/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/logic/natural_area_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/openlocationcode/logic/open_location_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/quadtree/logic/quadtree.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_day1976/logic/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/formats/slippymap/logic/slippy_map.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgrid/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/utm/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/xyz/logic/xyz.dart';
import 'package:latlong2/latlong.dart';

import 'coordinate_format_definition.dart';

abstract class BaseCoordinate {
  CoordinateFormat get format;
  late double latitude;
  late double longitude;

  BaseCoordinate([double? latitude, double? longitude]) {
    this.latitude = latitude ?? defaultCoord.defaultCoordinate.latitude;
    this.longitude = longitude ?? defaultCoord.defaultCoordinate.longitude;
  }

  // TODO: Make this null-safe. Some inheriting CoordFormats may return null here. This shall be avoided.
  LatLng? toLatLng() {
    return LatLng(latitude, longitude);
  }

  static BaseCoordinate? parse(String input) {
    return null;
  }

  static BaseCoordinate? parseWholeString(String input) {
    return parse(input);
  }

  @override
  String toString([int? precision]) {
    return LatLng(latitude, longitude).toString();
  }
}

abstract class BaseCoordinateWithSubtypes extends BaseCoordinate {

  CoordinateFormatKey get defaultSubtype;
}

enum HemisphereLatitude { North, South }

enum HemisphereLongitude { East, West }

int getCoordinateSignFromString(String text, bool isLatitude) {
  int _sign = 0;

  if (isLatitude) {
    _sign = (text == 'N') ? 1 : -1;
  } else {
    _sign = (text == 'E') ? 1 : -1;
  }

  return _sign;
}

BaseCoordinate buildUninitializedCoordinateByFormat(CoordinateFormat format) {

  return coordinateFormatDefinitionByKey(format.type).defaultCoordinate;
}

BaseCoordinate buildDefaultCoordinateByCoordinates(LatLng coords) {
  return buildCoordinate(defaultCoord.defaultCoordinateFormat, coords, defaultCoord.defaultEllipsoid);
}

BaseCoordinate buildCoordinate(CoordinateFormat format, LatLng coords, [Ellipsoid? ellipsoid]) {
  if (isCoordinateFormatWithSubtype(format.type)) {
    if (format.subtype == null || !isSubtypeOfCoordinateFormat(format.type, format.subtype!)) {
      format.subtype = defaultCoord.defaultCoordinateFormatSubtypeForFormat(format.type);
    }
  }

  ellipsoid ??= defaultCoord.defaultEllipsoid;

  switch (format.type) {
    case CoordinateFormatKey.DEC:
      return DECCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.DMM:
      return DMMCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.DMS:
      return DMSCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.UTM:
      return UTMREFCoordinate.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.MGRS:
      return MGRSCoordinate.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.XYZ:
      return XYZCoordinate.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.SWISS_GRID:
      return SwissGridCoordinate.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.SWISS_GRID_PLUS:
      return SwissGridPlusCoordinate.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.DUTCH_GRID:
      return DutchGridCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.GAUSS_KRUEGER:
      return GaussKruegerCoordinate.fromLatLon(coords, format.subtype!, ellipsoid);
    case CoordinateFormatKey.LAMBERT:
      return LambertCoordinate.fromLatLon(coords, format.subtype!, ellipsoid);
    case CoordinateFormatKey.MAIDENHEAD:
      return MaidenheadCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.MERCATOR:
      return MercatorCoordinate.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.NATURAL_AREA_CODE:
      return NaturalAreaCodeCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.SLIPPY_MAP:
      return SlippyMapCoordinate.fromLatLon(coords, format.subtype!);
    case CoordinateFormatKey.GEOHASH:
      return GeohashCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.GEO3X3:
      return Geo3x3Coordinate.fromLatLon(coords);
    case CoordinateFormatKey.GEOHEX:
      return GeoHexCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.OPEN_LOCATION_CODE:
      return OpenLocationCodeCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.MAKANEY:
      return MakaneyCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.QUADTREE:
      return QuadtreeCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.REVERSE_WIG_WALDMEISTER:
      return ReverseWherigoWaldmeisterCoordinate.fromLatLon(coords);
    case CoordinateFormatKey.REVERSE_WIG_DAY1976:
      return ReverseWherigoDay1976Coordinate.fromLatLon(coords);
    case CoordinateFormatKey.MAPCODE:
      return MapCode.fromLatLon(coords, format.subtype!);
    default:
      return buildDefaultCoordinateByCoordinates(coords);
  }
}
