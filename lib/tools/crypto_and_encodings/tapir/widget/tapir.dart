import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/logic/tapir.dart';

const String _apiSpecification = '''
{
  "/tapir" : {
    "get": {
      "summary": "Tapir Tool",
      "responses": {
        "204": {
          "description": "Tool loaded. No response data."
        }
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "key",
          "description": "OneTimePad key",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "mode",
          "description": "Defines encoding or decoding mode",
          "schema": {
            "type": "string",
            "enum": [
              "encode",
              "decode"
            ],
            "default": "decode"
          }
        }
      ]
    }
  }
}
''';

class Tapir extends GCWWebStatefulWidget {
  Tapir({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _TapirState createState() => _TapirState();
}

class _TapirState extends State<Tapir> {
  late TextEditingController _inputController;
  late TextEditingController _otpController;

  var _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  var _currentOneTimePadMode = false;

  var _currentOneTimePad = '';

  final _maskFormatter = GCWMaskTextInputFormatter(mask: '##### ' * 100000 + '#####', filter: {"#": RegExp(r'\d')});

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'encode') {
        _currentMode = GCWSwitchPosition.left;
      }

      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      var _otpKey = widget.getWebParameter('key');
      if (_otpKey != null && _otpKey.isNotEmpty) {
        _currentOneTimePad = _otpKey;
        _currentOneTimePadMode = true;
      }
      widget.webParameter = null;
    }

    _inputController = TextEditingController(text: _currentInput);
    _otpController = TextEditingController(text: _currentOneTimePad);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _otpController.dispose();

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
        GCWOnOffSwitch(
          title: i18n(context, 'tapir_onetimepad'),
          value: _currentOneTimePadMode,
          onChanged: (value) {
            setState(() {
              _currentOneTimePadMode = value;
            });
          },
        ),
        _currentOneTimePadMode
            ? GCWTextField(
                controller: _otpController,
                inputFormatters: [_maskFormatter],
                hintText: '12345 67890 12...',
                onChanged: (value) {
                  setState(() {
                    _currentOneTimePad = value;
                  });
                },
              )
            : Container(),
        GCWDefaultOutput(child: _buildOutput()),
      ],
    );
  }

  String _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return encryptTapir(_currentInput, _currentOneTimePad);
    } else {
      return decryptTapir(_currentInput, _currentOneTimePad);
    }
  }
}
