import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';

const String _apiSpecification = '''
{
  "/romannumbers" : {
    "alternative_paths": ["roman"],
    "get": {
      "summary": "Roman Numbers Tool",
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
          "description": "Input data for Roman Numbers text; 'schema/type' is 'string' if 'parameters/mode/' is 'decode' and 'integer' otherwise.",
          "schema": {}
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

class RomanNumbers extends GCWWebStatefulWidget {
  RomanNumbers({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _RomanNumbersState createState() => _RomanNumbersState();
}

class _RomanNumbersState extends State<RomanNumbers> {
  late TextEditingController _decodeController;

  var _currentEncodeInput = 1;
  var _currentDecodeInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'encode') {
        _currentMode = GCWSwitchPosition.left;

        var _encodeInput = widget.getWebParameter('input');
        if (_encodeInput != null) _currentEncodeInput = int.tryParse(_encodeInput) ?? _currentEncodeInput;
      } else {
        _currentDecodeInput = widget.getWebParameter('input') ?? _currentDecodeInput;
      }

      widget.webParameter = null;
    }

    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWIntegerSpinner(
                min: 1,
                max: 100000,
                value: _currentEncodeInput,
                onChanged: (value) {
                  setState(() {
                    _currentEncodeInput = value;
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'romannumbers_numberstoroman'),
          rightValue: i18n(context, 'romannumbers_romantonumbers'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    List<String> output;

    if (_currentMode == GCWSwitchPosition.left) {
      output = [
        encodeRomanNumbers(_currentEncodeInput, type: RomanNumberType.USE_SUBTRACTION_RULE),
        encodeRomanNumbers(_currentEncodeInput, type: RomanNumberType.ONLY_ADDITION)
      ];
    } else {
      output = [
        _currentDecodeInput
            .split(RegExp(r'\s+'))
            .map((number) => decodeRomanNumbers(number, type: RomanNumberType.USE_SUBTRACTION_RULE))
            .where((number) => number != null)
            .join(' '),
        _currentDecodeInput
            .split(RegExp(r'\s+'))
            .map((number) => decodeRomanNumbers(number, type: RomanNumberType.ONLY_ADDITION))
            .where((number) => number != null)
            .join(' ')
      ];
    }

    return GCWMultipleOutput(children: [
      output[0],
      GCWOutput(
        child: output[1],
        title: i18n(context, 'romannumbers_withoutsubtractionrule'),
      )
    ]);
  }
}
