import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble/logic/scrabble.dart';
import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_crosstotal_output/widget/gcw_crosstotal_output.dart';
import 'package:gc_wizard/tools/common/gcw_crosstotal_switch/widget/gcw_crosstotal_switch.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

class ScrabbleOverview extends StatefulWidget {
  @override
  ScrabbleOverviewState createState() => ScrabbleOverviewState();
}

class ScrabbleOverviewState extends State<ScrabbleOverview> {
  var _currentScrabbleVersion = scrabbleID_EN;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDownButton(
          value: _currentScrabbleVersion,
          onChanged: (value) {
            setState(() {
              _currentScrabbleVersion = value;
              _calculateOutput();
            });
          },
          items: scrabbleSets.entries.map((set) {
            return GCWDropDownMenuItem(
              value: set.key,
              child: i18n(context, set.value.i18nNameId),
            );
          }).toList(),
        ),
        GCWDefaultOutput(child: _calculateOutput()),
      ],
    );
  }

  _calculateOutput() {
    var data = <List<dynamic>>[[
      i18n(context, 'common_letter'),
      i18n(context, 'common_value'),
      i18n(context, 'scrabble_mode_frequency'),
    ]];
    data.addAll(
      scrabbleSets[_currentScrabbleVersion].letters.entries.map((entry) {
        return [
          entry.key.replaceAll(' ', String.fromCharCode(9251)),
          entry.value.value,
          entry.value.frequency
        ];
      }).toList()
    );

    return Column(
      children: columnedMultiLineOutput(context, data,
        hasHeader: true,
        copyColumn: 0
      ),
    );
  }
}
