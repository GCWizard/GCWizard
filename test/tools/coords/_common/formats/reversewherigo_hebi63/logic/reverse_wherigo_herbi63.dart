import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_hebi63/logic/reverse_wherigo_hebi63.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigoHebi63.fromLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // does not work because of the use of random numbers
      //{'coordinate': const LatLng(0.0, 0.0), 'text': ['244444', '009000', '005000']},
    ];

    for (var elem in _inputsToExpected) {
      test('coordinate: ${elem['coordinate']}', () {
        var _actual = ReverseWherigoHebi63Coordinate.fromLatLon(elem['coordinate'] as LatLng);
        expect(_actual.a, int.parse((elem['text'] as List<String>)[0]));
        expect(_actual.b, int.parse((elem['text'] as List<String>)[1]));
        expect(_actual.c, int.parse((elem['text'] as List<String>)[2]));
      });
    }
  });

  group("Converter.reverseWherigoHebi63.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(0.0, 0.0), 'text': ['011111', '111666', '666666']},

      // N 52° 19.321' E 014° 06.179'   52.3220166667 014.1029833333
      {'coordinate': const LatLng(52.3220166667, 014.1029833333), 'text': ['683565', '801690', '440187']},
      {'coordinate': const LatLng(52.3220166667, 014.1029833333), 'text': ['561343', '689689', '339076']},
      {'coordinate': const LatLng(52.3220166667, 014.1029833333), 'text': ['783565', '801701', '551298']},
      {'coordinate': const LatLng(52.3220166667, 014.1029833333), 'text': ['672454', '790889', '339076']},

    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoHebi63Coordinate.parse((elem['text'] as List<String>).join(' '))?.toLatLng();
        expect((_actual!.latitude - (elem['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
        expect((_actual.longitude - (elem['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
      });
    }
  });

}