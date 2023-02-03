import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

class IntegerFactorization extends StatefulWidget {
  final String numberLabel;

  const IntegerFactorization({Key key, this.numberLabel}) : super(key: key);

  @override
  IntegerFactorizationState createState() => IntegerFactorizationState();
}

class IntegerFactorizationState extends State<IntegerFactorization> {
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
          title: widget.numberLabel,
          value: _currentNumber,
          min: 1,
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
    return GCWMultipleOutput(children: integerFactorization(_currentNumber));
  }
}
