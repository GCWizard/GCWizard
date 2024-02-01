import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/drawable_image_data.dart';

Future<Uint8List> input2Image(DrawableImageData imageData) async {
  var width = 0.0;
  var height = 0.0;

  for (var line in imageData.lines) {
    width = max(width, line.length.toDouble());
    height++;
  }
  width = width * imageData.pointSize + 2 * imageData.bounds;
  height = height * imageData.pointSize + 2 * imageData.bounds;

  final canvasRecorder = PictureRecorder();
  final canvas = Canvas(canvasRecorder, Rect.fromLTWH(0, 0, width, height));

  final paint = Paint()
    ..color = Color(imageData.colors.values.first) //Colors.white
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  for (int row = 0; row < imageData.lines.length; row++) {
    for (int column = 0; column < imageData.lines[row].length; column++) {
      paint.color = Color(imageData.colors.values.first); // Colors.white
      if (imageData.colors.containsKey(imageData.lines[row][column])) {
        paint.color = Color(imageData.colors[imageData.lines[row][column]]!);
      }

      if (imageData.lines[row][column] != '0') {
        canvas.drawRect(
            Rect.fromLTWH(column * imageData.pointSize + imageData.bounds, row * imageData.pointSize + imageData.bounds,
                imageData.pointSize, imageData.pointSize),
            paint);
      }
    }
  }

  final img = await canvasRecorder.endRecording().toImage(width.floor(), height.floor());
  final data = await img.toByteData(format: ImageByteFormat.png);
  if (data == null) {
    throw Exception('Image data not created.');
  }

  return trimNullBytes(data.buffer.asUint8List());
}
