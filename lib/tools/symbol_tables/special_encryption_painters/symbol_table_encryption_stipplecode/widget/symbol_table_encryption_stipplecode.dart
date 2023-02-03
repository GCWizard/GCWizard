import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_paint_data/widget/symbol_table_encryption_paint_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';

class StippleSymbolTableEncryption extends SymbolTableEncryption {
  //measurements from original Inkscape SVG files
  final _OFFSET_VERTICAL = 131.691 / 950.639;
  final _OFFSET_HORIZONTAL = 11.789 / 579.173;

  @override
  SymbolTableEncryptionSizes sizes(SymbolTableEncryptionSizes sizes) {
    var cols = sizes.countColumns.toDouble();
    if (cols > 1) cols -= (sizes.countColumns - 1) * _OFFSET_HORIZONTAL;

    if (sizes.mode == SymbolTableEncryptionMode.FIXED_CANVASWIDTH) {
      sizes.symbolWidth = sizes.canvasWidth / cols;
      sizes.symbolHeight = sizes.symbolWidth / sizes.symbolAspectRatio;
    } else {
      sizes.canvasWidth = sizes.symbolWidth * cols;
    }

    sizes.canvasHeight = sizes.symbolHeight * sizes.countRows;
    if (sizes.countRows > 1) {
      sizes.canvasHeight -= (sizes.countRows - 1) * sizes.symbolHeight * _OFFSET_VERTICAL;
    }

    return sizes;
  }

  @override
  Canvas paint(SymbolTablePaintData paintData) {
    var countColumns = paintData.sizes.countColumns;
    var canvas = paintData.canvas;
    var data = paintData.data;
    var imageIndexes = paintData.imageIndexes;
    var _sizes = paintData.sizes;

    var countRows = _sizes.countRows;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var maxRect = Rect.fromLTWH(0, 0, _sizes.canvasWidth, _sizes.canvasHeight);
    canvas.clipRect(maxRect);
    canvas.drawRect(maxRect, paint);

    for (var i = 0; i <= countRows; i++) {
      for (var j = 0; j < countColumns; j++) {
        var imageIndex = i * countColumns + j;

        if (imageIndex < imageIndexes.length) {
          if (imageIndexes[imageIndex] != null) {
            var image = data.images[imageIndexes[imageIndex]].values.first.standardImage;

            var reverse = i % 2 == 1;

            var x;
            if (reverse) {
              x = _sizes.canvasWidth - (j + 1) * _sizes.symbolWidth;
              x += j * _sizes.symbolWidth * _OFFSET_HORIZONTAL;
            } else {
              x = j * _sizes.symbolWidth;
              if (j > 0) x -= _sizes.symbolWidth * _OFFSET_HORIZONTAL * j;
            }

            var y = i * _sizes.symbolHeight;
            if (i > 0) y -= _sizes.symbolHeight * _OFFSET_VERTICAL * i;

            if (i % 2 == 1) {
              canvas.save();
              canvas.translate(x, y);

              canvas.save();
              canvas.translate(_sizes.symbolWidth / 2, _sizes.symbolHeight / 2);
              canvas.scale(-1, 1);
              canvas.translate(-_sizes.symbolWidth / 2, -_sizes.symbolHeight / 2);
            }

            paintImage(
                canvas: canvas,
                fit: BoxFit.contain,
                rect: Rect.fromLTWH(reverse ? 0 : x, reverse ? 0 : y, _sizes.symbolWidth, _sizes.symbolHeight),
                image: image);

            if (reverse) {
              canvas.restore();
              canvas.restore();
            }
          }
        }
      }
    }

    return canvas;
  }
}
