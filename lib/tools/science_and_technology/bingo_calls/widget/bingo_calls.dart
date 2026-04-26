import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/bingo_calls/logic/bingo_calls.dart';

class BingoCalls extends StatefulWidget {
  const BingoCalls({super.key});

  @override
  _BingoCallsState createState() => _BingoCallsState();
}

class _BingoCallsState extends State<BingoCalls> {

  BINGOCALLS_LANGUAGES _currentLanguage = BINGOCALLS_LANGUAGES.EN;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TMZ (6/2025): for the time beeing there exists only an english and german version
    // if there exists Bingo calls in other languages the default language should be set

    return Column(
      children: <Widget>[
        GCWDropDown<BINGOCALLS_LANGUAGES>(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: SplayTreeMap<BINGOCALLS_LANGUAGES, String>.from(
              BINGOCALLS_LANGUAGE_LIST,
                  (keys1, keys2) =>
                  i18n(context, BINGOCALLS_LANGUAGE_LIST[keys1]!).compareTo(i18n(context, BINGOCALLS_LANGUAGE_LIST[keys2]!)))
              .entries
              .map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    Map<String, BingoCall> bingoCalls = BINGO_CALLS[_currentLanguage]!;
    List<List<String>> output = [];

    bingoCalls.forEach((k, v) {
      output.add([k, v.title.join('\n'), v.description]);
    });

    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        data: output,
        flexValues: const [1, 2, 4],
        copyColumn: 1,
      ),
    );
  }

}
