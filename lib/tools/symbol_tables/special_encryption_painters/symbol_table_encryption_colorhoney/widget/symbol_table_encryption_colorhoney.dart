import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_paint_data/widget/symbol_table_encryption_paint_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class ColorHoneySymbolTableEncryption extends SymbolTableEncryption {
  @override
  SymbolTableEncryptionSizes sizes(SymbolTableEncryptionSizes sizes) {
    if (sizes.mode == SymbolTableEncryptionMode.FIXED_CANVASWIDTH) {
      sizes.tileWidth = sizes.canvasWidth / (sizes.countColumns + 0.5);
    } else {
      sizes.tileWidth = sizes.symbolWidth;
      sizes.canvasWidth = sizes.tileWidth * (sizes.countColumns + 0.5);
    }

    var height = sizes.tileWidth / 2;
    var a = 2 * height / sqrt(3);
    sizes.tileHeight = a * 2.5;
    sizes.symbolWidth = 2 * height;
    sizes.countRows = ((sizes.countImages / 4).ceil() / sizes.countColumns).ceil();
    sizes.canvasHeight = sizes.countRows * sizes.tileHeight;
    if (sizes.countRows > 1) {
      sizes.canvasHeight -= (sizes.countRows - 1) * a / 2;
    }

    return sizes;
  }

  @override
  Canvas paint(SymbolTablePaintData paintData) {
    var countColumns = paintData.sizes.countColumns;
    var canvas = paintData.canvas;
    var data = paintData.data;
    var imageIndexes = paintData.imageIndexes;

    var _sizes = sizes(paintData.sizes);
    var tileWidth = _sizes.tileWidth;
    var tileHeight = _sizes.tileHeight;
    var height = tileWidth / 2;
    var a = 2 * height / sqrt(3);

    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var maxRect = Rect.fromLTWH(0, 0, _sizes.canvasWidth, _sizes.canvasHeight);
    canvas.clipRect(maxRect);
    canvas.drawRect(maxRect, paint);

    var counter = 0;
    for (var index = 0; index < imageIndexes.length; index++) {
      if (imageIndexes[index] == null) continue;

      var image = data.images[imageIndexes[index]].values.first.standardImage;

      var i = (counter / 4).floor() % countColumns;
      var j = ((counter / 4).floor() / countColumns).floor();

      var tileOffsetX;
      var tileOffsetY;
      var angle;
      switch (counter % 4) {
        case 3:
          tileOffsetX = height * 2;
          tileOffsetY = a / 2;
          angle = 90.0;
          break;
        case 0:
          tileOffsetX = height / 2;
          tileOffsetY = tileHeight / 2;
          angle = 30.0;
          break;
        case 1:
          tileOffsetX = height;
          tileOffsetY = 2 * a;
          angle = 90.0;
          break;
        case 2:
          tileOffsetX = 3 * height / 2;
          tileOffsetY = tileHeight / 2;
          angle = -30.0;
          break;
      }

      var translateX = (i * tileWidth) + tileOffsetX - height;
      var translateY = (j * tileHeight) + tileOffsetY - height - (j * a / 2);

      canvas
        ..save()
        ..translate(translateX, translateY);

      canvas
        ..save()
        ..translate(height, height)
        ..rotate(degreesToRadian(angle))
        ..translate(-height, -height);

      paintImage(
          canvas: canvas,
          fit: BoxFit.contain,
          rect: Rect.fromCenter(center: Offset(height, height), width: 2 * height, height: 2 * height),
          image: image);

      canvas.restore();
      canvas.restore();

      counter++;
    }

    return canvas;
  }
}
