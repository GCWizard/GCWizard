import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/logic/tools/crypto_and_encodings/morse.dart';
import 'package:gc_wizard/logic/tools/images_and_files/animated_image.dart' as animated_image;
import 'package:image/image.dart' as Image;
import 'package:tuple/tuple.dart';

Future<Map<String, dynamic>> analyseImageMorseCodeAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = await analyseImageMorseCode(jobData.parameters, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Future<Map<String, dynamic>> analyseImageMorseCode(Uint8List bytes, {SendPort sendAsyncPort}) async {
  try {
    var out = animated_image.analyseImage(bytes, sendAsyncPort: sendAsyncPort, filterImages: (outMap, frames) {
      List<Uint8List> imageList = outMap["images"];
      var filteredList = <List<int>>[];

      for (var i = 0; i < imageList.length; i++) filteredList = _filterImages(filteredList, i, imageList);

      filteredList = _searchHighSignalImage(frames, filteredList);
      outMap.addAll({"imagesFiltered": filteredList});
    });

    return out; // Future.value(out);
  } on Exception {
    return null;
  }
}

Future<Uint8List> createImageAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = await createImage(
      jobData.parameters.item1, jobData.parameters.item2, jobData.parameters.item3, jobData.parameters.item4,
      sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Future<Uint8List> createImage(Uint8List highImage, Uint8List lowImage, String input, int ditDuration,
    {SendPort sendAsyncPort}) async {
  input = encodeMorse(input);
  if (input == null || input == '') return null;
  if (highImage == null || lowImage == null) return null;
  if (ditDuration <= 0) return null;

  try {
    var _highImage = Image.decodeImage(highImage);
    var _lowImage = Image.decodeImage(lowImage);
    var animation = Image.Animation();

    input = input.replaceAll(String.fromCharCode(8195), ' ');
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
      image.duration = duration;
      animation.addFrame(image);
      outList.add(on);
    }

    // image count optimation
    for (var i = animation.frames.length - 1; i > 0; i--) {
      if (outList[i] == outList[i - 1]) {
        animation.frames[i - 1].duration += animation.frames[i].duration;
        animation.frames.removeAt(i);
      }
    }

    return Image.encodeGifAnimation(animation);
  } on Exception {
    return null;
  }
}

List<List<int>> _filterImages(List<List<int>> filteredList, int imageIndex, List<Uint8List> imageList) {
  const toler = 2;
  for (var i = 0; i < filteredList.length; i++) {
    var compareImage = imageList[filteredList[i].first];
    var image = imageList[imageIndex];

    if (animated_image.compareImages(compareImage, image, toler: toler)) {
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

Map<String, dynamic> decodeMorseCode(List<int> durations, List<bool> onSignal) {
  var timeList = _buildTimeList(durations, onSignal);
  var signalTimes = foundSignalTimes(timeList);

  if (signalTimes == null) return null;

  var out = '';
  timeList.forEach((element) {
    if (element.item1)
      out += (element.item2 > signalTimes.item1) ? '-' : '.'; //2
    else if (element.item2 > signalTimes.item3) //5
      out += String.fromCharCode(8195) + "|" + String.fromCharCode(8195);
    else if (element.item2 > signalTimes.item2) //3
      out += " ";
  });

  var output = Map<String, dynamic>();
  output.addAll({"morse": out, "text": decodeMorse(out)});

  return output;
}

List<Tuple2<bool, int>> _buildTimeList(List<int> durations, List<bool> onSignal) {
  var timeList = <Tuple2<bool, int>>[];
  var i = 0;

  if (durations == null || onSignal == null || durations.length != onSignal.length) return null;

  if (durations.length == 0) return timeList;

  timeList.add(Tuple2<bool, int>(onSignal[i], durations[i]));
  for (i = 1; i < durations.length; i++) {
    if (onSignal[i - 1] != onSignal[i])
      timeList.add(Tuple2<bool, int>(onSignal[i], durations[i]));
    else
      // same signal -> add
      timeList.last = Tuple2<bool, int>(onSignal[i], timeList.last.item2 + durations[i]);
  }
  return timeList;
}

Tuple3<int, int, int> foundSignalTimes(List<Tuple2<bool, int>> timeList) {
  if (timeList == null || timeList.length == 0) return null;

  const toler = 1.2;
  var onl = <int>[];
  var offl = <int>[];

  timeList.forEach((element) {
    if (element.item1)
      onl.add(element.item2);
    else
      offl.add(element.item2);
  });
  onl.sort();
  offl.sort();

  var t1 = onl.length > 0 ? onl[0] : 99999999;
  var t2 = offl.length > 0 ? offl[0] : 99999999;
  var t3 = offl.length > 0 ? offl[0] : 99999999;
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
  var diff1 = _differenceImage(image2, image1);
  var diff2 = _differenceImage(image1, image2);

  return _imageLuminance(diff1) > _imageLuminance(diff2) ? image1 : image2;
}

Image.Image _differenceImage(Image.Image image1, Image.Image image2) {
  for (var x = 0; x < min(image1.width, image2.width); x++) {
    for (var y = 0; y < min(image1.height, image2.height); y++) {
      if (_diffBetweenPixels(image1.getPixel(x, y), true, image2.getPixel(x, y)) < 0.3) image2.setPixel(x, y, 0);
    }
  }
  return image2;
}

/// Returns a single number representing the difference between two RGB pixels
num _diffBetweenPixels(int firstPixel, bool ignoreAlpha, int secondPixel) {
  var fRed = Image.getRed(firstPixel);
  var fGreen = Image.getGreen(firstPixel);
  var fBlue = Image.getBlue(firstPixel);
  var fAlpha = Image.getAlpha(firstPixel);
  var sRed = Image.getRed(secondPixel);
  var sGreen = Image.getGreen(secondPixel);
  var sBlue = Image.getBlue(secondPixel);
  var sAlpha = Image.getAlpha(secondPixel);

  num diff = (fRed - sRed).abs() + (fGreen - sGreen).abs() + (fBlue - sBlue).abs();

  if (ignoreAlpha) {
    diff = (diff / 255) / 3;
  } else {
    diff += (fAlpha - sAlpha).abs();
    diff = (diff / 255) / 4;
  }

  return diff;
}

double _imageLuminance(Image.Image image) {
  var sum = 0;
  for (var x = 0; x < image.width; x++) {
    for (var y = 0; y < image.height; y++) {
      sum += Image.getLuminance(image.getPixel(x, y));
    }
  }

  return sum / (image.width * image.height);
}
