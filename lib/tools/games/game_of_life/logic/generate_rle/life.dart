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

part of 'package:gc_wizard/tools/games/game_of_life/logic/game_of_life_rle_generate.dart';

// Translated BitmapLifePattern from the Ruby source.
// It inherits LifePattern and arranges template pieces in a bitmap-like layout.
// The constructor prints status messages similar to the Ruby code.
class BitmapLifePattern extends LifePattern {
  late final List<List<int>> positions; // list of pairs [x,y]
  late final int height; // number of rows (not pixel height)
  late final int width; // number of columns (not pixel width)

  BitmapLifePattern(int columnsParam, int rows) : super(null) {

    // Ruby code does:
    // columns = [((columns - 5) / 4.0).ceil, 0].max
    // We'll compute the same, call it chunks.
    final chunks = max(((columnsParam - 5) / 4.0).ceil(), 0);

    // this is all incredibly fragile (kept comment)
    // final source = LifePattern('template.rle');
    final source = LifePattern(_TEMPLATE_RLE);

    // follow same copy coordinates
    final top = source.copy(225, 0, 40, 45);
    final middle = source.copy(204, 29, 28, 39);
    final bottom = source.copy(0, 205, 90, 88);
    bottom.cut(31, 0, 51, 35); // cut some rectangle from bottom

    final topX = 18 + 23 * chunks;
    final topY = 2;

    final bottomX = 0;
    final bottomY = 0 + 23 * chunks;

    final template = LifePattern();

    template.overlay(top, topX, topY);
    template.overlay(bottom, bottomX, bottomY);

    // overlay 'middle' multiple times, mirroring Ruby:
    for (int n = 0; n <= chunks - 1; n++) {
      final middleX = topX - 21 - 23 * n;
      final middleY = topY + 29 + 23 * n;
      template.overlay(middle, middleX, middleY);
    }

    // positions: bunch of ugly code to calculate and store positions of dots
    positions = <List<int>>[
      [227, 18],
      [240, 18],
      [251, 30],
      [241, 42]
    ].map((p) => [p[0] - 225 + topX, p[1] + topY]).toList();

    // the 4th dot (index 3)
    final dxdy3 = positions[3];
    final dx3 = dxdy3[0];
    final dy3 = dxdy3[1];
    for (int n = 0; n <= chunks - 1; n++) {
      positions.add([dx3 - 12 - n * 23, dy3 + 11 + n * 23]);
      positions.add([dx3 - (n + 1) * 23, dy3 + (n + 1) * 23]);
    }
    positions.add([bottomX + 24, bottomY + 34]);
    final dxdy0 = positions[0];
    final dx0 = dxdy0[0];
    final dy0 = dxdy0[1];
    for (int n0 = 0; n0 <= chunks - 1; n0++) {
      int n = chunks - 1 - n0;
      positions.add([dx0 - (n + 1) * 23, dy0 + (n + 1) * 23]);
      positions.add([dx0 - 12 - n * 23, dy0 + 11 + n * 23]);
    }

    // Now tile the template across rows
    for (int n = 0; n <= rows - 1; n++) {
      final map = template.duplicate();
      // overlay onto this (BitmapLifePattern acts as a LifePattern)
      // in the Ruby original it calls overlay(map, 115 * n, 18 * n)
      overlay(map, 115 * n, 18 * n);
    }

    height = rows;
    width = chunks * 4 + 5;
  }

  // Clear a "pixel" (3x3 rect) in the pattern for a given column and row
  void clearPixel(int col, int row) {
    final len = positions.length;
    if (len == 0) return;
    // Ruby uses: offset = (@positions.length - 1 - (row * 5) + col) % @positions.length
    int offset = (len - 1 - (row * 5) + col) % len;
    if (offset < 0) offset += len;
    final pos = positions[offset];
    final baseX = pos[0] + 115 * row;
    final baseY = pos[1] + 18 * row;
    setRect(baseX, baseY, 3, 3, null); // null -> clear
  }

  // Draw the provided drawing array. drawing[row] can be null or a List<bool>.
  // If a cell is false or missing, clear that pixel, otherwise leave as drawn.
  void draw(List<List<bool?>> drawing) {
    for (int row = 0; row <= height - 1; row++) {
      final rowArr = (row < drawing.length) ? drawing[row] : null;
      final sb = StringBuffer();
      for (int col = 0; col <= width - 1; col++) {
        final shouldDraw = (rowArr != null) && (col < rowArr.length) && (rowArr[col] != null);
        if (!shouldDraw) {
          clearPixel(col, row);
          sb.write('.');
        } else {
          sb.write('*');
        }
      }
    }
  }
}