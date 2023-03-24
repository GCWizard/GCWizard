import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_hue.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

void main() {
  group("Colors.HSV:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : RGB(123, 230, 12), 'expectedOutput' : HSV(89.44954128440368, 0.9478260869565218, 0.9019607843137255)},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : HSV(0.0, 0.0, 0.0)},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : HSV(0.0, 0.0, 1.0)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var hsv = HSV.fromRGB(elem['input'] as RGB);
        expect((hsv.hue - (elem['expectedOutput'] as HSV).hue).abs() < 1e-5, true);
        expect((hsv.saturation - (elem['expectedOutput'] as HSV).saturation).abs() < 1e-5, true);
        expect((hsv.value - (elem['expectedOutput'] as HSV).value).abs() < 1e-5, true);

        var rgb = hsv.toRGB();
        expect((rgb.red - (elem['input'] as RGB).red).abs() < 1e-5, true);
        expect((rgb.green - (elem['input'] as RGB).green).abs() < 1e-5, true);
        expect((rgb.blue - (elem['input'] as RGB).blue).abs() < 1e-5, true);
      });
    }
  });

  group("Colors.HSL:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : RGB(123, 230, 12), 'expectedOutput' : HSL(89.44954128440368, 0.9008264462809918, 0.4745098039215686)},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : HSL(0.0, 0.0, 0.0)},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : HSL(0.0, 0.0, 1.0)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var hsl = HSL.fromRGB(elem['input'] as RGB);
        expect((hsl.hue - (elem['expectedOutput'] as HSL).hue).abs() < 1e-5, true);
        expect((hsl.saturation - (elem['expectedOutput'] as HSL).saturation).abs() < 1e-5, true);
        expect((hsl.lightness - (elem['expectedOutput'] as HSL).lightness).abs() < 1e-5, true);

        var rgb = hsl.toRGB();
        expect((rgb.red - (elem['input'] as RGB).red).abs() < 1e-5, true);
        expect((rgb.green - (elem['input'] as RGB).green).abs() < 1e-5, true);
        expect((rgb.blue - (elem['input'] as RGB).blue).abs() < 1e-5, true);
      });
    }
  });

  group("Colors.HSI:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : RGB(123, 230, 12), 'expectedOutput' : HSI(89.44954128440368, 0.9013698630136986, 0.477124183006536)},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : HSI(0.0, 0.0, 0.0)},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : HSI(0.0, 0.0, 1.0)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var hsi = HSI.fromRGB(elem['input'] as RGB);
        expect((hsi.hue - (elem['expectedOutput'] as HSI).hue).abs() < 1e-5, true);
        expect((hsi.saturation - (elem['expectedOutput'] as HSI).saturation).abs() < 1e-5, true);
        expect((hsi.intensity - (elem['expectedOutput'] as HSI).intensity).abs() < 1e-5, true);

        var rgb = hsi.toRGB();
        expect((rgb.red - (elem['input'] as RGB).red).abs() < 0.5, true);
        expect((rgb.green - (elem['input'] as RGB).green).abs() < 0.5, true);
        expect((rgb.blue - (elem['input'] as RGB).blue).abs() < 0.5, true);
      });
    }
  });
}