import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:latlong2/latlong.dart';

const maidenheadKey = 'coords_maidenhead';

final MaidenheadFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.MAIDENHEAD, maidenheadKey, maidenheadKey, MaidenheadCoordinate.parse, MaidenheadCoordinate(''));

class MaidenheadCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.MAIDENHEAD);
  String text;

  MaidenheadCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _maidenheadToLatLon(this);
  }

  static MaidenheadCoordinate fromLatLon(LatLng coord) {
    return _latLonToMaidenhead(coord);
  }

  static MaidenheadCoordinate? parse(String input) {
    return _parseMaidenhead(input);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

LatLng? _maidenheadToLatLon(MaidenheadCoordinate maidenhead) {
  var _maidenhead = maidenhead.text;
  if (_maidenhead.isEmpty) return null;
  _maidenhead = _maidenhead.toUpperCase();

  int res = 1;
  double reslon = 20;
  double reslat = 10;

  double lat = 0.0;
  double lon = 0.0;
  try {
    for (int i = 0; i < _maidenhead.length; i += 2) {
      if (res == 1) {
        if (!RegExp(r'[A-Z]{2}').hasMatch(_maidenhead.substring(0, 2))) return null;
        lon = ((alphabet_AZ[_maidenhead[0]]! - 1) * 20).toDouble();
        lat = ((alphabet_AZ[_maidenhead[1]]! - 1) * 10).toDouble();
        res = 2;
      } else if (res % 2 == 1) {
        reslon /= 24;
        reslat /= 24;
        if (!RegExp(r'[A-Z]{2}').hasMatch(_maidenhead.substring(i, i + 2))) return null;
        lon += (alphabet_AZ[_maidenhead[i]]! - 1).toDouble() * reslon;
        lat += (alphabet_AZ[_maidenhead[i + 1]]! - 1).toDouble() * reslat;
        ++res;
      } else {
        reslon /= 10;
        reslat /= 10;
        if (!RegExp(r'\d{2}').hasMatch(_maidenhead.substring(i, i + 2))) return null;
        lon += int.parse(_maidenhead[i]) * reslon;
        lat += int.parse(_maidenhead[i + 1]) * reslat;
        ++res;
      }
    }
  } catch (e) {
    return null;
  }

  lon -= 180;
  lat -= 90;

  return LatLng(lat, lon);
}

MaidenheadCoordinate? _parseMaidenhead(String input) {
  input = input.trim();
  if (input.isEmpty) return null;

  var _maidenhead = MaidenheadCoordinate(input);
  return _maidenheadToLatLon(_maidenhead) == null ? null : _maidenhead;
}

MaidenheadCoordinate _latLonToMaidenhead(LatLng coord) {
  var lon = coord.longitude + 180.0;
  var lat = coord.latitude + 90.0;

  int resolution = 8;

  String out = '';

  int intlon;
  int intlat;

  if (resolution >= 1) {
    intlon = (lon / 20.0).floor();
    lon -= intlon * 20.0;
    intlat = (lat / 10.0).floor();
    lat -= intlat * 10.0;
    out += alphabet_AZIndexes[intlon + 1] ?? '';
    out += alphabet_AZIndexes[intlat + 1] ?? '';
  }

  if (resolution >= 2) {
    intlon = (lon / 2.0).floor();
    lon -= intlon * 2.0;
    intlat = (lat).floor();
    lat -= intlat;

    out += intlon.toString();
    out += intlat.toString();
  }

  int i = 3;
  double reslon = 2.0;
  double reslat = 1.0;

  while (i <= resolution) {
    if (i % 2 == 1) {
      reslon /= 24.0;
      reslat /= 24.0;
      intlon = (lon / reslon).floor();
      lon -= intlon * reslon;
      intlat = (lat / reslat).floor();
      lat -= intlat * reslat;

      out += alphabet_AZIndexes[intlon + 1] ?? '';
      out += alphabet_AZIndexes[intlat + 1] ?? '';
    } else {
      reslon /= 10.0;
      reslat /= 10.0;
      intlon = (lon / reslon).floor();
      lon -= intlon * reslon;
      intlat = (lat / reslat).floor();
      lat -= intlat * reslat;

      out += intlon.toString();
      out += intlat.toString();
    }

    ++i;
  }

  return MaidenheadCoordinate(out);
}
