import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/zalgo_text/logic/zalgo_text.dart';

class ZalgoText extends StatefulWidget {
  const ZalgoText({super.key});

  @override
  _ZalgoTextState createState() => _ZalgoTextState();
}

class _ZalgoTextState extends State<ZalgoText> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  var _intensity = 50;

  @override
  void initState() {
    super.initState();

    _encodeController = TextEditingController(text: _currentEncodeInput);
    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();
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
                  });
                })
            : Container(
                alignment: Alignment.center,
                height: 150,
                child: GCWTextField(
                  controller: _decodeController,
                  onChanged: (text) {
                    setState(() {
                      _currentDecodeInput = text;
                    });
                })),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWIntegerSpinner(
                title: i18n(context, 'zalgo_text_intensity'),
                min: 1,
                max: 200,
                value: _intensity,
                onChanged: (value) {
                  setState(() {
                    _intensity = value;
                  });
                })
            : Container(),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
     return GCWDefaultOutput(
        child: SizedBox(
          height: 150,
          child: GCWOutputText(text: encodeZalgoText(_currentEncodeInput, _intensity)),
        ),
      );
    } else {
      return GCWDefaultOutput(child: decodeZalgoText(_currentDecodeInput));
    }
  }
}
