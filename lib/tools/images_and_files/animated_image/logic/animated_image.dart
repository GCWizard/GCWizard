import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:image/image.dart' as Image;

class AnimatedImageOutput {
  List<Uint8List> images;
  List<int> durations;
  List<int> linkList;
  List<Image.Image>? frames;

  AnimatedImageOutput(this.images, this.durations, this.linkList, {this.frames});
}

Future<AnimatedImageOutput?> analyseImageAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Uint8List) return null;

  var data = jobData!.parameters as Uint8List;
  var output = await analyseImage(data, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<AnimatedImageOutput?> analyseImage(Uint8List bytes,
    {bool withFramesOutput = false, SendPort? sendAsyncPort}) async {
  try {
    var progress = 0;
    final decoder = Image.findDecoderForData(bytes);

    if (decoder == null) return null;

    var animation = <Image.Image>[];
    var image = decoder.decode(bytes);
    if (image != null) animation.addAll(image.frames);

    var imageList = <Uint8List>[];
    var durations = <int>[];
    var linkList = <int>[];
    FileType extension = getFileType(bytes);

    if (animation.isNotEmpty) {
      int progressStep = max(animation.length ~/ 100, 1); // 100 steps

      for (var image in animation) {
        durations.add(image.frameDuration);
      }

      // overrides also durations
      animation = _linkSameImages(animation);

      for (int i = 0; i < animation.length; i++) {
        var index = _checkSameHash(animation, i);
        if (index < 0) {
          switch (extension) {
            case FileType.PNG:
              imageList.add(encodeTrimmedPng(animation[i]));
              break;
            default:
              imageList.add(Uint8List.fromList(Image.encodeGif(animation[i], singleFrame: true)));
              break;
          }
          linkList.add(i);
        } else {
          imageList.add(imageList[index]);
          linkList.add(index);
        }

        progress++;
        if (sendAsyncPort != null && (progress % progressStep == 0)) {
          sendAsyncPort.send(DoubleText(PROGRESS, progress / animation.length));
        }
      }
    }

    var out = AnimatedImageOutput(imageList, durations, linkList);

    if (animation.isNotEmpty && withFramesOutput) out.frames = animation;

    return out;
  } on Exception {
    return null;
  }
}

List<Image.Image> _linkSameImages(List<Image.Image> images) {
  for (int i = 1; i < images.length; i++) {
    for (int x = 0; x < i; x++) {
      if (_checkSameHash(images, x) >= 0) continue;

      if (compareImages(images[i].getBytes(), images[x].getBytes())) {
        images[i] = images[x];
        break;
      }
    }
  }

  return images;
}

bool compareImages(Uint8List image1, Uint8List image2, {int tolerance = 0}) {
  if (image1.length != image2.length) return false;

  for (int i = 0; i < image1.length; i++) {
    if ((image1[i] - image2[i]).abs() > tolerance) return false;
  }

  return true;
}

int _checkSameHash(List<Image.Image> list, int maxSearchIndex) {
  var compareHash = list[maxSearchIndex].hashCode;
  for (int i = 0; i < maxSearchIndex; i++) {
    if (list[i].hashCode == compareHash) return i;
  }

  return -1;
}
