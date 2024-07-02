part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

void _wptsAdd(Object lat, Object lon) {
  if (_isNotANumber(lat) || _isNotANumber(lon)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  if ((lat as num).abs() > 90.0) {
    _handleError(_INVALIDLATITUDE);
    return;
  }
  if ((lon as num).abs() > 180.0) {
    _handleError(_INVALIDLONGITUDE);
    return;
  }
  lat = lat as double;
  lon = lon as double;

  var wpt = GCWMapPoint(
      uuid: 'wpt',
      markerText: 'wpt',
      point: LatLng(lat, lon),
      coordinateFormat: CoordinateFormat(CoordinateFormatKey.DEC),
      color: Colors.black,
      isEditable: false,
      isVisible: true);
  _state.waypoints.add(wpt);
}

void _wptsClear() {
  _state.waypoints = [];
}

int _wptsCount() {
  return _state.waypoints.length;
}

double _wptsLat(Object i) {
  if (!_isANumber(i)) {
    _handleError(_INVALIDTYPECAST);
    return 0.0;
  }

  if ((i as num).toInt() > _state.waypoints.length || i.toInt() < 1) {
    _handleError(_RANGEERROR);
    return 0.0;
  }
  return _state.waypoints[i.toInt() - 1].point.latitude;
}

double _wptsLon(Object i) {
  if (!_isANumber(i)) {
    _handleError(_INVALIDTYPECAST);
    return 0.0;
  }
  if ((i as num).toInt() > _state.waypoints.length || i < 1) {
    _handleError(_RANGEERROR);
    return 0.0;
  }
  return _state.waypoints[i.toInt() - 1].point.longitude;
}

void _wptsCenter(Object x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  List<LatLng> coords = [];
  for (GCWMapPoint waypoint in _state.waypoints) {
    coords.add(LatLng(waypoint.point.latitude, waypoint.point.longitude));
  }
  LatLng coord = centroidCenterOfGravity(coords)!;
  if ((x as num) == 0) {
    // arithmetic
    coord = centroidArithmeticMean(coords, coord)!;
    _state.GCWizardScript_LAT = coord.latitude;
    _state.GCWizardScript_LON = coord.longitude;
  } else {
    // gravity
    _state.GCWizardScript_LAT = coord.latitude;
    _state.GCWizardScript_LON = coord.longitude;
  }
}
