import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/dfcigrid/logic/dfcigrid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  List<Map<String, Object?>> _inputsToExpected = [
    {'text': '', 'coord': null},
    {'text': 'HG00E7.3', 'coord': {'format': CoordinateFormatKey.DFCI_GRID, 'coordinate': const LatLng(46.02186228161046, 3.750783779014269)}},
    {'text': 'HG00D7.4', 'coord': {'format': CoordinateFormatKey.DFCI_GRID, 'coordinate': const LatLng(46.02234102, 3.71204547)}},
    {'text': 'BN08K5.3', 'coord': {'format': CoordinateFormatKey.DFCI_GRID, 'coordinate': const LatLng(51.01752887368988, -4.53000792821288)}},
    {'text': 'NB80L0.2', 'coord': {'format': CoordinateFormatKey.DFCI_GRID, 'coordinate': const LatLng(41.17705845237614, 9.458606982435517)}},
    {'text': 'GL02C3.1', 'coord': {'format': CoordinateFormatKey.DFCI_GRID, 'coordinate': const LatLng(48.845837464134796, 2.3977834702545584)}},
  ];

  group("Converter.dfcigrid.parseLatLon:", () {
    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {

        var _actual = DfciGridCoordinate.parse(elem['text'] as String);
        if (_actual == null) {
          expect(null, elem['coord']);
        } else {
          expect((_actual.latitude - ((elem['coord'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['coord'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        }
      });
    }
  });

  group("Converter.dfcigrid.fromLatLon:", () {
    for (var elem in _inputsToExpected) {
      if (elem['coord'] == null) continue;
      test('coord: ${((elem['coord'] as Map<String, Object>)['coordinate'] as LatLng)}', () {

        var _actual = DfciGridCoordinate.fromLatLon((elem['coord'] as Map<String, Object>)['coordinate'] as LatLng);
        expect(_actual.toString(), elem['text']);
      });
    }
  });
}