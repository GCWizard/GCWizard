import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/dcfigrid/logic/dcfigrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';

void main() {
  group("Parser.dcfigrid.parseLatLon:", () {
    // var def = '+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs';
    // 'EPSG:27572':
    var def ='+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs';
    final wgs = Projection.WGS84;
    var projection = Projection.parse(def);//def);


    //var lambert = poj. proj4(input: 'EPSG:27572');

    List<Map<String, Object?>> _inputsToExpected = [
      // {'text': '', 'expectedOutput': null},
      {'text': 'HG00E7.3', 'expectedOutput': {'format': CoordinateFormatKey.DCFIGRID, 'coordinate': const LatLng(46, 3)}},
      {'text': 'HG00D7.4', 'expectedOutput': {'format': CoordinateFormatKey.DCFIGRID, 'coordinate': const LatLng(46.0181666667, 3.7170833333)}}
    ];
    // Lambert NTF
    //{'text': 'X: 706898.197 Y: 706898.197', 'expectedOutput': {'format': CoordinateFormatKey.DCFIGRID, 'coordinate': const LatLng(46.0181666667, 3.7170833333)}}

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        //List<double> latLon = LambertToWGS84.lambertToWGS84(706898.197, 706898.197);
        // var latLon = projection.forward(Point(x:706898.197, y:706898.197));
        // print(latLon);
        // latLon = projection.forward(Point(x:46.0181666667, y:3.7170833333));
        // print(latLon);
        // latLon = projection.inverse(Point(x:46.0181666667, y:3.7170833333));
        // print(latLon);
        // latLon = projection.inverse(Point(x:3.7170833333, y:46.0181666667));
        // print(latLon);
        // latLon = projection.forward(Point(x:3.7170833333, y:46.0181666667));
        // print(latLon);
        //  latLon = projection.forward(Point(x:1550000.0, y:1400000.0)); //LambertToWGS84.lambertToWGS84(1550000.0, 1400000.0);
        // print(latLon);
        // latLon = projection.forward(Point(x:1550000.0, y:5400000.0)); //LambertToWGS84.lambertToWGS84(1550000.0, 5400000.0);
        // print(latLon);
        // var latLon = wgs.transform(projection, Point(x: 1777310.0568079422, y: 2327103.8227227707));
        //
        // print(LambertCoordinate(latLon.x, latLon.y, CoordinateFormatKey.LAMBERT93).toLatLng(ells: Ellipsoid.WGS84));
        var latLon = projection.transform(wgs, Point(x: 1777310.0568079422, y: 2327103.8227227707));
        print(latLon);
        latLon = wgs.transform(projection, Point(x: 17.88805856071017, y: 46.89226406700722));
        print(latLon);
        // latLon = wgs.transform(projection, Point(x: 17.88805856071017, y: 46.89226406700722));
        // print(latLon);

        var _actual = parseDFCI(elem['text'] as String, null);
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          print(_actual);
          expect((_actual.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        }
      });
    }
  });
}