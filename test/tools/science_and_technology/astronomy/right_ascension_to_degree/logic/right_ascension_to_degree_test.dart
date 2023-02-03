import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/astronomy/right_ascension_to_degree/logic/right_ascension_to_degree.dart';

void main() {

  group("right_ascension_to_degree.raDegree2RightAscension:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null.toString()},
      {'input' : 66.918277, 'expectedOutput' : '04:27:40.386'},
      {'input' : -66.918277, 'expectedOutput' : '-04:27:40.386'},
      {'input' : 9.618291666666666, 'expectedOutput' : '00:38:28.390'},

      {'input' : 90.0, 'expectedOutput' : '06:00:00.000'},
      {'input' : 460.0, 'expectedOutput' : '30:40:00.000'},
      {'input' : 0.0, 'expectedOutput' : '00:00:00.000'},
      {'input' : -0.0, 'expectedOutput' : '00:00:00.000'},
      {'input' : 90.0, 'expectedOutput' : '06:00:00.000'},
      {'input' : -90.0, 'expectedOutput' : '-06:00:00.000'},
      {'input' : 180.0, 'expectedOutput' : '12:00:00.000'},
      {'input' : -180.0, 'expectedOutput' : '-12:00:00.000'},
      {'input' : 360.0, 'expectedOutput' : '24:00:00.000'},
      {'input' : -360.0, 'expectedOutput' : '-24:00:00.000'},
      {'input' : 720.0, 'expectedOutput' : '48:00:00.000'},
      {'input' : -47.000, 'expectedOutput' : '-03:08:00.000'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = raDegree2RightAscension(RaDeg(elem['input']));
        expect(_actual.toString(), elem['expectedOutput']);
      });
    });
  });


  group("right_ascension_to_degree.raRightAscension2Degree:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '4:27:40.386', 'expectedOutput' : '66.918275'},
      {'input' : '-4:27:40.386', 'expectedOutput' : '-66.918275'},
      {'input' : '0:38:28.39', 'expectedOutput' : '9.6182916667'},

      {'input' : '-44:27:40.386', 'expectedOutput' : '-666.918275'},
      {'input' : '50:38:28.39', 'expectedOutput' : '759.6182916667'},
      {'input' : '-3:8:0', 'expectedOutput' : '-47.000'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = raRightAscension2Degree(RightAscension.parse(elem['input']));
        if (_actual == null)
          expect(_actual, elem['expectedOutput']);
        else
          expect(_actual.toString(), elem['expectedOutput']);
      });
    });
  });

  group("raDeg.parse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '66.918277', 'expectedOutput' : '66.918277'},
      {'input' : '-66.918277', 'expectedOutput' : '-66.918277'},
      {'input' : '9.618291666666666', 'expectedOutput' : '9.6182916667'},
      {'input' : '59.999999999', 'expectedOutput' : '59.999999999'},
      {'input' : '59.999999999999', 'expectedOutput' : '60.000'},

      {'input' : '0', 'expectedOutput' : '0.000'},
      {'input' : '-0', 'expectedOutput' : '-0.000'},
      {'input' : '90', 'expectedOutput' : '90.000'},
      {'input' : '-90', 'expectedOutput' : '-90.000'},
      {'input' : '180', 'expectedOutput' : '180.000'},
      {'input' : '-180', 'expectedOutput' : '-180.000'},
      {'input' : '360', 'expectedOutput' : '360.000'},
      {'input' : '-360', 'expectedOutput' : '-360.000'},
      {'input' : '720', 'expectedOutput' : '720.000'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = RaDeg.parse(elem['input']);
        if (_actual == null)
          expect(_actual, elem['expectedOutput']);
        else
          expect(_actual.toString(), elem['expectedOutput']);
      });
    });
  });

  group("RightAscension.parse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '4:27:40.386', 'expectedOutput' : '04:27:40.386'},
      {'input' : '-4:27:40.386', 'expectedOutput' : '-04:27:40.386'},
      {'input' : '0:38:28.39', 'expectedOutput' : '00:38:28.390'},
      {'input' : '0000:38:28.39', 'expectedOutput' : '00:38:28.390'},

      {'input' : '0:61:28.39', 'expectedOutput' : '01:01:28.390'},
      {'input' : '-0:61:28.39', 'expectedOutput' : '-01:01:28.390'},
      {'input' : '0:120:28.39', 'expectedOutput' : '02:00:28.390'},
      {'input' : '48:61:28.39', 'expectedOutput' : '49:01:28.390'},
      {'input' : '-48:61:28.39', 'expectedOutput' : '-49:01:28.390'},

      {'input' : '-48:01:28.999999', 'expectedOutput' : '-48:01:29.000'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = RightAscension.parse(elem['input']);
        if (_actual == null)
          expect(_actual, elem['expectedOutput']);
        else
          expect(_actual.toString(), elem['expectedOutput']);
      });
    });
  });
}