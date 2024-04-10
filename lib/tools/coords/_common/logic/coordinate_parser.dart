import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';

//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
List<BaseCoordinate> parseCoordinates(String text, {bool wholeString = false}) {
  var coords = <BaseCoordinate>[];

  try {
    BaseCoordinate? coord;
    coord = parseStandardFormats(text, wholeString: wholeString);
    if (coord != null) coords.add(coord);
    for (var format in allCoordinateFormatDefinitions.whereNot((format) => standardCoordinateFormatDefinitions.contains(format))   ) {
      coord = (wholeString ? format.parseCoordinateWholeString(text) : format.parseCoordinate(text));
      if (coord != null) coords.add(coord);
    }
  } catch (e) {}

  return coords;
}

//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
BaseCoordinate? parseStandardFormats(String text, {bool wholeString = false}) {

  for (var format in standardCoordinateFormatDefinitions) {
    var coord = (wholeString ? format.parseCoordinateWholeString(text) : format.parseCoordinate(text));
    if (coord != null) return coord;
  }

  return null;
}

