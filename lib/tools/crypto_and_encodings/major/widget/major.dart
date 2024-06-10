import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/major/logic/major.dart';

class Major extends StatefulWidget {
  const Major({super.key});

  @override
  _MajorState createState() => _MajorState();
}

class _MajorState extends State<Major> {
  late TextEditingController _inputController;

  String _currentInput = '';
  GCWSwitchPosition _nounMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
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
        
        GCWTextDivider(text: i18n(context, 'major_settings_capitalized_only')),
        
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_no'),
          rightValue: i18n(context, 'common_yes'),
          value: _nounMode,
          onChanged: (value) {
            setState(() {
              _nounMode = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'major_output_plaintext')),
        GCWText(text: MajorDecrypt(_currentInput).toString()),

        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    return (_nounMode == GCWSwitchPosition.left)
        ? MajorDecrypt(_currentInput).decodeToNumberString()
        : MajorDecrypt(_currentInput, nounMode: true).decodeToNumberString();
  }
}
