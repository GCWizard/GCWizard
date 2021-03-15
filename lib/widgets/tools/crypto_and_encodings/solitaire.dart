import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/solitaire.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_multiple_output.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';

class Solitaire extends StatefulWidget {
  @override
  SolitaireState createState() => SolitaireState();
}

class SolitaireState extends State<Solitaire> {
  String _currentInput = '';
  String _currentKey = '';

  var _currentMode = GCWSwitchPosition.right;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'common_key')),
        GCWTextField(
          hintText: i18n(context, 'common_key'),
          onChanged: (text) {
            setState(() {
              _currentKey = text;
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
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput == null || _currentInput.length == 0) return GCWDefaultOutput();

    var _currentOutput;
    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptSolitaire(_currentInput, _currentKey);
    } else {
      _currentOutput = decryptSolitaire(_currentInput, _currentKey);
    }

    if (_currentOutput == null || _currentOutput.output.length == 0) return GCWDefaultOutput();

    return GCWMultipleOutput(
      children: [
        _currentOutput.output,
        GCWOutput(
          title: i18n(context, 'solitaire_keystream'),
          child: GCWOutputText(
            text: _currentOutput.keyStream,
          ),
        ),
        GCWOutput(
          title: i18n(context, 'solitaire_resultdeck'),
          child: GCWOutputText(
            text: _currentOutput.resultDeck,
          ),
        )
      ],
    );
  }
}
