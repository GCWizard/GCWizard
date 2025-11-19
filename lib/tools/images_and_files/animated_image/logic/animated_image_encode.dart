import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:image/image.dart' as Image;
import 'package:utility/utility.dart';

enum EncodeMode {LOOP, REVERSE}

class AnimatedImageJobData {
  final List<Uint8List> images;
  final List<MapEntry<int, int>> durations;
  final EncodeMode mode;
  final int? loopDisplayDuration;
  final int loopCount;

  AnimatedImageJobData({required this.images, required this.durations, required this.mode,
    this.loopDisplayDuration, this.loopCount = 0});
}

Future<Uint8List?> createImageAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! AnimatedImageJobData) return null;

  var data = jobData!.parameters as AnimatedImageJobData;
  var output = createImage(data.images, _prepareDurations(data.durations, data.mode, data.loopDisplayDuration)
      , data.loopCount);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<MapEntry<int, int>> _prepareDurations(List<MapEntry<int, int>> durations, EncodeMode mode,
    int? loopDisplayDuration) {

  List<MapEntry<int, int>>? list;

  if (loopDisplayDuration != null && loopDisplayDuration > 0) {
    list = List<MapEntry<int, int>>.from(durations);
    var duration = (max(loopDisplayDuration, 0) / max(durations.length, 1)).toInt();
    for (var i = 0; i < list.length; i++) {
      list[i] = MapEntry(list[i].key, duration);
    }
  }

  if (mode == EncodeMode.REVERSE) {
    // 1234, 321, 234 no image with double view length
    list = list ?? List<MapEntry<int, int>>.from(durations);

    var list2 = list.reversed.toList();
    list2.removeFirst();
    list.addAll(list2);
    list2 = List<MapEntry<int, int>>.from(durations);
    list2.removeFirst();
    list.addAll(list2);
    return list;
  }
  return list ?? durations;
}

Uint8List? createImage(List<Uint8List> images,  List<MapEntry<int, int>> durations, int loopCount) {
  try {
    if (images.isEmpty || durations.isEmpty) return null;
    var convertedImages = <Image.Image?>[];
    for (var bytes in images) {
      var decoder = Image.findDecoderForData(bytes);
      Image.Image? convertedImage;
      if (decoder != null) {
        convertedImage = decoder.decode(bytes);
      }
      convertedImages.add(convertedImage);
    }

    // image count optimization
    for (var i = durations.length - 1; i > 0; i--) {
      if (durations[i].key == durations[i - 1].key) {
        durations[i - 1] = MapEntry<int, int>(durations[i].key, durations[i].value + durations[i - 1].value);
        durations.removeAt(i);
      }
    }

    var animation = <Image.Image>[];
    for (var i = 0; i < durations.length; i++) {
      var key = durations[i].key;
      if (key > 0 && key <= convertedImages.length && convertedImages[key - 1] != null) {
        var imageClone = Image.Image.from(convertedImages[key - 1]!);
        if (i < durations.length ) {
          imageClone.frameDuration = max(durations[i].value, 0);
        }
        animation.add(imageClone);
      }
    }

    var encoder = Image.GifEncoder(repeat: loopCount);
    for (var image in animation) {
      encoder.addFrame(image);
    }

    return encoder.finish();

  } on Exception {
    return null;
  }
}