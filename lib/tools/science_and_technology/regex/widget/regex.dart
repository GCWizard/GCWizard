import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/regex/logic/regex.dart';

class RegEx extends StatefulWidget {
  const RegEx({super.key});

  @override
  _RegExState createState() => _RegExState();
}

class _RegExState extends State<RegEx> {
  late TextEditingController _inputController;
  late TextEditingController _patternController;

  String _currentInput = '';
  String _currentPattern = '';
  regexOutput _calculatedPattern = regexOutput(true, [[]]);

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _patternController = TextEditingController(text: _currentPattern);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _patternController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          title: 'Input',
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextField(
          title: 'Pattern',
          controller: _patternController,
          onChanged: (text) {
            setState(() {
              _currentPattern = text;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculatedPattern =
                  getRegExPattern(_currentInput, _currentPattern);
            });
          },
        ),
        GCWDefaultOutput(
            child: GCWColumnedMultilineOutput(
          data: _calculatedPattern.ok
              ? _calculatedPattern.result
              : [
                  [i18n(context, 'regex_error')],
                  _calculatedPattern.result
                ],
        ))
      ],
    );
  }
}
