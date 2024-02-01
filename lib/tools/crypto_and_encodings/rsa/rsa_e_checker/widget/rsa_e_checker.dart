import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

class RSAEChecker extends StatefulWidget {
  const RSAEChecker({Key? key}) : super(key: key);

  @override
  _RSAECheckerState createState() => _RSAECheckerState();
}

class _RSAECheckerState extends State<RSAEChecker> {
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
            _currentE = text;
          },
        ),
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

      var validE = validateE(e as BigInt, p as BigInt, q as BigInt);
      _output = GCWDefaultOutput(
          child: validE ? i18n(context, 'rsa_e.checker_valid') : i18n(context, 'rsa_e.checker_notvalid'));
    } catch (exception) {
      _output = GCWDefaultOutput(child: i18n(context, exception.toString()));
    }
  }
}
