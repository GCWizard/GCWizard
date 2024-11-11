import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer_lists.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';

class RandomizerInteger extends StatefulWidget {
  const RandomizerInteger({Key? key}) : super(key: key);

  @override
  _RandomizerIntegerState createState() => _RandomizerIntegerState();
}

class _RandomizerIntegerState extends State<RandomizerInteger> {
  var _currentCount = 1;
  var _currentRepeat = true;

  var _currentStart = 1;
  var _currentEnd = 10;

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
        GCWOnOffSwitch(
          title: i18n(context, 'randomizer_repeat'),
          value: _currentRepeat,
          onChanged: (bool value) {
            setState(() {
              _currentRepeat = value;
            });
          }
        ),
        GCWTextDivider(text: i18n(context, 'randomizer_from') + ', ' + i18n(context, 'randomizer_to')),
        Row(
          children: [
            Expanded(
              child: GCWIntegerSpinner(
                value: _currentStart,
                onChanged: (int value) {
                  setState(() {
                    _currentStart = value;
                  });
                },
              ),
            ),
            Container(width: 5 * DOUBLE_DEFAULT_MARGIN),
            Expanded(
              child: GCWIntegerSpinner(
                value: _currentEnd,
                onChanged: (int value) {
                  setState(() {
                    _currentEnd = value;
                  });
                },
              ),
            )
          ],
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

    var start = _currentStart;
    var end = _currentEnd;
    if (start > end) {
      var temp = end;
      end = start;
      start = temp;
    }

    if (_currentRepeat == false) {
      var list = List<int>.generate(end - start + 1, (index) => index + start);
      out = shuffleList(list).sublist(0, min(_currentCount, list.length));
    } else {
      for (int i = 0; i < _currentCount; i++) {
        out.add(randomInteger(start, end));
      }
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    var outText = out.join(' ');

    var output = <Widget>[];
    if (_currentRepeat == false && out.length < _currentCount) {
      output.add(GCWOutput(child: i18n(context, 'randomizer_integer_notenoughdistinct'), suppressCopyButton: true));
      output.add(Container(height: DOUBLE_DEFAULT_MARGIN));
    }
    output.add(GCWOutput(child: outText));
    output.add(CrosstotalOutput(text: outText, values: out, inputType: CROSSTOTAL_INPUT_TYPE.NUMBERS));

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: output,
      ),
    );
  }
}
