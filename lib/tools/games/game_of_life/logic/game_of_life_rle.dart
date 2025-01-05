part of 'package:gc_wizard/tools/games/game_of_life/logic/game_of_life.dart';

GameOfLifeData? importRLE(GCWFile file) {
  var sizeRegex = RegExp(r'^[xX]\s*=\s*(\d+)\s*,\s*[yY]\s*=\s*(\d+)', multiLine: true);
  var ruleRegex = RegExp(r'rule\s*=\s*([sSbB])(\d+)\s*/\s*([sSbB])(\d+)');
  var patternRegex = RegExp(r'(\d*)([bo$])', multiLine: true);

  var text = convertBytesToString(file.bytes);

  var sizeMatch = sizeRegex.firstMatch(text);
  if (sizeMatch == null) return null;

  var dataStart = text.indexOf('\n', sizeMatch.end);
  var dataEnd = text.indexOf('!', sizeMatch.end);
  if (dataStart < 0 || dataEnd < 0) return null;

  var rules = buildRules(ruleRegex.firstMatch(text.substring(sizeMatch.end, dataStart)));
  var currentLine = 0;
  var currentPos = 0;
  var count = 0;
  var board = GameOfLifeData(Point<int>(int.parse(sizeMatch[1]!), int.parse(sizeMatch[2]!)), rules);

  patternRegex.allMatches(text.substring(dataStart + 1, dataEnd + 1)).forEach((pattern) {
    count = (pattern[1] == null || pattern[1]!.isEmpty) ? 1 : int.parse(pattern[1]!);
    switch (pattern[2]) {
      case 'o':
        for (var i = 0; i < count; i++) {
          if (currentLine < board.currentBoard.length &&  currentPos + i < board.currentBoard[currentLine].length) {
            board.currentBoard[currentLine][currentPos + i] = true;
          }
        }
      case 'b':
        currentPos += count;
        break;
      case '\$':
        currentLine += count;
        currentPos = 0;
        break;
    }
  });
  return board;
}

GameOfLifeRules buildRules(RegExpMatch? match) {
  if (match == null) return DEFAULT_GAME_OF_LIFE_RULES.first;

  var survivalsIndex = match[1] == 's' || match[1] == 'S' ? 2 : 4;
  var birthIndex = survivalsIndex == 2 ? 4 : 2;

  var survivals = GameOfLifeRules.toSet(match[survivalsIndex]!).toList();
  var births = GameOfLifeRules.toSet(match[birthIndex]!).toList();
  survivals.sort();
  births.sort();
  var survivalsSet = survivals.toSet();
  var birthsSet = births.toSet();

  for (var rule in DEFAULT_GAME_OF_LIFE_RULES) {
    if (setEquals<int>(rule.survivals, survivalsSet) && setEquals<int>(rule.births, birthsSet)) {
      return rule;
    }
  }

  return GameOfLifeRules(
      survivals: survivalsSet,
      births: birthsSet,
      key: KEY_CUSTOM_RULES);
}
