import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceContainsDigits extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceContainsDigits({Key? key, required this.mode, required this.maxIndex}) : super(key: key);

  @override
  _NumberSequenceContainsDigitsState createState() => _NumberSequenceContainsDigitsState();
}

class _NumberSequenceContainsDigitsState extends State<NumberSequenceContainsDigits> {
  int currentInputN = 0;

  Widget _currentOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, NUMBERSEQUENCE_TITLE[widget.mode]!),
          style: const TextStyle(fontSize: 20),
        ),
        GCWIntegerSpinner(
          value: currentInputN,
          min: 0,
          onChanged: (value) {
            setState(() {
              currentInputN = value;
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

  void _buildOutput() {
    List<List<String>> columnData = [];
    PositionOfSequenceOutput detailedOutput;

    detailedOutput = numberSequencesGetFirstPositionOfSequence(widget.mode, currentInputN.toString(), widget.maxIndex);

    columnData.add([
      i18n(context, 'numbersequence_output_col_1'),
      i18n(context, 'numbersequence_output_col_2'),
      i18n(context, 'numbersequence_output_col_3')
    ]);
    columnData.add(
        [detailedOutput.number, detailedOutput.positionSequence.toString(), detailedOutput.positionDigits.toString()]);

    _currentOutput = GCWDefaultOutput(
        child:
            GCWColumnedMultilineOutput(data: columnData, flexValues: const [4, 2, 1], copyColumn: 0, hasHeader: true));
  }
}
