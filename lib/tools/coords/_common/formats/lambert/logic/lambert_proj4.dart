part of 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';

LambertCoordinate? _latLonToLambertProj4(LatLng coord, CoordinateFormatKey subtype) {
  if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtype)) {
    subtype = defaultLambertType;
  }

  var formatDefinition = _getFormatDefinition(subtype);
  if (formatDefinition == null) return null;

  return __latLonToLambertProj4(coord, formatDefinition, subtype);
}

LatLng? _lambertProj4ToLatLon(LambertCoordinate lambert) {
  if (lambert.format.subtype == null) return null;
  var formatDefinition = _getFormatDefinition(lambert.format.subtype!);
  if (formatDefinition == null) return null;

  return __lambertProj4ToLatLon(lambert, formatDefinition);
}

String? _getFormatDefinition(CoordinateFormatKey subtype) {
  switch (subtype) {
    case CoordinateFormatKey.LAMBERT_NTF:
      return '+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs';
    default:
      return  null;
  }
}

LatLng __lambertProj4ToLatLon(LambertCoordinate lambert, String formatDefinition) {
  final wgs = Projection.WGS84;
  var projection = Projection.parse(formatDefinition);

  var coord = wgs.transform(projection, Point(x: lambert.easting, y: lambert.northing));
  return LatLng(coord.x, coord.y);
}

LambertCoordinate __latLonToLambertProj4(LatLng coord, String formatDefinition, CoordinateFormatKey subtype) {
  final wgs = Projection.WGS84;
  var projection = Projection.parse(formatDefinition);

  var lambert = wgs.transform(projection, Point(x: coord.longitude, y: coord.latitude));
  return LambertCoordinate(lambert.x, lambert.y, subtype);
}