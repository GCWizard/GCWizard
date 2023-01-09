import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/vigenere_breaker.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_async_executer.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_multiple_output.dart';
import 'package:gc_wizard/widgets/common/gcw_onoff_switch.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';

class VigenereBreaker extends StatefulWidget {
  @override
  VigenereBreakerState createState() => VigenereBreakerState();
}

class VigenereBreakerState extends State<VigenereBreaker> {
  String _currentInput = '';
  VigenereBreakerAlphabet _currentAlphabet = VigenereBreakerAlphabet.GERMAN;
  VigenereBreakerResult _currentOutput;
  bool _currentAutokey = false;
  bool _currentNonLetters = false;
  var _minKeyLengthController;
  var _maxKeyLengthController;
  int _minKeyLength = 3;
  int _maxKeyLength = 30;

  @override
  void initState() {
    super.initState();

    _minKeyLengthController = TextEditingController(text: _minKeyLength.toString());
    _maxKeyLengthController = TextEditingController(text: _maxKeyLength.toString());
  }

  @override
  void dispose() {
    _minKeyLengthController.dispose();
    _maxKeyLengthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var BreakerAlphabetItems = {
      VigenereBreakerAlphabet.ENGLISH: i18n(context, 'common_language_english'),
      VigenereBreakerAlphabet.GERMAN: i18n(context, 'common_language_german'),
      VigenereBreakerAlphabet.SPANISH: i18n(context, 'common_language_spanish'),
      VigenereBreakerAlphabet.FRENCH: i18n(context, 'common_language_french'),
    };

    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'vigenere_autokey'),
          value: _currentAutokey,
          onChanged: (value) {
            setState(() {
              _currentAutokey = value;
            });
          },
        ),
        _currentAutokey == false
            ? GCWOnOffSwitch(
                title: i18n(context, 'vigenere_ignorenonletters'),
                value: _currentNonLetters,
                onChanged: (value) {
                  setState(() {
                    _currentNonLetters = value;
                  });
                },
              )
            : Container(),
        GCWTextDivider(text: i18n(context, 'common_alphabet')),
        GCWDropDownButton(
          value: _currentAlphabet,
          onChanged: (value) {
            setState(() {
              _currentAlphabet = value;
            });
          },
          items: BreakerAlphabetItems.entries.map((alphabet) {
            return GCWDropDownMenuItem(
              value: alphabet.key,
              child: alphabet.value,
            );
          }).toList(),
        ),
        GCWTextDivider(text: i18n(context, 'vigenerebreaker_key_length')),
        GCWIntegerSpinner(
          title: i18n(context, 'vigenerebreaker_key_length_min'),
          controller: _minKeyLengthController,
          value: _minKeyLength,
          min: 3,
          max: 999,
          onChanged: (value) {
            setState(() {
              _minKeyLength = value;
              _maxKeyLength = max(_minKeyLength, _maxKeyLength);
              _maxKeyLengthController.text = _maxKeyLength.toString();
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'vigenerebreaker_key_length_max'),
          controller: _maxKeyLengthController,
          value: _maxKeyLength,
          min: 3,
          max: 999,
          onChanged: (value) {
            setState(() {
              _maxKeyLength = value;
              _minKeyLength = min(_minKeyLength, _maxKeyLength);
              _minKeyLengthController.text = _minKeyLength.toString();
            });
          },
        ),
        _buildSubmitButton(),
        _buildOutput(context),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              child: GCWAsyncExecuter(
                isolatedFunction: break_cipherAsync,
                parameter: _buildJobData(),
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
              height: 220,
              width: 150,
            ),
          );
        },
      );
    });
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput == null || _currentInput.length == 0) return GCWDefaultOutput();

    if (_currentOutput == null) return GCWDefaultOutput();

    if (_currentOutput.errorCode != VigenereBreakerErrorCode.OK) {
      showToast(i18n(context, 'vigenerebreaker_error', parameters: [_currentOutput.errorCode]));
      return GCWDefaultOutput();
    }

    return GCWMultipleOutput(
      children: [
        _currentOutput.plaintext,
        Column(
          children: [
            GCWOutput(
              title: i18n(context, 'common_key'),
              child: GCWOutputText(text: _currentOutput.key),
            ),
          ],
        )
      ],
    );
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    _currentOutput = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    if (_currentInput == null || _currentInput.length == 0) return null;

    return GCWAsyncExecuterParameters(VigenereBreakerJobData(
        input: _currentInput,
        vigenereBreakerType: _currentAutokey ? VigenereBreakerType.AUTOKEYVIGENERE : VigenereBreakerType.VIGENERE,
        ignoreNonLetters: _currentAutokey ? true : _currentNonLetters,
        alphabet: _currentAlphabet,
        keyLengthMin: _minKeyLength,
        keyLengthMax: _maxKeyLength));
  }

  _showOutput(VigenereBreakerResult output) {
    if (output == null) {
      _currentOutput = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentOutput = output;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
