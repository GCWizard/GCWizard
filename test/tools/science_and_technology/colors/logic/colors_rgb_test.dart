import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/pantone_color_codes/logic/pantone_color_codes.dart';

void main() {
  group("Colors.hex:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : RGB(123, 230, 14), 'expectedOutput' : '#7BE60E'},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : '#000000'},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : '#FFFFFF'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var hexCode = HexCode.fromRGB(elem['input'] as RGB);
        var _actual = hexCode.toString();
        expect(_actual, elem['expectedOutput']);
        expect(hexCode.toRGB().toString(), elem['input'].toString());
      });
    }
  });

  group("Colors.findNearestRGBs:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'fromRGB' : RGB(40, 116, 81), 'toRGBs': PANTONE_COLOR_CODES_ONLY_NUMBERS.values.map((e) {
        return HexCode(e.colorcode).toRGB();
      }).toList(), 'expectedOutput' : ['#28724F', '#228848', '#285C4D', '#286140', '#205C40', '#43695B']},
    ];

    for (var elem in _inputsToExpected) {
      test('fromRGB: ${elem['fromRGB']}', () {
        List<RGB> _actual = findNearestRGBs(elem['fromRGB'] as GCWBaseColor, elem['toRGBs'] as List<RGB>);
        expect(_actual.map((e) => HexCode.fromRGB(e).toString()).toList(), elem['expectedOutput']);
      });
    }
  });

  group("Colors.HexCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ff0000', 'expectedOutput' : '#FF0000'},
      {'input' : '00ff00', 'expectedOutput' : '#00FF00'},
      {'input' : 'ff0000', 'expectedOutput' : '#FF0000'},
      {'input' : 'fff', 'expectedOutput' : '#FFFFFF'},
      {'input' : 'ff00', 'expectedOutput' : '#00FF00'},
      {'input' : '#ff0000', 'expectedOutput' : '#FF0000'},
      {'input' : '0xff0000', 'expectedOutput' : '#FF0000'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var hexCode = HexCode(elem['input'] as String);
        var _actual = hexCode.toString();
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}