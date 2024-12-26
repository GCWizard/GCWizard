import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/word_search/logic/word_search.dart';

class WordSearch extends StatefulWidget {
  const WordSearch({Key? key}) : super(key: key);

  @override
  WordSearchState createState() => WordSearchState();
}

class WordSearchState extends State<WordSearch> {
  late TextEditingController _inputController;
  late TextEditingController _wordsController;

  String _currentInput = '';
  String _currentWords = '';
  int _currentSearchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.HORIZONTAL) |
      SearchDirectionFlags.setFlag(0, SearchDirectionFlags.VERTICAL) |
      SearchDirectionFlags.setFlag(0, SearchDirectionFlags.DIAGONAL) |
      SearchDirectionFlags.setFlag(0, SearchDirectionFlags.REVERSE);

  var _currentOptionsExpanded = false;
  var _currentFillGapMode = FillGapMode.OFF;

  List<Uint8List> _decodeOutput = [];
  List<String> _viewOutput = [];

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _wordsController = TextEditingController(text: _currentWords);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _wordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTextDivider(
        text: i18n(context, 'word_search_input'),
      ),
      GCWTextField(
        controller: _inputController,
        style: gcwMonotypeTextStyle(),
        onChanged: (text) {
          setState(() {
            _currentInput = text;
          });
        },
      ),
      GCWTextDivider(
        text: i18n(context, 'common_search'),
      ),
      GCWTextField(
        controller: _wordsController,
        onChanged: (text) {
          setState(() {
            _currentWords = text;
          });
        },
      ),
      _buildOptionWidget(),
      _buildButtonRow(),
      _buildOutput(),
    ]);
  }

  Widget _buildOptionWidget() {
    return GCWExpandableTextDivider(
      text: i18n(context, 'common_options'),
      suppressTopSpace: false,
      expanded: _currentOptionsExpanded,
      onChanged: (value) {
        setState(() {
          _currentOptionsExpanded = value;
        });
      },
      child: Column(children: <Widget>[
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_horizontal'),
          value: SearchDirectionFlags.hasFlag(_currentSearchDirection, SearchDirectionFlags.HORIZONTAL),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? SearchDirectionFlags.setFlag(_currentSearchDirection, SearchDirectionFlags.HORIZONTAL)
                  : SearchDirectionFlags.resetFlag(_currentSearchDirection, SearchDirectionFlags.HORIZONTAL);
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_vertical'),
          value: SearchDirectionFlags.hasFlag(_currentSearchDirection, SearchDirectionFlags.VERTICAL),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? SearchDirectionFlags.setFlag(_currentSearchDirection, SearchDirectionFlags.VERTICAL)
                  : SearchDirectionFlags.resetFlag(_currentSearchDirection, SearchDirectionFlags.VERTICAL);
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_diagonal'),
          value: SearchDirectionFlags.hasFlag(_currentSearchDirection, SearchDirectionFlags.DIAGONAL),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? SearchDirectionFlags.setFlag(_currentSearchDirection, SearchDirectionFlags.DIAGONAL)
                  : SearchDirectionFlags.resetFlag(_currentSearchDirection, SearchDirectionFlags.DIAGONAL);
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_reverse'),
          value: SearchDirectionFlags.hasFlag(_currentSearchDirection, SearchDirectionFlags.REVERSE),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? SearchDirectionFlags.setFlag(_currentSearchDirection, SearchDirectionFlags.REVERSE)
                  : SearchDirectionFlags.resetFlag(_currentSearchDirection, SearchDirectionFlags.REVERSE);
            });
          },
        ),
        GCWDropDown<FillGapMode>(
          title: i18n(context, 'word_search_fill_gap_mode'),
          flexValues: const [1, 1],
          value: _currentFillGapMode,
          onChanged: (value) {
            setState(() {
              _currentFillGapMode = value;
            });
          },
          items: <FillGapMode, String>{
            FillGapMode.OFF: 'common_off',
            FillGapMode.DOWN: 'common_down',
            FillGapMode.TOP: 'common_up',
            FillGapMode.RIGHT: 'common_right',
            FillGapMode.LEFT: 'common_left',
          }
              .map((key, value) {
                return MapEntry(key, GCWDropDownMenuItem(value: key, child: i18n(context, value)));
              })
              .values
              .toList(),
        ),
      ]),
    );
  }

  Widget _buildButtonRow() {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
          child: GCWButton(
            text: _viewOutput.isEmpty ? i18n(context, 'common_search') : i18n(context, 'word_search_search_more'),
            onPressed: () {
              setState(() {
                _calcOutputFillGapMode();
              });
            },
          ),
      )),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
          child: GCWButton(
            text: i18n(context, 'word_search_delete_letters'),
            onPressed: () {
              setState(() {
                _deleteMarkedLetters();
              });
            },
          ),
      )),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
          child: GCWButton(
            text: i18n(context, 'common_reset'),
            onPressed: () {
              setState(() {
                _decodeOutput = [];
                _viewOutput = [];
              });
            },
          ),
        ),
      ),
    ]);
  }

  void _calcOutput() {
    _decodeOutput = searchWordList(_currentInput, _currentWords, _currentSearchDirection);
    _viewOutput = normalizeAndSplitInputForView(_currentInput);
    setState(() {});
  }

  void _calcOutputFillGapMode() {
    if (_viewOutput.isEmpty) {
      _calcOutput();
    } else {
      _decodeOutput = searchWordList(_viewOutput.join('\r\n'), _currentWords, _currentSearchDirection, noSpaces: false);
      setState(() {});
    }
  }

  void _deleteMarkedLetters() {
    if (_viewOutput.isEmpty) return;
    if (_decodeOutput.isEmpty) return;
    _viewOutput = fillSpaces(_viewOutput.join('\r\n'), _decodeOutput, _currentFillGapMode);
    _decodeOutput = searchWordList(_viewOutput.join('\r\n'), '', 0, noSpaces: false);
    setState(() {});
  }

  Widget _buildOutput() {
    return GCWDefaultOutput(
      trailing: Row(
        children: <Widget>[
          GCWIconButton(
            iconColor: themeColors().mainFont(),
            size: IconButtonSize.SMALL,
            icon: Icons.content_copy,
            onPressed: () {
              insertIntoGCWClipboard(context, _viewOutput.join('\n'));
            },
          ),
        ],
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: _buildRtfOutput(_viewOutput, _decodeOutput), style: gcwTextStyle()),
      ),
    );
  }

  List<TextSpan> _buildRtfOutput(List<String> text, List<Uint8List> founds) {
    var textSpan = <TextSpan>[];

    if (text.isEmpty || text.first.isEmpty || founds.isEmpty || founds.first.isEmpty) return textSpan;
    var lastColor = _getTextColorValue(founds.first.first);
    var actText = '';

    for (var row = 0; row < text.length; row++) {
      if (row > 0) actText += '\n';
      for (var column = 0; column < text[row].length; column++) {
        var actColor = lastColor;
        if (founds.length > row && founds[row].length > column) {
          actColor = _getTextColorValue(founds[row][column]);
        }
        var lastEntry = (row == text.length - 1 && column == text[row].length - 1);
        if (lastEntry || actColor != lastColor) {
          if (lastEntry) {
            if (actColor != lastColor) {
              textSpan.add(_createTextSpan(actText, lastColor));
              actText = '';
              lastColor = actColor;
            }
            actText += text[row][column] + ' ';
          }

          textSpan.add(_createTextSpan(actText, lastColor));
          actText = '';
          lastColor = actColor;
        }
        actText += text[row][column] + ' ';
      }
    }
    return textSpan;
  }

  TextSpan _createTextSpan(String text, int color) {
    switch (color) {
      case 1:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.red));
      case 2:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.green));
      case 3:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.blue));
      default:
        return TextSpan(text: text, style: gcwMonotypeTextStyle());
    }
  }

  int _getTextColorValue(int value) {
    if (value == 0) return 0;
    if (SearchDirectionFlags.hasFlag(value, SearchDirectionFlags.HORIZONTAL)) return 1;
    if (SearchDirectionFlags.hasFlag(value, SearchDirectionFlags.VERTICAL)) return 2;
    if (SearchDirectionFlags.hasFlag(value, SearchDirectionFlags.DIAGONAL)) return 3;
    return 0;
  }
}
