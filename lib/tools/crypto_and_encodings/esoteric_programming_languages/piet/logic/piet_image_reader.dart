import 'dart:core';
import 'dart:typed_data';

import 'package:image/image.dart' as Image;

class PietImageReader {
  List<List<int>>? readImage(Uint8List image) {
    var _image = Image.decodeImage(image);
    if (_image == null) return null;
    return _readImage(_image);
  }

  List<List<int>> _readImage(Image.Image image) {
    var step = _estimateCodelSize(image);
    var codels = <List<int>>[];

    int outX = 0;
    for (var x = 0; x < image.width; x += step, outX++) {
      codels.add(<int>[]);
      for (var y = 0; y < image.height; y += step) {
        codels[outX].add(_toRgb(image.getPixel(x, y)));
      }
    }
    return codels;
  }

  int _toRgb(Image.Pixel abgr24) {
    return (abgr24.r.toInt() << 16) | (abgr24.g.toInt() << 8) | (abgr24.b.toInt()); // -> RGB
  }

  int _estimateCodelSize(Image.Image image) {
    // test the first row
    int count = 1;
    int minCount = 9999999999999;

    for (var rowIndex = 0; rowIndex < image.height; rowIndex++) {
      var prevColor = _toRgb(image.getPixel(0, rowIndex));
      for (var i = 1; i < image.width; i++) {
        var currentColor = _toRgb(image.getPixel(i, rowIndex));
        if (currentColor == prevColor) {
          count++;
        } else {
          if (count < minCount) minCount = count;

          prevColor = currentColor;
          count = 1;
        }
      }

      if (count < minCount) minCount = count;
    }
    return minCount;
  }
}
