import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/piano/logic/piano.dart';

class Piano extends StatefulWidget {
  @override
  PianoState createState() => PianoState();
}

class PianoState extends State<Piano> {
  var _currentSort = 0;
  var _currentIndex = 9; // Key number 1
  List<String> _currentSortList = [
    'piano_number',
    'piano_color',
    'piano_frequency',
    'piano_helmholtz',
    'piano_scientific',
    'piano_german',
    'piano_midi',
    'piano_latin'
  ];

  List<String> fields = ['color', 'frequency', 'helmholtz', 'scientific', 'german', 'midi', 'latin'];

  var _currentColor = GCWSwitchPosition.left;
  var _isColorSort = false;

  @override
  Widget build(BuildContext context) {
    var field = _currentSort == 0 ? fields[0] : fields[_currentSort - 1];
    return Column(
      children: <Widget>[
        GCWDropDown(
          title: i18n(context, 'piano_sort'),
          value: _currentSort,
          onChanged: (value) {
            setState(() {
              _currentSort = value;
              _isColorSort = _currentSort == 1;
            });
            field = _currentSort == 0 ? fields[0] : fields[_currentSort - 1];
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
                items: PIANO_KEYS.values.where((e) => e[field] != null && e[field].length > 0).map((e) {
                  if (_currentSort == 0) {
                    return e['number'];
                  } else {
                    return e[field];
                  }
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
              ),
        GCWDefaultOutput(
          child: _buildOutput()
        ),
      ],
    );
  }

  Widget _buildOutput() {
    if (_isColorSort) {
      var chosenColor = _currentColor == GCWSwitchPosition.left ? 'white' : 'black';
      var data = PIANO_KEYS.entries.where((element) => element.value['color'].endsWith(chosenColor)).map((element) {
        return [element.value['number'], element.value['frequency']];
      }).toList();

      data.insert(0, [i18n(context, 'piano_number'), i18n(context, 'piano_frequency')]);

      return GCWColumnedMultilineOutput(
          data: data,
          hasHeader: true,
          flexValues: [1, 2]
      );
    } else {
      var keyNumber = PIANO_KEYS.keys.toList()[_currentIndex];

      return GCWColumnedMultilineOutput(
          data: [
                  [i18n(context, 'piano_number'), PIANO_KEYS[keyNumber]['number']],
                  [i18n(context, 'piano_color'), i18n(context, PIANO_KEYS[keyNumber]['color'])],
                  [i18n(context, 'piano_frequency'), PIANO_KEYS[keyNumber]['frequency']],
                  [i18n(context, 'piano_helmholtz'), PIANO_KEYS[keyNumber]['helmholtz']],
                  [i18n(context, 'piano_scientific'), PIANO_KEYS[keyNumber]['scientific']],
                  [i18n(context, 'piano_german'), PIANO_KEYS[keyNumber]['german']],
                  [i18n(context, 'piano_midi'), PIANO_KEYS[keyNumber]['midi']],
                  [i18n(context, 'piano_latin'), PIANO_KEYS[keyNumber]['latin']],
                ],
          flexValues: [1, 2]
      );
    }
  }
}
