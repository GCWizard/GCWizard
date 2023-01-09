import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/number_sequences/number_sequence.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';

class NumberSequenceDigits extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxDigits;
  const NumberSequenceDigits({Key key, this.mode, this.maxDigits}) : super(key: key);

  @override
  NumberSequenceDigitsState createState() => NumberSequenceDigitsState();
}

class NumberSequenceDigitsState extends State<NumberSequenceDigits> {
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
    getNumbersWithNDigits(widget.mode, _currentInputN).forEach((element) {
      columnData.add([element.toString()]);
    });

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: columnData));
  }
}
