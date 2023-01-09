import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/games/scrabble/scrabble_sets.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';

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

  Widget _calculateOutput() {
    var data = <List<dynamic>>[
      [
        i18n(context, 'common_letter'),
        i18n(context, 'common_value'),
        i18n(context, 'scrabble_mode_frequency'),
      ]
    ];
    data.addAll(scrabbleSets[_currentScrabbleVersion].letters.entries.map((entry) {
      return [entry.key.replaceAll(' ', String.fromCharCode(9251)), entry.value.value, entry.value.frequency];
    }).toList());

    return GCWColumnedMultilineOutput(
        data: data,
        hasHeader: true,
        copyColumn: 0
    );
  }
}
