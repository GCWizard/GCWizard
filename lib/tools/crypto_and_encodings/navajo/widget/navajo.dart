import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/logic/navajo.dart';

class Navajo extends StatefulWidget {
  @override
  NavajoState createState() => NavajoState();
}

class NavajoState extends State<Navajo> {
  var _decodeController;
  var _encodeController;

  String _currentEncodeInput = '';
  String _currentDecodeInput = '';
  String _output = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentSource = GCWSwitchPosition.right;

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
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z- \.]')),
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
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z- \.]')),
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
        GCWTwoOptionsSwitch(
          value: _currentSource,
          title: i18n(context, 'navajo_source'),
          leftValue: i18n(context, 'navajo_source_dictionary'),
          rightValue: i18n(context, 'navajo_source_alphabet'),
          onChanged: (value) {
            setState(() {
              _currentSource = value;
              _calculateOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _output)
      ],
    );
  }

  _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left)
      _output = encodeNavajo(_currentEncodeInput, (_currentSource == GCWSwitchPosition.right));
    else
      _output = decodeNavajo(_currentDecodeInput, (_currentSource == GCWSwitchPosition.right));
  }
}
