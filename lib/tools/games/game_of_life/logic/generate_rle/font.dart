// https://github.com/tlrobinson/life-gen/blob/master/font.rb
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

class RLEPatternFont {
  final List<String> _binary = [];

  RLEPatternFont() {
    var chars = _RLE_FONT_DATA.split(",");
    var binaryString = '';
    for (var string in chars) {
      binaryString = BigInt.parse(string, radix: 16).toRadixString(2).padLeft(160, '0');
      //_binary.add('0' * (160 - binaryString.length) + binaryString);
      _binary.add(binaryString);
    }
  }

  void drawString(String string, void Function(int x, int y, bool val) callback) {
    int left = 0;
    for (var c in string.codeUnits) {
      int index = c - 32;
      if (index >= _binary.length) {
        index = _binary.length - 1;
      }
      var binary = _binary[index];
      int width = 0;
      int row = 0, col = 0;

      for (var b in binary.codeUnits) {
        if (col >= 16) {
          col = 0;
          row += 1;
        }

        if (b == 49) { // ASCII code for '1'
          callback(left + col, row, true);
          if (col > width) width = col;
        } else {
          callback(left + col, row, false);
        }

        col += 1;
      }

      left += width + 2;
    }
  }

  List<List<bool?>> drawingForString(String string) {
    List<List<bool?>> drawing = [];
    drawString(string, (x, y, val) {
      while (drawing.length <= y) {
        drawing.add([]);
      }
      while (drawing[y].length <= x) {
        drawing[y].add(null);
      }
      if (val) {
        drawing[y][x] = true;
      }
    });
    return drawing;
  }
}