import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceDigits extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxDigits;
  const NumberSequenceDigits({Key? key, required this.mode, required this.maxDigits}) : super(key: key);

  @override
  _NumberSequenceDigitsState createState() => _NumberSequenceDigitsState();
}

class _NumberSequenceDigitsState extends State<NumberSequenceDigits> {
  int _currentInputN = 1;

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
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputd'),
          value: _currentInputN,
          min: 1,
          max: widget.maxDigits,
          onChanged: (value) {
            setState(() {
              _currentInputN = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    List<List<String>> columnData = [];
    numberSequencesGetNumbersWithNDigits(widget.mode, _currentInputN).forEach((element) {
      columnData.add([element.toString()]);
    });

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: columnData));
  }
}
