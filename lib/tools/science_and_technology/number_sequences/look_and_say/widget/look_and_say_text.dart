import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/look_and_say/logic/look_and_say.dart';

class LookAndSayText extends StatefulWidget {
  const LookAndSayText({super.key});

  @override
  _LookAndSayTextState createState() => _LookAndSayTextState();
}

class _LookAndSayTextState extends State<LookAndSayText> {
  late TextEditingController _inputController;

  var _currentInput = '';

  var _count = 1;
  Widget _currentOutput = const GCWDefaultOutput();

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
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
              _buildOutput();
            });
          }),
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: 30,
          value: _count,
          onChanged: (value) {
            setState(() {
              _count = value;
              _buildOutput();
            });
          }),
        _currentOutput,
      ],
    );
  }

  void _buildOutput() {
    var look_and_say = _currentInput;
    List<List<String>> columnData = [];

    for (var i = 0; i < _count; i++) {
      look_and_say = lookAndSay(look_and_say);
      columnData.add([look_and_say]);
    }

    _currentOutput = GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: columnData));
  }
}