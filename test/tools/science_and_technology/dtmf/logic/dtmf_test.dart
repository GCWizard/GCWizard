import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/dtmf/logic/dtmf.dart';

void main() {
  group("DTMF.encodeDTMF:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'A', 'expectedOutput' : '[697, 1633]'},
      {'input' : 's', 'expectedOutput' : ''},
      {'input' : '27', 'expectedOutput' : '[697, 1336] [852, 1209]'},
      {'input' : '2h6', 'expectedOutput' : '[697, 1336] [770, 1477]'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeDTMF(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("DTMF.decodeDTMF:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '', 'input' : ''},
      {'expectedOutput' : 'A', 'input' : '[697, 1633]'},
      {'expectedOutput' : 'A', 'input' : '(697.1633)'},
      {'expectedOutput' : 'A', 'input' : '697 1633 '},
      {'expectedOutput' : 'A', 'input' : '697.1633.'},
      {'expectedOutput' : '27', 'input' : '697 1336 1209 852 '},
      {'expectedOutput' : '274', 'input' : '697 1336 1209 852 fghi 770 1209 '},

      {'expectedOutput' : '', 'input' : '697'},
      {'expectedOutput' : '', 'input' : '69'},
      {'expectedOutput' : '', 'input' : '69 1633'},
      {'expectedOutput' : '', 'input' : '697 1632'},
      {'expectedOutput' : 'A2', 'input' : '697 1633 697 1336 1209'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeDTMF(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}