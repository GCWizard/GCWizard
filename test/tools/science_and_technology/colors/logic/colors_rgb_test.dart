import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/pantone_color_codes/logic/pantone_color_codes.dart';

void main() {
  group("Colors.hex:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : RGB(123, 230, 14), 'expectedOutput' : '#7BE60E'},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : '#000000'},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : '#FFFFFF'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var hexCode = HexCode.fromRGB(elem['input']);
        var _actual = hexCode.toString();
        expect(_actual, elem['expectedOutput']);
        expect(hexCode.toRGB().toString(), elem['input'].toString());
      });
    });
  });

  group("Colors.findNearestRGBs:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'fromRGB' : RGB(40, 116, 81), 'toRGBs': PANTONE_COLOR_CODES_ONLY_NUMBERS.values.map((e) {
        return HexCode(e['colorcode']).toRGB();
      }).toList(), 'expectedOutput' : ['#28724F', '#228848', '#285C4D', '#286140', '#205C40', '#43695B']},
    ];

    _inputsToExpected.forEach((elem) {
      test('fromRGB: ${elem['fromRGB']}', () {
        List<RGB> _actual = findNearestRGBs(elem['fromRGB'], elem['toRGBs']);
        print(_actual);

        expect(_actual.map((e) => HexCode.fromRGB(e).toString()).toList(), elem['expectedOutput']);
      });
    });
  });
}