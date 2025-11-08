import 'dart:io';
import 'dart:math';

//import 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/font.dart';
//import 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/life_pattern.dart';

String generate_rle(String stringToGenerate){

  String stringToGenerate = '';

  var width = 100;
  var height = 50;

  List<List<bool?>>? drawing;

  //final font = RLEPatternFont('font.txt');
  final font = RLEPatternFont();
  drawing = font.drawingForString(stringToGenerate);
  height = drawing.length;
  var wmax = 0;
  for (var r in drawing) {
    wmax = max(wmax, r.length);
  }
  width = wmax + 10;

  final life = BitmapLifePattern(width, height);

  return life.writeRLE();
}


// https://github.com/tlrobinson/life-gen/blob/master/life.rb
//
// # Copyright (c) 2009 Thomas Robinson <tlrobinson.net>
// #
// # Permission is hereby granted, free of charge, to any person
// # obtaining a copy of this software and associated documentation
// # files (the "Software"), to deal in the Software without
// # restriction, including without limitation the rights to use,
// # copy, modify, merge, publish, distribute, sublicense, and/or sell
// # copies of the Software, and to permit persons to whom the
// # Software is furnished to do so, subject to the following
// # conditions:
// #
// # The above copyright notice and this permission notice shall be
// # included in all copies or substantial portions of the Software.
// #
// # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// # OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// # HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// # WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// # FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// # OTHER DEALINGS IN THE SOFTWARE.

/// Simple point representation
class LifePatternPoint {
  final int x;
  final int y;
  const LifePatternPoint(this.x, this.y);
  @override
  bool operator ==(Object other) =>
      other is LifePatternPoint && other.x == x && other.y == y;
  @override
  int get hashCode => x * 1000003 ^ y;
}

/// LifePattern class supports RLE load/save and region operations.
class LifePattern {
  // store live cells
  final Set<LifePatternPoint> _cells = {};

  LifePattern();

  /// Load from an RLE file if path provided
  factory LifePattern.fromRLEFile(String path) {
    //final content = File(path).readAsStringSync();
    return LifePattern.fromRLE(path);
  }

  /// Parse RLE content
  factory LifePattern.fromRLE(String rle) {
    final p = LifePattern();
    final lines = rle.split(RegExp(r'\r?\n'));
    // remove comment lines and header
    String body = '';
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      if (line.startsWith('#')) continue;
      if (line.contains('x') && line.contains('y') && line.contains('=')) {
        // header line - skip
        continue;
      }
      body += line.trim();
    }
    int x = 0, y = 0;
    int i = 0;
    int repeat = 0;
    while (i < body.length) {
      final ch = body[i];
      if (RegExp(r'\d').hasMatch(ch)) {
        // build repeat count
        int j = i;
        while (j < body.length && RegExp(r'\d').hasMatch(body[j])) {
          j++;
        }
        repeat = int.parse(body.substring(i, j));
        i = j;
        continue;
      } else if (ch == 'o') {
        int r = repeat == 0 ? 1 : repeat;
        for (int k = 0; k < r; k++) {
          p._cells.add(LifePatternPoint(x, y));
          x++;
        }
        repeat = 0;
      } else if (ch == 'b') {
        int r = repeat == 0 ? 1 : repeat;
        x += r;
        repeat = 0;
      } else if (ch == '\$') {
        int r = repeat == 0 ? 1 : repeat;
        y += r;
        x = 0;
        repeat = 0;
      } else if (ch == '!') {
        break;
      } else {
        // ignore unknown
      }
      i++;
    }
    return p;
  }

  /// Export RLE string representing the pattern bounding box
  String toRLE() {
    if (_cells.isEmpty) {
      return 'x = 0, y = 0, rule = B3/S23\n!';
    }
    int minX = _cells.map((p) => p.x).reduce(min);
    int minY = _cells.map((p) => p.y).reduce(min);
    int maxX = _cells.map((p) => p.x).reduce(max);
    int maxY = _cells.map((p) => p.y).reduce(max);
    final width = maxX - minX + 1;
    final height = maxY - minY + 1;

    final buffer = StringBuffer();
    buffer.writeln('x = $width, y = $height, rule = B3/S23');

    for (int y = 0; y < height; y++) {
      int runCount = 0;
      bool? runLive;
      for (int x = 0; x < width; x++) {
        final isLive = _cells.contains(LifePatternPoint(minX + x, minY + y));
        if (runLive == null) {
          runLive = isLive;
          runCount = 1;
        } else if (runLive == isLive) {
          runCount++;
        } else {
          if (runCount == 1) {
            buffer.write(runLive ? 'o' : 'b');
          } else {
            buffer.write('$runCount${runLive ? 'o' : 'b'}');
          }
          runLive = isLive;
          runCount = 1;
        }
      }
      // flush row
      if (runLive != null) {
        if (runCount == 1) {
          buffer.write(runLive ? 'o' : 'b');
        } else {
          buffer.write('$runCount${runLive ? 'o' : 'b'}');
        }
      }
      // end of line marker
      buffer.write('\$');
      // wrap lines to 70 char length for readability (optional)
      buffer.writeln();
    }
    buffer.write('!'); // end
    return buffer.toString();
  }

  /// Write to RLE file
  String writeRLE() {
    return toRLE();
  }

  /// Add a live cell
  void setCell(int x, int y) => _cells.add(LifePatternPoint(x, y));

  /// Remove a cell
  void clearCell(int x, int y) => _cells.remove(LifePatternPoint(x, y));

  /// Check if live
  bool isLive(int x, int y) => _cells.contains(LifePatternPoint(x, y));

  /// Make a copy of a rectangular region: source starting at (sx,sy) width w height h
  LifePattern copy(int sx, int sy, int w, int h) {
    final p = LifePattern();
    for (var pt in _cells) {
      if (pt.x >= sx && pt.x < sx + w && pt.y >= sy && pt.y < sy + h) {
        p._cells.add(LifePatternPoint(pt.x - sx, pt.y - sy));
      }
    }
    return p;
  }

  /// Remove cells in rectangle (x,y,w,h)
  void cut(int x, int y, int w, int h) {
    final toRemove = <LifePatternPoint>[];
    for (var pt in _cells) {
      if (pt.x >= x && pt.x < x + w && pt.y >= y && pt.y < y + h) {
        toRemove.add(pt);
      }
    }
    for (var pt in toRemove) {
      _cells.remove(pt);
    }
  }

  /// Overlay another LifePattern at offset (ox,oy)
  void overlay(LifePattern other, int ox, int oy) {
    for (var pt in other._cells) {
      _cells.add(LifePatternPoint(pt.x + ox, pt.y + oy));
    }
  }

  /// Duplicate
  LifePattern duplicate() {
    final d = LifePattern();
    d._cells.addAll(_cells);
    return d;
  }

  /// Set/clear rectangle. If value is null -> clear, otherwise set (true sets)
  void setRect(int x, int y, int w, int h, bool? value) {
    if (value == null) {
      // clear
      final toRemove = <LifePatternPoint>[];
      for (var pt in _cells) {
        if (pt.x >= x && pt.x < x + w && pt.y >= y && pt.y < y + h) {
          toRemove.add(pt);
        }
      }
      for (var p in toRemove) {
        _cells.remove(p);
      }
    } else {
      for (int yy = 0; yy < h; yy++) {
        for (int xx = 0; xx < w; xx++) {
          if (value) {
            _cells.add(LifePatternPoint(x + xx, y + yy));
          } else {
            _cells.remove(LifePatternPoint(x + xx, y + yy));
          }
        }
      }
    }
  }
}

/// BitmapLifePattern reproduces the Ruby logic
class BitmapLifePattern extends LifePattern {
  final List<List<int>> positions = [];
  int height = 0; // number of rows
  int width = 0; // number of columns (in the Ruby code this is chunks-based)
  BitmapLifePattern(int columnsArg, int rowsArg) : super() {
    // Note: columnsArg maps to "columns" as in the Ruby main invocation.
    print('Generating board of size ${columnsArg}x${rowsArg}');

    // Ruby logic: columns = [((columns - 5) / 4.0).ceil, 0].max
    final columns = max(0, ((columnsArg - 5) / 4.0).ceil());

    // Load template.rle (if available) else create empty source
    LifePattern source;
    source = LifePattern.fromRLEFile('TEMPLATE_RLE');
      // create a simple placeholder pattern large enough for copies
      for (int y = 0; y < 300; y += 10) {
        for (int x = 0; x < 300; x += 10) {
          if ((x + y) % 20 == 0) source.setCell(x, y);
        }
      }
    //}

    // copy regions (match Ruby indices)
    final top = source.copy(225, 0, 40, 45);
    final middle = source.copy(204, 29, 28, 39);
    final bottom = source.copy(0, 205, 90, 88);
    bottom.cut(31, 0, 51, 35);

    final topX = 18 + 23 * columns;
    final topY = 2;
    final bottomX = 0;
    final bottomY = 0 + 23 * columns;

    final template = LifePattern();
    template.overlay(top, topX, topY);
    template.overlay(bottom, bottomX, bottomY);

    for (var n = 0; n <= columns - 1; n++) {
      final middleX = topX - 21 - 23 * n;
      final middleY = topY + 29 + 23 * n;
      template.overlay(middle, middleX, middleY);
    }

    // compute positions array (same algorithm as Ruby)
    final initial = [
      [227, 18],
      [240, 18],
      [251, 30],
      [241, 42]
    ];
    for (var p in initial) {
      positions.add([p[0] - 225 + topX, p[1] + topY]);
    }
    var dx = positions[3][0];
    var dy = positions[3][1];
    for (var n = 0; n <= columns - 1; n++) {
      positions.add([dx - 12 - n * 23, dy + 11 + n * 23]);
      positions.add([dx - (n + 1) * 23, dy + (n + 1) * 23]);
    }
    positions.add([bottomX + 24, bottomY + 34]);

    dx = positions[0][0];
    dy = positions[0][1];
    for (var n0 = 0; n0 <= columns - 1; n0++) {
      var n = columns - 1 - n0;
      positions.add([dx - (n + 1) * 23, dy + (n + 1) * 23]);
      positions.add([dx - 12 - n * 23, dy + 11 + n * 23]);
    }

    // replicate the template rows times (rowsArg)
    for (var n = 0; n <= rowsArg - 1; n++) {
      final map = template.duplicate();
      overlay(map, 115 * n, 18 * n);
    }

    height = rowsArg;
    width = columns * 4 + 5;
    print('Actual size ${height}x${width}');
  }

  void clearPixel(int col, int row) {
    final len = positions.length;
    if (len == 0) return;
    // offset = (@positions.length - 1 - (row * 5) + col) % @positions.length
    final offset = (len - 1 - (row * 5) + col) % len;
    final pos = positions[offset];
    final x = pos[0] + 115 * row;
    final y = pos[1] + 18 * row;
    setRect(x, y, 3, 3, null);
  }

  /// drawing is List<List<bool?>> where null or false -> clear
  void draw(List<List<bool?>> drawing) {
    String line = '';
    for (var row = 0; row < height; row++) {
      line = '';
      for (var col = 0; col < width; col++) {
        final cell = (row < drawing.length && col < drawing[row].length)
            ? drawing[row][col]
            : null;
        if (cell == null || cell == false) {
          clearPixel(col, row);
          line = line + '.';
        } else {
          line = line + '*';
        }
      }
      print(line);
    }
  }
}


/// Simple Font implementation:
/// - If font.txt exists and is in a simple block format (see code comments), it will be used.
/// - Otherwise a fallback built-in 5x5 font for A-Z, 0-9 and space is used.
class RLEPatternFont {
  final Map<String, List<List<int>>> glyphs = {};

  RLEPatternFont() {
  //final f = File(path ?? 'font.txt');
  //if (f.existsSync()) {
  //  _loadFromFile(f);
  //} else {
    _loadFallback();
  //}
}

  void _loadFromFile(File f) {
    // Very simple parsing: each glyph block starts with a line "CHAR X"
    // followed by N lines of '1' and '0' with equal width, and a blank line separating glyphs.
    final lines = f.readAsLinesSync();
    String? curChar;
    final buffer = <String>[];
    for (var line in lines) {
      if (line.trim().isEmpty) {
        if (curChar != null) {
          _storeGlyph(curChar, buffer);
          curChar = null;
          buffer.clear();
        }
        continue;
      }
      final m = RegExp(r'^CHAR\s+(.+)$').firstMatch(line);
      if (m != null) {
        if (curChar != null) {
          _storeGlyph(curChar, buffer);
          buffer.clear();
        }
        curChar = m.group(1);
      } else {
        if (curChar == null) continue;
        buffer.add(line.trim());
      }
    }
    if (curChar != null) {
      _storeGlyph(curChar, buffer);
    }
    if (glyphs.isEmpty) {
      _loadFallback();
    }
  }

  void _storeGlyph(String ch, List<String> lines) {
    final matrix = <List<int>>[];
    for (var line in lines) {
      final row = <int>[];
      for (var i = 0; i < line.length; i++) {
        row.add(line[i] == '1' ? 1 : 0);
      }
      matrix.add(row);
    }
    glyphs[ch] = matrix;
  }

  void _loadFallback() {
    // Very small fallback 5x5 font for letters and digits and space.
    final map = <String, List<String>>{
      'A': ['0110', '1001', '1111', '1001', '1001'],
      'B': ['1110', '1001', '1110', '1001', '1110'],
      'C': ['0111', '1000', '1000', '1000', '0111'],
      'D': ['1110', '1001', '1001', '1001', '1110'],
      'E': ['1111', '1000', '1110', '1000', '1111'],
      'F': ['1111', '1000', '1110', '1000', '1000'],
      'G': ['0111', '1000', '1011', '1001', '0111'],
      'H': ['1001', '1001', '1111', '1001', '1001'],
      'I': ['111', '010', '010', '010', '111'],
      'J': ['0011', '0001', '0001', '1001', '0110'],
      'K': ['1001', '1010', '1100', '1010', '1001'],
      'L': ['1000', '1000', '1000', '1000', '1111'],
      'M': ['10001', '11011', '10101', '10001', '10001'],
      'N': ['1001', '1101', '1011', '1001', '1001'],
      'O': ['0110', '1001', '1001', '1001', '0110'],
      'P': ['1110', '1001', '1110', '1000', '1000'],
      'Q': ['0110', '1001', '1001', '1011', '0111'],
      'R': ['1110', '1001', '1110', '1010', '1001'],
      'S': ['0111', '1000', '0110', '0001', '1110'],
      'T': ['11111', '00100', '00100', '00100', '00100'],
      'U': ['1001', '1001', '1001', '1001', '0110'],
      'V': ['10001', '10001', '10001', '01010', '00100'],
      'W': ['10001', '10001', '10101', '11011', '10001'],
      'X': ['1001', '010', '0010', '010', '1001'],
      'Y': ['10001', '01010', '00100', '00100', '00100'],
      'Z': ['1111', '0001', '0010', '0100', '1111'],
      '0': ['0110', '1001', '1001', '1001', '0110'],
      '1': ['010', '110', '010', '010', '111'],
      '2': ['0110', '1001', '0010', '0100', '1111'],
      '3': ['1110', '0001', '0110', '0001', '1110'],
      '4': ['1001', '1001', '1111', '0001', '0001'],
      '5': ['1111', '1000', '1110', '0001', '1110'],
      '6': ['0111', '1000', '1110', '1001', '0110'],
      '7': ['1111', '0001', '0010', '0100', '0100'],
      '8': ['0110', '1001', '0110', '1001', '0110'],
      '9': ['0110', '1001', '0111', '0001', '1110'],
      ' ': ['0', '0', '0', '0', '0'],
    };

    map.forEach((k, v) {
      glyphs[k] = v.map((s) => s.split('').map((c) => c == '1' ? 1 : 0).toList()).toList();
    });
  }

  /// Returns a drawing for a string: list of rows (each row is List<bool?>)
  /// We concatenate glyphs horizontally with a 1-column spacing.
  List<List<bool?>> drawingForString(String s) {
    final up = s.toUpperCase();
    // Determine glyph height: pick max glyph height among characters used
    int glyphHeight = 0;
    for (var ch in up.split('')) {
      if (glyphs.containsKey(ch)) {
        glyphHeight = max(glyphHeight, glyphs[ch]!.length);
      }
    }
    if (glyphHeight == 0) glyphHeight = 5;

    // Compose rows
    final rows = List.generate(glyphHeight, (_) => <bool?>[]);
    for (var ch in up.split('')) {
      final glyph = glyphs[ch] ?? glyphs[' ']!;
      final w = glyph[0].length;
      for (var r = 0; r < glyphHeight; r++) {
        final row = r < glyph.length ? glyph[r] : List.filled(w, 0);
        for (var c = 0; c < w; c++) {
          rows[r].add(row[c] == 1);
        }
        // spacing column
        rows[r].add(null);
      }
    }
    return rows;
  }
}

