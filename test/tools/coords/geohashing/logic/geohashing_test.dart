import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/geohashing/logic/geohashing.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Geohashing.parse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '2015-03-27 34.123,-111.456', 'expectedOutput': LatLng(34.520364031734495, -111.75641517793687)},
      {'text': '34.123,-111.456 2015-03-27', 'expectedOutput': LatLng(34.520364031734495, -111.75641517793687)},
      {'text': '2008-09-10 34.123,-111.456', 'expectedOutput': LatLng(34.380395695429435, -111.6951528305385)},
      {'text': '2015-05-05 34.123,-111.456', 'expectedOutput': LatLng(34.89779651276887, -111.54811976468883)},
      {'text': '2015-05-05 34.123, -111.456', 'expectedOutput': LatLng(34.89779651276887, -111.54811976468883)},
      {'text': '2015-05-05 34.123, 111.456', 'expectedOutput': LatLng(34.072375550841855, 111.14132830888099)},
      {'text': '2015-05-05 -34.123, 111.456', 'expectedOutput': LatLng(-34.072375550841855, 111.14132830888099)},
      {'text': '2015-05-05 -34 111', 'expectedOutput': LatLng(-34.072375550841855, 111.14132830888099)},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () async {
        var _actual = await Geohashing.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - ((elem['expectedOutput'] as LatLng).latitude)).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as LatLng).longitude)).abs() < 1e-8, true);
        }
      });
    }
  });

  group("Geohashing.toLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': Geohashing(DateTime.parse('2005-05-26'), 34, -111), 'expectedOutput': LatLng(34.857713267707005, -111.54454306955928)},
      {'input': Geohashing(DateTime.parse('2015-03-27'), 34, -111), 'expectedOutput': LatLng(34.520364031734495, -111.75641517793687)},
      {'input': Geohashing(DateTime.parse('2008-09-10'), 34,-111), 'expectedOutput': LatLng(34.380395695429435, -111.6951528305385)},
      {'input': Geohashing(DateTime.parse('2015-05-05'), 34,-111), 'expectedOutput': LatLng(34.89779651276887, -111.54811976468883)},
      {'input': Geohashing(DateTime.parse('2023-08-01'), 9, 48), 'expectedOutput': LatLng(9.835349726655165, 48.50603874005688)},

      {'input': Geohashing(DateTime.parse('2015-03-27'), 34, -111, dowJonesIndex: 17673.63), 'expectedOutput': LatLng(34.520364031734495, -111.75641517793687)},
      {'input': Geohashing(DateTime.parse('2008-09-10'), 34,-111, dowJonesIndex: 11233.91), 'expectedOutput': LatLng(34.380395695429435, -111.6951528305385)},
      {'input': Geohashing(DateTime.parse('2015-05-05'), 34,-111, dowJonesIndex: 18062.53), 'expectedOutput': LatLng(34.89779651276887, -111.54811976468883)},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['input']}', () async {
        var _actual = await (elem['input'] as Geohashing).toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - ((elem['expectedOutput'] as LatLng).latitude)).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as LatLng).longitude)).abs() < 1e-8, true);
        }
      });
    }
  });

  group("Geohashing.dowJonesIndex:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'date': DateTime.now().add(const Duration(days: 1)), 'expectedOutput': null},
      {'date': DateTime.parse('1800-03-27'), 'expectedOutput': null},

      {'date': DateTime.parse('2022-03-27'), 'expectedOutput': 34702.39},
      {'date': DateTime.parse('2015-03-27'), 'expectedOutput': 17673.63},
      {'date': DateTime.parse('2008-09-10'), 'expectedOutput': 11233.91},
      {'date': DateTime.parse('2015-05-05'), 'expectedOutput': 18062.53},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['date']}', () async {
        var _actual = await dowJonesIndex(elem['date'] as DateTime);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}