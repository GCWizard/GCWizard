import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:tuple/tuple.dart';

class _wordClass {
  int sectionIndex;
  int rowIndex;
  int wordIndex;
  String text;

  _wordClass(this.sectionIndex, this.rowIndex, this.wordIndex, this.text);
}

enum searchFormat {
  SectionRowWord,
  SectionCharacter,
  RowWord,
  Word,
  SectionRowWordCharacter,
  RowWordCharacter,
  RowCharacter,
  WordCharacter,
  Character,
}

enum decodeOutFormat {
  SectionRowWord,
  RowWord,
  Word,
}

enum encodeOutFormat { SectionRowWordCharacter, RowWordCharacter, WordCharacter, Character }

String decodeSearchWord(
    String input, String word, decodeOutFormat format, String sectionLabel, String rowLabel, String wordLabel,
    {bool spacesOn = true,
    bool emptyLinesOn = true,
    String ignoreSymbols = '',
    bool diacriticsOn = true,
    bool azOn = true,
    bool numbersOn = true,
    bool onlyFirstWordLetter = false}) {
  if (input.isEmpty) return '';
  if (word.isEmpty) return '';

  input = _filterInput(input,
      spacesOn: spacesOn,
      emptyLinesOn: emptyLinesOn,
      ignoreSymbols: ignoreSymbols,
      diacriticsOn: diacriticsOn,
      azOn: azOn,
      numbersOn: numbersOn);

  var splittedResult = _wordList(input);
  var wordList = splittedResult.item1;
  word = word.toUpperCase();

  var out = wordList.where((e) => e.text.toUpperCase() == word).map((e) {
    switch (format) {
      case decodeOutFormat.SectionRowWord:
        return sectionLabel +
            ": " +
            e.sectionIndex.toString() +
            ", " +
            rowLabel +
            ": " +
            e.rowIndex.toString() +
            ", " +
            wordLabel +
            ": " +
            e.wordIndex.toString();
      case decodeOutFormat.RowWord:
        return rowLabel +
            ": " +
            _findRowIndex(e, wordList).toString() +
            ", " +
            wordLabel +
            ": " +
            e.wordIndex.toString();
      case decodeOutFormat.Word:
        return wordLabel + ": " + _findWordIndex(e, wordList).toString();
    }
  }).join('\n');

  return out;
}

String decodeFindWord(String input, String positions, searchFormat format,
    {bool spacesOn = true,
    bool emptyLinesOn = true,
    String ignoreSymbols = '',
    bool diacriticsOn = true,
    bool azOn = true,
    bool numbersOn = true,
    bool onlyFirstWordLetter = false}) {
  if (input.isEmpty) return '';
  if (positions.isEmpty) return '';

  List<int> positionList = <int>[];
  List<String> out = <String>[];
  int i = 0;

  RegExp regExp = RegExp("\\d{1,}");
  regExp.allMatches(positions).forEach((elem) {
    var value = int.tryParse(positions.substring(elem.start, elem.end));
    if (value != null) positionList.add(value);
  });

  input = _filterInput(input,
      spacesOn: spacesOn,
      emptyLinesOn: emptyLinesOn,
      ignoreSymbols: ignoreSymbols,
      diacriticsOn: diacriticsOn,
      azOn: azOn,
      numbersOn: numbersOn);

  var splittedResult = _wordList(input);
  var wordList = splittedResult.item1;
  var rowList = splittedResult.item2;
  var sectionList = splittedResult.item2;

  while (i < positionList.length) {
    switch (format) {
      case searchFormat.SectionRowWord:
        if (i + 2 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              section: positionList[i + 0],
              row: positionList[i + 1],
              word: positionList[i + 2],
              onlyFirstWordLetter: onlyFirstWordLetter));
        }
        i += 3;
        break;

      case searchFormat.SectionCharacter:
        if (i + 1 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              section: positionList[i + 0], character: positionList[i + 1], onlyFirstWordLetter: false));
        }
        i += 2;
        break;

      case searchFormat.RowWord:
        if (i + 1 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              row: positionList[i + 0], word: positionList[i + 1], onlyFirstWordLetter: onlyFirstWordLetter));
        }
        i += 2;
        break;

      case searchFormat.Word:
        if (i + 0 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              word: positionList[i + 0], onlyFirstWordLetter: onlyFirstWordLetter));
        }
        i += 1;
        break;

      case searchFormat.SectionRowWordCharacter:
        if (i + 3 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              section: positionList[i + 0],
              row: positionList[i + 1],
              word: positionList[i + 2],
              character: positionList[i + 3],
              onlyFirstWordLetter: false));
        }
        i += 4;
        break;

      case searchFormat.RowWordCharacter:
        if (i + 2 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              row: positionList[i + 0],
              word: positionList[i + 1],
              character: positionList[i + 2],
              onlyFirstWordLetter: false));
        }
        i += 3;
        break;

      case searchFormat.RowCharacter:
        if (i + 1 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              row: positionList[i + 0], character: positionList[i + 1], onlyFirstWordLetter: false));
        }
        i += 2;
        break;

      case searchFormat.WordCharacter:
        if (i + 1 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              word: positionList[i + 0], character: positionList[i + 1], onlyFirstWordLetter: false));
        }
        i += 2;
        break;

      case searchFormat.Character:
        if (i + 0 < positionList.length) {
          out.add(_findWord(wordList, rowList, sectionList, format,
              character: positionList[i + 0], onlyFirstWordLetter: false));
        }
        i += 1;
        break;
    }
  }

  return out.map((e) {
    return e.toUpperCase();
  }).join();
}

String encodeText(String input, String text, encodeOutFormat format,
    {bool spacesOn = true,
    bool emptyLinesOn = true,
    String ignoreSymbols = '',
    bool diacriticsOn = true,
    bool azOn = true,
    bool numbersOn = true,
    bool onlyFirstWordLetter = false}) {
  if (input.isEmpty) return '';
  if (text.isEmpty) return '';

  input = _filterInput(input,
      spacesOn: spacesOn,
      emptyLinesOn: emptyLinesOn,
      ignoreSymbols: ignoreSymbols,
      diacriticsOn: diacriticsOn,
      azOn: azOn,
      numbersOn: numbersOn);

  var out = '';
  var splittedResult = _wordList(input);
  var wordList = splittedResult.item1;
  var sectionList = splittedResult.item2;
  var positionList = <Tuple2<_wordClass?, int>>[];

  if (onlyFirstWordLetter) {
    for (var element in wordList) {
      if (element.text.isNotEmpty) element.text = element.text[0];
    }
  }

  text.split('').forEach((letter) {
    if (format == encodeOutFormat.Character) {
      positionList.add(_selectRandomLetterPosition(letter, sectionList));
    } else {
      positionList.add(_selectRandomLetterPosition(letter, wordList));
    }
  });

  for (var element in positionList) {
    var e = element.item1;
    switch (format) {
      case encodeOutFormat.SectionRowWordCharacter:
        if (e == null) {
          out += _createOutElement(true, -1, -1, -1, -1);
        } else {
          out += _createOutElement(false, e.sectionIndex, e.rowIndex, e.wordIndex, element.item2);
        }
        break;

      case encodeOutFormat.RowWordCharacter:
        if (e == null) {
          out += _createOutElement(true, 0, -1, -1, -1);
        } else {
          out += _createOutElement(false, 0, _findRowIndex(e, wordList), e.wordIndex, element.item2);
        }
        break;

      case encodeOutFormat.WordCharacter:
        if (e == null) {
          out += _createOutElement(true, 0, 0, -1, -1);
        } else {
          out += _createOutElement(false, 0, 0, _findWordIndex(e, wordList), element.item2);
        }
        break;

      case encodeOutFormat.Character:
        if (e == null) {
          out += _createOutElement(true, 0, 0, 0, -1);
        } else {
          out += _createOutElement(false, 0, 0, 0, _globalCharacterPosition(e, element.item2, sectionList));
        }
        break;
    }
  }

  return out.trim();
}

String _createOutElement(bool emptyElement, int number1, int number2, int number3, int number4) {
  var seperator = '.';
  var out = '';

  if (emptyElement) {
    if (number1 != 0) out += "?" + seperator;
    if (number2 != 0) out += "?" + seperator;
    if (number3 != 0) out += "?" + seperator;
    if (number4 != 0) out += "?";
  } else {
    if (number1 != 0) out += number1.toString() + seperator;
    if (number2 != 0) out += number2.toString() + seperator;
    if (number3 != 0) out += number3.toString() + seperator;
    if (number4 != 0) out += number4.toString();
  }

  return out + " ";
}

int _findRowIndex(_wordClass word, List<_wordClass> wordList) {
  var rowIndex = 0;
  var rowIndexTmp = 0;
  var lastRowIndex = 0;
  var sectionIndex = 0;

  for (var item in wordList) {
    if (sectionIndex != item.sectionIndex) {
      rowIndexTmp += 1;
    } else if (lastRowIndex != item.rowIndex) {
      rowIndexTmp += 1;
    }

    lastRowIndex = item.rowIndex;
    sectionIndex = item.sectionIndex;

    if (word == item) {
      rowIndex = rowIndexTmp;
      break;
    }
  }

  return rowIndex;
}

int _findWordIndex(_wordClass word, List<_wordClass> wordList) {
  return wordList.indexOf(word) + 1;
}

String _findWord(List<_wordClass> wordList, List<_wordClass> rowList, List<_wordClass> sectionList, searchFormat format,
    {int section = 0, int row = 0, int word = 0, int character = 0, bool onlyFirstWordLetter = false}) {
  List<_wordClass> list;
  _wordClass wordEntry;

  switch (format) {
    case searchFormat.SectionRowWord:
      list = _filterSection(section, wordList);
      list = _filterRow(row, list);
      return _filterWord(word, list, onlyFirstWordLetter).text;

    case searchFormat.SectionCharacter:
      list = _filterSection(section, sectionList);
      return _filterCharacter(character, list);

    case searchFormat.RowWord:
      list = _filterRow(row, wordList);
      return _filterWord(word, list, onlyFirstWordLetter).text;

    case searchFormat.Word:
      return _filterWord(word, wordList, onlyFirstWordLetter).text;

    case searchFormat.SectionRowWordCharacter:
      list = _filterSection(section, wordList);
      list = _filterRow(row, list);
      wordEntry = _filterWord(word, list, onlyFirstWordLetter);
      list = List<_wordClass>.from([wordEntry]);
      return _filterCharacter(character, list);

    case searchFormat.RowWordCharacter:
      list = _filterRow(row, wordList);
      wordEntry = _filterWord(word, list, onlyFirstWordLetter);
      list = List<_wordClass>.from([wordEntry]);
      return _filterCharacter(character, list);

    case searchFormat.RowCharacter:
      list = _filterRow(row, rowList);
      return _filterCharacter(character, list);

    case searchFormat.WordCharacter:
      wordEntry = _filterWord(word, wordList, onlyFirstWordLetter);
      list = List<_wordClass>.from([wordEntry]);
      return _filterCharacter(character, list);

    case searchFormat.Character:
      return _filterCharacter(character, sectionList);
  }

}

List<_wordClass> _filterSection(int index, List<_wordClass> wordList) {
  var list = <_wordClass>[];

  for (var item in wordList) {
    if (item.sectionIndex == index) list.add(item);
  }

  return list;
}

List<_wordClass> _filterRow(int index, List<_wordClass> wordList) {
  var list = <_wordClass>[];
  var rowIndex = 0;
  var lastRowIndex = 0;
  var sectionIndex = 0;

  for (var item in wordList) {
    if (sectionIndex != item.sectionIndex) {
      rowIndex += 1;
    } else if (lastRowIndex != item.rowIndex) {
      rowIndex += 1;
    }

    lastRowIndex = item.rowIndex;
    sectionIndex = item.sectionIndex;

    if (rowIndex == index) list.add(item);
  }

  return list;
}

_wordClass _filterWord(int index, List<_wordClass> wordList, bool onlyFirstWordLetter) {
  if (index > 0 && wordList.length >= index) {
    if (onlyFirstWordLetter) return _onlyFirstWordLetter(wordList[index - 1]);
    return wordList[index - 1];
  }

  return _wordClass(-1, -1, -1, '');
}

_wordClass _onlyFirstWordLetter(_wordClass wordClass) {
  if (wordClass.text.isNotEmpty) {
    return _wordClass(wordClass.sectionIndex, wordClass.rowIndex, wordClass.rowIndex, wordClass.text[0]);
  }
  return _wordClass(-1, -1, -1, '');
}

String _filterCharacter(int index, List<_wordClass> wordList) {
  var text = '';

  for (var item in wordList) {
    text += item.text;
  }

  if (index > 0 && index <= text.length) return text[index - 1];

  return '';
}

int _globalCharacterPosition(_wordClass word, int characterPosition, List<_wordClass> sectionList) {
  var text = '';

  for (var item in sectionList) {
    if (item == word) break;
    text += item.text;
  }

  return text.length + characterPosition;
}

Tuple2<_wordClass?, int> _selectRandomLetterPosition(String letter, List<_wordClass> wordList) {
  var letterCount = 0;
  var letterCountTmp = 0;
  var letterWordList = <_wordClass>[];
  var letterPosition = 0;
  _wordClass? outWord;
  var outLetterPosition = 0;

  var regexp = RegExp(letter, caseSensitive: false);

  for (var element in wordList) {
    letterCountTmp = regexp.allMatches(element.text).length;
    if (letterCountTmp > 0) letterWordList.add(element);
    letterCount += letterCountTmp;
  }

  if (letterCount > 0) {
    var randomIndex = Random().nextInt(letterCount);

    letterCount = 0;
    letterCountTmp = 0;
    for (_wordClass word in letterWordList) {
      if (outWord != null) break;
      letterPosition = 0;
      regexp.allMatches(word.text).forEach((element) {
        letterPosition = word.text.toUpperCase().indexOf(letter.toUpperCase(), letterPosition);
        letterPosition += 1;
        if (letterCountTmp == randomIndex) {
          outWord = word;
          outLetterPosition = letterPosition;
        }
        letterCountTmp += 1;
      });
    }
  }
  return Tuple2<_wordClass?, int>(outWord, outLetterPosition);
}

Tuple3<List<_wordClass>, List<_wordClass>, List<_wordClass>> _wordList(String input) {
  var wordList = <_wordClass>[];
  var rowList = <_wordClass>[];
  var sectionList = <_wordClass>[];
  int sectionIndex = 0;
  int rowIndex = 0;
  int wordIndex = 0;

  input.split(RegExp(r"\n\s*\n|\r\n\s*\r\n]")).forEach((section) {
    sectionIndex += 1;
    rowIndex = 0;
    wordIndex = 0;
    sectionList.add(_wordClass(sectionIndex, rowIndex, wordIndex, section));

    section.split(RegExp(r"\n")).forEach((row) {
      rowIndex += 1;
      wordIndex = 0;
      rowList.add(_wordClass(sectionIndex, rowIndex, wordIndex, row));

      row.split(RegExp(r"[\s]|[\.]|[,]|[!]|[\?]|[\\]")).forEach((word) {
        if (word.isNotEmpty) {
          wordIndex += 1;
          wordList.add(_wordClass(sectionIndex, rowIndex, wordIndex, word));
        }
      });
    });
  });

  return Tuple3<List<_wordClass>, List<_wordClass>, List<_wordClass>>(wordList, rowList, sectionList);
}

String _filterInput(String input,
    {bool spacesOn = true,
    bool emptyLinesOn = true,
    String ignoreSymbols = '',
    bool diacriticsOn = true,
    bool azOn = true,
    bool numbersOn = true}) {
  if (!spacesOn) input = input.replaceAll(RegExp(r'[^\n\S]'), '');
  if (!emptyLinesOn) {
    input = input.replaceAll('\n\n', '\n');
    input = input.replaceAll('\r\n\r\n', '\r\n');
  }
  if (ignoreSymbols.isNotEmpty) {
    var filter = ignoreSymbols.split('').map((char) {
      return r'\' + char;
    }).join();
    input = input.replaceAll(RegExp(r"[" + filter + "]"), '');
  }
  if (!diacriticsOn) input = _removeDiacritics(input);
  if (!azOn) input = input.replaceAll(RegExp(r'[A-Za-z]'), '');
  if (!numbersOn) input = input.replaceAll(RegExp(r'\d'), '');

  return input;
}

String _removeDiacritics(String input) {
  var copy = removeDiacritics(input);

  if (input.length != copy.length) return copy;
  for (var i = input.length - 1; i >= 0; i--) {
    if (input[i] != copy[i]) input = input.replaceRange(i, i + 1, '');
  }

  return input;
}
