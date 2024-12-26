import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/judoon//logic/judoon.dart';

class Judoon extends StatefulWidget {
  const Judoon({super.key});

  @override
  _JudoonState createState() => _JudoonState();
}

class _JudoonState extends State<Judoon> {
  late TextEditingController _inputController;

  var _currentInput = '';
  var _currentMode = GCWSwitchPosition.right;

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
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    return _currentMode == GCWSwitchPosition.left
        ? encryptJudoon(_currentInput)
        : decryptJudoon(_currentInput);
  }
}
