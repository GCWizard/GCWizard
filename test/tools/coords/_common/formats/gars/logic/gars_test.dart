import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/gars/logic/gars.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.gars.latLonToGARS:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': const LatLng(89.99999, 179.99999), 'expectedOutput': '720QZ23'},
      {'coord': const LatLng(-89.99999, 179.99999), 'expectedOutput': '720AA49'},
      {'coord': const LatLng(89.99999, -179.99999), 'expectedOutput': '001QZ11'},
      {'coord': const LatLng(-89.99999, -179.99999), 'expectedOutput': '001AA37'},

      {'coord': const LatLng(90, 180), 'expectedOutput': '720QZ23'},
      {'coord': const LatLng(-90, 180), 'expectedOutput': '720AA49'},
      {'coord': const LatLng(90, -180), 'expectedOutput': '001QZ11'},
      {'coord': const LatLng(-90, -180), 'expectedOutput': '001AA37'},
      {'coord': const LatLng(0, 0), 'expectedOutput': '361HN37'},

      {'coord': const LatLng(29.06757, 63.98863), 'expectedOutput': '488KY49'},
      {'coord': const LatLng(80.297927, -40.429688), 'expectedOutput': '280QE17'},
      {'coord': const LatLng(-38.548165, -68.203125), 'expectedOutput': '224EG21'},
      {'coord': const LatLng(-39.909736, 178.242188), 'expectedOutput': '717EE36'},
      {'coord': const LatLng(41.705729, -79.277344), 'expectedOutput': '202LZ33'},
      {'coord': const LatLng(41.666667, -79.3333333), 'expectedOutput': '202LZ33'},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = GARSCoordinate.fromLatLon(elem['coord'] as LatLng).toString();
        expect(_actual, elem['expectedOutput'].toString());
      });
    }
  });

  group("Converter.gars.garsToLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': const LatLng(89.99999, 179.99999), 'input': '720QZ23'},
      {'expectedOutput': const LatLng(-89.99999, 179.99999), 'input': '720AA49'},
      {'expectedOutput': const LatLng(89.99999, -179.99999), 'input': '001QZ11'},
      {'expectedOutput': const LatLng(-89.99999, -179.99999), 'input': '001AA37'},

      {'expectedOutput': const LatLng(90, 180), 'input': '720QZ23'},
      {'expectedOutput': const LatLng(-90, 180), 'input': '720AA49'},
      {'expectedOutput': const LatLng(90, -180), 'input': '001QZ11'},
      {'expectedOutput': const LatLng(-90, -180), 'input': '001AA37'},
      {'expectedOutput': const LatLng(0, 0), 'input': '361HN37'},

      {'expectedOutput': const LatLng(29.06757, 63.98863), 'input': '488KY49'},
      {'expectedOutput': const LatLng(80.297927, -40.429688), 'input': '280QE17'},
      {'expectedOutput': const LatLng(-38.548165, -68.203125), 'input': '224EG21'},
      {'expectedOutput': const LatLng(-39.909736, 178.242188), 'input': '717EE36'},
      {'expectedOutput': const LatLng(41.705729, -79.277344), 'input': '202LZ33'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = GARSCoordinate.parse(elem['input'].toString())?.toLatLng();

        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect(equalsLatLng(_actual, elem['expectedOutput'] as LatLng, tolerance: 0.0833334), true);
        }
      });
    }
  });
}