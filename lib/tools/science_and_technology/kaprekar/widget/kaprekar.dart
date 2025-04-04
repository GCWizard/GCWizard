import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/kaprekar/logic/kaprekar.dart';

class Kaprekar extends StatefulWidget {
  const Kaprekar({super.key});

  @override
  _KaprekarState createState() => _KaprekarState();
}

class _KaprekarState extends State<Kaprekar> {
  int _currentInputN = 1000;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'common_number'),
          min: 1000,
          max: 9999,
          overflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
          value: _currentInputN,
          onChanged: (value) {
            setState(() {
              _currentInputN = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInputN < 1000) return Container();

    KaprekarRoutine output = kaprekarsRoutine(_currentInputN);

    return GCWDefaultOutput(
      child: Column(
        children: [
          GCWTextDivider(
            text: i18n(context, 'common_steps'),
          ),
          GCWOutput(child: output.count),
          GCWTextDivider(
            text: i18n(context, 'kaprekar_routine'),
          ),
          GCWColumnedMultilineOutput(data: output.numbers),
        ],
      ),
    );
  }
}
