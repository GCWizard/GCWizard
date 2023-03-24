import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';

enum _SCRABBLE_MODE { FREQUENCY, LETTER_VALUE }

List<int> _textToValues(String text, String scrabbleVersion, _SCRABBLE_MODE mode) {
  if (text.isEmpty) return [];

  List<int> output = [];
  var _set = scrabbleSets[scrabbleVersion];
  if (_set == null) return [];

  ScrabbleSet set = _set;

  while (text.isNotEmpty) {
    //Some Scrabble Versions include triple letters (e.g. Klingon has "tlh" or German (Gender) has "*IN")
    //Some Scrabble Versions include double letters (e.g. Spanish has "LL" or "RR" tiles)

    var tileLength = 3;
    while (tileLength > 0) {
      if (text.length >= tileLength) {
        var tile = text.substring(0, tileLength);
        if (set.existLetter(tile) || tileLength == 1) {
          if (set.existLetter(tile)) {
            output.add(mode == _SCRABBLE_MODE.FREQUENCY ? set.letterFrequency(tile) : set.letterValue(tile));
          } else {
            output.add(0);
          }
          text = text.substring(tileLength, text.length);
          tileLength = 3;
          continue;
        } else {
          tileLength--;
        }
      } else {
        tileLength--;
      }
    }
  }

  return output;
}

List<int> scrabbleTextToLetterValues(String text, String scrabbleVersion) {
  return _textToValues(text, scrabbleVersion, _SCRABBLE_MODE.LETTER_VALUE);
}

List<int> scrabbleTextToLetterFrequencies(String text, String scrabbleVersion) {
  return _textToValues(text, scrabbleVersion, _SCRABBLE_MODE.FREQUENCY);
}
