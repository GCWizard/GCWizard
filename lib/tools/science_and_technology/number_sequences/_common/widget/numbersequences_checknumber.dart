import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceCheckNumber extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceCheckNumber({super.key, required this.mode, required this.maxIndex});

  @override
  _NumberSequenceCheckNumberState createState() => _NumberSequenceCheckNumberState();
}

class _NumberSequenceCheckNumberState extends State<NumberSequenceCheckNumber> {
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
        _currentOutput,
      ],
    );
  }

  void _buildOutput() {
    if (_currentInputN.isEmpty) {
      return;
    }

    var checked = numberSequencesCheckNumber(widget.mode, BigInt.parse(_currentInputN), widget.maxIndex);

    String output;
    if (checked >= 0) {
      output = i18n(context, 'numbersequence_check_isinsequence', parameters: [checked]);
    } else {
      output = i18n(context, 'numbersequence_check_isnotinsequence');
    }

    _currentOutput = GCWDefaultOutput(
      child: output.toString(),
      copyText: checked.toString(),
      suppressCopyButton: checked < 0,
    );
  }
}
