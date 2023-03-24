import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/_common/logic/irrational_numbers.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class IrrationalNumbersDecimalRange extends StatefulWidget {
  final IrrationalNumber irrationalNumber;

  const IrrationalNumbersDecimalRange({Key? key, required this.irrationalNumber}) : super(key: key);

  @override
  IrrationalNumbersDecimalRangeState createState() => IrrationalNumbersDecimalRangeState();
}

class IrrationalNumbersDecimalRangeState extends State<IrrationalNumbersDecimalRange> {
  int _currentStart = 1;
  int _currentLength = 1;
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
        GCWTextDivider(
          text: i18n(context, 'irrationalnumbers_decimalrange_start'),
        ),
        GCWIntegerSpinner(
          value: _currentStart,
          min: 1,
          max: widget.irrationalNumber.decimalPart.length,
          onChanged: (value) {
            setState(() {
              _currentStart = value;
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'irrationalnumbers_decimalrange_length'),
        ),
        GCWIntegerSpinner(
          value: _currentLength,
          min: -widget.irrationalNumber.decimalPart.length,
          max: widget.irrationalNumber.decimalPart.length,
          onChanged: (value) {
            setState(() {
              _currentLength = value;
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    if (_currentStart < 1) return '';

    try {
      return _calculator.decimalRange(_currentStart, _currentLength);
    } on FormatException catch (e) {
      return printErrorMessage(context, e.message);
    }
  }
}
