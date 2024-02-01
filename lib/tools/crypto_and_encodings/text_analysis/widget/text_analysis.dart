import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/logic/text_analysis.dart';
import 'package:intl/intl.dart';

enum _SORT_TYPES { ALPHABETICAL, COUNT_GROUP, COUNT_OVERALL }

class TextAnalysis extends StatefulWidget {
  const TextAnalysis({Key? key}) : super(key: key);

  @override
  _TextAnalysisState createState() => _TextAnalysisState();
}

class _TextAnalysisState extends State<TextAnalysis> {
  late TextEditingController _inputController;
  String _currentInput = '';

  var _currentOptions = false;
  var _currentUseLetters = true;
  var _currentUseNumbers = true;
  var _currentUseSpecialChars = true;
  var _currentUseWhitespaceChars = true;
  var _currentUseControlChars = true;

  var _currentCaseSensitive = true;
  var _currentSort = _SORT_TYPES.ALPHABETICAL;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWOnOffSwitch(
          value: _currentOptions,
          title: 'Options',
          onChanged: (value) {
            setState(() {
              _currentOptions = value;
            });
          },
        ),
        _currentOptions
            ? Column(
                children: [
                  const GCWDivider(),
                  GCWOnOffSwitch(
                    value: _currentCaseSensitive,
                    title: i18n(context, 'common_case_sensitive'),
                    onChanged: (value) {
                      setState(() {
                        _currentCaseSensitive = value;
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    value: _currentUseLetters,
                    title: i18n(context, 'textanalysis_letters'),
                    onChanged: (value) {
                      setState(() {
                        _currentUseLetters = value;
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    value: _currentUseNumbers,
                    title: i18n(context, 'textanalysis_numerals'),
                    onChanged: (value) {
                      setState(() {
                        _currentUseNumbers = value;
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    value: _currentUseSpecialChars,
                    title: i18n(context, 'textanalysis_specialcharacters'),
                    onChanged: (value) {
                      setState(() {
                        _currentUseSpecialChars = value;
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    value: _currentUseWhitespaceChars,
                    title: i18n(context, 'textanalysis_whitespacecharacters'),
                    onChanged: (value) {
                      setState(() {
                        _currentUseWhitespaceChars = value;
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    value: _currentUseControlChars,
                    title: i18n(context, 'textanalysis_controlcharacters'),
                    onChanged: (value) {
                      setState(() {
                        _currentUseControlChars = value;
                      });
                    },
                  ),
                  const GCWDivider()
                ],
              )
            : Container(),
        GCWDropDown<_SORT_TYPES>(
          value: _currentSort,
          title: i18n(context, 'common_sortby'),
          onChanged: (value) {
            setState(() {
              _currentSort = value;
            });
          },
          items: _SORT_TYPES.values.map((type) {
            String childText;
            switch (type) {
              case _SORT_TYPES.ALPHABETICAL:
                childText = 'textanalysis_sort_alphabetical';
                break;
              case _SORT_TYPES.COUNT_GROUP:
                childText = 'textanalysis_sort_countgroup';
                break;
              case _SORT_TYPES.COUNT_OVERALL:
                childText = 'textanalysis_sort_countoverall';
                break;
            }

            return GCWDropDownMenuItem(value: type, child: i18n(context, childText));
          }).toList(),
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String? _buildControlCharName(String key) {
    var map = Map<String, ControlCharacter>.from(WHITESPACE_CHARACTERS);
    map.addAll(CONTROL_CHARACTERS);

    var char = map[key];
    if (char == null) return null;

    return char.abbreviation + '   ' + char.symbols.first + '\n' + i18n(context, char.name) + '\n' + char.unicode;
  }

  int _groupCount(Map<String, int> map) {
    return map.isEmpty ? 0 : map.values.reduce((value, element) => value + element);
  }

  TextGroup? _buildGroup(Map<String, int> map, int totalCount) {
    var numFormat = NumberFormat('0.00');

    var groupCount = _groupCount(map);
    if (groupCount == 0) return null;

    var groupCommon = [
      [i18n(context, 'textanalysis_count'), groupCount],
      [i18n(context, 'textanalysis_overallpercent'), numFormat.format(groupCount / totalCount * 100)],
      [i18n(context, 'textanalysis_distinctcharacters'), map.keys.length]
    ];

    var entries = map.entries.toList();
    switch (_currentSort) {
      case _SORT_TYPES.ALPHABETICAL:
        entries.sort((a, b) => a.key.compareTo(b.key));
        break;
      case _SORT_TYPES.COUNT_GROUP:
      case _SORT_TYPES.COUNT_OVERALL:
        entries.sort((a, b) => b.value.compareTo(a.value));
        break;
    }

    var hasControlChars = false;

    var groupDetailed = entries.map((e) {
      var isControlChar = WHITESPACE_CHARACTERS.containsKey(e.key) || CONTROL_CHARACTERS.containsKey(e.key);
      hasControlChars = hasControlChars || isControlChar;

      var data = [
        isControlChar ? _buildControlCharName(e.key) : e.key,
        e.value,
        numFormat.format(e.value / totalCount * 100)
      ];

      if (_currentSort != _SORT_TYPES.COUNT_OVERALL) {
        data.insert(2, numFormat.format(e.value / groupCount * 100));
      }

      return data;
    }).toList();

    if (_currentSort == _SORT_TYPES.COUNT_OVERALL) {
      groupDetailed.insert(0, [
        i18n(context, 'textanalysis_character'),
        i18n(context, 'textanalysis_count'),
        i18n(context, 'textanalysis_overallpercent')
      ]);
    } else {
      groupDetailed.insert(0, [
        i18n(context, 'textanalysis_character'),
        i18n(context, 'textanalysis_count'),
        i18n(context, 'textanalysis_grouppercent'),
        i18n(context, 'textanalysis_overallpercent')
      ]);
    }

    return TextGroup(groupCommon, groupDetailed, hasControlChars);
  }

  Widget _buildGroupWidget(TextGroup? group, {String? title}) {
    if (group == null) return Container();

    var flexValues =
        _currentSort == _SORT_TYPES.COUNT_OVERALL ? [2, 1, 1] : [group.isControlCharGroup ? 2 : 1, 1, 1, 1];

    var child = Column(
      children: [
        _currentSort != _SORT_TYPES.COUNT_OVERALL
            ? Column(
                children: [
                  GCWColumnedMultilineOutput(data: group.common, copyColumn: 1),
                  Container(
                    height: 8 * DOUBLE_DEFAULT_MARGIN,
                  )
                ],
              )
            : Container(),
        GCWColumnedMultilineOutput(data: group.detailed, hasHeader: true, flexValues: flexValues, copyColumn: 1)
      ],
    );

    return Column(
      children: [
        Container(
          height: 5 * DOUBLE_DEFAULT_MARGIN,
        ),
        _currentSort == _SORT_TYPES.COUNT_OVERALL
            ? child
            : GCWExpandableTextDivider(
                text: i18n(context, 'common_group') + ': ' + i18n(context, title ?? ''), child: child)
      ],
    );
  }

  int _totalCount(TextAnalysisCharacterCounts analysis) {
    var total = 0;

    if (_currentUseLetters) total += _groupCount(analysis.letters);

    if (_currentUseNumbers) total += _groupCount(analysis.numbers);

    if (_currentUseSpecialChars) total += _groupCount(analysis.specialChars);

    if (_currentUseWhitespaceChars) total += _groupCount(analysis.whiteSpaces);

    if (_currentUseControlChars) total += _groupCount(analysis.controlChars);

    return total;
  }

  Set<String> _recognizedChars(TextAnalysisCharacterCounts analysis) {
    Set<String> chars = {};

    if (_currentUseLetters) chars.addAll(analysis.letters.keys);

    if (_currentUseNumbers) chars.addAll(analysis.numbers.keys);

    if (_currentUseSpecialChars) chars.addAll(analysis.specialChars.keys);

    if (_currentUseWhitespaceChars) chars.addAll(analysis.whiteSpaces.keys);

    if (_currentUseControlChars) chars.addAll(analysis.controlChars.keys);

    return chars;
  }

  int _totalDistinctCount(Set<String> validChars) {
    return validChars.length;
  }

  int _wordCount(Set<String> validChars) {
    var text = '';
    _currentInput.split('').forEach((char) {
      if (validChars.contains(char)) text += char;
    });

    return countWords(text);
  }

  Widget _buildOutput() {
    if (!(_currentUseLetters ||
        _currentUseNumbers ||
        _currentUseSpecialChars ||
        _currentUseWhitespaceChars ||
        _currentUseControlChars)) {
      return GCWText(
        text: i18n(context, 'textanalysis_noselection'),
      );
    }

    var analysis = analyzeText(_currentInput, caseSensitive: _currentCaseSensitive);

    var recognizedChars = _recognizedChars(analysis);
    var totalCharacterCount = _totalCount(analysis);
    var totalDistinctCharacterCount = _totalDistinctCount(recognizedChars);
    var wordCount = _wordCount(recognizedChars);

    var commonOutput = GCWExpandableTextDivider(
        text: i18n(context, 'textanalysis_common_count'),
        child: GCWColumnedMultilineOutput(data: [
          [i18n(context, 'textanalysis_common_wordcount'), wordCount],
          [i18n(context, 'textanalysis_common_charactercount'), totalCharacterCount],
          [i18n(context, 'textanalysis_distinctcharacters'), totalDistinctCharacterCount],
        ], copyColumn: 1));

    if (_currentSort == _SORT_TYPES.COUNT_OVERALL) {
      return _buildOverallGroupOutput(analysis, commonOutput, totalCharacterCount);
    } else {
      return _buildGroupsOutput(analysis, totalCharacterCount, commonOutput);
    }
  }

  Column _buildOverallGroupOutput(
      TextAnalysisCharacterCounts analysis, GCWExpandableTextDivider commonOutput, int totalCharacterCount) {
    var allCharacters = <String, int>{};
    if (_currentUseLetters) allCharacters.addAll(analysis.letters);
    if (_currentUseNumbers) allCharacters.addAll(analysis.numbers);
    if (_currentUseSpecialChars) allCharacters.addAll(analysis.specialChars);
    if (_currentUseWhitespaceChars) allCharacters.addAll(analysis.whiteSpaces);
    if (_currentUseControlChars) allCharacters.addAll(analysis.controlChars);

    var allCharactersOutput = _buildGroup(allCharacters, totalCharacterCount);

    return Column(
      children: [commonOutput, _buildGroupWidget(allCharactersOutput)],
    );
  }

  Column _buildGroupsOutput(
      TextAnalysisCharacterCounts analysis, int totalCharacterCount, GCWExpandableTextDivider commonOutput) {
    var letterOutput = _currentUseLetters ? _buildGroup(analysis.letters, totalCharacterCount) : null;
    var numberOutput = _currentUseNumbers ? _buildGroup(analysis.numbers, totalCharacterCount) : null;
    var specialCharsOutput = _currentUseSpecialChars ? _buildGroup(analysis.specialChars, totalCharacterCount) : null;
    var whitespaceCharsOutput =
        _currentUseWhitespaceChars ? _buildGroup(analysis.whiteSpaces, totalCharacterCount) : null;
    var controlCharsOutput = _currentUseControlChars ? _buildGroup(analysis.controlChars, totalCharacterCount) : null;

    return Column(
      children: [
        commonOutput,
        _currentUseLetters ? _buildGroupWidget(letterOutput, title: 'textanalysis_letters') : Container(),
        _currentUseNumbers ? _buildGroupWidget(numberOutput, title: 'textanalysis_numerals') : Container(),
        _currentUseSpecialChars
            ? _buildGroupWidget(specialCharsOutput, title: 'textanalysis_specialcharacters')
            : Container(),
        _currentUseWhitespaceChars
            ? _buildGroupWidget(whitespaceCharsOutput, title: 'textanalysis_whitespacecharacters')
            : Container(),
        _currentUseControlChars
            ? _buildGroupWidget(controlCharsOutput, title: 'textanalysis_controlcharacters')
            : Container(),
      ],
    );
  }
}

class TextGroup {
  List<List<Object>> common;
  List<List<Object?>> detailed;
  bool isControlCharGroup;

  TextGroup(this.common, this.detailed, this.isControlCharGroup);
}
