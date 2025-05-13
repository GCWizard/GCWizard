import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceContainsDigits extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceContainsDigits({super.key, required this.mode, required this.maxIndex});

  @override
  _NumberSequenceContainsDigitsState createState() => _NumberSequenceContainsDigitsState();
}

class _NumberSequenceContainsDigitsState extends State<NumberSequenceContainsDigits> {
  String _currentInputN = '';
  late TextEditingController currentInputController;

  Widget _currentOutput = const GCWDefaultOutput();

  @override
  void initState() {
    super.initState();
    currentInputController = TextEditingController(text: _currentInputN);
  }

  @override
  void dispose() {
    currentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, NUMBERSEQUENCE_TITLE[widget.mode]!),
        ),
        GCWTextField(
          controller: currentInputController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'\d')),
          ],
          onChanged: (text) {
            setState(() {
              if (text.isEmpty) {
                _currentInputN = '';
              } else {
                _currentInputN = text;
              }
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
    if (_currentInputN.isEmpty) {
      return;
    }

    List<List<String>> columnData = [];
    PositionOfSequenceOutput detailedOutput;

    detailedOutput = numberSequencesGetFirstPositionOfSequence(widget.mode, _currentInputN, widget.maxIndex);

    if (detailedOutput.number == '-1') {
      _currentOutput = GCWDefaultOutput(child: i18n(context, 'numbersequence_notfound'));
      return;
    }

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
