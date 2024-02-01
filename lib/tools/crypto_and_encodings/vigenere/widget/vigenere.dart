import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';

const String _apiSpecification = '''
{
  "/vigenere" : {
    "get": {
      "summary": "Vigenère Tool",
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
          "description": "Vigenère key",
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

class Vigenere extends GCWWebStatefulWidget {
  Vigenere({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _VigenereState createState() => _VigenereState();
}

class _VigenereState extends State<Vigenere> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';
  int _currentAValue = 0;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  bool _currentAutokey = false;
  bool _currentNonLetters = false;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'encode') {
        _currentMode = GCWSwitchPosition.left;
      }

      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      _currentKey = widget.getWebParameter('key') ?? _currentKey;

      var a = widget.getWebParameter('a');
      if (a != null) _currentAValue = int.tryParse(a) ?? _currentAValue;

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
        GCWIntegerSpinner(
          title: 'A',
          value: _currentAValue,
          onChanged: (value) {
            setState(() {
              _currentAValue = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'vigenere_autokey'),
          value: _currentAutokey,
          onChanged: (value) {
            setState(() {
              _currentAutokey = value;
            });
          },
        ),
        _currentAutokey == false
            ? GCWOnOffSwitch(
                title: i18n(context, 'vigenere_ignorenonletters'),
                value: _currentNonLetters,
                onChanged: (value) {
                  setState(() {
                    _currentNonLetters = value;
                  });
                },
              )
            : Container(),
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
      output = encryptVigenere(
        _currentInput,
        _currentKey,
        _currentAutokey,
        aValue: _currentAValue,
        ignoreNonLetters: _currentAutokey ? true : _currentNonLetters,
      );
    } else {
      output = decryptVigenere(
        _currentInput,
        _currentKey,
        _currentAutokey,
        aValue: _currentAValue,
        ignoreNonLetters: _currentAutokey ? true : _currentNonLetters,
      );
    }

    return GCWDefaultOutput(child: output);
  }
}
