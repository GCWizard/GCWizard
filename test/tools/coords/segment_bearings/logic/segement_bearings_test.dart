import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {

  group("SegmentBearings.segmentBearings:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 20.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(0.0087355383, 0.0023250111)], 5)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 20.0, 'distance': 1000.0, 'countSegments': 3, 'expectedOutput': SegmentedAngle([LatLng(0.0087999208, 0.0020716576), LatLng(0.0086637647, 0.0025763973)], 3.3333333333333)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 20.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 10.0)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 20.0, 'distance': 1000.0, 'countSegments': 0, 'expectedOutput': SegmentedAngle([], 10.0)},

      {'coord': LatLng(0,0), 'bearing1': 20.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.0087355383, -0.0023250111)], 175)},
      {'coord': LatLng(0,0), 'bearing1': 20.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 3, 'expectedOutput': SegmentedAngle([LatLng(-0.0065781452, 0.0061646135), LatLng(-0.0025937609, -0.0086057662)], 116.6666666666667)},

      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 370.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 370.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 730.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 730.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 370.0, 'bearing2': 730.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 730.0, 'bearing2': 370.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 360.0)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 730.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.008906300724040118, -0.0015599081330606168)], 180.0)},
      {'coord': LatLng(0,0), 'bearing1': 730.0, 'bearing2': 370.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.008906300724040118, -0.0015599081330606168)], 180.0)},

      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 360.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 350.0)},
      {'coord': LatLng(0,0), 'bearing1': 360.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 10.0)},
      {'coord': LatLng(0,0), 'bearing1': 0.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 10.0)},
      {'coord': LatLng(0,0), 'bearing1': 10.0, 'bearing2': 350.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 340.0)},
      {'coord': LatLng(0,0), 'bearing1': 350.0, 'bearing2': 10.0, 'distance': 1000.0, 'countSegments': 1, 'expectedOutput': SegmentedAngle([], 20.0)},

      {'coord': LatLng(0,0), 'bearing1': 0.0, 'bearing2': 360.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 180)},
      {'coord': LatLng(0,0), 'bearing1': 0.0, 'bearing2': 720.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 180)},
      {'coord': LatLng(0,0), 'bearing1': 0.0, 'bearing2': 710.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009009280780508087, 0.0007829333644995645)], 175)},
      {'coord': LatLng(0,0), 'bearing1': 0.0, 'bearing2': 730.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(0.009009280780508087, 0.0007829333644995645)], 5)},
      {'coord': LatLng(0,0), 'bearing1': 360.0, 'bearing2': 0.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 180)},
      {'coord': LatLng(0,0), 'bearing1': 720.0, 'bearing2': 0.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 180)},
      {'coord': LatLng(0,0), 'bearing1': 710.0, 'bearing2': 0.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(0.009009280780508087, -0.0007829333645190673)], 5)},
      {'coord': LatLng(0,0), 'bearing1': 350.0, 'bearing2': 0.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(0.009009280780508087, -0.0007829333645190673)], 5)},
      {'coord': LatLng(0,0), 'bearing1': 730.0, 'bearing2': 0.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009009280780508087, -0.0007829333645190673)], 175)},
      {'coord': LatLng(0,0), 'bearing1': 0.0, 'bearing2': 0.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 180)},
      {'coord': LatLng(0,0), 'bearing1': 360.0, 'bearing2': 360.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 180)},

      {'coord': LatLng(0,0), 'bearing1': 359.0, 'bearing2': 359.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009042317371220963, 0.0001567776357656623)], 180)},
      {'coord': LatLng(0,0), 'bearing1': 358.0, 'bearing2': 359.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(0.009040595721398335, -0.00023515152952313656)], 0.5)},
      {'coord': LatLng(0,0), 'bearing1': 359.0, 'bearing2': 358.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009040595721398335, 0.00023515152950415738)], 179.5)},
      {'coord': LatLng(0,0), 'bearing1': 359.0, 'bearing2': 1.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(0.009043694769749644, 0.0)], 1.0)},
      {'coord': LatLng(0,0), 'bearing1': 1.0, 'bearing2': 359.0, 'distance': 1000.0, 'countSegments': 2, 'expectedOutput': SegmentedAngle([LatLng(-0.009043694769749644, 0.0)], 179.0)},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}, bearing1: ${elem['bearing1']}, bearing2: ${elem['bearing2']}, distance: ${elem['distance']}, countSegments: ${elem['countSegments']},', () {
        var actual = segmentBearings(
          elem['coord'] as LatLng,
          elem['bearing1'] as double,
          elem['bearing2'] as double,
          elem['distance'] as double,
          elem['countSegments'] as int,
          Ellipsoid.WGS84
        );

        expect(equalsLatLngList(actual.points, (elem['expectedOutput'] as SegmentedAngle).points, tolerance: 1e-5), true);
        expect(doubleEquals(actual.segmentAngle, (elem['expectedOutput'] as SegmentedAngle).segmentAngle, tolerance: 1e-5), true);
      });
    }
  });
}