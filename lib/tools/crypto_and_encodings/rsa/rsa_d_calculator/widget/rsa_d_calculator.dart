import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

class RSADCalculator extends StatefulWidget {
  const RSADCalculator({Key? key}) : super(key: key);

  @override
  _RSADCalculatorState createState() => _RSADCalculatorState();
}

class _RSADCalculatorState extends State<RSADCalculator> {
  String _currentE = '';
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
          hintText: i18n(context, 'rsa_e'),
          onChanged: (text) {
            setState(() {
              _currentE = text;
            });
          },
        ),
        GCWTextField(
          inputFormatters: [_integerInputFormatter],
          hintText: i18n(context, 'rsa_primep'),
          onChanged: (text) {
            setState(() {
              _currentP = text;
            });
          },
        ),
        GCWTextField(
          inputFormatters: [_integerInputFormatter],
          hintText: i18n(context, 'rsa_primeq'),
          onChanged: (text) {
            setState(() {
              _currentQ = text;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        _output ?? const GCWDefaultOutput(),
      ],
    );
  }

  void _calculateOutput() {
    if (_currentE.isEmpty || _currentP.isEmpty || _currentQ.isEmpty) {
      _output = null;
    }

    try {
      var e = BigInt.tryParse(_currentE);
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      _output = GCWDefaultOutput(child: calculateD(e, p, q).toString());
    } catch (exception) {
      showSnackBar(i18n(context, exception.toString()), context);
      _output = null;
    }
  }
}
