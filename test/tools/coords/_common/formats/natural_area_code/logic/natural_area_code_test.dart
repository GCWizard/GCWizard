import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/logic/natural_area_code.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  // Mark test
  group("Converter.naturalAreaCode.latlonToNaturalAreaCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': const LatLng(51.907002, 9.113159), 'expectedOutput': NaturalAreaCodeCoordinate('HQRGL6Z7', 'RMJ1H830')},

      {'coord': const LatLng(0.0, 0.0), 'expectedOutput': NaturalAreaCodeCoordinate('H0000000', 'H0000000')},
      {'coord': const LatLng(89.99999, 179.99999), 'expectedOutput': NaturalAreaCodeCoordinate('ZZZZZ9QH', 'ZZZZXMGZ')},
      {'coord': const LatLng(-89.99999, 179.99999), 'expectedOutput': NaturalAreaCodeCoordinate('ZZZZZ9QH', '00001BH0')},
      {'coord': const LatLng(89.99999, -179.99999), 'expectedOutput': NaturalAreaCodeCoordinate('00000N7H', 'ZZZZXMGZ')},
      {'coord': const LatLng(-89.99999, -179.99999), 'expectedOutput': NaturalAreaCodeCoordinate('00000N7H', '00001BH0')},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = NaturalAreaCodeCoordinate.fromLatLon(elem['coord'] as LatLng);
        expect(_actual.x, (elem['expectedOutput'] as NaturalAreaCodeCoordinate).x);
        expect(_actual.y, (elem['expectedOutput'] as NaturalAreaCodeCoordinate).y);
      });
    }
  });

  group("Converter.naturalAreaCode.naturalAreaCodeToLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': const LatLng(51.907002, 9.113159), 'nac': NaturalAreaCodeCoordinate('HQRGL6Z7', 'RMJ1H830')},

      {'expectedOutput': const LatLng(0.0, 0.0), 'nac': NaturalAreaCodeCoordinate('H0000000', 'H0000000')},
      {'expectedOutput': const LatLng(89.99999, 179.99999), 'nac': NaturalAreaCodeCoordinate('ZZZZZ9QH', 'ZZZZXMGZ')},
      {'expectedOutput': const LatLng(-89.99999, 179.99999), 'nac': NaturalAreaCodeCoordinate('ZZZZZ9QH', '00001BH0')},
      {'expectedOutput': const LatLng(89.99999, -179.99999), 'nac': NaturalAreaCodeCoordinate('00000N7H', 'ZZZZXMGZ')},
      {'expectedOutput': const LatLng(-89.99999, -179.99999), 'nac': NaturalAreaCodeCoordinate('00000N7H', '00001BH0')},

      {'expectedOutput': const LatLng(0.0, 0.0), 'nac': NaturalAreaCodeCoordinate('H0000000', 'H0000000')},
      {'expectedOutput': const LatLng(89.99998999972564, 179.99999000000003), 'nac': NaturalAreaCodeCoordinate('ZZZZZ9QH', 'ZZZZXMGZ')},
      {'expectedOutput': const LatLng(-89.99999, 179.99999000000003), 'nac': NaturalAreaCodeCoordinate('ZZZZZ9QH', '00001BH0')},
      {'expectedOutput': const LatLng(89.99998999972564, -179.99999), 'nac': NaturalAreaCodeCoordinate('00000N7H', 'ZZZZXMGZ')},
      {'expectedOutput': const LatLng(-89.99999, -179.99999), 'nac': NaturalAreaCodeCoordinate('00000N7H', '00001BH0')},
    ];

    for (var elem in _inputsToExpected) {
      test('nac: ${elem['nac']}', () {
        var _actual = (elem['nac'] as NaturalAreaCodeCoordinate?)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - (elem['expectedOutput'] as LatLng).latitude).abs() < 1e-4, true);
          expect((_actual.longitude - (elem['expectedOutput'] as LatLng).longitude).abs() < 1e-4, true);
        }
      });
    }
  });

  group("Converter.natural_area_code.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'K3ZVLFSSQP1MKBNZ', 'expectedOutput': null},
      {'text': 'K3ZVLFSS QP1MKBNZ', 'expectedOutput': {'format': CoordinateFormatKey.NATURAL_AREA_CODE, 'coordinate': const LatLng(46.2110174566, 025.598495717)}},
      {'text': 'X: K3ZVLFSS Y: QP1MKBNZ', 'expectedOutput': {'format': CoordinateFormatKey.NATURAL_AREA_CODE, 'coordinate': const LatLng(46.2110174566, 025.598495717)}},
      {'text': 'X:K3ZVLFSS Y:QP1MKBNZ', 'expectedOutput': {'format': CoordinateFormatKey.NATURAL_AREA_CODE, 'coordinate': const LatLng(46.2110174566, 025.598495717)}},
      {'text': 'X K3ZVLFSS Y QP1MKBNZ', 'expectedOutput': {'format': CoordinateFormatKey.NATURAL_AREA_CODE, 'coordinate': const LatLng(46.2110174566, 025.598495717)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = NaturalAreaCodeCoordinate.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        }
      });
    }
  });
}