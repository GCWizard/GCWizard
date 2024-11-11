import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';

class RandomizerCoin extends StatefulWidget {
  const RandomizerCoin({Key? key}) : super(key: key);

  @override
  _RandomizerCoinState createState() => _RandomizerCoinState();
}

class _RandomizerCoinState extends State<RandomizerCoin> {
  var _currentCount = 1;

  Widget _currentOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: 1000,
          value: _currentCount,
          onChanged: (int value) {
            setState(() {
              _currentCount = value;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        _currentOutput
      ],
    );
  }

  void _calculateOutput() {
    var out = <int>[];
    for (int i = 0; i < _currentCount; i++) {
      out.add(randomInteger(0, 2500));
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    var outText = out.map((int value) {
      if (value == 0) {
        return i18n(context, 'randomizer_coin_edge');
      }

      if (value % 2 == 0) {
        return i18n(context, 'randomizer_coin_tail');
      } else {
        return i18n(context, 'randomizer_coin_head');
      }
    }).join('\n');

    var output = <Widget>[
      GCWColumnedMultilineOutput(data: [
        [i18n(context, 'randomizer_coin_tail'), out.where((int value) => value != 0 && value % 2 == 0).length],
        [i18n(context, 'randomizer_coin_head'), out.where((int value) => value != 0 && value % 2 == 1).length],
        if (out.contains(0)) [i18n(context, 'randomizer_coin_edge'), out.where((int value) => value == 0).length]
      ]),
      GCWOutput(title: i18n(context, 'common_details'), child: outText),
    ];

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: output,
      ),
    );
  }
}
