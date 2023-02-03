import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

class RSAPhiCalculator extends StatefulWidget {
  @override
  RSAPhiCalculatorState createState() => RSAPhiCalculatorState();
}

class RSAPhiCalculatorState extends State<RSAPhiCalculator> {
  String _currentP = '';
  String _currentQ = '';

  var _integerInputFormatter = GCWIntegerTextInputFormatter(min: 0);
  Widget _output;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          inputFormatters: [_integerInputFormatter],
          hintText: i18n(context, 'rsa_primep'),
          onChanged: (text) {
            _currentP = text;
          },
        ),
        GCWTextField(
          inputFormatters: [_integerInputFormatter],
          hintText: i18n(context, 'rsa_primeq'),
          onChanged: (text) {
            _currentQ = text;
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput(context);
            });
          },
        ),
        _output ?? GCWDefaultOutput(),
      ],
    );
  }

  _calculateOutput(BuildContext context) {
    if (_currentP == null || _currentP.length == 0 || _currentQ == null || _currentQ.length == 0) {
      _output = null;
    }

    try {
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      _output = GCWDefaultOutput(child: phi(p, q).toString());
    } catch (exception) {
      showToast(i18n(context, exception.message));
      _output = null;
    }
  }
}
