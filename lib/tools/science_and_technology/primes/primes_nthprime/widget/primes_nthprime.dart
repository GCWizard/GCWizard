import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

class NthPrime extends StatefulWidget {
  @override
  NthPrimeState createState() => NthPrimeState();
}

class NthPrimeState extends State<NthPrime> {
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
          min: 1,
          max: 78499,
          onChanged: (value) {
            setState(() {
              _currentNumber = value;
            });
          },
        ),
        GCWDefaultOutput(child: getNthPrime(_currentNumber))
      ],
    );
  }
}
