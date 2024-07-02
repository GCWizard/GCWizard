import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/bosch/logic/bosch.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.bosch.latLonToBosch:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': const LatLng(89.99999, 179.99999), 'expectedOutput': '999999999'},
      {'coord': const LatLng(-89.99999, 179.99999), 'expectedOutput': 'IFFFFFFFF'},
      {'coord': const LatLng(89.99999, -179.99999), 'expectedOutput': '144444444'},
      {'coord': const LatLng(-89.99999, -179.99999), 'expectedOutput': 'AAAAAAAAA'},

      {'coord': const LatLng(90, 180), 'expectedOutput': '99999999999'},
      {'coord': const LatLng(-90, 180), 'expectedOutput': 'IFFFFFFFFFF'},
      {'coord': const LatLng(90, -180), 'expectedOutput': '14444444444'},
      {'coord': const LatLng(-90, -180), 'expectedOutput': 'AAAAAAAAAAA'},

      {'coord': const LatLng(52.51611, 13.37694), 'expectedOutput': '5LAABO03'},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = BoschCoordinate.fromLatLon(elem['coord'] as LatLng).toString();
        expect(true, _actual.startsWith(elem['expectedOutput'].toString()));
      });
    }
  });

  group("Converter.bosch.boschToLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': const LatLng(89.99999, 179.99999), 'input': '999999999'},
      {'expectedOutput': const LatLng(-89.99999, 179.99999), 'input': 'IFFFFFFFF'},
      {'expectedOutput': const LatLng(89.99999, -179.99999), 'input': '144444444'},
      {'expectedOutput': const LatLng(-89.99999, -179.99999), 'input': 'AAAAAAAAA'},

      {'expectedOutput': const LatLng(90, 180), 'input': '99999999999'},
      {'expectedOutput': const LatLng(-90, 180), 'input': 'IFFFFFFFFFF'},
      {'expectedOutput': const LatLng(90, -180), 'input': '14444444444'},
      {'expectedOutput': const LatLng(-90, -180), 'input': 'AAAAAAAAAAA'},

      {'expectedOutput': const LatLng(52.51611, 13.37694), 'input': '5LAABO03'},

      {'expectedOutput': null, 'input': '5LAABO03%'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = BoschCoordinate.parse(elem['input'].toString())?.toLatLng();

        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect(equalsLatLng(_actual, elem['expectedOutput'] as LatLng, tolerance: 1e-4), true);
        }
      });
    }
  });
}