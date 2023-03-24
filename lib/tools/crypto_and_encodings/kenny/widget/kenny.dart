import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/logic/kenny.dart';

class Kenny extends StatefulWidget {
  const Kenny({Key? key}) : super(key: key);

  @override
  KennyState createState() => KennyState();
}

class KennyState extends State<Kenny> {
  late TextEditingController _inputController;
  late TextEditingController _mController;
  late TextEditingController _pController;
  late TextEditingController _fController;

  var _currentInput = '';
  var _currentCaseSensitive = true;
  var _currentM = 'm';
  var _currentP = 'p';
  var _currentF = 'f';

  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _mController = TextEditingController(text: _currentM);
    _pController = TextEditingController(text: _currentP);
    _fController = TextEditingController(text: _currentF);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _mController.dispose();
    _pController.dispose();
    _fController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        GCWTextDivider(text: i18n(context, 'common_key')),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: GCWTextField(
                    controller: _mController,
                    onChanged: (text) {
                      setState(() {
                        _currentM = text;
                      });
                    },
                  )),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: GCWTextField(
                    controller: _pController,
                    onChanged: (text) {
                      setState(() {
                        _currentP = text;
                      });
                    },
                  )),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: GCWTextField(
                    controller: _fController,
                    onChanged: (text) {
                      setState(() {
                        _currentF = text;
                      });
                    },
                  )),
            ),
          ],
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'common_case_sensitive'),
          value: _currentCaseSensitive,
          onChanged: (value) {
            setState(() {
              _currentCaseSensitive = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    if (_currentInput.isEmpty || _currentM.isEmpty || _currentP.isEmpty || _currentF.isEmpty) return '';

    var key = [_currentM, _currentP, _currentF];
    return _currentMode == GCWSwitchPosition.left
        ? encryptKenny(_currentInput, key, _currentCaseSensitive)
        : decryptKenny(_currentInput, key, _currentCaseSensitive);
  }
}
