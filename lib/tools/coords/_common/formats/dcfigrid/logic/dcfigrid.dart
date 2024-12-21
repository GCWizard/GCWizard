// ported from https://github.com/Viglino/ol-ext/blob/master/src/geom/DFCI.js

import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart' as defaultCoord;
import 'package:latlong2/latlong.dart';

/** Convert coordinate to French DFCI grid
 * @param {ol/coordinate} coord
 * @param {number} level [0-3]
 * @param {ol/proj/Projection} projection of the coord, default EPSG:27572
 * @return {String} the DFCI index
 */
String olCoordinateToDFCI(LatLng coord, int? level, String? projection) {
  level ??= 3;
  // if (projection != null) {
  //   if (Proj4.get('EPSG:27572') == null) {
  //     // Add Lambert IIe proj
  //     if (Proj4.defs["EPSG:27572"] == null) {
  //       Proj4.defs["EPSG:27572"] = "+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
  //     }
  //     coord = Proj4.transform(coord, projection, 'EPSG:27572');
  //   }
  // }
  var lambert = LambertCoordinate.fromLatLon(coord, CoordinateFormatKey.LAMBERT93, defaultCoord.defaultEllipsoid);
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
LatLng olCoordinateFromDFCI(String index, String? projection) {
  List<double>? coord;

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

  // // Convert ?
  // if (projection != null) {
  //   if (!Proj4.getDef('EPSG:27572')) {
  //     // Add Lambert IIe proj
  //     if (Proj4.defs["EPSG:27572"] == null) {
  //       Proj4.defs["EPSG:27572"] = "+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
  //     }
  //     Proj4.register();
  //   }
  //   coord = Proj4.transform(coord!, 'EPSG:27572', projection);
  // }

  return LambertCoordinate(coord[0], coord[1], CoordinateFormatKey.LAMBERT93).toLatLng();
}

/** The string is a valid DFCI index
 * @param {string} index DFCI index
 * @return {boolean}
 */
bool olCoordinateValidDFCI(String index) {
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
bool olCoordinateValidDFCICoord(LatLng coord) {
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

  var lambert = LambertCoordinate.fromLatLon(coord, CoordinateFormatKey.LAMBERT93, defaultCoord.defaultEllipsoid);

  // Test extent
  if (lambert.easting < 0 || lambert.easting > 1200000) return false;
  if (lambert.northing < 1600000 || lambert.northing > 2700000) return false;
  return true;
}