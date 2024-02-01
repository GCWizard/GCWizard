import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/logic/vigenere_breaker.dart';

class VigenereBreaker extends StatefulWidget {
  const VigenereBreaker({Key? key}) : super(key: key);

  @override
  _VigenereBreakerState createState() => _VigenereBreakerState();
}

class _VigenereBreakerState extends State<VigenereBreaker> {
  String _currentInput = '';
  VigenereBreakerAlphabet _currentAlphabet = VigenereBreakerAlphabet.GERMAN;
  VigenereBreakerResult? _currentOutput;
  bool _currentAutokey = false;
  bool _currentNonLetters = false;
  late TextEditingController _minKeyLengthController;
  late TextEditingController _maxKeyLengthController;
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
        GCWDropDown<VigenereBreakerAlphabet>(
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
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<VigenereBreakerResult>(
                isolatedFunction: break_cipherAsync,
                parameter: _buildJobData,
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    if (_currentOutput == null) return const GCWDefaultOutput();

    if (_currentOutput!.errorCode != VigenereBreakerErrorCode.OK) {
      showSnackBar(i18n(context, 'vigenerebreaker_error', parameters: [_currentOutput!.errorCode]), context);
      return const GCWDefaultOutput();
    }

    return GCWMultipleOutput(
      children: [
        _currentOutput!.plaintext,
        Column(
          children: [
            GCWOutput(
              title: i18n(context, 'common_key'),
              child: GCWOutputText(text: _currentOutput!.key),
            ),
          ],
        )
      ],
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    _currentOutput = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    if (_currentInput.isEmpty) return null;

    return GCWAsyncExecuterParameters(VigenereBreakerJobData(
        input: _currentInput,
        vigenereBreakerType: _currentAutokey ? VigenereBreakerType.AUTOKEYVIGENERE : VigenereBreakerType.VIGENERE,
        ignoreNonLetters: _currentAutokey ? true : _currentNonLetters,
        alphabet: _currentAlphabet,
        keyLengthMin: _minKeyLength,
        keyLengthMax: _maxKeyLength));
  }

  void _showOutput(VigenereBreakerResult? output) {
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
