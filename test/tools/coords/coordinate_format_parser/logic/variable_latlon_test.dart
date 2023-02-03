import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/variable_latlon.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.variableLatLon.parseVariableLatLon:", () {
    final expectedLatLngList = {
      'coordinates': [
        {
        'coordinate': LatLng(51.11960894786239, 0.42652334719892887),
        'variables': {'A': '1', 'B': '0', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.11960492060995, 11.426523663312299),
          'variables': {'A': '1', 'B': '1', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.11960089147215, 22.4265239678175),
          'variables': {'A': '1', 'B': '2', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.11959282759345, 44.426524541965485),
          'variables': {'A': '1', 'B': '4', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.22619484235261, 0.42079431270562384),
          'variables': {'A': '2', 'B': '0', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.226196421033954, 11.420783247210858),
          'variables': {'A': '2', 'B': '1', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.226198012378866, 24.420772183774734),
          'variables': {'A': '2', 'B': '2', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.22620123306048, 56.420750063225206),
          'variables': {'A': '2', 'B': '4', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.34292319020224, 0.41491506976384096),
          'variables': {'A': '3', 'B': '0', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.34293247464074, 11.414921985728482),
          'variables': {'A': '3', 'B': '1', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.34294175286147, 28.414928928816426),
          'variables': {'A': '3', 'B': '2', 'C': '12'}
        },
        {
          'coordinate': LatLng(51.34296029052551, 104.41494289630785),
          'variables': {'A': '3', 'B': '4', 'C': '12'}
        }
      ],
      'leftPadCoordinates': []
    };

    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': 'N 51.[A][A+1] E [B][B^A].[4]23', 'values': {'A': '1-3', 'B': '4-0#2,1', 'C': '12,34'}, 'projectionData': {'bearing': 'A00.B', 'distance': '[A*2]50, [B+5]', 'lengthUnit': UNITCATEGORY_LENGTH.defaultUnit, 'ellipsoid': getEllipsoidByName('WGS84')}, 'expectedOutput': expectedLatLngList},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}, values: ${elem['values']}, projectionData: ${elem['projectionData']}', () {
        var _actual = parseVariableLatLon(elem['text'], elem['values'], projectionData: elem['projectionData']);

        List<Map<String, dynamic>> _actualCoords = _actual['coordinates'];
        expect(_actualCoords.length, 12);

        var _expectedCoords = elem['expectedOutput']['coordinates'];
        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord['coordinate'], _expectedCoords[index]['coordinate']));
          expect(actualCoord['variables'], _expectedCoords[index]['variables']);
        });
        expect(_actual['leftPadCoordinates'], elem['expectedOutput']['leftPadCoordinates']);
      });
    });
  });
  
  group("Parser.variableLatLon.parseVariableLatLonWithoutVariables:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': 'N 50 54.216 E 011 35.215', 'values': null, 'expectedOutput': [{
        'coordinate': LatLng(50.9036, 11.586917),
        'variables': {}
      }]},
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-3'}, 'expectedOutput': [{
        'coordinate': LatLng(50.9036, 11.586917),
        'variables': {'Y': '1'}
      }]},
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-3'},
        'projectionData': {
          'bearing': '318',
          'distance': '1100 - 13.45 * Y',
          'lengthUnit': UNITCATEGORY_LENGTH.defaultUnit,
          'ellipsoid': getEllipsoidByName('WGS84')
        },
        'expectedOutput':  [{
          'coordinate': LatLng(50.910858, 11.576579),
          'variables': {'Y': '1'}
        },{
          'coordinate': LatLng(50.910768, 11.576707),
          'variables': {'Y': '2'}
        },{
          'coordinate': LatLng(50.910678, 11.576835),
          'variables': {'Y': '3'}
        }]
      },
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-3'},
        'projectionData': {
          'bearing': '318',
          'distance': '1100 - 13.45 × Y',
          'lengthUnit': UNITCATEGORY_LENGTH.defaultUnit,
          'ellipsoid': getEllipsoidByName('WGS84')
        },
        'expectedOutput':  [{
          'coordinate': LatLng(50.910858, 11.576579),
          'variables': {'Y': '1'}
        },{
          'coordinate': LatLng(50.910768, 11.576707),
          'variables': {'Y': '2'}
        },{
          'coordinate': LatLng(50.910678, 11.576835),
          'variables': {'Y': '3'}
        }]
      },
      {'text': 'N 50 54.216 E 011 35.215', 'values': {'Y': '1-10'},
        'projectionData': {
          'bearing': '318',
          'distance': '1100 - 13.45 × A',
          'lengthUnit': UNITCATEGORY_LENGTH.defaultUnit,
          'ellipsoid': getEllipsoidByName('WGS84')
        },
        'expectedOutput': []
      },
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}, values: ${elem['values']}, projectionData: ${elem['projectionData']}', () {
        var _actual = parseVariableLatLon(elem['text'], elem['values'], projectionData: elem['projectionData']);

        List<Map<String, dynamic>> _actualCoords = _actual['coordinates'];
        expect(_actualCoords.length, elem['expectedOutput'].length);
        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord['coordinate'], elem['expectedOutput'][index]['coordinate']));
          expect(actualCoord['variables'], elem['expectedOutput'][index]['variables']);
        });
        // expect(_actual['leftPadCoordinates'], elem['expectedOutput']['leftPadCoordinates']);
      });
    });
  });

  group("Parser.variableLatLon.parseVariableLatLonWithLeftPadAndReplaceE:", () {
    final expectedLatLngList = {
      'coordinates': [
        {
          'variables': {'E': '5'},
          'coordinate': LatLng(52.50205,11.342333333333332)
        }
      ],
      'leftPadCoordinates': [
        {
          'variables': {'E': '5'},
          'coordinate': LatLng(52.50205, 11.334233333333334)
        }
      ]
    };

    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': 'N 52° 30.123 E 11° [20.E4]', 'values': {'E': '5'}, 'expectedOutput': expectedLatLngList},
      {'text': 'N 52° 30.123 E 12', 'values': {'E': '5'}, 'expectedOutput':  {'coordinates': [{'variables': {'E': '5'}, 'coordinate': LatLng(52.50205, 5.2)}],'leftPadCoordinates': [{'variables': {'E': '5'},'coordinate': LatLng(52.50205, 5.2)}]}},
      {'text': '52° 30.123 11° 20.E4', 'values': {'E': '5'}, 'expectedOutput': expectedLatLngList},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}, values: ${elem['values']}, projectionData: ${elem['projectionData']}', () {
        var _actual = parseVariableLatLon(elem['text'], elem['values'], projectionData: elem['projectionData']);

        List<Map<String, dynamic>> _actualCoords = _actual['coordinates'];
        expect(_actualCoords.length, 1);
        var _expectedCoords = elem['expectedOutput']['coordinates'];
        _actualCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord['coordinate'], _expectedCoords[index]['coordinate']));
          expect(actualCoord['variables'], _expectedCoords[index]['variables']);
        });

        List<Map<String, dynamic>> _actualLeftPadCoords = _actual['leftPadCoordinates'];
        expect(_actualCoords.length, 1);
        var _expectedLeftPadCoords = elem['expectedOutput']['leftPadCoordinates'];
        _actualLeftPadCoords.asMap().forEach((index, actualCoord) {
          expect(true, equalsLatLng(actualCoord['coordinate'], _expectedLeftPadCoords[index]['coordinate']));
          expect(actualCoord['variables'], _expectedCoords[index]['variables']);
        });
      });
    });
  });
}