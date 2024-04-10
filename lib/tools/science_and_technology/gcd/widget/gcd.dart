import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class GCD extends StatefulWidget {
  const GCD({Key? key}) : super(key: key);

  @override
  _GCDState createState() => _GCDState();
}

class _GCDState extends State<GCD> {
  int _currentInputA = 0;
  int _currentInputB = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          value: _currentInputA,
          onChanged: (value) {
            setState(() {
              _currentInputA = value;
            });
          },
        ),
        GCWIntegerSpinner(
          value: _currentInputB,
          onChanged: (value) {
            setState(() {
              _currentInputB = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    return GCWDefaultOutput(
      child: gcd(_currentInputA, _currentInputB).toString(),
    );
  }
}
