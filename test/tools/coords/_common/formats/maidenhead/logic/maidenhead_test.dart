import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/maidenhead/logic/maidenhead.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.maidenhead.latlonToMaidenhead:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': const LatLng(89.99999, 179.99999), 'expectedOutput': 'RR99XX99XX99RK01'},
      {'coord': const LatLng(-89.99999, 179.99999), 'expectedOutput': 'RA90XA90XA90RN08'},
      {'coord': const LatLng(89.99999, -179.99999), 'expectedOutput': 'AR09AX09AX09GK91'},
      {'coord': const LatLng(-89.99999, -179.99999), 'expectedOutput': 'AA00AA00AA00GN98'},

      {'coord': const LatLng(50.6569, 11.35443333), 'expectedOutput': 'JO50QP27MP77QK35'},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = MaidenheadCoordinate.fromLatLon(elem['coord'] as LatLng).toString();
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Converter.maidenhead.maidenheadToLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': null, 'coord': ''},
      {'expectedOutput': null, 'coord': 'ÖD31365480657013431886'},
      {'expectedOutput': const LatLng(89.99999, 179.99999), 'coord': 'RR99XX99XX99RK01'},
      {'expectedOutput': const LatLng(-89.99999, 179.99999), 'coord': 'RA90XA90XA90RN08'},
      {'expectedOutput': const LatLng(89.99999, -179.99999), 'coord': 'AR09AX09AX09GK91'},
      {'expectedOutput': const LatLng(-89.99999, -179.99999), 'coord': 'AA00AA00AA00GN98'},

      {'expectedOutput': const LatLng(50.6569, 11.35443333), 'coord': 'JO50QP27MP77QK35'},
      {'expectedOutput': const LatLng(46.2110242332, 025.5985060764), 'coord': 'KN26TF10TP64XX49'},
      {'expectedOutput': const LatLng(46.2110242332, 025.5985060764), 'coord': 'kn26tf10tp64xx49'},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = MaidenheadCoordinate.parse(elem['coord'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - (elem['expectedOutput'] as LatLng).latitude).abs() < 1e-4, true);
          expect((_actual.longitude - (elem['expectedOutput'] as LatLng).longitude).abs() < 1e-4, true);
        }
      });
    }
  });

}