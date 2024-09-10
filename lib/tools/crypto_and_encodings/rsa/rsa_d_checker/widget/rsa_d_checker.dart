import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

class RSADChecker extends StatefulWidget {
  const RSADChecker({Key? key}) : super(key: key);

  @override
  _RSADCheckerState createState() => _RSADCheckerState();
}

class _RSADCheckerState extends State<RSADChecker> {
  String _currentD = '';
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
          hintText: i18n(context, 'rsa_d'),
          onChanged: (text) {
            _currentD = text;
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
    if (_currentD.isEmpty || _currentP.isEmpty || _currentQ.isEmpty) {
      _output = null;
    }

    try {
      var e = BigInt.tryParse(_currentD);
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      var validD = validateD(e as BigInt, p as BigInt, q as BigInt);
      _output = GCWDefaultOutput(
          child: validD ? i18n(context, 'rsa_d.checker_valid') : i18n(context, 'rsa_d.checker_notvalid'));
    } on FormatException catch (e) {
      _output = GCWDefaultOutput(child: i18n(context, e.message));
    }
  }
}
