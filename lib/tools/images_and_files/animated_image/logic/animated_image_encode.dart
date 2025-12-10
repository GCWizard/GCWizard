import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:image/image.dart' as Image;

enum EncodeMode {FORWARD, FORWARDREVERSE}

class AnimatedImageJobData {
  final List<Uint8List> images;
  final List<MapEntry<int, int>> durations;
  final EncodeMode mode;
  final int? loopDisplayDuration;
  final int loopCount;
  final int scale;

  AnimatedImageJobData({required this.images, required this.durations, required this.mode,
    this.loopDisplayDuration, required this.loopCount, required this.scale});
}

Future<Uint8List?> createImageAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! AnimatedImageJobData) return null;

  var data = jobData!.parameters as AnimatedImageJobData;
  var output = createImage(data.images, _prepareDurations(data.durations, data.mode, data.loopDisplayDuration)
      , data.loopCount, data.scale);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<MapEntry<int, int>> _prepareDurations(List<MapEntry<int, int>> durations, EncodeMode mode,
    int? loopDisplayDuration) {

  var list = List<MapEntry<int, int>>.from(durations);

  if (loopDisplayDuration != null && loopDisplayDuration > 0) {
    var imageCount = durations.length;
    if (mode == EncodeMode.FORWARDREVERSE) {
      imageCount = imageCount * 2 - 1;
    }
    imageCount = max(imageCount, 1);

    var duration = (max(loopDisplayDuration, 0) / imageCount).toInt();
    for (var i = 0; i < list.length; i++) {
      list[i] = MapEntry(list[i].key, duration);
    }
  }

  if (mode == EncodeMode.FORWARDREVERSE) {
    // 1234, 321, 234 no image with double view length
    list.addAll(list.reversed.skip(1).toList());
  }

  list.removeWhere((entry) => entry.key < 0 || entry.value < 0);

  // image count optimization
  for (var i = list.length - 1; i > 0; i--) {
    if (list[i].key == list[i - 1].key) {
      list[i - 1] = MapEntry<int, int>(list[i].key, list[i].value + list[i - 1].value);
      list.removeAt(i);
    }
  }

  return list;
}

Uint8List? createImage(List<Uint8List> images,  List<MapEntry<int, int>> durations, int loopCount, int scale) {
  try {
    if (images.isEmpty || durations.isEmpty) return null;
    var convertedImages = <Image.Image?>[];
    var maxWidth = 0;
    var maxHeight = 0;

    images.forEachIndexed((index, image) {
      Image.Image? convertedImage;
      if (durations.any((entry) => entry.key == index)) {
        var decoder = Image.findDecoderForData(image);
        if (decoder != null) {
          convertedImage = decoder.decode(image);
        }
      }
      convertedImage = convertedImage?.frames.first;
      if (convertedImage != null) {
        if (convertedImage.width > maxWidth) maxWidth = convertedImage.width;
        if (convertedImage.height > maxHeight) maxHeight = convertedImage.height;
      }
      convertedImages.add(convertedImage);
    });

    if (scale > 0) {
      maxWidth = (maxWidth * scale) ~/ 100;
      maxHeight = (maxHeight * scale) ~/ 100;
    }

    convertedImages.forEachIndexed((index, convertedImage) {
      if (convertedImage != null) {
        if (convertedImage.width != maxWidth || convertedImage.height != maxHeight) {
          if (scale != 100) {
            convertedImage = Image.copyResize(convertedImage, maintainAspect: true,
                width: (convertedImage.width * scale) ~/ 100);
          }
          if (convertedImage.width > maxWidth || convertedImage.height > maxHeight) {
            convertedImage = Image.copyResize(convertedImage, width: maxWidth, height: maxHeight);
          } else {
            convertedImage = Image.copyExpandCanvas(convertedImage,
                newWidth: maxWidth, newHeight: maxHeight, position: Image.ExpandCanvasPosition.center);
          }
          convertedImages[index] = convertedImage;
        }
      }
    });

    var animation = <Image.Image>[];
    for (var i = 0; i < durations.length; i++) {
      var key = durations[i].key;
      if (key >= 0 && key < convertedImages.length && convertedImages[key] != null) {
        var imageClone = Image.Image.from(convertedImages[key]!);
        if (i < durations.length ) {
          imageClone.frameDuration = max(durations[i].value, 0);
        }
        animation.add(imageClone);
      }
    }

    var encoder = Image.GifEncoder(repeat: max(loopCount, 0));
    for (var image in animation) {
      encoder.addFrame(image, duration: (image.frameDuration/ 10).toInt());
    }

    return encoder.finish();

  } on Exception {
    return null;
  }
}