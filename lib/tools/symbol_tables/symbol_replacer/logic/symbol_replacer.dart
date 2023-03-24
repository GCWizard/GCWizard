import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer_symboldata.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:image/image.dart' as Image;
import 'package:tuple/tuple.dart';

class ReplaceSymbolsInput {
  final Uint8List image;
  final int blackLevel;
  final double similarityLevel;
  final int gap;
  final SymbolReplacerImage? symbolImage;
  final List<Map<String, SymbolReplacerSymbolData>>? compareSymbols;
  final double similarityCompareLevel;
  final double? mergeDistance;

  ReplaceSymbolsInput({
      required this.image,
      this.blackLevel = 50,
      this.similarityLevel = 90.0,
      this.gap = 1,
      this.symbolImage,
      this.compareSymbols,
      this.similarityCompareLevel = 80.0,
      this.mergeDistance});
}

Future<SymbolReplacerImage?> replaceSymbolsAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! ReplaceSymbolsInput) return null;

  var data = jobData!.parameters as ReplaceSymbolsInput;
  var output = await replaceSymbols(
      data.image, data.blackLevel, data.similarityLevel,
      gap: data.gap,
      symbolImage: data.symbolImage,
      compareSymbols: data.compareSymbols,
      similarityCompareLevel: data.similarityCompareLevel,
      mergeDistance: data.mergeDistance);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<SymbolReplacerImage?> replaceSymbols(Uint8List image, int blackLevel, double similarityLevel,
    {int gap = 1,
    SymbolReplacerImage? symbolImage,
    List<Map<String, SymbolReplacerSymbolData>>? compareSymbols,
    double? similarityCompareLevel,
    double? mergeDistance}) async {
  symbolImage ??= SymbolReplacerImage(image);

  symbolImage.splitAndGroupSymbols(blackLevel * 255 ~/ 100, similarityLevel,
      gap: gap,
      compareSymbols: compareSymbols,
      similarityCompareLevel: similarityCompareLevel,
      mergeDistance: mergeDistance);

  return Future.value(symbolImage);
}

class SymbolReplacerImage {
  /// source image
  late Uint8List _image;

  /// converted  source image
  Image.Image? _bmp;

  /// source image with symbol borders
  Uint8List? _outputImageBytes;

  /// assigned symbol table (original)
  List<Map<String, SymbolReplacerSymbolData>>? compareSymbols;

  /// used symbol table (original)
  List<Map<String, SymbolReplacerSymbolData>>? _usedCompareSymbols;

  /// image with groups from  cropped _usedCompareSymbols
  SymbolReplacerImage? _usedCompareSymbolsImage;
  double? _similarityCompareLevel;

  /// detected lines from _image (after symbol merge)
  List<_SymbolRow> lines = [];

  /// detected lines from _image
  final List<_SymbolRow> _sourceLines = [];

  /// detected symbols (after symbol merge)
  List<Symbol> symbols = [];

  /// detected symbols
  final List<Symbol> _sourceSymbols = [];

  /// symbol groups (same symbol/ text)
  List<SymbolGroup> symbolGroups = [];

  List<double>? _mergeDistanceSteps;
  double? _mergeDistance;
  static const int _mergeDistanceInit = 5; // %

  int? _blackLevel;
  double? _similarityLevel;
  int? _gap;

  SymbolReplacerImage(Uint8List image) {
    _image = image;
    _outputImageBytes = image;
  }

  /// <summary>
  /// source image
  /// </summary>
  Uint8List getImage() {
    return _image;
  }

  /// <summary>
  /// Image with symbol borders
  /// </summary>
  Uint8List? getBorderImage() {
    if (_outputImageBytes != null) return _outputImageBytes!;

    var mergedImage = _mergeBorderData();
    if (mergedImage == null) return null;
    _outputImageBytes = encodeTrimmedPng(mergedImage);
    return _outputImageBytes;
  }

  /// <summary>
  /// SymbolImage with compary symbols (symbol table)
  /// </summary>
  SymbolReplacerImage? getCompareImage() {
    return _usedCompareSymbolsImage;
  }

  /// <summary>
  /// determines the text based on the assigned symbols
  /// </summary>
  String? getTextOutput({bool withLinebreak = false}) {
    var output = '';
    var referenceWidth = _referenceWidth(symbols);

    for (var line in lines) {
      var rightBorder = 0.0;
      for (var symbol in line.symbols) {
        if (symbol.refPoint.dx - rightBorder > referenceWidth) output += ' ';
        output += symbol.symbolGroup?.text != null ? symbol.symbolGroup!.text! : '';
        rightBorder = symbol.refPoint.dx + symbol.bmp.width;
      }
      if (withLinebreak) output += '\r\n';
    }
    return output.trim();
  }

  /// <summary>
  /// seperate symbols from image and create SymbolGroups
  /// </summary>
  void splitAndGroupSymbols(int blackLevel, double similarityLevel,
      {int gap = 1,
      List<Map<String, SymbolReplacerSymbolData>>? compareSymbols,
      double? similarityCompareLevel = 80,
      bool groupSymbols = true,
      double? mergeDistance}) {
    _bmp ??= Image.decodeImage(_image);
    if (_bmp == null) return;

    // detect changed parameter -> recalc

    if (_blackLevel != blackLevel) {
      lines.clear();
      _sourceLines.clear();
      symbols.clear();
      _sourceSymbols.clear();
      symbolGroups.clear();
    }
    _blackLevel = blackLevel;

    if (_gap != gap) {
      symbols.clear();
      _sourceSymbols.clear();
      symbolGroups.clear();
    }
    _gap = gap;

    if (_similarityLevel != similarityLevel) symbolGroups.clear();
    _similarityLevel = similarityLevel;
    _similarityCompareLevel = similarityCompareLevel;

    mergeDistance = mergeDistance ?? _mergeDistance;
    if (_mergeDistance != mergeDistance) {
      lines.clear();
      symbols.clear();
      symbolGroups.clear();
    }
    _mergeDistance = mergeDistance;

    if (_sourceLines.isEmpty) _splitToLines();

    var symbolsCloned = false;
    if (_sourceSymbols.isEmpty && _blackLevel != null) {
      for (var line in _sourceLines) {
        line._splitLineToSymbols(gap, _blackLevel!);
        _sourceSymbols.addAll(line.symbols);
      }
      symbolsCloned = true;
      _cloneSourceLines();
    }

    if (symbolGroups.isEmpty && groupSymbols) {
      _mergeDistance ??= _mergeSymbolsDefault(_mergeDistanceInit);

      if (!symbolsCloned) _cloneSourceLines();
      if (_mergeDistance != null && _mergeDistance! > 0) _mergeSymbols(_mergeDistance!);

      _groupSymbols();
    }

    if (this.compareSymbols != compareSymbols) _usedCompareSymbolsImage = null;

    if (groupSymbols & (compareSymbols != null) & (_similarityCompareLevel != null)) {
      if (this.compareSymbols != _usedCompareSymbols || _usedCompareSymbolsImage == null) {
        _usedCompareSymbolsImage = _buildCompareSymbols(compareSymbols!);
      }
      _useCompareSymbols(_usedCompareSymbolsImage);
      _usedCompareSymbols = compareSymbols;
      this.compareSymbols = compareSymbols;
      mergeSymbolGroups();
    }

    // rebuild image
    _outputImageBytes = null;
  }

  /// <summary>
  /// add Symbol to SymbolGroup
  /// </summary>
  void addToGroup(Symbol symbol, SymbolGroup? symbolGroup) {
    if (symbolGroup == null) return;
    if (symbol.symbolGroup != null) {
      symbol.symbolGroup?.symbols.remove(symbol);
      if (symbol.symbolGroup!.symbols.isEmpty) symbolGroups.remove(symbol.symbolGroup);
    }
    symbolGroup.symbols = <Symbol>[];

    _addSymbolToGroup(symbol, symbolGroup);
  }

  /// <summary>
  /// remove Symbol from SymbolGroup (create new SymbolGroup)
  /// </summary>
  void removeFromGroup(Symbol symbol) {
    if (symbol.symbolGroup != null) symbol.symbolGroup?.symbols.remove(symbol);
    var symbolGroup = SymbolGroup();
    symbolGroups.add(symbolGroup);

    _addSymbolToGroup(symbol, symbolGroup);
  }

  void _addSymbolToGroup(Symbol symbol, SymbolGroup symbolGroup) {
    symbolGroup.symbols.add(symbol);
    if ((symbol.symbolGroup?.symbols != null) && (symbol.symbolGroup!.symbols.isEmpty)) {
      symbolGroups.remove(symbol.symbolGroup);
    }
    symbol.symbolGroup = symbolGroup;
  }

  /// <summary>
  /// SymbolGroup for these symbols together
  /// </summary>
  void buildSymbolGroup(List<Symbol> symbols) {
    if (symbols.isEmpty) return;

    removeFromGroup(symbols.first);
    for (var i = 1; i < symbols.length; i++) {
      addToGroup(symbols[i], symbols.first.symbolGroup);
    }
  }

  /// <summary>
  /// merge SymbolGroups with same compareSymbol
  /// </summary>
  void mergeSymbolGroups() {
    if (symbolGroups.isEmpty) return;

    for (var i= 0; i< symbolGroups.length; i++) {
      var compareSymbol = symbolGroups[i].compareSymbol;
      if (compareSymbol != null) {
        var groups = symbolGroups.where((group) => group.compareSymbol == compareSymbol).toList();
        if (groups.length > 1) {
          for (var x = groups.length - 1; x > 0; x--) {
            for (var y = groups.elementAt(x).symbols.length - 1; y >= 0; y--) {
              _addSymbolToGroup(groups.elementAt(x).symbols[y], groups.elementAt(0));
            }
          }
        }
      }
    }
  }

  /// <summary>
  /// reset all SymbolGroup text
  /// </summary>
  void resetGroupText() {
    for (var group in symbolGroups) {
      group.text = null;
      group.compareSymbol = null;
    }
  }

  /// <summary>
  /// extract symbols from the compare symbol table
  /// </summary>
  SymbolReplacerImage? _buildCompareSymbols(List<Map<String, SymbolReplacerSymbolData>> compareSymbols) {
    if (compareSymbols.isEmpty || compareSymbols.first.values.first.bytes == null) return null;
    if (_blackLevel == null || _similarityLevel == null || _gap == null) return null;
    var compareSymbolImage = SymbolReplacerImage(compareSymbols.first.values.first.bytes!);

    for (var element in compareSymbols) {
      element.forEach((text, symbolData) {
        if (symbolData.bytes != null) {
          var symbolImage = SymbolReplacerImage(symbolData.bytes!);
          symbolImage.splitAndGroupSymbols(_blackLevel!, _similarityLevel!, gap: _gap!, groupSymbols: false);
          // merge all symbols parts
          for (var i = symbolImage.symbols.length - 2; i >= 0; i--) {
            symbolImage.mergeSymbol(symbolImage.symbols[i], symbolImage.symbols[i + 1], null);
          }

          // create SymbolGroups with text for the symbols
          // ignore: unused_local_variable
          for (var element in symbolImage.symbols) {
            var symbolGroup = SymbolGroup();
            symbolGroup.symbols = symbolImage.symbols;
            symbolGroup.text = text;
            for (var symbol in symbolGroup.symbols) {
              symbol.symbolGroup = symbolGroup;
            }
            symbolGroup.compareSymbol = symbolData;

            compareSymbolImage.symbols.addAll(symbolGroup.symbols);
            compareSymbolImage.symbolGroups.add(symbolGroup);
          }
          symbolImage.symbols = [];
        }
      });
    }

    return compareSymbolImage;
  }

  /// <summary>
  /// Compare the symbols in the specified symbol table with the existing symbols and
  /// then assign the text to the groups
  /// return: Sum of percent match for all symbols
  /// </summary>
  double _useCompareSymbols(SymbolReplacerImage? compareSymbolImage) {
    var percentSum = 0.0;
    if (compareSymbolImage == null || _similarityCompareLevel == null) return 0;

    // build hash for compare
    for (int i = 0; i < compareSymbolImage.symbols.length; i++) {
      compareSymbolImage.symbols[i].hash = ImageHashing.AverageHash(compareSymbolImage.symbols[i].bmp);
    }

    // found the best compare symbols
    for (int i = 0; i < symbolGroups.length; i++) {
      if ((symbolGroups[i].text == null) || (symbolGroups[i].text!.isEmpty)) {
        double maxPercent = 0.0;
        Symbol? maxPercentSymbol;

        Symbol symbol1 = symbolGroups[i].symbols.first;

        for (int x = 0; x < compareSymbolImage.symbols.length; x++) {
          if (symbol1.hash != null && compareSymbolImage.symbols[x].hash != null) {
            var similarity = ImageHashing.Similarity(symbol1.hash!, compareSymbolImage.symbols[x].hash!);
            if (similarity > maxPercent) {
              maxPercent = similarity;
              maxPercentSymbol = compareSymbolImage.symbols[x];
            }
          }
        }
        if (maxPercent >= _similarityCompareLevel! && (maxPercentSymbol?.symbolGroup != null)) {
          symbolGroups[i].text = maxPercentSymbol?.symbolGroup?.text;
          symbolGroups[i].compareSymbol = maxPercentSymbol?.symbolGroup?.compareSymbol;
        }
        percentSum += maxPercent;
      }
    }
    return percentSum;
  }

  /// <summary>
  /// creates an image with frames around the symbols
  /// </summary>
  Image.Image? _mergeBorderData() {
    if (_bmp == null) return null;
    var bmp = Image.Image(width: _bmp!.width, height: _bmp!.height);

    Image.compositeImage(bmp, _bmp!);

    for (var symbol in symbols) {
      var rect = Rectangle<int>(
        symbol.refPoint.dx.toInt(),
        symbol.refPoint.dy.toInt(),
        symbol.bmp.width,
        symbol.bmp.height,
      );

      var color = Image.ColorRgb8(Colors.blue.red, Colors.blue.green, Colors.blue.blue);
      Image.drawRect(bmp, x1: rect.left, y1: rect.top, x2: rect.right, y2: rect.bottom, color: color);
      Image.drawRect(bmp, x1: rect.left - 1, y1: rect.top - 1, x2: rect.right + 1,y2:  rect.bottom + 1, color: color);
    }

    return bmp;
  }

  /// <summary>
  /// Split the image into individual lines
  /// </summary>
  void _splitToLines() {
    var emptyLineIndex = <int>[];
    if (_bmp == null || _blackLevel == null) return;

    /// <summary>
    /// search empty lines
    /// </summary>
    for (int y = 0; y < _bmp!.height; y++) {
      if (_emptyRow(_bmp!, 0, _bmp!.width - 1, y, _blackLevel!)) emptyLineIndex.add(y);
    }

    if (emptyLineIndex.isEmpty) emptyLineIndex.add(_bmp!.width - 1);

    // split lines
    if (emptyLineIndex.isNotEmpty) {
      // first line
      if (emptyLineIndex.first != 0) _cutLine(0, emptyLineIndex.first - 1);

      for (int i = 1; i < emptyLineIndex.length; i++) {
        if (emptyLineIndex[i - 1] != emptyLineIndex[i] - 1) _cutLine(emptyLineIndex[i - 1] + 1, emptyLineIndex[i] - 1);
      }

      // last line
      if ((emptyLineIndex.last != _bmp!.height - 1) && (emptyLineIndex.last != 0)) {
        _cutLine(emptyLineIndex.last + 1, _bmp!.height - 1);
      }
    }
  }

  /// <summary>
  /// Cut line and add to sourceLines
  /// </summary>
  void _cutLine(int startIndex, int endIndex) {
    if (_bmp == null) return;
    var rect = Rectangle<double>(0, startIndex.toDouble(), _bmp!.width.toDouble(), (endIndex - startIndex).toDouble());

    if (rect.height > 0) {
      _sourceLines.add(_SymbolRow(
          rect, Image.copyCrop(_bmp!, x: rect.left.toInt(), y: rect.top.toInt(), width: rect.width.toInt(), height: rect.height.toInt())));
    }
  }

  /// <summary>
  /// Group symbols together
  /// </summary>
  void _groupSymbols() {
    if (_similarityLevel == null) return;
    for (int i = 0; i < symbols.length; i++) {
      symbols[i].hash = ImageHashing.AverageHash(symbols[i].bmp);
    }

    for (int i = 0; i < symbols.length; i++) {
      double maxPercent = 0;
      int maxPercentSymbolIndex = 0;

      Symbol symbol1 = symbols[i];

      for (int x = 0; x < i; x++) {
        var similarity = ImageHashing.Similarity(symbol1.hash!, symbols[x].hash!);
        if (similarity > maxPercent) {
          maxPercent = similarity;
          maxPercentSymbolIndex = x;
        }
      }

      if ((maxPercent < _similarityLevel!) || (maxPercentSymbolIndex > i)) {
        var group = SymbolGroup();
        symbolGroups.add(group);
        symbolGroups[symbolGroups.length - 1].symbols.add(symbol1);
        symbol1.symbolGroup = group;
      } else {
        var image2 = symbols[maxPercentSymbolIndex];

        // search symbolGroup
        var group = _searchSymbolGroup(image2);
        if (group != null) {
          group.symbols.add(symbol1);
          symbol1.symbolGroup = group;
        }
      }
    }
  }

  /// <summary>
  /// it is an empty line ?
  /// </summary>
  static bool _emptyRow(Image.Image bmp, int startColumn, int endColumn, int row, int blackLevel) {
    for (int x = startColumn; x <= endColumn; x++) {
      var pixel = bmp.getPixel(x, row);
      if (_blackPixel(pixel, blackLevel)) return false;
    }
    return true;
  }

  /// <summary>
  /// Pixels darker than threshold  ?
  /// </summary>
  static bool _blackPixel(Image.Pixel pixel, int blackLevel) {
    return (pixel.luminance <= blackLevel);
  }

  /// <summary>
  /// Average of all symbol widths
  /// </summary>
  static int _referenceWidth(List<Symbol> symbols) {
    int width = 0;

    for (var symbol in symbols) {
      width = max(symbol.bmp.width, width);
    }

    return width;
  }

  /// <summary>
  /// closest distance leading to symbol merging
  /// </summary>
  double? nextMergeDistance(double? actMergeDistance) {
    double? next;
    actMergeDistance = actMergeDistance ?? _mergeDistance;
    if (actMergeDistance != null && _mergeDistanceSteps != null) {
      var nextl = _mergeDistanceSteps!.where((value) => value > actMergeDistance!);
      if (nextl.isNotEmpty) next = nextl.first;
    }

    // if (next == null) {
    //   double minDist;
    //   actMergeDistance = actMergeDistance ?? 0;
    //   for (int x = 0; x < symbols.length; x++) {
    //     for (int y = x+1; y < symbols.length; y++) {
    //       var dist = symbols[x].distance(symbols[y]);
    //       if (dist >= 2*actMergeDistance) minDist = min(minDist ?? 99999999, dist);
    //     }
    //   }
    //   minDist = minDist ?? 0;
    //   next = (minDist/2) + 0.0001; // +0.0001 fix round problem
    //   if (!_mergeDistanceSteps.contains(next)) _mergeDistanceSteps.add(next);
    // }
    // return next;

    return next ?? _mergeDistanceSteps!.last;
  }

  /// <summary>
  /// previous spacing that caused symbols to be merged
  /// </summary>
  double? prevMergeDistance(double? actMergeDistance) {
    double? prev;
    actMergeDistance = actMergeDistance ?? _mergeDistance;
    if (actMergeDistance != null && _mergeDistanceSteps != null) {
      var prevl = _mergeDistanceSteps!.where((value) => value < actMergeDistance!);
      if (prevl.isNotEmpty) prev = prevl.last;
    }
    return prev;
  }

  /// <summary>
  /// calc init merge distance
  /// </summary>
  double? _mergeSymbolsDefault(int mergeDistance) {
    // calc possible steps
    _mergeDistanceSteps ??= _calcMergeDistances();

    double? minLineDistance;

    for (var i = 0; i < lines.length - 1; i++) {
      var dist = lines[i + 1].size.top - lines[i].size.bottom;
      if (dist > 0 && (minLineDistance == null || minLineDistance > dist)) minLineDistance = dist;
    }

    var _mergeDistance = 0.0;
    // calc init merge distance
    var referenceWidth = _referenceWidth(symbols);
    // value symbol width
    _mergeDistance = referenceWidth * mergeDistance / 100.0;
    // and line distance
    if (minLineDistance != null && minLineDistance > 0) {
      _mergeDistance = (_mergeDistance == 0.0)
          ? referenceWidth.toDouble()
          : min(_mergeDistance, (minLineDistance - 1) / 2);
    }

    if (_mergeDistance > 0) return prevMergeDistance(_mergeDistance);

    return null;
  }

  /// <summary>
  /// calc possible merge distances steps
  /// </summary>
  List<double> _calcMergeDistances() {
    var distances = <double>[0];
    for (int x = 0; x < symbols.length; x++) {
      for (int y = x + 1; y < symbols.length; y++) {
        var dist = symbols[x].distance(symbols[y]);
        if (dist > 0) {
          dist = (dist / 2) + 0.0001; // +0.0001 fix round problem
          if (!distances.contains(dist)) distances.add(dist);
        }
      }
    }
    distances.sort();
    return distances;
  }

  /// <summary>
  /// Verification and merging of all symbols
  /// </summary>
  void _mergeSymbols(double maxDistance) {
    var rectList = <Rectangle<double>>[];
    var symbolList = <Symbol?>[];
    var changed = false;

    symbolList.addAll(symbols);
    // build rectangles with oversize
    for (var symbol in symbolList) {
      if (symbol != null) rectList.add(symbol._borderRectangleWithOffset(maxDistance));
    }

    do {
      changed = false;
      for (int x = 0; x < symbolList.length; x++) {
        for (int y = x + 1; y < symbolList.length; y++) {
          if (symbolList[x] != null && symbolList[y] != null) {
            // overlaps rectangles ?
            if (rectList[x].intersects(rectList[y])) {
              var line = _searchSymbolRow(symbolList[y]!);
              if (line != null) {
                // merge symbols
                mergeSymbol(symbolList[x]!, symbolList[y]!, line);
                rectList[x] = symbolList[x]!._borderRectangleWithOffset(maxDistance);
                symbolList[y] = null;
                changed = true;
              }
            }
          }
        }
      }
    } while (changed);
  }

  /// <summary>
  /// Find the row that the symbol is associated with
  /// </summary>
  _SymbolRow? _searchSymbolRow(Symbol symbol) {
    for (_SymbolRow line in lines) {
      if (line.symbols.contains(symbol)) return line;
    }
    return null;
  }

  /// <summary>
  /// Find the SymbolGroup that the symbol is associated with
  /// </summary>
  SymbolGroup? _searchSymbolGroup(Symbol symbol) {
    for (SymbolGroup group in symbolGroups) {
      if (group.symbols.contains(symbol)) return group;
    }
    return null;
  }

  /// <summary>
  /// Merge symbols
  /// </summary>
  void mergeSymbol(Symbol symbol1, Symbol symbol2, _SymbolRow? line) {
    var box = symbol1._borderRectangle().boundingBox(symbol2._borderRectangle());

    if (_bmp == null) return;
    symbol1.refPoint = Offset(box.left, box.top);
    symbol1.bmp = Image.copyCrop(_bmp!, x: box.left.toInt(), y: box.top.toInt(), width: box.width.toInt(), height: box.height.toInt());

    var group = _searchSymbolGroup(symbol2);
    if (group != null) group.symbols.remove(symbol2);

    symbols.remove(symbol2);
    if (line!= null) line.symbols.remove(symbol2);
  }

  void _cloneSourceLines() {
    lines.clear();
    symbols.clear();
    for (var line in _sourceLines) {
      var lineClone = line._clone();
      lines.add(lineClone);
      symbols.addAll(lineClone.symbols);
    }
  }
}

class _SymbolRow {
  late Rectangle<double> size;
  late Image.Image bmp;
  var symbols = <Symbol>[];

  _SymbolRow(this.size, this.bmp);

  _SymbolRow _clone() {
    var symbolRow = _SymbolRow(size, bmp);
    for (var symbol in symbols) {
      var symbolClone = symbol._clone();
      symbolClone.row = symbolRow;
      symbolRow.symbols.add(symbolClone);
    }
    return symbolRow;
  }

  /// <summary>
  /// Break line into symbols
  /// </summary>
  void _splitLineToSymbols(int gap, int blackLevel) {
    var emptyColumnIndex = <int>[];

    // detect empty columns
    for (int x = 0; x < bmp.width; x++) {
      var emptyColumn = true;
      for (int y = 0; y < bmp.height; y++) {
        var pixel = bmp.getPixel(x, y);

        if (SymbolReplacerImage._blackPixel(pixel, blackLevel)) {
          emptyColumn = false;
          break;
        }
      }
      if (emptyColumn) emptyColumnIndex.add(x);
    }

    if (emptyColumnIndex.isNotEmpty) {
      emptyColumnIndex = _removeGapColumns(emptyColumnIndex, gap);

      if (emptyColumnIndex.first != 0) _cutSymbol(0, emptyColumnIndex.first - 1, blackLevel);

      for (int i = 1; i < emptyColumnIndex.length; i++) {
        if (emptyColumnIndex[i - 1] != emptyColumnIndex[i] - 1) {
          _cutSymbol(emptyColumnIndex[i - 1] + 1, emptyColumnIndex[i] - 1, blackLevel);
        }
      }

      if ((emptyColumnIndex.last != bmp.width - 1) && (emptyColumnIndex.last != 0)) {
        _cutSymbol(emptyColumnIndex.last + 1, bmp.width - 1, blackLevel);
      }
    }
  }

  List<int> _removeGapColumns(List<int> emptyColumnIndex, int gap) {
    if (gap > 1) {
      for (int i = emptyColumnIndex.length - 1 - gap; i > 0; i--) {
        // previus column not empty ?
        if (emptyColumnIndex[i - 1] != emptyColumnIndex[i] - 1) {
          var emtyColumnsCount = _countEmptyColumns(emptyColumnIndex, i);

          if (emtyColumnsCount <= gap) {
            for (int x = emtyColumnsCount - 1; x >= 0; x--) {
              emptyColumnIndex.removeAt(i + x);
            }
          }
        }
      }
    }
    return emptyColumnIndex;
  }

  /// <summary>
  /// count the empty columns between symbols
  /// </summary>
  int _countEmptyColumns(List<int> emptyColumnIndex, int startIndex) {
    var counter = 1;
    for (int i = startIndex; i < emptyColumnIndex.length - 1; i++) {
      if (emptyColumnIndex[i] == emptyColumnIndex[i + 1] - 1) {
        counter++;
      } else {
        break;
      }
    }
    return counter;
  }

  /// <summary>
  /// Cut symbol and add to symbols
  /// </summary>
  Rectangle<double> _cutSymbol(int startIndex, int endIndex, int blackLevel) {
    var rect = Rectangle<double>(startIndex.toDouble(), 0, (endIndex - startIndex).toDouble(), bmp.height.toDouble());

    if (rect.width > 0) {
      var box = _boundingBox(bmp, rect, blackLevel);
      var refPoint = Offset(box.left, box.top);
      refPoint = refPoint.translate(size.left, size.top);
      symbols.add(Symbol(refPoint,
          Image.copyCrop(bmp, x: box.left.toInt(), y: box.top.toInt(), width: box.width.toInt(), height: box.height.toInt()), this));
    }
    return rect;
  }

  /// <summary>
  /// determine the bounding rectangle for the symbol
  /// </summary>
  Rectangle<double> _boundingBox(Image.Image bmp, Rectangle<double> rect, int blackLevel) {
    var startRow = rect.top.toInt();
    var endRow = rect.bottom.toInt() - 1;

    for (int y = rect.top.toInt(); y <= rect.bottom - 1; y++) {
      if (!SymbolReplacerImage._emptyRow(bmp, rect.left.toInt(), rect.right.toInt(), y, blackLevel)) {
        startRow = y;
        break;
      }
    }

    for (int y = rect.bottom.toInt() - 1; y >= rect.top; y--) {
      if (!SymbolReplacerImage._emptyRow(bmp, rect.left.toInt(), rect.right.toInt(), y, blackLevel)) {
        endRow = y + 1;
        break;
      }
    }
    return Rectangle<double>(rect.left, startRow.toDouble(), rect.width, (endRow - startRow).toDouble());
  }
}

class Symbol {
  late Offset refPoint;
  late Image.Image bmp;
  late _SymbolRow row;
  int? hash;
  SymbolGroup? symbolGroup;
  Uint8List? _outputImageBytes;

  Symbol(this.refPoint, this.bmp, this.row);

  Symbol _clone() {
    var symbol = Symbol(refPoint, bmp, row);
    symbol.hash = hash;
    return symbol;
  }

  /// <summary>
  /// determine the minimum distance between the symbols that is greater than 0
  /// </summary>
  double distance(Symbol symbol2) {
    return _rectangleDistance(_borderRectangle(), symbol2._borderRectangle());
  }

  Rectangle<double> _borderRectangle() {
    return Rectangle(refPoint.dx, refPoint.dy, bmp.width.toDouble(), bmp.height.toDouble());
  }

  /// <summary>
  /// inflate rectangle
  /// </summary>
  Rectangle<double> _borderRectangleWithOffset(double sizeOffset) {
    var rect = _borderRectangle();
    return Rectangle<double>(rect.left - sizeOffset, rect.top - sizeOffset,
        rect.right + sizeOffset, rect.bottom + sizeOffset); //.inflate(sizeOffset);
  }

  /// <summary>
  /// determine the minimum distance between the rectangles that is greater than 0
  /// </summary>
  static double _rectangleDistance(Rectangle<double> rect1, Rectangle<double> rect2) {
    var m1 = Offset(rect1.left + rect1.width / 2.0, rect1.top + rect1.height / 2.0); //center;
    var m2 = Offset(rect2.left + rect2.width / 2.0, rect2.top + rect2.height / 2.0); //center;;
    var dist1 = (m1.dx - m2.dx).abs() - (rect1.width + rect2.width) / 2;
    var dist2 = (m1.dy - m2.dy).abs() - (rect1.height + rect2.height) / 2;

    if (min(dist1, dist2) > 0) return min(dist1, dist2);
    return max(dist1, dist2);
  }

  Uint8List getImage() {
    if (_outputImageBytes != null) return _outputImageBytes!;

    _outputImageBytes = encodeTrimmedPng(bmp);
    return _outputImageBytes!;
  }
}

class SymbolGroup {
  // group text
  String? text;
  bool viewGroupImage = false;
  var symbols = <Symbol>[];
  SymbolReplacerSymbolData? compareSymbol;

  Uint8List? getImage() {
    if (symbols.isNotEmpty) return symbols.first.getImage();
    return null;
  }

  SymbolReplacerSymbolData? getCompareSymbol() {
    return compareSymbol;
  }
}

Future<List<Map<String, SymbolReplacerSymbolData>>?> searchSymbolTableAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple2<SymbolReplacerImage, List<List<Map<String, SymbolReplacerSymbolData>>>>) return null;

  var data = jobData!.parameters as Tuple2<SymbolReplacerImage, List<List<Map<String, SymbolReplacerSymbolData>>>>;
  var output = await searchSymbolTable(data.item1, data.item2, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<List<Map<String, SymbolReplacerSymbolData>>?> searchSymbolTable(
    SymbolReplacerImage? image, List<List<Map<String, SymbolReplacerSymbolData>>>? compareSymbols,
    {SendPort? sendAsyncPort}) {
  if (image == null) return Future.value(null);
  if (compareSymbols == null) return Future.value(null);
  var progress = 0;

  double maxPercentSum = 0.0;
  List<Map<String, SymbolReplacerSymbolData>>? maxPercentSymbolTable;
  var imageTmp = SymbolReplacerImage(image._image);
  imageTmp.symbols = image.symbols;
  imageTmp.symbolGroups = image.symbolGroups;
  imageTmp._blackLevel = image._blackLevel;
  imageTmp._similarityCompareLevel = 0;
  imageTmp._similarityLevel = 0;
  imageTmp._gap = image._gap;

  sendAsyncPort?.send(DoubleText('progress', 0.0));

  for (var symbolTable in compareSymbols) {
    imageTmp.resetGroupText();
    var compareSymbolImage = imageTmp._buildCompareSymbols(symbolTable);
    if (compareSymbolImage != null) {
      var percent = imageTmp._useCompareSymbols(compareSymbolImage);
      if (maxPercentSum < percent) {
        maxPercentSum = percent;
        maxPercentSymbolTable = symbolTable;
      }
    }
    progress++;
    sendAsyncPort?.send(DoubleText('progress', progress / compareSymbols.length));
  }
  return Future.value(maxPercentSymbolTable);
}

/// <summary>
/// Contains a variety of methods useful in generating image hashes for image comparison
/// and recognition.
///
/// Credit for the AverageHash implementation to David Oftedal of the University of Oslo.
/// </summary>
class ImageHashing {
  /// Private constants and utility methods
  /// <summary>
  /// Bitcounts array used for BitCount method (used in Similarity comparisons).
  /// Don't try to read this or understand it, I certainly don't. Credit goes to
  /// David Oftedal of the University of Oslo, Norway for this.
  /// http://folk.uio.no/davidjo/computing.php
  /// </summary>
  static final _bitCounts = Uint8List.fromList([
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3,
    2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4,
    2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5,
    4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4,
    3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6,
    4, 5, 5, 6, 5, 6, 6, 7, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4,
    3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5,
    4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4, 5,
    3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6,
    5, 6, 6, 7, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8
  ]);

  /// <summary>
  /// Counts bits (duh). Utility function for similarity.
  /// I wouldn't try to understand this. I just copy-pasta'd it
  /// from Oftedal's implementation. It works.
  /// </summary>
  /// <param name="num">The hash we are counting.</param>
  /// <returns>The total bit count.</returns>
  static int _BitCount(int num) {
    int count = 0;
    for (; num > 0; num >>= 8) {
      count += _bitCounts[(num & 0xff)];
    }
    return count;
  }

  /// source: https://github.com/jforshee/ImageHashing/blob/master/ImageHashing/ImageHashing.cs
  /// <summary>
  /// Computes the average hash of an image according to the algorithm given by Dr. Neal Krawetz
  /// on his blog: http://www.hackerfactor.com/blog/index.php?/archives/432-Looks-Like-It.html.
  /// </summary>
  /// <param name="image">The image to hash.</param>
  /// <returns>The hash of the image.</returns>
  static int AverageHash(Image.Image image) {
    // Squeeze the image into an 8x8 canvas
    Image.Image squeezed = Image.copyResize(image, width: 8, height: 8, interpolation: Image.Interpolation.nearest);

    // Reduce colors to 6-bit grayscale and calculate average color value
    var grayscale = Uint8List(64);
    int averageValue = 0;
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        var pixel = squeezed.getPixel(x, y); //..ToArgb();
        int gray = (pixel.r + pixel.g +pixel.r + pixel.b).toInt();
        gray = gray ~/ 12;

        grayscale[x + (y * 8)] = gray;
        averageValue += gray;
      }
    }
    averageValue = averageValue ~/ 64;

    // Compute the hash: each bit is a pixel
    // 1 = higher than average, 0 = lower than average
    int hash = 0;
    for (int i = 0; i < 64; i++) {
      if (grayscale[i] >= averageValue) hash |= (1 << (63 - i));
    }

    if (hash < 0) hash = ~hash; //no uint
    return hash;
  }

  /// <summary>
  /// Returns a percentage-based similarity value between the two given hashes. The higher
  /// the percentage, the closer the hashes are to being identical.
  /// </summary>
  /// <param name="hash1">The first hash.</param>
  /// <param name="hash2">The second hash.</param>
  /// <returns>The similarity percentage.</returns>
  static double Similarity(int hash1, int hash2) {
    return ((64 - _BitCount(hash1 ^ hash2)) * 100) / 64.0;
  }

  /// <summary>
  /// Returns a percentage-based similarity value between the two given images. The higher
  /// the percentage, the closer the images are to being identical.
  /// </summary>
  /// <param name="image1">The first image.</param>
  /// <param name="image2">The second image.</param>
  /// <returns>The similarity percentage.</returns>
  static double SimilarityImage(Image.Image image1, Image.Image image2) {
    int hash1 = AverageHash(image1);
    int hash2 = AverageHash(image2);
    return Similarity(hash1, hash2);
  }
}
