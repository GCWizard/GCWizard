import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

LatLng addIntegersToDMM(LatLng coord, Map<String, int> valuesToAdd) {
  DMM dmm = DMM.fromLatLon(coord);
  DMMLatitude lat = dmm.latitude;
  DMMLongitude lon = dmm.longitude;

  var addLat = valuesToAdd['latitude'] ?? 0;
  var addLon = valuesToAdd['longitude'] ?? 0;

  DMMLatitude newLat = dmm.latitude;
  if (addLat != 0) {
    var newLatMin = (lat.minutes * 1000 + addLat) / 1000;
    newLat = DMMLatitude(lat.sign, lat.degrees, newLatMin);
  }

  DMMLongitude newLon = dmm.longitude;
  if (addLon != 0) {
    var newLonMin = (lon.minutes * 1000 + addLon) / 1000;
    newLon = DMMLongitude(lon.sign, lon.degrees, newLonMin);
  }

  return DMM(newLat, newLon).toLatLng();
}
