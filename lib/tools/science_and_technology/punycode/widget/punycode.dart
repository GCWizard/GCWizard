import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/punycode/logic/punycode.dart';

class Punycode extends StatefulWidget {
  const Punycode({super.key});

  @override
  _PunycodeState createState() => _PunycodeState();
}

class _PunycodeState extends State<Punycode> {
  late TextEditingController _decodeController;
  late TextEditingController _encodeController;

  String _currentEncodeInput = '';
  String _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentEncodeInput);
    _encodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    _encodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
          ? GCWTextField(
              controller: _encodeController,
              onChanged: (text) {
                setState(() {
                  _currentEncodeInput = text;
                  _calculateOutput();
                });
              },
            )
          : GCWTextField(
              controller: _decodeController,
              onChanged: (text) {
                setState(() {
                  _currentDecodeInput = text;
                  _calculateOutput();
                });
              },
            ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _calculateOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    ({String output, String errorText}) output;
    if (_currentMode == GCWSwitchPosition.left) {
      output = encodeDomainPunycode(_currentEncodeInput);
    } else {
      output = decodeDomainPunycode(_currentDecodeInput);
    }
    return (output.errorText == '') ? output.output : i18n(context, "common_error") + ': ' + output.errorText;
  }
}