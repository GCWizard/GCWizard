import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/latlon.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

class ParseVariableLatLonJobData {
  final String coordinate;
  final Map<String, String> substitutions;
  final Map<String, dynamic> projectionData;

  ParseVariableLatLonJobData({this.coordinate, this.substitutions, this.projectionData = const {}});
}

Map<String, LatLng> _parseCoordText(String text) {
  var parsedCoord = parseCoordinates(text, wholeString: true);
  if (parsedCoord == null || parsedCoord.length == 0) return null;

  var out = <String, LatLng>{'coordinate': parsedCoord.elementAt(0).toLatLng()};

  if (parsedCoord.elementAt(0).key == keyCoordsDMM) {
    out.putIfAbsent('leftPadCoordinate', () => DMM.parse(text, leftPadMilliMinutes: true)?.toLatLng());
  }

  return out;
}

_sanitizeVariableDoubleText(String text) {
  if (text == null) return null;

  return text.replaceAll(',', '.').replaceAll(RegExp(r'\s+'), '');
}

_addBrackets(String formula) {
  RegExp regExp = RegExp(r'\[.+?\]');
  if (regExp.hasMatch(formula)) return formula;

  return '[$formula]';
}

_removeBrackets(String formula) {
  RegExp regExp = RegExp(r'\[.+?\]');
  if (!regExp.hasMatch(formula)) return formula;

  return formula.substring(1, formula.length - 1);
}

Future<Map<String, dynamic>> parseVariableLatLonAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = parseVariableLatLon(jobData.parameters.coordinate, jobData.parameters.substitutions,
      projectionData: jobData.parameters.projectionData);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Map<String, dynamic> parseVariableLatLon(String coordinate, Map<String, String> substitutions,
    {Map<String, dynamic> projectionData = const {}}) {
  if (substitutions == null) substitutions = {};

  var textToExpand;

  var withProjection = false;
  if (projectionData != null) {
    if (projectionData['bearing'] != null &&
        projectionData['bearing'].length > 0 &&
        projectionData['distance'] != null &&
        projectionData['distance'].length > 0) {
      withProjection = true;

      textToExpand = _addBrackets(coordinate);
      textToExpand += String.fromCharCode(1) + _addBrackets(projectionData['bearing']);
      textToExpand += String.fromCharCode(1) + _addBrackets(projectionData['distance']);
    }
  } else {
    textToExpand = coordinate;
  }

  var calculated = FormulaParser(unlimitedExpanded: true).parse(textToExpand,
      substitutions.entries.map((e) => FormulaValue(e.key, e.value, type: FormulaValueType.INTERPOLATED)).toList());

  var coords = <Map<String, dynamic>>[];
  var leftPadCoords = <Map<String, dynamic>>[];

  for (FormulaSolverResult expandedText in calculated.results) {
    if (withProjection) {
      var evaluatedTexts = expandedText.result.split(String.fromCharCode(1));

      var parsedCoord = _parseCoordText(_removeBrackets(evaluatedTexts[0]));
      if (parsedCoord == null) continue;

      var parsedBearing = double.tryParse(_sanitizeVariableDoubleText(_removeBrackets(evaluatedTexts[1])));
      var parsedDistance = double.tryParse(_sanitizeVariableDoubleText(_removeBrackets(evaluatedTexts[2])));

      if (parsedBearing == null || parsedDistance == null) continue;

      parsedBearing = modulo360(parsedBearing);
      parsedDistance = parsedDistance.abs();

      parsedCoord.entries.forEach((entry) {
        if (projectionData['reverseBearing'] != null && projectionData['reverseBearing']) {
          var revProjected = reverseProjection(entry.value, parsedBearing,
              projectionData['lengthUnit'].toMeter(parsedDistance), projectionData['ellipsoid']);
          if (revProjected == null || revProjected.length == 0) return;

          var projected = revProjected.map((projection) {
            return {'variables': expandedText.variables, 'coordinate': projection};
          }).toList();

          if (entry.key == 'coordinate')
            coords.addAll(projected);
          else
            leftPadCoords.addAll(projected);
        } else {
          var projected = {
            'coordinate': projection(entry.value, parsedBearing, projectionData['lengthUnit'].toMeter(parsedDistance),
                projectionData['ellipsoid']),
            'variables': expandedText.variables ?? {}
          };

          if (entry.key == 'coordinate')
            coords.add(projected);
          else
            leftPadCoords.add(projected);
        }
      });
    } else {
      var parsedCoord = _parseCoordText(_removeBrackets(expandedText.result));
      if (parsedCoord == null) continue;

      coords.add({'variables': expandedText.variables ?? {}, 'coordinate': parsedCoord['coordinate']});
      if (parsedCoord['leftPadCoordinate'] != null) {
        leftPadCoords.add({'variables': expandedText.variables ?? {}, 'coordinate': parsedCoord['leftPadCoordinate']});
      }
    }
  }

  return {'coordinates': coords, 'leftPadCoordinates': leftPadCoords};
}
