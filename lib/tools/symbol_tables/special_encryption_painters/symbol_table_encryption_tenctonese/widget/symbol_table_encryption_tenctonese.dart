import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_paint_data/widget/symbol_table_encryption_paint_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';

class TenctoneseSymbolTableEncryption extends SymbolTableEncryption {
  final _SCALE = 150 / 84; // 84 == maximum image width

  @override
  SymbolTableEncryptionSizes sizes(SymbolTableEncryptionSizes sizes) {
    sizes.relativeBorderWidth = 0;
    sizes.initialize();

    sizes.canvasHeight = sizes.symbolHeight * sizes.countRows * _SCALE;
    if (sizes.countRows > 1) {
      sizes.canvasHeight += ((sizes.countRows - 1) * sizes.absoluteBorderWidth) * _SCALE;
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
      var rowPosition = 0.0;
      for (var j = 0; j < countColumns; j++) {
        var imageIndex = i * countColumns + j;

        if (imageIndex < imageIndexes.length) {
          if (imageIndexes[imageIndex] != null) {
            var image = data.images[imageIndexes[imageIndex]].values.first.specialEncryptionImage;
            var width = image.width / image.height * _sizes.symbolHeight * _SCALE;

            paintImage(
                canvas: canvas,
                fit: BoxFit.contain,
                rect: Rect.fromLTWH(rowPosition, (i * _sizes.tileHeight + _sizes.absoluteBorderWidth / 2) * _SCALE,
                    width, _sizes.symbolHeight * _SCALE),
                image: image);

            rowPosition += width;
          }
        }
      }
    }

    return canvas;
  }
}
