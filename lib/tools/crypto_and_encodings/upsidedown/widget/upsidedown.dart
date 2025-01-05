import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/upsidedown/logic/upsidedown.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

class UpsideDown extends StatefulWidget {
  const UpsideDown({Key? key}) : super(key: key);

  @override
  UpsideDownState createState() => UpsideDownState();
}

class UpsideDownState extends State<UpsideDown> {
  late TextEditingController _inputControllerDecode;
  late TextEditingController _inputControllerEncode;

  String _currentInputEncode = '';
  String _currentInputDecode = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputControllerDecode = TextEditingController(text: _currentInputDecode);
    _inputControllerEncode = TextEditingController(text: _currentInputEncode);
  }

  @override
  void dispose() {
    _inputControllerDecode.dispose();
    _inputControllerEncode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
         _currentMode == GCWSwitchPosition.right
            ? GCWTextField(
                controller: _inputControllerDecode,
                onChanged: (text) {
                  setState(() {
                    _currentInputDecode = text;
                  });
                },
              style: const TextStyle(fontFamily: 'Noto'),
              )
            : GCWTextField(
                controller: _inputControllerEncode,
                onChanged: (text) {
                  setState(() {
                    _currentInputEncode = text;
                  });
                },
                style: const TextStyle(fontFamily: 'Noto'),
              ),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    String result = '';
    if (_currentMode == GCWSwitchPosition.right) {
      // decode
      result = decodeUpsideDownText(_currentInputDecode);
    } else {
      // encode
      result = encodeUpsideDownText(_currentInputEncode);
    }
    for (int i = 32; i < 65; i++){

    }
    return Column(
      children: [
        GCWTextDivider(
            text: i18n(context, 'common_output')),
        GCWOutputText(
          text: result,
          style: const TextStyle(fontFamily: 'Noto'),
        )

    ],
    );
  }
}
