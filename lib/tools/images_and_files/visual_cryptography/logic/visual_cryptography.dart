import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/image_utils.dart';
import 'package:image/image.dart' as Image;
import 'package:tuple/tuple.dart';

var _whiteColor = Image.ColorRgb8(Colors.white.red, Colors.white.green, Colors.white.blue);
var _blackColor = Image.ColorRgb8(Colors.black.red, Colors.black.green, Colors.black.blue);

Future<Uint8List?> decodeImagesAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple4<Uint8List, Uint8List, int, int>) return null;

  var data = jobData!.parameters as Tuple4<Uint8List, Uint8List, int, int>;
  var output = await _decodeImages(data.item1, data.item2, data.item3, data.item4);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<Uint8List?> _decodeImages(Uint8List image1, Uint8List image2, int offsetX, int offsetY) {
  if (image1.isEmpty || image2.isEmpty) return Future.value(null);

  var decoder1 = Image.findDecoderForData(image1);
  var decoder2 = Image.findDecoderForData(image2);
  if (decoder1 == null || decoder2 == null) return Future.value(null);

  var _image1 = decoder1.decode(image1);
  var _image2 = decoder2.decode(image2);
  if (_image1 == null || _image2 == null) return Future.value(null);

  var pixelSize = _detectPixelSize(_image1, _image2);
  var image = Image.Image(
      width: (max(_image1.width, _image2.width)/ pixelSize).ceil() + offsetX.abs(),
      height: (max(_image1.height, _image2.height)/ pixelSize).ceil() + offsetY.abs());

  image = _pasteImage(image, _image1, min(offsetX, 0).abs(), min(offsetY, 0).abs(), false, pixelSize);
  image = _pasteImage(image, _image2, max(offsetX, 0).abs(), max(offsetY, 0).abs(), true, pixelSize);

  Uint8List output = encodeTrimmedPng(image);
  return Future.value(output);
}

Image.Image _pasteImage(Image.Image targetImage, Image.Image image, int offsetX, int offsetY, bool secondLayer,
    int pixelSize) {
  if (secondLayer) {
    for (var x = 0; x < image.width / pixelSize; x++) {
      for (var y = 0; y < image.height / pixelSize; y++) {
        if (_blackPixel(image.getPixel(x * pixelSize, y * pixelSize))) targetImage.setPixel(x + offsetX, y + offsetY, _blackColor);
      }
    }
  } else {
    for (var x = 0; x < image.width / pixelSize; x++) {
      for (var y = 0; y < image.height / pixelSize; y++) {
        targetImage.setPixel(x + offsetX, y + offsetY,
            _blackPixel(image.getPixel(x * pixelSize, y * pixelSize)) ? _blackColor : _whiteColor);
      }
    }
  }

  return targetImage;
}

Future<Tuple2<int, int>?> offsetAutoCalcAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple4<Uint8List, Uint8List, int, int>) return null;

  var data = jobData!.parameters as Tuple4<Uint8List, Uint8List, int, int>;
  var output =
      await _offsetAutoCalc(data.item1, data.item2, data.item3, data.item4, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

int _detectPixelSize(Image.Image image1, Image.Image image2) {
  return __detectPixelSize(image1);
}

int __detectPixelSize(Image.Image image) {
  var refOffset = _detectReferenceCorner(image);
  var refPixel = _blackPixel(image.getPixel(refOffset.x, refOffset.y));

  for (var offset = 1; offset < min(image.width - refOffset.x, image.height - refOffset.y); offset++) {
    if ((_blackPixel(image.getPixel(refOffset.x + offset, refOffset.y)) != refPixel) ||
        (_blackPixel(image.getPixel(refOffset.x, refOffset.y + offset)) != refPixel)) {
      return offset;
    }
  }
  return 1;
}

Point<int> _detectReferenceCorner(Image.Image image) {
  var offsetX = 0;
  var offsetY = 0;
  var found = false;

  for (var x = 0; x < image.width; x++) {
    for (var y = 0; y < image.height; y++) {
      if (_blackPixel(image.getPixel(x, y))) {
        offsetX = x;
        found = true;
        break;
      }
    }
    if (found) break;
  }
  found = false;
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      if (_blackPixel(image.getPixel(x, y))) {
        offsetY = y;
        found = true;
        break;
      }
    }
    if (found) break;
  }
  return Point<int>(offsetX, offsetY);
}

Future<Tuple2<int, int>?> _offsetAutoCalc(Uint8List image1, Uint8List image2, int? offsetX, int? offsetY,
    {SendPort? sendAsyncPort}) {
  var _image1 = decodeImage4ChannelFormat(image1);
  var _image2 = decodeImage4ChannelFormat(image2);

  if (_image1 == null || _image2 == null) return Future.value(null);

  var minX = (offsetX == null) ? -_image2.width + 2 : offsetX;
  var maxX = (offsetX == null) ? _image1.width + _image2.width - 2 : offsetX;
  var minY = (offsetY == null) ? -_image2.height + 2 : offsetY;
  var maxY = (offsetY == null) ? _image1.width + _image2.width - 2 : offsetY;
  var progress = 0;

  var solutionsAll = <Tuple2<int, int>>[];
  int _countCombinations = max(((maxX - minX + 1) * (maxY - minY + 1)).toInt(), 1);
  int _progressStep = max(_countCombinations ~/ 100, 1); // 100 steps

  sendAsyncPort?.send(DoubleText(PROGRESS, 0.0));

  for (var y = minY; y <= maxY; y++) {
    var solutionsRow = <int>[];
    for (var x = minX; x <= maxX; x++) {
      solutionsRow.add(_calcBlackBlockCount(_image1, _image2, x, y));

      progress++;
      if (sendAsyncPort != null && (progress % _progressStep == 0)) {
        sendAsyncPort.send(DoubleText(PROGRESS, progress / _countCombinations));
      }
    }
    solutionsAll.add(_highPassFilter(0.2, solutionsRow));
  }

  var min = solutionsAll.reduce((curr, next) => curr.item2 < next.item2 ? curr : next);
  var result = Tuple2<int, int>(min.item1 + minX, solutionsAll.indexOf(min) + minY);

  return Future.value(result);
}

/// HighPass Filter
Tuple2<int, int> _highPassFilter(double alpha, List<int> keyList) {
  var list = List.filled(keyList.length, 0);
  for (var i = 0; i < keyList.length; ++i) {
    list[i] = (alpha * keyList[i] -
            (i > 0 ? keyList[i - 1] : keyList[i]) -
            (i < keyList.length - 1 ? keyList[i + 1] : keyList[i]))
        .toInt();
  }

  var min = list.reduce((curr, next) => curr < next ? curr : next);
  return Tuple2<int, int>(list.indexOf(min), min);
}

Uint8List? cleanImage(Uint8List image1, Uint8List image2, int offsetX, int offsetY) {
  var _image1 = decodeImage4ChannelFormat(image1);
  var _image2 = decodeImage4ChannelFormat(image2);

  if (_image1 == null || _image2 == null) return null;

  var pixelSize = _detectPixelSize(_image1, _image2);
  offsetX *= pixelSize;
  offsetY *= pixelSize;
  var coreImageSize = _coreImageSize(_image1, _image2, offsetX, offsetY, pixelSize);
  var image =
      Image.Image(width: coreImageSize.item2 - coreImageSize.item1, height: coreImageSize.item4 - coreImageSize.item3);

  for (var x = coreImageSize.item1; x < coreImageSize.item2 - 1; x += 2) {
    for (var y = coreImageSize.item3; y < coreImageSize.item4 - 1; y += 2) {
      if (!(_blackArea(_image1, _image2, x * pixelSize, y * pixelSize, offsetX, offsetY, pixelSize))) {
        image.setPixel(x - coreImageSize.item1, y - coreImageSize.item3, _whiteColor);
        image.setPixel(x + 1 - coreImageSize.item1, y - coreImageSize.item3, _whiteColor);
        image.setPixel(x - coreImageSize.item1, y + 1 - coreImageSize.item3, _whiteColor);
        image.setPixel(x + 1 - coreImageSize.item1, y + 1 - coreImageSize.item3, _whiteColor);
      }
    }
  }

  return encodeTrimmedPng(image);
}

Future<Tuple2<Uint8List, Uint8List?>?> encodeImagesAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple6<Uint8List, Uint8List?, int, int, int, int>) return null;

  var data = jobData!.parameters as Tuple6<Uint8List, Uint8List?, int, int, int, int>;
  var output = await _encodeImage(data.item1, data.item2, data.item3, data.item4, data.item5, data.item6);

  jobData.sendAsyncPort?.send(output);

  return output;
}
int encodeImageWidth(int imageWidth, bool withKeyImage, int offsetX, int scale, int pixelSize ) {
  if (withKeyImage) {
    scale = 100;
    pixelSize = 1;
  }
  return (((imageWidth * scale/ 100.0).round() * 2 + offsetX.abs()) * pixelSize).round();
}

int encodeImageHight(int imageHeight, bool withKeyImage, int offsetY, int scale, int pixelSize ) {
  if (withKeyImage) {
    scale = 100;
    pixelSize = 1;
  }
  return (((imageHeight * scale/ 100.0).round() * 2 + offsetY.abs()) * pixelSize).round();
}

Future<Tuple2<Uint8List, Uint8List?>?> _encodeImage(
    Uint8List image, Uint8List? keyImage, int offsetX, int offsetY, int scale, int pixelSize) {
  try {
    var _image = decodeImage4ChannelFormat(image);
    if (_image == null) return Future.value(null);

    var hasKeyImage = keyImage != null;
    Image.Image? _keyImage;

    if (hasKeyImage) {
      _keyImage = decodeImage4ChannelFormat(keyImage);
      if (_keyImage == null) return Future.value(null);

      pixelSize = 1;
      scale = (min<double>(_keyImage.width / 2.0 / _image.width, _keyImage.height / 2.0 / _image.height) * 100).round();

      var _dstImage = Image.Image(width: _keyImage.width ~/ 2, height: _keyImage.height ~/ 2);
      _dstImage = Image.drawRect(_dstImage, x1: 0, y1: 0, x2: _dstImage.width, y2: _dstImage.height, color: _whiteColor);

      var _dstXOffset = (_dstImage.width - _image.width) ~/ 2;
      var _dstYOffset = (_dstImage.height - _image.height) ~/ 2;

      _dstImage = Image.compositeImage(_dstImage, _image,
          dstX: _dstXOffset, dstY: _dstYOffset, dstW: _image.width, dstH: _image.height);

      return _encodeWithKeyImage(offsetX, offsetY, _dstImage, _keyImage, pixelSize);
    } else {
      pixelSize = max(1, pixelSize);
      if (scale > 0 && scale != 100) _image = Image.copyResize(_image, height: (_image.height * scale/ 100.0).round());

      return _encodeWithoutKeyImage(offsetX, offsetY, _image, pixelSize);
    }
  } catch (e) {}
  return Future.value(null);
}

List<bool> _keyPixels(Image.Image _keyImage, int x, int y) {
  return [
    _blackPixel(_keyImage.getPixel(2 * x, 2 * y)),
    _blackPixel(_keyImage.getPixel(2 * x, 2 * y + 1)),
    _blackPixel(_keyImage.getPixel(2 * x + 1, 2 * y)),
    _blackPixel(_keyImage.getPixel(2 * x + 1, 2 * y + 1)),
  ];
}

Future<Tuple2<Uint8List, Uint8List?>> _encodeWithKeyImage(
    int offsetX, int offsetY, Image.Image _image, Image.Image _keyImage, int pixelSize) {

  var image1 = Image.Image(width: _image.width * 2 * pixelSize, height: _image.height * 2 * pixelSize);

  for (var x = 0; x < _image.width; x++) {
    for (var y = 0; y < _image.height; y++) {
      var pixel = _randomPixel(false).item1;
      for (var x1 = 0; x1 < 2; x1++) {
        for (var y1 = 0; y1 < 2; y1++) {
          var _paintX = x * 2 + x1;
          var _paintY = y * 2 + y1;
          _setPixel(image1, _paintX, _paintY, pixelSize, pixel[2 * x1 + y1] ? _whiteColor : _blackColor);
        }
      }
    }
  }

  for (var x = 0; x < _image.width; x++) {
    for (var y = 0; y < _image.height; y++) {
      var keyPixels = _keyPixels(_keyImage, x, y);
      var pixel = _checkLimits(x + offsetX, y + offsetY, _image.width, _image.height)
          ? _pixelsFromKey(_blackPixel(_image.getPixel(x + offsetX, y + offsetY)), keyPixels)
          : _pixelsFromKey(false, keyPixels);
      for (var x1 = 0; x1 < 2; x1++) {
        for (var y1 = 0; y1 < 2; y1++) {
          var _paintX = x * 2 + x1 + offsetX;
          var _paintY = y * 2 + y1 + offsetY;
          if (_checkLimits(_paintX * pixelSize, _paintY * pixelSize, image1.width, image1.height)) {
            _setPixel(image1, _paintX, _paintY, pixelSize, pixel[2 * x1 + y1] ? _whiteColor : _blackColor);
          }
        }
      }
    }
  }

  return Future.value(Tuple2<Uint8List, Uint8List?>(encodeTrimmedPng(image1), null));
}

Future<Tuple2<Uint8List, Uint8List>> _encodeWithoutKeyImage(int offsetX, int offsetY, Image.Image _image,
    int pixelSize) {
  var image1OffsetX = max(offsetX, 0).abs();
  var image1OffsetY = max(offsetY, 0).abs();
  var image2OffsetX = min(offsetX, 0).abs();
  var image2OffsetY = min(offsetY, 0).abs();
  var image1 = Image.Image(
      width: (_image.width * 2 + image1OffsetX + image2OffsetX) * pixelSize,
      height: (_image.height * 2 + image1OffsetY + image2OffsetY) * pixelSize);
  var image2 = Image.Image(width: image1.width, height: image1.height);

  for (var x = -(image1OffsetX + image2OffsetX); x < image1OffsetX + image2OffsetX + _image.width; x++) {
    for (var y = -(image1OffsetY + image2OffsetY); y < image1OffsetY + image2OffsetY + _image.height; y++) {
      var pixel = _checkLimits(x, y, _image.width, _image.height)
          ? _randomPixel(_blackPixel(_image.getPixel(x, y)))
          : _randomPixel(false);
      for (var x1 = 0; x1 < 2; x1++) {
        for (var y1 = 0; y1 < 2; y1++) {
          var offsetX = x * 2 + image1OffsetX + x1;
          var offsetY = y * 2 + image1OffsetY + y1;
          if (_checkLimits(offsetX * pixelSize, offsetY * pixelSize, image1.width, image1.height)) {
            _setPixel(image1, offsetX, offsetY, pixelSize, pixel.item1[2 * x1 + y1] ? _whiteColor : _blackColor);
          }

          offsetX = x * 2 + image2OffsetX + x1;
          offsetY = y * 2 + image2OffsetY + y1;
          if (_checkLimits(offsetX * pixelSize, offsetY * pixelSize, image2.width, image2.height)) {
            _setPixel(image2, offsetX, offsetY, pixelSize, pixel.item2[2 * x1 + y1] ? _whiteColor : _blackColor);
          }
        }
      }
    }
  }

  return Future.value(Tuple2<Uint8List, Uint8List>(encodeTrimmedPng(image1), encodeTrimmedPng(image2)));
}

bool _checkLimits(int x, int y, int width, int height) {
  return x >= 0 && x < width && y >= 0 && y < height;
}

List<bool> _pixelsFromKey(bool black, List<bool> keyPixel) {
  var pixels = List<bool>.filled(4, false);

  for (var i = 0; i < 4; i++) {
    pixels[i] = black ? keyPixel[i] : !keyPixel[i];
  }

  return pixels;
}

void _setPixel(Image.Image image, int offsetX, int offsetY, int pixelSize, Image.ColorRgb8 color) {
  for (var x = 0; x < pixelSize; x++ ) {
    for (var y = 0; y < pixelSize; y++ ) {
      image.setPixel(offsetX * pixelSize + x, offsetY * pixelSize + y, color);
    }
  }
}

Tuple2<List<bool>, List<bool>> _randomPixel(bool black) {
  var random = Random();
  var pixel1 = random.nextInt(4);
  int pixel2;
  do {
    pixel2 = random.nextInt(4);
  } while (pixel2 == pixel1);

  var bool1 = List.filled(4, false);
  var bool2 = List.filled(4, false);
  for (var i = 0; i < 4; i++) {
    bool1[i] = (i == pixel1 || i == pixel2);
    bool2[i] = black ? !bool1[i] : bool1[i];
  }

  return Tuple2<List<bool>, List<bool>>(bool1, bool2);
}

int _calcBlackBlockCount(Image.Image image1, Image.Image image2, int offsetX, int offsetY) {
  var counter = 0;
  var pixelSize = _detectPixelSize(image1, image2);
  offsetX *= pixelSize;
  offsetY *= pixelSize;
  var coreImageSize = _coreImageSize(image1, image2, offsetX, offsetY, pixelSize);
  for (var x = coreImageSize.item1; x < coreImageSize.item2 - 1; x += 2) {
    for (var y = coreImageSize.item3; y < coreImageSize.item4 - 1; y += 2) {
      if (_blackArea(image1, image2, x * pixelSize, y * pixelSize, offsetX, offsetY, pixelSize)) counter++;
    }
  }

  return counter;
}

bool _blackPixel(Image.Pixel pixel) {
  return (pixel.a > 128 && Image.getLuminance(pixel) < 128);
}

bool _blackResultPixel(Image.Pixel pixel1, Image.Pixel pixel2) {
  return (_blackPixel(pixel1) || _blackPixel(pixel2));
}

bool _blackArea(Image.Image image1, Image.Image image2, int x, int y, int offsetX, int offsetY, int pixelSize) {
  return _blackResultPixel(image1.getPixel(x, y), image2.getPixel(x - offsetX, y - offsetY)) &&
      _blackResultPixel(image1.getPixel(x + pixelSize, y), image2.getPixel(x + pixelSize - offsetX, y - offsetY)) &&
      _blackResultPixel(image1.getPixel(x, y + pixelSize), image2.getPixel(x - offsetX, y + pixelSize - offsetY)) &&
      _blackResultPixel(image1.getPixel(x + pixelSize, y + pixelSize), image2.getPixel(x + pixelSize - offsetX, y + pixelSize - offsetY));
}

Tuple4<int, int, int, int> _coreImageSize(Image.Image image1, Image.Image image2, int offsetX, int offsetY,
    int pixelSize) {
  var minX = max(offsetX * pixelSize, 0);
  var maxX = (min(image1.width, image2.width + offsetX)/ pixelSize).ceil();
  var minY = max(offsetY * pixelSize, 0);
  var maxY = (min(image1.height, image2.height + offsetY)/ pixelSize).ceil();

  return Tuple4<int, int, int, int>(minX, maxX, minY, maxY);
}
