import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/complex_numbers.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/double_textinputformatter.dart';

class ComplexNumbers extends StatefulWidget {
  @override
  ComplexNumbersState createState() => ComplexNumbersState();
}

class ComplexNumbersState extends State<ComplexNumbers> {
  var _currentA = '';
  var _currentB = '';
  var _currentRadius = '';
  var _currentAngle = '';
  var _aController;
  var _bController;
  var _radiusController;
  var _angleController;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _aController = TextEditingController(text: _currentA);
    _bController = TextEditingController(text: _currentB);
    _radiusController = TextEditingController(text: _currentRadius);
    _angleController = TextEditingController(text: _currentAngle);
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _radiusController.dispose();
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.right
            ? Row(
                children: <Widget>[
                  Expanded(
                      child: GCWTextField(
                    controller: _aController,
                    inputFormatters: [DoubleTextInputFormatter(min: -1.0 * pow(2, 63), max: 1.0 * pow(2, 63))],
                    hintText: i18n(context, 'complex_numbers_hint_a'),
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
                    hintText: i18n(context, 'complex_numbers_hint_b'),
                    onChanged: (value) {
                      setState(() {
                        _currentB = value;
                      });
                    },
                  ))
                ],
              )
            : Row(
                children: <Widget>[
                  Expanded(
                      child: GCWTextField(
                    controller: _radiusController,
                    inputFormatters: [DoubleTextInputFormatter(min: -1.0 * pow(2, 63), max: 1.0 * pow(2, 63))],
                    hintText: i18n(context, 'complex_numbers_hint_radius'),
                    onChanged: (value) {
                      setState(() {
                        _currentRadius = value;
                      });
                    },
                  )),
                  Container(width: DOUBLE_DEFAULT_MARGIN),
                  Expanded(
                      child: GCWTextField(
                    controller: _angleController,
                    inputFormatters: [DoubleTextInputFormatter(min: -1.0 * pow(2, 63), max: 1.0 * pow(2, 63))],
                    hintText: i18n(context, 'complex_numbers_hint_angle'),
                    onChanged: (value) {
                      setState(() {
                        _currentAngle = value;
                      });
                    },
                  )),
                ],
              ),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'complex_numbers_convert'),
          leftValue: i18n(context, 'complex_numbers_cartesian'),
          rightValue: i18n(context, 'complex_numbers_polar'),
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
    Map<String, String> coordinates = new Map<String, String>();
    if (_currentMode == GCWSwitchPosition.right) {
      coordinates = CartesianToPolar(_currentA, _currentB);
    } else {
      coordinates = PolarToCartesian(_currentRadius, _currentAngle);
    }

    return GCWDefaultOutput(
        child: GCWColumnedMultilineOutput(
            data: coordinates.entries.map((entry) {
                    if (entry.key != '') return [i18n(context, entry.key), entry.value];
                  }).toList(),
            flexValues: [1, 1]
            ),
    );
  }
}
