import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';

class GCWUnitInput<T extends Unit> extends StatefulWidget {
  final double? min;
  final double? max;
  final int? numberDecimalDigits;
  final double value;
  final List<T>? unitList;
  final UnitCategory<T>? unitCategory;
  final String? title;
  final T? initialUnit;
  final bool suppressOverflow;

  final void Function(double) onChanged;

  const GCWUnitInput(
      {Key? key,
      this.title,
      this.min,
      this.max,
      this.numberDecimalDigits = 5,
      this.value = 0.0,
      this.unitCategory,
      this.unitList,
      this.initialUnit,
      required this.onChanged,
      this.suppressOverflow = false})
      : super(key: key);

  @override
  _GCWUnitInputState<T> createState() => _GCWUnitInputState<T>();
}

class _GCWUnitInputState<T extends Unit> extends State<GCWUnitInput> {
  late T _currentUnit;
  late double _currentValue;
  late List<T> _unitList;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.value;
    _unitList = (widget.unitList ?? widget.unitCategory?.units ?? <T>[]) as List<T>;
    _currentUnit = (widget.initialUnit ?? getReferenceUnit<T>(_unitList)) as T;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
            child: GCWDoubleSpinner(
              title: widget.title,
              min: widget.min,
              max: widget.max,
              numberDecimalDigits: widget.numberDecimalDigits ?? 2,
              value: _currentValue,
              suppressOverflow: widget.suppressOverflow,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                  _convertToReferenceAndEmitOnChange();
                });
              },
            ),
          )),
      Expanded(
          flex: 1,
          child: GCWUnitDropDown<T>(
            value: _currentUnit,
            unitList: _unitList,
            onChanged: (T value) {
              setState(() {
                _currentUnit = value;
                _convertToReferenceAndEmitOnChange();
              });
            },
          ))
    ]);
  }

  void _convertToReferenceAndEmitOnChange() {
    var referenceValue = _currentUnit.toReference(_currentValue);
    widget.onChanged(referenceValue);
  }
}
