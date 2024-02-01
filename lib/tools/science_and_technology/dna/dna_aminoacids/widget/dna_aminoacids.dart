import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/logic/dna.dart';

class DNAAminoAcids extends StatefulWidget {
  const DNAAminoAcids({Key? key}) : super(key: key);

  @override
  _DNAAminoAcidsState createState() => _DNAAminoAcidsState();
}

class _DNAAminoAcidsState extends State<DNAAminoAcids> {
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

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return GCWDefaultOutput(child: encodeRNASymbolLong(_currentInput));
    } else {
      var output = decodeRNASymbolLong(_currentInput);
      var includesM = output.contains('M');

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
