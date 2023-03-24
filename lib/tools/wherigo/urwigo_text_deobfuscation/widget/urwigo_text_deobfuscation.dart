import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/wherigo/logic/urwigo_tools.dart';

class UrwigoTextDeobfuscation extends StatefulWidget {
  const UrwigoTextDeobfuscation({Key? key}) : super(key: key);

  @override
  UrwigoTextDeobfuscationState createState() => UrwigoTextDeobfuscationState();
}

class UrwigoTextDeobfuscationState extends State<UrwigoTextDeobfuscation> {
  late TextEditingController _inputController;
  late TextEditingController _inputObfuscateController;
  late TextEditingController _dtableController;

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
              flex: 1,
              child: GCWText(text: i18n(context, 'urwigo_textdeobfuscation_dtable')),
            ),
            Expanded(
                flex: 3,
                child: GCWTextField(
                  controller: _dtableController,
                  onChanged: (text) {
                    setState(() {
                      _currentDTable = text;
                    });
                  },
                ))
          ],
        ),
        _currentMode == GCWSwitchPosition.right
            ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GCWText(text: i18n(context, 'urwigo_textdeobfuscation_text')),
                  ),
                  Expanded(
                      flex: 3,
                      child: GCWTextField(
                        controller: _inputController,
                        onChanged: (text) {
                          setState(() {
                            _currentInput = text;
                          });
                        },
                      ))
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GCWText(text: i18n(context, 'urwigo_textdeobfuscation_obfuscate_text')),
                  ),
                  Expanded(
                      flex: 3,
                      child: GCWTextField(
                        controller: _inputObfuscateController,
                        onChanged: (text) {
                          setState(() {
                            _currentObfuscateInput = text;
                          });
                        },
                      ))
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
