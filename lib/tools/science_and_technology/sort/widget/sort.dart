import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/sort/logic/sort.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum _SortType{CHARACTERS, WORDS, LINES, CHARS_IN_WORDS}

class Sort extends StatefulWidget {
  const Sort({Key? key}) : super(key: key);

  @override
  _SortState createState() => _SortState();
}

class _SortState extends State<Sort> {
  var _currentInput = '';
  late TextEditingController _inputController;

  var _currentSortType = _SortType.CHARACTERS;

  var _currentCaseSensitive = false;
  var _currentSortingMode = GCWSwitchPosition.left;

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
          onChanged: (value) {
            setState(() {
              _currentInput = value;
            });
          },
        ),
        GCWDropDown<_SortType>(
          value: _currentSortType,
          items: _SortType.values.map((type) {
            var text = 'sort_modes_' + enumName(type.toString()).toLowerCase();

            return GCWDropDownMenuItem(
              value: type,
              child: i18n(context, text + '_title'),
              subtitle: i18n(context, text + '_description')
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentSortType = value;
            });
          }
        ),
        Container(height: 2 * DOUBLE_DEFAULT_MARGIN),
        GCWOnOffSwitch(
          value: _currentCaseSensitive,
          title: i18n(context, 'common_case_sensitive'),
          onChanged: (value) {
            setState(() {
              _currentCaseSensitive = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'common_sorting'),
          leftValue: i18n(context, 'common_sorting_asc'),
          rightValue: i18n(context, 'common_sorting_desc'),
          value: _currentSortingMode,
          onChanged: (value) {
            setState(() {
              _currentSortingMode = value;
            });
          }
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) {
      return const GCWDefaultOutput();
    }

    var sortMode = _currentSortingMode == GCWSwitchPosition.left ? SortingMode.ASCENDING : SortingMode.DESCENDING;
    var sortInput = _currentCaseSensitive ? _currentInput : _currentInput.toUpperCase();

    String textOutput = '';
    switch (_currentSortType) {
      case _SortType.CHARACTERS: textOutput = sortTextASCII(sortInput, sortMode); break;
      case _SortType.WORDS: textOutput = sortList<String>(sortInput.split(RegExp(r'\s+')).toList(), sortMode).join(' '); break;
      case _SortType.LINES: textOutput = sortList<String>(sortInput.replaceAll('\r+', '').split(RegExp(r'\n+')).toList(), sortMode).join('\n'); break;
      case _SortType.CHARS_IN_WORDS: textOutput = sortTextInBlocks(sortInput, sortMode); break;
      default: break;
    }

    List<String> detailData;
    switch (_currentSortType) {
      case _SortType.CHARACTERS: detailData = textOutput.split('').toList(); break;
      case _SortType.WORDS: detailData = textOutput.split(' ').toList(); break;
      case _SortType.LINES: detailData = textOutput.split('\n').toList(); break;
      case _SortType.CHARS_IN_WORDS: detailData = textOutput.split(RegExp(r'[\s]')).toList(); break;
      default: detailData = <String>[]; break;
    }

    var details = GCWExpandableTextDivider(
      suppressTopSpace: false,
      text: i18n(context, 'common_details'),
      expanded: false,
      child: GCWColumnedMultilineOutput(
        flexValues: const [1, 5],
        data: detailData.asMap().map((index, data) {
            return MapEntry<int, List<String>>(
                index,
                [(index + 1).toString() + '.', data]
            );
          }).values.toList()
      ),
    );

    return Column(
      children: [
        GCWDefaultOutput(
          child: textOutput,
        ),
        details
      ],
    );
  }
}
