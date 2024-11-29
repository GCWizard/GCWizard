import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/major_system/logic/major_system.dart';

class MajorSystem extends StatefulWidget {
  const MajorSystem({super.key});

  @override
  _MajorSystemState createState() => _MajorSystemState();
}

class _MajorSystemState extends State<MajorSystem> {
  late TextEditingController _inputController;
  late GCWSwitchPosition _nounMode;

  String _currentInput = '';

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _nounMode = GCWSwitchPosition.left;
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
        
        GCWTextDivider(text: i18n(context, 'major_system_settings_capitalized_only')),
        
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
    return (_nounMode == GCWSwitchPosition.left)
        ? decryptMajorSystem(_currentInput, nounMode: false)
        : decryptMajorSystem(_currentInput, nounMode: true);
  }

  String _buildPlainTextOutput() {
    return (_nounMode == GCWSwitchPosition.left)
        ? preparedMajorText(_currentInput, nounMode: false)
        : preparedMajorText(_currentInput, nounMode: true);
  }
}
