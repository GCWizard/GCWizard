import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/logic/navajo.dart';

class NavajoList extends StatefulWidget {
  const NavajoList({Key? key}) : super(key: key);

  @override
  NavajoListState createState() => NavajoListState();
}

class NavajoListState extends State<NavajoList> {
  bool _currentDictionary = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown<bool>(
          value: _currentDictionary,
          onChanged: (value) {
            setState(() {
              _currentDictionary = value;
            });
          },
          items: [
            GCWDropDownMenuItem(
              value: false,
              child: i18n(context, 'navajo_source_alphabet'),
            ),
            GCWDropDownMenuItem(
              value: true,
              child: i18n(context, 'navajo_source_dictionary'),
            )
          ],
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var navajoOverview = _currentDictionary ? navajoDictionary() : navajoAlphabet();
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        data: navajoOverview.map((entry) {
          return [entry.key, entry.value];
        }).toList(),
        flexValues: const [2, 3],
      ),
    );
  }
}
