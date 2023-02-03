import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';

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
        CrosstotalSwitch(
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

  Widget _buildOutput() {
    var divs = divisors(_currentInputN);

    return Column(
      children: [
        GCWDefaultOutput(
          child: _currentCrosstotalMode
              ? divs.join(' ')
              : GCWColumnedMultilineOutput(data: divs.map((e) => [e]).toList()),
        ),
        if (_currentCrosstotalMode)
          CrosstotalOutput(
            text: _currentInputN.toString(),
            values: divisors(_currentInputN),
            inputType: CROSSTOTAL_INPUT_TYPE.NUMBERS,
          )
      ],
    );
  }
}
