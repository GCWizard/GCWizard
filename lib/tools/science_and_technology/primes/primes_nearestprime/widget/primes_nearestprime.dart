import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

class NearestPrime extends StatefulWidget {
  const NearestPrime({Key? key}) : super(key: key);

  @override
  NearestPrimeState createState() => NearestPrimeState();
}

class NearestPrimeState extends State<NearestPrime> {
  var _currentNumber = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          value: _currentNumber,
          onChanged: (value) {
            setState(() {
              _currentNumber = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    return GCWMultipleOutput(children: getNearestPrime(_currentNumber) ?? []);
  }
}
