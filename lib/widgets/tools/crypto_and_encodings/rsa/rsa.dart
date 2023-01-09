import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/rsa.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/integer_textinputformatter.dart';

class RSA extends StatefulWidget {
  @override
  RSAState createState() => RSAState();
}

class RSAState extends State<RSA> {
  String _currentInput = '';
  String _currentED = '';
  String _currentP = '';
  String _currentQ = '';

  var _integerInputFormatter = IntegerTextInputFormatter(min: 0);
  var _currentMode = GCWSwitchPosition.right;
  Widget _output;

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
        _output ?? GCWDefaultOutput(),
      ],
    );
  }

  _calculateOutput() {
    try {
      var ed = BigInt.tryParse(_currentED);
      var p = BigInt.tryParse(_currentP);
      var q = BigInt.tryParse(_currentQ);

      if (_currentInput == null) {
        _currentInput = '';
      }

      var outputChildren = <Widget>[];
      if (_currentMode == GCWSwitchPosition.left) {
        var inputAsText = _currentInput.split('').map((char) {
          return BigInt.from(char.codeUnits.first);
        }).toList();

        if (_currentInput.replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'[0-9]'), '').length == 0) {
          var inputAsInt = _currentInput
              .split(RegExp(r'\s+'))
              .where((chunk) => chunk != null)
              .map((chunk) => BigInt.tryParse(chunk))
              .toList();

          outputChildren.add(GCWOutput(
            child: encryptRSA(inputAsInt, ed, p, q).join(' '),
            title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_encryption_output_textasnumbers')})',
          ));
        }

        outputChildren.add(GCWOutput(
          child: encryptRSA(inputAsText, ed, p, q).join(' '),
          title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_encryption_output_textasascii')})',
        ));
      } else {
        var inputNumbers = _currentInput
            .split(RegExp(r'\s+'))
            .map((number) {
              var n = number.replaceAll(RegExp('[^0-9]'), '');
              return BigInt.tryParse(n);
            })
            .where((number) => number != null)
            .toList();

        var outputNumbers = decryptRSA(inputNumbers, ed, p, q);
        outputChildren.add(GCWOutput(
          child: outputNumbers.join(' '),
          title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_decryption_output_numbers')})',
        ));

        outputChildren.add(GCWOutput(
          child: outputNumbers.map((number) => String.fromCharCode(number.toInt())).join(''),
          title: i18n(context, 'common_output') + ' (${i18n(context, 'rsa_decryption_output_numbersasascii')})',
        ));
      }

      var d;
      if (_currentMode == GCWSwitchPosition.left) {
        try {
          d = calculateD(ed, p, q).toString();
        } catch (e) {
          d = i18n(context, 'rsa_rsa_d.notcomputeable');
        }
      }

      var calculatedParameters = [
        d != null ? [i18n(context, 'rsa_d'), d] : null,
        [i18n(context, 'rsa_n'), N(p, q)],
        [i18n(context, 'rsa_phi'), phi(p, q)]
      ];

      outputChildren.add(
        GCWTextDivider(text: i18n(context, 'rsa_rsa_calculatedparameters')),
      );

      _output = GCWColumnedMultilineOutput(
          firstRows: outputChildren,
          data: calculatedParameters,
          flexValues: [1, 2]
      );
    } catch (exception) {
      _output = null;
      showToast(i18n(context, exception.message));
    }
  }
}
