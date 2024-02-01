import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/_common/logic/irrational_numbers.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class IrrationalNumbersNthDecimal extends StatefulWidget {
  final IrrationalNumber irrationalNumber;

  const IrrationalNumbersNthDecimal({Key? key, required this.irrationalNumber}) : super(key: key);

  @override
  _IrrationalNumbersNthDecimalState createState() => _IrrationalNumbersNthDecimalState();
}

class _IrrationalNumbersNthDecimalState extends State<IrrationalNumbersNthDecimal> {
  int _currentValue = 1;
  late IrrationalNumberCalculator _calculator;

  @override
  void initState() {
    super.initState();
    _calculator = IrrationalNumberCalculator(irrationalNumber: widget.irrationalNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          value: _currentValue,
          min: 1,
          max: widget.irrationalNumber.decimalPart.length,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    if (_currentValue < 1) return '';

    try {
      return _calculator.decimalAt(_currentValue);
    } on FormatException catch (e) {
      return printErrorMessage(context, e.message);
    }
  }
}
