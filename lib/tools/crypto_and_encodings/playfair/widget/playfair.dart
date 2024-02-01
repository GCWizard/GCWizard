import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/logic/playfair.dart';

const String _apiSpecification = '''
{
  "/playfair" : {
    "get": {
      "summary": "Playfair Tool",
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
          "description": "Playfair key",
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

class Playfair extends GCWWebStatefulWidget {
  Playfair({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _PlayfairState createState() => _PlayfairState();
}

class _PlayfairState extends State<Playfair> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  AlphabetModificationMode _currentModificationMode = AlphabetModificationMode.J_TO_I;

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
        GCWAlphabetModificationDropDown(
          value: _currentModificationMode,
          allowedModifications: const [
            AlphabetModificationMode.J_TO_I,
            AlphabetModificationMode.W_TO_VV,
            AlphabetModificationMode.C_TO_K
          ],
          onChanged: (value) {
            setState(() {
              _currentModificationMode = value;
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
      output = encryptPlayfair(_currentInput, _currentKey, mode: _currentModificationMode);
    } else {
      output = decryptPlayfair(_currentInput, _currentKey, mode: _currentModificationMode);
    }

    return GCWDefaultOutput(child: output);
  }
}
