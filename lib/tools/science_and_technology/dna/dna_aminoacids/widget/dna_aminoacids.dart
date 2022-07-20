import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/logic/dna.dart';
import 'package:gc_wizard/tools/common/base/gcw_text/widget/gcw_text.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_text_divider/widget/gcw_text_divider.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class DNAAminoAcids extends StatefulWidget {
  @override
  DNAAminoAcidsState createState() => DNAAminoAcidsState();
}

class DNAAminoAcidsState extends State<DNAAminoAcids> {
  var _currentMode = GCWSwitchPosition.right;
  var _currentInput = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (value) {
            setState(() {
              _currentInput = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return GCWDefaultOutput(child: encodeRNASymbolLong(_currentInput));
    } else {
      var output = decodeRNASymbolLong(_currentInput);
      var includesM = output.indexOf('M') > -1;

      return Column(
        children: <Widget>[
          GCWDefaultOutput(child: output),
          includesM ? GCWTextDivider(text: i18n(context, 'common_note')) : Container(),
          includesM ? GCWText(text: i18n(context, 'dna_aminoacids_notem')) : Container()
        ],
      );
    }
  }
}
