import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetdropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bifid/logic/bifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

class Bifid extends StatefulWidget {
  @override
  BifidState createState() => BifidState();
}

class BifidState extends State<Bifid> {
  var _inputController;
  var _alphabetController;

  var _currentMode = GCWSwitchPosition.right;

  String _currentInput = '';
  String _currentAlphabet = '';

  PolybiosMode _currentBifidMode = PolybiosMode.AZ09;
  AlphabetModificationMode _currentModificationMode = AlphabetModificationMode.J_TO_I;

  GCWSwitchPosition _currentMatrixMode = GCWSwitchPosition.left;

  /// switches between 5x5 or 6x6 square

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _alphabetController = TextEditingController(text: _currentAlphabet);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _alphabetController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var BifidModeItems = {
      PolybiosMode.AZ09: i18n(context, 'bifid_mode_az09'),
      PolybiosMode.ZA90: i18n(context, 'bifid_mode_za90'),
      PolybiosMode.CUSTOM: i18n(context, 'bifid_mode_custom'),
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
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),

        GCWTextDivider(text: i18n(context, 'common_alphabet')),

        GCWAlphabetDropDown(
          value: _currentBifidMode,
          items: BifidModeItems,
          customModeKey: PolybiosMode.CUSTOM,
          textFieldController: _alphabetController,
          onChanged: (value) {
            setState(() {
              _currentBifidMode = value;
            });
          },
          onCustomAlphabetChanged: (text) {
            setState(() {
              _currentAlphabet = text;
            });
          },
        ),

        GCWTwoOptionsSwitch(
          title: i18n(context, 'bifid_matrix'),
          leftValue: i18n(context, 'bifid_mode_5x5'),
          rightValue: i18n(context, 'bifid_mode_6x6'),
          value: _currentMatrixMode,
          onChanged: (value) {
            setState(() {
              _currentMatrixMode = value;
            });
          },
        ),

        _currentMatrixMode == GCWSwitchPosition.left
            ? GCWAlphabetModificationDropDown(
                value: _currentModificationMode,
                onChanged: (value) {
                  setState(() {
                    _currentModificationMode = value;
                  });
                },
              )
            : Container(), //empty widget

        _buildOutput()
      ],
    );
  }

  _buildOutput() {
    var key;
    if (_currentMatrixMode == GCWSwitchPosition.left) {
      key = "12345";
    } else {
      key = "123456";
    }

    if (_currentInput == null || _currentInput.length == 0) return GCWDefaultOutput(child: '');

    var _currentOutput = BifidOutput('', '', '');
    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptBifid(_currentInput, key,
          mode: _currentBifidMode, alphabet: _currentAlphabet, alphabetMode: _currentModificationMode);
    } else {
      _currentOutput = decryptBifid(_currentInput, key,
          mode: _currentBifidMode, alphabet: _currentAlphabet, alphabetMode: _currentModificationMode);
    }

    if (_currentOutput.state == 'ERROR') {
      showToast(i18n(context, _currentOutput.output));
      return GCWDefaultOutput(child: '');
    }

    return GCWMultipleOutput(
      children: [
        _currentOutput.output,
        GCWOutput(
            title: i18n(context, 'bifid_usedgrid'),
            child: GCWOutputText(
              text: _currentOutput.grid,
              isMonotype: true,
            ))
      ],
    );
  }
}
