import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/logic/tap_code.dart';

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
        GCWAlphabetModificationDropDown(
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
