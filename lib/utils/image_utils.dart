import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as Image;

Image.Image? decodeImage4ChannelFormat(Uint8List bytes) {
  var image = Image.decodeImage(bytes);
  if (image == null) return null;

  if (image.numChannels != 4 || image.format != Image.Format.uint8) {
    image = image.convert(format: Image.Format.uint8, numChannels: 4);
  }
  return image;
}

Image.ColorRgb8 convertColor(Color color) {
  return Image.ColorRgb8((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());
}
