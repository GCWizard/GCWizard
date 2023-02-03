import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:image/image.dart' as Image;

Future<Map<String, dynamic>> analyseImageAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = await analyseImage(jobData.parameters, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Future<Map<String, dynamic>> analyseImage(Uint8List bytes, {Function filterImages, SendPort sendAsyncPort}) async {
  try {
    var progress = 0;
    final decoder = Image.findDecoderForData(bytes);

    if (decoder == null) return null;

    var out = Map<String, dynamic>();
    var animation = decoder.decodeAnimation(bytes);
    int progressStep = max(animation.length ~/ 100, 1); // 100 steps

    var imageList = <Uint8List>[];
    var durations = <int>[];
    var linkList = <int>[];
    FileType extension = getFileType(bytes);

    if (animation != null) {
      animation?.frames.forEach((image) {
        durations.add(image.duration);
      });

      // overrides also durations
      animation.frames = _linkSameImages(animation.frames);

      for (int i = 0; i < animation.frames.length; i++) {
        var index = _checkSameHash(animation.frames, i);
        if (index < 0) {
          switch (extension) {
            case FileType.PNG:
              imageList.add(encodeTrimmedPng(animation.frames[i]));
              break;
            default:
              imageList.add(Image.encodeGif(animation.frames[i]));
              break;
          }
          linkList.add(i);
        } else {
          imageList.add(imageList[index]);
          linkList.add(index);
        }

        progress++;
        if (sendAsyncPort != null && (progress % progressStep == 0)) {
          sendAsyncPort.send({'progress': progress / animation.length});
        }
      }
    }

    out.addAll({"images": imageList});
    out.addAll({"durations": durations});
    out.addAll({"linkList": linkList});

    if (filterImages != null) filterImages(out, animation.frames);

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

bool compareImages(Uint8List image1, Uint8List image2, {toler = 0}) {
  if (image1.length != image2.length) return false;

  for (int i = 0; i < image1.length; i++) if ((image1[i] - image2[i]).abs() > toler) return false;

  return true;
}

int _checkSameHash(List<Image.Image> list, int maxSearchIndex) {
  var compareHash = list[maxSearchIndex].hashCode;
  for (int i = 0; i < maxSearchIndex; i++) if (list[i].hashCode == compareHash) return i;

  return -1;
}

List<List<int>> _filterImages(List<List<int>> filteredList, int imageIndex, List<Uint8List> imageList) {
  const toler = 2;
  for (var i = 0; i < filteredList.length; i++) {
    var compareImage = imageList[filteredList[i].first];
    var image = imageList[imageIndex];

    if (compareImages(compareImage, image, toler: toler)) {
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
