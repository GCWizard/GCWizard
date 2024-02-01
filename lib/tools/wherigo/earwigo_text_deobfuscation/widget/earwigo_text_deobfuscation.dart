import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/wherigo/logic/earwigo_tools.dart';

class EarwigoTextDeobfuscation extends StatefulWidget {
  const EarwigoTextDeobfuscation({Key? key}) : super(key: key);

  @override
  _EarwigoTextDeobfuscationState createState() => _EarwigoTextDeobfuscationState();
}

class _EarwigoTextDeobfuscationState extends State<EarwigoTextDeobfuscation> {
  late TextEditingController _inputController;
  late TextEditingController _inputObfuscateController;

  var _currentInput = '';
  var _currentObfuscateInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _inputObfuscateController = TextEditingController(text: _currentObfuscateInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputObfuscateController.dispose();
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
        _currentMode == GCWSwitchPosition.right
            ? Row(
                // de-obfuscate
                children: [
                  Expanded(
                    flex: 1,
                    child: GCWText(text: i18n(context, 'earwigo_textdeobfuscation_text')),
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
                // obfuscate
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
      return Column(children: <Widget>[
        GCWOutput(
            title: i18n(context, 'earwigo_textdeobfuscation_tool_gsub'),
            child: deobfuscateEarwigoText(_currentInput, EARWIGO_DEOBFUSCATION.GSUB_WIG)),
        GCWOutput(
            title: i18n(context, 'earwigo_textdeobfuscation_tool_wwb'),
            child: deobfuscateEarwigoText(_currentInput, EARWIGO_DEOBFUSCATION.WWB_DEOBF)),
      ]);
    } else {
      return Column(children: <Widget>[
        GCWOutput(
            title: i18n(context, 'earwigo_textdeobfuscation_tool_gsub'),
            child: obfuscateEarwigoText(_currentObfuscateInput, EARWIGO_DEOBFUSCATION.GSUB_WIG)),
        GCWOutput(
            title: i18n(context, 'earwigo_textdeobfuscation_tool_wwb'),
            child: obfuscateEarwigoText(_currentObfuscateInput, EARWIGO_DEOBFUSCATION.WWB_DEOBF)),
      ]);
    }
  }
}
