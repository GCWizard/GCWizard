import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/whitespace_language/logic/whitespace_language.dart';

class WhitespaceLanguage extends StatefulWidget {
  @override
  WhitespaceLanguageState createState() => WhitespaceLanguageState();
}

class WhitespaceLanguageState extends State<WhitespaceLanguage> {
  WhitespaceResult _currentOutput;

  String _currentCode = '';
  String _currentInput = '';
  WhitespaceState _continueState;
  var _isStarted = false;

  var _currentMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentCode = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_programming_mode_interpret'),
          rightValue: i18n(context, 'common_programming_mode_generate'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWButton(
          text: i18n(context, 'common_start'),
          onPressed: () {
            setState(() {
              _calcOutput(context);
            });
          },
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if ((_currentCode == null || _currentCode.length == 0) && (_currentOutput == null)) return GCWDefaultOutput();

    if (_currentOutput == null) return GCWDefaultOutput();

    return GCWMultipleOutput(
      children: [
        _currentOutput.output +
            (_currentOutput.error && (_currentOutput.errorText != null)
                ? '\n' + (i18n(context, _currentOutput.errorText) ?? _currentOutput.errorText)
                : ''),
        GCWOutput(
          title: i18n(context, 'whitespace_language_readable_code'),
          child: GCWOutputText(
            text: _currentOutput.code,
          ),
        ),
      ],
    );
  }

  _calcOutput(BuildContext context) async {
    if (_currentCode == null || _currentCode.length == 0 || _isStarted) return;

    _isStarted = true;
    _currentOutput = null;

    if (_currentMode == GCWSwitchPosition.left) {
      var currentOutputFuture = interpreterWhitespace(_currentCode, '', continueState: _continueState);
      _continueState = null;

      currentOutputFuture.then((output) {
        if (output.finished) {
          _currentOutput = output;
          _isStarted = false;
          this.setState(() {});
        } else {
          _continueState = output.state;
          _currentInput = "";
          _showDialogBox(context, output.output);
        }
      });
    } else {
      var currentOutputFuture = generateWhitespace(_currentCode);
      currentOutputFuture.then((output) {
        _currentOutput = output;
        _isStarted = false;
        this.setState(() {});
      });
    }
  }

  _showDialogBox(BuildContext context, String text) {
    showGCWDialog(
        context,
        text,
        Container(
          width: 300,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GCWTextField(
                autofocus: true,
                filled: true,
                onChanged: (text) {
                  _currentInput = text;
                },
              ),
            ],
          ),
        ),
        [
          GCWDialogButton(
            text: i18n(context, 'common_ok'),
            onPressed: () {
              _isStarted = false;
              if (_continueState != null) _continueState.inp = _currentInput + '\n';
              _calcOutput(context);
            },
          )
        ],
        cancelButton: false);
  }
}
