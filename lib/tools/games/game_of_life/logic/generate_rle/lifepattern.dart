// https://github.com/tlrobinson/life-gen/blob/master/lifepattern.rb
//
//    # Copyright (c) 2009 Thomas Robinson <tlrobinson.net>
//    #
//    # Permission is hereby granted, free of charge, to any person
//    # obtaining a copy of this software and associated documentation
//    # files (the "Software"), to deal in the Software without
//    # restriction, including without limitation the rights to use,
//    # copy, modify, merge, publish, distribute, sublicense, and/or sell
//    # copies of the Software, and to permit persons to whom the
//    # Software is furnished to do so, subject to the following
//    # conditions:
//    #
//    # The above copyright notice and this permission notice shall be
//    # included in all copies or substantial portions of the Software.
//    #
//    # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//    # OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//    # HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//    # WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//    # FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//    # OTHER DEALINGS IN THE SOFTWARE.

part of 'package:gc_wizard/tools/games/game_of_life/logic/game_of_life_rle_generate.dart';

// A Dart port of the Ruby `LifePattern` class.
//
// Example usage:
//
// void main() {
//   // Create an empty pattern and set a few cells
//   final p = LifePattern();
//   p.set(0, 0, true);
//   p.set(1, 0, true);
//   p.set(2, 0, true);
//
//   // Write to RLE
//   p.writeRLE('glider.rle');
//
//   // Load a pattern from file
//   final loaded = LifePattern('glider.rle');
//   print(loaded);
//
//   // Duplicate and overlay example
//   final dup = loaded.duplicate();
//   dup.overlay(loaded, 5, 0);
//   dup.writeRLE('glider_twice.rle');
// }
// - The internal `map` is `List<List<bool?>?>`: rows may be null, cells may be null.
// - Methods mirror the Ruby behavior: loadRLE, writeRLE, get, set, each, copy, cut, overlay, duplicate, etc.
class LifePattern {
  // Public map to mimic Ruby `attr_accessor :map`.
  // Each element is either null (a nil row) or a List<bool?> representing cells in that row.
  List<List<bool?>?> map = [];

  // Create an empty pattern or load from an RLE file if `filename` is provided.
  LifePattern([String? filename]) {
    if (filename != null) {
      loadRLE(filename);
    }
  }

  // Load RLE from `rleFile`. Prints metadata lines and progress similar to the Ruby original.
  void loadRLE(String rleFile) {
    int row = 0;
    int col = 0;

    final lines = rleFile.split('\n');
    final tokenRegex = RegExp(r'[0-9]*[bo\$]|!'); // matches runs like '3o', 'b', '$', or '!'
    final runMatchRegex = RegExp(r'([0-9]*)([bo\$])');

    for (var line in lines) {
      // Trim right side only, preserve beginning characters for meta detection
      final trimmed = line.trimRight();

      if (RegExp(r'^(#|x |x=)').hasMatch(trimmed)) {
        // print("META: $trimmed");
      } else {
        for (final m in tokenRegex.allMatches(trimmed)) {
          final run = m.group(0)!;
          final match = runMatchRegex.firstMatch(run);
          if (match != null) {
            final countStr = match.group(1) ?? '';
            final symbol = match.group(2) ?? '';
            final length = countStr.isNotEmpty ? int.parse(countStr) : 1;

            if (symbol == r'$') {
              row += length;
              col = 0;
            } else if (symbol == 'o') {
              for (int i = 0; i < length; i++) {
                set(col, row, true);
                col += 1;
              }
            } else if (symbol == 'b') {
              col += length;
            } else {
              //print("OH NO $symbol");
            }
          } else if (run == '!') {
            //print("END!");
          } else {
            //print("unknown:$run");
          }
        }
      }
    }
  }

  // Synchronous generator that yields RLE tokens similar to the Ruby `yieldRLE`.
  // Yields "o" for alive, "b" for dead for each cell in a row, and "$\n" at row end.
  Iterable<String> yieldRLE() sync* {
    for (final row in map) {
      if (row != null) {
        for (final col in row) {
          yield(col == true ? 'o' : 'b');
        }
      }
      yield('\$\n'); // "$" followed by newline to mirror Ruby implementation
    }
  }

  // Write the current pattern to RLE file `filename`.
  // Adds header line `x = <width>, y = <height>, rule = B3/S23`.
  // void writeRLE(String filename) {
  String writeRLE() {
    // Determine width (max row length) and height (number of rows)
    int x = 0;
    for (final row in map) {
      if (row != null && row.length > x) x = row.length;
    }
    final y = map.length;

    final buffer = StringBuffer();
    buffer.writeln('x = $x, y = $y, rule = B3/S23');

    String? current;
    int count = 0;
    int sinceNewline = 0;

    void flushCurrent() {
      if (count <= 0 || current == null) return;
      final toWrite = (count > 1 ? '$count' : '') + current!;
      buffer.write(toWrite);
      sinceNewline += toWrite.length;
      current = null;
      count = 0;
    }

    for (final token in yieldRLE()) {
      if (token == current) {
        count += 1;
      } else {
        // when switching, first flush the previous run
        flushCurrent();

        if (sinceNewline > 80) {
          buffer.write('\n');
          sinceNewline = 0;
        }

        current = token;
        count = 1;
      }
    }

    // Flush last run
    flushCurrent();

    buffer.write('!');

    // Write to file
    //final file = File(filename);
    //file.writeAsStringSync(buffer.toString());

    return buffer.toString();
  }

  // Get the value at `(x, y)` or `null` if not set/out of bounds.
  bool? get(int x, int y) {
    if (y < 0 || x < 0) return null;
    if (y >= map.length) return null;
    final row = map[y];
    if (row == null) return null;
    if (x >= row.length) return null;
    return row[x];
  }

  // Set the value at `(x, y)` to `value`. Expands the internal structure as needed.
  void set(int x, int y, bool? value) {
    if (x < 0 || y < 0) {
      throw ArgumentError('Negative coordinates are not supported: x=$x, y=$y');
    }

    // Ensure map has at least y+1 elements
    while (map.length <= y) {
      map.add(null);
    }

    // Ensure row exists
    if (map[y] == null) {
      map[y] = List<bool?>.filled(x + 1, null, growable: true);
    }

    final row = map[y]!;
    // Ensure row has at least x+1 elements
    while (row.length <= x) {
      row.add(null);
    }

    row[x] = value;
  }

  // Call `action(x, y)` for every non-null cell in the pattern.
  void each(void Function(int x, int y) action) {
    for (int rowNum = 0; rowNum < map.length; rowNum++) {
      final row = map[rowNum];
      if (row == null) {
        continue;
      }
      for (int colNum = 0; colNum < row.length; colNum++) {
        final col = row[colNum];
        if (col != null) {
          action(colNum, rowNum);
        }
      }
    }
  }

  // Set a rectangle starting at `(x, y)` of width `w` and height `h` to `value`.
  void setRect(int x, int y, int w, int h, bool? value) {
    if (w < 0 || h < 0) return;
    for (int col = x; col <= x + w - 1; col++) {
      for (int row = y; row <= y + h - 1; row++) {
        set(col, row, value);
      }
    }
  }

  // Return a new `LifePattern` that is a copy of the rectangle starting at `(x, y)` with width `w` and height `h`.
  LifePattern copy(int x, int y, int w, int h) {
    final result = LifePattern();
    for (int col = 0; col <= w - 1; col++) {
      for (int row = 0; row <= h - 1; row++) {
        final v = get(x + col, y + row);
        if (v == true) {
          result.set(col, row, true);
        }
      }
    }
    return result;
  }

  // Cut rectangle `(x, y, w, h)` out of this pattern and return it as a new `LifePattern`.
  // The area in this pattern is set to `null`.
  LifePattern cut(int x, int y, int w, int h) {
    final result = copy(x, y, w, h);
    setRect(x, y, w, h, null);
    return result;
  }

  // Overlay another `LifePattern` onto this one with offsets `sx` and `sy`.
  // The other pattern's set cells (non-null) are placed here as `true`.
  void overlay(LifePattern other, [int sx = 0, int sy = 0]) {
    other.each((x, y) {
      set(x + sx, y + sy, true);
    });
  }

  // Deep-duplicate the pattern and return it.
  LifePattern duplicate() {
    final result = LifePattern();
    for (final row in map) {
      if (row == null) {
        result.map.add(null);
      } else {
        // Create a shallow copy of the List<bool?> (booleans are immutable)
        result.map.add(List<bool?>.from(row));
      }
    }
    return result;
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('LifePattern: rows=${map.length}');
    for (var r = 0; r < map.length; r++) {
      final row = map[r];
      if (row == null) {
        sb.writeln('$r: <nil>');
      } else {
        final rowStr = row.map((c) => c == true ? 'o' : (c == false ? '.' : ' ')).join();
        sb.writeln('$r: $rowStr');
      }
    }
    return sb.toString();
  }
}

