import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';
import 'package:gc_wizard/tools/common/gcw_crosstotal_output/widget/gcw_crosstotal_output.dart';
import 'package:gc_wizard/tools/common/gcw_crosstotal_switch/widget/gcw_crosstotal_switch.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_integer_spinner/widget/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

class Divisor extends StatefulWidget {
  @override
  DivisorState createState() => DivisorState();
}

class DivisorState extends State<Divisor> {
  int _currentInputN = 0;

  bool _currentCrosstotalMode = true;

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
          min: 0,
          value: _currentInputN,
          onChanged: (value) {
            setState(() {
              _currentInputN = value;
            });
          },
        ),
        GCWCrosstotalSwitch(
          onChanged: (value) {
            setState(() {
              _currentCrosstotalMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  _buildOutput() {
    var divs = divisors(_currentInputN);

    return Column(
      children: [
        GCWDefaultOutput(
          child: _currentCrosstotalMode
              ? divs.join(' ')
              : Column(
                  children: columnedMultiLineOutput(context, divs.map((e) => [e]).toList()),
                ),
        ),
        if (_currentCrosstotalMode)
          GCWCrosstotalOutput(
            text: _currentInputN.toString(),
            values: divisors(_currentInputN),
            inputType: CROSSTOTAL_INPUT_TYPE.NUMBERS,
          )
      ],
    );
  }
}
