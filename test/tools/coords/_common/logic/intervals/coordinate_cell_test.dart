import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/coordinate_cell.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("CoordinateCell.bearingTo_[-10,10],[-10,10]:", () {
    CoordinateCell cell = CoordinateCell(
        latInterval: Interval(a: degToRadian(-10.0), b: degToRadian(10.0)),
        lonInterval: Interval(a: degToRadian(-10.0), b: degToRadian(10.0)),
        ellipsoid: Ellipsoid.WGS84
    );

    List<Map<String, Object?>> _inputsToExpected = [
      //Points within cell
      // {'point': const LatLng(0.0, 0.0), 'expectedOutput': [0, 360]},
      // {'point': const LatLng(2.0, 2.0), 'expectedOutput': [0, 360]},
      // {'point': const LatLng(2.0, -2.0), 'expectedOutput': [0, 360]},
      // {'point': const LatLng(-2.0, 2.0), 'expectedOutput': [0, 360]},
      // {'point': const LatLng(-2.0, -2.0), 'expectedOutput': [0, 360]},
      //
      // //Point on edges
      {'point': const LatLng(10.0, 2.0), 'expectedOutput': [270, 448]},
      // {'point': const LatLng(10.0, -2.0), 'expectedOutput': [271, 449]},
      // {'point': const LatLng(10.0, 0.0), 'expectedOutput': [270, 449]},
      // {'point': const LatLng(-10.0, 2.0), 'expectedOutput': [91, 269]},
      // {'point': const LatLng(-10.0, -2.0), 'expectedOutput': [90, 268]},
      // {'point': const LatLng(-10.0, 0.0), 'expectedOutput': [90, 269]},
      // {'point': const LatLng(2.0, 10.0), 'expectedOutput': [360, 540]},
      // {'point': const LatLng(-2.0, 10.0), 'expectedOutput': [360, 540]},
      // {'point': const LatLng(0.0, 10.0), 'expectedOutput': [360, 540]},
      // {'point': const LatLng(2.0, -10.0), 'expectedOutput': [180, 360]},
      // {'point': const LatLng(-2.0, -10.0), 'expectedOutput': [180, 360]},
      // {'point': const LatLng(0.0, -10.0), 'expectedOutput': [180, 360]},
      //
      // //Points on corners
      // {'point': const LatLng(-10.0, -10.0), 'expectedOutput': [180, 268]},
      // {'point': const LatLng(10.0, 10.0), 'expectedOutput': [360, 448]},
      // {'point': const LatLng(10.0, -10.0), 'expectedOutput': [271, 360]},
      // {'point': const LatLng(-10.0, 10.0), 'expectedOutput': [91, 180]},
      //
      // //Points around the cell
      // {'point': const LatLng(0.0, 12.0), 'expectedOutput': [11, 168]},
      // {'point': const LatLng(2.0, 12.0), 'expectedOutput': [9, 165]},
      // {'point': const LatLng(-2.0, 12.0), 'expectedOutput': [14, 170]},
      // {'point': const LatLng(-10.0, 12.0), 'expectedOutput': [90, 174]},
      // {'point': const LatLng(-12.0, 12.0), 'expectedOutput': [97, 174]},
      // {'point': const LatLng(-12.0, 10.0), 'expectedOutput': [97, 180]},
      // {'point': const LatLng(-12.0, 0.0), 'expectedOutput': [102, 257]},
      // {'point': const LatLng(-12.0, 2.0), 'expectedOutput': [100, 255]},
      // {'point': const LatLng(-12.0, -2.0), 'expectedOutput': [104, 259]},
      // {'point': const LatLng(-12.0, -10.0), 'expectedOutput': [180, 262]},
      // {'point': const LatLng(-12.0, -12.0), 'expectedOutput': [185, 262]},
      // {'point': const LatLng(-10.0, -12.0), 'expectedOutput': [185, 269]},
      // {'point': const LatLng(0.0, -12.0), 'expectedOutput': [191, 348]},
      // {'point': const LatLng(2.0, -12.0), 'expectedOutput': [194, 350]},
      // {'point': const LatLng(-2.0, -12.0), 'expectedOutput': [189, 345]},
      // {'point': const LatLng(10.0, -12.0), 'expectedOutput': [270, 354]},
      // {'point': const LatLng(12.0, -12.0), 'expectedOutput': [277, 354]},
      // {'point': const LatLng(12.0, -10.0), 'expectedOutput': [277, 360]},
      // {'point': const LatLng(12.0, 0.0), 'expectedOutput': [282, 437]},
      // {'point': const LatLng(12.0, 2.0), 'expectedOutput': [284, 439]},
      // {'point': const LatLng(12.0, -2.0), 'expectedOutput': [280, 435]},
      // {'point': const LatLng(12.0, 10.0), 'expectedOutput': [360, 442]},
      // {'point': const LatLng(12.0, 12.0), 'expectedOutput': [5, 82]},
      // {'point': const LatLng(10.0, 12.0), 'expectedOutput': [5, 89]},
    ];

    for (var elem in _inputsToExpected) {
      test('point: ${elem['point']}', () {
        var _actualDouble = cell.bearingTo(elem['point'] as LatLng);
        var _actual = [
          _actualDouble.a.floor(),
          _actualDouble.b.floor()
        ];
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}