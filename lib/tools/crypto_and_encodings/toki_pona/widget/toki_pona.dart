import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/toki_pona/logic/toki_pona.dart';

class TokiPona extends StatefulWidget {
  const TokiPona({Key? key}) : super(key: key);

  @override
  _TokiPonaState createState() => _TokiPonaState();
}

class _TokiPonaState extends State<TokiPona> {
  late TextEditingController _inputEncodeController;
  late TextEditingController _inputDecodeController;

  String _currentEncodeInput = '';
  String _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentCryptMode = GCWSwitchPosition.left;
  GCWSwitchPosition _currentNumberMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _inputDecodeController = TextEditingController(text: _currentDecodeInput);
    _inputEncodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _inputDecodeController.dispose();
    _inputEncodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _inputEncodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : GCWTextField(
                controller: _inputDecodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
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
        _currentMode == GCWSwitchPosition.left
            ? GCWTwoOptionsSwitch(
                value: _currentCryptMode,
                leftValue: i18n(context, 'toki_pona_cryptmode_numbers'),
                rightValue: i18n(context, 'toki_pona_cryptmode_letters'),
                onChanged: (mode) {
                  setState(() {
                    _currentCryptMode = mode;
                  });
                },
              )
            : Container(),
        _currentMode == GCWSwitchPosition.left &&
                _currentCryptMode == GCWSwitchPosition.left
            ? GCWTwoOptionsSwitch(
                value: _currentNumberMode,
                leftValue: i18n(context, 'toki_pona_cryptnumbermode_digits'),
                rightValue: i18n(context, 'toki_pona_cryptnumbermode_numbers'),
                onChanged: (mode) {
                  setState(() {
                    _currentNumberMode = mode;
                  });
                },
              )
            : Container(),
        _buildOutput()
      ],
    );
  }

  TokiPonaMode _tokiPonaMode() {
    return _currentCryptMode == GCWSwitchPosition.right
        ? TokiPonaMode.LETTERS
        : _currentNumberMode == GCWSwitchPosition.right
            ? TokiPonaMode.NUMBERS
            : TokiPonaMode.DIGITS;
  }

  Widget _buildOutput() {
    String outputs;
    if (_currentMode == GCWSwitchPosition.left) {
      outputs = encodeTokiPona(_currentEncodeInput, _tokiPonaMode());
    } else {
      outputs = decodeTokiPona(_currentDecodeInput);
    }

    return GCWDefaultOutput(child: outputs);
  }
}
