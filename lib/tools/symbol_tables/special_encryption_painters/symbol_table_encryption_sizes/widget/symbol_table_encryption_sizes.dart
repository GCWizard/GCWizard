import 'dart:math';

enum SymbolTableEncryptionMode { FIXED_SYMBOLSIZE, FIXED_CANVASWIDTH }

class SymbolTableEncryptionSizes {
  int countImages;
  int countColumns;
  double symbolWidth;
  double symbolHeight;
  double canvasWidth;
  double canvasHeight;
  // 0 - 1, percent of symbolsize
  double? relativeBorderWidth;
  SymbolTableEncryptionMode mode;

  late double absoluteBorderWidth;
  late double symbolAspectRatio;
  late int countRows;
  late double tileWidth;
  late double tileHeight;

  SymbolTableEncryptionSizes({
      required this.countImages,
      required this.countColumns,
      required this.symbolWidth,
      required this.symbolHeight,
      this.canvasWidth = 0,
      this.canvasHeight = 0,
      required this.relativeBorderWidth,
      required this.mode}) {
    initialize();
  }

  void initialize() {
    _setCountRows();
    _setBorderWidth();
    _setSymbolSizes();
    _setCanvasWidth();
    _setCanvasHeight();
  }

  void _setCountRows() {
    countRows = (countImages / countColumns).floor();
    if (countRows * countColumns < countImages) countRows = countRows + 1;
  }

  void _setBorderWidth() {
    relativeBorderWidth ??= 0.0;

    relativeBorderWidth = max(-0.9, relativeBorderWidth!);
  }

  void _setSymbolSizes() {
    symbolAspectRatio = symbolWidth / symbolHeight;

    if (mode == SymbolTableEncryptionMode.FIXED_CANVASWIDTH) {
      tileWidth = canvasWidth / countColumns;
      symbolWidth = tileWidth / (1 + relativeBorderWidth!);
      absoluteBorderWidth = tileWidth - symbolWidth;
      symbolHeight = symbolWidth / symbolAspectRatio;
      tileHeight = symbolHeight + absoluteBorderWidth;
    } else {
      tileWidth = symbolWidth * (1 + relativeBorderWidth!);
      absoluteBorderWidth = tileWidth - symbolWidth;
      tileHeight = symbolHeight + absoluteBorderWidth;
    }
  }

  void _setCanvasWidth() {
    if (mode == SymbolTableEncryptionMode.FIXED_SYMBOLSIZE) {
      canvasWidth = tileWidth * countColumns;
    }
  }

  void _setCanvasHeight() {
    canvasHeight = tileHeight * countRows;
  }
}
