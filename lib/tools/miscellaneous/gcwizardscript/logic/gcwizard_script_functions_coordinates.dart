part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

String _wgs84(Object x, Object y) {
  if (_isNotANumber(x) || _isNotANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  var coord = LatLng(x as double, y as double);
  return coord.latitude.toString() + ' ' + coord.longitude.toString();
}

double _getLon() {
  return _state.GCWizardScript_LON;
}

double _getLat() {
  return _state.GCWizardScript_LAT;
}

void _setLon(Object x) {
  if (_isNotANumber(x)) {
    _handleError(_INVALIDTYPECAST);
  }
  if ((x as num).abs() > 180) {
    _handleError(_INVALIDLONGITUDE);
    _state.GCWizardScript_LON = x as double;
  } else {
    _state.GCWizardScript_LON = x as double;
  }
}

void _setLat(Object x) {
  if (_isNotANumber(x)) {
    _handleError(_INVALIDTYPECAST);
  }
  if ((x as num).abs() > 90) {
    _handleError(_INVALIDLATITUDE);
    _state.GCWizardScript_LAT = 0;
  } else {
    _state.GCWizardScript_LAT = x as double;
  }
}

_GCWList _convertTo(Object target) {
  if (_isNotAInt(target)) {
    _handleError(_INVALIDTYPECAST);
  }

  LatLng coord = LatLng(_getLat(), _getLon());

  if (_GCW_SCRIPT_COORD_CONVERTER[target as int] == null) {
    _handleError(_INVALIDCOORDINATEFORMAT);
  }

  _GCWList targetData = _GCWList();

  switch (target) {
    case _COORD_DMM: //= 1;
      DMMCoordinate result = DMMCoordinate.fromLatLon(coord);

      _listAdd(
          targetData,
          _latSign(result.dmmLatitude.sign) +
              ' ' +
              result.dmmLatitude.degrees.toString() +
              '° ' +
              result.dmmLatitude.minutes.toStringAsFixed(3) +
              "' " +
              _latSign(result.dmmLongitude.sign) +
              ' ' +
              result.dmmLongitude.degrees.toString() +
              '° ' +
              result.dmmLatitude.minutes.toStringAsFixed(3) +
              "'");
      _listAdd(
          targetData,
          _latSign(result.dmmLatitude.sign) +
              ' ' +
              result.dmmLatitude.degrees.toString() +
              '° ' +
              result.dmmLatitude.minutes.toStringAsFixed(3) +
              "'");
      _listAdd(targetData, _latSign(result.dmmLatitude.sign));
      _listAdd(targetData, result.dmmLatitude.degrees);
      _listAdd(targetData, result.dmmLatitude.minutes);
      _listAdd(
          targetData,
          _lonSign(result.dmmLongitude.sign) +
              ' ' +
              result.dmmLongitude.degrees.toString() +
              '° ' +
              result.dmmLongitude.minutes.toStringAsFixed(3) +
              "'");
      _listAdd(targetData, _lonSign(result.dmmLongitude.sign));
      _listAdd(targetData, result.dmmLongitude.degrees);
      _listAdd(targetData, result.dmmLongitude.minutes);
      break;

    case _COORD_DMS: //= 2;
      DMSCoordinate result = DMSCoordinate.fromLatLon(coord);

      _listAdd(
          targetData,
          _latSign(result.dmsLatitude.sign) +
              ' ' +
              result.dmsLatitude.degrees.toString() +
              '° ' +
              result.dmsLatitude.minutes.toStringAsFixed(3) +
              "' " +
              result.dmsLatitude.seconds.toStringAsFixed(3) +
              _latSign(result.dmsLongitude.sign) +
              ' ' +
              result.dmsLongitude.degrees.toString() +
              '° ' +
              result.dmsLatitude.minutes.toStringAsFixed(3) +
              "' " +
              result.dmsLongitude.seconds.toStringAsFixed(3) +
              '"');
      _listAdd(
          targetData,
          _latSign(result.dmsLatitude.sign) +
              ' ' +
              result.dmsLatitude.degrees.toString() +
              '° ' +
              result.dmsLatitude.minutes.toStringAsFixed(3) +
              "' " +
              result.dmsLatitude.seconds.toStringAsFixed(3) +
              '"');
      _listAdd(targetData, _latSign(result.dmsLatitude.sign));
      _listAdd(targetData, result.dmsLatitude.degrees);
      _listAdd(targetData, result.dmsLatitude.minutes);
      _listAdd(targetData, result.dmsLatitude.seconds);
      _listAdd(
          targetData,
          _lonSign(result.dmsLongitude.sign) +
              ' ' +
              result.dmsLongitude.degrees.toString() +
              '° ' +
              result.dmsLongitude.minutes.toStringAsFixed(3) +
              "' " +
              result.dmsLongitude.seconds.toStringAsFixed(3) +
              '"');
      _listAdd(targetData, _lonSign(result.dmsLongitude.sign));
      _listAdd(targetData, result.dmsLongitude.degrees);
      _listAdd(targetData, result.dmsLongitude.minutes);
      _listAdd(targetData, result.dmsLongitude.seconds);
      break;

    case _COORD_UTM: //= 3;
      UTMREFCoordinate result = UTMREFCoordinate.fromLatLon(coord, Ellipsoid.WGS84);
      _listAdd(
          targetData,
          result.zone.lonZoneRegular.toString() +
              result.zone.latZone +
              ' ' +
              result.easting.toString() +
              ' ' +
              result.northing.toString());
      _listAdd(targetData, result.zone.lonZoneRegular);
      _listAdd(targetData, result.zone.latZone);
      _listAdd(targetData, result.easting);
      _listAdd(targetData, result.northing);
      break;

    case _COORD_MGRS: //= 4;
      MGRSCoordinate result = MGRSCoordinate.fromLatLon(coord, Ellipsoid.WGS84);
      _listAdd(
          targetData,
          result.utmZone.lonZoneRegular.toString() +
              result.utmZone.latZone +
              ' ' +
              result.digraph +
              ' ' +
              result.easting.toString() +
              ' ' +
              result.northing.toString());
      _listAdd(targetData, result.utmZone.lonZoneRegular);
      _listAdd(targetData, result.utmZone.latZone);
      _listAdd(targetData, result.digraph);
      _listAdd(targetData, result.easting);
      _listAdd(targetData, result.northing);
      break;

    case _COORD_XYZ: //= 5;
      XYZCoordinate result = XYZCoordinate.fromLatLon(coord, Ellipsoid.WGS84);
      _listAdd(targetData, 'X: ' + result.x.toString() + '\nY: ' + result.y.toString() + '\nZ: ' + result.z.toString());
      _listAdd(targetData, result.x);
      _listAdd(targetData, result.y);
      _listAdd(targetData, result.z);
      break;

    case _COORD_SWISS_GRID: //= 6;
    case _COORD_SWISS_GRID_PLUS: //= 7;
      SwissGridCoordinate result = SwissGridCoordinate.fromLatLon(coord, Ellipsoid.WGS84);
      _listAdd(targetData, result.easting.toString() + ' ' + result.northing.toString());
      _listAdd(targetData, result.easting);
      _listAdd(targetData, result.northing);
      break;

    case _COORD_DUTCH_GRID: //= 8;
      DutchGridCoordinate result = DutchGridCoordinate.fromLatLon(coord);
      _listAdd(targetData, 'X: ' + result.x.toString() + '\nY: ' + result.y.toString());
      _listAdd(targetData, result.x);
      _listAdd(targetData, result.y);
      break;

    case _COORD_GAUSS_KRUEGER_GK1: //= 901;
    case _COORD_GAUSS_KRUEGER_GK2: //= 902;
    case _COORD_GAUSS_KRUEGER_GK3: //= 903;
    case _COORD_GAUSS_KRUEGER_GK4: //= 904;
    case _COORD_GAUSS_KRUEGER_GK5: //= 905;
      GaussKruegerCoordinate result =
          GaussKruegerCoordinate.fromLatLon(coord, _GCW_SCRIPT_COORD_CONVERTER[target]!, Ellipsoid.WGS84);
      _listAdd(targetData, result.easting.toString() + ' ' + result.northing.toString());
      _listAdd(targetData, result.easting);
      _listAdd(targetData, result.northing);
      break;

    case _COORD_LAMBERT2008: //= 1008;
    case _COORD_LAMBERT93: //= 1093;
    case _COORD_ETRS89LCC: //= 1089;
    case _COORD_LAMBERT72: //= 1072;
    case _COORD_LAMBERT93_CC42: //= 1042;
    case _COORD_LAMBERT93_CC43: //= 1043;
    case _COORD_LAMBERT93_CC44: //= 1044;
    case _COORD_LAMBERT93_CC45: //= 1045;
    case _COORD_LAMBERT93_CC46: //= 1046;
    case _COORD_LAMBERT93_CC47: //= 1047;
    case _COORD_LAMBERT93_CC48: //= 1048;
    case _COORD_LAMBERT93_CC49: //= 1049;
    case _COORD_LAMBERT93_CC50: //= 1050;
      LambertCoordinate result =
          LambertCoordinate.fromLatLon(coord, _GCW_SCRIPT_COORD_CONVERTER[target]!, Ellipsoid.WGS84);
      _listAdd(targetData, result.easting.toString() + ' ' + result.northing.toString());
      _listAdd(targetData, result.easting);
      _listAdd(targetData, result.northing);
      break;

    case _COORD_MAIDENHEAD: //= 11;
      MaidenheadCoordinate result = MaidenheadCoordinate.fromLatLon(coord);
      _listAdd(targetData, result.text);
      break;

    case _COORD_MERCATOR: //= 12;
      MercatorCoordinate result = MercatorCoordinate.fromLatLon(coord, Ellipsoid.WGS84);
      _listAdd(targetData, result.easting.toString() + result.northing.toString());
      _listAdd(targetData, result.easting);
      _listAdd(targetData, result.northing);
      break;

    case _COORD_NATURAL_AREA_CODE: //= 13;
      NaturalAreaCodeCoordinate result = NaturalAreaCodeCoordinate.fromLatLon(coord);
      _listAdd(targetData, 'X: ' + result.x.toString() + '\nY: ' + result.y.toString());
      _listAdd(targetData, result.x);
      _listAdd(targetData, result.y);
      break;

    case _COORD_SLIPPYMAP_0: //= 1400;
    case _COORD_SLIPPYMAP_1: //= 1401;
    case _COORD_SLIPPYMAP_2: //= 1402;
    case _COORD_SLIPPYMAP_3: //= 1403;
    case _COORD_SLIPPYMAP_4: //= 1404;
    case _COORD_SLIPPYMAP_5: //= 1405;
    case _COORD_SLIPPYMAP_6: //= 1406;
    case _COORD_SLIPPYMAP_7: //= 1407;
    case _COORD_SLIPPYMAP_8: //= 1408;
    case _COORD_SLIPPYMAP_9: //= 1409;
    case _COORD_SLIPPYMAP_10: //= 1410;
    case _COORD_SLIPPYMAP_11: //= 1411;
    case _COORD_SLIPPYMAP_12: //= 1412;
    case _COORD_SLIPPYMAP_13: //= 1413;
    case _COORD_SLIPPYMAP_14: //= 1414;
    case _COORD_SLIPPYMAP_15: //= 1415;
    case _COORD_SLIPPYMAP_16: //= 1416;
    case _COORD_SLIPPYMAP_17: //= 1417;
    case _COORD_SLIPPYMAP_18: //= 1418;
    case _COORD_SLIPPYMAP_19: //= 1419;
    case _COORD_SLIPPYMAP_20: //= 1420;
    case _COORD_SLIPPYMAP_21: //= 1421;
    case _COORD_SLIPPYMAP_22: //= 1422;
    case _COORD_SLIPPYMAP_23: //= 1423;
    case _COORD_SLIPPYMAP_24: //= 1424;
    case _COORD_SLIPPYMAP_25: //= 1425;
    case _COORD_SLIPPYMAP_26: //= 1426;
    case _COORD_SLIPPYMAP_27: //= 1427;
    case _COORD_SLIPPYMAP_28: //= 1428;
    case _COORD_SLIPPYMAP_29: //= 1429;
    case _COORD_SLIPPYMAP_30: //= 1430;
      SlippyMapCoordinate result = SlippyMapCoordinate.fromLatLon(coord, _GCW_SCRIPT_COORD_CONVERTER[target]!);
      _listAdd(targetData, result.x.toString() + ' ' + result.y.toString());
      _listAdd(targetData, result.x);
      _listAdd(targetData, result.y);
      break;

    case _COORD_GEOHASH: //= 15;
      GeohashCoordinate result = GeohashCoordinate.fromLatLon(coord, 14);
      _listAdd(targetData, result.text);
      break;

    case _COORD_GEO3X3: //= 16;
      Geo3x3Coordinate result = Geo3x3Coordinate.fromLatLon(coord, 20);
      _listAdd(targetData, result.text);
      break;

    case _COORD_GEOHEX: //= 17;
      GeoHexCoordinate result = GeoHexCoordinate.fromLatLon(coord, 20);
      _listAdd(targetData, result.text);
      break;

    case _COORD_OPEN_LOCATION_CODE: //= 18;
      OpenLocationCodeCoordinate result = OpenLocationCodeCoordinate.fromLatLon(coord);
      _listAdd(targetData, result.text);
      break;

    case _COORD_MAKANEY: //= 19;
      MakaneyCoordinate result = MakaneyCoordinate.fromLatLon(coord);
      _listAdd(targetData, result.text);
      break;

    case _COORD_QUADTREE: //= 20;
      QuadtreeCoordinate result = QuadtreeCoordinate.fromLatLon(coord);
      _listAdd(targetData, result.coords.join(' '));
      break;

    case _COORD_REVERSE_WIG_WALDMEISTER: //= 21;
      ReverseWherigoWaldmeisterCoordinate result = ReverseWherigoWaldmeisterCoordinate.fromLatLon(coord);
      _listAdd(targetData, result.a.toString() + ' ' + result.b.toString() + ' ' + result.c.toString());
      _listAdd(targetData, result.a);
      _listAdd(targetData, result.b);
      _listAdd(targetData, result.c);
      break;

    case _COORD_REVERSE_WIG_DAY1976: //= 22;
      ReverseWherigoDay1976Coordinate result = ReverseWherigoDay1976Coordinate.fromLatLon(coord);
      _listAdd(targetData, result.s.toString() + ' ' + result.t.toString());
      _listAdd(targetData, result.s);
      _listAdd(targetData, result.t);
      break;

    case _COORD_MAPCODE_LOCAL: // 2301
    case _COORD_MAPCODE_INTERNATIONAL: // 2302
      MapCode result = MapCode.fromLatLon(coord, _GCW_SCRIPT_COORD_CONVERTER[target]!);
      _listAdd(
          targetData,
          result.coords[0].mapcode +
              ' ' +
              result.coords[0].territoryAlphaCode +
              ' ' +
              result.coords[0].fullmapcode +
              ' ' +
              result.coords[0].territoryNumber.toString());
      _listAdd(targetData, result.coords[0].mapcode);
      _listAdd(targetData, result.coords[0].territoryAlphaCode);
      _listAdd(targetData, result.coords[0].fullmapcode);
      _listAdd(targetData, result.coords[0].territoryNumber.toString());
      break;

    default:
      _handleError(_INVALIDCOORDINATEFORMAT);
  }

  return targetData;
}

void _convertFrom(Object source, _GCWList parameter) {
  if (_isNotANumber(source)) {
    _handleError(_INVALIDTYPECAST);
  }
  late LatLng? coord;
  late Object parameter_1;
  late Object parameter_2;
  late Object parameter_3;
  late Object parameter_4;
  late Object parameter_5;
  late Object parameter_6;
  late Object parameter_7;
  late Object parameter_8;

  switch (source as num) {
    case _COORD_DMM: //= 1;
      if (_listLength(parameter) != 6) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if ((parameter_1 as String).toUpperCase() == 'N') {
        parameter_1 = 1;
      } else {
        parameter_1 = -1;
      }
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      parameter_4 = _listGet(parameter, 3)!;
      if ((parameter_4 as String).toUpperCase() == 'E') {
        parameter_4 = 1;
      } else {
        parameter_4 = -1;
      }
      parameter_5 = _listGet(parameter, 4)!;
      parameter_6 = _listGet(parameter, 5)!;
      if (_isNotAString(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_3)) _handleError(_INVALIDTYPECAST);
      if (_isNotAString(parameter_4)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_5)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_6)) _handleError(_INVALIDTYPECAST);
      DMMCoordinate result = DMMCoordinate(
        DMMLatitude(parameter_1 as int, parameter_2 as int, parameter_3 as double),
        DMMLongitude(parameter_4 as int, parameter_5 as int, parameter_6 as double),
      );
      coord = result.toLatLng();
      break;

    case _COORD_DMS: //= 2;
      if (_listLength(parameter) != 8) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if ((parameter_1 as String).toUpperCase() == 'N') {
        parameter_1 = 1;
      } else {
        parameter_1 = -1;
      }
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      parameter_4 = _listGet(parameter, 3)!;
      parameter_5 = _listGet(parameter, 4)!;
      if ((parameter_5 as String).toUpperCase() == 'E') {
        parameter_5 = 1;
      } else {
        parameter_5 = -1;
      }
      parameter_6 = _listGet(parameter, 5)!;
      parameter_7 = _listGet(parameter, 6)!;
      parameter_8 = _listGet(parameter, 7)!;
      if (_isNotAString(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_3)) _handleError(_INVALIDTYPECAST);
      if (_isNotAString(parameter_4)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_5)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_6)) _handleError(_INVALIDTYPECAST);
      DMSCoordinate result = DMSCoordinate(
        DMSLatitude(parameter_1 as int, parameter_2 as int, parameter_3 as int, parameter_7 as double),
        DMSLongitude(parameter_5 as int, parameter_6 as int, parameter_7 as int, parameter_8 as double),
      );
      coord = result.toLatLng();
      break;

    case _COORD_UTM: //= 3;
      if (_listLength(parameter) != 4) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      parameter_4 = _listGet(parameter, 3)!;
      if (_isNotAInt(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotAString(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_3)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_4)) _handleError(_INVALIDTYPECAST);
      UTMREFCoordinate result = UTMREFCoordinate(UTMZone(parameter_1 as int, parameter_1, parameter_2.toString()),
          parameter_3 as double, parameter_4 as double);
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_MGRS: //= 4;
      if (_listLength(parameter) != 5) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      parameter_4 = _listGet(parameter, 3)!;
      parameter_5 = _listGet(parameter, 4)!;
      if (_isNotAInt(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotAString(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isNotAString(parameter_3)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_4)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_5)) _handleError(_INVALIDTYPECAST);
      MGRSCoordinate result = MGRSCoordinate(UTMZone(parameter_1 as int, parameter_1, parameter_2 as String),
          parameter_3 as String, parameter_4 as double, parameter_5 as double);
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_XYZ: //= 5;
      if (_listLength(parameter) != 3) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_3)) _handleError(_INVALIDTYPECAST);
      XYZCoordinate result = XYZCoordinate(
        parameter_1 as double,
        parameter_2 as double,
        parameter_3 as double,
      );
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_SWISS_GRID: //= 6;
    case _COORD_SWISS_GRID_PLUS: //= 7;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      SwissGridCoordinate result = SwissGridCoordinate(
        parameter_1 as double,
        parameter_2 as double,
      );
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_DUTCH_GRID: //= 8;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      DutchGridCoordinate result = DutchGridCoordinate(
        parameter_1 as double,
        parameter_2 as double,
      );
      coord = result.toLatLng();
      break;

    case _COORD_GAUSS_KRUEGER_GK1: //= 901;
    case _COORD_GAUSS_KRUEGER_GK2: //= 902;
    case _COORD_GAUSS_KRUEGER_GK3: //= 903;
    case _COORD_GAUSS_KRUEGER_GK4: //= 904;
    case _COORD_GAUSS_KRUEGER_GK5: //= 905;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      GaussKruegerCoordinate result =
          GaussKruegerCoordinate(parameter_1 as double, parameter_2 as double, _GCW_SCRIPT_COORD_CONVERTER[source]!);
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_LAMBERT93: //= 1093;
    case _COORD_LAMBERT2008: //= 1008;
    case _COORD_ETRS89LCC: //= 1089;
    case _COORD_LAMBERT72: //= 1072;
    case _COORD_LAMBERT93_CC42: //= 1042;
    case _COORD_LAMBERT93_CC43: //= 1043;
    case _COORD_LAMBERT93_CC44: //= 1044;
    case _COORD_LAMBERT93_CC45: //= 1045;
    case _COORD_LAMBERT93_CC46: //= 1046;
    case _COORD_LAMBERT93_CC47: //= 1047;
    case _COORD_LAMBERT93_CC48: //= 1048;
    case _COORD_LAMBERT93_CC49: //= 1049;
    case _COORD_LAMBERT93_CC50: //= 1050;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      LambertCoordinate result =
          LambertCoordinate(parameter_1 as double, parameter_2 as double, _GCW_SCRIPT_COORD_CONVERTER[source]!);
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_MAIDENHEAD: //= 11;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      MaidenheadCoordinate result = MaidenheadCoordinate(parameter_1 as String);
      coord = result.toLatLng();
      break;

    case _COORD_MERCATOR: //= 12;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      MercatorCoordinate result = MercatorCoordinate(
        parameter_1 as double,
        parameter_2 as double,
      );
      coord = result.toLatLng(ells: Ellipsoid.WGS84);
      break;

    case _COORD_NATURAL_AREA_CODE: //= 13;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isAList(parameter_2)) _handleError(_INVALIDTYPECAST);
      NaturalAreaCodeCoordinate result = NaturalAreaCodeCoordinate(
        parameter_1 as String,
        parameter_2 as String,
      );
      coord = result.toLatLng();
      break;

    case _COORD_SLIPPYMAP_0: //= 1400;
    case _COORD_SLIPPYMAP_1: //= 1401;
    case _COORD_SLIPPYMAP_2: //= 1402;
    case _COORD_SLIPPYMAP_3: //= 1403;
    case _COORD_SLIPPYMAP_4: //= 1404;
    case _COORD_SLIPPYMAP_5: //= 1405;
    case _COORD_SLIPPYMAP_6: //= 1406;
    case _COORD_SLIPPYMAP_7: //= 1407;
    case _COORD_SLIPPYMAP_8: //= 1408;
    case _COORD_SLIPPYMAP_9: //= 1409;
    case _COORD_SLIPPYMAP_10: //= 1410;
    case _COORD_SLIPPYMAP_11: //= 1411;
    case _COORD_SLIPPYMAP_12: //= 1412;
    case _COORD_SLIPPYMAP_13: //= 1413;
    case _COORD_SLIPPYMAP_14: //= 1414;
    case _COORD_SLIPPYMAP_15: //= 1415;
    case _COORD_SLIPPYMAP_16: //= 1416;
    case _COORD_SLIPPYMAP_17: //= 1417;
    case _COORD_SLIPPYMAP_18: //= 1418;
    case _COORD_SLIPPYMAP_19: //= 1419;
    case _COORD_SLIPPYMAP_20: //= 1420;
    case _COORD_SLIPPYMAP_21: //= 1421;
    case _COORD_SLIPPYMAP_22: //= 1422;
    case _COORD_SLIPPYMAP_23: //= 1423;
    case _COORD_SLIPPYMAP_24: //= 1424;
    case _COORD_SLIPPYMAP_25: //= 1425;
    case _COORD_SLIPPYMAP_26: //= 1426;
    case _COORD_SLIPPYMAP_27: //= 1427;
    case _COORD_SLIPPYMAP_28: //= 1428;
    case _COORD_SLIPPYMAP_29: //= 1429;
    case _COORD_SLIPPYMAP_30: //= 1430;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isNotANumber(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotANumber(parameter_2)) _handleError(_INVALIDTYPECAST);
      SlippyMapCoordinate result =
          SlippyMapCoordinate(parameter_1 as double, parameter_2 as double, _GCW_SCRIPT_COORD_CONVERTER[source]!);
      coord = result.toLatLng();
      break;

    case _COORD_GEOHASH: //= 15;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      GeohashCoordinate result = GeohashCoordinate(parameter_1 as String);
      coord = result.toLatLng();
      break;

    case _COORD_GEO3X3: //= 16;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      Geo3x3Coordinate result = Geo3x3Coordinate(parameter_1 as String);
      coord = result.toLatLng();
      break;

    case _COORD_GEOHEX: //= 17;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      GeoHexCoordinate result = GeoHexCoordinate(parameter_1 as String);
      coord = result.toLatLng();
      break;

    case _COORD_OPEN_LOCATION_CODE: //= 18;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      OpenLocationCodeCoordinate result = OpenLocationCodeCoordinate(parameter_1 as String);
      coord = result.toLatLng();
      break;

    case _COORD_MAKANEY: //= 19;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      MakaneyCoordinate result = MakaneyCoordinate(parameter_1 as String);
      coord = result.toLatLng();
      break;

    case _COORD_QUADTREE: //= 20;
      if (_listLength(parameter) != 1) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      if (_isNotAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      QuadtreeCoordinate result = QuadtreeCoordinate(parameter_1 as List<int>);
      coord = result.toLatLng();
      break;

    case _COORD_REVERSE_WIG_WALDMEISTER: //= 21;
      if (_listLength(parameter) != 3) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      if (_isNotAInt(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_3)) _handleError(_INVALIDTYPECAST);
      ReverseWherigoWaldmeisterCoordinate result =
          ReverseWherigoWaldmeisterCoordinate(parameter_1 as int, parameter_2 as int, parameter_3 as int);
      coord = result.toLatLng();
      break;

    case _COORD_REVERSE_WIG_DAY1976: //= 22;
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      if (_isAList(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isAList(parameter_2)) _handleError(_INVALIDTYPECAST);
      ReverseWherigoDay1976Coordinate result =
          ReverseWherigoDay1976Coordinate(parameter_1 as String, parameter_2 as String);
      coord = result.toLatLng();
      break;

    case _COORD_MAPCODE_LOCAL:
    case _COORD_MAPCODE_INTERNATIONAL:
      if (_listLength(parameter) != 2) _handleError(_INVALIDNUMBEROFPARAMETER);
      parameter_1 = _listGet(parameter, 0)!;
      parameter_2 = _listGet(parameter, 1)!;
      parameter_3 = _listGet(parameter, 2)!;
      parameter_4 = _listGet(parameter, 3)!;
      if (_isAString(parameter_1)) _handleError(_INVALIDTYPECAST);
      if (_isAString(parameter_2)) _handleError(_INVALIDTYPECAST);
      if (_isAString(parameter_3)) _handleError(_INVALIDTYPECAST);
      if (_isNotAInt(parameter_4)) _handleError(_INVALIDTYPECAST);
      McInfo mcInfo = McInfo();
      mcInfo.mapcode = parameter_1 as String;
      mcInfo.territoryAlphaCode = parameter_2 as String;
      mcInfo.fullmapcode = parameter_3 as String;
      mcInfo.territoryNumber = parameter_4 as int;
      MapCode result = MapCode([mcInfo], _GCW_SCRIPT_COORD_CONVERTER[source]!);

      coord = result.toLatLng();
      break;

    default:
      _handleError(_INVALIDCOORDINATEFORMAT);
      coord = const LatLng(0.0, 0.0);
  }

  _setLat(coord!.latitude);
  _setLon(coord.longitude);
}

double _distance(Object lat1, Object lon1, Object lat2, Object lon2) {
  if (_isNotANumber(lat1) || _isNotANumber(lon1) || _isNotANumber(lat2) || _isNotANumber(lon2)) {
    _handleError(_INVALIDTYPECAST);
  }
  return distanceBearing(LatLng(lat1 as double, lon1 as double), LatLng(lat2 as double, lon2 as double),
          const Ellipsoid(ELLIPSOID_NAME_WGS84, 6378137.0, 298.257223563))
      .distance;
}

double _bearing(Object lat1, Object lon1, Object lat2, Object lon2) {
  if (_isNotANumber(lat1) || _isNotANumber(lon1) || _isNotANumber(lat2) || _isNotANumber(lon2)) {
    _handleError(_INVALIDTYPECAST);
  }
  return distanceBearing(
          LatLng(lat1 as double, lon1 as double), LatLng(lat2 as double, lon2 as double), Ellipsoid.WGS84)
      .bearingAToB;
}

void _projection(Object lat, Object lon, Object distance, Object bearing) {
  if (_isNotANumber(lat) || _isNotANumber(lon) || _isNotANumber(distance) || _isNotANumber(bearing)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    lat = lat as double;
    lon = lon as double;
    if (_isAInt(bearing)) bearing = (bearing as int).toDouble();
    bearing = bearing as double;
    if (_isAInt(distance)) distance = (distance as int).toDouble();
    distance = distance as double;
    distanceBearing(LatLng(lat, lon), LatLng(lat, lon), Ellipsoid.WGS84);
    LatLng _currentValues = projection(LatLng(lat, lon), bearing, distance, Ellipsoid.WGS84);
    _state.GCWizardScript_LAT = _currentValues.latitude;
    _state.GCWizardScript_LON = _currentValues.longitude;
  }
}

void _centerThreePoints(Object lat1, Object lon1, Object lat2, Object lon2, Object lat3, Object lon3) {
  if (_isNotANumber(lat1) ||
      _isNotANumber(lon1) ||
      _isNotANumber(lat2) ||
      _isNotANumber(lon2) ||
      _isNotANumber(lat3) ||
      _isNotANumber(lon3)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }

  double yDelta_a = (lat2 as double) - (lat1 as double);
  double xDelta_a = (lon2 as double) - (lon1 as double);
  double yDelta_b = (lat3 as double) - (lat2);
  double xDelta_b = (lon3 as double) - (lon2);

  double aSlope = yDelta_a / xDelta_a;
  double bSlope = yDelta_b / xDelta_b;

  _state.GCWizardScript_LON =
      (aSlope * bSlope * (lat1 - lat3) + bSlope * (lon1 + lon2) - aSlope * (lon2 + lon3)) / (2 * (bSlope - aSlope));
  _state.GCWizardScript_LAT = -1 * (_state.GCWizardScript_LON - (lon1 + lon2) / 2) / aSlope + (lat1 + lat2) / 2;
}

void _centerTwoPoints(Object lat1, Object lon1, Object lat2, Object lon2) {
  if (_isNotANumber(lat1) || _isNotANumber(lon1) || _isNotANumber(lat2) || _isNotANumber(lon2)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  CenterPointDistance coord = centerPointTwoPoints(
      LatLng(lat1 as double, lon1 as double), LatLng(lat2 as double, lon2 as double), Ellipsoid.WGS84);
  _state.GCWizardScript_LAT = coord.centerPoint.latitude;
  _state.GCWizardScript_LON = coord.centerPoint.longitude;
}

double _dmmtodec(Object? dec, Object? min) {
  if (_isNotAInt(dec)) {
    _handleError(_INVALIDTYPECAST);
  }
  if (_isNotANumber(min)) {
    _handleError(_INVALIDTYPECAST);
  }
  return (dec as int) + (min as num).toDouble() / 60;
}

double _dmstodec(Object? dec, Object? min, Object? sec) {
  if (_isNotAInt(dec)) {
    _handleError(_INVALIDTYPECAST);
  }
  if (_isNotAInt(min)) {
    _handleError(_INVALIDTYPECAST);
  }
  if (_isNotANumber(sec)) {
    _handleError(_INVALIDTYPECAST);
  }
  return (dec as int) + (min as int) / 60 + (sec as num).toDouble() / 3600;
}

String _dectodmm(Object? dec) {
  if (_isNotANumber(dec)) _handleError(_INVALIDTYPECAST);
  String result = '';
  double ms = 0.0;

  result = ((dec as double).truncate()).toString() + '° ';
  ms = (dec - dec.truncate()) * 60;
  result = result + ms.toStringAsFixed(3) + "' ";

  return result;
}

String _dectodms(Object? dec) {
  if (_isNotANumber(dec)) _handleError(_INVALIDTYPECAST);
  String result = '';
  double ms = 0.0;

  result = ((dec as double).truncate()).toString() + '° ';
  ms = (dec - dec.truncate()) * 60;
  result = result + ms.truncate().toString() + "' ";

  ms = (ms - ms.truncate()) * 60;
  result = result + ms.toStringAsFixed(3) + '"';

  return result;
}

String _dmmtodms(Object? dec, Object? min) {
  if (_isNotAInt(dec)) _handleError(_INVALIDTYPECAST);
  if (_isNotANumber(min)) _handleError(_INVALIDTYPECAST);
  return (_dectodms(_dmmtodec(dec as int, min as double)));
}

String _dmstodmm(Object? dec, Object? min, Object? sec) {
  if (_isNotAInt(dec)) _handleError(_INVALIDTYPECAST);
  if (_isNotAInt(min)) _handleError(_INVALIDTYPECAST);
  if (_isNotANumber(sec)) _handleError(_INVALIDTYPECAST);

  return (_dectodmm(_dmstodec(dec as int, min as int, sec as double)));
}

String _latSign(int sign) {
  if (sign == 1) {
    return 'N';
  }
  return 'S';
}

String _lonSign(int sign) {
  if (sign == 1) {
    return 'E';
  }
  return 'W';
}
