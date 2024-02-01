import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';


//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
List<BaseCoordinate> parseCoordinates(String text, {bool wholeString = false}) {
  var coords = <BaseCoordinate>[];

  try {
    BaseCoordinate? coord;
    for (var format in allCoordinateFormatDefinitions) {
      coord = (wholeString ? format.parseCoordinateWholeString(text) : format.parseCoordinate(text));
      if (coord != null) coords.add(coord);
    }
  } catch (e) {}

  return coords;
}

//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
BaseCoordinate? parseStandardFormats(String text, {bool wholeString = false}) {
  LatLng? coord;
  coord = (wholeString ? DMSCoordinate.parseWholeString(text) : DMSCoordinate.parse(text))?.toLatLng();
  if (coord != null) return DMSCoordinate.fromLatLon(coord);

  coord = (wholeString ? DMMCoordinate.parseWholeString(text) : DMMCoordinate.parse(text))?.toLatLng();
  if (coord != null) return DMMCoordinate.fromLatLon(coord);

  coord = (wholeString ? DECCoordinate.parseWholeString(text) : DECCoordinate.parse(text))?.toLatLng();
  if (coord != null) return DECCoordinate.fromLatLon(coord);

  return null;
}
