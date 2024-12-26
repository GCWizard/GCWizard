import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';

class RandomizerDice extends StatefulWidget {
  const RandomizerDice({Key? key}) : super(key: key);

  @override
  _RandomizerDiceState createState() => _RandomizerDiceState();
}

class _RandomizerDiceState extends State<RandomizerDice> {
  final _DICEVALUES = [4,6,8,10,12,20];

  var _currentCount = 1;

  int? _currentIndex;

  Widget _currentOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    _currentIndex ??= _DICEVALUES.indexOf(6);

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
        GCWDropDownSpinner(
          index: _currentIndex!,
          items: _DICEVALUES.map((int value) => Text('$value ' + i18n(context, 'randomizer_dice_sides'), style: gcwTextStyle())).toList(),
          onChanged: (int value) {
            setState(() {
              _currentIndex = value;
            });
          }
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
      out.add(randomInteger(1, _DICEVALUES[_currentIndex!]));
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    var outText = out.join(' ');

    var output = <Widget>[];
    output.add(GCWOutput(child: outText));
    output.add(CrosstotalOutput(text: outText, values: out, inputType: CROSSTOTAL_INPUT_TYPE.NUMBERS));

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: output,
      ),
    );
  }
}
