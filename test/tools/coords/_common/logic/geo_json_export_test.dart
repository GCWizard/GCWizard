import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/geo_json_export.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("Coordinates.geoJsonExport:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputPoints': <GCWMapPoint>[],
        'inputLines': <GCWMapPolyline>[],
        'expectedOutput': '{"type":"FeatureCollection","features":[]}',
      },
      {
        'inputPoints': <GCWMapPoint>[
          GCWMapPoint(point: LatLng(52.00, 13.00), markerText: '1'),
          GCWMapPoint(point: LatLng(52.00, 13.10)),
          GCWMapPoint(
            point: LatLng(52.10, 13.10),
            markerText: '3',
          ),
          GCWMapPoint(point: LatLng(52.10, 13.00))
        ],
        'inputLines': <GCWMapPolyline>[],
        'expectedOutput':
        '{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[13.0,52.0]},"properties":{"name":"1"}},{"type":"Feature","geometry":{"type":"Point","coordinates":[13.1,52.0]},"properties":{}},{"type":"Feature","geometry":{"type":"Point","coordinates":[13.1,52.1]},"properties":{"name":"3"}},{"type":"Feature","geometry":{"type":"Point","coordinates":[13.0,52.1]},"properties":{}}]}',
      },
      {
        'inputPoints': <GCWMapPoint>[],
        'inputLines': <GCWMapPolyline>[
          GCWMapPolyline(
            points: <GCWMapPoint>[
              GCWMapPoint(point: LatLng(52.30, 13.00), markerText: '1'),
              GCWMapPoint(point: LatLng(52.00, 13.10)),
            ],
          ),
          GCWMapPolyline(
            points: <GCWMapPoint>[
              GCWMapPoint(point: LatLng(52.50, 13.00), markerText: '1'),
              GCWMapPoint(point: LatLng(52.04, 13.10)),
            ],
          ),
        ],
        'expectedOutput':
        '{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"LineString","coordinates":[[13.0,52.3],[13.1,52.0]]},"properties":{}},{"type":"Feature","geometry":{"type":"LineString","coordinates":[[13.0,52.5],[13.1,52.04]]},"properties":{}}]}',
      },
      {
        'inputPoints': <GCWMapPoint>[
          GCWMapPoint(point: LatLng(52.00, 13.00), markerText: '1'),
          GCWMapPoint(point: LatLng(52.00, 13.10)),
          GCWMapPoint(
            point: LatLng(52.10, 13.10),
            markerText: '3',
          ),
          GCWMapPoint(point: LatLng(52.10, 13.00))
        ],
        'inputLines': <GCWMapPolyline>[
          GCWMapPolyline(
            points: <GCWMapPoint>[
              GCWMapPoint(point: LatLng(52.30, 13.00), markerText: '1'),
              GCWMapPoint(point: LatLng(52.00, 13.10)),
            ],
          ),
          GCWMapPolyline(
            points: <GCWMapPoint>[
              GCWMapPoint(point: LatLng(52.50, 13.00), markerText: '1'),
              GCWMapPoint(point: LatLng(52.04, 13.10)),
            ],
          ),
        ],
        'expectedOutput': '{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[13.0,52.0]},"properties":{"name":"1"}},{"type":"Feature","geometry":{"type":"Point","coordinates":[13.1,52.0]},"properties":{}},{"type":"Feature","geometry":{"type":"Point","coordinates":[13.1,52.1]},"properties":{"name":"3"}},{"type":"Feature","geometry":{"type":"Point","coordinates":[13.0,52.1]},"properties":{}},{"type":"Feature","geometry":{"type":"LineString","coordinates":[[13.0,52.3],[13.1,52.0]]},"properties":{}},{"type":"Feature","geometry":{"type":"LineString","coordinates":[[13.0,52.5],[13.1,52.04]]},"properties":{}}]}',
      },
      {
        'inputPoints': <GCWMapPoint>[],
        'inputLines': <GCWMapPolyline>[
          GCWMapPolyline(
            points: <GCWMapPoint>[
              GCWMapPoint(point: LatLng(52.30, 13.00)),
              GCWMapPoint(point: LatLng(52.00, 13.10)),
              GCWMapPoint(point: LatLng(52.30, 13.10)),
              GCWMapPoint(point: LatLng(52.30, 13.00)),
            ],
          ),
        ],
        'expectedOutput':
        '{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[[13.0,52.3],[13.1,52.0],[13.1,52.3],[13.0,52.3]]]},"properties":{}}]}',
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = geoJsonWriter().toJson(
          elem['inputPoints'] as List<GCWMapPoint>,
          elem['inputLines'] as List<GCWMapPolyline>,
        );
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
