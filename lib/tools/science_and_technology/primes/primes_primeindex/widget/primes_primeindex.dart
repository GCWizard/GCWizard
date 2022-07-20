import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/logic/primes.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_integer_spinner/widget/gcw_integer_spinner.dart';

class PrimeIndex extends StatefulWidget {
  @override
  PrimeIndexState createState() => PrimeIndexState();
}

class PrimeIndexState extends State<PrimeIndex> {
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
          max: 1000003,
          onChanged: (value) {
            setState(() {
              _currentNumber = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  _buildOutput() {
    var index = getPrimeIndex(_currentNumber);
    return index >= 1 ? index.toString() : i18n(context, 'primes_noprime');
  }
}
