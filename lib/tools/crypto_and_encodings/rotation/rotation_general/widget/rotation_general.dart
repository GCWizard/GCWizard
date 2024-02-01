import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/utils/math_utils.dart';

const String _apiSpecification = '''
{
  "/rotation_general" : {
    "alternative_paths": ["rotation", "rot", "rotx"],
    "get": {
      "summary": "Rotation Tool",
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
          "description": "Input data for rotate text",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "key",
          "description": "Shifts the input for n alphabet places",
          "schema": {
            "type": "integer",
            "default": 13
          }
        }
      ]
    }
  }
}
''';

class RotationGeneral extends GCWWebStatefulWidget {
  RotationGeneral({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _RotationGeneralState createState() => _RotationGeneralState();
}

class _RotationGeneralState extends State<RotationGeneral> {
  late TextEditingController _controller;

  String _currentInput = '';
  int _currentKey = 13;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      _currentInput = widget.getWebParameter('input') ?? _currentInput;

      var key = widget.getWebParameter('key');
      if (key != null) _currentKey = int.tryParse(key) ?? _currentKey;

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
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'common_key'),
          value: _currentKey,
          onChanged: (value) {
            setState(() {
              _currentKey = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    var reverseKey = modulo(26 - _currentKey, 26).toInt();

    return Column(
      children: [
        GCWDefaultOutput(
          child: Rotator().rotate(_currentInput, _currentKey),
        ),
        GCWOutput(
          title: i18n(context, 'rotation_general_reverse') +
              ' (' +
              i18n(context, 'common_key') +
              ': ' +
              reverseKey.toString() +
              ')',
          child: Rotator().rotate(_currentInput, reverseKey),
        ),
      ],
    );
  }
}
