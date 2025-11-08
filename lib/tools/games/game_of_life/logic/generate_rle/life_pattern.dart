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

import 'dart:io';

class LifePattern {
  List<List<bool?>?> map = [];

  LifePattern([String? filename]) {
    if (filename != null) {
      loadRLE(filename);
    }
  }

  void loadRLE(String filename) {
    int row = 0;
    int col = 0;

    final lines = File(filename).readAsLinesSync();

    for (var line in lines) {
      if (RegExp(r'^(#|x |x=)').hasMatch(line)) {
        //print("META: $line");
      } else {
        final regExp = RegExp(r'[0-9]*[bo\$]|!');
        final matches = regExp.allMatches(line);

        for (var match in matches) {
          final run = match.group(0)!;
          final innerMatch = RegExp(r'([0-9]*)([bo\$])').firstMatch(run);

          if (innerMatch != null) {
            int length = innerMatch.group(1)!.isNotEmpty
                ? int.parse(innerMatch.group(1)!)
                : 1;

            String char = innerMatch.group(2)!;

            if (char == r"$") {
              row += length;
              col = 0;
            } else if (char == "o") {
              for (int i = 0; i < length; i++) {
                set(col, row, true);
                col++;
              }
            } else if (char == "b") {
              col += length;
            } else {
              //print("OH NO $char");
            }
          } else if (run == "!") {
            //print("END!");
          } else {
            //print("unknown:$run");
          }
        }
      }
    }

    //print("rows=${map.length}");
  }

  Iterable<String> yieldRLE() sync* {
    for (var row in map) {
      if (row != null) {
        for (var col in row) {
          yield (col == true) ? "o" : "b";
        }
      }
      yield "\$\n";
    }
  }

  void writeRLE(String filename) {
    int x = 0;
    for (var obj in map) {
      if (obj != null && obj.length > x) {
        x = obj.length;
      }
    }
    int y = map.length;

    final f = File(filename).openSync(mode: FileMode.write);
    f.writeStringSync("x = $x, y = $y, rule = B3/S23\n");

    String? current;
    int count = 0;
    int sinceNewline = 0;

    for (var char in yieldRLE()) {
      if (char == current) {
        count++;
      } else {
        if (count > 1) f.writeStringSync(count.toString());
        if (count > 0) f.writeStringSync(current!);

        if (sinceNewline > 80) {
          f.writeStringSync("\n");
          sinceNewline = 0;
        }

        current = char;
        count = 1;
      }
      sinceNewline++;
    }

    if (count > 1) f.writeStringSync(count.toString());
    if (count > 0) f.writeStringSync(current!);

    f.writeStringSync("!");
    f.closeSync();
  }

  bool? get(int x, int y) {
    if (y < 0 || y >= map.length) return null;
    var row = map[y];
    if (row == null) return null;
    if (x < 0 || x >= row.length) return null;
    return row[x];
  }

  void set(int x, int y, bool? value) {
    while (map.length <= y) {
      map.add(null);
    }
    map[y] ??= [];
    var row = map[y]!;
    while (row.length <= x) {
      row.add(null);
    }
    row[x] = value;
  }

  void each(void Function(int colNum, int rowNum) action) {
    int rowNum = 0;
    for (var row in map) {
      int colNum = 0;
      if (row != null) {
        for (var col in row) {
          if (col != null) {
            action(colNum, rowNum);
          }
          colNum++;
        }
      }
      rowNum++;
    }
  }

  void setRect(int x, int y, int w, int h, bool? value) {
    for (int col = x; col <= x + w - 1; col++) {
      for (int row = y; row <= y + h - 1; row++) {
        set(col, row, value);
      }
    }
  }

  LifePattern copy(int x, int y, int w, int h) {
    var result = LifePattern();

    for (int col = 0; col <= w - 1; col++) {
      for (int row = 0; row <= h - 1; row++) {
        if (get(x + col, y + row) == true) {
          result.set(col, row, true);
        }
      }
    }

    return result;
  }

  LifePattern cut(int x, int y, int w, int h) {
    var result = copy(x, y, w, h);
    setRect(x, y, w, h, null);
    return result;
  }

  void overlay(List<List<int>> map, [int sx = 0, int sy = 0]) {
    for (var point in map) {
      int x = point[0];
      int y = point[1];
      set(x + sx, y + sy, true);
    }
  }

  LifePattern duplicate() {
    var result = LifePattern();
    for (var row in map) {
      if (row == null) {
        result.map.add(null);
      } else {
        result.map.add(List<bool?>.from(row));
      }
    }
    return result;
  }
}