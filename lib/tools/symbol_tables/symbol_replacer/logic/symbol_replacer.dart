import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer_symboldata.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:image/image.dart' as Image;

class ReplaceSymbolsInput {
  final Uint8List image;
  final int blackLevel;
  final double similarityLevel;
  final int gap;
  final SymbolReplacerImage symbolImage;
  final List<Map<String, SymbolReplacerSymbolData>> compareSymbols;
  final double similarityCompareLevel;
  final double mergeDistance;

  ReplaceSymbolsInput(
      {this.image,
      this.blackLevel: 50,
      this.similarityLevel: 90.0,
      this.gap: 1,
      this.symbolImage,
      this.compareSymbols,
      this.similarityCompareLevel: 80.0,
      this.mergeDistance});
}

Future<SymbolReplacerImage> replaceSymbolsAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = await replaceSymbols(
      jobData.parameters.image, jobData.parameters.blackLevel, jobData.parameters.similarityLevel,
      gap: jobData.parameters.gap,
      symbolImage: jobData.parameters.symbolImage,
      compareSymbols: jobData.parameters.compareSymbols,
      similarityCompareLevel: jobData.parameters.similarityCompareLevel,
      mergeDistance: jobData.parameters.mergeDistance);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Future<SymbolReplacerImage> replaceSymbols(Uint8List image, int blackLevel, double similarityLevel,
    {int gap = 1,
    SymbolReplacerImage symbolImage,
    List<Map<String, SymbolReplacerSymbolData>> compareSymbols,
    double similarityCompareLevel,
    double mergeDistance}) async {
  if ((image == null) && (symbolImage == null)) return null;
  if (symbolImage == null) symbolImage = SymbolReplacerImage(image);

  symbolImage.splitAndGroupSymbols(blackLevel * 255 ~/ 100, similarityLevel,
      gap: gap,
      compareSymbols: compareSymbols,
      similarityCompareLevel: similarityCompareLevel,
      mergeDistance: mergeDistance);

  return Future.value(symbolImage);
}

class SymbolReplacerImage {
  /// source image
  Uint8List _image;

  /// converted  source image
  Image.Image _bmp;

  /// source image with symbol borders
  Uint8List _outputImageBytes;

  /// assigned symbol table (original)
  List<Map<String, SymbolReplacerSymbolData>> compareSymbols;

  /// used symbol table (original)
  List<Map<String, SymbolReplacerSymbolData>> _usedCompareSymbols;

  /// image with groups from  cropped _usedCompareSymbols
  SymbolReplacerImage _usedCompareSymbolsImage;
  double _similarityCompareLevel;

  /// detected lines from _image (after symbol merge)
  List<_SymbolRow> lines = [];

  /// detected lines from _image
  List<_SymbolRow> _sourceLines = [];

  /// detected symbols (after symbol merge)
  List<Symbol> symbols = [];

  /// detected symbols
  List<Symbol> _sourceSymbols = [];

  /// symbol groups (same symbol/ text)
  List<SymbolGroup> symbolGroups = [];

  List<double> _mergeDistanceSteps;
  double _mergeDistance;
  static int _mergeDistanceInit = 5; // %

  int _blackLevel;
  double _similarityLevel;
  int _gap;

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
  Uint8List getBorderImage() {
    if (_outputImageBytes != null) return _outputImageBytes;

    _outputImageBytes = encodeTrimmedPng(_mergeBorderData());
    return _outputImageBytes;
  }

  /// <summary>
  /// SymbolImage with compary symbols (symbol table)
  /// </summary>
  SymbolReplacerImage getCompareImage() {
    return _usedCompareSymbolsImage;
  }

  /// <summary>
  /// determines the text based on the assigned symbols
  /// </summary>
  String getTextOutput({bool withLinebreak: false}) {
    var output = '';
    var referenceWidth = _referenceWidth(symbols);

    lines.forEach((line) {
      var rightBorder = 0.0;
      line.symbols.forEach((symbol) {
        if (symbol?.refPoint.dx - rightBorder > referenceWidth) output += ' ';
        output += symbol.symbolGroup?.text != null ? symbol.symbolGroup.text : '';
        rightBorder = symbol.refPoint.dx + symbol.bmp.width;
      });
      if (withLinebreak) output += '\r\n';
    });
    return output.trim();
  }

  /// <summary>
  /// seperate symbols from image and create SymbolGroups
  /// </summary>
  splitAndGroupSymbols(int blackLevel, double similarityLevel,
      {int gap = 1,
      List<Map<String, SymbolReplacerSymbolData>> compareSymbols,
      double similarityCompareLevel = 80,
      bool groupSymbols = true,
      double mergeDistance}) {
    if (_image == null) return;
    if (_bmp == null) _bmp = Image.decodeImage(_image);
    if (_bmp == null) return;
    if (blackLevel == null) return;
    if (similarityLevel == null) return;

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
    if (_sourceSymbols.isEmpty) {
      _sourceLines.forEach((line) {
        line._splitLineToSymbols(gap, _blackLevel);
        _sourceSymbols.addAll(line.symbols);
      });
      symbolsCloned = true;
      _cloneSourceLines();
    }

    if (symbolGroups.isEmpty && groupSymbols) {
      if (_mergeDistance == null) _mergeDistance = _mergeSymbolsDefault(_mergeDistanceInit);

      if (!symbolsCloned) _cloneSourceLines();
      if (_mergeDistance != null && _mergeDistance > 0) _mergeSymbols(_mergeDistance);

      _groupSymbols();
    }

    if (this.compareSymbols != compareSymbols) _usedCompareSymbolsImage = null;

    if (groupSymbols & (compareSymbols != null) & (_similarityCompareLevel != null)) {
      if (this.compareSymbols != _usedCompareSymbols || _usedCompareSymbolsImage == null) {
        _usedCompareSymbolsImage = _buildCompareSymbols(compareSymbols);
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
  addToGroup(Symbol symbol, SymbolGroup symbolGroup) {
    if (symbol == null) return;
    if (symbol.symbolGroup != null) {
      symbol.symbolGroup?.symbols?.remove(symbol);
      if (symbol.symbolGroup.symbols.isEmpty) symbolGroups.remove(symbol.symbolGroup);
    }
    if (symbolGroup.symbols == null) symbolGroup.symbols = <Symbol>[];

    _addSymbolToGroup(symbol, symbolGroup);
  }

  /// <summary>
  /// remove Symbol from SymbolGroup (create new SymbolGroup)
  /// </summary>
  removeFromGroup(Symbol symbol) {
    if (symbol == null) return;
    if (symbol.symbolGroup != null) symbol.symbolGroup?.symbols?.remove(symbol);
    var symbolGroup = SymbolGroup();
    symbolGroups.add(symbolGroup);

    _addSymbolToGroup(symbol, symbolGroup);
  }

  _addSymbolToGroup(Symbol symbol, SymbolGroup symbolGroup) {
    symbolGroup.symbols.add(symbol);
    if ((symbol?.symbolGroup?.symbols != null) && (symbol?.symbolGroup?.symbols.isEmpty))
      symbolGroups.remove(symbol.symbolGroup);
    symbol.symbolGroup = symbolGroup;
  }

  /// <summary>
  /// SymbolGroup for these symbols together
  /// </summary>
  buildSymbolGroup(List<Symbol> symbols) {
    if ((symbols == null) || symbols.isEmpty) return;

    removeFromGroup(symbols.first);
    for (var i = 1; i < symbols.length; i++) addToGroup(symbols[i], symbols.first.symbolGroup);
  }

  /// <summary>
  /// merge SymbolGroups with same compareSymbol
  /// </summary>
  mergeSymbolGroups() {
    if ((symbolGroups == null) || symbolGroups.isEmpty) return;

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
  resetGroupText() {
    symbolGroups.forEach((group) {
      group.text = null;
      group.compareSymbol = null;
    });
  }

  /// <summary>
  /// extract symbols from the compare symbol table
  /// </summary>
  SymbolReplacerImage _buildCompareSymbols(List<Map<String, SymbolReplacerSymbolData>> compareSymbols) {
    var compareSymbolImage = SymbolReplacerImage(compareSymbols?.first?.values?.first?.bytes);
    if (compareSymbols == null) return null;

    compareSymbols.forEach((element) {
      element.forEach((text, symbolData) {
        if (symbolData != null && symbolData.bytes != null) {
          var symbolImage = SymbolReplacerImage(symbolData.bytes);
          symbolImage.splitAndGroupSymbols(_blackLevel, _similarityLevel, gap: _gap, groupSymbols: false);
          if (symbolImage.symbols != null) {
            // merge all symbols parts
            for (var i = symbolImage.symbols.length - 2; i >= 0; i--)
              symbolImage.mergeSymbol(symbolImage.symbols[i], symbolImage.symbols[i + 1], null);
          }

          // create SymbolGroups with text for the symbols
          symbolImage.symbols.forEach((element) {
            var symbolGroup = SymbolGroup();
            symbolGroup.symbols = symbolImage.symbols;
            symbolGroup.text = text;
            symbolGroup.symbols.forEach((symbol) {
              symbol.symbolGroup = symbolGroup;
            });
            symbolGroup.compareSymbol = symbolData;

            compareSymbolImage.symbols.addAll(symbolGroup.symbols);
            compareSymbolImage.symbolGroups.add(symbolGroup);
          });
          symbolImage.symbols = null;
        }
      });
    });

    return compareSymbolImage;
  }

  /// <summary>
  /// Compare the symbols in the specified symbol table with the existing symbols and
  /// then assign the text to the groups
  /// return: Sum of percent match for all symbols
  /// </summary>
  double _useCompareSymbols(SymbolReplacerImage compareSymbolImage) {
    var percentSum = 0.0;

    if (compareSymbolImage?.symbols == null) return percentSum;

    // build hash for compare
    for (int i = 0; i < compareSymbolImage.symbols.length; i++)
      compareSymbolImage.symbols[i].hash = ImageHashing.AverageHash(compareSymbolImage.symbols[i].bmp);

    // found the best compare symbols
    for (int i = 0; i < symbolGroups.length; i++) {
      if ((symbolGroups[i].text == null) || (symbolGroups[i].text.isEmpty)) {
        double maxPercent = 0.0;
        Symbol maxPercentSymbol;

        Symbol symbol1 = symbolGroups[i].symbols.first;

        for (int x = 0; x < compareSymbolImage.symbols.length; x++) {
          var similarity = ImageHashing.Similarity(symbol1.hash, compareSymbolImage.symbols[x].hash);
          if (similarity > maxPercent) {
            maxPercent = similarity;
            maxPercentSymbol = compareSymbolImage.symbols[x];
          }
        }
        if (maxPercent >= _similarityCompareLevel && (maxPercentSymbol?.symbolGroup != null)) {
          symbolGroups[i].text = maxPercentSymbol.symbolGroup.text;
          symbolGroups[i].compareSymbol = maxPercentSymbol.symbolGroup.compareSymbol;
        }
        percentSum += maxPercent;
      }
    }
    return percentSum;
  }

  /// <summary>
  /// creates an image with frames around the symbols
  /// </summary>
  Image.Image _mergeBorderData() {
    var bmp = Image.Image(_bmp.width, _bmp.height);

    Image.drawImage(bmp, _bmp);

    symbols.forEach((symbol) {
      var rect = Rectangle<int>(
        symbol.refPoint.dx.toInt(),
        symbol.refPoint.dy.toInt(),
        symbol.bmp.width,
        symbol.bmp.height,
      );

      Image.drawRect(bmp, rect.left, rect.top, rect.right, rect.bottom, Colors.blue.value);
      Image.drawRect(bmp, rect.left - 1, rect.top - 1, rect.right + 1, rect.bottom + 1, Colors.blue.value);
    });

    return bmp;
  }

  /// <summary>
  /// Split the image into individual lines
  /// </summary>
  _splitToLines() {
    var emptyLineIndex = <int>[];

    /// <summary>
    /// search empty lines
    /// </summary>
    for (int y = 0; y < _bmp.height; y++) if (_emptyRow(_bmp, 0, _bmp.width - 1, y, _blackLevel)) emptyLineIndex.add(y);

    if (emptyLineIndex.isEmpty) emptyLineIndex.add(_bmp.width - 1);

    // split lines
    if (emptyLineIndex.isNotEmpty) {
      // first line
      if (emptyLineIndex.first != 0) _cutLine(0, emptyLineIndex.first - 1);

      for (int i = 1; i < emptyLineIndex.length; i++) {
        if (emptyLineIndex[i - 1] != emptyLineIndex[i] - 1) _cutLine(emptyLineIndex[i - 1] + 1, emptyLineIndex[i] - 1);
      }

      // last line
      if ((emptyLineIndex.last != _bmp.height - 1) & (emptyLineIndex.last != 0))
        _cutLine(emptyLineIndex.last + 1, _bmp.height - 1);
    }
  }

  /// <summary>
  /// Cut line and add to sourceLines
  /// </summary>
  _cutLine(int startIndex, int endIndex) {
    var rect = Rectangle<double>(0, startIndex.toDouble(), _bmp.width.toDouble(), (endIndex - startIndex).toDouble());

    if (rect.height > 0)
      _sourceLines.add(_SymbolRow(
          rect, Image.copyCrop(_bmp, rect.left.toInt(), rect.top.toInt(), rect.width.toInt(), rect.height.toInt())));
  }

  /// <summary>
  /// Group symbols together
  /// </summary>
  _groupSymbols() {
    for (int i = 0; i < symbols.length; i++) symbols[i].hash = ImageHashing.AverageHash(symbols[i].bmp);

    for (int i = 0; i < symbols.length; i++) {
      double maxPercent = 0;
      int maxPercentSymbolIndex = 0;

      Symbol symbol1 = symbols[i];

      for (int x = 0; x < i; x++) {
        var similarity = ImageHashing.Similarity(symbol1.hash, symbols[x].hash);
        if (similarity > maxPercent) {
          maxPercent = similarity;
          maxPercentSymbolIndex = x;
        }
      }

      if ((maxPercent < _similarityLevel) | (maxPercentSymbolIndex > i)) {
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
  static bool _blackPixel(int color, int blackLevel) {
    return (Image.getLuminance(color) <= blackLevel);
  }

  /// <summary>
  /// Average of all symbol widths
  /// </summary>
  static int _referenceWidth(List<Symbol> symbols) {
    int width = 0;
    if (symbols == null) return null;

    symbols.forEach((symbol) {
      width = max(symbol.bmp.width, width);
    });

    return width;
  }

  /// <summary>
  /// closest distance leading to symbol merging
  /// </summary>
  double nextMergeDistance(double actMergeDistance) {
    double next;
    actMergeDistance = actMergeDistance ?? _mergeDistance;
    if (actMergeDistance != null) {
      var nextl = _mergeDistanceSteps.where((value) => value > actMergeDistance);
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

    return next ?? _mergeDistanceSteps.last;
  }

  /// <summary>
  /// previous spacing that caused symbols to be merged
  /// </summary>
  double prevMergeDistance(double actMergeDistance) {
    double prev;
    actMergeDistance = actMergeDistance ?? _mergeDistance;
    if (actMergeDistance != null) {
      var prevl = _mergeDistanceSteps.where((value) => value < actMergeDistance);
      if (prevl.isNotEmpty) prev = prevl.last;
    }
    return prev;
  }

  /// <summary>
  /// calc init merge distance
  /// </summary>
  double _mergeSymbolsDefault(int mergeDistance) {
    // calc possible steps
    if (_mergeDistanceSteps == null) _mergeDistanceSteps = _calcMergeDistances();

    double minLineDistance;

    for (var i = 0; i < lines.length - 1; i++) {
      var dist = lines[i + 1].size.top - lines[i].size.bottom;
      if (dist > 0 && (minLineDistance == null || minLineDistance > dist)) minLineDistance = dist;
    }

    var _mergeDistance = 0.0;
    // calc init merge distance
    var referenceWidth = _referenceWidth(symbols);
    // value symbol width
    if (referenceWidth != null) _mergeDistance = referenceWidth * mergeDistance / 100.0;
    // and line distance
    if (minLineDistance != null && minLineDistance > 0)
      _mergeDistance = (_mergeDistance == 0.0) ? referenceWidth : min(_mergeDistance, (minLineDistance - 1) / 2);

    if (_mergeDistance != null && _mergeDistance > 0) return prevMergeDistance(_mergeDistance);

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
  _mergeSymbols(double maxDistance) {
    if (lines == null) return;
    if (maxDistance == null) return;

    var rectList = <Rectangle<double>>[];
    var symbolList = <Symbol>[];
    var changed = false;

    symbolList.addAll(symbols);
    // build rectangles with oversize
    symbolList.forEach((symbol) {
      rectList.add(symbol._borderRectangleWithOffset(maxDistance));
    });

    do {
      changed = false;
      for (int x = 0; x < symbolList.length; x++) {
        for (int y = x + 1; y < symbolList.length; y++) {
          if (symbolList[x] != null && symbolList[y] != null) {
            // overlaps rectangles ?
            if (rectList[x].intersects(rectList[y])) {
              var line = _searchSymbolRow(symbolList[y]);
              if (line != null) {
                // merge symbols
                mergeSymbol(symbolList[x], symbolList[y], line);
                rectList[x] = symbolList[x]._borderRectangleWithOffset(maxDistance);
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
  _SymbolRow _searchSymbolRow(Symbol symbol) {
    for (_SymbolRow line in lines) if (line.symbols.contains(symbol)) return line;
  }

  /// <summary>
  /// Find the SymbolGroup that the symbol is associated with
  /// </summary>
  SymbolGroup _searchSymbolGroup(Symbol symbol) {
    for (SymbolGroup group in symbolGroups) if (group.symbols.contains(symbol)) return group;
  }

  /// <summary>
  /// Merge symbols
  /// </summary>
  mergeSymbol(Symbol symbol1, Symbol symbol2, _SymbolRow line) {
    var box = symbol1._borderRectangle().boundingBox(symbol2._borderRectangle());

    symbol1.refPoint = Offset(box.left, box.top);
    symbol1.bmp = Image.copyCrop(_bmp, box.left.toInt(), box.top.toInt(), box.width.toInt(), box.height.toInt());

    var group = _searchSymbolGroup(symbol2);
    if (group != null) group.symbols.remove(symbol2);

    symbols?.remove(symbol2);
    line?.symbols?.remove(symbol2);
  }

  _cloneSourceLines() {
    lines.clear();
    symbols.clear();
    _sourceLines.forEach((line) {
      var lineClone = line._clone();
      lines.add(lineClone);
      symbols.addAll(lineClone.symbols);
    });
  }
}

class _SymbolRow {
  Rectangle<double> size;
  Image.Image bmp;
  var symbols = <Symbol>[];

  _SymbolRow(Rectangle<double> size, Image.Image bmp) {
    this.size = size;
    this.bmp = bmp;
  }

  _SymbolRow _clone() {
    var symbolRow = _SymbolRow(size, bmp);
    symbols.forEach((symbol) {
      var symbolClone = symbol._clone();
      symbolClone.row = symbolRow;
      symbolRow.symbols.add(symbolClone);
    });
    return symbolRow;
  }

  /// <summary>
  /// Break line into symbols
  /// </summary>
  _splitLineToSymbols(int gap, int blackLevel) {
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

    if (emptyColumnIndex.length > 0) {
      emptyColumnIndex = _removeGapColumns(emptyColumnIndex, gap);

      if (emptyColumnIndex.first != 0) _cutSymbol(0, emptyColumnIndex.first - 1, blackLevel);

      for (int i = 1; i < emptyColumnIndex.length; i++) {
        if (emptyColumnIndex[i - 1] != emptyColumnIndex[i] - 1)
          _cutSymbol(emptyColumnIndex[i - 1] + 1, emptyColumnIndex[i] - 1, blackLevel);
      }

      if ((emptyColumnIndex.last != bmp.width - 1) & (emptyColumnIndex.last != 0))
        _cutSymbol(emptyColumnIndex.last + 1, bmp.width - 1, blackLevel);
    }
  }

  List<int> _removeGapColumns(List<int> emptyColumnIndex, int gap) {
    if (gap > 1) {
      for (int i = emptyColumnIndex.length - 1 - gap; i > 0; i--) {
        // previus column not empty ?
        if (emptyColumnIndex[i - 1] != emptyColumnIndex[i] - 1) {
          var emtyColumnsCount = _countEmptyColumns(emptyColumnIndex, i);

          if (emtyColumnsCount <= gap) for (int x = emtyColumnsCount - 1; x >= 0; x--) emptyColumnIndex.removeAt(i + x);
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
      if (emptyColumnIndex[i] == emptyColumnIndex[i + 1] - 1)
        counter++;
      else
        break;
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
          Image.copyCrop(bmp, box.left.toInt(), box.top.toInt(), box.width.toInt(), box.height.toInt()), this));
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
  Offset refPoint;
  Image.Image bmp;
  int hash;
  _SymbolRow row;
  SymbolGroup symbolGroup;
  Uint8List _outputImageBytes;

  Symbol(Offset refPoint, Image.Image bmp, _SymbolRow row) {
    this.refPoint = refPoint;
    this.bmp = bmp;
    this.row = row;
  }

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
    if (_outputImageBytes != null) return _outputImageBytes;

    _outputImageBytes = encodeTrimmedPng(bmp);
    return _outputImageBytes;
  }
}

class SymbolGroup {
  // group text
  String text;
  bool viewGroupImage = false;
  var symbols = <Symbol>[];
  SymbolReplacerSymbolData compareSymbol;

  Uint8List getImage() {
    if (symbols.isNotEmpty) return symbols.first.getImage();
    return null;
  }

  SymbolReplacerSymbolData getCompareSymbol() {
    return compareSymbol;
  }
}

Future<List<Map<String, SymbolReplacerSymbolData>>> searchSymbolTableAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output =
      await searchSymbolTable(jobData.parameters.item1, jobData.parameters.item2, sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

List<Map<String, SymbolReplacerSymbolData>> searchSymbolTable(
    SymbolReplacerImage image, List<List<Map<String, SymbolReplacerSymbolData>>> compareSymbols,
    {SendPort sendAsyncPort}) {
  if (image == null) return null;
  if (compareSymbols == null) return null;
  var progress = 0;

  double maxPercentSum = 0.0;
  List<Map<String, SymbolReplacerSymbolData>> maxPercentSymbolTable;
  var imageTmp = SymbolReplacerImage(image._image);
  imageTmp.symbols = image.symbols;
  imageTmp.symbolGroups = image.symbolGroups;
  imageTmp._blackLevel = image._blackLevel;
  imageTmp._similarityCompareLevel = 0;
  imageTmp._similarityLevel = 0;
  imageTmp._gap = image._gap;

  if (sendAsyncPort != null) sendAsyncPort.send({'progress': 0.0});

  compareSymbols.forEach((symbolTable) {
    imageTmp.resetGroupText();
    var compareSymbolImage = imageTmp._buildCompareSymbols(symbolTable);
    var percent = imageTmp._useCompareSymbols(compareSymbolImage);
    if (maxPercentSum < percent) {
      maxPercentSum = percent;
      maxPercentSymbolTable = symbolTable;
    }

    progress++;
    if (sendAsyncPort != null) {
      sendAsyncPort.send({'progress': progress / compareSymbols.length});
    }
  });
  return maxPercentSymbolTable;
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
    for (; num > 0; num >>= 8) count += _bitCounts[(num & 0xff)];
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
    for (int y = 0; y < 8; y++)
      for (int x = 0; x < 8; x++) {
        int pixel = squeezed.getPixel(x, y); //..ToArgb();
        int gray = (pixel & 0x00ff0000) >> 16;
        gray += (pixel & 0x0000ff00) >> 8;
        gray += (pixel & 0x000000ff);
        gray = gray ~/ 12;

        grayscale[x + (y * 8)] = gray;
        averageValue += gray;
      }
    averageValue = averageValue ~/ 64;

    // Compute the hash: each bit is a pixel
    // 1 = higher than average, 0 = lower than average
    int hash = 0;
    for (int i = 0; i < 64; i++) if (grayscale[i] >= averageValue) hash |= (1 << (63 - i));

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
