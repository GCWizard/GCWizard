import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/piano/logic/piano.dart';

class Piano extends StatefulWidget {
  const Piano({super.key});

  @override
  _PianoState createState() => _PianoState();
}

class _PianoState extends State<Piano> {
  var _currentSort = 0;
  var _currentIndex = 9;

  final List<int> _allKeyIds = [
    ...List.generate(9, (i) => 89 + i), // 89 bis 97
    ...List.generate(88, (i) => 1 + i), // 1 bis 88
    ...List.generate(11, (i) => 98 + i) // 98 bis 108
  ];

  MiddleCStandard _middleC = MiddleCStandard.C4;

  final List<String> _currentSortList = [
    'piano_number',
    'piano_color',
    'piano_frequency',
    'piano_helmholtz',
    'piano_scientific',
    'piano_german',
    'piano_italian',
    'piano_midi',
  ];

  var _currentColor = GCWSwitchPosition.left;
  var _isColorSort = false;

  @override
  Widget build(BuildContext context) {
    var field = _currentSort == 0 ? PianoFields.values.first : PianoFields.values.elementAt(_currentSort - 1);

    List<String> spinnerItems = _allKeyIds.map((id) {
      final key = PianoCalculator.getKey(id, middleC: _middleC);
      return ((_currentSort == 0) ? key.number : key.getField(field)).toString();
    }).toList();

    return Column(
      children: <Widget>[
        GCWDropDown<int>(
          title: i18n(context, 'piano_sort'),
          value: _currentSort,
          onChanged: (value) {
            setState(() {
              _currentSort = value;
              _isColorSort = _currentSort == 1;
            });
          },
          items: _currentSortList
              .asMap()
              .map((index, field) {
            return MapEntry(index, GCWDropDownMenuItem(value: index, child: i18n(context, field)));
          })
              .values
              .toList(),
        ),
        _isColorSort
            ? GCWTwoOptionsSwitch(
          title: i18n(context, 'piano_color'),
          leftValue: i18n(context, 'common_color_white'),
          rightValue: i18n(context, 'common_color_black'),
          value: _currentColor,
          onChanged: (value) {
            setState(() {
              _currentColor = value;
            });
          },
        )
            : GCWDropDownSpinner(
          index: _currentIndex,
          items: spinnerItems,
          onChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        if (!_isColorSort)
          GCWExpandableTextDivider(
            text: i18n(context, 'common_options'),
            expanded: false,
            suppressTopSpace: false,
            child: GCWDropDown<MiddleCStandard>(
              title: i18n(context, 'piano_midi_middle_c'),
              value: _middleC,
              onChanged: (value) {
                setState(() {
                  _middleC = value;
                });
              },
              items: MiddleCStandard.values.map((standard) {
                String label;
                switch (standard) {
                  case MiddleCStandard.C3:
                    label = "C3 (Yamaha)";
                    break;
                  case MiddleCStandard.C4:
                    label = "C4 (Scientific / Roland)";
                    break;
                  case MiddleCStandard.C5:
                    label = "C5 (Legacy)";
                    break;
                }
                return GCWDropDownMenuItem(value: standard, child: label);
              }).toList(),
            ),
          ),
        GCWDefaultOutput(child: _buildOutput()),
      ],
    );
  }

  Widget _buildOutput() {
    if (_isColorSort) {
      var chosenColor = _currentColor == GCWSwitchPosition.left ? 'common_color_white' : 'common_color_black';

      var dataIdx = <void Function()>[() => {}];

      List<List<String>> data = [];

      for (int i = 0; i < _allKeyIds.length; i++) {
        int id = _allKeyIds[i];
        var key = PianoCalculator.getKey(id, middleC: _middleC);

        if (key.color == chosenColor) {
          dataIdx.add(() {
            setState(() {
              _currentSort = 0;
              _currentIndex = i;
              _isColorSort = false;
            });
          });
          data.add([key.number, key.frequency]);
        }
      }

      data.insert(0, [i18n(context, 'piano_number'), i18n(context, 'piano_frequency')]);

      return GCWColumnedMultilineOutput(data: data, hasHeader: true, flexValues: const [1, 2], tappables: dataIdx);
    } else {
      var currentKeyId = _allKeyIds[_currentIndex];
      var currentKey = PianoCalculator.getKey(currentKeyId, middleC: _middleC);

      return GCWColumnedMultilineOutput(data: [
        [i18n(context, 'piano_number'), currentKey.number],
        [i18n(context, 'piano_color'), i18n(context, currentKey.color)],
        [i18n(context, 'piano_frequency'), currentKey.frequency],
        [i18n(context, 'piano_helmholtz'), currentKey.helmholtz],
        [i18n(context, 'piano_scientific'), currentKey.scientific],
        [i18n(context, 'piano_german'), currentKey.german],
        [i18n(context, 'piano_italian'), currentKey.italian],
        [i18n(context, 'piano_midi'), currentKey.midi],
      ], flexValues: const [
        1,
        2
      ]);
    }
  }
}
