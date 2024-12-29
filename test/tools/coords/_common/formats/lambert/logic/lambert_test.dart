import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  List<Map<String, Object?>> _inputsToExpected = [
    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93, 'text': 'X: 700069.8367344924\nY: 12655667.466398649'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93, 'text': 'X: 1213968669890.8623\nY: 963315816005.129'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93, 'text': 'X: 700069.8367204563\nY: 12655667.466416338'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93, 'text': 'X: 1213968425900.6868\nY: 963316123484.8439'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93, 'text': 'X: 1290691.6694699805\nY: 7093499.297327789'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT2008, 'text': 'X: 649357.0864838692\nY: 5899928.628534915'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT2008, 'text': 'X: 2256702877183.2314\nY: 2298996190952.9434'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT2008, 'text': 'X: 649357.0864758879\nY: 5899928.62854275'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT2008, 'text': 'X: 2256702257941.0654\nY: 2298996798804.488'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT2008, 'text': 'X: 1143225.7408677062\nY: 672869.2624144716'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT72, 'text': 'X: 150029.10278072392\nY: 5400118.066289277'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT72, 'text': 'X: 2256958628693.345\nY: 2298744579393.1987'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT72, 'text': 'X: 150029.1027727434\nY: 5400118.066297115'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT72, 'text': 'X: 2256958009518.8125\nY: 2298745187313.77'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT72, 'text': 'X: 643315.5167699516\nY: 173003.76416015922'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.ETRS89LCC, 'text': 'X: 4000028.0945213186\nY: 7701444.002666069'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.ETRS89LCC, 'text': 'X: 2461374937477.2266\nY: 2201876602577.6567'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.ETRS89LCC, 'text': 'X: 4000028.094514516\nY: 7701444.002673674'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.ETRS89LCC, 'text': 'X: 2461374341520.978\nY: 2201877268770.3574'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.ETRS89LCC, 'text': 'X: 4092480.2555230022\nY: 2656549.912640821'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC42, 'text': 'X: 1700202.8480968622\nY: 8293577.363918985'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC42, 'text': 'X: 563036591212.4438\nY: 304942501678.09357'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC42, 'text': 'X: 1700202.8480712012\nY: 8293577.363966365'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC42, 'text': 'X: 563036519986.6844\nY: 304942633190.3193'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC42, 'text': 'X: 2296910.4231684958\nY: 2195149.212339973'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC43, 'text': 'X: 1700159.5365392622\nY: 9049699.455688842'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC43, 'text': 'X: 672708100803.4219\nY: 399706070715.4419'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC43, 'text': 'X: 1700159.5365166953\nY: 9049699.455726823'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC43, 'text': 'X: 672708005647.839\nY: 399706230866.12854'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC43, 'text': 'X: 2295285.769868992\nY: 3083371.2733549913'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC44, 'text': 'X: 1700125.7791516287\nY: 9814773.244567888'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC44, 'text': 'X: 800284002922.3785\nY: 518887264203.567'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC44, 'text': 'X: 1700125.7791318535\nY: 9814773.244598389'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC44, 'text': 'X: 800283877100.5214\nY: 518887458262.8364'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC44, 'text': 'X: 2293869.7495098244\nY: 3971850.1982128564'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC45, 'text': 'X: 1700099.4109020806\nY: 10588177.898440247'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC45, 'text': 'X: 947877507387.116\nY: 667710385373.5492'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC45, 'text': 'X: 1700099.4108847957\nY: 10588177.898464786'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC45, 'text': 'X: 947877342576.0924\nY: 667710619341.4818'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC45, 'text': 'X: 2292658.3976622485\nY: 4860547.888318749'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC46, 'text': 'X: 1700078.7685167978\nY: 11369345.701318324'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC46, 'text': 'X: 1117670590371.788\nY: 852274021117.7257'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC46, 'text': 'X: 1700078.7685017155\nY: 11369345.701338103'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC46, 'text': 'X: 1117670376365.0015\nY: 852274301769.0779'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC46, 'text': 'X: 2291647.816399476\nY: 5749426.839155653'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC47, 'text': 'X: 1700062.57197326\nY: 12157756.398140127'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC47, 'text': 'X: 1311872383370.5388\nY: 1079641824926.0054'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC47, 'text': 'X: 1700062.5719601135\nY: 12157756.398156103'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC47, 'text': 'X: 1311872107743.2188\nY: 1079642159843.911'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC47, 'text': 'X: 2290834.161844847\nY: 6638450.146050058'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC48, 'text': 'X: 1700049.8344337824\nY: 12952932.238843368'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC48, 'text': 'X: 1532667083582.0532\nY: 1357929925159.1333'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC48, 'text': 'X: 1700049.8344223285\nY: 12952932.238856293'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC48, 'text': 'X: 1532666731319.3572\nY: 1357930322753.9128'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC48, 'text': 'X: 2290213.631248338\nY: 7527581.5130859045'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC49, 'text': 'X: 1700039.793701401\nY: 13754433.62360481'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC49, 'text': 'X: 1782150968405.1555\nY: 1696387223522.3767'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC49, 'text': 'X: 1700039.7936914219\nY: 13754433.623615295'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC49, 'text': 'X: 1782150521493.8877\nY: 1696387693031.2402'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC49, 'text': 'X: 2289782.4495479153\nY: 8416785.265446726'},

    {'coord': const LatLng(89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC50, 'text': 'X: 1700031.859982006\nY: 14561855.266314678'},
    {'coord': const LatLng(-89.99999, 179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC50, 'text': 'X: 2062258502015.7114\nY: 2105464181350.8462'},
    {'coord': const LatLng(89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC50, 'text': 'X: 1700031.859973308\nY: 14561855.266323198'},
    {'coord': const LatLng(-89.99999, -179.99999), 'subtype': CoordinateFormatKey.LAMBERT93_CC50, 'text': 'X: 2062257939002.245\nY: 2105464732814.0725'},
    {'coord': const LatLng(50.6569, 11.35443333), 'subtype': CoordinateFormatKey.LAMBERT93_CC50, 'text': 'X: 2289536.855368441\nY: 9306026.36549408'},

    {'coord': const LatLng(46.89226406700879, 17.888058560281515), 'subtype': CoordinateFormatKey.LAMBERT_EPSG27572, 'text': 'X: 1777310.0568079427\nY: 2327103.8227227707'},
  ];

  group("Converter.lambert.fromLatLon:", () {
    var ells = Ellipsoid.WGS84;

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']} subtype: ${elem['subtype']}', () {
        var _actual = LambertCoordinate.fromLatLon(elem['coord'] as LatLng, elem['subtype'] as CoordinateFormatKey, ells).toString();
        expect(_actual, elem['text']);
      });
    }
  });

  group("Converter.lambert.parseLatLon:", () {
    var ells = Ellipsoid.WGS84;

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']} subtype: ${elem['subtype']}', () {
        var _actual = LambertCoordinate.parse(elem['text'] as String, subtype: elem['subtype'] as CoordinateFormatKey)?.toLatLng(ells: ells);
        if (_actual == null) {
          expect(null, elem['text']);
        } else {
          expect((_actual.latitude - (elem['coord'] as LatLng).latitude).abs() < 1e-4, true);
          expect((_actual.longitude - (elem['coord'] as LatLng).longitude).abs() < 1e-4, true);
        }
      });
    }
  });

}