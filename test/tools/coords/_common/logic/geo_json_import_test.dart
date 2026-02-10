import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/geo_json_import.dart';
import 'package:prefs/prefs.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("Coordinates.geoJsonImport:", () {
    var baseStructure =
    '''{
       "type": "FeatureCollection",
       "features": [{
           "type": "Feature",
           "geometry": testReplacement,
           "properties": {
               "prop0": "value0"
           }
       }]
      }''';

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedPointOutput' : null, 'expectedLinesOutput' : null},
      {'input' :   '''{
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [125.6, 10.1]
          },
          "properties": {
            "name": "Dinagat Islands"
          }
        }''', 'expectedPointOutput' : 1, 'expectedLinesOutput' : 0},
      {'input' : '''{
         "type": "Point",
         "coordinates": [100.0, 0.0]
        }''', 'expectedPointOutput' : 1, 'expectedLinesOutput' : 0},
      {'input' : '''{
         "type": "LineString",
         "coordinates": [
             [100.0, 0.0],
             [101.0, 1.0]
         ]
        }''', 'expectedPointOutput' : 2, 'expectedLinesOutput' : 1},
      {'input' : '''{
         "type": "Polygon",
         "coordinates": [
             [
                 [100.0, 0.0],
                 [101.0, 0.0],
                 [101.0, 1.0],
                 [100.0, 1.0],
                 [100.0, 0.0]
             ]
         ]
        }''', 'expectedPointOutput' : 4, 'expectedLinesOutput' : 1},
      {'input' : '''{
         "type": "Polygon",
         "coordinates": [
             [
                 [100.0, 0.0],
                 [101.0, 0.0],
                 [101.0, 1.0],
                 [100.0, 1.0],
                 [100.0, 0.0]
             ],
             [
                 [100.8, 0.8],
                 [100.8, 0.2],
                 [100.2, 0.2],
                 [100.2, 0.8],
                 [100.8, 0.8]
             ]
         ]
        }''', 'expectedPointOutput' : 8, 'expectedLinesOutput' : 2},
      {'input' : '''{
         "type": "MultiPolygon",
         "coordinates": [
             [
                 [
                     [180.0, 40.0], [180.0, 50.0], [170.0, 50.0],
                     [170.0, 40.0], [180.0, 40.0]
                 ]
             ],
             [
                 [
                     [-170.0, 40.0], [-170.0, 50.0], [-180.0, 50.0],
                     [-180.0, 40.0], [-170.0, 40.0]
                 ]
             ]
         ]
        }''', 'expectedPointOutput' : 8, 'expectedLinesOutput' : 2},
      {'input' : '''{
         "type": "MultiPolygon",
         "coordinates": [
             [
                 [
                     [102.0, 2.0],
                     [103.0, 2.0],
                     [103.0, 3.0],
                     [102.0, 3.0],
                     [102.0, 2.0]
                 ]
             ],
             [
                 [
                     [100.0, 0.0],
                     [101.0, 0.0],
                     [101.0, 1.0],
                     [100.0, 1.0],
                     [100.0, 0.0]
                 ],
                 [
                     [100.2, 0.2],
                     [100.2, 0.8],
                     [100.8, 0.8],
                     [100.8, 0.2],
                     [100.2, 0.2]
                 ]
             ]
         ]
        }''', 'expectedPointOutput' : 12, 'expectedLinesOutput' : 3},
      {'input' : '''{
         "type": "MultiPoint",
         "coordinates": [
             [100.0, 0.0],
             [101.0, 1.0]
         ]
        }''', 'expectedPointOutput' : 2, 'expectedLinesOutput' : 0},
      {'input' : '''{
         "type": "MultiLineString",
         "coordinates": [
             [
                 [100.0, 0.0],
                 [101.0, 1.0]
             ],
             [
                 [102.0, 2.0],
                 [103.0, 3.0]
             ]
         ]
        }''', 'expectedPointOutput' : 4, 'expectedLinesOutput' : 2},
      {'input' : '''{
       "type": "FeatureCollection",
       "features": [{
           "type": "Feature",
           "title": "testname1",
           "geometry": {
               "type": "Point",
               "coordinates": [102.0, 0.5]
           },
           "properties": {
               "prop0": "value0"
           }
       }, {
           "type": "Feature",
           "geometry": {
               "type": "LineString",
               "coordinates": [
                   [102.0, 0.0],
                   [103.0, 1.0],
                   [104.0, 0.0],
                   [105.0, 1.0]
               ]
           },
           "properties": {
               "title": "testname2",
               "prop1": 0.0
           }
       }, {
           "type": "Feature",
           "geometry": {
               "type": "Polygon",
               "coordinates": [
                   [
                       [100.0, 0.0],
                       [101.0, 0.0],
                       [101.0, 1.0],
                       [100.0, 1.0],
                       [100.0, 0.0]
                   ]
               ]
           },
           "properties": {
               "prop0": "value0",
               "prop1": {
                   "this": "that"
               }
           }
       }]
      }''', 'expectedPointOutput' : 9, 'expectedLinesOutput' : 2},
      {'input' : '''{
         "type": "GeometryCollection",
         "geometries": [{
             "type": "Point",
             "coordinates": [100.0, 0.0]
         }, {
             "type": "LineString",
             "coordinates": [
                 [101.0, 0.0],
                 [102.0, 1.0]
             ]
         }]
        }''', 'expectedPointOutput' : 3, 'expectedLinesOutput' : 1},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var input = elem['input'].toString();
        if (input.isNotEmpty && !input.contains('Feature') && !input.contains('GeometryCollection')) {
          input = baseStructure.replaceAll('testReplacement', input);
        }
        var _actual = GeoJsonReader().parse(input);
        expect(_actual?.points.length, elem['expectedPointOutput']);
        expect(_actual?.polylines.length, elem['expectedLinesOutput']);
      });
    }
  });
}
