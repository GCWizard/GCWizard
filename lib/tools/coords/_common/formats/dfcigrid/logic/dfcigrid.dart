// ported from https://github.com/Viglino/ol-ext/blob/master/src/geom/DFCI.js

import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

const dfciGridKey = 'coords_dfcigrid';

final DfciGridFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.DUTCH_GRID, dfciGridKey, dfciGridKey, DfciGridCoordinate.parse, DfciGridCoordinate(''));

class DfciGridCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.DFCI_GRID);
  String text;

  DfciGridCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _parseDFCI(text);
  }

  static DfciGridCoordinate fromLatLon(LatLng coord) {
    return _latLonToDfciGrid(coord);
  }

  static DfciGridCoordinate? parse(String input) {
    return _parseDfciGrid(input);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

DfciGridCoordinate _latLonToDfciGrid(LatLng coord) {
  var dfciGrid = _validDFCICoord(coord) ? __latLonToDfciGrid(coord, null) : '';
  return DfciGridCoordinate(dfciGrid);
}

DfciGridCoordinate? _parseDfciGrid(String input) {
 var coord = _parseDFCI(input);
 if (coord == null) {
   return null;
 } else {
   var dfci = DfciGridCoordinate(input);
   dfci.latitude = coord.latitude;
   dfci.longitude = coord.longitude;
   return dfci;
 }

}

/** Convert coordinate to French DFCI grid
 * @param {ol/coordinate} coord
 * @param {number} level [0-3]
 * @return {String} the DFCI index
 */
String __latLonToDfciGrid(LatLng coord, int? level) {
  level ??= 3;

  var lambert = LambertCoordinate.fromLatLon(coord, CoordinateFormatKey.LAMBERT_NTF, _dcfiGridEllipsoid());
  var x = lambert.easting; //???
  var y = lambert.northing;  //???
  var s = '';
  // Level 0
  var step = 100000;
  s += String.fromCharCode(65 + ((x < 800000 ? x : x + 200000) / step).floor())
      + String.fromCharCode(65 + ((y < 2300000 ? y : y + 200000) / step).floor() - (1500000 / step).floor());
  if (level == 0) return s;
  // Level 1
  var step1 = 100000 / 5;
  s += (2 * (x % step / step1).floor()).toString();
  s += (2 * (y % step / step1).floor()).toString();
  if (level == 1) return s;
  // Level 2
  var step2 = step1 / 10;
  var x0 = ((x % step1) / step2).floor();
  s += String.fromCharCode(65 + (x0 < 8 ? x0 : x0 + 2));
  s += ((y % step1) / step2).floor().toString();
  if (level == 2) return s;
  // Level 3
  var x3 = ((x % step2) / 500).floor();
  var y3 = ((y % step2) / 500).floor();
  if (x3 < 1) {
    if (y3 > 1) {
      s += '.1';
    } else {
      s += '.4';
    }
  } else if (x3 > 2) {
    if (y3 > 1) {
      s += '.2';
    } else {
      s += '.3';
    }
  } else if (y3 > 2) {
    if (x3 < 2) {
      s += '.1';
    } else {
      s += '.2';
    }
  } else if (y3 < 1) {
    if (x3 < 2) {
      s += '.4';
    } else {
      s += '.3';
    }
  } else {
    s += '.5';
  }
  return s;
}


/** Get coordinate from French DFCI index
 * @param {String} index the DFCI index
 * @param {ol/proj/Projection} projection result projection, default EPSG:27572
 * @return {ol/coordinate} coord
 */
LatLng? _parseDFCI(String index) {
  List<double>? coord;
  if (!_validDFCI(index)) return null;

  // Level 0
  double step = 100000;
  double x = index.codeUnitAt(0) - 65;
  x = (x < 8 ? x : x - 2) * step;
  double y = index.codeUnitAt(1) - 65;
  y = (y < 8 ? y : y - 2) * step + 1500000;

  if (index.length == 2) {
    coord = [x + step / 2, y + step / 2];
  } else {
    // Level 1
    step /= 5;
    x += int.parse(index[2]) / 2 * step;
    y += int.parse(index[3]) / 2 * step;

    if (index.length == 4) {
      coord = [x + step / 2, y + step / 2];
    } else {
      // Level 2
      step /= 10;
      int x0 = index.codeUnitAt(4) - 65;
      x += (x0 < 8 ? x0 : x0 - 2) * step;
      y += int.parse(index[5]) * step;

      if (index.length == 6) {
        coord = [x + step / 2, y + step / 2];
      } else {
        // Level 3
        switch (index[7]) {
          case '1':
            coord = [x + step / 4, y + 3 * step / 4];
            break;
          case '2':
            coord = [x + 3 * step / 4, y + 3 * step / 4];
            break;
          case '3':
            coord = [x + 3 * step / 4, y + step / 4];
            break;
          case '4':
            coord = [x + step / 4, y + step / 4];
            break;
          default:
            coord = [x + step / 2, y + step / 2];
            break;
        }
      }
    }
  }

  return LambertCoordinate(coord[0], coord[1], CoordinateFormatKey.LAMBERT_NTF).toLatLng(ells: _dcfiGridEllipsoid());
}

/** The string is a valid DFCI index
 * @param {string} index DFCI index
 * @return {boolean}
 */
bool _validDFCI(String index) {
  index = index.trim();
  if (index.length < 2 || index.length > 8) return false;
  if (!RegExp(r'^[A-HK-N]').hasMatch(index[0])) return false;
  if (!RegExp(r'^[B-HK-N]').hasMatch(index[1])) return false;
  if (index.length > 2) {
    if (index.length < 4) return false;
    if (!RegExp(r'^[02468]').hasMatch(index[2])) return false;
    if (!RegExp(r'^[02468]').hasMatch(index[3])) return false;
  }
  if (index.length > 4) {
    if (index.length < 6) return false;
    if (!RegExp(r'^[A-HK-L]').hasMatch(index[4])) return false;
    if (!RegExp(r'^[0-9]').hasMatch(index[5])) return false;
  }
  if (index.length > 6) {
    if (index.length < 8) return false;
    if (index[6] != '.') return false;
    if (!RegExp(r'^[1-5]').hasMatch(index[7])) return false;
  }
  return true;
}

/** Coordinate is valid for DFCI
 * @param {ol/coordinate} coord
 * @param {ol/proj/Projection} projection result projection, default EPSG:27572
 * @return {boolean}
 */
bool _validDFCICoord(LatLng coord) {
  // if (projection != null) {
  //   if (!Proj4.getProjection('EPSG:27572')) {
  //     // Add Lambert IIe proj
  //     if (!Proj4.defs.containsKey("EPSG:27572")) {
  //       Proj4.defs["EPSG:27572"] = "+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
  //     }
  //     Proj4.register();
  //   }
  //   coord = Proj4.transform(coord, projection, 'EPSG:27572');
  // }

  var lambert = LambertCoordinate.fromLatLon(coord, CoordinateFormatKey.LAMBERT_NTF, _dcfiGridEllipsoid());

  // Test extent
  if (lambert.easting < 0 || lambert.easting > 1200000) return false;
  if (lambert.northing < 1600000 || lambert.northing > 2700000) return false;
  return true;
}

Ellipsoid _dcfiGridEllipsoid() {
  return getEllipsoidByName('Clarke 1880 IGN')!;
}

class LambertToWGS84 {
  // WGS84 Datum (für geografische Koordinaten)
  static const double a = 6378388.0; // Halbachse des Clarke 1880 (Modifiziert) Ellipsoids
  static const double f = 1 / 297.0; // Abplattung des Clarke 1880 Ellipsoids
  static const double e2 = 2 * f - f * f; // Exzentrizität des Ellipsoids
  static const double pi = 3.1415926535897932;

  // Lambert 72 spezifische Parameter
  static const double lat0 = 49.8333333; // Ursprungslatitude (49°50'N)
  static const double lon0 = 2.3333333; // Ursprungslängengrad (2°20'E)
  static const double x0 = 1550000.0; // Falsch-Easting
  static const double y0 = 5400000.0; // Falsch-Northing

  static const double phi1 = 49.8333333; // 1. Standardparallele (49°50'N)
  static const double phi2 = 51.8333333; // 2. Standardparallele (51°50'N)
  static const double lat0Rad = lat0 * pi / 180.0; // Ursprungslatitude in Bogenmaß
  static const double lon0Rad = lon0 * pi / 180.0; // Ursprungslängengrad in Bogenmaß
  static const double phi1Rad = phi1 * pi / 180.0; // 1. Standardparallele in Bogenmaß
  static const double phi2Rad = phi2 * pi / 180.0; // 2. Standardparallele in Bogenmaß

  static double n = (log(cos(phi1Rad) / tan(phi1Rad)) - log(cos(phi2Rad) / tan(phi2Rad))) /
      (log(tan(pi / 4 + phi1Rad / 2) / tan(pi / 4 + lat0Rad / 2)) - log(tan(pi / 4 + phi2Rad / 2) / tan(pi / 4 + lat0Rad / 2)));

  static double radiusOfCurvature(double lat) {
    return a / sqrt(1 - e2 * sin(lat) * sin(lat));
  }

  static double calculateR(double lat) {
    return radiusOfCurvature(lat) * tan(lat / 2 + pi / 4);
  }

  static List<double> lambertToWGS84(double x, double y) {
    // Berechnung der Transformation
    double deltaX = x - x0;
    double deltaY = y - y0;

    // Umrechnung von Lambert Koordinaten in Breiten- und Längengrad
    double m = calculateR(lat0Rad); // Metrische Grundlage in ursprünglicher Breite
    double t = tan(lat0Rad / 2 + pi / 4);
    double phi = (lat0Rad + (deltaY / m)) * 180.0 / pi;  // Breite in WGS84

    // Rückgabe der geographischen Koordinaten (Latitude, Longitude)
    double lat = phi;
    double lon = lon0 + deltaX / (cos(lat0Rad) * radiusOfCurvature(lat));

    return [lat, lon];
  }
}

// Beispiel für Lambert-Koordinaten (X, Y)
double x = 1550000.0;  // Beispiel X-Koordinate in Lambert 27572
double y = 1400000.0;  // Beispiel Y-Koordinate in Lambert 27572

// Latitude: 50.8503, Longitude: 4.3517