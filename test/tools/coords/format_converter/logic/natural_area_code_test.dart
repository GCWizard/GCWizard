import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

void main() {
  // Mark test
  group("Converter.naturalAreaCode.latlonToNaturalAreaCode:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coord': LatLng(51.907002, 9.113159), 'expectedOutput': NaturalAreaCode('HQRGL6Z7', 'RMJ1H830')},

      {'coord': LatLng(0.0, 0.0), 'expectedOutput': NaturalAreaCode('H0000000', 'H0000000')},
      {'coord': LatLng(89.99999, 179.99999), 'expectedOutput': NaturalAreaCode('ZZZZZ9QH', 'ZZZZXMGZ')},
      {'coord': LatLng(-89.99999, 179.99999), 'expectedOutput': NaturalAreaCode('ZZZZZ9QH', '00001BH0')},
      {'coord': LatLng(89.99999, -179.99999), 'expectedOutput': NaturalAreaCode('00000N7H', 'ZZZZXMGZ')},
      {'coord': LatLng(-89.99999, -179.99999), 'expectedOutput': NaturalAreaCode('00000N7H', '00001BH0')},
    ];

    _inputsToExpected.forEach((elem) {
      test('coord: ${elem['coord']}', () {
        var _actual = NaturalAreaCode.fromLatLon(elem['coord']);
        expect(_actual.x, elem['expectedOutput'].x);
        expect(_actual.y, elem['expectedOutput'].y);
      });
    });
  });

  group("Converter.naturalAreaCode.naturalAreaCodeToLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput': LatLng(51.907002, 9.113159), 'nac': NaturalAreaCode('HQRGL6Z7', 'RMJ1H830')},

      {'expectedOutput': LatLng(0.0, 0.0), 'nac': NaturalAreaCode('H0000000', 'H0000000')},
      {'expectedOutput': LatLng(89.99999, 179.99999), 'nac': NaturalAreaCode('ZZZZZ9QH', 'ZZZZXMGZ')},
      {'expectedOutput': LatLng(-89.99999, 179.99999), 'nac': NaturalAreaCode('ZZZZZ9QH', '00001BH0')},
      {'expectedOutput': LatLng(89.99999, -179.99999), 'nac': NaturalAreaCode('00000N7H', 'ZZZZXMGZ')},
      {'expectedOutput': LatLng(-89.99999, -179.99999), 'nac': NaturalAreaCode('00000N7H', '00001BH0')},

      {'expectedOutput': LatLng(0.0, 0.0), 'nac': NaturalAreaCode('H0000000', 'H0000000')},
      {'expectedOutput': LatLng(89.99998999972564, 179.99999000000003), 'nac': NaturalAreaCode('ZZZZZ9QH', 'ZZZZXMGZ')},
      {'expectedOutput': LatLng(-89.99999, 179.99999000000003), 'nac': NaturalAreaCode('ZZZZZ9QH', '00001BH0')},
      {'expectedOutput': LatLng(89.99998999972564, -179.99999), 'nac': NaturalAreaCode('00000N7H', 'ZZZZXMGZ')},
      {'expectedOutput': LatLng(-89.99999, -179.99999), 'nac': NaturalAreaCode('00000N7H', '00001BH0')},
    ];

    _inputsToExpected.forEach((elem) {
      test('nac: ${elem['nac']}', () {
        var _actual = elem['nac']?.toLatLng();
        if (_actual == null)
          expect(null, elem['expectedOutput']);
        else {
          expect((_actual.latitude - elem['expectedOutput'].latitude).abs() < 1e-4, true);
          expect((_actual.longitude - elem['expectedOutput'].longitude).abs() < 1e-4, true);
        }
      });
    });
  });

  group("Converter.natural_area_code.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'K3ZVLFSSQP1MKBNZ', 'expectedOutput': null},
      {'text': 'K3ZVLFSS QP1MKBNZ', 'expectedOutput': {'format': keyCoordsNaturalAreaCode, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'X: K3ZVLFSS Y: QP1MKBNZ', 'expectedOutput': {'format': keyCoordsNaturalAreaCode, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'X:K3ZVLFSS Y:QP1MKBNZ', 'expectedOutput': {'format': keyCoordsNaturalAreaCode, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'X K3ZVLFSS Y QP1MKBNZ', 'expectedOutput': {'format': keyCoordsNaturalAreaCode, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = NaturalAreaCode.parse(elem['text'])?.toLatLng();
        if (_actual == null)
          expect(null, elem['expectedOutput']);
        else {
          expect((_actual.latitude - elem['expectedOutput']['coordinate'].latitude).abs() < 1e-8, true);
          expect((_actual.longitude - elem['expectedOutput']['coordinate'].longitude).abs() < 1e-8, true);
        }
      });
    });
  });
}