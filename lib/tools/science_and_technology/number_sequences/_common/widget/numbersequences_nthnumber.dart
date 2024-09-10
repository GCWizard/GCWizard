import 'package:flutter/material.dart';

import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceNthNumber extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceNthNumber({Key? key, required this.mode, required this.maxIndex}) : super(key: key);

  @override
  _NumberSequenceNthNumberState createState() => _NumberSequenceNthNumberState();
}

class _NumberSequenceNthNumberState extends State<NumberSequenceNthNumber> {
  int _currentInputN = 0;
  Widget _currentOutput = const GCWDefaultOutput();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, NUMBERSEQUENCE_TITLE[widget.mode]!),
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          i18n(context, 'numbersequence_maxindex') + ' = ' + widget.maxIndex.toString(),
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputn'),
          min: 0,
          max: widget.maxIndex,
          value: _currentInputN,
          onChanged: (value) {
            setState(() {
              _currentInputN = value;
            });
          },
        ),
        GCWSubmitButton(onPressed: () {
          setState(() {
            _calculateNumberAt();
          });
        }),
        _currentOutput,
        //_buildOutput()
      ],
    );
  }

  void _calculateNumberAt() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<BigInt>(
              isolatedFunction: calculateNumberAtAsync,
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
    return GCWAsyncExecuterParameters(GetNumberAtJobData(sequence: widget.mode, n: _currentInputN));
  }

  void _showOutput(BigInt output) {
    _currentOutput = GCWDefaultOutput(child: output.toString());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
