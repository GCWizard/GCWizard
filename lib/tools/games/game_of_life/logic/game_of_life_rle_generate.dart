import 'dart:math';

part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/template_rle.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/font.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/font_text.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/life.dart';
part 'package:gc_wizard/tools/games/game_of_life/logic/generate_rle/life_pattern.dart';

String generate_rle(String stringToGenerate){

  String stringToGenerate = '';

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

  return life.writeRLE();
}
