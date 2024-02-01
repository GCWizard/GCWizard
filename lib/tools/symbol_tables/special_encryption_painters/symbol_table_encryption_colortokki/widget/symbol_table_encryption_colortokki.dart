import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_paint_data/widget/symbol_table_encryption_paint_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class ColorTokkiSymbolTableEncryption extends SymbolTableEncryption {
  @override
  SymbolTableEncryptionSizes sizes(SymbolTableEncryptionSizes sizes) {
    if (sizes.mode == SymbolTableEncryptionMode.FIXED_CANVASWIDTH) {
      sizes.tileWidth = sizes.canvasWidth / sizes.countColumns;
      sizes.symbolWidth = sizes.tileWidth / 2;
    } else {
      sizes.tileWidth = sizes.symbolWidth * 2;
      sizes.canvasWidth = sizes.tileWidth * sizes.countColumns;
    }

    sizes.tileHeight = sizes.tileWidth;
    sizes.countRows = ((sizes.countImages / 4).ceil() / sizes.countColumns).ceil();
    sizes.canvasHeight = sizes.countRows * sizes.tileHeight;

    return sizes;
  }

  @override
  Canvas paint(SymbolTablePaintData paintData) {
    var countColumns = paintData.sizes.countColumns;
    var canvas = paintData.canvas;
    var data = paintData.data;
    var imageIndexes = paintData.imageIndexes;

    var _sizes = sizes(paintData.sizes);
    var tileSize = _sizes.tileWidth;
    var symbolSize = _sizes.symbolWidth;

    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var maxRect = Rect.fromLTWH(0, 0, _sizes.canvasWidth, _sizes.canvasHeight);
    canvas.clipRect(maxRect);
    canvas.drawRect(maxRect, paint);

    var counter = 0;
    for (var index = 0; index < imageIndexes.length; index++) {
      var image = data.images[imageIndexes[index]].values.first.specialEncryptionImage;

      var i = (counter / 4).floor() % countColumns;
      var j = ((counter / 4).floor() / countColumns).floor();

      double tileOffsetX = 0;
      double tileOffsetY = 0;
      double angle = 0;

      switch (counter % 4) {
        case 3:
          tileOffsetX = 0.5;
          tileOffsetY = 0.5;
          angle = 90.0;
          break;
        case 0:
          tileOffsetX = 0;
          tileOffsetY = 0;
          angle = 90.0;
          break;
        case 1:
          tileOffsetX = 0;
          tileOffsetY = 0.5;
          angle = 0.0;
          break;
        case 2:
          tileOffsetX = 0.5;
          tileOffsetY = 0;
          angle = 0.0;
          break;
      }

      var translateX = tileSize * (i + tileOffsetX);
      var translateY = tileSize * (j + tileOffsetY);

      canvas
        ..save()
        ..translate(translateX, translateY);

      canvas
        ..save()
        ..translate(symbolSize / 2, symbolSize / 2)
        ..rotate(degreesToRadian(angle))
        ..translate(-symbolSize / 2, -symbolSize / 2);

      if (image != null) {
        paintImage(
            canvas: canvas,
            fit: BoxFit.contain,
            rect:
                Rect.fromCenter(center: Offset(symbolSize / 2, symbolSize / 2), width: symbolSize, height: symbolSize),
            image: image);
      }
      canvas.restore();
      canvas.restore();
      counter++;
    }

    return canvas;
  }
}
