import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tomtom/logic/tomtom.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class TomTom extends StatefulWidget {
  @override
  TomTomState createState() => TomTomState();
}

class TomTomState extends State<TomTom> {
  var _inputEncryptController;
  var _inputDecryptController;
  var _aController;
  var _bController;

  var _currentInputEncrypt = '';
  var _currentInputDecrypt = '';
  var _currentA = '/';
  var _currentB = '\\';

  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    _inputEncryptController = TextEditingController(text: _currentInputEncrypt);
    _inputDecryptController = TextEditingController(text: _currentInputDecrypt);
    _aController = TextEditingController(text: _currentA);
    _bController = TextEditingController(text: _currentB);
  }

  @override
  void dispose() {
    _inputEncryptController.dispose();
    _inputDecryptController.dispose();
    _aController.dispose();
    _bController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'common_key')),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: GCWTextField(
                    controller: _aController,
                    onChanged: (text) {
                      setState(() {
                        _currentA = text;
                      });
                    },
                  ),
                  padding: EdgeInsets.only(right: DEFAULT_MARGIN)),
            ),
            Expanded(
              child: Container(
                  child: GCWTextField(
                    controller: _bController,
                    onChanged: (text) {
                      setState(() {
                        _currentB = text;
                      });
                    },
                  ),
                  padding: EdgeInsets.only(
                    left: DEFAULT_MARGIN,
                  )),
            ),
          ],
        ),
        GCWTextDivider(text: i18n(context, 'common_input')),
        _currentMode == GCWSwitchPosition.right ? _buildButtonBar() : Container(),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _inputEncryptController,
                onChanged: (text) {
                  setState(() {
                    _currentInputEncrypt = text;
                  });
                },
              )
            : GCWTextField(
                controller: _inputDecryptController,
                onChanged: (text) {
                  setState(() {
                    _currentInputDecrypt = text;
                  });
                },
              ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  _buildButtonBar() {
    return GCWToolBar(children: [
      GCWButton(
        text: _currentA,
        onPressed: () {
          setState(() {
            _addCharacter(_currentA);
          });
        },
      ),
      GCWButton(
        text: _currentB,
        onPressed: () {
          setState(() {
            _addCharacter(_currentB);
          });
        },
      ),
      GCWButton(
        text: _currentA + _currentB,
        onPressed: () {
          setState(() {
            _addCharacter(_currentA + _currentB);
          });
        },
      ),
      GCWButton(
        text: _currentB + _currentA,
        onPressed: () {
          setState(() {
            _addCharacter(_currentB + _currentA);
          });
        },
      ),
      GCWIconButton(
        icon: Icons.space_bar,
        onPressed: () {
          setState(() {
            _addCharacter(' ');
          });
        },
      ),
      GCWIconButton(
        icon: Icons.backspace,
        onPressed: () {
          setState(() {
            _currentInputDecrypt = textControllerDoBackSpace(_currentInputDecrypt, _inputDecryptController);
          });
        },
      ),
    ]);
  }

  _addCharacter(String input) {
    _currentInputDecrypt = textControllerInsertText(input, _currentInputDecrypt, _inputDecryptController);
  }

  _buildOutput() {
    if (_currentA.length == 0 || _currentB.length == 0) return '';

    var key = {'/': _currentA, '\\': _currentB};

    return _currentMode == GCWSwitchPosition.left
        ? encryptTomTom(_currentInputEncrypt, key)
        : decryptTomTom(_currentInputDecrypt, key);
  }
}
