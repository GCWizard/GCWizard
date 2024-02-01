import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:latlong2/latlong.dart';

LatLng? addIntegersToDMM(LatLng coord, Map<String, int> valuesToAdd) {
  DMMCoordinate dmm = DMMCoordinate.fromLatLon(coord);
  DMMLatitude lat = dmm.dmmLatitude;
  DMMLongitude lon = dmm.dmmLongitude;

  var addLat = valuesToAdd['latitude'] ?? 0;
  var addLon = valuesToAdd['longitude'] ?? 0;

  DMMLatitude newLat = dmm.dmmLatitude;
  if (addLat != 0) {
    var newLatMin = (lat.minutes * 1000 + addLat) / 1000;
    newLat = DMMLatitude(lat.sign, lat.degrees, newLatMin);
  }

  DMMLongitude newLon = dmm.dmmLongitude;
  if (addLon != 0) {
    var newLonMin = (lon.minutes * 1000 + addLon) / 1000;
    newLon = DMMLongitude(lon.sign, lon.degrees, newLonMin);
  }

  return DMMCoordinate(newLat, newLon).toLatLng();
}
