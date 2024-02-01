import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class LCM extends StatefulWidget {
  const LCM({Key? key}) : super(key: key);

  @override
  LCMState createState() => LCMState();
}

class LCMState extends State<LCM> {
  int _currentInputA = 0;
  int _currentInputB = 0;

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
      child: lcm(_currentInputA, _currentInputB).toString(),
    );
  }
}
