import 'dart:math';

part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/font.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/font_text.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/life.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/lifepattern.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/template_rle.dart';

// based on https://github.com/tlrobinson/life-gen/blob/master/life-gen.dart
// using life.rb

// Copyright (c) 2009 Thomas Robinson <tlrobinson.net>
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//
// to run the produced RLE file:

// https://conwaylife.com/
//
String generate_rle(String stringToGenerate){

  var width = 100;
  var height = 50;

  List<List<bool?>>? drawing;

  final font = RLEPatternFont();
  drawing = font.drawingForString(stringToGenerate);
  height = drawing.length;
  var wmax = 0;
  for (var r in drawing) {
    wmax = max(wmax, r.length);
  }
  width = wmax + 10;

  final life = BitmapLifePattern(width, height);
  life.draw(drawing);

  return life.writeRLE();
}
