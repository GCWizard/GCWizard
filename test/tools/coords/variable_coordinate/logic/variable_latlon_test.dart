import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/logic/variable_latlon.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.variableLatLon.parseVariableLatLon:", () {
    final expectedLatLngList = VariableCoordinateResults([
        VariableCoordinateSingleResult(LatLng(51.11960894786239, 0.42652334719892887),{'A': '1', 'B': '0', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.11960492060995, 11.426523663312299),{'A': '1', 'B': '1', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.11960089147215, 22.4265239678175), {'A': '1', 'B': '2', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.11959282759345, 44.426524541965485), {'A': '1', 'B': '4', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.22619484235261, 0.42079431270562384), {'A': '2', 'B': '0', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.226196421033954, 11.420783247210858), {'A': '2', 'B': '1', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.226198012378866, 24.420772183774734), {'A': '2', 'B': '2', 'C': '12'}),
        VariableCoordinateSingleResult( LatLng(51.22620123306048, 56.420750063225206), {'A': '2', 'B': '4', 'C': '12'}),
        VariableCoordinateSingleResult( LatLng(51.34292319020224, 0.41491506976384096), {'A': '3', 'B': '0', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.34293247464074, 11.414921985728482), {'A': '3', 'B': '1', 'C': '12'}),
        VariableCoordinateSingleResult(LatLng(51.34294175286147, 28.414928928816426), {'A': '3', 'B': '2', 'C': '12'}),
        VariableCoordinateSingleResult( LatLng(51.34296029052551, 104.41494289630785),{'A': '3', 'B': '4', 'C': '12'})], <VariableCoordinateSingleResult>[]);

    List<Map<String, Object?>> _inputsToExpected = [
      {'text': 'N 51.[A][A+1] E [B][B^A].[4]23', 'values': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'projectionData': ProjectionData('[A*2]50, [B+5]', UNITCATEGORY_LENGTH.defaultUnit, 'A00.B', false, getEllipsoidByName(ELLIPSOID_NAME_WGS84)), 'expectedOutput': expectedLatLngList},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}, values: ${elem['values']}, projectionData: ${elem['projectionData']}', () {
        var _actual = parseVariableLatLon(elem['text'] as String, elem['values'] as Map<String, String>, projectionData: elem['projectionData'] as ProjectionData?);
        var _expected = elem['expectedOutput'] as VariableCoordinateResults;

        var _actualCoords = _actual.coordinates;
        expect(_actualCoords.length, _expected.coordinates.length);

        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord.coordinate, _expected.coordinates[index].coordinate));
          expect(actualCoord.variables, _expected.coordinates[index].variables);
        });

        _actualCoords = _actual.leftPadCoordinates;
        expect(_actualCoords.length, _expected.leftPadCoordinates.length);

        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord.coordinate, _expected.leftPadCoordinates[index].coordinate));
          expect(actualCoord.variables, _expected.leftPadCoordinates[index].variables);
        });
      });
    }
  });
  
  group("Parser.variableLatLon.parseVariableLatLonWithoutVariables:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': 'N 50 54.216 E 011 35.215', 'values': <String, String>{},
        'expectedOutput': VariableCoordinateResults([
          VariableCoordinateSingleResult(LatLng(50.9036, 11.586917))], [])
      },
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-3'},
        'expectedOutput': VariableCoordinateResults([
          VariableCoordinateSingleResult(LatLng(50.9036, 11.586917), {'Y': '1'})], [])
      },
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-3'},
        'projectionData': ProjectionData('1100 - 13.45 * Y', UNITCATEGORY_LENGTH.defaultUnit, '318', false, getEllipsoidByName(ELLIPSOID_NAME_WGS84)),
        'expectedOutput':  VariableCoordinateResults([
          VariableCoordinateSingleResult(LatLng(50.910858, 11.576579), {'Y': '1'}),
          VariableCoordinateSingleResult(LatLng(50.910768, 11.576707), {'Y': '2'}),
          VariableCoordinateSingleResult(LatLng(50.910678, 11.576835), {'Y': '3'})], [])
      },
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-3'},
        'projectionData': ProjectionData('1100 - 13.45 × Y', UNITCATEGORY_LENGTH.defaultUnit, '318', false, getEllipsoidByName(ELLIPSOID_NAME_WGS84)),
        'expectedOutput':  VariableCoordinateResults([
            VariableCoordinateSingleResult(LatLng(50.910858, 11.576579), {'Y': '1'}),
            VariableCoordinateSingleResult(LatLng(50.910768, 11.576707), {'Y': '2'}),
            VariableCoordinateSingleResult(LatLng(50.910678, 11.576835), {'Y': '3'})], [])
      },
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-10'},
        'projectionData': ProjectionData('1100 - 13.45 × A',UNITCATEGORY_LENGTH.defaultUnit,'318', false, getEllipsoidByName(ELLIPSOID_NAME_WGS84)),
        'expectedOutput': VariableCoordinateResults([], [])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}, values: ${elem['values']}, projectionData: ${elem['projectionData']}', () {
        var _actual = parseVariableLatLon(elem['text'] as String, elem['values'] as Map<String, String>, projectionData: elem['projectionData'] as ProjectionData?);
        var _expected = elem['expectedOutput'] as VariableCoordinateResults;

        var _actualCoords = _actual.coordinates;
        expect(_actualCoords.length, _expected.coordinates.length);
        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord.coordinate, _expected.coordinates[index].coordinate, tolerance: 1e-5));
          if (actualCoord.variables == null){
            expect(null, _expected.coordinates[index].variables);
          } else {
            expect(actualCoord.variables, _expected.coordinates[index].variables);
          }
        });
        // expect(_actual['leftPadCoordinates'], elem['expectedOutput']['leftPadCoordinates']);
      });
    }
  });

  group("Parser.variableLatLon.parseVariableLatLonWithLeftPadAndReplaceE:", () {
    final expectedLatLngList = VariableCoordinateResults(
      [
        VariableCoordinateSingleResult(
          LatLng(52.50205,11.342333333333332),
          {'E': '5'},
        )
      ],
      [
        VariableCoordinateSingleResult(
          LatLng(52.50205, 11.334233333333334),
          {'E': '5'},
        )
      ]
    );

    List<Map<String, Object?>> _inputsToExpected = [
      {'text': 'N 52° 30.123 E 11° [20.E4]', 'values': {'E': '5'}, 'expectedOutput': expectedLatLngList},
      {'text': 'N 52° 30.123 E 12', 'values': {'E': '5'}, 'expectedOutput': VariableCoordinateResults([VariableCoordinateSingleResult(LatLng(52.50205, 5.2), {'E': '5'})], [VariableCoordinateSingleResult(LatLng(52.50205, 5.2), {'E': '5'})])},
      {'text': '52° 30.123 11° 20.E4', 'values': {'E': '5'}, 'expectedOutput': expectedLatLngList},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}, values: ${elem['values']}, projectionData: ${elem['projectionData']}', () {
        var _actual = parseVariableLatLon(elem['text'] as String, elem['values'] as Map<String, String>, projectionData: elem['projectionData'] as ProjectionData?);
        var _expected = elem['expectedOutput'] as VariableCoordinateResults;

        var _actualCoords = _actual.coordinates;
        expect(_actualCoords.length, 1);
        var _expectedCoords = _expected.coordinates;
        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord.coordinate, _expectedCoords[index].coordinate));
          expect(actualCoord.variables, _expectedCoords[index].variables);
        });

        var _actualLeftPadCoords = _actual.leftPadCoordinates;
        expect(_actualCoords.length, 1);
        var _expectedLeftPadCoords = _expected.leftPadCoordinates;
        _actualLeftPadCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord.coordinate, _expectedLeftPadCoords[index].coordinate));
          expect(actualCoord.variables, _expectedCoords[index].variables);
        });
      });
    }
  });
}