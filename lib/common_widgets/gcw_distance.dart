import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';

class GCWDistance extends StatefulWidget {
  final void Function(double) onChanged;
  final String? hintText;
  final double? value;
  final Length? unit;
  final bool allowNegativeValues;
  final TextEditingController? controller;

  const GCWDistance(
      {Key? key,
      required this.onChanged,
      this.hintText,
      this.value,
      this.unit,
      this.allowNegativeValues = false,
      this.controller})
      : super(key: key);

  @override
  _GCWDistanceState createState() => _GCWDistanceState();
}

class _GCWDistanceState extends State<GCWDistance> {
  late TextEditingController _controller;

  var _currentInput = defaultDoubleText;
  late Length _currentLengthUnit;

  @override
  void initState() {
    super.initState();

    if (widget.value != null) _currentInput = DoubleText(widget.value!.toString(), widget.value!);

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: _currentInput.text);
    }

    _currentLengthUnit = widget.unit ?? defaultLengthUnit;
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
                padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                child: GCWDoubleTextField(
                  hintText: widget.hintText ?? i18n(context, 'common_distance_hint'),
                  min: widget.allowNegativeValues ? null : 0.0,
                  controller: _controller,
                  onChanged: (DoubleText ret) {
                    setState(() {
                      _currentInput = ret;
                      _setCurrentValueAndEmitOnChange();
                    });
                  },
                ))),
        Expanded(
          flex: 1,
          child: GCWUnitDropDown(
              unitList: allLengths(),
              value: _currentLengthUnit,
              onChanged: (Unit? value) {
                setState(() {
                  _currentLengthUnit = (value is Length) ? value : LENGTH_METER;
                  _setCurrentValueAndEmitOnChange();
                });
              }),
        )
      ],
    );
  }

  void _setCurrentValueAndEmitOnChange([bool setTextFieldText = false]) {
    if (setTextFieldText) _controller.text = _currentInput.value.toString();

    double _currentValue = _currentInput.value;
    var _meters = _currentLengthUnit.toMeter(_currentValue);
    widget.onChanged(_meters);
  }
}
