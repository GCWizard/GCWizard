import 'package:gc_wizard/tools/coords/format_converter/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

String formatCoordOutput(LatLng _coords, Map<String, String> _outputFormat, Ellipsoid ells, [int precision]) {
  switch (_outputFormat['format']) {
    case keyCoordsDEC:
      return DEC.fromLatLon(_coords).toString(precision);
    case keyCoordsDMM:
      return DMM.fromLatLon(_coords).toString(precision);
    case keyCoordsDMS:
      return DMS.fromLatLon(_coords).toString(precision);
    case keyCoordsUTM:
      return UTMREF.fromLatLon(_coords, ells).toString();
    case keyCoordsMGRS:
      return MGRS.fromLatLon(_coords, ells).toString();
    case keyCoordsXYZ:
      return XYZ.fromLatLon(_coords, ells).toString();
    case keyCoordsSwissGrid:
      return SwissGrid.fromLatLon(_coords, ells).toString();
    case keyCoordsSwissGridPlus:
      return SwissGridPlus.fromLatLon(_coords, ells).toString();
    case keyCoordsGaussKrueger:
      return GaussKrueger.fromLatLon(_coords, getGkSubTypeCode(_outputFormat['subtype'], defaultValue: 0), ells)
          .toString();
    case keyCoordsLambert:
      return Lambert.fromLatLon(_coords, getLambertType(_outputFormat['subtype'], defaultValue: null), ells).toString();
    case keyCoordsDutchGrid:
      return DutchGrid.fromLatLon(_coords).toString();
    case keyCoordsMaidenhead:
      return Maidenhead.fromLatLon(_coords).toString();
    case keyCoordsMercator:
      return Mercator.fromLatLon(_coords, ells).toString();
    case keyCoordsNaturalAreaCode:
      return NaturalAreaCode.fromLatLon(_coords, precision: 8).toString();
    case keyCoordsSlippyMap:
      return SlippyMap.fromLatLon(_coords, double.tryParse(_outputFormat['subtype'])).toString();
    case keyCoordsGeohash:
      return Geohash.fromLatLon(_coords, 14).toString();
    case keyCoordsGeoHex:
      return GeoHex.fromLatLon(_coords, 20).toString();
    case keyCoordsGeo3x3:
      return Geo3x3.fromLatLon(_coords, 20).toString();
    case keyCoordsOpenLocationCode:
      return OpenLocationCode.fromLatLon(_coords, codeLength: 14).toString();
    case keyCoordsQuadtree:
      return Quadtree.fromLatLon(_coords, precision: 40).toString();
    case keyCoordsMakaney:
      return Makaney.fromLatLon(_coords).toString();
    case keyCoordsReverseWherigoWaldmeister:
      return ReverseWherigoWaldmeister.fromLatLon(_coords).toString();
    case keyCoordsReverseWherigoDay1976:
      return ReverseWherigoDay1976.fromLatLon(_coords).toString();
    default:
      return DEC.fromLatLon(_coords).toString();
  }
}

int coordinateSign(double value) {
  return value == 0 ? 1 : value.sign.floor();
}

bool coordEquals(LatLng coords1, LatLng coords2, {tolerance: 1e-10}) {
  return doubleEquals(coords1.latitude, coords2.latitude) && doubleEquals(coords1.longitude, coords2.longitude);
}

double normalizeBearing(double bearing) {
  return modulo360(bearing);
}

LambertType getLambertType(String subtype, {defaultValue: DefaultLambertType}) {
  switch (subtype) {
    case keyCoordsLambert93:
      return LambertType.LAMBERT_93;
    case keyCoordsLambert2008:
      return LambertType.LAMBERT_2008;
    case keyCoordsLambertETRS89LCC:
      return LambertType.ETRS89_LCC;
    case keyCoordsLambert72:
      return LambertType.LAMBERT_72;
    case keyCoordsLambert93CC42:
      return LambertType.L93_CC42;
    case keyCoordsLambert93CC43:
      return LambertType.L93_CC43;
    case keyCoordsLambert93CC44:
      return LambertType.L93_CC44;
    case keyCoordsLambert93CC45:
      return LambertType.L93_CC45;
    case keyCoordsLambert93CC46:
      return LambertType.L93_CC46;
    case keyCoordsLambert93CC47:
      return LambertType.L93_CC47;
    case keyCoordsLambert93CC48:
      return LambertType.L93_CC48;
    case keyCoordsLambert93CC49:
      return LambertType.L93_CC49;
    case keyCoordsLambert93CC50:
      return LambertType.L93_CC50;
    default:
      return defaultValue;
  }
}

String getLambertKey({LambertType lambertType: DefaultLambertType}) {
  switch (lambertType) {
    case LambertType.LAMBERT_93:
      return keyCoordsLambert93;
    case LambertType.LAMBERT_2008:
      return keyCoordsLambert2008;
    case LambertType.ETRS89_LCC:
      return keyCoordsLambertETRS89LCC;
    case LambertType.LAMBERT_72:
      return keyCoordsLambert72;
    case LambertType.L93_CC42:
      return keyCoordsLambert93CC42;
    case LambertType.L93_CC43:
      return keyCoordsLambert93CC43;
    case LambertType.L93_CC44:
      return keyCoordsLambert93CC44;
    case LambertType.L93_CC45:
      return keyCoordsLambert93CC45;
    case LambertType.L93_CC46:
      return keyCoordsLambert93CC46;
    case LambertType.L93_CC47:
      return keyCoordsLambert93CC47;
    case LambertType.L93_CC48:
      return keyCoordsLambert93CC48;
    case LambertType.L93_CC49:
      return keyCoordsLambert93CC49;
    case LambertType.L93_CC50:
      return keyCoordsLambert93CC50;
  }
}

int getGkSubTypeCode(String subtype, {defaultValue: DefaultGaussKruegerType}) {
  switch (subtype) {
    case keyCoordsGaussKruegerGK1:
      return 1;
    case keyCoordsGaussKruegerGK2:
      return 2;
    case keyCoordsGaussKruegerGK3:
      return 3;
    case keyCoordsGaussKruegerGK4:
      return 4;
    case keyCoordsGaussKruegerGK5:
      return 5;
    default:
      return DefaultGaussKruegerType;
  }
}

String getGaussKruegerTypKey({int subtype: DefaultGaussKruegerType}) {
  switch (subtype) {
    case 1:
      return keyCoordsGaussKruegerGK1;
    case 2:
      return keyCoordsGaussKruegerGK2;
    case 3:
      return keyCoordsGaussKruegerGK3;
    case 4:
      return keyCoordsGaussKruegerGK4;
    case 5:
      return keyCoordsGaussKruegerGK5;
    default:
      return getGaussKruegerTypKey();
  }
}