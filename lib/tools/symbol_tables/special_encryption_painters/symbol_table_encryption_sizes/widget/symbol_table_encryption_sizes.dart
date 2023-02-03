import 'dart:math';

import 'package:flutter/material.dart';

enum SymbolTableEncryptionMode { FIXED_SYMBOLSIZE, FIXED_CANVASWIDTH }

class SymbolTableEncryptionSizes {
  @required
  int countImages;
  @required
  int countColumns;
  int countRows;
  @required
  double symbolWidth;
  @required
  double symbolHeight;
  double tileWidth;
  double tileHeight;
  double canvasWidth;
  double canvasHeight;
  // 0 - 1, percent of symbolsize
  double relativeBorderWidth;
  SymbolTableEncryptionMode mode;

  double absoluteBorderWidth;
  double symbolAspectRatio;

  SymbolTableEncryptionSizes(
      {@required this.countImages,
      @required this.countColumns,
      this.countRows,
      this.symbolWidth,
      this.symbolHeight,
      this.tileWidth,
      this.tileHeight,
      this.canvasWidth,
      this.canvasHeight,
      this.relativeBorderWidth,
      @required this.mode}) {
    initialize();
  }

  initialize() {
    _setCountRows();
    _setBorderWidth();
    _setSymbolSizes();
    _setCanvasWidth();
    _setCanvasHeight();
  }

  _setCountRows() {
    if (this.countColumns != null && this.countImages != null) {
      countRows = (countImages / countColumns).floor();
      if (countRows * countColumns < countImages) countRows++;
    }
  }

  _setBorderWidth() {
    if (relativeBorderWidth == null) relativeBorderWidth = 0.0;

    relativeBorderWidth = max(-0.9, relativeBorderWidth);
  }

  _setSymbolSizes() {
    symbolAspectRatio = symbolWidth / symbolHeight;

    if (mode == SymbolTableEncryptionMode.FIXED_CANVASWIDTH) {
      tileWidth = canvasWidth / countColumns;
      symbolWidth = tileWidth / (1 + relativeBorderWidth);
      absoluteBorderWidth = tileWidth - symbolWidth;
      symbolHeight = symbolWidth / symbolAspectRatio;
      tileHeight = symbolHeight + absoluteBorderWidth;
    } else {
      tileWidth = symbolWidth * (1 + relativeBorderWidth);
      absoluteBorderWidth = tileWidth - symbolWidth;
      tileHeight = symbolHeight + absoluteBorderWidth;
    }
  }

  _setCanvasWidth() {
    if (mode == SymbolTableEncryptionMode.FIXED_SYMBOLSIZE) {
      canvasWidth = tileWidth * countColumns;
    }
  }

  _setCanvasHeight() {
    canvasHeight = tileHeight * countRows;
  }
}
