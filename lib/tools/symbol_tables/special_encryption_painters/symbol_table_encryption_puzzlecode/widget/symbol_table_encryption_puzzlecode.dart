import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_paint_data/widget/symbol_table_encryption_paint_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';

class PuzzleSymbolTableEncryption extends SymbolTableEncryption {
  final _ABS_TILEOFFSET = 30 / 150;

  @override
  SymbolTableEncryptionSizes sizes(SymbolTableEncryptionSizes sizes) {
    if (sizes.mode == SymbolTableEncryptionMode.FIXED_CANVASWIDTH) {
      sizes.symbolWidth = sizes.canvasWidth / (sizes.countColumns + _ABS_TILEOFFSET);
    } else {
      sizes.canvasWidth = sizes.symbolWidth * (sizes.countColumns + _ABS_TILEOFFSET);
    }
    sizes.canvasHeight = sizes.symbolWidth * (sizes.countRows + _ABS_TILEOFFSET);

    return sizes;
  }

  @override
  Canvas paint(SymbolTablePaintData paintData) {
    var countColumns = paintData.sizes.countColumns;
    var canvas = paintData.canvas;
    var data = paintData.data;
    var imageIndexes = paintData.imageIndexes;

    var _sizes = sizes(paintData.sizes);

    var countRows = _sizes.countRows;
    var symbolSize = _sizes.symbolWidth;

    final TILE_OFFSET = symbolSize * _ABS_TILEOFFSET;

    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var maxRect = Rect.fromLTWH(0, 0, _sizes.canvasWidth, _sizes.canvasHeight);
    canvas.clipRect(maxRect);
    canvas.drawRect(maxRect, paint);

    for (var i = 0; i <= countRows; i++) {
      for (var j = 0; j < countColumns; j++) {
        var imageIndex = i * countColumns + j;

        if (imageIndex < imageIndexes.length) {
          var image = data.images[imageIndexes[imageIndex]].values.first.specialEncryptionImage;

          if (image != null) {
            paintImage(
                canvas: canvas,
                fit: BoxFit.contain,
                rect: Rect.fromLTWH(
                    j * symbolSize + TILE_OFFSET, i * symbolSize + TILE_OFFSET, symbolSize, symbolSize),
                image: image);
          }
        }
      }
    }

    final LINE_WIDTH = 3 / 150 * symbolSize;

    paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = LINE_WIDTH;

    // draw left and top border

    canvas.drawLine(Offset(LINE_WIDTH / 2, 0), Offset(LINE_WIDTH / 2, countRows * symbolSize), paint);

    canvas.drawLine(Offset(0, LINE_WIDTH / 2),
        Offset(countRows > 1 ? countColumns * symbolSize : imageIndexes.length * symbolSize, LINE_WIDTH / 2), paint);

    // draw stub lines at the beginning

    for (var i = 0; i <= countRows; i++) {
      canvas.drawLine(
          Offset(0, i * symbolSize - LINE_WIDTH / 2), Offset(TILE_OFFSET, i * symbolSize - LINE_WIDTH / 2), paint);
    }

    for (var j = 0; j <= countColumns; j++) {
      canvas.drawLine(
          Offset(j * symbolSize - LINE_WIDTH / 2, 0), Offset(j * symbolSize - LINE_WIDTH / 2, TILE_OFFSET), paint);
    }

    // remove stub line endings

    paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var imageOffset = countColumns * countRows - imageIndexes.length;

    var maxWidth = countColumns * symbolSize;
    for (var i = 0; i <= countRows; i++) {
      canvas.drawRect(Rect.fromLTWH(maxWidth, i * symbolSize - 2 * LINE_WIDTH, TILE_OFFSET, LINE_WIDTH * 4), paint);
    }

    if (imageOffset > 0) {
      canvas.drawRect(
          Rect.fromLTWH((countColumns - imageOffset) * symbolSize, countRows * symbolSize - 2 * LINE_WIDTH, TILE_OFFSET,
              LINE_WIDTH * 4),
          paint);
    }

    var maxHeight = countRows * symbolSize;
    for (var j = 0; j <= countColumns; j++) {
      canvas.drawRect(Rect.fromLTWH(j * symbolSize - 2 * LINE_WIDTH, maxHeight, LINE_WIDTH * 4, TILE_OFFSET), paint);
    }

    if (imageOffset > 0) {
      for (var j = (countColumns - imageOffset + 1); j <= countColumns; j++) {
        canvas.drawRect(
            Rect.fromLTWH(j * symbolSize - 2 * LINE_WIDTH, (countRows - 1) * symbolSize, LINE_WIDTH * 4, TILE_OFFSET),
            paint);
      }
    }

    return canvas;
  }
}
