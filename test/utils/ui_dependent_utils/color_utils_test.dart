import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/color_utils.dart';


void main() {

  group("color_utils.hexStringToColor:", () {

    List<Map<String, Object>> _inputsToExpected = [
      {'input' : '0', 'expectedOutput' : const Color.from(alpha: 1.0000, red: 0.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)},

      {'input' : '0xff0000', 'expectedOutput' : const Color.from(alpha: 1.0000, red: 1.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)},
      {'input' : '0x00ff00', 'expectedOutput' : const Color.from(alpha: 1.0000, red: 0.0000, green: 1.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)},
      {'input' : '0x0000ff', 'expectedOutput' : const Color.from(alpha: 1.0000, red: 0.0000, green: 0.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)},
      {'input' : '0x00ffff', 'expectedOutput' : const Color.from(alpha: 1.0000, red: 0.0000, green: 1.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)},
      {'input' : '0xff00ffff', 'expectedOutput' : const Color.from(alpha: 1.0000, red: 0.0000, green: 1.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = hexStringToColor((elem['input'] as String));
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("color_utils.colorToHexString:", () {

    List<Map<String, Object>> _inputsToExpected = [
      {'expectedOutput' : '#000000', 'input' : const Color.from(alpha: 1.0000, red: 0.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)},

      {'expectedOutput' : '#FF0000', 'input' : const Color.from(alpha: 1.0000, red: 1.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)},
      {'expectedOutput' : '#00FF00', 'input' : const Color.from(alpha: 1.0000, red: 0.0000, green: 1.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB)},
      {'expectedOutput' : '#0000FF', 'input' : const Color.from(alpha: 1.0000, red: 0.0000, green: 0.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)},
      {'expectedOutput' : '#00FFFF', 'input' : const Color.from(alpha: 1.0000, red: 0.0000, green: 1.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)},
      {'expectedOutput' : '#00FFFF', 'input' : const Color.from(alpha: 1.0000, red: 0.0000, green: 1.0000, blue: 1.0000, colorSpace: ColorSpace.sRGB)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = colorToHexString((elem['input'] as Color));
        expect(_actual.toString(), elem['expectedOutput']);
      });
    }
  });
}
