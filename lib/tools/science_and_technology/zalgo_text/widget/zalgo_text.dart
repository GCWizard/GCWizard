import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/zalgo_text/logic/zalgo_text.dart';

class ZalgoText extends StatefulWidget {
  const ZalgoText({super.key});

  @override
  _ZalgoTextState createState() => _ZalgoTextState();
}

class _ZalgoTextState extends State<ZalgoText> {
  late TextEditingController _inputController;

  String _currentInput = '';
  var _intensity = 50;

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
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'zalgo_text_intensity'),
          min: 1,
          max: 200,
          value: _intensity,
          onChanged: (value) {
            setState(() {
              _intensity = value;
            });
          },
        ),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    var result = zalgo_text(_currentInput, _intensity);

    return GCWDefaultOutput(
        child: SizedBox(
            height: 150,
            child: GCWOutputText(text: result),
        ),
    );
  }
}
