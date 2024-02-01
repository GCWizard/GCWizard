import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kamasutra/logic/kamasutra.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class Kamasutra extends StatefulWidget {
  const Kamasutra({Key? key}) : super(key: key);

  @override
  _KamasutraState createState() => _KamasutraState();
}

class _KamasutraState extends State<Kamasutra> {
  var _currentInput = '';
  var _currentAlphabet = '';
  var _currentAlphabetMode = GCWSwitchPosition.left;

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
        GCWTwoOptionsSwitch(
          title: i18n(context, 'common_alphabet'),
          leftValue: 'A-Z',
          rightValue: i18n(context, 'common_custom'),
          value: _currentAlphabetMode,
          onChanged: (value) {
            setState(() {
              _currentAlphabetMode = value;
            });
          },
        ),
        _currentAlphabetMode == GCWSwitchPosition.right
            ? GCWTextField(onChanged: (text) {
                setState(() {
                  _currentAlphabet = text;
                });
              })
            : Container(),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    var alphabet = _currentAlphabetMode == GCWSwitchPosition.left ? alphabet_AZString : _currentAlphabet;
    return encryptKamasutra(_currentInput, alphabet);
  }
}
