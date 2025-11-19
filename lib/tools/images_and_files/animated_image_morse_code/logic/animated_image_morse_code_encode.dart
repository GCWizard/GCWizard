import 'dart:typed_data';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image_encode.dart';

class AnimatedImageMorseCodeJobData {
  final List<Uint8List> images;
  final int imageOn;
  final int imageOff;
  final int? imageFirst;
  final int? imageFirstDuration;
  final int? imageLast;
  final int? imageLastDuration;
  final int ditDuration;
  final String text;
  final int loopCount;

  AnimatedImageMorseCodeJobData({required this.images, required this.imageOn, required this.imageOff,
    required this.ditDuration, required this.text, this.imageFirst, this.imageFirstDuration,
    this.imageLast, this.imageLastDuration, this.loopCount = 0});
}

Future<Uint8List?> createImageMorseCodeAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! AnimatedImageMorseCodeJobData) return null;

  var data = jobData!.parameters as AnimatedImageMorseCodeJobData;
  var output = createImage(data.images, _prepareDurations(data.imageOn, data.imageOff, data.ditDuration,
      data.text, data.imageFirst, data.imageFirstDuration, data.imageLast, data.imageLastDuration), data.loopCount);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<MapEntry<int, int>> _prepareDurations(int imageOn, int imageOff, int ditDurationLength, String text,
    int? imageFirst, int? imageFirstDuration, int? imageLast, int? imageLastDuration) {

  var list = <MapEntry<int, int>>[];
  text = encodeMorse(text);

  if (imageFirst != null) {
    list.add(MapEntry(imageFirst, imageFirstDuration ?? ditDurationLength));
  }

  text = text.replaceAll('| ', '|');
  text = text.replaceAll(' |', '|');
  text = text.replaceAll('.', '.*');
  text = text.replaceAll('-', '-*');
  text = text.replaceAll('* ', ' ');
  if (text[text.length - 1] == '*' && text.length > 1) text = text.substring(0, text.length - 1);

  for (var i = 0; i < text.length; i++) {
    switch (text[i]) {
      case '.':
        list.add(MapEntry(imageOn, ditDurationLength));
        break;
      case '-':
        list.add(MapEntry(imageOn, ditDurationLength * 3));
        break;
      case '*':
        list.add(MapEntry(imageOff, ditDurationLength));
        break;
      case ' ':
        list.add(MapEntry(imageOff, ditDurationLength * 3));
        break;
      case '|':
        list.add(MapEntry(imageOff, ditDurationLength * 7));
        break;
    }
  }
  if (imageLast != null) {
    list.add(MapEntry(imageLast, imageLastDuration ?? ditDurationLength));
  }
  return list;
}