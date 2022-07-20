import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/common/units/logic/unit.dart';
import 'package:gc_wizard/tools/common/units/logic/unit_category.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/tools/common/gcw_double_spinner/widget/gcw_double_spinner.dart';
import 'package:gc_wizard/tools/common/gcw_integer_spinner/widget/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/common/units/gcw_unit_dropdownbutton/widget/gcw_unit_dropdownbutton.dart';

class GCWUnitInput extends StatefulWidget {
  final min;
  final numberDecimalDigits;
  final double value;
  final List<Unit> unitList;
  final UnitCategory unitCategory;
  final title;
  final Unit initialUnit;

  final Function onChanged;

  GCWUnitInput(
      {Key key,
      this.title,
      this.min,
      this.numberDecimalDigits: 5,
      this.value: 0.0,
      this.unitCategory,
      this.unitList,
      this.initialUnit,
      this.onChanged})
      : super(key: key);

  @override
  _GCWUnitInputState createState() => _GCWUnitInputState();
}

class _GCWUnitInputState extends State<GCWUnitInput> {
  var _currentUnit;
  var _currentValue;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.value;
    _currentUnit = widget.initialUnit ?? getReferenceUnit(widget.unitList ?? widget.unitCategory.units);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Container(
            child: GCWDoubleSpinner(
              title: widget.title,
              min: widget.min,
              numberDecimalDigits: widget.numberDecimalDigits,
              value: _currentValue,
              suppressOverflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                  _convertToReferenceAndEmitOnChange();
                });
              },
            ),
            padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
          ),
          flex: 3),
      Expanded(
          child: GCWUnitDropDownButton(
            value: _currentUnit,
            unitList: widget.unitList ?? widget.unitCategory.units,
            onChanged: (value) {
              setState(() {
                _currentUnit = value;
                _convertToReferenceAndEmitOnChange();
              });
            },
          ),
          flex: 1)
    ]);
  }

  _convertToReferenceAndEmitOnChange() {
    var referenceValue = _currentUnit.toReference(_currentValue);
    widget.onChanged(referenceValue);
  }
}
