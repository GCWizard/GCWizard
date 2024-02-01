import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/solitaire/logic/solitaire.dart';

class Solitaire extends StatefulWidget {
  const Solitaire({Key? key}) : super(key: key);

  @override
  _SolitaireState createState() => _SolitaireState();
}

class _SolitaireState extends State<Solitaire> {
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
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    SolitaireOutput? _currentOutput;
    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptSolitaire(_currentInput, _currentKey);
    } else {
      _currentOutput = decryptSolitaire(_currentInput, _currentKey);
    }

    if (_currentOutput == null || _currentOutput.output.isEmpty) return const GCWDefaultOutput();

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
