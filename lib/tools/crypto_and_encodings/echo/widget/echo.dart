import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/echo/logic/echo.dart';

class Echo extends StatefulWidget {
  const Echo({super.key});

  @override
  _EchoState createState() => _EchoState();
}

class _EchoState extends State<Echo> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  String _currentInput = '';
  String _currentKey = '';

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
        GCWTextField(
          controller: _keyController,
          hintText: i18n(context, 'common_key'),
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (mode) {
            setState(() {
              _currentMode = mode;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    EchoOutput output;
    String outputText;

    if (_currentMode == GCWSwitchPosition.right) {
      output = decryptEcho(_currentInput, _currentKey);
    } else {
      output = encryptEcho(_currentInput, _currentKey);
    }

    switch (output.state) {
      case EchoState.OK: outputText = output.output; break;
      case EchoState.ERROR_UNKNOWN_CHAR: outputText = i18n(context, 'echo_error_unknownchar'); break;
      case EchoState.ERROR_EVEN_KEY: outputText = i18n(context, 'echo_error_evenkey'); break;
      case EchoState.ERROR_INPUT_TOO_SHORT: outputText = i18n(context, 'echo_error_inputtooshort'); break;
    }

    return GCWDefaultOutput(child: outputText);
  }
}
