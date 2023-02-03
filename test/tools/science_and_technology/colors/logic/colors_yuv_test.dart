import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_yuv.dart';

void main() {
  group("Colors.YUV:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : RGB(123, 230, 12), 'expectedOutput' : YUV(0.6790392156862746, -0.3109971230027, -0.17255643198791645)},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : YUV(0.0, 0.0, 0.0)},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : YUV(1.0, 0.0, 0.0)},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var yuv = YUV.fromRGB(elem['input']);
        expect((yuv.y - elem['expectedOutput'].y).abs() < 1e-5, true);
        expect((yuv.u - elem['expectedOutput'].u).abs() < 1e-5, true);
        expect((yuv.v - elem['expectedOutput'].v).abs() < 1e-5, true);

        var rgb = yuv.toRGB();
        expect((rgb.red - elem['input'].red).abs() < 1e-5, true);
        expect((rgb.green - elem['input'].green).abs() < 1e-5, true);
        expect((rgb.blue - elem['input'].blue).abs() < 1e-5, true);
      });
    });
  });

  //implicitely tests YPbPr because of the conversion RGB <-> YPbPr <-> YCbCr
  group("Colors.YCbCr:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : RGB(123, 230, 12), 'expectedOutput' : YCbCr(164.70958823529412, 48.11083078829725, 96.57508880870465)},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : YCbCr(16.0, 128.0, 128.0)},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : YCbCr(235.0, 128.0, 128.0)},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var yCbCr = YCbCr.fromRGB(elem['input']);
        expect((yCbCr.y - elem['expectedOutput'].y).abs() < 1e-5, true);
        expect((yCbCr.cb - elem['expectedOutput'].cb).abs() < 1e-5, true);
        expect((yCbCr.cr - elem['expectedOutput'].cr).abs() < 1e-5, true);

        var rgb = yCbCr.toRGB();
        expect((rgb.red - elem['input'].red).abs() < 1e-5, true);
        expect((rgb.green - elem['input'].green).abs() < 1e-5, true);
        expect((rgb.blue - elem['input'].blue).abs() < 1e-5, true);
      });
    });
  });

  group("Colors.YIQ:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : RGB(123, 230, 12), 'expectedOutput' : YIQ(0.6790392156862746, 0.02466317214669836, -0.35480510238160223)},
      {'input' : RGB(0, 0, 0), 'expectedOutput' : YIQ(0.0, 0.0, 0.0)},
      {'input' : RGB(255, 255, 255), 'expectedOutput' : YIQ(1.0, 0.0, 0.0)},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var yiq = YIQ.fromRGB(elem['input']);
        expect((yiq.y - elem['expectedOutput'].y).abs() < 1e-5, true);
        expect((yiq.i - elem['expectedOutput'].i).abs() < 1e-5, true);
        expect((yiq.q - elem['expectedOutput'].q).abs() < 1e-5, true);

        var rgb = yiq.toRGB();
        expect((rgb.red - elem['input'].red).abs() < 1e-5, true);
        expect((rgb.green - elem['input'].green).abs() < 1e-5, true);
        expect((rgb.blue - elem['input'].blue).abs() < 1e-5, true);
      });
    });
  });
}