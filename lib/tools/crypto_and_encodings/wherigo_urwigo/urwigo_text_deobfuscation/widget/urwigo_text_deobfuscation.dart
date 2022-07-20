import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wherigo_urwigo/logic/urwigo_tools.dart';
import 'package:gc_wizard/tools/common/base/gcw_text/widget/gcw_text.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class UrwigoTextDeobfuscation extends StatefulWidget {
  @override
  UrwigoTextDeobfuscationState createState() => UrwigoTextDeobfuscationState();
}

class UrwigoTextDeobfuscationState extends State<UrwigoTextDeobfuscation> {
  var _inputController;
  var _inputObfuscateController;
  var _dtableController;

  var _currentInput = '';
  var _currentDTable = '';
  var _currentObfuscateInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _inputObfuscateController = TextEditingController(text: _currentObfuscateInput);
    _dtableController = TextEditingController(text: _currentDTable);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputObfuscateController.dispose();
    _dtableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'urwigo_textdeobfuscation_mode_obfuscate'),
          rightValue: i18n(context, 'urwigo_textdeobfuscation_mode_de_obfuscate'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        Row(
          children: [
            Expanded(
              child: GCWText(text: i18n(context, 'urwigo_textdeobfuscation_dtable')),
              flex: 1,
            ),
            Expanded(
                child: GCWTextField(
                  controller: _dtableController,
                  onChanged: (text) {
                    setState(() {
                      _currentDTable = text;
                    });
                  },
                ),
                flex: 3)
          ],
        ),
        _currentMode == GCWSwitchPosition.right
            ? Row(
                children: [
                  Expanded(
                    child: GCWText(text: i18n(context, 'urwigo_textdeobfuscation_text')),
                    flex: 1,
                  ),
                  Expanded(
                      child: GCWTextField(
                        controller: _inputController,
                        onChanged: (text) {
                          setState(() {
                            _currentInput = text;
                          });
                        },
                      ),
                      flex: 3)
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: GCWText(text: i18n(context, 'urwigo_textdeobfuscation_obfuscate_text')),
                    flex: 1,
                  ),
                  Expanded(
                      child: GCWTextField(
                        controller: _inputObfuscateController,
                        onChanged: (text) {
                          setState(() {
                            _currentObfuscateInput = text;
                          });
                        },
                      ),
                      flex: 3)
                ],
              ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.right) {
      return GCWDefaultOutput(child: deobfuscateUrwigoText(_currentInput, _currentDTable));
    } else {
      return GCWDefaultOutput(child: obfuscateUrwigoText(_currentObfuscateInput, _currentDTable));
    }
  }
}
