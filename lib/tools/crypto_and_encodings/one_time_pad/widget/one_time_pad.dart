import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/logic/one_time_pad.dart';

const String _apiSpecification = '''
{
  "/onetimepad" : {
    "alternative_paths": ["otp", "one_time_pad"],
    "get": {
      "summary": "OneTimePad Tool",
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
          "description": "Input data for OneTimePad text",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "key",
          "required": true,
          "description": "OTP key",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "a",
          "required": true,
          "description": "Value for letter A",
          "schema": {
            "type": "integer"
          },
          "default": 0
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

class OneTimePad extends GCWWebStatefulWidget {
  OneTimePad({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _OneTimePadState createState() => _OneTimePadState();
}

class _OneTimePadState extends State<OneTimePad> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';

  var _currentOffset = 0;

  var _currentMode = GCWSwitchPosition.right;

  // two same maskTextInputFormatters are necessary because using the same formatter creates conflicts
  // (entered value in one input will be used for the other one)
  final _mask = '#' * 10000;
  final _filter = {"#": RegExp(r'[A-Za-z]')};
  late GCWMaskTextInputFormatter _inputMaskInputFormatter;
  late GCWMaskTextInputFormatter _keyMaskInputFormatter;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'encode') {
        _currentMode = GCWSwitchPosition.left;
      }

      _currentKey = widget.getWebParameter('key') ?? _currentKey;

      var a = widget.getWebParameter('a');
      if (a != null) {
        var aInt = int.tryParse(a);
        if (aInt != null) _currentOffset = aInt - 1;
      }

      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      widget.webParameter = null;
    }

    _inputMaskInputFormatter = GCWMaskTextInputFormatter(mask: _mask, filter: _filter);
    _keyMaskInputFormatter = GCWMaskTextInputFormatter(mask: _mask, filter: _filter);

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
          hintText: i18n(context, 'onetimepad_input'),
          inputFormatters: [_inputMaskInputFormatter],
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextField(
          hintText: i18n(context, 'onetimepad_key'),
          inputFormatters: [_keyMaskInputFormatter],
          controller: _keyController,
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'onetimepad_keyoffset'),
          value: _currentOffset + 1,
          onChanged: (value) {
            setState(() {
              _currentOffset = value - 1;
            });
          },
        ),
        GCWTwoOptionsSwitch(
            value: _currentMode,
            onChanged: (value) {
              setState(() {
                _currentMode = value;
              });
            }),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    return _currentMode == GCWSwitchPosition.left
        ? encryptOneTimePad(_currentInput, _currentKey, keyOffset: _currentOffset)
        : decryptOneTimePad(_currentInput, _currentKey, keyOffset: _currentOffset);
  }
}
