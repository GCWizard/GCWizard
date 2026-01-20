import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceRange extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceRange({super.key, required this.mode, required this.maxIndex});

  @override
  _NumberSequenceRangeState createState() => _NumberSequenceRangeState();
}

class _NumberSequenceRangeState extends State<NumberSequenceRange> {
  int _currentInputStop = 1;
  int _currentInputStart = 1;

  Widget _currentOutput = const GCWDefaultOutput();
  late TextEditingController _stopController;

  @override
  void initState() {
    super.initState();

    _stopController = TextEditingController(text: _currentInputStop.toString());
  }

  @override
  void dispose() {
    _stopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, NUMBERSEQUENCE_TITLE[widget.mode]!),
        ),
        Text(
          i18n(context, 'numbersequence_maxindex') + ' = ' + widget.maxIndex.toString(),
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputstart'),
          value: _currentInputStart,
          min: 1,
          max: widget.maxIndex,
          onChanged: (value) {
            setState(() {
              _currentInputStart = value;
              _currentInputStop = max(_currentInputStart, _currentInputStop);
              _stopController.text = _currentInputStop.toString();
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputstop'),
          value: _currentInputStop,
          controller: _stopController,
          min: _currentInputStart,
          max: widget.maxIndex,
          onChanged: (value) {
            setState(() {
              _currentInputStop = value;
            });
          },
        ),
        GCWSubmitButton(onPressed: () {
          int countLines = (_currentInputStop - _currentInputStart).abs();
          setState(() {
            showGCWAlertDialog(
                context,
                i18n(context, 'numbersequence_range_hint_title'),
                i18n(context, 'numbersequence_range_hint_description',parameters: [countLines]),
                    () async {
                      _calculateRange();
                }, cancelButton: true);
          });
        }),
        _currentOutput
      ],
    );
  }

  void _calculateRange() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<List<BigInt>>(
              isolatedFunction: calculateRangeAsync,
              parameter: _buildJobData,
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    return GCWAsyncExecuterParameters(GetNumberRangeJobData(sequence: widget.mode, start: _currentInputStart - 1, stop: _currentInputStop - 1));
  }

  void _showOutput(List<BigInt> output) {
    List<List<String>> columnData = [['n', i18n(context, 'common_element')]];
    for (int i = 0; i < output.length; i++) {
      BigInt element = output[i];
      columnData.add([(i + _currentInputStart).toString(), element.toString()]);
    }

    _currentOutput = GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: columnData, flexValues: [1, 5], hasHeader: true,));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

}
