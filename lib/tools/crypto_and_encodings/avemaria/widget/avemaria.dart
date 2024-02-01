import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/avemaria/logic/avemaria.dart';

class AveMaria extends StatefulWidget {
  const AveMaria({Key? key}) : super(key: key);

  @override
  AveMariaState createState() => AveMariaState();
}

class AveMariaState extends State<AveMaria> {
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                    _calculateOutput();
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ],
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
    if (_currentMode == GCWSwitchPosition.left) {
      return encodeAveMaria(_currentEncodeInput);
    } else {
      return decodeAveMaria(_currentDecodeInput);
    }
  }
}
