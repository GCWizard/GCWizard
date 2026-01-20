import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system.dart';

class MajorSystem extends StatefulWidget {
  const MajorSystem({super.key});

  @override
  _MajorSystemState createState() => _MajorSystemState();
}

class _MajorSystemState extends State<MajorSystem> {
  late TextEditingController _inputController;
  late MajorSystemLanguage _currentLanguage;
  late bool _nounMode;

  String _currentInput = '';

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _currentLanguage = MajorSystemLanguage.DE;
    _nounMode = false;
  }

  @override
  void dispose() {
    _inputController.dispose();
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
        GCWDropDown<MajorSystemLanguage>(
            title: i18n(context, 'common_language'),
            value: _currentLanguage,
            onChanged: (value) {
              setState(() {
                _currentLanguage = value;
                });
            },
            items: MajorSystemLanguage.values.map((language) {
              return GCWDropDownMenuItem(
                  value: language,
                  child: i18n(context, languageName(language)));
            }).toList(),
        ),
        GCWOnOffSwitch(
            title: i18n(context, 'major_system_settings_capitalized_only'),
            value: _nounMode,
            onChanged: (value) {
              setState(() {
                _nounMode = value;
              });
            }),
        GCWOutput(
            title: i18n(context, 'major_system_output_plaintext'),
            child: GCWOutputText(
                suppressCopyButton: true,
                text: _buildPlainTextOutput()),
        ),

        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    return MajorSystemLogic(
      text: _currentInput,
      nounMode: _nounMode,
      currentLanguage: _currentLanguage
    ).decrypt();
  }

  String _buildPlainTextOutput() {
    return MajorSystemLogic(
        text: _currentInput,
        nounMode: _nounMode,
        currentLanguage: _currentLanguage
    ).preparedText();
  }
}
