import 'package:latlong2/latlong.dart';

LatLng antipodes(LatLng coord) {
  var lat = coord.latitude;
  var lon = coord.longitude;
  lat *= -1;
  if (lon > 0) {
    lon += -180;
  } else {
    lon += 180;
  }

  return LatLng(lat, lon);
}
