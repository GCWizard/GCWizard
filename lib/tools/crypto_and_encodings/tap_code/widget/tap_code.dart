import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/logic/tap_code.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_alphabetmodification_dropdownbutton/widget/gcw_alphabetmodification_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/utils/textinputformatter/wrapper_for_masktextinputformatter/widget/wrapper_for_masktextinputformatter.dart';

class TapCode extends StatefulWidget {
  @override
  TapCodeState createState() => TapCodeState();
}

class TapCodeState extends State<TapCode> {
  var _encryptionController;
  var _decryptionController;

  var _currentEncryptionInput = '';
  var _currentDecryptionInput = '';
  AlphabetModificationMode _currentModificationMode = AlphabetModificationMode.J_TO_I;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  var _maskFormatter = WrapperForMaskTextInputFormatter(mask: '## ' * 100000 + '##', filter: {"#": RegExp(r'[1-5]')});

  @override
  void initState() {
    super.initState();

    _encryptionController = TextEditingController(text: _currentEncryptionInput);
    _decryptionController = TextEditingController(text: _currentDecryptionInput);
  }

  @override
  void dispose() {
    _encryptionController.dispose();
    _decryptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encryptionController,
                onChanged: (text) {
                  setState(() {
                    _currentEncryptionInput = text;
                  });
                },
              )
            : GCWTextField(
                inputFormatters: [_maskFormatter],
                controller: _decryptionController,
                onChanged: (text) {
                  setState(() {
                    _currentDecryptionInput = text;
                  });
                },
              ),
        GCWAlphabetModificationDropDownButton(
          value: _currentModificationMode,
          onChanged: (value) {
            setState(() {
              _currentModificationMode = value;
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
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return encryptTapCode(_currentEncryptionInput, mode: _currentModificationMode);
    } else {
      return decryptTapCode(_currentDecryptionInput, mode: _currentModificationMode);
    }
  }
}
