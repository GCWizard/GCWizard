import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image.dart' as animated_image;
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image.dart';
import 'package:image/image.dart' as Image;
import 'package:tuple/tuple.dart';

class AnimatedImageMorseOutput extends AnimatedImageOutput {
  List<List<int>> imagesFiltered;

  AnimatedImageMorseOutput(AnimatedImageOutput animatedImageOutput, this.imagesFiltered)
      : super(animatedImageOutput.images, animatedImageOutput.durations, animatedImageOutput.linkList);
}

class MorseCodeOutput {
  String? morseCode;
  String? text;

  MorseCodeOutput(this.morseCode, this.text);
}

Future<AnimatedImageMorseOutput?> analyseImageMorseCodeAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Uint8List) return null;

  var data = jobData?.parameters as Uint8List;
  var output = await analyseImageMorseCode(data, sendAsyncPort: jobData!.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<AnimatedImageMorseOutput?> analyseImageMorseCode(Uint8List bytes, {SendPort? sendAsyncPort}) async {
  try {
    var out = await animated_image.analyseImage(bytes, sendAsyncPort: sendAsyncPort, withFramesOutput: true);
    if (out == null || out.frames == null) return null;

    List<Uint8List> imageList = out.images;
    var filteredList = <List<int>>[];

    for (var i = 0; i < imageList.length; i++) {
      filteredList = _filterImages(filteredList, i, imageList);
    }

    filteredList = _searchHighSignalImage(out.frames!, filteredList);
    var outMorse = AnimatedImageMorseOutput(out, filteredList);

    return Future.value(outMorse);
  } on Exception {
    return null;
  }
}

Future<Uint8List?> createImageAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple4<Uint8List, Uint8List, String, int>) return null;

  var data = jobData!.parameters as Tuple4<Uint8List, Uint8List, String, int>;
  var output = await _createImage(data.item1, data.item2, data.item3, data.item4, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<Uint8List?> _createImage(Uint8List highImage, Uint8List lowImage, String input, int ditDuration,
    {SendPort? sendAsyncPort}) async {
  if (input.isEmpty) return null;
  if (ditDuration <= 0) return null;

  input = encodeMorse(input);

  try {
    var _highImage = Image.decodeImage(highImage);
    var _lowImage = Image.decodeImage(lowImage);
    var animation = <Image.Image>[];
    if (_highImage == null || _lowImage == null) return null;

    input = input.replaceAll('| ', '|');
    input = input.replaceAll(' |', '|');
    input = input.replaceAll('.', '.*');
    input = input.replaceAll('-', '-*');
    input = input.replaceAll('* ', ' ');
    if (input[input.length - 1] == '*' && input.length > 1) input = input.substring(0, input.length - 1);

    var duration = ditDuration;
    var on = false;
    var outList = <bool>[];

    for (var i = 0; i < input.length; i++) {
      duration = ditDuration;
      on = false;
      switch (input[i]) {
        case '.':
          on = true;
          break;
        case '-':
          on = true;
          duration *= 3;
          break;
        case '*':
          break;
        case ' ':
          duration *= 3;
          break;
        case '|':
          duration *= 7;
          break;
      }

      var image = Image.Image.from(on ? _highImage : _lowImage);
      image.frameDuration = duration;
      animation.add(image);
      outList.add(on);
    }

    // image count optimation
    for (var i = animation.length - 1; i > 0; i--) {
      if (outList[i] == outList[i - 1]) {
        animation[i - 1].frameDuration += animation[i].frameDuration;
        animation.removeAt(i);
      }
    }
    var encoder = Image.GifEncoder();
    for (var image in animation) {
      encoder.addFrame(image);
    }

    var list = encoder.finish();
    return Future.value((list == null) ? null : Uint8List.fromList(list));
  } on Exception {
    return null;
  }
}

List<List<int>> _filterImages(List<List<int>> filteredList, int imageIndex, List<Uint8List> imageList) {
  const toler = 2;
  for (var i = 0; i < filteredList.length; i++) {
    var compareImage = imageList[filteredList[i].first];
    var image = imageList[imageIndex];

    if (animated_image.compareImages(compareImage, image, tolerance: toler)) {
      filteredList[i].add(imageIndex);
      return filteredList;
    }
  }

  // not found -> new List
  var newList = <int>[];
  newList.add(imageIndex);
  filteredList.add(newList);

  return filteredList;
}

MorseCodeOutput? decodeMorseCode(List<int> durations, List<bool> onSignal) {
  var timeList = _buildTimeList(durations, onSignal);
  var signalTimes = foundSignalTimes(timeList);

  if (signalTimes == null) return null;

  var out = '';
  for (var element in timeList) {
    if (element.item1) {
      out += (element.item2 > signalTimes.item1) ? '-' : '.'; //2
    } else if (element.item2 > signalTimes.item3) {
      out += String.fromCharCode(8195) + "|" + String.fromCharCode(8195);
    } else if (element.item2 > signalTimes.item2) {
      out += " ";
    }
  }

  return MorseCodeOutput(out, decodeMorse(out));
}

List<Tuple2<bool, int>> _buildTimeList(List<int> durations, List<bool> onSignal) {
  var timeList = <Tuple2<bool, int>>[];
  var i = 0;

  if (durations.length != onSignal.length) return timeList;

  if (durations.isEmpty) return timeList;

  timeList.add(Tuple2<bool, int>(onSignal[i], durations[i]));
  for (i = 1; i < durations.length; i++) {
    if (onSignal[i - 1] != onSignal[i]) {
      timeList.add(Tuple2<bool, int>(onSignal[i], durations[i]));
    } else {
      timeList.last = Tuple2<bool, int>(onSignal[i], timeList.last.item2 + durations[i]);
    }
  }
  return timeList;
}

Tuple3<int, int, int>? foundSignalTimes(List<Tuple2<bool, int>> timeList) {
  if (timeList.isEmpty) return null;

  const toler = 1.2;
  var onl = <int>[];
  var offl = <int>[];

  for (var element in timeList) {
    if (element.item1) {
      onl.add(element.item2);
    } else {
      offl.add(element.item2);
    }
  }
  onl.sort();
  offl.sort();

  var t1 = onl.isNotEmpty ? onl[0] : 99999999;
  var t2 = offl.isNotEmpty ? offl[0] : 99999999;
  var t3 = offl.isNotEmpty ? offl[0] : 99999999;
  var calct2 = true;

  for (int i = 1; i < onl.length; i++) {
    if (onl[i] > (onl[i - 1] * toler)) {
      t1 = (onl[i - 1] + ((onl[i] - onl[i - 1]) / 2.0)).toInt();
      break;
    }
  }

  for (int i = 1; i < offl.length; i++) {
    if (offl[i] > (offl[i - 1] * toler)) {
      if (calct2) {
        t2 = (offl[i - 1] + ((offl[i] - offl[i - 1]) / 2.0)).toInt();
        t3 = t2;
        calct2 = false;
      } else {
        t3 = (offl[i - 1] + ((offl[i] - offl[i - 1]) / 2.0)).toInt();
        break;
      }
    }
  }

  // item1 ./-; item2 ''; item3 ' '
  return Tuple3<int, int, int>(t1, t2, t3);
}

List<List<int>> _searchHighSignalImage(List<Image.Image> frames, List<List<int>> filteredList) {
  if (filteredList.length == 2) {
    var brightestImage = _searchBrightestImage(frames[filteredList[0][0]], frames[filteredList[1][0]]);

    if (brightestImage == frames[filteredList[1][0]]) {
      var listTmp = filteredList[0];
      filteredList[0] = filteredList[1];
      filteredList[1] = listTmp;
    }
  }
  return filteredList;
}

Image.Image _searchBrightestImage(Image.Image image1, Image.Image image2) {
  var images = _maskedImages(image1, image2);

  return _imageLuminance(images.item1) > _imageLuminance(images.item2) ? image1 : image2;
}

Tuple2<Image.Image, Image.Image> _maskedImages(Image.Image image1, Image.Image image2) {
  var clone1 = image1.clone();
  var clone2 = image2.clone();
  for (var x = 0; x < min(image1.width, image2.width); x++) {
    for (var y = 0; y < min(image1.height, image2.height); y++) {
      if (_diffBetweenPixels(image1.getPixel(x, y), true, image2.getPixel(x, y)) < 0.3) {
        clone1.setPixelRgb(x, y, 0, 0, 0);
        clone2.setPixelRgb(x, y, 0, 0, 0);
      }
    }
  }
  return Tuple2<Image.Image, Image.Image>(clone1, clone2);
}

/// Returns a single number representing the difference between two RGB pixels
num _diffBetweenPixels(Image.Pixel firstPixel, bool ignoreAlpha, Image.Pixel secondPixel) {
  num diff = (firstPixel.r - secondPixel.r).abs() +
      (firstPixel.g - secondPixel.g).abs() +
      (firstPixel.b - secondPixel.b).abs();

  if (ignoreAlpha) {
    diff = (diff / 255.0) / 3.0;
  } else {
    diff += (firstPixel.a - secondPixel.a).abs();
    diff = (diff / 255.0) / 4.0;
  }

  return diff;
}

double _imageLuminance(Image.Image image) {
  num sum = 0;
  for (var x = 0; x < image.width; x++) {
    for (var y = 0; y < image.height; y++) {
      sum += image.getPixel(x, y).luminance;
    }
  }

  return sum / (image.width * image.height);
}
