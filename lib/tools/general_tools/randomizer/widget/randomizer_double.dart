import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:intl/intl.dart';

class RandomizerDouble extends StatefulWidget {
  const RandomizerDouble({Key? key}) : super(key: key);

  @override
  _RandomizerDoubleState createState() => _RandomizerDoubleState();
}

class _RandomizerDoubleState extends State<RandomizerDouble> {
  var _currentCount = 1;

  var _currentStart = 0.0;
  var _currentEnd = 10.0;

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
        GCWTextDivider(text: i18n(context, 'randomizer_from') + ', ' + i18n(context, 'randomizer_to')),
        Row(
          children: [
            Expanded(
              child: GCWDoubleSpinner(
                value: _currentStart,
                onChanged: (double value) {
                  setState(() {
                    _currentStart = value;
                  });
                },
              ),
            ),
            Container(width: 5 * DOUBLE_DEFAULT_MARGIN),
            Expanded(
              child: GCWDoubleSpinner(
                value: _currentEnd,
                onChanged: (double value) {
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
    var out = <double>[];

    for (int i = 0; i < _currentCount; i++) {
      out.add(randomDouble(_currentStart, _currentEnd));
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    var sum = out.fold(0.0, (a, b) => a + b);
    var formatter = NumberFormat('0.##########');
    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: [
          GCWColumnedMultilineOutput(data: out.map((double value) => [formatter.format(value)]).toList()),
          GCWTextDivider(text: i18n(context, 'crosstotal_commonsums')),
          GCWColumnedMultilineOutput(data: [
            [i18n(context, 'crosstotal_sum'), formatter.format(sum)],
            [i18n(context, 'crosstotal_average'), formatter.format(sum / out.length)],
          ]),
        ],
      ),
    );
  }
}
