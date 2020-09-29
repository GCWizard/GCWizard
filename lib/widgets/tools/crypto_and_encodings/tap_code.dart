import 'package:flutter/material.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/tap_code.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_alphabetmodification_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/wrapper_for_masktextinputformatter.dart';

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
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  var _maskFormatter = WrapperForMaskTextInputFormatter(
    mask: '## ' * 100000 + '##',
    filter: {"#": RegExp(r'[1-5]')}
  );

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
        GCWDefaultOutput(
          child: _calculateOutput()
        )
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