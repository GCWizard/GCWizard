import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/resection/logic/resection.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  // Visualization: https://flopp.net/?c=70.672448:-11.564522&z=2&t=OSM&f=&m=A:49.664727:10.799873:0:A:FF0000*B:49.671282:10.805108:0:B:00FF00*C:49.673892:10.813176:0:C:0000FF*D:-45.917011:75.168090:0:D:FFFF00*E:-39.905793:79.628539:0:E:FF00FF*F:-45.182285:84.698730:0:F:00FFFF*G:-41.129287:70.378051:0:G:FFFFFF*H:45.611249:-105.280707:0:H:FF0000*I:49.678879:10.792528:0:I:00FF00*J:-49.593868:-169.164903:0:J:0000FF*K:0.844036:174.949591:0:K:FFFF00*L:49.678865:10.792505:0:L:FF00FF*M:49.660435:10.821665:0:M:00FFFF*N:38.641149:-12.850702:0:N:FFFFFF*O:-11.277231:-178.876092:0:O:FF0000*P:-7.244463:-179.689081:0:P:00FF00*Q:5.318914:-0.373216:0:Q:0000FF*R:51.809541:17.594238:0:R:FFFF00*S:49.838948:16.539551:0:S:FF00FF*T:52.242173:19.989258:0:T:00FFFF*U:53.963431:16.264892:0:U:FFFFFF*V:-0.969712:-63.887798:0:V:FF0000*W:21.532052:24.793687:0:W:00FF00*X:-0.384776:-62.428145:0:X:0000FF*Y:-0.969755:-63.887953:0:Y:FFFF00*Z:84.321622:22.009697:0:Z:FF00FF*A1:84.898956:102.341728:0:A1:00FFFF*B1:83.361472:-83.213752:0:B1:FFFFFF*C1:79.532344:-143.927803:0:C1:FF0000&d=M:A*M:B*M:C*I:A*I:B*I:C*D:G*D:E*D:F*H:G*H:E*H:F*J:B*P:K*P:N*P:O*R:S*R:T*R:U*Y:X*Y:W*Y:V*Z:A1*Z:B1*Z:C1
  group("Resection.resection:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord1': LatLng(-41.129287, 70.378051), 'angle12': 67.9, 'coord2': LatLng(-39.905793, 79.628539), 'angle23': 57.0, 'coord3': LatLng(-45.182285, 84.698730),
        'expectedOutput': [
          LatLng(-45.915268, 75.165365),
          LatLng(45.611249, -105.280707)
        ]},
      {'coord1': LatLng(49.6647, 10.7999), 'angle12': 28.5, 'coord2': LatLng(49.6713, 10.8051), 'angle23': 22.5, 'coord3': LatLng(49.6739, 10.8132),
        'expectedOutput': [
          LatLng(49.660435, 10.821665),
          LatLng(49.678865, 10.792505),
          LatLng(-49.445364, -169.194801),
          LatLng(-49.657084, -168.78753),
          LatLng(-49.678912, -168.817342),
          LatLng(-49.889824, -169.195246),
          LatLng(-49.660435, -169.568451),
          LatLng(-49.680072, -169.599516)
        ]
      },
      {'coord1': LatLng(53.963431, 16.264892), 'angle12': 141.0, 'coord2': LatLng(49.838948, 16.539551), 'angle23': 126.4, 'coord3': LatLng(52.242173, 19.989258),
        'expectedOutput': [
          LatLng(51.808181, 17.591589)
        ]},
      {'coord1': LatLng(-0.384776 ,-62.428145), 'angle12': 0.2, 'coord2': LatLng(21.532052, 24.793687), 'angle23': 6.2, 'coord3': LatLng(-0.969755 ,- 63.887953),
        'expectedOutput': [
          LatLng(-0.970677, -63.891305)
        ]},
      {'coord1': LatLng(84.898956, 102.341728), 'angle12': 55.5, 'coord2': LatLng(79.532344 ,-143.927803), 'angle23': 31.8, 'coord3': LatLng(83.361472, -83.213752),
        'expectedOutput': [
          LatLng(84.325817, 22.219325),
          LatLng(-84.321398, -157.797258),
        ]},
      {'coord1': LatLng(0.844036, 174.949591), 'angle12': 52.5, 'coord2': LatLng(38.641149, -12.850702), 'angle23': 150.1, 'coord3': LatLng(-11.277231, -178.876092),
        'expectedOutput': [
          LatLng(-7.221408, -179.696681),
          LatLng(5.292156, -0.384757)
        ]},
    ];

    for (var elem in _inputsToExpected) {
      test('coord1: ${elem['coord1']}, angle12: ${elem['angle12']}, coord2: ${elem['coord2']}, angle23: ${elem['angle23']}, coord3: ${elem['coord3']}', () {
        var actual = resection(elem['coord1'] as LatLng, elem['angle12'] as double, elem['coord2'] as LatLng, elem['angle23'] as double, elem['coord3'] as LatLng, getEllipsoidByName(ELLIPSOID_NAME_WGS84)!);
        List<LatLng> expected = elem['expectedOutput'] as List<LatLng>;
        expect(actual.length, expected.length);
        for (int i = 0; i < actual.length; i++) {
          expect(equalsLatLng(actual[i], expected[i], tolerance: 1e-5), true);
        }
      });
    }
  });
}