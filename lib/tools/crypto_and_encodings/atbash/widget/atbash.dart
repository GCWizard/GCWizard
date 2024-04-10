import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/logic/atbash.dart';

const String _apiSpecification = '''
{
  "/atbash" : {
    "alternative_paths": ["atbasch"],
    "get": {
      "summary": "Atbash Tool",
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
          "description": "Input data for Atbash text",
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  }
}
''';

class Atbash extends GCWWebStatefulWidget {
  Atbash({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _AtbashState createState() => _AtbashState();
}

class _AtbashState extends State<Atbash> {
  late TextEditingController _controller;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  String _currentInput = '';

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      widget.webParameter = null;
    }

    _controller = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'atbash_mode_original'),
          rightValue: i18n(context, 'atbash_mode_modern'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWDefaultOutput(child: atbash(_currentInput, historicHebrew: (_currentMode == GCWSwitchPosition.left)))
      ],
    );
  }
}
