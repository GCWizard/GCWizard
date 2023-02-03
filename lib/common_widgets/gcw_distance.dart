import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:prefs/prefs.dart';

class GCWDistance extends StatefulWidget {
  final Function onChanged;
  final String hintText;
  final double value;
  final Length unit;
  final allowNegativeValues;
  final controller;

  const GCWDistance(
      {Key key, this.onChanged, this.hintText, this.value, this.unit, this.allowNegativeValues: false, this.controller})
      : super(key: key);

  @override
  _GCWDistanceState createState() => _GCWDistanceState();
}

class _GCWDistanceState extends State<GCWDistance> {
  var _controller;

  var _currentInput = {'text': '', 'value': 0.0};
  Length _currentLengthUnit;

  @override
  void initState() {
    super.initState();

    if (widget.value != null) _currentInput = {'text': widget.value.toString(), 'value': widget.value};

    if (widget.controller != null) {
      _controller = widget.controller;
    } else {
      _controller = TextEditingController(text: _currentInput['text']);
    }

    _currentLengthUnit = widget.unit ?? getUnitBySymbol(allLengths(), Prefs.get(PREFERENCE_DEFAULT_LENGTH_UNIT));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Container(
                child: GCWDoubleTextField(
                  hintText: widget.hintText ?? i18n(context, 'common_distance_hint'),
                  min: widget.allowNegativeValues ? null : 0.0,
                  controller: _controller,
                  onChanged: (ret) {
                    setState(() {
                      _currentInput = ret;
                      _setCurrentValueAndEmitOnChange();
                    });
                  },
                ),
                padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN))),
        Expanded(
          flex: 1,
          child: GCWUnitDropDown(
              unitList: allLengths(),
              value: _currentLengthUnit,
              onChanged: (Length value) {
                setState(() {
                  _currentLengthUnit = value;
                  _setCurrentValueAndEmitOnChange();
                });
              }),
        )
      ],
    );
  }

  _setCurrentValueAndEmitOnChange([setTextFieldText = false]) {
    if (setTextFieldText) _controller.text = _currentInput['value'].toString();

    double _currentValue = _currentInput['value'];
    var _meters = _currentLengthUnit.toMeter(_currentValue);
    widget.onChanged(_meters);
  }
}
