import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

class RSA extends StatefulWidget {
  const RSA({Key? key}) : super(key: key);

  @override
  _RSAState createState() => _RSAState();
}

class _RSAState extends State<RSA> {
  String _currentInput = '';
  String _currentED = '';
  String _currentP = '';
  String _currentQ = '';

  final _integerInputFormatter = GCWIntegerTextInputFormatter(min: 0);
  var _currentMode = GCWSwitchPosition.right;
  Widget? _output;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            _currentInput = text;
          },
        ),
        GCWTextDivider(text: i18n(context, 'rsa_rsa_key')),
        GCWTextField(
          inputFormatters: [_integerInputFormatter],
          hintText: i18n(context, 'rsa_rsa_eq'),
          onChanged: (text) {
            _currentED = text;
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
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _output = null;
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
    try {
      var ed = BigInt.tryParse(_currentED);
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      var outputChildren = <Widget>[];
      if (ed != null && p != null && q != null) {
        if (_currentMode == GCWSwitchPosition.left) {
          var inputAsText = _currentInput.split('').map((char) {
            return BigInt.from(char.codeUnits.first);
          }).toList();

          if (_currentInput.replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'\d'), '').isEmpty) {
            var inputAsInt =
                _currentInput.split(RegExp(r'\s+')).map((chunk) => BigInt.tryParse(chunk) ?? BigInt.zero).toList();

            outputChildren.add(GCWOutput(
              child: (encryptRSA(inputAsInt, ed, p, q) ?? []).join(' '),
              title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_encryption_output_textasnumbers')})',
            ));
          }

          outputChildren.add(GCWOutput(
            child: (encryptRSA(inputAsText, ed, p, q) ?? []).join(' '),
            title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_encryption_output_textasascii')})',
          ));
        } else {
          var inputNumbers = _currentInput.split(RegExp(r'\s+')).map((number) {
            var n = number.replaceAll(RegExp(r'\D'), '');
            return BigInt.tryParse(n) ?? BigInt.zero;
          }).toList();

          var outputNumbers = decryptRSA(inputNumbers, ed, p, q);
          outputChildren.add(GCWOutput(
            child: (outputNumbers ?? []).join(' '),
            title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_decryption_output_numbers')})',
          ));

          outputChildren.add(GCWOutput(
            child: (outputNumbers ?? []).map((number) => String.fromCharCode(number.toInt())).join(''),
            title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_decryption_output_numbersasascii')})',
          ));
        }
      }

      String? d;
      if (_currentMode == GCWSwitchPosition.left) {
        try {
          d = calculateD(ed, p, q).toString();
        } catch (e) {
          d = i18n(context, 'rsa_rsa_d.notcomputeable');
        }
      }

      List<List<Object?>> calculatedParameters = [];
      if (d != null) calculatedParameters.add([i18n(context, 'rsa_d'), d]);
      calculatedParameters.addAll([
        [i18n(context, 'rsa_n'), N(p!, q!)],
        [i18n(context, 'rsa_phi'), phi(p, q)]
      ]);

      outputChildren.add(
        GCWTextDivider(text: i18n(context, 'rsa_rsa_calculatedparameters')),
      );

      _output =
          GCWColumnedMultilineOutput(firstRows: outputChildren, data: calculatedParameters, flexValues: const [1, 2]);
    } catch (exception) {
      _output = null;
      showSnackBar(i18n(context, exception.toString()), context);
    }
  }
}
