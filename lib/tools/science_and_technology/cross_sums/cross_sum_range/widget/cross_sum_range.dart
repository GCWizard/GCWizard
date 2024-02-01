import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals_range.dart';
import 'package:gc_wizard/utils/constants.dart';

const _ALERT_MAX_OUTPUT = 200;
const _ALERT_MAX_RANGE = 25000;

class CrossSumRange extends StatefulWidget {
  final CrossSumType type;

  const CrossSumRange({Key? key, this.type = CrossSumType.NORMAL}) : super(key: key);

  @override
  _CrossSumRangeState createState() => _CrossSumRangeState();
}

class _CrossSumRangeState extends State<CrossSumRange> {
  var _currentCrossSum = 1;
  var _currentRangeStart = 0;
  var _currentRangeEnd = 100;

  var _currentOutput = <Widget>[];

  late TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _endController = TextEditingController(text: _currentRangeEnd.toString());
  }

  @override
  void dispose() {
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'crosssum_range_expected')),
        GCWIntegerSpinner(
          value: _currentCrossSum,
          min: widget.type == CrossSumType.ITERATED ? -9 : MIN_INT,
          max: widget.type == CrossSumType.ITERATED ? 9 : MAX_INT,
          onChanged: (value) {
            setState(() {
              _currentCrossSum = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'crosssum_range_range')),
        GCWIntegerSpinner(
          value: _currentRangeStart,
          onChanged: (value) {
            setState(() {
              _currentRangeStart = value;
              _currentRangeEnd = max(_currentRangeStart, _currentRangeEnd);
              _endController.text = _currentRangeEnd.toString();
            });
          },
        ),
        GCWIntegerSpinner(
          value: _currentRangeEnd,
          min: _currentRangeStart,
          controller: _endController,
          onChanged: (value) {
            setState(() {
              _currentRangeEnd = value;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            var rangeLength = (_currentRangeStart - _currentRangeEnd).abs() + 1;
            if (rangeLength.abs() > _ALERT_MAX_RANGE) {
              showGCWAlertDialog(
                context,
                i18n(context, 'crosssum_range_alert_input_title'),
                i18n(context, 'crosssum_range_alert_input_text', parameters: [rangeLength]),
                () {
                  _calculateOutput();
                },
              );
            } else {
              _calculateOutput();
            }
          },
        ),
        GCWMultipleOutput(
          children: _currentOutput,
        )
      ],
    );
  }

  void _calculateOutput() {
    List<int> output;

    switch (widget.type) {
      case CrossSumType.NORMAL:
        output = crossSumRange(_currentRangeStart, _currentRangeEnd, _currentCrossSum);
        break;
      case CrossSumType.ITERATED:
        output = crossSumRange(_currentRangeStart, _currentRangeEnd, _currentCrossSum, type: CrossSumType.ITERATED);
        break;
    }

    if (output.length > _ALERT_MAX_OUTPUT) {
      showGCWAlertDialog(
        context,
        i18n(context, 'crosssum_range_alert_result_title'),
        i18n(context, 'crosssum_range_alert_result_text', parameters: [output.length]),
        () {
          setState(() {
            _currentOutput = _buildOutput(output);
          });
        },
      );
    } else {
      setState(() {
        _currentOutput = _buildOutput(output);
      });
    }
  }

  List<Widget> _buildOutput(List<int> output) {
    return [
      GCWOutputText(
        text: '${i18n(context, 'common_count')}: ${output.length}',
        copyText: output.length.toString(),
      ),
      GCWColumnedMultilineOutput(data: List<List<dynamic>>.from(output.map((element) => [element]).toList()))
    ];
  }
}
