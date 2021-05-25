import 'package:gc_wizard/logic/tools/coords/converter/dec.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dmm.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dms.dart';
import 'package:gc_wizard/logic/tools/coords/converter/gauss_krueger.dart';
import 'package:gc_wizard/logic/tools/coords/converter/geo3x3.dart';
import 'package:gc_wizard/logic/tools/coords/converter/geohash.dart';
import 'package:gc_wizard/logic/tools/coords/converter/geohex.dart';
import 'package:gc_wizard/logic/tools/coords/converter/maidenhead.dart';
import 'package:gc_wizard/logic/tools/coords/converter/mercator.dart';
import 'package:gc_wizard/logic/tools/coords/converter/mgrs.dart';
import 'package:gc_wizard/logic/tools/coords/converter/natural_area_code.dart';
import 'package:gc_wizard/logic/tools/coords/converter/open_location_code.dart';
import 'package:gc_wizard/logic/tools/coords/converter/quadtree.dart';
import 'package:gc_wizard/logic/tools/coords/converter/reverse_whereigo_waldmeister.dart';
import 'package:gc_wizard/logic/tools/coords/converter/slippy_map.dart';
import 'package:gc_wizard/logic/tools/coords/converter/swissgrid.dart';
import 'package:gc_wizard/logic/tools/coords/converter/utm.dart';
import 'package:gc_wizard/logic/tools/coords/converter/xyz.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:latlong/latlong.dart';

double mod(double x, double y) {
  return x - y * (x / y).floor();
}

double modLon(double x) {
  x = mod(x, 360);

  if (x > 180) x -= 360;

  return x;
}

String formatCoordOutput(LatLng _coords, Map<String, String> _outputFormat, Ellipsoid ells, [int precision]) {
  int _getGKCode() {
    switch (_outputFormat['subtype']) {
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
        return 0;
    }
  }

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
      return GaussKrueger.fromLatLon(_coords, _getGKCode(), ells).toString();
    case keyCoordsMaidenhead:
      return Maidenhead.fromLatLon(_coords).toString();
    case keyCoordsMercator:
      return Mercator.fromLatLon(_coords, ells).toString();
    case keyCoordsNaturalAreaCode:
      return NaturalAreaCode.fromLatLon(_coords).toString();
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
      return Quadtree.fromLatLon(_coords).toString();
    case keyCoordsReverseWhereIGoWaldmeister:
      return Waldmeister.fromLatLon(_coords).toString();
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
  return modulo(bearing, 360.0);
}
