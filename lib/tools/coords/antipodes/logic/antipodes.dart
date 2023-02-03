import 'package:latlong2/latlong.dart';

LatLng antipodes(LatLng coord) {
  LatLng antipodes = LatLng(coord.latitude, coord.longitude);

  antipodes.latitude *= -1;
  if (antipodes.longitude > 0)
    antipodes.longitude += -180;
  else
    antipodes.longitude += 180;

  return antipodes;
}
