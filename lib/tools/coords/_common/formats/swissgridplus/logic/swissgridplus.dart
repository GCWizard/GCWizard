import 'package:gc_wizard/tools/coords/_common/formats/swissgrid/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

const swissGridPlusKey = 'coords_swissgridplus';

final SwissGridPlusFormatDefinition = CoordinateFormatDefinition(CoordinateFormatKey.SWISS_GRID_PLUS, swissGridPlusKey,
    swissGridPlusKey, SwissGridPlusCoordinate.parse, SwissGridPlusCoordinate(0, 0));

class SwissGridPlusCoordinate extends SwissGridCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.SWISS_GRID_PLUS);

  SwissGridPlusCoordinate(super.easting, super.northing);

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return _swissGridPlusToLatLon(this, ells);
  }

  static SwissGridPlusCoordinate fromLatLon(LatLng coord, Ellipsoid ells) {
    return _latLonToSwissGridPlus(coord, ells);
  }

  static SwissGridPlusCoordinate? parse(String input) {
    return _parseSwissGridPlus(input);
  }
}

SwissGridPlusCoordinate _latLonToSwissGridPlus(LatLng coord, Ellipsoid ells) {
  SwissGridCoordinate swissGrid = SwissGridCoordinate.fromLatLon(coord, ells);

  return SwissGridPlusCoordinate(swissGrid.easting + 2000000, swissGrid.northing + 1000000);
}

LatLng _swissGridPlusToLatLon(SwissGridPlusCoordinate coord, Ellipsoid ells) {
  var swissGripPlus = SwissGridCoordinate(coord.easting - 2000000, coord.northing - 1000000);

  return swissGridToLatLon(swissGripPlus, ells);
}

SwissGridPlusCoordinate? _parseSwissGridPlus(String input) {
  var swissGrid = SwissGridCoordinate.parse(input);
  if (swissGrid != null) {
    swissGrid = (swissGrid.easting.toInt().toString().length == 7 || swissGrid.northing.toInt().toString().length == 7)
        ? swissGrid
        : null;
  }

  return swissGrid == null ? null : SwissGridPlusCoordinate(swissGrid.easting, swissGrid.northing);
}
