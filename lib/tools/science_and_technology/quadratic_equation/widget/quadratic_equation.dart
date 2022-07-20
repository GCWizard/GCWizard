import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/quadratic_equation/logic/quadratic_equation.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/tools/common/base/gcw_output_text/widget/gcw_output_text.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';
import 'package:gc_wizard/tools/utils/textinputformatter/double_textinputformatter/widget/double_textinputformatter.dart';

class QuadraticEquation extends StatefulWidget {
  @override
  QuadraticEquationState createState() => QuadraticEquationState();
}

class QuadraticEquationState extends State<QuadraticEquation> {
  var _currentA = '0.0';
  var _currentB = '0.0';
  var _currentC = '0.0';
  var _aController;
  var _bController;
  var _cController;

  @override
  void initState() {
    super.initState();
    _aController = TextEditingController(text: _currentA);
    _bController = TextEditingController(text: _currentB);
    _cController = TextEditingController(text: _currentC);
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWOutputText(
          text: i18n(context, 'quadratic_equation_explanation') + '\n',
          suppressCopyButton: true,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: GCWTextField(
              controller: _aController,
              inputFormatters: [DoubleTextInputFormatter(min: -1.0 * pow(2, 63), max: 1.0 * pow(2, 63))],
              hintText: i18n(context, 'quadratic_equation_hint_a'),
              onChanged: (value) {
                setState(() {
                  _currentA = value;
                });
              },
            )),
            Container(width: DOUBLE_DEFAULT_MARGIN),
            Expanded(
                child: GCWTextField(
              controller: _bController,
              inputFormatters: [DoubleTextInputFormatter(min: -1.0 * pow(2, 63), max: 1.0 * pow(2, 63))],
              hintText: i18n(context, 'quadratic_equation_hint_b'),
              onChanged: (value) {
                setState(() {
                  _currentB = value;
                });
              },
            )),
            Container(width: DOUBLE_DEFAULT_MARGIN),
            Expanded(
                child: GCWTextField(
              controller: _cController,
              inputFormatters: [DoubleTextInputFormatter(min: -1.0 * pow(2, 63), max: 1.0 * pow(2, 63))],
              hintText: i18n(context, 'quadratic_equation_hint_c'),
              onChanged: (value) {
                setState(() {
                  _currentC = value;
                });
              },
            ))
          ],
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    Map<String, String> result = new Map<String, String>();
    result = solveQuadraticEquation(_currentA, _currentB, _currentC);
    if (result[''] == null)
      return GCWDefaultOutput(
          child: Column(
        children: columnedMultiLineOutput(
            context,
            result.entries.map((entry) {
              if (entry.key.startsWith('quad'))
                return [i18n(context, entry.key), i18n(context, entry.value)];
              else
                return [entry.key, entry.value];
            }).toList(),
            flexValues: [1, 1]),
      ));
    else
      return Container();
  }
}
