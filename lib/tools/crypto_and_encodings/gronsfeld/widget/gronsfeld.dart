import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/logic/gronsfeld.dart';

class Gronsfeld extends StatefulWidget {
  const Gronsfeld({Key? key}) : super(key: key);

  @override
  _GronsfeldState createState() => _GronsfeldState();
}

class _GronsfeldState extends State<Gronsfeld> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';
  int _currentAValue = 0;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  bool _currentAutokey = false;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _keyController = TextEditingController(text: _currentKey);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWIntegerTextField(
          hintText: i18n(context, 'common_key'),
          controller: _keyController,
          onChanged: (value) {
            setState(() {
              _currentKey = value.text;
            });
          },
        ),
        GCWIntegerSpinner(
          title: 'A',
          value: _currentAValue,
          onChanged: (value) {
            setState(() {
              _currentAValue = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'vigenere_autokey'),
          value: _currentAutokey,
          onChanged: (value) {
            setState(() {
              _currentAutokey = value;
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
    var output = '';

    if (_currentMode == GCWSwitchPosition.left) {
      output = encryptGronsfeld(_currentInput, _currentKey, _currentAutokey, aValue: _currentAValue);
    } else {
      output = decryptGronsfeld(_currentInput, _currentKey, _currentAutokey, aValue: _currentAValue);
    }

    return GCWDefaultOutput(child: output);
  }
}
