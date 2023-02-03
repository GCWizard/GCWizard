import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.maidenhead.latlonToMaidenhead:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coord': LatLng(89.99999, 179.99999), 'expectedOutput': 'RR99XX99XX99RK01'},
      {'coord': LatLng(-89.99999, 179.99999), 'expectedOutput': 'RA90XA90XA90RN08'},
      {'coord': LatLng(89.99999, -179.99999), 'expectedOutput': 'AR09AX09AX09GK91'},
      {'coord': LatLng(-89.99999, -179.99999), 'expectedOutput': 'AA00AA00AA00GN98'},

      {'coord': LatLng(50.6569, 11.35443333), 'expectedOutput': 'JO50QP27MP77QK35'},
    ];

    _inputsToExpected.forEach((elem) {
      test('coord: ${elem['coord']}', () {
        var _actual = Maidenhead.fromLatLon(elem['coord']).toString();
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Converter.maidenhead.maidenheadToLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput': null, 'coord': ''},
      {'expectedOutput': null, 'coord': 'ÖD31365480657013431886'},
      {'expectedOutput': LatLng(89.99999, 179.99999), 'coord': 'RR99XX99XX99RK01'},
      {'expectedOutput': LatLng(-89.99999, 179.99999), 'coord': 'RA90XA90XA90RN08'},
      {'expectedOutput': LatLng(89.99999, -179.99999), 'coord': 'AR09AX09AX09GK91'},
      {'expectedOutput': LatLng(-89.99999, -179.99999), 'coord': 'AA00AA00AA00GN98'},

      {'expectedOutput': LatLng(50.6569, 11.35443333), 'coord': 'JO50QP27MP77QK35'},
      {'expectedOutput': LatLng(46.2110242332, 025.5985060764), 'coord': 'KN26TF10TP64XX49'},
      {'expectedOutput': LatLng(46.2110242332, 025.5985060764), 'coord': 'kn26tf10tp64xx49'},
    ];

    _inputsToExpected.forEach((elem) {
      test('coord: ${elem['coord']}', () {
        var _actual = Maidenhead.parse(elem['coord'])?.toLatLng();
        if (_actual == null)
          expect(null, elem['expectedOutput']);
        else {
          expect((_actual.latitude - elem['expectedOutput'].latitude).abs() < 1e-4, true);
          expect((_actual.longitude - elem['expectedOutput'].longitude).abs() < 1e-4, true);
        }
      });
    });
  });

}