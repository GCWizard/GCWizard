import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

class RSAPhiCalculator extends StatefulWidget {
  const RSAPhiCalculator({Key? key}) : super(key: key);

  @override
  _RSAPhiCalculatorState createState() => _RSAPhiCalculatorState();
}

class _RSAPhiCalculatorState extends State<RSAPhiCalculator> {
  String _currentP = '';
  String _currentQ = '';

  final _integerInputFormatter = GCWIntegerTextInputFormatter(min: 0);
  Widget? _output;

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
        _output ?? const GCWDefaultOutput(),
      ],
    );
  }

  void _calculateOutput(BuildContext context) {
    if (_currentP.isEmpty || _currentQ.isEmpty) {
      _output = null;
    }

    try {
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      _output = GCWDefaultOutput(child: phi(p as BigInt, q as BigInt).toString());
    } catch (exception) {
      showSnackBar(i18n(context, exception.toString()), context);
      _output = null;
    }
  }
}
