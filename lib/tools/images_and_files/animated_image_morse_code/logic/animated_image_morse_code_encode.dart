import 'dart:typed_data';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image_encode.dart';

class AnimatedImageMorseCodeJobData {
  final List<Uint8List> images;
  final int imageHigh;
  final int imageLow;
  final List<MapEntry<int, int>> durationsStart;
  final List<MapEntry<int, int>> durationsEnd;
  final int dotDuration;
  final String text;
  final int loopCount;
  final int scale;

  AnimatedImageMorseCodeJobData({required this.images, required this.imageHigh, required this.imageLow,
    required this.dotDuration, required this.text, required this.durationsStart,
    required this.durationsEnd, required this.loopCount, required this.scale});
}

Future<Uint8List?> createImageMorseCodeAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! AnimatedImageMorseCodeJobData) return null;

  var data = jobData!.parameters as AnimatedImageMorseCodeJobData;
  var output = createImage(data.images, _prepareDurations(data.imageHigh, data.imageLow, data.dotDuration,
      data.text, data.durationsStart, data.durationsEnd), data.loopCount, data.scale);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<MapEntry<int, int>> _prepareDurations(int imageHigh, int imageLow, int dotDurationLength, String text,
    List<MapEntry<int, int>> durationsStart, List<MapEntry<int, int>> durationsEnd) {

  var list = <MapEntry<int, int>>[];

  list.addAll(durationsStart);

  text = encodeMorse(text);

  text = text.replaceAll('| ', '|');
  text = text.replaceAll(' |', '|');
  text = text.replaceAll('.', '.*');
  text = text.replaceAll('-', '-*');
  text = text.replaceAll('* ', ' ');
  if (text.isNotEmpty && text[text.length - 1] == '*') text = text.substring(0, text.length - 1);

  for (var i = 0; i < text.length; i++) {
    switch (text[i]) {
      case '.':
        list.add(MapEntry(imageHigh, dotDurationLength));
        break;
      case '-':
        list.add(MapEntry(imageHigh, dotDurationLength * 3));
        break;
      case '*':
        list.add(MapEntry(imageLow, dotDurationLength));
        break;
      case ' ':
        list.add(MapEntry(imageLow, dotDurationLength * 3));
        break;
      case '|':
        list.add(MapEntry(imageLow, dotDurationLength * 7));
        break;
    }
  }

  list.addAll(durationsEnd);
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