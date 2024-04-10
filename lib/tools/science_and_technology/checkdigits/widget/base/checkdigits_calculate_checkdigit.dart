import 'package:flutter/material.dart';

import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

class CheckDigitsCalculateCheckDigit extends StatefulWidget {
  final CheckDigitsMode mode;
  const CheckDigitsCalculateCheckDigit({Key? key, required this.mode, }) : super(key: key);

  @override
  CheckDigitsCalculateCheckDigitState createState() => CheckDigitsCalculateCheckDigitState();
}

class CheckDigitsCalculateCheckDigitState extends State<CheckDigitsCalculateCheckDigit> {
  String _currentInputNString = '';
  late TextEditingController currentInputController;

  @override
  void initState() {
    super.initState();
    currentInputController = TextEditingController(text: _currentInputNString);
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
        GCWTextField( // CheckDigitsMode.ISBN, CheckDigitsMode.IBAN, CheckDigitsMode.EURO, CheckDigitsMode.DEPERSID
          controller: currentInputController,
          inputFormatters: [INPUTFORMATTERS[widget.mode]!],
          onChanged: (text) {
            setState(() {
              _currentInputNString = text;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    String output = checkDigitsCalculateCheckDigitAndNumber(widget.mode, checkDigitsNormalizeNumber(_currentInputNString));
    if (output.startsWith('check')) {
      output = i18n(context, output);
    }
    return GCWDefaultOutput(
      child: _formatOutput(output, widget.mode),
    );
  }

  String _formatOutput(String output, CheckDigitsMode mode){
    switch (mode) {
      case CheckDigitsMode.EAN_GTIN:
      case CheckDigitsMode.DETAXID:
      case CheckDigitsMode.EURO:
      case CheckDigitsMode.IMEI:
      case CheckDigitsMode.ISBN:
      return output;
      case CheckDigitsMode.IBAN:
        return _formatOutput_IBAN(output);
      case CheckDigitsMode.UIC:
        return _formatOutput_UIC(output);
      case CheckDigitsMode.CREDITCARD:
        return _formatOutput_Creditcard(output);
      default:
        return '';
    }
  }

  String _formatOutput_IBAN(String output){
    if (BigInt.tryParse(output.substring(2)) == null) {
      return output;
    }
    String result = '';
    for (int i = 0; i < output.length; i++) {
      result = result + output[i];
      if ((i + 1) % 4 == 0) {
        result = result + ' ';
      }
    }
    return result;
  }

  String _formatOutput_Creditcard(String output){
    if (int.tryParse(output) == null) {
      return output;
    }
    String result = '';
    for (int i = 0; i < output.length; i++) {
      result = result + output[i];
      if ((i + 1) % 4 == 0) {
        result = result + ' ';
      }
    }
    return result;
  }

  String _formatOutput_UIC(String output){
    if (int.tryParse(output) == null) {
      return output;
    }
    return output.substring(0, 2) + ' ' + output.substring(2, 4) + ' ' + output.substring(4, 8) + ' ' + output.substring(8, 11) + '-' + output[11];
  }

}