import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/bifid.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/polybios.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_alphabetmodification_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_multiple_output.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';

class Bifid extends StatefulWidget {
  @override
  BifidState createState() => BifidState();
}

class BifidState extends State<Bifid> {
  var _inputController;
  var _alphabetController;

  var _currentMode = GCWSwitchPosition.left;

  String _currentInput = '';
  String _currentAlphabet = '';

  PolybiosMode _currentBifidMode = PolybiosMode.AZ09;
  AlphabetModificationMode _currentModificationMode = AlphabetModificationMode.J_TO_I;

  GCWSwitchPosition _currentMatrixMode = GCWSwitchPosition.left;         /// switches between 5x5 or 6x6 square

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
      PolybiosMode.AZ09 : i18n(context, 'bifid_mode_az09'),
      PolybiosMode.ZA90 : i18n(context, 'bifid_mode_za90'),
      PolybiosMode.CUSTOM : i18n(context, 'bifid_mode_custom'),
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

        GCWTextDivider(
            text: i18n(context, 'common_alphabet')
        ),

        GCWDropDownButton(
          value: _currentBifidMode,
          onChanged: (value) {
            setState(() {
              _currentBifidMode = value;
            });
          },
          items: BifidModeItems.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: mode.value,
            );
          }).toList(),
        ),

        _currentBifidMode == PolybiosMode.CUSTOM
          ? GCWTextField(
              hintText: i18n(context, 'common_alphabet'),
              controller: _alphabetController,
              onChanged: (text) {
                setState(() {
                  _currentAlphabet = text;
                });
              },
            )
          : Container(),

        GCWTwoOptionsSwitch(
          title: i18n(context, 'bifid_matrix'),
          leftValue: i18n(context, 'bifid_mode_5x5'),
          rightValue: i18n(context, 'bifid_mode_6x6'),
          onChanged: (value) {
            setState(() {
              _currentMatrixMode = value;
            });
          },
        ),

        _currentMatrixMode == GCWSwitchPosition.left
          ? GCWAlphabetModificationDropDownButton(
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

    if (_currentInput == null || _currentInput.length == 0)
      return GCWDefaultOutput(child: '');

    var _currentOutput = BifidOutput('', '', '');
    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptBifid(
        _currentInput,
        key,
        mode: _currentBifidMode,
        alphabet: _currentAlphabet,
        alphabetMode: _currentModificationMode
      );
    } else {
      _currentOutput = decryptBifid(
        _currentInput,
        key,
        mode: _currentBifidMode,
        alphabet: _currentAlphabet,
        alphabetMode: _currentModificationMode
      );
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
          )
        )
      ],
    );
  }
}