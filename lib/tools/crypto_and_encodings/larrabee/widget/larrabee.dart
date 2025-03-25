import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/larrabee/logic/larrabee.dart';

const String _apiSpecification = '''
{
  "/larrabee" : {
    "get": {
      "summary": "Larrabee Tool",
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
          "required": true,
          "description": "Larrabee key",
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

class Larrabee extends GCWWebStatefulWidget {
  Larrabee({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _LarrabeeState createState() => _LarrabeeState();
}

class _LarrabeeState extends State<Larrabee> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'encode') {
        _currentMode = GCWSwitchPosition.left;
      }

      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      _currentKey = widget.getWebParameter('key') ?? _currentKey;

      widget.webParameter = null;
    }

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
          hintText: i18n(context, 'common_key'),
          controller: _keyController,
          onChanged: (text) {
            setState(() {
              _currentKey = text;
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
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';

    if (_currentMode == GCWSwitchPosition.left) {
      output = encryptLarrabee(
        _currentInput,
        _currentKey
      );
    } else {
      output = decryptLarrabee(
        _currentInput,
        _currentKey
      );
    }

    return GCWDefaultOutput(child: output);
  }
}
