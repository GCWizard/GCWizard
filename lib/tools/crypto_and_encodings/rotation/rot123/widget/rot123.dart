import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class Rot123 extends StatefulWidget {
  const Rot123({Key? key}) : super(key: key);

  @override
  _Rot123State createState() => _Rot123State();
}

class _Rot123State extends State<Rot123> {
  late TextEditingController _controller;

  String _currentInput = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    return Column(
      children: [
        GCWDefaultOutput(child: encryptVigenere(_currentInput, alphabet_AZ.keys.join(), false, aValue: 1)),
        GCWOutput(
            title: i18n(context, 'rotation_general_reverse'),
            child: decryptVigenere(_currentInput, alphabet_AZ.keys.join(), false, aValue: 1)),
      ],
    );
  }
}
