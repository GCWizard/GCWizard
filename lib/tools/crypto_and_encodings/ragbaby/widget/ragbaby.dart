import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/ragbaby/logic/ragbaby.dart';

class Ragbaby extends StatefulWidget {
  const Ragbaby({Key? key}) : super(key: key);

  @override
  _RagbabyState createState() => _RagbabyState();
}

class _RagbabyState extends State<Ragbaby> {
  late TextEditingController _inputController;
  late TextEditingController _passwordController;

  String _currentInput = '';
  String _currentPassword = '';
  RagbabyType _currentOption = RagbabyType.NoJX;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _passwordController = TextEditingController(text: _currentPassword);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          hintText: i18n(context, 'common_programming_hint_input'),
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextField(
          hintText: i18n(context, 'common_key'),
          controller: _passwordController,
          onChanged: (text) {
            setState(() {
              _currentPassword = text;
            });
          },
        ),
        GCWDropDown<RagbabyType>(
          value: _currentOption,
          items: RAGBABY_OPTIONS.entries.map((mode) {
            return GCWDropDownMenuItem(
                value: mode.key, child: i18n(context, mode.value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentOption = value;
            });
          }),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput(context),

      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput.isEmpty) {
      return const GCWDefaultOutput();
    }

    var output = '';

    if (_currentMode == GCWSwitchPosition.left) {
      output = encryptRagbaby(
        _currentInput,
        _currentPassword,
        type: _currentOption,
      );
    } else {
      output = decryptRagbaby(
        _currentInput,
        _currentPassword,
        type: _currentOption,
      );
    }

    return Column(
      children: [
        GCWDefaultOutput(child: output),
        GCWOutput(title: i18n(context, 'common_alphabet'),
          child:
          GCWOutputText(text: createSecretAlphabet(_currentPassword, type: _currentOption)),
        ),
      ]
    );
  }
}
