import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

class CheckDigitsCalculateMissingDigits extends StatefulWidget {
  final CheckDigitsMode mode;
  const CheckDigitsCalculateMissingDigits({
    Key? key,
    required this.mode,
  }) : super(key: key);

  @override
  CheckDigitsCalculateMissingDigitsState createState() => CheckDigitsCalculateMissingDigitsState();
}

class CheckDigitsCalculateMissingDigitsState extends State<CheckDigitsCalculateMissingDigits> {
  String _currentInputNumberString = '';
  late TextEditingController currentInputController;
  List<String> _numbers = <String>[];

  @override
  void initState() {
    super.initState();
    currentInputController = TextEditingController(text: _currentInputNumberString);
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
        GCWOutputText(
          text: i18n(context, 'checkdigits_calculate_number_hint') + '\n',
          suppressCopyButton: true,
        ),
        GCWTextField(
          controller: currentInputController,
          inputFormatters: [INPUTFORMATTERS[widget.mode]!],
          onChanged: (text) {
            setState(() {
              _currentInputNumberString = text;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _numbers = checkDigitsCalculateMissingDigitsAndNumber(
                  widget.mode, checkDigitsNormalizeNumber(_currentInputNumberString));
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_numbers.join('') == '') {
      return const GCWDefaultOutput(
        child: '',
      );
    }

    if (_numbers[0].startsWith('checkdigits_')) {
      return GCWDefaultOutput(
        child: i18n(context, _numbers[0]),
      );
    }

    if (_numbers.length == 1) {
      return GCWDefaultOutput(
        child: _numbers.join(''),
      );
    }

    Map<String, String> output = {};
    for (int i = 0; i < _numbers.length; i++) {
      output[(i + 1).toString() + '.'] = _numbers[i];
    }

    if (widget.mode == CheckDigitsMode.IBAN && _numbers.length > 1) {
      return Column(
        children: <Widget>[
          GCWDefaultOutput(
              child: GCWColumnedMultilineOutput(
                  data: output.entries.map((entry) {
                    return [entry.key, entry.value];
                  }).toList(),
                  flexValues: const [1, 4])),
          GCWOutput(
            title: i18n(context, 'checkdigits_hint'),
            suppressCopyButton: true,
            child: i18n(context, 'checkdigits_iban_hint_iban_multiple'),
          ),
          (_currentInputNumberString.length > 2 && _currentInputNumberString.toUpperCase().substring(0, 2) == 'DE')
              ? _showInvalidBankNumbers()
              : Container(),
        ],
      );
    } else {
      return GCWDefaultOutput(
          child: GCWColumnedMultilineOutput(
              data: output.entries.map((entry) {
                return [entry.key, entry.value];
              }).toList(),
              flexValues: const [1, 4]));
    }
  }

  Widget _showInvalidBankNumbers() {
    Map<String, String> output = {};
    int count = 1;
    for (int i = 0; i < _numbers.length; i++) {
      if (checkDigitsIBANDEBankNumberDoesNotExist(_numbers[i].substring(4, 12))) {
        output[count.toString() + '.'] = _numbers[i];
      }
    }

    return GCWOutput(
        title: i18n(context, 'checkdigits_iban_hint_iban_de_invalid_banknumbers'),
        child: GCWColumnedMultilineOutput(
            data: output.entries.map((entry) {
              return [entry.key, entry.value];
            }).toList(),
            flexValues: const [1, 4]));
  }
}
