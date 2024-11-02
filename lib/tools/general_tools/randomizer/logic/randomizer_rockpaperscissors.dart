import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';

enum RockPaperScissorsElement {ROCK, PAPER, SCISSORS, LIZARD, SPOCK}
enum RockPaperScissorsGameResult {LEFT, RIGHT, DRAW}
enum RockPaperScissorsVersion {ORIGINAL, BIG_BANG_THEORY}

class RockPaperScissorsResult {
  final RockPaperScissorsElement left;
  final RockPaperScissorsElement right;
  final RockPaperScissorsGameResult winner;

  RockPaperScissorsResult(this.left, this.right, this.winner);
}

RockPaperScissorsResult randomizerRockPaperScissors(RockPaperScissorsVersion version) {
  var elements = version == RockPaperScissorsVersion.ORIGINAL ? 3 : 5;
  var left = RockPaperScissorsElement.values[randomInteger(0, elements - 1)];
  var right = RockPaperScissorsElement.values[randomInteger(0, elements - 1)];

  var winner = _rockPaperScissorsRules(left, right);

  return RockPaperScissorsResult(left, right, winner);
}

RockPaperScissorsGameResult _rockPaperScissorsRules(RockPaperScissorsElement left, RockPaperScissorsElement right) {

  switch (left) {
    case RockPaperScissorsElement.ROCK:
      switch (right) {
        case RockPaperScissorsElement.ROCK: return RockPaperScissorsGameResult.DRAW;
        case RockPaperScissorsElement.PAPER: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.SCISSORS: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.LIZARD: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.SPOCK: return RockPaperScissorsGameResult.RIGHT;
      }

    case RockPaperScissorsElement.PAPER:
      switch (right) {
        case RockPaperScissorsElement.ROCK: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.PAPER: return RockPaperScissorsGameResult.DRAW;
        case RockPaperScissorsElement.SCISSORS: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.LIZARD: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.SPOCK: return RockPaperScissorsGameResult.LEFT;
      }

    case RockPaperScissorsElement.SCISSORS:
      switch (right) {
        case RockPaperScissorsElement.ROCK: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.PAPER: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.SCISSORS: return RockPaperScissorsGameResult.DRAW;
        case RockPaperScissorsElement.LIZARD: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.SPOCK: return RockPaperScissorsGameResult.RIGHT;
      }

    case RockPaperScissorsElement.LIZARD:
      switch (right) {
        case RockPaperScissorsElement.ROCK: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.PAPER: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.SCISSORS: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.LIZARD: return RockPaperScissorsGameResult.DRAW;
        case RockPaperScissorsElement.SPOCK: return RockPaperScissorsGameResult.LEFT;
      }

    case RockPaperScissorsElement.SPOCK:
      switch (right) {
        case RockPaperScissorsElement.ROCK: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.PAPER: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.SCISSORS: return RockPaperScissorsGameResult.LEFT;
        case RockPaperScissorsElement.LIZARD: return RockPaperScissorsGameResult.RIGHT;
        case RockPaperScissorsElement.SPOCK: return RockPaperScissorsGameResult.DRAW;
      }
  }
}