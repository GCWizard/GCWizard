import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetdropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/adfgvx/logic/adfgvx.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

class ADFGVX extends StatefulWidget {
  const ADFGVX({Key? key}) : super(key: key);

  @override
  _ADFGVXState createState() => _ADFGVXState();
}

class _ADFGVXState extends State<ADFGVX> {
  late TextEditingController _inputController;
  late TextEditingController _substitutionKeyController;
  late TextEditingController _transpositionKeyController;
  late TextEditingController _alphabetController;

  String _currentInput = '';
  String _currentSubstitutionKey = '';
  String _currentTranspositionKey = '';

  GCWSwitchPosition _currentADFGVXMode = GCWSwitchPosition.left;
  PolybiosMode _currentPolybiosMode = PolybiosMode.ZA90;
  String _currentAlphabet = '';

  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _substitutionKeyController = TextEditingController(text: _currentSubstitutionKey);
    _transpositionKeyController = TextEditingController(text: _currentTranspositionKey);
    _alphabetController = TextEditingController(text: _currentAlphabet);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _substitutionKeyController.dispose();
    _transpositionKeyController.dispose();
    _alphabetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var polybiosModeItems = {
      PolybiosMode.AZ09: i18n(context, 'polybios_mode_az09'),
      PolybiosMode.ZA90: i18n(context, 'polybios_mode_za90'),
      PolybiosMode.x09AZ: i18n(context, 'polybios_mode_09az'),
      PolybiosMode.x90ZA: i18n(context, 'polybios_mode_90za'),
      PolybiosMode.CUSTOM: i18n(context, 'common_custom'),
    };

    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'adfgvx_mode_adfgx'),
          rightValue: i18n(context, 'adfgvx_mode_adfgvx'),
          value: _currentADFGVXMode,
          onChanged: (text) {
            setState(() {
              _currentADFGVXMode = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'common_key')),
        GCWTextField(
          hintText: i18n(context, 'adfgvx_key_substitution'),
          controller: _substitutionKeyController,
          onChanged: (text) {
            setState(() {
              _currentSubstitutionKey = text;
            });
          },
        ),
        GCWTextField(
          hintText: i18n(context, 'adfgvx_key_transposition'),
          controller: _transpositionKeyController,
          onChanged: (text) {
            setState(() {
              _currentTranspositionKey = text;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'common_alphabet')),
        GCWAlphabetDropDown<PolybiosMode>(
          value: _currentPolybiosMode,
          items: polybiosModeItems,
          customModeKey: PolybiosMode.CUSTOM,
          textFieldController: _alphabetController,
          onChanged: (value) {
            setState(() {
              _currentPolybiosMode = value;
            });
          },
          onCustomAlphabetChanged: (text) {
            setState(() {
              _currentAlphabet = text;
            });
          },
        ),
        _calculateOutput()
      ],
    );
  }

  Widget _calculateOutput() {
    ADFGVXReturnType? output;

    if (_currentMode == GCWSwitchPosition.left) {
      if (_currentADFGVXMode == GCWSwitchPosition.left) {
        output = encryptADFGX(_currentInput, _currentSubstitutionKey, _currentTranspositionKey,
            polybiosMode: _currentPolybiosMode, alphabet: _currentAlphabet);
      } else {
        output = encryptADFGVX(_currentInput, _currentSubstitutionKey, _currentTranspositionKey,
            polybiosMode: _currentPolybiosMode, alphabet: _currentAlphabet);
      }
    } else {
      if (_currentADFGVXMode == GCWSwitchPosition.left) {
        output = decryptADFGX(_currentInput, _currentSubstitutionKey, _currentTranspositionKey,
            polybiosMode: _currentPolybiosMode, alphabet: _currentAlphabet);
      } else {
        output = decryptADFGVX(_currentInput, _currentSubstitutionKey, _currentTranspositionKey,
            polybiosMode: _currentPolybiosMode, alphabet: _currentAlphabet);
      }
    }

    if (output == null || output.output == null || output.output!.isEmpty) {
      return const GCWDefaultOutput();
    }

    var out = output.output;
    var grid = output.polybiosGrid;

    return Column(
      children: [
        GCWDefaultOutput(
          child: out,
        ),
        grid == null
            ? Container()
            : GCWOutput(
                title: i18n(context, 'polybios_usedgrid'),
                child: GCWOutputText(
                  text: grid,
                  isMonotype: true,
                ),
              )
      ],
    );
  }
}
