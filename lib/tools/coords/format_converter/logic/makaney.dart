import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/format_converter/logic/external_libs/net.makaney/makaney.dart';

LatLng? makaneyToLatLon(Makaney makaney) {
  if (makaney.text.isEmpty) return null;

  var _text = makaney.text.toLowerCase().replaceAll(RegExp(r'[^\-+abo2zptscjkwmgnxqfd984ery3h5l76ui]'), '');

  var regexCheck = RegExp(r'-?[a-z\d]+([+-])[a-z\d]+');
  if (!regexCheck.hasMatch(_text)) {
    return null;
  }

  var latLon = _makaneyToLatLon(_text);
  if (latLon.contains(null)) return null;

  try {
    return LatLng(latLon[0], latLon[1]);
  } catch (e) {
    return null;
  }
}

Makaney latLonToMakaney(LatLng latLon) {
  return Makaney(_latLonToMakaney(latLon.latitude, latLon.longitude).toUpperCase());
}

Makaney? parseMakaney(String input) {
  var makaney = Makaney(input);
  return makaneyToLatLon(makaney) == null ? null : makaney;
}
