import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_code_textfield.dart';
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
  late TextEditingController _codeControllerHighlighted;

  String _currentInput = '';
  String _currentPattern = '';
  List<List<String>> _calculatedPattern = [];

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _patternController = TextEditingController(text: _currentPattern);
    _codeControllerHighlighted = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _inputController.dispose();
    _patternController.dispose();
    _codeControllerHighlighted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _codeControllerHighlighted.text = _currentInput;

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
          title: i18n(context, 'regex_pattern'),
          controller: _patternController,
          onChanged: (text) {
            setState(() {
              _currentPattern = text;
            });
          },
        ),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    try {
      _calculatedPattern = evaluateRegExPattern(_currentInput, _currentPattern);
      return Column(children: [
        GCWDefaultOutput(
            child: Column(
          children: [
            GCWCodeTextField(
              wrap: true,
              controller: _codeControllerHighlighted,
              patternMap: _higlightMap(),
              lineNumbers: false,
            ),
            GCWExpandableTextDivider(
                suppressTopSpace: false,
                expanded: false,
                text: i18n(context, 'common_details'),
                child: GCWColumnedMultilineOutput(
                  data: _calculatedPattern,
                ))
          ],
        )),
      ]);
    } on FormatException catch (e) {
      return GCWDefaultOutput(
          child: GCWColumnedMultilineOutput(
        data: [
          [i18n(context, 'regex_error')],
          [e.message],
        ],
      ));
    } finally {}
  }

  Map<String, TextStyle> _higlightMap() {
    Map<String, TextStyle> result = {};
    result[_currentPattern] = const TextStyle(color: Colors.red);

    return result;
  }
}
