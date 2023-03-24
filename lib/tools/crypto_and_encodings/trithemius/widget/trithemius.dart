import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/logic/trithemius.dart';

class Trithemius extends StatefulWidget {
  const Trithemius({Key? key}) : super(key: key);

  @override
  TrithemiusState createState() => TrithemiusState();
}

class TrithemiusState extends State<Trithemius> {
  late TextEditingController _inputController;

  String _currentInput = '';
  int _currentAValue = 0;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
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
        GCWIntegerSpinner(
          title: 'A',
          value: _currentAValue,
          onChanged: (value) {
            setState(() {
              _currentAValue = value;
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
      output = encryptTrithemius(_currentInput, aValue: _currentAValue);
    } else {
      output = decryptTrithemius(_currentInput, aValue: _currentAValue);
    }

    return GCWDefaultOutput(child: output);
  }
}
