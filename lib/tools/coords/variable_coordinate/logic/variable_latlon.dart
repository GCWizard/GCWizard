import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

class _ParsedCoordinates {
  BaseCoordinate coordinate;
  DMMCoordinate? leftPadCoordinate;

  _ParsedCoordinates(this.coordinate);
}

_ParsedCoordinates? _parseCoordText(String text) {
  var parsedCoord = parseCoordinates(text, wholeString: true);
  if (parsedCoord.isEmpty || parsedCoord.first.toLatLng() == null) return null;

  var out = _ParsedCoordinates(parsedCoord.first);

  if (parsedCoord.first.format.type == CoordinateFormatKey.DMM) {
    out.leftPadCoordinate = DMMCoordinate.parse(text, leftPadMilliMinutes: true);
  }

  return out;
}

String _sanitizeVariableDoubleText(String text) {
  return text.replaceAll(',', '.').replaceAll(RegExp(r'\s+'), '');
}

String _addBrackets(String formula) {
  RegExp regExp = RegExp(r'\[.+?\]');
  if (regExp.hasMatch(formula)) return formula;

  return '[$formula]';
}

String _removeBrackets(String formula) {
  RegExp regExp = RegExp(r'\[.+?\]');
  if (!regExp.hasMatch(formula)) return formula;

  return formula.substring(1, formula.length - 1);
}

class VariableCoordinateSingleResult {
  LatLng coordinate;
  Map<String, String>? variables;

  VariableCoordinateSingleResult(this.coordinate, [this.variables]);

  @override
  String toString() {
    return coordinate.toString() + '\n' + variables.toString();
  }
}

VariableCoordinateResults parseVariableLatLon(String coordinate, Map<String, String> substitutions,
    {ProjectionData? projectionData}) {
  String textToExpand = coordinate;

  var withProjection = false;
  if (projectionData != null) {
    if (projectionData.bearing.isNotEmpty && projectionData.distance.isNotEmpty) {
      withProjection = true;

      textToExpand = _addBrackets(coordinate);
      textToExpand += String.fromCharCode(1) + _addBrackets(projectionData.bearing);
      textToExpand += String.fromCharCode(1) + _addBrackets(projectionData.distance);
    }
  }


  var values = substitutions.entries.map((e) => FormulaValue(e.key, e.value, type: FormulaValueType.INTERPOLATED)).toList();
  var parserResult = formatAndParseFormulas([Formula(textToExpand)], values, unlimitedExpanded: true);

  var coords = <VariableCoordinateSingleResult>[];
  var leftPadCoords = <VariableCoordinateSingleResult>[];

  for (FormulaSolverSingleResult expandedText in parserResult.first.output.results) {
    if (withProjection) {
      var evaluatedTexts = expandedText.result.split('\u0001');

      var parsedCoord = _parseCoordText(_removeBrackets(evaluatedTexts[0]));
      if (parsedCoord == null) continue;

      var _parsedBearing = double.tryParse(_sanitizeVariableDoubleText(_removeBrackets(evaluatedTexts[1])));
      var _parsedDistance = double.tryParse(_sanitizeVariableDoubleText(_removeBrackets(evaluatedTexts[2])));

      if (_parsedBearing == null || _parsedDistance == null) continue;

      var parsedBearing = modulo360(_parsedBearing).toDouble();
      var parsedDistance = _parsedDistance.abs();

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      VariableCoordinateSingleResult? _projectCoordinates(BaseCoordinate coordinate) {
        if (projectionData!.reverse) {
          LatLng? revProjected = reverseProjection(coordinate.toLatLng()!, parsedBearing,
              projectionData.distanceUnit.toMeter(parsedDistance), projectionData.ellipsoid ?? defaultEllipsoid);
          if (revProjected == null) return null;

          var projected = VariableCoordinateSingleResult(revProjected, expandedText.variables);

          return projected;
        } else {
          var projected = VariableCoordinateSingleResult(
              projection(coordinate.toLatLng()!, parsedBearing, projectionData.distanceUnit.toMeter(parsedDistance),
                  projectionData.ellipsoid ?? defaultEllipsoid),
              expandedText.variables);

          return projected;
        }
      }

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      if (parsedCoord.coordinate.toLatLng() == null) {
        continue;
      }

      var projected = _projectCoordinates(parsedCoord.coordinate);
      if (projected != null) {
        coords.add(projected);
      }

      if (parsedCoord.leftPadCoordinate != null) {
        projected = _projectCoordinates(parsedCoord.leftPadCoordinate!);
        if (projected != null) {
          leftPadCoords.add(projected);
        }
      }
    } else {
      var parsedCoord = _parseCoordText(_removeBrackets(expandedText.result));
      if (parsedCoord == null ||
          ![CoordinateFormatKey.DEC, CoordinateFormatKey.DMM, CoordinateFormatKey.DMS]
              .contains(parsedCoord.coordinate.format.type) ||
          parsedCoord.coordinate.toLatLng() == null) {
        continue;
      }

      coords.add(VariableCoordinateSingleResult(parsedCoord.coordinate.toLatLng()!, expandedText.variables));
      var latLng = parsedCoord.leftPadCoordinate?.toLatLng();
      if (latLng != null) {
        leftPadCoords.add(VariableCoordinateSingleResult(latLng, expandedText.variables));
      }
    }
  }

  return VariableCoordinateResults(coords, leftPadCoords);
}

class VariableCoordinateResults {
  List<VariableCoordinateSingleResult> coordinates;
  List<VariableCoordinateSingleResult> leftPadCoordinates;

  VariableCoordinateResults(this.coordinates, this.leftPadCoordinates);
}
