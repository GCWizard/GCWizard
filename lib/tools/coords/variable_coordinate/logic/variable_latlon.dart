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
  DMM? leftPadCoordinate;

  _ParsedCoordinates(this.coordinate);
}

_ParsedCoordinates? _parseCoordText(String text) {
  var parsedCoord = parseCoordinates(text, wholeString: true);
  if (parsedCoord.isEmpty || parsedCoord.first.toLatLng() == null) return null;

  var out = _ParsedCoordinates(parsedCoord.first);

  if (parsedCoord.first.format.type == CoordinateFormatKey.DMM) {
    out.leftPadCoordinate = DMM.parse(text, leftPadMilliMinutes: true);
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
}

VariableCoordinateResults parseVariableLatLon(String coordinate, Map<String, String> substitutions, {ProjectionData? projectionData}) {

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

  var calculated = FormulaParser(unlimitedExpanded: true).parse(textToExpand,
      substitutions.entries.map((e) => FormulaValue(e.key, e.value, type: FormulaValueType.INTERPOLATED)).toList());

  var coords = <VariableCoordinateSingleResult>[];
  var leftPadCoords = <VariableCoordinateSingleResult>[];

  for (FormulaSolverSingleResult expandedText in calculated.results) {
    if (withProjection) {
      var evaluatedTexts = expandedText.result.split(String.fromCharCode(1));

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

      List<VariableCoordinateSingleResult> _projectCoordinates(BaseCoordinate coordinate) {
        if (projectionData!.reverse) {
          List<LatLng> revProjected = reverseProjection(
              coordinate.toLatLng()!,
              parsedBearing,
              projectionData.distanceUnit.toMeter(parsedDistance),
              projectionData.ellipsoid ?? defaultEllipsoid
          );
          if (revProjected.isEmpty) return [];

          var projected = revProjected.map((LatLng projection) {
            return VariableCoordinateSingleResult(projection, expandedText.variables);
          }).toList();

          return projected;

        } else {
          var projected = VariableCoordinateSingleResult(
            projection(
              coordinate.toLatLng()!,
              parsedBearing,
              projectionData.distanceUnit.toMeter(parsedDistance),
              projectionData.ellipsoid ?? defaultEllipsoid
            ),
            expandedText.variables
          );

          return [projected];
        }
      }

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      if (parsedCoord.coordinate.toLatLng() == null) {
        continue;
      }

      coords.addAll(_projectCoordinates(parsedCoord.coordinate));

      if (parsedCoord.leftPadCoordinate != null) {
        leftPadCoords.addAll(_projectCoordinates(parsedCoord.leftPadCoordinate!));
      }

    } else {
      var parsedCoord = _parseCoordText(_removeBrackets(expandedText.result));
      if (parsedCoord == null || parsedCoord.coordinate.toLatLng() == null) continue;

      coords.add(VariableCoordinateSingleResult(parsedCoord.coordinate.toLatLng()!, expandedText.variables));
      if (parsedCoord.leftPadCoordinate != null) {
        leftPadCoords.add(VariableCoordinateSingleResult(parsedCoord.leftPadCoordinate!.toLatLng(), expandedText.variables));
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
