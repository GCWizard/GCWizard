import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/number_sequences/number_sequence.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';

class NumberSequenceRange extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceRange({Key key, this.mode, this.maxIndex}) : super(key: key);

  @override
  NumberSequenceRangeState createState() => NumberSequenceRangeState();
}

class NumberSequenceRangeState extends State<NumberSequenceRange> {
  int _currentInputStop = 0;
  int _currentInputStart = 0;

  Widget _currentOutput;
  TextEditingController _stopController;

  @override
  void initState() {
    super.initState();

    _currentOutput = GCWDefaultOutput();
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
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputstart'),
          value: _currentInputStart,
          min: 0,
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
          setState(() {
            _buildOutput();
          });
        }),
        _currentOutput
      ],
    );
  }

  _buildOutput() {
    List<List<String>> columnData = [];
    getNumbersInRange(widget.mode, _currentInputStart, _currentInputStop).forEach((element) {
      columnData.add([element.toString()]);
    });

    _currentOutput = GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: columnData));
  }
}
