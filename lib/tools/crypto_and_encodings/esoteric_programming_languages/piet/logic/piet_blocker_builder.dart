part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

const _knownColors = [
  //format RGB
  // reds
  0xFFC0C0, // light
  0xFF0000,
  0xC00000, //dark
  // yellows
  0xFFFFC0,
  0xFFFF00,
  0x0C0C000,
  // greens
  0xC0FFC0,
  0x00FF00,
  0x00C000,
  // cyans
  0xC0FFFF,
  0x00FFFF,
  0x00C0C0,
  // blues
  0xC0C0FF,
  0x0000FF,
  0x0000C0,
  // magentas
  0xFFC0FF,
  0xFF00FF,
  0xC000C0,
  // white
  0xFFFFFF,
  // black
  0x000000
];

class _PietBlockerBuilder {
  // we if want to support custom colors and operations going forward
  // we'll need to allow extensions to add to this collection

  List<List<int>> _data;
  _PietBlock _block;
  var _blockCache = Map<Point<int>, _PietBlock>();
  int _width;
  int _height;

  _PietBlockerBuilder(List<List<int>> data) {
    _data = data;
    _width = _data.length;
    _height = _data[0].length;
  }

  _PietBlock _getBlockAt(int x, int y) {
    return _buildPietBlock(x, y);
  }

  _PietBlock _buildPietBlock(int x, int y) {
    var point = Point<int>(x, y);
    if (_blockCache.containsKey(point)) return _blockCache[point];
    int targetColor = _data[x][y];
    var knownColor = _knownColors.contains(targetColor);

    _block = _PietBlock(targetColor, knownColor);
    _buildPietBlockRec(x, y, targetColor);
    _blockCache.addAll({point: _block});

    return _block;
  }

  void _buildPietBlockRec(int x, int y, int currentColor) {
    var queue = Set<Point<int>>();
    queue.add(Point<int>(x, y));

    while (!queue.isEmpty) {
      var queuePixel = queue.last;
      queue.remove(queuePixel);
      _block.addPixel(queuePixel);
      x = queuePixel.x;
      y = queuePixel.y;

      _addIsValidBlock(x + 1, y, currentColor, queue); // right
      _addIsValidBlock(x, y + 1, currentColor, queue); // bottom
      _addIsValidBlock(x - 1, y, currentColor, queue); // left
      _addIsValidBlock(x, y - 1, currentColor, queue); // top
    }
  }

  Set<Point<int>> _addIsValidBlock(int x, int y, int color, Set<Point<int>> queue) {
    if (x < 0 || x >= _width || y < 0 || y >= _height) // out of bounds
      return queue;
    // colors don't match - you hit an edge
    if (_data[x][y] == color && !_block.containsPixel(Point<int>(x, y)))
      queue.add(Point<int>(x, y));
    return queue;
  }
}
