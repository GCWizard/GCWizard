import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/rsa.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/integer_textinputformatter.dart';

class RSANCalculator extends StatefulWidget {
  @override
  RSANCalculatorState createState() => RSANCalculatorState();
}

class RSANCalculatorState extends State<RSANCalculator> {
  String _currentP = '';
  String _currentQ = '';

  var _integerInputFormatter = IntegerTextInputFormatter(min: 0);
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
              _calculateOutput();
            });
          },
        ),
        _output ?? GCWDefaultOutput(),
      ],
    );
  }

  _calculateOutput() {
    if (_currentP == null || _currentP.length == 0 || _currentQ == null || _currentQ.length == 0) {
      _output = null;
    }

    try {
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      _output = GCWDefaultOutput(child: N(p, q).toString());
    } catch (exception) {
      showToast(i18n(context, exception.message));
      _output = null;
    }
  }
}
