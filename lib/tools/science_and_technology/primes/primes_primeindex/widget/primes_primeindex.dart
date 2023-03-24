import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

class PrimeIndex extends StatefulWidget {
  const PrimeIndex({Key? key}) : super(key: key);

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

  String _buildOutput() {
    var index = getPrimeIndex(_currentNumber);
    return index >= 1 ? index.toString() : i18n(context, 'primes_noprime');
  }
}
